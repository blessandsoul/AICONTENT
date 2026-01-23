# Prompt Engineering Protocol

## Image Prompt Structure

```
[Subject] + [Style] + [Mood] + [Lighting] + [Composition] + [Quality]
```

## Key Elements

### Subject
Be specific about what you want:
- "A woman" → "A 30-year-old woman with curly red hair"
- "A city" → "A futuristic Tokyo-inspired megacity"

### Style
Define the artistic approach:
- Photorealistic, digital art, oil painting, watercolor
- Anime, cartoon, 3D render, sketch
- Specific artist styles (when appropriate)

### Mood/Atmosphere
Set the emotional tone:
- Dramatic, peaceful, mysterious, joyful
- Dark and moody, bright and cheerful
- Ethereal, gritty, nostalgic

### Lighting
Specify light conditions:
- Golden hour, blue hour, harsh midday
- Neon lights, candlelight, moonlight
- Rim lighting, backlighting, soft diffused

### Composition
Define framing:
- Close-up, medium shot, wide angle
- Bird's eye view, low angle, straight on
- Rule of thirds, centered, dynamic

### Quality Modifiers
Add technical quality:
- 8k, ultra detailed, masterpiece
- Cinematic, professional photography
- Sharp focus, bokeh background

---

## Platform-Specific Tips

### Midjourney
- Use `--ar 16:9` for aspect ratio
- Use `--v 6` for version
- Use `--style raw` for less stylized

### DALL-E
- Be descriptive but not overly complex
- Avoid brand names
- Specify "digital art" or "photograph"

### Flux/Grok
- Natural language descriptions
- Specify dimensions in text: "9:16 vertical"
- Avoid technical parameters

---

## Prompt Templates

### Product Shot
```
[Product] on [surface], [lighting style] lighting, [background], professional product photography, 8k, sharp focus
```

### Portrait
```
Portrait of [subject description], [expression], [lighting], [background], [style], professional photography
```

### Environment
```
[Location type], [time of day], [weather/atmosphere], [style], cinematic, wide angle, detailed
```

### Abstract
```
Abstract [concept], [color palette], [texture], [mood], digital art, 8k
```
