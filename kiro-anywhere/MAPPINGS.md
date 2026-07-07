# Source → Kiro Concept Mappings

## Claude Code → Kiro

| Claude Code | Kiro Equivalent |
|---|---|
| `CLAUDE.md` (project rules) | `prompt` field + `.kiro/steering/*.md` |
| `CLAUDE.md` (commands section) | `hooks` or `allowedTools` |
| `.claude/settings.json` → `allowedTools` | `allowedTools` array |
| `.claude/settings.json` → `permissions.allow` | `toolsSettings.write.allowedPaths` |
| `.claude/settings.json` → `permissions.deny` | `toolsSettings.write.deniedPaths` |
| `.claude/settings.json` → `mcpServers` | `mcpServers` field (same format) |
| Memory files | `.kiro/steering/*.md` or `resources` |
| `/allowed-tools` patterns | `allowedTools` with wildcards |

## Cursor → Kiro

| Cursor | Kiro Equivalent |
|---|---|
| `.cursorrules` | `prompt` field (inline or file ref) |
| `.cursor/rules/*.md` (always) | `.kiro/steering/*.md` |
| `.cursor/rules/*.md` (glob-scoped) | `.kiro/steering/*.md` (no conditional loading — all steering is always loaded) |
| `.cursor/rules/*.md` (manual) | `.kiro/skills/*/SKILL.md` (loaded on demand via frontmatter match) |
| "Include files" in rules | `resources` with `file://` URIs |
| Composer Agent mode | Default Kiro agent (all tools) |
| Composer Normal mode | Agent with `tools: ["read", "write", "grep"]` |
| Docs references | `resources` or `knowledge` base |
| MCP servers | `mcpServers` field |

## Windsurf → Kiro

| Windsurf | Kiro Equivalent |
|---|---|
| `.windsurfrules` | `prompt` field |
| `.windsurf/rules/*.md` | `.kiro/steering/*.md` |
| Cascade memory | `.kiro/steering/*.md` |
| Tool permissions | `allowedTools` + `toolsSettings` |
| MCP servers | `mcpServers` field |

## Aider → Kiro

| Aider | Kiro Equivalent |
|---|---|
| `.aider.conf.yml` → `read` files | `resources` with `file://` |
| `.aider.conf.yml` → `auto-commits` | `postToolUse` hook with matcher `write` for auto-commit |
| `.aider.conf.yml` → `lint-cmd` | `stop` hook running linter |
| `.aider.conf.yml` → `test-cmd` | `stop` hook running tests |
| `.aiderignore` | `toolsSettings.write.deniedPaths` |
| `--model` flag | `model` field |
| Convention files | `.kiro/steering/*.md` |

## Continue → Kiro

| Continue | Kiro Equivalent |
|---|---|
| `config.json` → `models` | `model` field |
| `config.json` → `customCommands` | `.kiro/skills/*/SKILL.md` |
| `config.json` → `slashCommands` | `.kiro/skills/*/SKILL.md` |
| `config.json` → `contextProviders` | `hooks.agentSpawn` or `resources` |
| `.continuerc.json` → `rules` | `prompt` + `.kiro/steering/*.md` |
| Docs context | `resources` or `knowledge` base |
| Tab autocomplete model | Not applicable (Kiro uses `kiro-cli inline`) |

## Cline → Kiro

| Cline | Kiro Equivalent |
|---|---|
| `.clinerules` | `prompt` field |
| `.cline/rules/*.md` | `.kiro/steering/*.md` |
| Custom instructions (VS Code setting) | `prompt` field |
| Allowed commands list | `toolsSettings.shell.allowedCommands` |
| Auto-approve patterns | `allowedTools` |
| MCP servers | `mcpServers` field |
| Memory bank | `.kiro/steering/*.md` or `resources` |

## GitHub Copilot → Kiro

