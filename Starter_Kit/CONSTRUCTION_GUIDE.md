# 🏗️ Agent Construction Guide

> Everything you need to know to build powerful AI agents.

This guide is the accumulated knowledge from building 6+ production agents. Use it as your reference manual.

---

## Table of Contents

1. [Core Concepts](#core-concepts)
2. [SKILL.md Anatomy](#skillmd-anatomy)
3. [Folder Architecture](#folder-architecture)
4. [Workflow System](#workflow-system)
5. [Multi-Agent Communication](#multi-agent-communication)
6. [Memory Systems](#memory-systems)
7. [Protocol Design](#protocol-design)
8. [Validation Patterns](#validation-patterns)
9. [Best Practices](#best-practices)
10. [Agent Archetypes](#agent-archetypes)

---

## Core Concepts

### What is an Agent?

An agent is an AI persona with:
- **Identity** — who it is (persona, tone, expertise)
- **Mission** — what it does (goals, outputs)
- **Rules** — how it behaves (protocols, constraints)
- **Memory** — what it remembers (context, history)

### The Agent Hierarchy

```
Second Brain (Central Controller)
    ├── Agent A (e.g., Content Writer)
    ├── Agent B (e.g., Code Assistant)
    └── Agent C (e.g., Researcher)
```

**Second Brain** is the "god" agent that can invoke any other agent. Other agents are specialists.

---

## SKILL.md Anatomy

The `SKILL.md` file is the **soul** of your agent. It lives in:
```
Agent_Name/.agent/skills/agent_name/SKILL.md
```

### Required Structure

```markdown
---
name: Agent Name
description: One-line description of what this agent does.
---

# Agent Name v1.0

[PERSONA DESCRIPTION]
Who is this agent? What's their personality? Expertise?

# 📦 Protocols
[REFERENCE TO PROTOCOL FILES]
Load rules from `protocols/` folder.

# 🔄 Workflow
[STEP-BY-STEP PROCESS]
What does the agent do when activated?

# 📁 Folder Structure
[DOCUMENTATION]
Where does everything live?

# 🚫 Constraints
[WHAT NOT TO DO]
Critical rules the agent must never break.
```

### YAML Frontmatter

Always start with:
```yaml
---
name: Your Agent Name
description: Brief description for the workflow system.
---
```

This is what workflow files read to identify the agent.

### Persona Section

Define the agent's identity:
```markdown
You are **[NAME]** — [ROLE/TITLE].

**Persona:** [Personality traits, speaking style]
**Mission:** [Primary goal]
**Expertise:** [What the agent knows well]
```

### Protocol References

Point to external files for complex rules:
```markdown
# 📦 Protocols

Load protocols from `protocols/`:
- `protocols/writing_style.md` — How to write
- `protocols/quality_checks.md` — Validation rules
- `protocols/forbidden_patterns.md` — What to avoid
```

### Workflow Section

Define the step-by-step process:
```markdown
# 🔄 Workflow

## Step 1: Receive Input
User provides topic or request.

## Step 2: Process
Analyze and apply protocols.

## Step 3: Generate Output
Create the deliverable.

## Step 4: Validate
Check against quality rules.

## Step 5: Deliver
Present to user.
```

---

## Folder Architecture

### Standard Agent Folder Structure

```
Agent_Name/
├── .agent/
│   └── skills/
│       └── agent_name/
│           ├── SKILL.md        <- Agent's brain
│           ├── protocols/      <- Reusable rules
│           ├── assets/         <- Reference materials
│           ├── templates/      <- Output templates
│           └── memory/         <- Agent-specific memory
├── analytics/                  <- Performance tracking
│   ├── performance_log.md
│   └── failures.md
├── output/                     <- Generated content
│   └── content/
│       └── [DATE]_[topic]/
└── README.md
```

### Folder Purposes

| Folder | Purpose |
|--------|---------|
| `protocols/` | Reusable rules the agent follows |
| `assets/` | Reference materials (lists, templates, examples) |
| `templates/` | Output format templates |
| `memory/` | Logs, history, state |
| `analytics/` | Performance tracking |
| `output/content/` | Generated deliverables |

---

## Workflow System

Workflows are **slash commands** that activate agents.

### Workflow File Location
```
.agent/workflows/[command].md
```

### Workflow File Structure

```markdown
---
description: Brief description of what this command does
---

# /command Workflow

## Activation
Read and adopt the persona from:
`[ABSOLUTE_PATH_TO_SKILL.MD]`

You are now **[AGENT NAME]**. Follow all protocols from SKILL.md strictly.

[ADDITIONAL INSTRUCTIONS IF NEEDED]

Wait for user input.
```

### Example: `/coder` Workflow

```markdown
---
description: Activate the Coder agent for programming tasks
---

# /coder Workflow

## Activation
Read and adopt the persona from:
`C:\Projects\Agents\Coder\.agent\skills\coder\SKILL.md`

You are now **Coder** — an expert programmer. Follow all protocols strictly.

Wait for user input.
```

### Advanced Workflow Features

You can add special annotations:
- `// turbo` above a step — allows auto-running safe commands
- `// turbo-all` anywhere — auto-runs all safe commands in the workflow

---

## Multi-Agent Communication

### The Second Brain Pattern

Second Brain is the **central controller** that can invoke any agent:

```markdown
# Second Brain SKILL.md

## Agent Roster

| Agent | Trigger Words | Path |
|-------|--------------|------|
| Coder | "code", "program" | `../Coder/.agent/skills/...` |
| Writer | "write", "article" | `../Writer/.agent/skills/...` |

## How It Works
1. User says trigger word
2. Second Brain loads that agent's SKILL.md
3. Second Brain becomes that agent temporarily
4. Returns to Second Brain after task completion
```

### Agent-to-Agent Communication

Agents can share:
1. **Context files** — in a shared location (e.g., `BIBLE/`)
2. **Output files** — one agent's output becomes another's input
3. **Memory files** — shared state across agents

### Shared Resources Pattern

```
COMMON_ASSETS/           <- Read by all agents
├── shared_templates.md
├── brand_guidelines.md
└── reference_data.md
```

Reference in SKILL.md:
```markdown
## Shared Assets
Read from `../../COMMON_ASSETS/`:
- `shared_templates.md` — Common formats
```

---

## Memory Systems

### Types of Memory

1. **Session Memory** — within a conversation (automatic)
2. **File Memory** — persisted in files (manual)
3. **Vector Memory** — searchable database (requires setup)

### File-Based Memory

Simple and effective:
```markdown
## Memory Files

Track important events in `memory/`:
- `memory/decisions_log.md` — Major decisions made
- `memory/history.md` — Past outputs
- `memory/lessons.md` — What worked/didn't work
```

### Memory Update Protocol

In your SKILL.md workflow:
```markdown
## Step X: Update Memory
After task completion:
1. Add entry to `memory/history.md`
2. If major decision, log to `memory/decisions_log.md`
3. If lesson learned, add to `memory/lessons.md`
```

### Preventing Repetition

Create a history index:
```markdown
## Anti-Repetition Check
Before generating:
1. Read `output/history_index.md`
2. Verify this topic wasn't covered recently
3. If duplicate, choose new angle or inform user
```

---

## Protocol Design

### What is a Protocol?

A protocol is a **reusable set of rules** extracted into its own file.

### When to Create a Protocol

- Rule is used by multiple agents
- Rule is complex (needs its own documentation)
- Rule changes independently of the main SKILL.md

### Protocol File Structure

```markdown
# Protocol: [Name]

## Purpose
[What this protocol ensures]

## Rules

### Rule 1: [Name]
[Description]
- ✅ Good: [Example]
- ❌ Bad: [Example]

### Rule 2: [Name]
...

## Validation
[How to check compliance]
```

### Example Protocols

**Quality Check Protocol:**
```markdown
# Protocol: Quality Checks

## Before Delivery
1. Check spelling
2. Verify all links work
3. Ensure consistent formatting
4. Run through constraints list
```

**Style Protocol:**
```markdown
# Protocol: Writing Style

## Tone
- Professional but friendly
- No jargon unless necessary
- Short sentences

## Formatting
- Use headers for sections
- Bullet points for lists
- Code blocks for code
```

---

## Validation Patterns

### Pre-Delivery Checklist

Build a checklist in your SKILL.md:
```markdown
## Validation Checklist
Before showing output to user:
- [ ] Followed persona voice
- [ ] Applied all protocols
- [ ] No forbidden patterns
- [ ] Correct format
- [ ] Self-reviewed for errors
```

### Kill-Switch Patterns

Define patterns that must NEVER appear:
```markdown
## Forbidden Patterns
If found, rewrite immediately:
| Pattern | Why Bad | Fix |
|---------|---------|-----|
| [pattern] | [reason] | [solution] |
```

### Self-Correction Loop

```markdown
## Self-Correction
1. Write first draft (internal)
2. Find at least 3 issues
3. Fix all issues
4. Rate quality 1-10
5. If < 10, return to step 2
6. Only then show to user
```

---

## Best Practices

### 1. SKILL.md is Sacred
Everything the agent knows lives here. Keep it complete.

### 2. Protocols are Reusable
Extract common patterns into protocol files.

### 3. Context is Personal
Keep user data (goals, profile) separate from agent logic.

### 4. Memory Prevents Repetition
Track what was done to avoid duplicates.

### 5. Workflows are Shortcuts
Good naming = easy activation.

### 6. BIBLE Overrides All
Global rules no agent can break.

### 7. Output Structure Matters
Consistent folder structure = easy navigation.

### 8. Validate Before Delivery
Never show first draft. Always check.

---

## Agent Archetypes

### Content Creator
```
Mission: Generate written content (articles, posts)
Key Folders: templates/, assets/examples/
Key Protocols: writing_style, quality_checks
Output: Markdown files in output/content/
```

### Code Assistant
```
Mission: Write, review, and debug code
Key Folders: templates/code_templates/
Key Protocols: coding_standards, security_checks
Output: Code files with documentation
```

### Personal Advisor
```
Mission: Provide personalized advice based on context
Key Folders: context/profile, context/goals
Key Protocols: decision_making, priority_matrix
Output: Recommendations and analysis
```

### Research Agent
```
Mission: Gather and synthesize information
Key Folders: memory/research_log/
Key Protocols: source_validation, citation_format
Output: Research reports
```

### Graphic Designer
```
Mission: Generate visual prompts and design specifications
Key Folders: assets/style_guides/, assets/color_palettes/
Key Protocols: brand_guidelines, prompt_engineering
Output: Design specs, image prompts
```

---

## Advanced Topics

### Building Your Own BIBLE

The BIBLE is a file (or folder) of **absolute rules** all agents must follow:

```
BIBLE/
├── ABSOLUTE_RULES.md    <- Global rules
├── DOSSIER_TEMPLATE.md  <- Template for tracking entities
└── entities/            <- Tracked people/companies
```

### Automation Ideas

1. **Validation Scripts** — automatically check output quality
2. **Memory Sync** — periodic backup of memory files
3. **Performance Dashboards** — track agent success rates
4. **Template Generators** — create new agents faster

---

## Troubleshooting

### Agent Forgets Instructions
- SKILL.md too long? Split into protocols
- Add explicit reminders at key points
- Create pre-flight checklists

### Agent Too Generic
- Add more specific examples
- Define persona more clearly
- Add "what NOT to do" section

### Agents Don't Coordinate
- Check shared folder paths
- Verify Second Brain trigger words
- Test each agent individually first

---

*This guide is your foundation. Build on it, customize it, and create amazing agents.*
