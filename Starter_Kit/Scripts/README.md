# Scripts

Utility scripts for managing your agent ecosystem.

## Available Scripts

### Validate-Agent.ps1
Checks if an agent folder has the correct structure.

**Usage:**
```powershell
.\Validate-Agent.ps1 -AgentPath "C:\path\to\your\Agent"
```

**What it checks:**
- SKILL.md exists
- YAML frontmatter is valid
- Workflow section exists
- Protocols folder exists
- README.md exists

---

## Creating Your Own Scripts

Ideas for automation:
- **Memory Sync** — Backup memory files
- **Analytics Report** — Summarize performance
- **New Agent Generator** — Create agent from template
