---
description: Analyze the impact of published content and update Agent Memory with insights.
---

1. Ask user for the Post ID (or Link) and the Results (Screenshot or Text).
2. **Retrieve** the original post content from AutoMem to understand context.
3. Compare the **Result** (Views/Retention) with the **Technique** used (Hook/Visual).
4. **Generate Insight:** Why did it succeed or fail?
   - *Example:* "Success due to 'Risk' hook + 'Red' lighting."
5. **Update Memory:**
   - Add tag `HIGH_PERFORMANCE` or `LOW_PERFORMANCE` to the memory ID.
   - Save the **Insight** as a new memory type: `strategy_insight`.
6. Update `analytics/performance_log.md` locally.

**Usage:**
Run this when you have new stats from TikTok/FB.
