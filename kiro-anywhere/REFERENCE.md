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

**Two different resolution rules:**

- `prompt` field `file://` resolves **relative to the agent JSON file's directory**
  - For workspace agents (`.kiro/agents/myagent.json`), the base is `.kiro/agents/`
  - For global agents (`~/.kiro/agents/myagent.json`), the base is `~/.kiro/agents/`
- `resources` field `file://` and `skill://` resolve **relative to the workspace root** (cwd)
- `file:///` (triple slash) is always an **absolute path**

### Prompt Path Examples

| Agent location | `prompt` value | Resolves to |
|---|---|---|
| `.kiro/agents/my.json` | `file://prompts/system.md` | `.kiro/agents/prompts/system.md` |
| `.kiro/agents/my.json` | `file://../../.kiro/prompts/system.md` | `.kiro/prompts/system.md` |
| `.kiro/agents/my.json` | `file:///home/user/prompt.md` | `/home/user/prompt.md` |

### Resources Path Examples

| `resources` entry | Resolves to (from workspace root) |
|---|---|
| `file://README.md` | `<cwd>/README.md` |
| `file://.kiro/steering/rules.md` | `<cwd>/.kiro/steering/rules.md` |
| `file://.kiro/steering/**/*.md` | All .md files under `<cwd>/.kiro/steering/` |
| `skill://.kiro/skills/aws-cdk/SKILL.md` | `<cwd>/.kiro/skills/aws-cdk/SKILL.md` |
| `skill://.kiro/skills/**/SKILL.md` | All skills (glob) |
| `skill://aws-cdk` | Name-based lookup (matches `name: aws-cdk` in frontmatter) |

### Hook Command Paths

Hook `command` fields execute with cwd = workspace root:
- `"command": "python3 .kiro/hooks/script.py"` → `<cwd>/.kiro/hooks/script.py`

> **KEY DISTINCTION:** `prompt` uses agent-file-relative paths. `resources` uses workspace-relative paths. Do NOT mix them up.

## Built-in Tools (Canonical Names)

Each tool below is an **individual tool name** — use them as-is in `tools` and `allowedTools` arrays. There are NO category groupings (no `"web"` category — use `"web_search"` and `"web_fetch"` individually).

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

### Referencing Skills in Agent Resources

Two forms are valid:

| Format | Example | Behavior |
|---|---|---|
| Name-based | `skill://aws-cdk` | Matches skill where frontmatter `name: aws-cdk` |
| Path-based (glob) | `skill://.kiro/skills/**/SKILL.md` | Loads all skills matching glob |

**Name-based is preferred** for explicit skill lists. Kiro scans `.kiro/skills/` for SKILL.md files, reads their frontmatter, and matches by `name:` field.

**Do NOT use relative path traversal** with `skill://` (e.g., `skill://../skills/aws-cdk/SKILL.md` is not guaranteed to work). Use bare names: `skill://aws-cdk`.

### MCP Settings Auto-Loading

Workspace agents automatically get MCP servers from `.kiro/settings/mcp.json` — no `useLegacyMcpJson` or `includeMcpJson` field is needed. Only use `useLegacyMcpJson: true` if you need to load servers from the legacy `.amazonq/mcp.json` path.

## Permissions Model

1. `--trust-all-tools` — trust everything (CLI flag)
2. `--trust-tools=list` — trust specific tools (CLI flag)
3. `allowedTools` in agent config — permanent trust
4. `/tools trust <name>` — session trust
5. Default — requires user approval
