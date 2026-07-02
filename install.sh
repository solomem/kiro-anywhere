#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

mkdir -p ~/.kiro/agents/kiro-harness

cp "$SCRIPT_DIR/kiro-harness.json" ~/.kiro/agents/kiro-harness.json
cp "$SCRIPT_DIR/kiro-harness/REFERENCE.md" ~/.kiro/agents/kiro-harness/REFERENCE.md
cp "$SCRIPT_DIR/kiro-harness/MAPPINGS.md" ~/.kiro/agents/kiro-harness/MAPPINGS.md
cp "$SCRIPT_DIR/kiro-harness/prompt.md" ~/.kiro/agents/kiro-harness/prompt.md

echo "✓ kiro-harness installed to ~/.kiro/agents/"
