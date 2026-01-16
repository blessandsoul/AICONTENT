# 🔄 Anti-Repeat Protocol

## Prevent Repetition of Characters, Topics, and Phrases

---

## 🎭 CHARACTER ROTATION

### Rule
NEVER use the same character in 2 consecutive posts.

### Check Before Generation
1. Open `output/history_index.md`
2. Find "Last 5 Characters Used" section
3. Avoid top 2 characters in the list

### Example
```
Last 5 Characters:
1. Bugs Bunny      ← AVOID
2. Daffy Duck      ← AVOID
3. Wile E. Coyote  ← OK
4. Marvin          ← OK
5. Porky Pig       ← OK
```

---

## 📰 TOPIC ROTATION

### Rule
Don't cover the same major topic within 7 days.

### Major Topics
- OpenAI / Sam Altman
- Google / Sundar Pichai
- Meta / Zuckerberg
- Microsoft / Satya Nadella
- Elon Musk (any context)
- Crypto crash
- Job layoffs
- Data breach

### Exception
Series posts (Part 2, Part 3) are allowed if clearly labeled.

---

## 💬 PHRASE ROTATION

### Shock Hook Patterns
Don't repeat the same pattern structure within 5 posts.

| Pattern | Example | Cooldown |
|---------|---------|----------|
| Number + Disaster | "200 გათავისუფლებული" | 5 posts |
| Question | "იცოდი რომ...?" | 3 posts |
| Name + Action | "Altman-მა გააკეთა..." | 3 posts |
| Fake Quote | "ისინი ამბობენ..." | 5 posts |

### Headlines
Track unique headlines in `history_index.md`. Never repeat exact headline.

---

## 🌍 ENVIRONMENT ROTATION

### Rule
Don't use same environment in 3 consecutive posts.

### Categories to Rotate
1. Corporate → Urban → Domestic → Tech → Abstract → Global
2. Then repeat cycle

---

## 📊 TRACKING TEMPLATE

Update `output/history_index.md` after each generation:

```markdown
## Last Generation: 2026-01-15

| Element | Value |
|---------|-------|
| Character | Bugs Bunny |
| Topic | OpenAI Layoffs |
| Hook Pattern | Number + Disaster |
| Environment | Server Room |
| Headline | სისხლიანი ალგორითმი |
```

---

## ⚠️ VIOLATION CONSEQUENCES

If repetition detected:
1. Regenerate with different values
2. Log violation in `analytics/failures.md`
3. Adjust weights to prevent future repeats
