# 🏗️ Architecture Overview

Visual overview of how the agent ecosystem works.

---

## System Architecture

```mermaid
graph TD
    subgraph User
        U[User Input]
    end

    subgraph Workflows
        W1["/brain"]
        W2["/agent"]
        W3["/coder"]
        W4["/designer"]
        W5["/ask"]
    end

    subgraph Agents
        SB[Second Brain<br/>Central Controller]
        SA[Sample Agent]
        C[Coder]
        D[Designer]
    end

    subgraph Shared
        B[BIBLE<br/>Global Rules]
        CA[COMMON_ASSETS]
    end

    U --> W1 & W2 & W3 & W4 & W5
    W1 --> SB
    W2 --> SA
    W3 --> C
    W4 --> D
    W5 --> U

    SB -.->|Can invoke| SA & C & D
    SB & SA & C & D --> B
    SA & C & D --> CA
```

---

## Agent Internal Structure

```mermaid
graph LR
    subgraph Agent
        SKILL[SKILL.md<br/>Agent Brain]
        SKILL --> P[Protocols<br/>Rules]
        SKILL --> A[Assets<br/>Resources]
        SKILL --> M[Memory<br/>History]
        SKILL --> O[Output<br/>Results]
    end
```

---

## Workflow Flow

```mermaid
sequenceDiagram
    participant U as User
    participant W as Workflow
    participant S as SKILL.md
    participant P as Protocols
    participant O as Output

    U->>W: /command
    W->>S: Load agent
    S->>P: Apply protocols
    P->>S: Rules applied
    S->>O: Generate output
    O->>U: Deliver result
```

---

## Folder Hierarchy

```
Starter_Kit/
│
├── 📁 .agent/workflows/      <- Slash commands
│   ├── brain.md
│   ├── agent.md
│   └── ask.md
│
├── 📁 BIBLE/                 <- Global rules
│   ├── ABSOLUTE_RULES.md
│   └── entities/
│
├── 📁 Second_Brain/          <- Central controller
│   └── .agent/skills/
│       └── second_brain/
│           ├── SKILL.md
│           ├── context/
│           ├── protocols/
│           └── memory/
│
├── 📁 Sample_Agent/          <- Template agent
│   └── .agent/skills/
│       └── sample_agent/
│           ├── SKILL.md
│           ├── protocols/
│           └── assets/
│
└── 📁 Archetypes/           <- Pre-built agents
    ├── Coder/
    └── Designer/
```

---

## Data Flow

```
┌─────────────────────────────────────────────────────┐
│                    USER LAYER                        │
│  Commands (/brain, /coder) → Questions → Tasks      │
└─────────────────────────────────────────────────────┘
                          │
                          ▼
┌─────────────────────────────────────────────────────┐
│                  WORKFLOW LAYER                      │
│  Routes commands to appropriate agents               │
└─────────────────────────────────────────────────────┘
                          │
                          ▼
┌─────────────────────────────────────────────────────┐
│                   AGENT LAYER                        │
│  SKILL.md → Protocols → Assets → Generation          │
└─────────────────────────────────────────────────────┘
                          │
                          ▼
┌─────────────────────────────────────────────────────┐
│                  OUTPUT LAYER                        │
│  Generated content → Validation → Delivery           │
└─────────────────────────────────────────────────────┘
```

---

*Use this document to understand how all pieces connect.*
