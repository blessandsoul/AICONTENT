---
description: Generate weekly performance digest for all content
---

# /weekly-digest Workflow

**Usage:** `/weekly-digest`
**Output:** Summary of last 7 days performance

---

## Steps

### 1. Scan MASTER_INDEX.md
- Find all posts from last 7 days
- Collect their results.md data

### 2. Generate Report

```markdown
# 📊 Weekly Digest: [DATE RANGE]

## 🔥 TOP PERFORMERS
1. [Title] — [Views] views — [Verdict]
2. [Title] — [Views] views — [Verdict]
3. [Title] — [Views] views — [Verdict]

## ❌ UNDERPERFORMERS
1. [Title] — [Views] views — Reason: [...]

## 📈 TRENDS
- Best performing villain: [Name]
- Best performing hook pattern: [Pattern]
- Best platform: [TikTok/YT/FB/TG]

## 💡 RECOMMENDATIONS
- Next week focus on: [...]
- Avoid: [...]

## 🔮 ORACLE ACCURACY
- Predictions vs Actuals: [X]% match
```

### 3. Save Report
- Save to `analytics/weekly_digest_[DATE].md`

### 4. Update Prediction Model (if needed)
- Adjust weights in prediction_model.md based on trends
