# Example: Cursor → Kiro

**Input:** `.cursorrules` with TypeScript conventions

**Output:**
- `.kiro/agents/my-project.json` — agent config with prettier hook and denied paths
- `.kiro/steering/conventions.md` — coding rules extracted as steering

**What was mapped:**
| Source | Kiro |
|--------|------|
| "Run prettier on save" | `postToolUse` hook with matcher `write` |
| "Never edit dist/ or node_modules/" | `toolsSettings.write.deniedPaths` |
| Coding rules | `.kiro/steering/conventions.md` |
| Agent personality | Inline `prompt` field |
