# ✅ New Agent Checklist

Use this checklist when creating a new agent.

---

## Phase 1: Planning

- [ ] **Define purpose:** What does this agent do?
- [ ] **Define persona:** Who is this agent?
- [ ] **Identify protocols:** What rules does it follow?
- [ ] **List assets needed:** What resources does it need?

---

## Phase 2: Create Structure

- [ ] **Create agent folder:**
  ```
  [Agent_Name]/
  ├── .agent/skills/[agent_name]/
  ├── analytics/
  └── output/content/
  ```

- [ ] **Create SKILL.md** with:
  - [ ] YAML frontmatter (name, description)
  - [ ] Persona section
  - [ ] Protocols section
  - [ ] Workflow section
  - [ ] Folder structure documentation
  - [ ] Constraints section

- [ ] **Create protocols folder:**
  ```
  protocols/
  ├── [rule1].md
  └── [rule2].md
  ```

- [ ] **Create assets folder (if needed):**
  ```
  assets/
  ├── examples.md
  └── templates.md
  ```

---

## Phase 3: Connect to System

- [ ] **Create workflow file:**
  ```
  .agent/workflows/[command].md
  ```

- [ ] **Register in Second Brain:**
  Add to Agent Roster table in Second Brain SKILL.md

- [ ] **Add to BIBLE (if needed):**
  Any global rules this agent should follow

---

## Phase 4: Test

- [ ] **Test workflow activation:**
  Type `/[command]` and verify agent activates

- [ ] **Test basic functionality:**
  Give agent a simple task

- [ ] **Test protocol compliance:**
  Verify agent follows its rules

- [ ] **Test edge cases:**
  Give unusual inputs

---

## Phase 5: Document

- [ ] **Create README.md** in agent folder

- [ ] **Update main README** if needed

- [ ] **Add to Archetypes** if it's reusable

---

## Quick Reference

| What | Where |
|------|-------|
| Agent brain | `.agent/skills/[name]/SKILL.md` |
| Agent rules | `.agent/skills/[name]/protocols/` |
| Slash command | `.agent/workflows/[command].md` |
| Global rules | `BIBLE/ABSOLUTE_RULES.md` |
| Second Brain roster | `Second_Brain/.../SKILL.md` |
