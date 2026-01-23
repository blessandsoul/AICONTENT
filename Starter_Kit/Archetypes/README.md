# Archetypes

Pre-built agent templates for common use cases. Copy any folder to create your own agent.

## Available Archetypes

| Archetype | Workflow | Purpose | Best For |
|-----------|----------|---------|----------|
| **Coder** | `/coder` | Expert programmer | Writing, reviewing, debugging code |
| **Designer** | `/designer` | Visual design expert | Graphics, branding, image prompts |
| **UI/UX** | `/ui` | Interface designer | User interfaces, user experience |

## How to Use

1. **Copy** the archetype folder you want
2. **Rename** it to your agent name
3. **Customize** SKILL.md with your specifics
4. **Create workflow** in `.agent/workflows/`
5. **Register** in Second Brain's agent roster

## ⚠️ Important: Validation

All archetypes include mandatory validation. Before delivering ANY output, agents must:

1. Run through the validation checklist
2. Verify quality ≥7/10
3. Check all protocols followed
4. Only then deliver to user

See `BIBLE/ABSOLUTE_RULES.md` Section 0 for details.

## Creating Your Own Archetype

Build on Sample_Agent or copy an existing archetype. Great archetypes to add:
- **Writer** — Content creation, copywriting
- **Researcher** — Data gathering, analysis
- **Marketer** — Marketing strategy, campaigns
- **Teacher** — Explanations, tutorials
