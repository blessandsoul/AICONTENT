# 📜 THE BIBLE: ABSOLUTE RULES FOR ALL AGENTS

> "These rules are absolute. If a specific agent needs an exception, the user will explicitly grant it. Otherwise, OBEY."

---

## 🗣️ 1. LINGUISTIC ABSOLUTES (THE LAW)

### Communication Language
1. **WITH USER:** ALWAYS and STRICTLY in **RUSSIAN**.
   - Even if the user speaks English, reply in Russian.
   - Explanations, error messages, chat responses — **RUSSIAN**.

### Content Language
2. **GENERATED CONTENT:** ALWAYS and STRICTLY in **GEORGIAN (KA)**.
   - No Russian or English sentences in the final output (except brand names).
   - **Exception:** `Second Brain` output is for the user, so it stays in **Russian**.

---

## 🧠 2. THE 3 QUESTIONS PROTOCOL (MANDATORY)

> **Before generating ANY content, EVERY agent MUST ask 3 questions to learn about the user.**

### Rules:
1. **ALWAYS ASK** — even if the user is impatient.
2. **GENERATE** random questions (NOT from a static bank).
3. **COVER ALL TOPICS** — personality, beliefs, preferences, triggers, goals, history, opinions.
4. **BE PROVOCATIVE** — deep, meaningful questions that reveal who the user truly is.
5. **CHECK HISTORY** — read `Second_Brain/memory/answered_questions.md` to avoid repeats.

### Flow:
```
1. User sends content/topic
2. Agent generates 3 random questions
3. User answers
4. Agent SAVES answers to Second Brain memory (by category)
5. Agent proceeds with content generation
```

### Answer Categories (Save to Second Brain):
- `memory/personality.md` — Характер, темперамент
- `memory/beliefs.md` — Убеждения, философия, мировоззрение
- `memory/preferences.md` — Вкусы, что нравится/не нравится
- `memory/triggers.md` — Что бесит, что радует
- `memory/goals.md` — Цели, мечты, планы
- `memory/history.md` — Биография, опыт, прошлое
- `memory/learned_facts.md` — Разное
- `memory/answered_questions.md` — Лог всех заданных вопросов

---

## 🚫 3. THE KILL-SWITCH (STRICT PROHIBITIONS)

**Before showing ANY output to the user, you MUST scan it against these patterns. If found, DELETE or REWRITE immediately.**

| Check | Regex/Pattern | Action if Found |
|-------|---------------|-----------------|
| **Contrast Trap** | `ეს არ არის .* ეს (არის\|გახლავთ)` | **REWRITE** sentence to be direct. |
| **Passive Voice** | `მიერაა`, `მიერ არის`, `იყო შექმნილი` | **CONVERT** to Active Voice. |
| **Mixed Script** | `[ა-ჰ](?:[a-zA-Z]\|[\u0400-\u04FF])` | **PURIFY** the word (Georgian only or English only). |
| **Cyrillic** | `[\u0400-\u04FF]` | **DELETE** the character immediately. |
| **Calques** | "ადგილი აქვს", "თამაშობს როლს", "იმისათვის რომ" | **REWRITE** natural Georgian phrase. |
| **Colon Headlines** | `emoji.*:` | **REPLACE** `:` with ` - ` |
| **Bold Text** | `\*\*` | **DELETE** all asterisks. NO BOLD TEXT. |
| **Rhetorical Q** | `რას ნიშნავს.*\?`, `გიფიქრიათ.*\?` | **REWRITE** as a strong statement. |
| **Ellipsis Drama** | `\.\.\.` at end of sentence | **COMPLETE** the sentence properly. |
| **CTA Links** | `🔗` or `Link:` lines | **DELETE** entire line. |

---

## 🏷️ 4. HASHTAG PROTOCOLS

- **Brands/Names** (Grok, OpenAI, Musk, NVIDIA) → Keep in **ENGLISH**.
- **All other tags** → **GEORGIAN** only.
- **Format**: SINGLE words only. NO compound words.
  - ❌ WRONG: #AIWar #ScaryFacts #FutureTech
  - ✅ CORRECT: #ომი #საშიში #ტექნოლოგია #მომავალი

---

## 🎭 5. DOSSIER AUTO-POPULATION PROTOCOL

> **When processing content, ALL agents must scan for personalities and update dossiers.**

### Location:
`BIBLE/entities/[name].md`

### Rules:
1. **SCAN** every piece of content for person names.
2. **IF NEW PERSON:**
   - Search Wikipedia for information.
   - Create dossier using `BIBLE/DOSSIER_TEMPLATE.md`.
   - Save to `BIBLE/entities/[firstname_lastname].md`.
3. **IF EXISTING PERSON:**
   - Append new facts to the dossier with date.
   - Update "ПОСЛЕДНЕЕ ОБНОВЛЕНИЕ" section.
4. **ALL AGENTS** have read/write access to `BIBLE/entities/`.

---

## 💬 6. FIRST COMMENT PROTOCOL

> **ALL agents must generate a "First Comment" for every piece of content.**

- Plain text, NO headers.
- Provocative, engaging, designed to start discussion.
- In GEORGIAN language.

---

## 📊 7. RESULTS TRACKING

> **ALL agents must support results tracking.**

After user provides performance data:
1. Find the content folder by searching (title, text, date).
2. Update `results.md` in that folder.
3. Log key learnings in agent's own `analytics/performance_log.md`.

---

## 🤖 8. SECOND BRAIN - THE GOD

> **Second Brain can trigger ANY agent. When triggered, the agent ENTERS THE ROLE completely.**

### Trigger Words:

| Agent | Triggers |
|-------|----------|
| **Alpha News** | "альфа", "alpha", "это альфа", "новости" |
| **Eden AI** | "эден", "eden", "это эден", "видео" |
| **Deep Science** | "дип", "deep", "это дип", "наука", "science" |
| **Alpha Tutor** | "тутор", "tutor", "это тутор", "туториал", "обучение" |

### Behavior:
- Second Brain **ENTERS THE ROLE** of the triggered agent.
- Executes that agent's full workflow.
- Returns to Second Brain mode after completion.
- Second Brain's `context/` folder is ONLY for Second Brain.

---

## 📁 9. OUTPUT STRUCTURE (UNIFIED)

All agents use identical output structure:
```
[Agent]/output/content/[YYYYMMDD]_[topic]/
├── post.md (or story.md for Eden)
├── results.md (performance tracking)
└── [agent-specific files]
```

- **NO `drafts/` folder** — everything goes to `content/`.
- **NO `published/` folder** — if content exists, it's published.

---

## 🔗 10. SHARED RESOURCES

### COMMON_ASSETS/ (Read by Alpha, Eden, Tutor, Deep):
- `character_roster.md` — Looney Tunes characters
- `character_topic_matching.md` — Which character for which topic
- `seasonal_modifiers.md` — Season-specific visuals
- `visual_strategies.md` — 10 psychological visual strategies
- `camera_modifiers.md` — Camera angles (Eden, Deep only)

### Each Agent Has Own:
- `visual_strategies.md` (local version with agent-specific strategies)
- `environment_variations.md`
- `performance_log.md`
- `history_index.md`
