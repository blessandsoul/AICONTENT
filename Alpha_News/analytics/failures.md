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

*Add entries after analyzing failed posts*
