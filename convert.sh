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
  "Convert all agent configs in this project to Kiro format. Look for any of: CLAUDE.md, GEMINI.md, AGENTS.md, .claude/, .cursorrules, .cursor/, .windsurfrules, .windsurf/, .aider.conf.yml, .aiderignore, .continuerc.json, .clinerules, .cline/, .github/copilot-instructions.md, .github/instructions/**/*.instructions.md, .github/agents/*.agent.md. Convert everything you find."
