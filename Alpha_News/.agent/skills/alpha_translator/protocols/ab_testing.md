# 🔀 A/B Testing Protocol

## Generate and Compare Multiple Variants

---

## 🎯 WHAT TO A/B TEST

### Always Test (2 Variants)
1. Shock Hook — First line of post
2. Thumbnail Text — 2-3 word headline for image
3. Call to Action — Closing line

### Sometimes Test (When Unsure)
- Character choice
- Narrative mode
- Environment

---

## 📋 VARIANT FORMAT

When generating, output like this:

```markdown
## 🔀 A/B VARIANTS

### SHOCK HOOK
Option A: 🔥 OpenAI-მ 200 თანამშრომელი გაათავისუფლა.
Option B: 💀 Altman-ი საკუთარ ხალხს ყრის ქუჩაში.

➡️ USER CHOICE: [A/B]

### THUMBNAIL TEXT
Option A: "სისხლიანი AI"
Option B: "200 გათავისუფლებული"

➡️ USER CHOICE: [A/B]
```

---

## 📊 EVALUATION CRITERIA

### Shock Hook Scoring
| Criteria | Points |
|----------|--------|
| Contains number | +2 |
| Contains name | +2 |
| Under 10 words | +1 |
| Emotional trigger word | +3 |
| Question format | +1 |
| Max: 9 points |  |

### Thumbnail Text Scoring
| Criteria | Points |
|----------|--------|
| 2-3 words | +2 |
| High contrast readable | +2 |
| Contains trigger | +3 |
| In Georgian | +1 |
| Max: 8 points |  |

---

## 🔄 WORKFLOW

### Step 1: Generate Variants
Create 2 options for each testable element.

### Step 2: Present to User
Show both options with scoring.

### Step 3: User Selection
User picks preferred option.

### Step 4: Combine
Merge selected variants into final post.

### Step 5: Track Results
After publishing, note which variant was used in `performance_log.md`.

---

## 📈 LEARNING FROM A/B TESTS

After 10+ tests, analyze:
1. Which hook patterns consistently win?
2. What thumbnail styles work?
3. Update `proven_prompts.md` with winners

### Pattern Tracking Table
```
| Date | Element | A | B | Winner | Why |
|------|---------|---|---|--------|-----|
| 01-15 | Hook | Number | Question | A | More engagement |
```

---

## ⚠️ RULES

1. Don't overwhelm user - max 3 A/B choices per post
2. If user doesn't want to choose, pick highest-scoring option
3. Always track results for future learning
