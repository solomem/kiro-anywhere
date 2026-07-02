# kiro-anywhere

```text
 __    _                                            __
/ /__ (_)______  ____     ____ _____  __  ______  / /_  ___  ________
/ //_/ / ___/ _ \/ __ \   / __ `/ __ \/ / / / __ \/ __ \/ _ \/ ___/ _ \
/ ,< / / /  /  __/ /_/ /  / /_/ / / / / /_/ / /_/ / / / /  __/ /  /  __/
/_/|_/_/_/   \___/\____/   \__,_/_/ /_/\__, / .___/_/ /_/\___/_/   \___/
                                      /____/_/

        many agent configs  --->  Kiro anywhere
```

Convert common AI coding-agent configurations into Kiro CLI-compatible agents — supports Claude Code, Cursor, Windsurf, Aider, Continue, Cline, GitHub Copilot, and structured custom formats.

## What it does

`kiro-anywhere` is a Kiro CLI agent that reads recognized source agent configs from other tools and generates valid `.kiro/agents/<name>.json` files plus any supporting artifacts (steering files, skills, hooks).

## Use cases

- Convert Claude Code project instructions to Kiro CLI agents
- Convert Cursor rules (`.cursorrules`, `.cursor/rules/*.md`) to Kiro agent configuration
- Convert GitHub Copilot custom instructions and agent profiles to Kiro-compatible prompts and agents
- Migrate Cline, Windsurf, Aider, and Continue configuration into `.kiro/agents/`
- Preserve common AI agent concepts such as prompts, tools, permissions, resources, hooks, skills, and MCP server configuration

## Supported source formats

| Tool | Config files |
|------|-------------|
| Claude Code | `CLAUDE.md`, `.claude/settings.json` |
| Cursor | `.cursorrules`, `.cursor/rules/*.md` |
| Windsurf | `.windsurfrules`, `.windsurf/rules/*.md` |
| Aider | `.aider.conf.yml`, `.aiderignore` |
| Continue | `.continuerc.json`, `config.json` |
| Cline | `.clinerules`, `.cline/rules/*.md` |
| GitHub Copilot | `.github/copilot-instructions.md`, `.github/instructions/**/*.instructions.md`, `AGENTS.md`, `.github/agents/*.agent.md` |
| Custom | Structured agent definitions with identifiable prompts, tools, resources, hooks, skills, or MCP servers |

## Prerequisites

- [Kiro CLI](https://kiro.dev) installed and authenticated (`kiro-cli login`)

## Installation

```bash
git clone <this-repo>
cd kiro-anywhere
chmod +x install.sh
./install.sh
```

This installs the `kiro-anywhere` agent to `~/.kiro/agents/` (available globally).

Verify it's installed:

```bash
kiro-cli agent list
```

You should see `kiro-anywhere` in the list.

## Usage

### Interactive mode

Navigate to any project with a source harness and start a chat:

```bash
cd ~/my-project  # has .cursorrules, CLAUDE.md, etc.
kiro-cli chat --agent kiro-anywhere
```

Then tell it what to convert:

```
Convert the cursor rules in this project to Kiro format
```

The agent reads the source config, maps concepts to Kiro equivalents, and writes output to `.kiro/` in your project.

### One-shot mode

For automation or CI:

```bash
cd ~/my-project
kiro-cli chat --agent kiro-anywhere --trust-all-tools --no-interactive \
  "Convert all agent configs in this project to Kiro format"
```

## What gets generated

Depending on the source config, the agent produces:

| Output | Location |
|--------|----------|
| Agent config | `.kiro/agents/<name>.json` |
| Steering files (coding rules, conventions) | `.kiro/steering/<name>.md` |
| Skills (reusable workflows) | `.kiro/skills/<name>/SKILL.md` |
| Prompt files (complex system prompts) | `.kiro/prompts/<name>.md` |

## Concept mapping

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

For the full mapping reference, see [MAPPINGS.md](kiro-anywhere/MAPPINGS.md).

## Limitations

Some source features have no direct Kiro equivalent:

- Inline code completions config
- Tab autocomplete model selection
- Per-file model routing
- Conditional rule loading (glob-scoped rules)
- Embeddings/RAG configuration (global only in Kiro)

The agent will note these and suggest workarounds where possible.

## How it works

The agent uses three reference files:

- **[prompt.md](kiro-anywhere/prompt.md)** — System prompt with conversion workflow and validation checklist
- **[REFERENCE.md](kiro-anywhere/REFERENCE.md)** — Kiro CLI agent configuration quick reference
- **[MAPPINGS.md](kiro-anywhere/MAPPINGS.md)** — Source-to-Kiro concept mapping tables

The agent is configured to:
- Read any file in the project (to parse source configs)
- Write only to `.kiro/**` (to generate output)
- Not run arbitrary shell commands (read-only commands only)
- Not overwrite its own config

## Uninstalling

Remove the agent files:

```bash
rm ~/.kiro/agents/kiro-anywhere.json
rm -rf ~/.kiro/agents/kiro-anywhere/
```

## Contributing

To update the reference material or add support for new source formats:

1. Edit files in `kiro-anywhere/`
2. Run `./install.sh` to reinstall
3. Test with a sample source config

## License

MIT
