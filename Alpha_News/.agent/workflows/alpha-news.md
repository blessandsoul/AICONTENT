---
description: Generate AI news content using Alpha Translator
---

# Alpha News Generation Workflow

## Usage
Say: `/alpha-news` or "Generate Alpha News about [TOPIC]"

## Steps

1. **Provide Topic**
   User gives raw AI news article or topic URL/text.

2. **Agent Processes**
   Agent reads SKILL.md and all protocols, then generates content.

3. **Output Generated**
   - Facebook post (3500-5000 chars)
   - Telegram post (750-1000 chars)
   - Meta-commentary
   - Image prompts (9:16 + 16:9)
   - Music suggestion

4. **Review & Publish**
   User reviews, edits if needed, publishes.

5. **Log Results**
   After publishing, update `analytics/performance_log.md` or `analytics/failures.md`.

## Quick Command
```
/alpha-news [paste article or topic here]
```
