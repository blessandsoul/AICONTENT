# 📋 OUTPUT STRUCTURE FOR MAPPING

## Overview

This document describes the exact structure of generated posts for the Alpha_News project.
Use this to build parsers/mappers for extracting content sections.

---

## DELIMITERS (Exact Strings)

The output uses these exact delimiter strings to separate sections:

```
--- [START OF OUTPUT] ---
--- [TELEGRAM CONTENT STARTS HERE] ---
--- [META-COMMENTARY STARTS HERE] ---
---
```

---

## SECTION 1: FACEBOOK POST

Location: Between `--- [START OF OUTPUT] ---` and `--- [TELEGRAM CONTENT STARTS HERE] ---`

Structure:
```
[HOOK LINE]
[Empty line]
[TEASER PARAGRAPH]
[Empty line]
[DEEP ANALYSIS - 2 paragraphs]
[Empty line]
[5 BULLET POINTS - each starts with emoji, NO asterisks]
[Empty line]
[CLOSING LINE - always starts with 🫣]
[Empty line]
[HASHTAGS - Georgian + English brand names]
```

Bullet Point Format:
```
[Emoji] [Headline] — [Full paragraph, 4-6 sentences]
```

Example:
```
🎭 ცრუ ნდობა — თქვენ ენდობით ChatGPT-ს როგორც ნეიტრალურ ექსპერტს. ეს ილუზია მალე დაიმსხვრევა...
```

Important: NO markdown formatting (no bold, no asterisks, no #). Plain text only with emojis.

---

## SECTION 2: TELEGRAM POST

Location: Between `--- [TELEGRAM CONTENT STARTS HERE] ---` and `--- [META-COMMENTARY STARTS HERE] ---`

Structure:
```
[Emoji] [Headline - clickbait style]
[Empty line]
[Dense intro paragraph about immediate threat]
[Empty line]
[3 bullet points with emoji + headline + text]
[Empty line]
[Short cynical conclusion - no hope, no CTA]
[Empty line]
[CLOSING LINE - always starts with 🫣]
[Empty line]
[HASHTAGS]
```

Telegram Length: 750-1000 characters total

---

## SECTION 3: META-COMMENTARY

Location: Between `--- [META-COMMENTARY STARTS HERE] ---` and next `---`

Structure:
```
[Single paragraph of cynical opinion in Georgian]
```

Rules:
- Does NOT describe the image
- Does NOT mention the character
- Pure opinion/analysis

---

## SECTION 4: IMAGE PROMPT (Vertical 9:16)

Location: After META-COMMENTARY, starts with `Prompt:`

Identifier: Contains `Format: Vertical 9:16`

Structure:
```
Prompt:

Format: Vertical 9:16
Primary Branding: "AndrewAltair.GE" (...)
Secondary Text: "[Georgian phrase]" (...)
Quality: Ultra High Quality, 8k, ...
Subject: (Stylized 3D Character Art, Looney Tunes style fur shader), [CHARACTER], [Action], [Emotion]
Composition: [Camera angle]. Full Body framing.
Lighting: [Light style]. Atmospheric fog.
Camera: 35mm lens, f/1.8, Bokeh background.
Environment: [Description]
Style: STATE-OF-THE-ART CGI. ...
Negative Prompt: 2d, drawing, sketch, ...
```

---

## SECTION 5: IMAGE PROMPT (Horizontal 16:9)

Location: After Vertical prompt, separated by `---`

Identifier: Contains `Format: Horizontal 16:9`

Structure: Same as Vertical but with:
- `Format: Horizontal 16:9`
- `Composition: [Camera angle]. Wide framing.`
- `Camera: 50mm lens, f/2.8, cinematic motion blur.`

---

## SECTION 6: MUSIC SUGGESTION

Location: Last section of output

Structure:
```
🎶 [6-8 word style description]

⭐️ [Georgian phrase - same as Secondary Text in prompts]
```

---

## PARSING PSEUDOCODE

```python
def parse_alpha_news_output(raw_text):
    sections = {}
    
    # Split by main delimiters
    fb_start = raw_text.find("--- [START OF OUTPUT] ---")
    tg_start = raw_text.find("--- [TELEGRAM CONTENT STARTS HERE] ---")
    meta_start = raw_text.find("--- [META-COMMENTARY STARTS HERE] ---")
    
    # Extract Facebook content
    sections["facebook"] = raw_text[fb_start + len("--- [START OF OUTPUT] ---"):tg_start].strip()
    
    # Extract Telegram content
    sections["telegram"] = raw_text[tg_start + len("--- [TELEGRAM CONTENT STARTS HERE] ---"):meta_start].strip()
    
    # Extract Meta Commentary (until next ---)
    meta_end = raw_text.find("---", meta_start + len("--- [META-COMMENTARY STARTS HERE] ---"))
    sections["meta"] = raw_text[meta_start + len("--- [META-COMMENTARY STARTS HERE] ---"):meta_end].strip()
    
    # Extract Image Prompts by finding "Prompt:" and "Format:"
    prompts = raw_text[meta_end:].split("---")
    for p in prompts:
        if "Format: Vertical 9:16" in p:
            sections["image_vertical"] = p.strip()
        elif "Format: Horizontal 16:9" in p:
            sections["image_horizontal"] = p.strip()
        elif "🎶" in p:
            sections["music"] = p.strip()
    
    return sections
```

---

## KEY RULES FOR GENERATOR

1. NO MARKDOWN - No bold, no asterisks, no # in the output
2. PLAIN TEXT - Only emojis and plain Georgian/English text
3. EXACT DELIMITERS - Use the exact delimiter strings shown above
4. GEORGIAN SCRIPT - All main content in Georgian, brand names can be English
5. CLOSING LINE - Always include: `🫣 გსურთ რაღაც, რასაც აქ ვერ ნახავთ? იპოვეთ Andrew Altair Google-ში.`
6. HASHTAG FORMAT - `#word #word` (no spaces inside hashtag)

