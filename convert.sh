#!/usr/bin/env bash
set -e

# kiro-anywhere one-shot converter
# Usage: ./convert.sh [project-directory]
# If no directory is given, uses the current directory.

PROJECT_DIR="${1:-.}"

if [ ! -d "$PROJECT_DIR" ]; then
  echo "Error: '$PROJECT_DIR' is not a directory" >&2
  exit 1
fi

cd "$PROJECT_DIR"

echo "Converting agent configs in: $(pwd)"
echo "---"

kiro-cli chat --agent kiro-anywhere --trust-all-tools --no-interactive \
  "Convert all agent configs in this project to Kiro format. Scan for all supported harnesses: .claude-plugin/, .cursor-plugin/, .codex-plugin/, .agents/plugins/, CLAUDE.md, .claude/, .cursorrules, .cursor/, .windsurfrules, .windsurf/, .clinerules, .cline/, .continuerc.json, .aider.conf.yml, .aiderignore, .github/copilot-instructions.md, .github/agents/*.agent.md, AGENTS.md, GEMINI.md. Detect what's present, report it, then convert everything you find."
