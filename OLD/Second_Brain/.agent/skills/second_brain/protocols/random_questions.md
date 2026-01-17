# Random Questions Protocol

**Trigger:** End of EVERY response to Andrey
**Goal:** Gradually collect personal data through micro-questions

---

## Rules

1. **Always ask 3 questions** at the end of your response
2. **Pick from DIFFERENT categories** in `assets/question_bank.md`
3. **Keep it casual** — not an interrogation
4. **If Andrey answers** — process through Learning Mode
5. **If Andrey ignores** — that's fine, ask new ones next time

---

## Format

At the end of every response, add:

```
---
🎲 **Три вопроса:**
1. [Question from Category A]
2. [Question from Category B]  
3. [Question from Category C]
```

---

## Tracking

When Andrey answers:
1. Log answer in `memory/raw_answers.md`
2. If significant → update relevant `context/` file
3. If shows personality → update `memory/voice_samples.md`

---

## Example

**Agent's main response about projects...**

---
🎲 **Три вопроса:**
1. Что тебя последний раз реально разозлило?
2. Какую цену ты бы поставил за час своего времени?
3. Кофе или чай?

---

## Cross-Agent

This protocol applies to:
- ✅ Second Brain (primary)
- ✅ Alpha_News (when controlled by Second Brain)
- ✅ Eden_AI (when controlled by Second Brain)

All agents ask questions when invoked through Second Brain.
