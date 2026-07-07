# Kiro CLI Agent Configuration — Quick Reference (v2.8.1)

## Agent JSON Schema

```json
{
  "name": "string",
  "description": "string",
  "prompt": "string | file:///path/to/prompt.txt",
  "tools": ["tool-name", "@builtin", "@mcp-server"],
  "allowedTools": ["tool-name", "fs_*", "@server/tool_*"],
  "toolsSettings": {
    "fs_write": {
      "allowedPaths": ["glob/**"],
      "deniedPaths": ["glob/**"]
    },
    "execute_bash": {
      "allowedCommands": ["cmd1", "cmd2"],
      "autoAllowReadonly": true
    },
    "use_aws": {
      "allowedServices": ["s3", "lambda"],
      "autoAllowReadonly": true
    },
    "web_fetch": {
      "trusted": ["regex-pattern"],
      "blocked": ["regex-pattern"]
    }
  },
  "resources": [
    "file://path/or/glob",
    "skill://.kiro/skills/**/SKILL.md"
  ],
  "hooks": {
    "agentSpawn": [{"command": "cmd", "description": "desc"}],
    "userPromptSubmit": [{"command": "cmd", "description": "desc"}],
    "preToolUse": [{"matcher": "tool-pattern", "command": "cmd", "description": "desc"}],
    "postToolUse": [{"matcher": "tool-pattern", "command": "cmd", "description": "desc"}],
    "stop": [{"command": "cmd", "description": "desc"}]
  },
  "mcpServers": {
    "server-name": {
      "command": "binary",
      "args": ["--stdio"],
      "env": {"KEY": "value"},
      "timeout": 120000,
      "disabled": false
    },
    "remote-server": {
      "url": "https://example.com/mcp",
      "oauth": {"clientId": "id"},
      "oauthScopes": ["scope1"]
    }
  },
  "toolAliases": {"@server/long_name": "short"},
  "useLegacyMcpJson": false,
  "model": "model-id",
  "keyboardShortcut": "ctrl+shift+x",
  "welcomeMessage": "Greeting text"
}
```

## File Locations

| Scope | Path |
|---|---|
| Workspace agents | `.kiro/agents/<name>.json` |
| Global agents | `~/.kiro/agents/<name>.json` |
| Workspace steering | `.kiro/steering/*.md` |
| Global steering | `~/.kiro/steering/*.md` |
| Workspace skills | `.kiro/skills/<name>/SKILL.md` |
| Global skills | `~/.kiro/skills/<name>/SKILL.md` |
| Workspace prompts | `.kiro/prompts/<name>.md` |
| Global prompts | `~/.kiro/prompts/<name>.md` |
| MCP config | `.kiro/settings/mcp.json` or `~/.kiro/settings/mcp.json` |

## Path Resolution

- `file://` in `prompt` and `resources` resolves **relative to the agent JSON file's directory**
  - For workspace agents (`.kiro/agents/myagent.json`), the base is `.kiro/agents/`
  - For global agents (`~/.kiro/agents/myagent.json`), the base is `~/.kiro/agents/`
- `file:///` (triple slash) is an **absolute path** — resolves from filesystem root
- The default built-in agent resolves relative paths from the **workspace root** (cwd)

### Examples

| Agent location | Resource value | Resolves to |
|---|---|---|
| `.kiro/agents/my.json` | `file://helpers/ref.md` | `.kiro/agents/helpers/ref.md` |
| `.kiro/agents/my.json` | `file://../../.kiro/steering/rules.md` | `.kiro/steering/rules.md` |
| `.kiro/agents/my.json` | `file://../../.kiro/prompts/system.md` | `.kiro/prompts/system.md` |
| `.kiro/agents/my.json` | `file://../../src/**/*.ts` | `src/**/*.ts` |
| `.kiro/agents/my.json` | `file:///home/user/ref.md` | `/home/user/ref.md` |
| (default agent) | `file://src/**/*.rs` | `<cwd>/src/**/*.rs` |
| (default agent) | `file://.kiro/steering/**/*.md` | `<cwd>/.kiro/steering/**/*.md` |

> **CRITICAL:** For workspace agents at `.kiro/agents/<name>.json`, always use `../../` to reach workspace root. `file://.kiro/steering/foo.md` would incorrectly resolve to `.kiro/agents/.kiro/steering/foo.md`.

### Skill References

| Reference style | Resolves to |
|---|---|
| `skill://aws-cdk` | Matches skill with `name: aws-cdk` in frontmatter (any `.kiro/skills/**/SKILL.md`) |
| `skill://.kiro/skills/**/SKILL.md` | Glob — loads all skills by path |

### Hook Commands

Hook `command` fields execute with `cwd` = workspace root. Use workspace-relative paths directly:
- ✅ `"command": "python3 .kiro/hooks/script.py"`
- ❌ `"command": "python3 ../../.kiro/hooks/script.py"` (wrong — hooks don't resolve from agent dir)

## Built-in Tools (Canonical Names)

| Tool (canonical) | Aliases | Description |
|---|---|---|
| `read` | `fs_read`, `fsRead` | Read files, directories, search patterns |
| `write` | `fs_write`, `fsWrite` | Create and edit files |
| `shell` | `execute_bash`, `execute_cmd` | Execute terminal commands |
| `grep` | | Text pattern search |
| `glob` | | Find files matching patterns |
| `use_aws` | `aws` | AWS CLI calls |
| `code` | | Symbol search, LSP operations |
| `knowledge` | | Knowledge base operations |
| `web_search` | | Search the web |
| `web_fetch` | | Fetch URL content |
| `task` | `todo_list`, `todo` | Task tracking |
| `subagent` | `use_subagent`, `agent_crew` | Delegate tasks |
| `introspect` | | Query Kiro docs |
| `session` | | Adjust session settings |

## Tool Groups

| Group | Meaning |
|---|---|
| `@builtin` | All built-in tools |
| `@server-name` | All tools from an MCP server |
| `@server-name/tool` | Specific MCP server tool |

## Hook Events

| Event | When | Can Block? | Extra Fields |
|---|---|---|---|
| `agentSpawn` | Agent initializes | No | — |
| `userPromptSubmit` | User sends message | No | `prompt` |
| `preToolUse` | Before tool runs | Yes (exit 2) | `tool_name`, `tool_input` |
| `postToolUse` | After tool runs | No | `tool_name`, `tool_input`, `tool_response` |
| `stop` | Agent finishes turn | No | `assistant_response` |

## Hook Exit Codes

| Code | Meaning |
|---|---|
| 0 | Success |
| 2 | Block (preToolUse only) — STDERR returned to LLM |
| Other | Warning — STDERR shown to user |

## Steering Files

Markdown files in `.kiro/steering/` auto-loaded by default agent. Custom agents must opt in:
```json
{"resources": ["file://.kiro/steering/**/*.md"]}
```

## Skills

Portable instruction packages in `.kiro/skills/<name>/SKILL.md`:
```markdown
---
name: skill-name
description: When to activate this skill
---
Instructions here...
```

Invoke via `/skill-name` or automatic matching.

## Permissions Model

1. `--trust-all-tools` — trust everything (CLI flag)
2. `--trust-tools=list` — trust specific tools (CLI flag)
3. `allowedTools` in agent config — permanent trust
4. `/tools trust <name>` — session trust
5. Default — requires user approval
