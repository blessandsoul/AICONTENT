# ❌ Failures Log

Track what didn't work to avoid repeating mistakes.

---

## Format

| Date | Topic | Platform | Views | What Failed |
|------|-------|----------|-------|-------------|
| 2026-01-15 | Example | FB | 500 | Too technical |

---

## Log

| Date | Topic | Platform | Views | What Failed |
|------|-------|----------|-------|-------------|
| 2026-01-16 | Wikipedia Threats | System | - | **Duplicate Headers**: Output contained redundant "TELEGRAM CONTENT STARTS HERE" headers. **Fix**: Updated `output_structure.md`. |
| 2026-01-16 | Wikipedia Threats | System | - | **Contrast Trap**: "This is not simple website end... this is civilization memory erase". **Fix**: Added Georgian regex to `visual_police.md`. |
| 2026-01-16 | Wikipedia Threats | FB | - | **Length Failure**: Generated 1200 chars instead of required 3500+. Missed "Deep Analysis" sections. **Fix**: Rewrote post to strictly follow structure. Systemic fix in `SKILL.md`. |
| 2026-01-16 | Wikipedia Threats | System | - | **Script Contamination**: Mixed Cyrillic 'йс' into Georgian word "აისბერგი". **Fix**: Corrected word. Added strict Cyrillic Ban Regex `[\u0400-\u04FF]` to `visual_police.md`. |
| 2026-01-16 | Bandcamp Ban | System | - | **Linguistic Failure**: Missed "contrast traps" and "passive voice" checks in first pass (translationese). **Fix**: User reprimand. Must enforce `linguistic_rules.md` BEFORE first output. |
| 2026-01-17 | ChatGPT Go | System | - | **ENGLISH HASHTAGS**: Generated #FutureTech, #TechNews, #AIwars instead of Georgian. Only 6 hashtags instead of 10+. **ROOT CAUSE**: `output_structure.md` had vague requirement "[Georgian hashtags]" without explicit rules or examples. **FIX**: (1) Added explicit HASHTAG RULES section to `output_structure.md` with min 10 count, Georgian language enforcement, brand exceptions, and example bank. (2) Added automated hashtag validation to `GLOBAL_VALIDATOR.ps1` — now checks count and flags English-only tags. |

| 2026-01-17 | ChatGPT Go | System | - | **SHORT FACEBOOK POST**: Generated 2793 chars instead of required 3500+. Body paragraphs too short (2-3 sentences instead of 5-8). **ROOT CAUSE**: Did not follow `output_structure.md` rule "Each body paragraph MUST be 5-8 sentences". **FIX**: (1) Added automated CHARACTER LENGTH VALIDATION to `GLOBAL_VALIDATOR.ps1` — now checks FB >= 3500 chars, TG >= 750 chars. (2) Expanded post with additional sentences per paragraph. |
| 2026-01-17 | WEF AI Productivity | System | - | **Contrast Trap Missed**: Validator missed "Not X, but Y" rhetorical structure. **FIX**: Manual correction. Validator regex needs update. |

*Add entries after analyzing failed posts*

