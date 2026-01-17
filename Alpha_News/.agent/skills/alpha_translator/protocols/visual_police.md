# 🚨 VISUAL POLICE PROTOCOL

## INSTANT FAIL CONDITIONS

Any violation = regenerate entire output.

---

## 1. EMOJI FORMATTING

❌ WRONG:
```
(💀) სათაური
[💀] სათაური
```

✅ RIGHT:
```
💀 სათაური
```

RULE: NO brackets of ANY kind around emojis.

---

## 2. NO BOLD TEXT
❌ WRONG:
```
This is important (WRONG)
სათაური (WRONG)
```

✅ RIGHT:
```
This is important
სათაური:
```

RULE: BOLD formatting is STRICTLY FORBIDDEN in the output content. Use dash (-) for emphasis instead.

---

## 3. SQUARE BRACKETS IN TEXT

❌ WRONG:
```
[This is the main point of the story]
```

✅ RIGHT:
```
This is the main point of the story.
```

RULE: NEVER wrap paragraphs in [].

---

## 3. INVISIBLE HEADERS

❌ WRONG:
```
=== [PART 1] ===
STRATEGIC GRID
DEEP TECH ANALYSIS
--- SECTION ---
```

✅ RIGHT:
Just write the content without meta-labels.

RULE: NEVER output structural labels. Only content. Only big separators like --- [START OF OUTPUT] --- are allowed.

---

## 4. INTERNAL VARIABLES

❌ WRONG:
```
{CHAR}: Bugs Bunny
Mode Selected: THE RED PILL
```

✅ RIGHT:
Don't print these at all.

RULE: Internal logic stays internal.

---

## 5. NO CODE BLOCKS AROUND CTA

❌ WRONG:
```
```
🔗 Link
#hashtag
```
```

✅ RIGHT:
```
🔗 Link
#hashtag
```

RULE: The final CTA link and hashtags must NEVER be inside a code block.

---

## 6. REGEX POLICE (AUTOMATIC FAIL)

If the output matches any of these regex patterns, it is INVALID:

1. Start of Line Check (Facebook Body):
   - Pattern: `^\s*(?![#\-*]|\s*$|\[).+$` (Lines that don't start with Emoji/Headline in body)
   - Rule: Every paragraph must start with Emoji (e.g. `⚡`) or be a separator.

2. Code Block CTA Check:
   - Pattern: ````[\s\S]*?🔗`
   - Rule: Link `🔗` symbol found inside code fence.

3. Banned Phrases:
   - Pattern: `(?i)this is not .*? this is`
   - Rule: Contrast trap detected (English).
   - Pattern: `(?i)ეს არ არის .*? ეს (არის|გახლავთ|-ა|-აა)`
   - Rule: Contrast trap detected (Georgian: "Es ar aris... es aris").

5. Cyrillic Contamination:
   - Pattern: `[\u0400-\u04FF]`
   - Rule: CYRILLIC DETECTED. Strict ban. Use Georgian script only.

6. Mixed Script Contamination (CRITICAL):
   - Pattern: `[ა-ჰ](?:[a-zA-Z]|[\u0400-\u04FF])|(?:[a-zA-Z]|[\u0400-\u04FF])[ა-ჰ]`
   - Rule: MIXED GEORGIAN + LATIN/CYRILLIC IN SAME WORD = INSTANT FAIL.
   - ❌ WRONG: "ბოtlnecks", "აპsკილინგ", "გამაrdжобა" (Mixed G/L/C)
   - ✅ RIGHT: "შეფერხებები", "bottlenecks", "გამარჯობა"
   - Fix: Use PURE Georgian OR keep English term fully in English. Never mix scripts.

7. Headline Separator Violation:
   - Pattern: `\s:\s`
   - Rule: Colons are BANNED for separation. Use short dash ` - ` only.

---

## 8. PRE-PUBLISH SELF-CORRECTION

Before returning the final response, run this internal script:
1. `Scan for "\n\n[A-Za-z]"` -> If found, does it have an Emoji?
2. `Scan for triple backticks` -> Is the CTA inside it?
3. `Scan for "not X, but Y"` -> Rewrite.
4. `Scan for [ა-ჰ][a-z]|[a-z][ა-ჰ]` -> MIXED SCRIPT DETECTED. Rewrite word.
5. `Scan for Cyrillic` -> Remove any Russian characters.


