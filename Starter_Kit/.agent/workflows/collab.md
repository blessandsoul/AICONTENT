---
description: Multi-agent collaboration — chain multiple agents on a single task
---

# /collab Workflow

## Purpose
Run multiple agents together on a single task. Each agent handles their specialty.

---

## How to Use

**Syntax:**
```
/collab [agent1] + [agent2] + [agent3]
```

**Examples:**
```
/collab coder + designer
/collab researcher + writer
/collab ui + coder + designer
```

---

## Collaboration Patterns

### Pattern 1: Sequential (A → B)
First agent completes, then second agent takes over.

```
/collab coder + designer

Flow:
1. Coder writes the code
2. Designer reviews and adds styling
3. Combined output delivered
```

### Pattern 2: Parallel (A + B → Combined)
Both agents work on aspects, then combine.

```
/collab ui + coder

Flow:
1. UI creates interface specification
2. Coder creates implementation
3. Merge into complete solution
```

### Pattern 3: Review (A → B reviews)
First agent creates, second agent reviews.

```
/collab coder + reviewer

Flow:
1. Coder writes code
2. Reviewer checks for issues
3. Coder fixes if needed
4. Final output delivered
```

---

## Execution Steps

### Step 1: Parse Request
Identify which agents are needed and the task.

### Step 2: Define Handoff Points
What does Agent A pass to Agent B?

### Step 3: Execute First Agent
- Load Agent A's SKILL.md
- Complete their portion
- Document output for handoff

### Step 4: Handoff
Pass relevant context to next agent:
- What was done
- What's needed next
- Any constraints

### Step 5: Execute Second Agent
- Load Agent B's SKILL.md
- Use handoff context
- Complete their portion

### Step 6: Combine & Validate
- Merge outputs if needed
- Run validation (MANDATORY)
- Deliver combined result

---

## Common Collaborations

| Combo | Use Case |
|-------|----------|
| `coder + designer` | Full-stack feature |
| `ui + coder` | Interface implementation |
| `researcher + writer` | Research-backed content |
| `designer + ui` | Visual + UX design |
| `coder + coder` | Pair programming |

---

## Handoff Template

When passing between agents:

```markdown
## Handoff: [Agent A] → [Agent B]

### Completed:
[What Agent A did]

### Output:
[The deliverable]

### For You:
[What Agent B needs to do]

### Constraints:
[Any limitations or requirements]
```

---

## Validation

**IMPORTANT:** The FINAL agent in the chain must run full validation before delivery.

All standard validation rules apply (see BIBLE Section 0).

---

Wait for user input.
