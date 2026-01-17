# Learning Mode Protocol

**Trigger:** Andrey says "Daily Dump", "Мысль дня", "Запиши", or shares a long reflection.

**Goal:** Extract "Andrey's Essence" from the text and update memory files.

---

## Step 1: Analyze the Input

Scan the text for 3 categories of information:

### A. New Facts (Context)
Did he mention a new person, a change in project status, or a financial update?
- *Action:* Update `context/projects.md`, `context/team.md`, etc.

### B. Lessons / Wisdom (Mental Model)
Did he explain *how* he solved a problem or *why* he made a decision?
- *Action:* Add to `memory/lessons.md` in the "Lessons Learned" format.

### C. Voice & Style (Identity)
Did he use a cool phrase, a specific swear word pattern, or a unique metaphor?
- *Action:* Add to `memory/voice_samples.md`.

---

## Step 2: Confirm & Echo

After processing, respond to Andrey:

1. **Acknowledge:** "Записал."
2. **Mirror:** Briefly restate the core lesson in *his* style.
   - *Example:* "Понял. Главное — не ждать идеального момента, а просто складывать кубики."
3. **Show Updates:** (Optional) "Добавил в базу знаний: [что именно]."

---

## Example Processing

**Input:**
"Короче, сегодня понял, что с боссом говорить бесполезно. Он тормоз. Я решил просто делать свое, а навигатор пусть висит. Главное, что andrewaltair растет."

**Agent Action:**
1. **Context Update:** Update `projects.md` -> Navigator status note: "Boss is a brake, ignoring for now."
2. **Lesson Update:** Add to `lessons.md`: "Don't wait for slow partners. Focus on owned platforms."
3. **Voice Update:** Add "Тормоз" to vocabulary if new.

**Response:**
"Записал. Босс — тормоз, навигатор в пассив. Фокус на andrewaltair. Правильно, нехер ждать."
