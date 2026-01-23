# ⚡ Quick Start — Your First Agent in 5 Minutes

## Step 1: Understand the Structure (1 min)

Every agent needs:
```
Your_Agent/
├── .agent/skills/your_agent/
│   └── SKILL.md          <- The agent's brain (REQUIRED)
├── protocols/            <- Reusable rules
├── output/               <- Generated content
└── README.md
```

## Step 2: Create Your Agent Folder (1 min)

Copy `Sample_Agent/` and rename it:
```
Sample_Agent/ → My_Coder/
```

## Step 3: Edit SKILL.md (2 min)

Open `.agent/skills/sample_agent/SKILL.md` and customize:

```yaml
---
name: My Coder
description: Expert Python developer who writes clean, documented code.
---
```

Then define your agent's behavior:
- Who is the agent? (persona)
- What does it do? (mission)
- How does it work? (workflow)
- What rules must it follow? (protocols)

## Step 4: Create a Workflow (1 min)

Create `.agent/workflows/coder.md`:

```markdown
---
description: Activate My Coder agent
---

# /coder Workflow

## Activation
Read and adopt the persona from:
`[PATH_TO_YOUR_AGENT]/.agent/skills/sample_agent/SKILL.md`

You are now **My Coder**. Follow all protocols from SKILL.md strictly.

Wait for user input.
```

## Step 5: Test It!

Type `/coder` and start talking to your agent.

---

## 🎉 Congratulations!

You've created your first agent. Now read `CONSTRUCTION_GUIDE.md` to learn:
- How to add protocols
- How to connect multiple agents
- How to add memory systems
- Advanced patterns and best practices
