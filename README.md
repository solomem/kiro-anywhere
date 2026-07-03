# kiro-anywhere

> **Migrate your existing AI coding assistants to Kiro in seconds.**

Convert Claude Code, Cursor, Windsurf, Continue, Copilot, Cline, and Aider configurations into production-ready Kiro CLI agents — with skills, hooks, steering, and MCP servers preserved.

---

## The problem

You've spent hours crafting the perfect AI coding assistant setup — custom rules, allowed commands, context files, MCP integrations. Now you want to try Kiro.

Starting from scratch? No thanks.

**kiro-anywhere** reads your existing config and generates a complete Kiro agent in seconds.

---

## The transformation

```
.cursorrules                          .kiro/
.cursor/rules/        ──────────►     ├── agents/my-project.json
CLAUDE.md                             ├── steering/conventions.md
.aider.conf.yml       kiro-anywhere   ├── skills/deploy/SKILL.md
.github/copilot-                      └── prompts/system.md
  instructions.md
```

Your rules become **steering files**. Your workflows become **skills**. Your pre-commit checks become **hooks**. Nothing is lost.

---

## Why migrate to Kiro?

- **Unified agent format** — one config to rule them all
- **Skills** — reusable, on-demand workflows with frontmatter triggers
- **Hooks** — run commands at every lifecycle point (spawn, pre-tool, post-tool, stop)
- **Steering** — always-on conventions loaded into every session
- **MCP servers** — first-class support for external tool integrations
- **Shareable** — commit `.kiro/` and your whole team gets the same agent

---

## Quick start

```bash
# Install the agent globally
git clone https://github.com/user/kiro-anywhere.git
cd kiro-anywhere
./install.sh

# Convert any project
cd ~/my-project
kiro-cli chat --agent kiro-harness
```

Then say:

```
Convert the cursor rules in this project to Kiro format
```

Done.

### One-shot mode (CI / automation)

```bash
./convert.sh ~/my-project
```

Or directly:

```bash
cd ~/my-project
kiro-cli chat --agent kiro-harness --trust-all-tools --no-interactive \
  "Convert all agent configs in this project to Kiro format"
```

---

## Supported sources

| Tool | Config files | Status |
|------|-------------|--------|
| Claude Code | `CLAUDE.md`, `.claude/settings.json` | ✅ Full |
| Cursor | `.cursorrules`, `.cursor/rules/*.md` | ✅ Full |
| Windsurf | `.windsurfrules`, `.windsurf/rules/*.md` | ✅ Full |
| Aider | `.aider.conf.yml`, `.aiderignore` | ✅ Full |
| Continue | `.continuerc.json`, `config.json` | ✅ Full |
| Cline | `.clinerules`, `.cline/rules/*.md` | ✅ Full |
| GitHub Copilot | `.github/copilot-instructions.md` | ✅ Full |
| Custom | Any structured agent definition | ✅ Partial |

---

## Example conversion

**Input** — `.cursorrules`:
```
You are a senior TypeScript developer.
Always use strict mode. Prefer functional patterns.
Run prettier on save. Never edit dist/ or node_modules/.
```

**Output** — `.kiro/agents/my-project.json`:
```json
{
  "name": "my-project",
  "description": "Senior TypeScript developer with strict mode and functional patterns",
  "prompt": "file://../../.kiro/prompts/my-project.md",
  "tools": ["read", "write", "shell", "grep", "glob", "code"],
  "allowedTools": ["read", "grep", "glob", "code"],
  "toolsSettings": {
    "write": {
      "deniedPaths": ["dist/**", "node_modules/**"]
    }
  },
  "hooks": {
    "postToolUse": [
      {"matcher": "write", "command": "npx prettier --write ."}
    ]
  }
}
```

Plus `.kiro/steering/conventions.md` with the coding rules extracted.

---

## Concept mapping

This isn't just a file converter — it understands what your config *means*:

| Source concept | Kiro equivalent |
|----------------|-----------------|
| System prompt / rules | `prompt` field or `.kiro/steering/*.md` |
| Allowed tools / commands | `allowedTools` + `toolsSettings` |
| File context (always include) | `resources` with `file://` URIs |
| MCP servers | `mcpServers` field |
| Pre-commit checks | `preToolUse` hook |
| Auto-format on save | `postToolUse` hook |
| Test/lint runners | `stop` hook |
| Reusable workflows | `.kiro/skills/` |

Full mapping reference: [MAPPINGS.md](kiro-harness/MAPPINGS.md)

---

## Architecture

```
┌─────────────────────────────────┐
│  Source Configs                  │
│  (Cursor, Claude, Windsurf...)  │
└───────────────┬─────────────────┘
                │
                ▼
┌─────────────────────────────────┐
│  kiro-anywhere agent            │
│  ┌───────────┐  ┌───────────┐  │
│  │  Parser   │→ │ Normalizer│  │
│  └───────────┘  └─────┬─────┘  │
│                        │        │
│                        ▼        │
│               ┌───────────┐     │
│               │ Generator │     │
│               └─────┬─────┘     │
└─────────────────────┼───────────┘
                      │
                      ▼
┌─────────────────────────────────┐
│  .kiro/                          │
│  ├── agents/<name>.json          │
│  ├── steering/<name>.md          │
│  ├── skills/<name>/SKILL.md      │
│  └── prompts/<name>.md           │
└─────────────────────────────────┘
```

---

## Known limitations

Some source features don't have a direct Kiro equivalent:

| Feature | Status |
|---------|--------|
| Inline code completions config | Not applicable |
| Tab autocomplete model selection | Not configurable per-agent |
| Per-file model routing | Single model per agent |
| Conditional rule loading (glob-scoped) | Steering is always-on; use skills for on-demand |
| Embeddings/RAG config | Global only in Kiro |

The agent notes these during conversion and suggests workarounds.

---

## How it works

The agent is powered by three reference files:

- **[prompt.md](kiro-harness/prompt.md)** — Conversion workflow + validation checklist
- **[REFERENCE.md](kiro-harness/REFERENCE.md)** — Kiro CLI agent config schema
- **[MAPPINGS.md](kiro-harness/MAPPINGS.md)** — Source → Kiro concept mappings

Safety constraints:
- Reads any file in the project (to parse source configs)
- Writes only to `.kiro/**`
- Shell commands restricted to read-only (`cat`, `ls`, `find`, `head`, `tail`, `jq`)
- Cannot overwrite its own config

---

## Prerequisites

- [Kiro CLI](https://kiro.dev) installed and authenticated (`kiro-cli login`)

---

## Installation

```bash
git clone https://github.com/user/kiro-anywhere.git
cd kiro-anywhere
./install.sh
```

Verify:

```bash
kiro-cli agent list
# Should show: kiro-harness
```

## Uninstalling

```bash
rm ~/.kiro/agents/kiro-harness.json
rm -rf ~/.kiro/agents/kiro-harness/
```

---

## Contributing

1. Edit files in `kiro-harness/`
2. Run `./install.sh` to reinstall
3. Test with a sample source config

PRs welcome — especially for new source format support.

---

## License

MIT
