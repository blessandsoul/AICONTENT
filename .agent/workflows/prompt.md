---
description: Generate Midjourney prompt with Georgian SMM post for marketplace
---

# /prompt Workflow

## Prerequisites
Read these files FIRST:
1. `C:\Users\User\Desktop\AICONTENT\Prompt_Master\.agent\skills\prompt_master\SKILL.md`
2. `C:\Users\User\Desktop\AICONTENT\Prompt_Master\.agent\skills\prompt_master\visual_strategies.md`

## Activation
You are now **Prompt Master**. Adopt the persona and follow all protocols from SKILL.md strictly.

## Workflow Steps

### 1. Understand the Request
- Parse user's image concept/idea
- Identify: subject, environment, mood, style
- Select visual strategy from database

### 2. Generate Content (Following SKILL.md)

**A. Georgian SMM Post:**
- Epic title (Georgian or mixed, CAPS)
- 2-sentence selling description
- Exactly 3 categories
- How-to-get section with 6-digit code
- 15 Georgian hashtags

**B. Midjourney Prompt (4 Layers):**
- LAYER 1: Subject (gender-neutral only!)
- LAYER 2: Environment + Text Integration
- LAYER 3: Lighting & Camera (luxury)
- LAYER 4: Technical (--ar 16:9 --v 6.0)

**C. First Comment:**
- 2-3 engaging Georgian sentences
- No headers, plain text

**D. SOC.MD (Viral Hooks):**
- Generate 5 specific viral lines as per SKILL.md [Section 7]


### 3. Create Output Folder
// turbo
```powershell
$date = Get-Date -Format "yyyyMMdd"
$name = "[short_descriptive_name]"
$folder = "C:\Users\User\Desktop\AICONTENT\Prompt_Master\output\published\${date}_${name}"
New-Item -ItemType Directory -Path $folder -Force
```

### 4. Save Files
- `post.md` - Complete SMM post with prompt in code block
- `prompt.md` - Clean Midjourney prompt only
- `comment.md` - First comment text
- `soc.md` - Viral hooks and headlines
- `results.md` - Performance tracking template

### 5. Validate
// turbo
```powershell
& "C:\Users\User\Desktop\AICONTENT\Prompt_Master\.agent\skills\prompt_master\validate_prompt.ps1" -PostPath "[FULL_PATH_TO_POST.MD]"
```

## Critical Protocols
- ✅ ANDREWALTAIR.GE must be in prompt
- ✅ --ar 16:9 OR 9:16 always
- ✅ --v 6.0 always  
- ✅ NO gender words (man/woman/he/she) — use "The Subject"
- ✅ Exactly 3 categories
- ✅ 15 Georgian hashtags
- ✅ Random 6-digit code

