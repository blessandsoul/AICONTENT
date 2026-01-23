# 🔧 Troubleshooting Guide

Common problems and their solutions.

---

## Agent Forgets Instructions

**Symptoms:**
- Agent doesn't follow SKILL.md rules
- Responses become generic over time
- Agent "forgets" persona

**Solutions:**

1. **SKILL.md too long?**
   - Split into protocols (separate files)
   - Keep SKILL.md focused on essentials
   - Reference protocols: `protocols/specific_rules.md`

2. **Add explicit reminders:**
   ```markdown
   > ⚠️ REMINDER: Always check X before responding
   ```

3. **Create pre-flight checklists:**
   ```markdown
   ## Before Every Response
   - [ ] Am I in character?
   - [ ] Did I check protocols?
   - [ ] Is this following the rules?
   ```

4. **Re-read SKILL.md periodically:**
   Add instruction: "Before complex tasks, re-read SKILL.md"

---

## Agent Too Generic

**Symptoms:**
- Responses feel like any AI could write them
- No personality shines through
- Advice is vague

**Solutions:**

1. **Define persona more specifically:**
   ```markdown
   ❌ "You are helpful"
   ✅ "You are brutally honest, use dark humor, and never sugarcoat"
   ```

2. **Add examples of how to respond:**
   ```markdown
   ## Response Style Examples
   
   ❌ Wrong: "That's an interesting question."
   ✅ Right: "Here's the brutal truth you didn't want to hear..."
   ```

3. **Add "What NOT to do" section:**
   ```markdown
   ## Never Do
   - Never be vague
   - Never say "It depends" without explaining
   - Never give generic advice
   ```

---

## Agents Don't Coordinate

**Symptoms:**
- Second Brain can't invoke other agents
- Agents don't share information
- Context gets lost between agents

**Solutions:**

1. **Check trigger words in Second Brain:**
   ```markdown
   | Agent | Triggers |
   |-------|----------|
   | Coder | "code", "program", "coder" |
   ```

2. **Verify paths are correct:**
   - Use absolute paths when possible
   - Test path by reading the file

3. **Use shared resources:**
   - Create `COMMON_ASSETS/` folder
   - Store shared data in `BIBLE/`
   - Reference: `../../BIBLE/shared_data.md`

4. **Test each agent individually first:**
   - Verify each agent works on its own
   - Then test invocation through Second Brain

---

## Output Quality Inconsistent

**Symptoms:**
- Some outputs are great, others poor
- No predictability

**Solutions:**

1. **Add validation protocol:**
   ```markdown
   ## Before Delivery
   - [ ] Quality score > 7/10?
   - [ ] Followed all protocols?
   - [ ] Self-reviewed for errors?
   ```

2. **Create Golden Samples:**
   - Save best outputs as examples
   - Reference before new generation

3. **Add self-correction loop:**
   ```markdown
   ## Self-Correction
   1. Generate draft (internal)
   2. Find 3 issues
   3. Fix issues
   4. Rate 1-10
   5. If < 8, repeat step 2
   ```

---

## Workflow Not Working

**Symptoms:**
- `/command` doesn't activate agent
- Wrong agent activates

**Solutions:**

1. **Check workflow file location:**
   - Must be in `.agent/workflows/`
   - Filename = command (e.g., `coder.md` for `/coder`)

2. **Check YAML frontmatter:**
   ```yaml
   ---
   description: Activate Coder agent
   ---
   ```

3. **Check path in workflow:**
   - Path to SKILL.md must be correct
   - Test by manually reading the file

---

## Memory Not Working

**Symptoms:**
- Agent doesn't remember past interactions
- No history tracking

**Solutions:**

1. **Create memory files explicitly:**
   ```
   memory/
   ├── history.md
   ├── decisions_log.md
   └── lessons.md
   ```

2. **Add save instructions to workflow:**
   ```markdown
   ## After Task Completion
   - Add entry to memory/history.md
   - Log important decisions
   ```

3. **Read memory at start:**
   ```markdown
   ## Before Starting
   - Read memory/history.md
   - Check for relevant past context
   ```

---

## Still Stuck?

1. **Simplify:** Remove complexity, start with basics
2. **Test isolation:** Test each component separately
3. **Read files:** Manually verify all files exist and are correct
4. **Start fresh:** Copy from Sample_Agent and rebuild

---

*Add your own troubleshooting entries as you discover solutions!*
