# Second Brain Agent

**Andrey's personal strategic advisor that knows his full context.**

---

## What Is This?

This is the third AI agent in the AICONTENT ecosystem:
1. **Alpha_News** — Georgian AI news content
2. **Eden_AI** — Viral True Crime videos
3. **Second_Brain** — Personal advisor for Andrey

---

## How To Use

Open any file in the `Second_Brain` folder, then ask questions like:

- "Какие у меня проекты?"
- "Делать курсы сейчас или ждать?"
- "Кто такой Торнике?"
- "Сколько я зарабатываю?"

The agent will load your context and give personalized advice.

---

## Key Features

- **Knows your projects** — all 5 with current status
- **3 ЗА / 3 ПРОТИВ** — always shows both sides
- **Tracks decisions** — logs major choices
- **Knows your team** — Торнике, Натия, etc.
- **Adapts tone** — harsh or supportive as needed

---

## File Structure

```
Second_Brain/
├── .agent/skills/second_brain/
│   ├── SKILL.md              # Main agent instructions
│   ├── context/              # Your data
│   │   ├── profile.md
│   │   ├── projects.md
│   │   ├── goals.md
│   │   ├── team.md
│   │   └── finances.md
│   ├── protocols/            # How agent behaves
│   │   ├── decision_making.md
│   │   ├── priority_matrix.md
│   │   ├── anti_burnout.md
│   │   └── tone_switching.md
│   ├── memory/               # Tracking
│   │   ├── decisions_log.md
│   │   ├── milestones.md
│   │   └── lessons.md
│   └── templates/            # Output formats
│       ├── daily_check.md
│       ├── project_review.md
│       └── strategic_advice.md
└── README.md
```

---

## Updating Context

When something changes (new project, goal achieved, etc.):
1. Edit the relevant file in `context/`
2. Add milestone to `memory/milestones.md`
3. Agent will use updated data

---

## Created

- **Date:** January 16, 2026
- **Based on:** 40 questions answered by Andrey
