# Changelog

## v0.2.0 — 2026-07-08

### Added
- Codex CLI Plugin support (`.codex-plugin/plugin.json`)
- Claude Plugin support (`.claude-plugin/plugin.json`, `hooks/hooks.json`)
- Cursor Plugin support (`.cursor-plugin/plugin.json`)
- Agent Toolkit support (`.agents/plugins/marketplace.json`, multi-plugin → multi-agent)
- Plugin `commands/` → Kiro skills conversion
- Hook script translation (Claude JSON output → Kiro exit code 2 + STDERR)
- Detection-first workflow — agent scans and reports before converting
- Task list enforcement — structured 7-step workflow
- WRONG/CORRECT anti-patterns table in prompt
- Path resolution rules (prompt vs resources resolve differently)
- Prompt vs steering distinction (never use steering as prompt)
- Stale reference rewriting guidance
- Conservative default `allowedTools` (read-only unless source explicitly permitted)
- Anti-web-search guardrails (agent trusts its own references only)

### Fixed
- `stop` hook incorrectly documented as blocking (it's not)
- Tool names table had canonical/alias columns inverted
- Removed undocumented `@builtin/code` group syntax
- Shell `denyByDefault` silently rejected commands — replaced with `autoAllowReadonly`
- All stale `kiro-harness` references renamed to `kiro-anywhere`

## v0.1.0 — 2026-07-04

### Added
- Initial release
- Cursor support (`.cursorrules`, `.cursor/rules/*.md`)
- Claude Code support (`CLAUDE.md`, `.claude/settings.json`)
- Windsurf support (`.windsurfrules`, `.windsurf/rules/*.md`)
- Continue support (`.continuerc.json`, `config.json`)
- Cline support (`.clinerules`, `.cline/rules/*.md`)
- GitHub Copilot support (`.github/copilot-instructions.md`)
- Aider support (`.aider.conf.yml`, `.aiderignore`)
- One-shot CLI mode (`convert.sh`)
- Safety constraints (write-only to `.kiro/`, read-only shell)
- `install.sh` for global agent installation
