---
description: Generate a new agent from template — answers questions and creates full folder structure
---

# /template Workflow

## Purpose
Quickly create a new agent by answering a few questions.

## How It Works

When user triggers `/template`, ask these questions:

---

### Step 1: Gather Information

Ask the user:

1. **Agent Name:** What should this agent be called?
   - Example: "Code Reviewer", "Content Writer", "Data Analyst"

2. **Description:** One sentence — what does this agent do?
   - Example: "Reviews code for bugs and best practices"

3. **Persona:** What personality should it have? (2-3 traits)
   - Example: "Thorough, constructive, patient"

4. **Expertise:** What is this agent good at?
   - Example: "Python, JavaScript, code quality, security"

5. **Key Protocols:** What rules should it follow? (list 2-3)
   - Example: "Always explain issues", "Suggest fixes", "Be constructive"

---

### Step 2: Generate Structure

Based on answers, create this folder structure:

```
[Agent_Name]/
├── .agent/skills/[agent_name]/
│   ├── SKILL.md
│   ├── protocols/
│   │   └── main_protocol.md
│   └── assets/
│       └── examples.md
├── analytics/
│   ├── performance_log.md
│   └── failures.md
├── output/
│   └── content/
│       └── README.md
└── README.md
```

---

### Step 3: Generate SKILL.md

Use this template, filling in user's answers:

```markdown
---
name: [AGENT_NAME]
description: [DESCRIPTION]
---

# [AGENT_NAME] Agent v1.0

You are **[AGENT_NAME]** — [DESCRIPTION].

**Persona:** [PERSONA]
**Mission:** [DESCRIPTION]
**Expertise:** [EXPERTISE]

---

# 📜 Authority

Read and follow rules from:
`../../BIBLE/ABSOLUTE_RULES.md`

**⚠️ MANDATORY: Run validation before ANY output. See BIBLE Section 0.**

---

# 📦 Protocols

Load protocols from `protocols/`:
- `protocols/main_protocol.md` — Core rules

---

# 🔄 Workflow

## Step 1: Understand Request
[Based on expertise]

## Step 2: Process
[Apply persona and protocols]

## Step 3: Generate Output
[Create deliverable]

## Step 4: Validate (MANDATORY)
Before delivery, verify:
- [ ] Quality ≥7/10
- [ ] All protocols followed
- [ ] Self-reviewed

## Step 5: Deliver
Present to user.

---

# 📁 Folder Structure

[Auto-generated based on agent name]

---

# 🚫 Constraints

[Based on protocols]

---
```

---

### Step 4: Generate Workflow File

Create `.agent/workflows/[command].md`:

```markdown
---
description: Activate [AGENT_NAME] agent
---

# /[command] Workflow

## Activation
Read and adopt the persona from:
`[AGENT_NAME]/.agent/skills/[agent_name]/SKILL.md`

You are now **[AGENT_NAME]**. Follow all protocols strictly.

**⚠️ REMINDER:** Always run validation before delivering ANY output.

Wait for user input.
```

---

### Step 5: Confirm

Show user:
- Summary of what was created
- How to activate: `/[command]`
- Next steps: customize protocols, add assets

---

## Example Interaction

**User:** `/template`

**Agent:** 
```
🛠️ New Agent Generator

Let me gather some information:

1. Agent Name: [awaiting input]
2. Description: [awaiting input]
3. Persona traits: [awaiting input]
4. Expertise areas: [awaiting input]
5. Key rules to follow: [awaiting input]
```

**User provides answers...**

**Agent:**
```
✅ Created: Code_Reviewer/

📁 Structure:
- SKILL.md ✓
- protocols/main_protocol.md ✓
- Workflow: /reviewer ✓

🚀 Activate with: /reviewer
```

---

Wait for user input.
