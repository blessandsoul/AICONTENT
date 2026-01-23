# 🔄 Version Control Guide

How to use Git with your agent ecosystem.

---

## .gitignore Recommendations

Create a `.gitignore` file in your Starter_Kit folder:

```gitignore
# Personal context (don't share)
Second_Brain/.agent/skills/second_brain/context/*
!Second_Brain/.agent/skills/second_brain/context/.gitkeep

# Memory files (optional - may contain personal info)
**/memory/*.md
!**/memory/.gitkeep

# Output (usually large, regeneratable)
**/output/content/*
!**/output/content/.gitkeep

# Analytics (optional - may want to track)
# **/analytics/*.md

# OS files
.DS_Store
Thumbs.db

# Editor files
.vscode/
.idea/
*.swp
```

---

## What to Version Control

### ✅ Always Track:

| File/Folder | Why |
|-------------|-----|
| `SKILL.md` files | Agent definitions |
| `protocols/` | Rules and logic |
| `assets/` | Reference materials |
| `workflows/` | Slash commands |
| `BIBLE/` | Global rules |
| Documentation | README, guides |

### ❌ Usually Exclude:

| File/Folder | Why |
|-------------|-----|
| `context/` | Personal information |
| `memory/` | May contain sensitive data |
| `output/content/` | Large, regeneratable |

---

## Branching Strategy

### Simple (Recommended for Personal Use):

```
main (stable agents)
  └── experiment (try new ideas)
```

### Team Use:

```
main (production agents)
  ├── develop (integration)
  ├── feature/new-agent
  └── fix/coder-bug
```

---

## Commit Messages

Use clear prefixes:

```
[agent] Added Coder archetype
[protocol] Updated security rules
[workflow] Fixed /designer path
[docs] Updated CONSTRUCTION_GUIDE
[fix] Corrected SKILL.md syntax
```

---

## Sharing Agents

### To Share an Agent:

1. Copy the agent folder
2. Remove personal context
3. Remove output/analytics
4. Keep SKILL.md, protocols, assets
5. Zip and share

### What to Include:

```
My_Agent/
├── .agent/skills/my_agent/
│   ├── SKILL.md ✅
│   ├── protocols/ ✅
│   └── assets/ ✅
├── analytics/ ❌ (empty or remove)
├── output/ ❌ (empty or remove)
└── README.md ✅
```

---

## Versioning SKILL.md

Add version in SKILL.md:

```markdown
# Agent Name v1.2

## Changelog
- v1.2: Added new protocol
- v1.1: Fixed workflow bug
- v1.0: Initial release
```

---

## Git Commands Reference

```bash
# Initialize repo
git init

# Add files
git add .

# Commit
git commit -m "[agent] Initial commit"

# Create branch
git checkout -b experiment

# Merge back
git checkout main
git merge experiment

# Push to remote
git push origin main
```

---

*Version control helps you experiment safely and share easily.*
