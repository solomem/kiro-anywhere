# Source → Kiro Concept Mappings (v2.8.1)

## Claude Code → Kiro

| Claude Code | Kiro Equivalent |
|---|---|
| `CLAUDE.md` (project rules) | `prompt` field + `.kiro/steering/*.md` |
| `CLAUDE.md` (commands section) | `hooks` or `allowedTools` |
| `.claude/settings.json` → `allowedTools` | `allowedTools` array |
| `.claude/settings.json` → `permissions.allow` | `toolsSettings.fs_write.allowedPaths` |
| `.claude/settings.json` → `permissions.deny` | `toolsSettings.fs_write.deniedPaths` |
| `.claude/settings.json` → `mcpServers` | `mcpServers` field (same format) |
| Memory files | `.kiro/steering/*.md` or `resources` |
| `/allowed-tools` patterns | `allowedTools` with wildcards |

## Cursor → Kiro

| Cursor | Kiro Equivalent |
|---|---|
| `.cursorrules` | `prompt` field (inline or file ref) |
| `.cursor/rules/*.md` (always) | `.kiro/steering/*.md` |
| `.cursor/rules/*.md` (glob-scoped) | `.kiro/steering/*.md` with `inclusion: fileMatch` |
| `.cursor/rules/*.md` (manual) | `.kiro/steering/*.md` with `inclusion: manual` |
| "Include files" in rules | `resources` with `file://` URIs |
| Composer Agent mode | Default Kiro agent (all tools) |
| Composer Normal mode | Agent with `tools: ["fs_read", "fs_write", "grep"]` |
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
| `.aider.conf.yml` → `auto-commits` | `postToolUse` hook on `fs_write` for auto-commit |
| `.aider.conf.yml` → `lint-cmd` | `stop` hook running linter |
| `.aider.conf.yml` → `test-cmd` | `stop` hook running tests |
| `.aiderignore` | `toolsSettings.fs_write.deniedPaths` |
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
| Allowed commands list | `toolsSettings.execute_bash.allowedCommands` |
| Auto-approve patterns | `allowedTools` |
| MCP servers | `mcpServers` field |
| Memory bank | `.kiro/steering/*.md` or `resources` |

## GitHub Copilot → Kiro

| Copilot | Kiro Equivalent |
|---|---|
| `.github/copilot-instructions.md` | `prompt` field + `.kiro/steering/*.md` |
| Workspace settings | Agent config |
| `@workspace` context | `resources` with glob patterns |
| Custom agents (chat participants) | Custom agents in `.kiro/agents/` |

## Common Patterns

### "Always include these files in context"
```json
{"resources": ["file://README.md", "file://src/types.ts", "file://docs/**/*.md"]}
```

### "Never edit these paths"
```json
{"toolsSettings": {"fs_write": {"deniedPaths": ["node_modules/**", "dist/**", ".git/**"]}}}
```

### "Only allow these shell commands"
```json
{"toolsSettings": {"execute_bash": {"allowedCommands": ["npm test", "npm run build", "git status"]}}}
```

### "Run linter after every file write"
```json
{"hooks": {"postToolUse": [{"matcher": "fs_write", "command": "npm run lint -- --fix", "description": "Auto-lint"}]}}
```

### "Run tests when done"
```json
{"hooks": {"stop": [{"command": "npm test", "description": "Run tests after changes"}]}}
```

### "Show git status on start"
```json
{"hooks": {"agentSpawn": [{"command": "git status --short", "description": "Git status"}]}}
```

### "Block writes to production config"
```json
{"hooks": {"preToolUse": [{"matcher": "fs_write", "command": "check-not-prod.sh", "description": "Block prod writes"}]}}
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
