# COMMON_ASSETS

Shared resources that ALL agents can access.

## Purpose
Centralized assets that multiple agents need. Avoid duplication by putting shared content here.

## Contents

| File | Purpose |
|------|---------|
| `brand_guidelines.md` | Brand identity rules |
| `tone_of_voice.md` | Communication style |
| `forbidden_patterns.md` | What to never do/say |
| `shared_templates.md` | Reusable output templates |

## How to Reference

In any agent's SKILL.md:

```markdown
## Shared Assets
Read from `../../COMMON_ASSETS/`:
- `brand_guidelines.md` — Brand rules
- `tone_of_voice.md` — How to communicate
```

## Rules

1. **All agents can read** from this folder
2. **Only update** when it affects ALL agents
3. **Document changes** in CHANGELOG.md
