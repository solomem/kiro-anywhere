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
