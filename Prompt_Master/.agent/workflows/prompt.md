---
description: Generate Midjourney prompt with Georgian SMM post for marketplace
---

# /prompt Workflow

## Prerequisites
- Read SKILL.md: `C:\Users\User\Desktop\AICONTENT\Prompt_Master\.agent\skills\prompt_master\SKILL.md`
- Read visual strategies: `C:\Users\User\Desktop\AICONTENT\Prompt_Master\.agent\skills\prompt_master\visual_strategies.md`

## Workflow Steps

### 1. Understand the Request
- Parse user's image concept/idea
- Identify key elements: subject, environment, mood, style
- Select appropriate visual strategy from database

### 2. Generate Content
Create complete output following SKILL.md protocols:

**A. Georgian SMM Post:**
- Epic Georgian/mixed title (CAPS)
- 2-sentence selling description
- Exactly 3 categories from database
- How to get section with 6-digit code
- 15 Georgian hashtags

**B. Midjourney Prompt:**
- LAYER 1: Subject (gender-neutral)
- LAYER 2: Environment + Text Integration (title + ANDREWALTAIR.GE)
- LAYER 3: Lighting & Camera
- LAYER 4: Technical (--ar 16:9 --v 6.0)

**C. First Comment:**
- 2-3 engaging sentences in Georgian
- Question or curiosity hook

### 3. Create Output Files
// turbo
```powershell
$date = Get-Date -Format "yyyyMMdd"
$folder = "C:\Users\User\Desktop\AICONTENT\Prompt_Master\output\published\${date}_[short_name]"
New-Item -ItemType Directory -Path $folder -Force
```

Save files:
- `post.md` - Full SMM post with prompt block
- `prompt.md` - Clean Midjourney prompt only
- `comment.md` - First comment
- `results.md` - Empty performance template

### 4. Validate Output
// turbo
```powershell
& "C:\Users\User\Desktop\AICONTENT\Prompt_Master\.agent\skills\prompt_master\validate_prompt.ps1" -PostPath "[path_to_post.md]"
```

### 5. Final Check
Verify all protocols:
- [ ] ANDREWALTAIR.GE in prompt
- [ ] --ar 16:9 present
- [ ] --v 6.0 present
- [ ] No gender words in prompt
- [ ] Exactly 3 categories
- [ ] 15 Georgian hashtags
- [ ] 6-digit random code
- [ ] Title used in prompt text integration

## Output Structure
```
Prompt_Master/output/content/YYYYMMDD_short_name/
├── post.md
├── prompt.md
├── comment.md
└── results.md
```

