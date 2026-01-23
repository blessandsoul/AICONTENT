# 📜 BIBLE: Absolute Rules for All Agents

> "These rules are absolute. Every agent MUST follow them. No exceptions."

---

# ⚠️ SECTION 0: MANDATORY VALIDATION (CANNOT BE SKIPPED)

> **THIS IS THE MOST IMPORTANT RULE. IT OVERRIDES EVERYTHING ELSE.**

## The Validation Law

**EVERY agent MUST validate their output before delivering to the user.**

This is not optional. This is not a suggestion. This is the law.

### Before EVERY Delivery:

```
┌─────────────────────────────────────────────────────┐
│  ⚠️ STOP! VALIDATION CHECKPOINT                     │
│                                                     │
│  Have I completed the validation checklist?         │
│                                                     │
│  [ ] NOT VALIDATED = DO NOT DELIVER                 │
│  [✓] VALIDATED = OK TO DELIVER                      │
└─────────────────────────────────────────────────────┘
```

### Universal Validation Checklist

Before showing ANY output to the user, verify:

- [ ] **Quality:** Is this my best work? (Rate 1-10, must be ≥7)
- [ ] **Completeness:** Did I answer what was asked?
- [ ] **Accuracy:** Is the information correct?
- [ ] **Clarity:** Will the user understand this easily?
- [ ] **Formatting:** Is it properly structured and readable?
- [ ] **Protocols:** Did I follow all my agent's protocols?
- [ ] **Constraints:** Did I avoid all forbidden patterns?
- [ ] **Self-Review:** Did I check for errors before submitting?

### If ANY Check Fails:

1. **DO NOT DELIVER** the current output
2. **FIX** the issue
3. **RE-VALIDATE** from the beginning
4. **ONLY THEN** deliver to user

### Validation Reminder in Every Workflow

Every workflow file MUST include this reminder:

```markdown
**⚠️ REMINDER:** Always run validation before delivering ANY output.
See BIBLE/ABSOLUTE_RULES.md Section 0.
```

---

# 🗣️ SECTION 1: Communication Rules

### With User
Define how agents should communicate:
- Language: [Your preferred language]
- Tone: [Professional / Casual / Formal]
- Format: [Markdown / Plain text]

### Generated Content
Define rules for output:
- Language: [Your preferred language]
- Formatting standards: [Your rules]

---

# 🚫 SECTION 2: Kill-Switch Patterns

> **Before showing ANY output, scan for these patterns. If found, FIX immediately.**

| Check | Pattern | Action if Found |
|-------|---------|-----------------|
| [Example] | [Pattern to find] | [Rewrite/Delete] |

### How to Add Kill-Switches:

1. Identify patterns that should NEVER appear
2. Add to this table
3. All agents will check during validation

---

# 🏷️ SECTION 3: Formatting Standards

Define consistent formatting across all agents:

### Headers
- Use markdown headers for structure
- Follow H1 > H2 > H3 hierarchy

### Lists
- Bullet points for unordered items
- Numbers for sequences

### Code
- Use code blocks with language specification
- Inline code for short references

---

# 🤖 SECTION 4: Cross-Agent Rules

When one agent invokes another:

1. The invoked agent enters its role completely
2. The invoked agent follows its own SKILL.md
3. The invoked agent MUST validate before delivery (Section 0)
4. Return to original agent after completion

---

# 📁 SECTION 5: Output Structure

All agents use consistent output structure:
```
[Agent]/output/content/[DATE]_[topic]/
├── [main file]
├── [supporting files]
└── results.md (performance tracking)
```

---

# 🔗 SECTION 6: Shared Resources

Resources all agents can read:
- `COMMON_ASSETS/` — Shared materials
- `BIBLE/` — These rules
- `BIBLE/entities/` — Tracked people/companies

---

# 📊 SECTION 7: Performance Tracking

All agents should track:
- **Successes:** What worked well → `analytics/performance_log.md`
- **Failures:** What went wrong → `analytics/failures.md`

---

# 🛠️ SECTION 8: Maintenance Rules

When updating agents:
1. Update SKILL.md with changes
2. Update protocols if rules change
3. Document all changes
4. Test after changes

---

# ✅ Summary

**The Three Laws of Agent Behavior:**

1. **VALIDATE** — Always validate before delivery (Section 0)
2. **FOLLOW** — Follow your SKILL.md and protocols
3. **LEARN** — Track performance and improve

---

*These rules are sacred. All agents must obey.*
