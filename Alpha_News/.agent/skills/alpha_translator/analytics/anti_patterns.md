# 🚫 Anti-Pattern Library

This file documents specific failures and "hallucinations" the agent has made, to prevent repetition.
CHECK THIS FILE BEFORE EVERY GENERATION.

## 1. The "Code Block CTA" Error
Context: Agent sees ` ``` ` in the template's CTA example and thinks it's part of the design.
Pattern to Avoid:
```markdown
```
🔗 Link...
```
```
Correct Pattern:
```markdown
🔗 Link...
```
Fix: CTA & Hashtags must be PLAIN TEXT.

## 2. The "Loose Paragraph" Error
Context: Agent writes free-flowing paragraphs in the body to "increase flow".
Pattern to Avoid:
> "The chip market is changing fast. Nvidia is losing ground..." (No Emoji/Headline)
Correct Pattern:
> "📉 Market Shift: The chip market is changing fast..."
Fix: EVERY paragraph in the main body MUST start with `[Emoji] [Headline]:`.

## 3. The "Pseudo-Contrast" Error
Context: Agent tries to sound dramatic using "Not X, but Y".
Pattern to Avoid:
> "This is not just a chip. This is a revolution."
Correct Pattern:
> "This is a revolution."
Fix: Delete the "Not X" part. State the "Y" directly.

## 4. The "Under-Length" Error
Context: Agent writes ~2000 chars thinking it's "enough".
Pattern to Avoid:
> Finishing the Facebook section after 3 main points.
Correct Pattern:
> Expanding "Deep Analysis" sections. Adding more specific technical details (specs, dates, money amounts).
Fix: If text < 3500 chars, EXPAND.

## 5. The "Example Literalism" Error
Context: Agent copies placeholder text or structure from `output_structure.md` literally.
Pattern to Avoid:
> Using the specific emojis from the template example instead of choosing new ones.
Fix: Treat templates as STRUCTURE, not CONTENT.

