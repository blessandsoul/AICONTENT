---
description: Log performance results for a published post
---

# /log-result Workflow

**Usage:** `/log-result [CONTENT_ID] [VIEWS] [VERDICT]`
**Example:** `/log-result EDEN_0115_GROK 85000 WIN`

---

## Steps

### 1. Find the Project
- Open `AICONTENT/MASTER_INDEX.md`
- Search by CONTENT_ID or first 20 chars of title
- Navigate to the project folder

### 2. Update results.md
- Open `[project_folder]/results.md`
- Fill in: Views, Likes, Comments, Shares
- Mark VERDICT: WIN / NEUTRAL / FLOP
- Add LEARNINGS

### 3. Update performance_log.md
- Open `analytics/performance_log.md`
- Add new entry with all metrics
- Note any learnings for future calibration

### 4. Update villain_log.md (if needed)
- If villain was used, check cooldown status
- Extend cooldown if it was a WIN (proven effective)

### 5. Update hook_log.md (if needed)
- If hook was successful, mark as "PROVEN"
- If hook failed, add to "BANNED" list

### 6. Update MASTER_INDEX.md
- Change Status from PUBLISHED to WIN/FLOP

---

## Auto-Calibration

After logging:
- If Oracle predicted 90+ and actual was FLOP → Note discrepancy
- If Oracle predicted 60 and actual was WIN → Investigate why
- Use these to refine prediction_model.md weights
