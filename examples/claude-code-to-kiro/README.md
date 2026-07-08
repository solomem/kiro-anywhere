# Example: Claude Code → Kiro

**Input:** `CLAUDE.md` with FastAPI project rules

**Output:**
- `.kiro/agents/fastapi-service.json` — agent config with pytest hook and secret denial
- `.kiro/steering/conventions.md` — coding rules

**What was mapped:**
| Source | Kiro |
|--------|------|
| "Run pytest before committing" | `stop` hook |
| "Never commit .env files" | `toolsSettings.write.deniedPaths` |
| Coding conventions | `.kiro/steering/conventions.md` |
| Agent role | Inline `prompt` field |
| Git workflow rules | Steering file |