| Copilot | Kiro Equivalent |
|---|---|
| `.github/copilot-instructions.md` | `prompt` field + `.kiro/steering/*.md` |
| `.github/instructions/**/*.instructions.md` | `.kiro/steering/*.md`; preserve `applyTo` as text because Kiro steering is always loaded |
| `AGENTS.md` | `prompt` field + `.kiro/steering/*.md` |
| Root-level `CLAUDE.md` / `GEMINI.md` | `prompt` field + `.kiro/steering/*.md` |
| `$HOME/.copilot/copilot-instructions.md` | Global `.kiro/steering/*.md` or agent prompt when explicitly importing user-local preferences |
| `.github/agents/*.agent.md` | Custom agents in `.kiro/agents/` |
| `~/.copilot/agents/*.agent.md` | Global custom agents in `~/.kiro/agents/` |
| Agent profile frontmatter `name` / `description` | Agent config `name` / `description` |
| Agent profile frontmatter `tools` | Agent config `tools` |
| Agent profile frontmatter `model` | Agent config `model` |
| Agent profile frontmatter `mcp-servers` | Agent config `mcpServers` |
| Agent profile Markdown body | Agent config `prompt` field or prompt file |
| `@file` prompt context | `resources` with `file://` URIs when the referenced files should be persistent context |

## Common Patterns

### "Always include these files in context"
```json
{"resources": ["file://README.md", "file://src/types.ts", "file://docs/**/*.md"]}
```

### "Never edit these paths"
```json
{"toolsSettings": {"write": {"deniedPaths": ["node_modules/**", "dist/**", ".git/**"]}}}
```

### "Only allow these shell commands"
```json
{"toolsSettings": {"shell": {"allowedCommands": ["npm test", "npm run build", "git status"]}}}
```

### "Run linter after every file write"
```json
{"hooks": {"postToolUse": [{"matcher": "write", "command": "npm run lint -- --fix"}]}}
```

### "Run tests when done"
```json
{"hooks": {"stop": [{"command": "npm test"}]}}
```

### "Show git status on start"
```json
{"hooks": {"agentSpawn": [{"command": "git status --short"}]}}
```

### "Block writes to production config"
```json
{"hooks": {"preToolUse": [{"matcher": "write", "command": "check-not-prod.sh"}]}}
```

### "Coding standards always in context"
Create `.kiro/steering/coding-standards.md` — auto-loaded by default agent.

### "Reusable workflow"
Create `.kiro/skills/deploy/SKILL.md`:
```markdown
---
name: deploy
description: Deploy to production. Use when asked to deploy or ship.
---
1. Run tests
2. Build
3. Deploy
```

## Codex CLI Plugin → Kiro

| Codex CLI | Kiro Equivalent |
|---|---|
| `.codex-plugin/plugin.json` → `name` | Agent filename (`<name>.json`) |
| `.codex-plugin/plugin.json` → `description` | `description` field |
| `.codex-plugin/plugin.json` → `interface.shortDescription` | `description` field (preferred over top-level) |
| `.codex-plugin/plugin.json` → `interface.displayName` | Agent `name` field |
| `.codex-plugin/plugin.json` → `interface.longDescription` | `.kiro/prompts/<name>.md` (referenced via `prompt` field) |
| `.codex-plugin/plugin.json` → `interface.defaultPrompt[]` | `welcomeMessage` (first entry) or skill descriptions |
| `.codex-plugin/plugin.json` → `interface.capabilities` | `tools` array (`"Read"` → `["read", "grep", "glob"]`, `"Write"` → adds `"write", "shell"`) |
| `.codex-plugin/plugin.json` → `skills` path | `.kiro/skills/` (copy skill markdown files) |
| `.codex-plugin/plugin.json` → `mcpServers` path | Load referenced `.mcp.json` → inline in `mcpServers` field |
| `.codex-plugin/plugin.json` → `keywords` | Not mapped (no Kiro equivalent) |
| `.codex-plugin/plugin.json` → `interface.brandColor` | Not mapped |

## Claude Plugin → Kiro

| Claude Plugin | Kiro Equivalent |
|---|---|
| `.claude-plugin/plugin.json` → `name` | Agent filename (`<name>.json`) |
| `.claude-plugin/plugin.json` → `description` | `description` field |
| `.claude-plugin/plugin.json` → `keywords` | Not mapped |
| `.claude-plugin/plugin.json` → `version` | Not mapped (Kiro agents are unversioned) |
| `hooks/hooks.json` → `PreToolUse` | `hooks.preToolUse` (translate format — see below) |
| `hooks/hooks.json` → `PostToolUse` | `hooks.postToolUse` |
| `skills/` directory | `.kiro/skills/` (copy SKILL.md files as-is) |
| `.mcp.json` → `mcpServers` | `mcpServers` field (inline, resolve env vars) |

