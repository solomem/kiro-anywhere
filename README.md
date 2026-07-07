# kiro-anywhere

> **The universal migration tool for Kiro CLI.**

Migrate your existing AI coding assistants to Kiro in seconds. Convert Claude Code, Cursor, Windsurf, Continue, Copilot, Cline, and Aider configurations into production-ready Kiro CLI agents — with skills, hooks, steering, and MCP servers preserved.

---

## Convert

```
✅ Cursor           ✅ Claude Code       ✅ Windsurf
✅ Continue         ✅ Cline             ✅ GitHub Copilot
✅ Aider            ✅ Codex CLI Plugin  ✅ Claude Plugin
✅ Cursor Plugin    ✅ Agent Toolkit     🔲 Roo Code
🔲 Gemini CLI       🔲 Amazon Q          🔲 Augment Code
```

## Generate

```
.kiro/
├── agents/<name>.json          ← agent config
├── steering/<name>.md          ← coding conventions (always-on)
├── skills/<name>/SKILL.md      ← reusable workflows (on-demand)
├── prompts/<name>.md           ← system prompts
└── hooks                       ← lifecycle commands
```

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
# Install
git clone https://github.com/solomem/kiro-anywhere.git
cd kiro-anywhere
./install.sh

# Convert any project
cd ~/my-project
kiro-cli chat --agent kiro-anywhere
```

Then say:

```
Convert the cursor rules in this project to Kiro format
```

### One-shot mode (CI / automation)

```bash
./convert.sh ~/my-project
```

Or directly:

```bash
kiro-cli chat --agent kiro-anywhere --trust-all-tools --no-interactive \
  "Convert all agent configs in this project to Kiro format"
```

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

## Compatibility benchmark

| Source Tool | Agents | Steering | Skills | Hooks | MCP | Status |
|-------------|:------:|:--------:|:------:|:-----:|:---:|--------|
| Cursor | ✅ | ✅ | ✅ | ✅ | ✅ | Full |
| Claude Code | ✅ | ✅ | ✅ | ✅ | ✅ | Full |
| Windsurf | ✅ | ✅ | ✅ | ✅ | ✅ | Full |
| Aider | ✅ | ✅ | — | ✅ | — | Full |
| Continue | ✅ | ✅ | ✅ | ✅ | — | Full |
| Cline | ✅ | ✅ | Partial | — | ✅ | Full |
| GitHub Copilot | ✅ | ✅ | — | — | — | Full |
| Codex CLI Plugin | ✅ | — | ✅ | ✅ | ✅ | Full |
| Claude Plugin | ✅ | — | ✅ | ✅ | ✅ | Full |
| Cursor Plugin | ✅ | — | ✅ | — | ✅ | Full |
| Agent Toolkit | ✅ | ✅ | ✅ | ✅ | ✅ | Full |
| Roo Code | 🔲 | 🔲 | 🔲 | 🔲 | 🔲 | Planned |
| Gemini CLI | 🔲 | 🔲 | 🔲 | 🔲 | 🔲 | Planned |
| Amazon Q | 🔲 | 🔲 | 🔲 | 🔲 | 🔲 | Planned |
| Augment Code | 🔲 | 🔲 | 🔲 | 🔲 | 🔲 | Planned |

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

Full mapping reference: [MAPPINGS.md](kiro-anywhere/MAPPINGS.md)

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

## Roadmap

### Done
- ✅ Cursor support (full)
- ✅ Claude Code support (full)
- ✅ Windsurf support (full)
- ✅ Continue support (full)
- ✅ Cline support (full)
- ✅ GitHub Copilot support (full)
- ✅ Aider support (full)
- ✅ Codex CLI Plugin support (full)
- ✅ Claude Plugin support (full)
- ✅ Cursor Plugin support (full)
- ✅ Agent Toolkit support (full — skills, hooks, MCP, commands)
- ✅ One-shot CLI mode
- ✅ Safety constraints (write-only to `.kiro/`, read-only shell)

### Next
- 🔲 Roo Code support
- 🔲 Gemini CLI support
- 🔲 Amazon Q Developer support
- 🔲 Augment Code support
- 🔲 Auto-detect source configs on agent spawn
- 🔲 Terminal recording / animated demo
- 🔲 Validation report (diff what was mapped vs. what couldn't be)

### Future
- 🔲 Interactive TUI mode
- 🔲 Web converter
- 🔲 Bidirectional sync (Kiro ↔ other formats)
- 🔲 Plugin SDK for custom source formats
- 🔲 npm / brew package for zero-clone install

---

## How it works

The agent is powered by three reference files:

- **[prompt.md](kiro-anywhere/prompt.md)** — Conversion workflow + validation checklist
- **[REFERENCE.md](kiro-anywhere/REFERENCE.md)** — Kiro CLI agent config schema
- **[MAPPINGS.md](kiro-anywhere/MAPPINGS.md)** — Source → Kiro concept mappings

Safety constraints:
- Reads any file in the project (to parse source configs)
- Writes only to `.kiro/**`
- Read-only shell commands auto-approved (`find`, `ls`, `cat`, `head`, `tail`, etc.)
- Write-capable shell commands require user approval
- Cannot overwrite its own config

---

## Known limitations

| Feature | Status |
|---------|--------|
| Inline code completions config | Not applicable |
| Tab autocomplete model selection | Not configurable per-agent |
| Per-file model routing | Single model per agent |
| Conditional rule loading (glob-scoped) | Steering is always-on; use skills for on-demand |
| Embeddings/RAG config | Global only in Kiro |

The agent notes these during conversion and suggests workarounds.

---

## Installation

### Prerequisites

- [Kiro CLI](https://kiro.dev) installed and authenticated (`kiro-cli login`)

### Install

```bash
git clone https://github.com/solomem/kiro-anywhere.git
cd kiro-anywhere
./install.sh
```

Verify:

```bash
kiro-cli agent list
# Should show: kiro-anywhere
```

### Uninstall

```bash
rm ~/.kiro/agents/kiro-anywhere.json
rm -rf ~/.kiro/agents/kiro-anywhere/
```

---

## Contributing

1. Edit files in `kiro-anywhere/`
2. Run `./install.sh` to reinstall
3. Test with a sample source config

PRs welcome — especially for new source format support.

---

## ⭐ Star this project if it saved you time.

---

## License

MIT
