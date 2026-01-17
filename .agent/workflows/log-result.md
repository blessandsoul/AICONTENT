---
description: Log performance results for a published post
---

# /log-result Workflow

**Usage:** User sends post title + screenshots with stats → Agent logs everything automatically.

---

## Agent Instructions

When user provides statistics (screenshots or numbers), **automatically update ALL files without asking:**

### 1. Extract Stats from Screenshots/Message
Parse the following metrics:

**TikTok:**
- Views, Likes, Comments, Shares, Saves
- Avg Watch Time, Completion Rate
- New Subscribers, FYP %

**Facebook:**
- Views, Unique Viewers
- Reactions, Clicks, Comments, Reposts
- Avg Watch Time, Drop-off Point

### 2. Find the Project Folder
- Match post title to folder in `[Agent]/output/content/`
- Agent types: `Eden_AI`, `Alpha_News`, `Deep_Science`

### 3. Create/Update results.md
- Path: `[project_folder]/results.md`
- Include ALL metrics in tables
- Add VERDICT: WIN / NEUTRAL / FLOP
- Add Analysis with Strengths/Weaknesses/Learnings

### 4. Update performance_log.md
- Path: `[Agent]/analytics/performance_log.md`
- Add new row to Post History table

### 5. Update MASTER_INDEX.md
- Path: `AICONTENT/MASTER_INDEX.md`
- Add entry or update Status to WIN/NEUTRAL/FLOP

### 6. Synthesize Key Learnings (CRITICAL)
- Path: `[Agent]/analytics/performance_log.md` → **"Key Learnings"** section
- After logging stats, analyze the results for NEW patterns
- Add new "დასკვნა #N" entries when you discover:
  - Hook types that work/fail (question vs statement)
  - Drop-off patterns (early = hook problem)
  - Engagement patterns (comments, saves, shares)
  - Topic/villain combinations that succeed
- Format: `**დასკვნა #N (DD.MM.YYYY)**: [Learning in Georgian or Russian]`
- This is how the agent "learns" and improves future content!

---

## Verdict Guidelines

| Views (Total) | Engagement | Verdict |
|---------------|------------|---------|
| 10K+ | High | **WIN** |
| 5K-10K | Medium | NEUTRAL |
| <5K | Low | FLOP |

---

## PowerShell Script (Optional)

For manual use: `.agent/scripts/log_stats.ps1`

```powershell
# Example
.\log_stats.ps1 -PostFolder "Eden_AI/output/content/20260116_merge_labs" `
  -TikTokViews 1400 -TikTokLikes 48 -TikTokComments 2 `
  -FBViews 4749 -FBReactions 63 -Verdict WIN
```