### Claude Plugin Hooks Translation

Claude format:
```json
{"hooks": {"PreToolUse": [{"matcher": "Bash|use_aws", "hooks": [{"type": "command", "command": "script.py", "timeout": 5}]}]}}
```

Kiro equivalent:
```json
{"hooks": {"preToolUse": [{"matcher": "shell", "command": "python3 script.py", "timeout_ms": 5000}, {"matcher": "use_aws", "command": "python3 script.py", "timeout_ms": 5000}]}}
```

Key differences:
- `PreToolUse` (Pascal) → `preToolUse` (camel)
- `matcher` is regex in Claude → glob/exact in Kiro (split `|` alternatives into separate entries)
- `Bash` matcher → `shell`
- Nested `hooks[]` array → flat (one hook object per entry)
- `timeout` in seconds → `timeout_ms` in milliseconds
- `$CLAUDE_PLUGIN_ROOT` env var → use path relative to agent file

### Claude Plugin Hook Script Translation

Hook scripts MUST be rewritten for Kiro's protocol:

| Claude convention | Kiro convention |
|---|---|
| Output JSON `{"permissionDecision": "deny"}` + exit 0 | Print to STDERR + exit 2 |
| Check `tool_name == "Bash"` | Check `tool_name == "shell"` |
| Check `tool_name.startswith("mcp__")` | Check `tool_name == "@server/tool"` or `tool_name == "use_aws"` |
| `timeout: 5` (seconds) | `timeout_ms: 5000` (milliseconds) |

If the source script is non-trivial, copy it to `.kiro/hooks/` and rewrite the exit logic:
```python
# WRONG (Claude style):
json.dump({"hookSpecificOutput": {"permissionDecision": "deny", ...}}, sys.stdout)
sys.exit(0)

# CORRECT (Kiro style):
print("Reason for blocking", file=sys.stderr)
sys.exit(2)
```

## Cursor Plugin → Kiro

| Cursor Plugin | Kiro Equivalent |
|---|---|
| `.cursor-plugin/plugin.json` → `name` | Agent filename |
| `.cursor-plugin/plugin.json` → `displayName` | Agent `name` field |
| `.cursor-plugin/plugin.json` → `description` | `description` field |
| `.cursor-plugin/plugin.json` → `category` | Not mapped |
| `.cursor-plugin/plugin.json` → `skills` path | `.kiro/skills/` |
| `.cursor-plugin/plugin.json` → `mcpServers` path | Load referenced file → inline in `mcpServers` field |

## Agent Toolkit → Kiro

The Agent Toolkit pattern (`.agents/plugins/marketplace.json`) is a **multi-plugin registry**. Each plugin becomes a separate Kiro agent.

| Agent Toolkit | Kiro Equivalent |
|---|---|
| `.agents/plugins/marketplace.json` → `plugins[].name` | One `.kiro/agents/<name>.json` per plugin |
| `.agents/plugins/marketplace.json` → `plugins[].source.path` | Base path for that plugin's skills, hooks, MCP |
| `plugins/<name>/skills/` | Copy all to `.kiro/skills/` (flatten — no per-plugin subdirs) |
| `plugins/<name>/hooks/hooks.json` | Translate to Kiro hooks in each agent's config |
| `plugins/<name>/hooks/*.py` | Copy to `.kiro/hooks/`, rewrite for Kiro protocol |
| `plugins/<name>/.mcp.json` | Inline into each agent's `mcpServers` |
| `plugins/<name>/commands/` | Convert to `.kiro/skills/` (same as Plugin Commands) |
| `rules/*.md` | → `.kiro/steering/*.md` |

### Conversion strategy for multi-plugin repos:

