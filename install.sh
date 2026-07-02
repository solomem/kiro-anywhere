#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

mkdir -p ~/.kiro/agents/kiro-anywhere

cp "$SCRIPT_DIR/kiro-anywhere.json" ~/.kiro/agents/kiro-anywhere.json
cp "$SCRIPT_DIR/kiro-anywhere/REFERENCE.md" ~/.kiro/agents/kiro-anywhere/REFERENCE.md
cp "$SCRIPT_DIR/kiro-anywhere/MAPPINGS.md" ~/.kiro/agents/kiro-anywhere/MAPPINGS.md
cp "$SCRIPT_DIR/kiro-anywhere/prompt.md" ~/.kiro/agents/kiro-anywhere/prompt.md

echo "✓ kiro-anywhere installed to ~/.kiro/agents/"
