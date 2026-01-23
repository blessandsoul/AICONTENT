# 📖 Glossary

Definitions of key terms used in this system.

---

## Core Concepts

### Agent
An AI persona with defined identity, mission, and rules. Each agent lives in its own folder and has a SKILL.md file.

### SKILL.md
The "brain" of an agent. Contains everything the agent needs to know: persona, protocols, workflow, constraints. Located in `.agent/skills/[name]/SKILL.md`.

### Second Brain
The central controller agent that can invoke other agents. Acts as a hub for multi-agent coordination.

### Workflow
A slash command that activates an agent. Defined in `.agent/workflows/[command].md`. Example: `/coder` activates the Coder agent.

---

## File Types

### Protocol
A reusable set of rules stored in a separate file. Keeps SKILL.md clean and allows sharing rules between agents. Located in `protocols/` folder.

### Asset
Reference material the agent can use: examples, templates, lists. Located in `assets/` folder.

### BIBLE
Folder containing global rules that ALL agents must follow. Overrides individual agent rules.

### Dossier
A file tracking information about a specific person, company, or entity. Template in `BIBLE/DOSSIER_TEMPLATE.md`.

---

## Folder Structure

### `.agent/`
Hidden folder containing agent configuration. Houses `skills/` and `workflows/`.

### `context/`
Files containing personal information about the user. Used by Second Brain to personalize responses.

### `memory/`
Files tracking agent history: decisions made, lessons learned, past outputs.

### `analytics/`
Performance tracking: what worked, what failed, patterns found.

### `output/content/`
Where generated content is saved. Typically organized by date and topic.

---

## Actions

### Invoke
When one agent activates another. Example: Second Brain invokes Coder.

### Trigger
A word or phrase that activates an agent through Second Brain. Defined in the Agent Roster.

### Validate
Check output against quality rules before delivery.

### Self-Correction
Process where agent reviews own output, finds issues, and fixes them before showing to user.

---

## Patterns

### Agent Roster
Table in Second Brain SKILL.md listing all available agents, their triggers, and paths.

### Pre-Flight Check
Steps agent must take before generating content: read rules, check history, load context.

### Kill-Switch
Patterns that must NEVER appear in output. Agent must check and remove before delivery.

### Golden Sample
An example of ideal output used as reference for quality.

---

## File Naming

| Pattern | Meaning | Example |
|---------|---------|---------|
| `SKILL.md` | Agent brain | Always this name |
| `*.md` | Markdown file | Most documentation |
| `[command].md` | Workflow for /command | `coder.md` → `/coder` |
| `[YYYYMMDD]_[topic]/` | Dated output folder | `20240121_website/` |

---

*Add your own terms as your system grows!*