1. **One agent per plugin** — each plugin in the marketplace becomes its own `.kiro/agents/<name>.json`
2. **Shared steering** — global rules (`rules/`) become a single `.kiro/steering/` file referenced by all agents
3. **Skills are flat** — all skills from all plugins go into `.kiro/skills/<name>/SKILL.md` (no nesting). Skills are matched by `name:` frontmatter, not directory path.
4. **Hooks shared** — if multiple plugins use the same hook script, copy it once to `.kiro/hooks/` and reference from each agent
5. **MCP per agent** — each agent inlines only the MCP servers it needs (don't give every agent every MCP server)
6. **Prompt per agent** — generate `.kiro/agents/prompts/<name>.md` for each agent with its specific instructions

### Example:

Source `marketplace.json` with 3 plugins → generates:
```
.kiro/
├── agents/
│   ├── aws-core.json
│   ├── aws-agents.json
│   ├── aws-data-analytics.json
│   └── prompts/
│       ├── aws-core.md
│       ├── aws-agents.md
│       └── aws-data-analytics.md
├── steering/
│   └── aws-agent-rules.md          ← shared by all agents
├── skills/
│   ├── aws-cdk/SKILL.md            ← from plugins/aws-core/skills/
│   ├── agents-build/SKILL.md       ← from plugins/aws-agents/skills/
│   └── ...                          ← flattened from all plugins
└── hooks/
    └── secret-safety.py             ← shared hook, rewritten for Kiro
```

## Plugin Commands → Kiro Skills

Plugin `commands/` directories contain markdown files with frontmatter:

```markdown
---
description: Start a deep root-cause investigation
argument-hint: [incident description]
---
Workflow instructions here...
```

Kiro equivalent — `.kiro/skills/<name>/SKILL.md`:

```markdown
---
name: investigate
description: Start a deep root-cause investigation. Use when asked to investigate an incident.
---
Workflow instructions here...
```

Key differences:
- Add `name` field (derived from filename)
- `argument-hint` → incorporate into `description` text
- File location: `commands/<name>.md` → `.kiro/skills/<name>/SKILL.md`

## Standalone .mcp.json → Kiro

`.mcp.json` files map directly to the `mcpServers` field in agent config:

```json
{"mcpServers": {"aws-mcp": {"command": "uvx", "args": ["mcp-proxy@1.6.3", "https://..."]}}}
```

For HTTP-based MCP servers, drop the `"type"` field (Kiro infers from `url` presence):
```json
{"mcpServers": {"aws-devops-agent": {"url": "https://...", "headers": {"Authorization": "Bearer $TOKEN"}, "timeout": 120000}}}
```

**IMPORTANT: MCP server placement rule.** If a steering file or prompt mentions an MCP server (e.g., "use the AWS MCP Server"), that server MUST be configured in the agent's `mcpServers` field. Do NOT assume it will come from global settings or `useLegacyMcpJson`. Each agent should be self-contained.

## Prompt Content Rewriting

When converting prompt/instruction files, rewrite internal path references to match the `.kiro/` layout:

| Source path | Rewrite to |
|---|---|
| `plugins/<name>/skills/` | `.kiro/skills/` |
| `plugins/<name>/hooks/` | `.kiro/hooks/` |
| `rules/` | `.kiro/steering/` |
| `commands/` | `.kiro/skills/` |
| `skills/core-skills/` | `.kiro/skills/` |
| `skills/specialized-skills/` | `.kiro/skills/` |

Skills in Kiro are flat under `.kiro/skills/<name>/SKILL.md` — there are no subdirectory groupings like `core-skills/` or `specialized-skills/`. All skills are found by name via `skill://` URI regardless of where they sit.

## Concepts Without Direct Kiro Equivalent

| Source Concept | Workaround |
|---|---|
| Inline code completions config | Use `kiro-cli inline` (separate feature) |
| Tab autocomplete model selection | Not configurable per-agent |
| GUI-only features (hover, inline diff) | TUI has built-in diff viewer |
| Multi-file edit preview | Kiro shows diffs in approval UX |
| Conversation export format | `/chat save` exports JSON |
| Per-file model routing | Not supported — single model per agent |
| Embeddings/RAG config | `knowledge` settings (global, not per-agent) |
| Conditional steering (load rules only for certain files) | Not supported — steering files are always loaded. Use skills for on-demand content. |
