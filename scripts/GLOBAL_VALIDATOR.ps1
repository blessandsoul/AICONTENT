<#
.SYNOPSIS
    GLOBAL SYSTEM VALIDATOR (The Sheriff)
.DESCRIPTION
    A modular validator that enforces:
    1. THE BIBLE (Global Rules for everyone)
    2. AGENT SPECIFIC RULES (Modular blocks)
.USAGE
    .\GLOBAL_VALIDATOR.ps1 -Path "path\to\content.md" -Agent "Alpha|Eden|Deep|Tutor"
#>

param(
    [Parameter(Mandatory = $true)][string]$Path,
    [Parameter(Mandatory = $true)][string]$Agent
)

$isJson = $Path.EndsWith(".json")
$contentRaw = Get-Content -Path $Path -Raw -Encoding UTF8
$contentToCheck = $contentRaw

if ($isJson) {
    try {
        $jsonObj = $contentRaw | ConvertFrom-Json
        # Extract all text content from "content" array
        $contentToCheck = ""
        if ($jsonObj.content) {
            foreach ($item in $jsonObj.content) {
                if ($item.content) {
                    $contentToCheck += $item.content + "`n"
                }
            }
        }
        # Also add meta fields to check for forbidden words
        if ($jsonObj.meta.title) { $contentToCheck += $jsonObj.meta.title + "`n" }
        if ($jsonObj.seo.excerpt) { $contentToCheck += $jsonObj.seo.excerpt + "`n" }
        
        Write-Host "📂 JSON MODE DETECTED: Parsed content fields." -ForegroundColor Cyan
    }
    catch {
        $violations += "❌ [JSON] INVALID JSON: Failed to parse file."
    }
}

$content = $contentToCheck

# ==========================================
# 🛡️ 1. THE BIBLE (CORE CHECK - ALL AGENTS)
# ==========================================
Write-Host "🔍 Сканирую по БИБЛИИ..." -ForegroundColor Cyan

# 1.1 Contrast Trap (STRICT USER BAN)
if ($content -match 'ეს არ არის .{1,50} ეს' -or $content -match 'არ არის .* არამედ') {
    $violations += "❌ [BIBLE] CONTRAST TRAP: 'Not X, but Y' detected. User HATES this. Use direct assertions!"
}
if ($content -match 'კარი იკვეთება') {
    $violations += "❌ [BIBLE] NONSENSE DETECTED: 'კარი იკვეთება' means nothing. Use 'კარი იკეტება'."
}
if ($content -match 'ეს არ არის') {
    $violations += "⚠️ [BIBLE] RISKY PHRASE: 'ეს არ არის' (This is not). Verify it's not a contrast trap. Consider rewriting."
}

# 1.2 Passive Voice
$passivePatterns = @('მიერაა', 'მიერ არის', 'იყო შექმნილი', 'არის შექმნილი', 'იქნა')
foreach ($p in $passivePatterns) {
    if ($content -match $p) {
        $violations += "❌ [BIBLE] PASSIVE VOICE: '$p' обнаружено."
    }
}

# 1.3 Calques
$calques = @('ადგილი აქვს', 'თამაშობს როლს', 'იმისათვის, რომ', 'პირველ ადგილზე', 'მიიღო გადაწყვეტილება', 'საკუთარი ყურები', 'დანაზოგებზე', 'არ დაიჯერო შენი')
foreach ($c in $calques) {
    if ($content -match [regex]::Escape($c)) {
        $violations += "❌ [BIBLE] BAD GEORGIAN: '$c'. User banned this phrase! Speak like a native."
    }
}

# 1.4 Barbarism Blacklist (Strict Ban on Anglicisms)
$barbarisms = @(
    'dalaikeba', 'laikebs', 'postavs', 'sheri', 'sharebs', 'dakomentareba', 'foloveri', 'folovebs',
    'subscribi', 'skrolavs', 'strimavs', 'kontenti', 'influenceri', 'stori', 'rilsi', 'fidi',
    'chati', 'mesiji', 'voisi', 'linki', 'tegi', 'tagavs', 'kepsheni', 'vlogi', 'svaipi',
    'skrini', 'skrinshoti', 'blokavs', 'reposti', 'aklonebs', 'bugi', 'fix', 'fixavs', 'apdeiti',
    'apgreidi', 'daaploadeba', 'daunloadebs', 'instalacia', 'klikavs', 'logini', 'logauti',
    'pasvordi', 'yuzeri', 'akaunti', 'softi', 'app', 'devaisi', 'faili', 'folderi', 'daseiveba',
    'diliti', 'edeitebs', 'dakoppireba', 'peisti', 'serveri', 'data', 'bekapi', 'dareseteba',
    'krashavs', 'frontendi', 'bekendi', 'artifishial', 'prompti', 'generireba', 'chatboti', 'tuli',
    'ficheri', 'solusheni', 'keisi', 'mitingi', 'koli', 'dedlaini', 'tasqi', 'skili', 'daskipva',
    'spichi', 'targeti', 'richi', 'ingiejmenti', 'fidbeki', 'brainstormingi', 'vorkshopi',
    'frilanseri', 'startapi', 'founderi', 'siio', 'ofisi', 'riviu', 'chelenji', 'vaibi', 'chilavs',
    'krinji', 'randomad', 'feiki', 'trendi', 'heiti', 'pranki', 'chekavs', 'ignorebs', 'bustavs',
    'join', 'muting', 'promoutebs', 'flexavs', 'shipebs'
)
foreach ($b in $barbarisms) {
    if ($content -match $b) {
        $violations += "❌ [BIBLE] BARBARISM DETECTED: '$b'. Use Georgian equivalent! (Checking linguistic_rules.md)"
    }
}

# 1.5 Colon Headlines
$nonCodeContent = $content -replace '```[\s\S]*?```', ''
if ($nonCodeContent -match '[\p{So}\p{Cs}]\s+[ა-ჰ\w]+.*?:\s') {
    $violations += "❌ [BIBLE] COLON HEADLINE: Замени ':' на ' - '"
}

# 1.5 Cyrillic Contamination
if ($content -match '[а-яА-ЯёЁ]') {
    $cyrillicMatches = [regex]::Matches($content, '\S*[а-яА-ЯёЁ]+\S*')
    foreach ($m in $cyrillicMatches) {
        if ($m.Value -notmatch 'Prompt|Format|Quality|Subject|Style|Archive|MEMORY_TAGS') {
            $violations += "❌ [BIBLE] CYRILLIC: '$($m.Value)'"
        }
    }
}

# 1.6 Bold Text (ALL AGENTS)
if ($nonCodeContent -match '\*\*') {
    $violations += "❌ [BIBLE] BOLD TEXT: ** обнаружено. Удали жирный текст."
}

# 1.7 Ellipsis Drama
if ($content -match '[ა-ჰa-zA-Z]\.\.\.\s*$' -or $content -match '[ა-ჰa-zA-Z]\.\.\.[\r\n]') {
    $violations += "❌ [BIBLE] ELLIPSIS DRAMA: '...' в конце предложения. Заверши мысль."
}

# 1.8 Rhetorical Questions
$rhetoricalPatterns = @('რას ნიშნავს.*\?', 'გიფიქრიათ.*\?', 'წარმოიდგინეთ.*\?', 'რა იქნება თუ.*\?')
foreach ($r in $rhetoricalPatterns) {
    if ($content -match $r) {
        $violations += "❌ [BIBLE] RHETORICAL Q: Риторический вопрос. Перепиши как утверждение."
    }
}

# 1.10 Tautology Check (Consecutive Line Starts)
$lines = $content -split '\r?\n' | Where-Object { $_ -notmatch '^\s*$' -and $_ -notmatch '^#|^\s*---' }
for ($i = 0; $i -lt $lines.Count - 1; $i++) {
    $currentLine = $lines[$i].Trim()
    $nextLine = $lines[$i + 1].Trim()
    
    # Get first 2 words
    $currentWords = $currentLine -split '\s+' | Select-Object -First 2
    $nextWords = $nextLine -split '\s+' | Select-Object -First 2
    
    if ($currentWords.Count -ge 2 -and $nextWords.Count -ge 2) {
        $firstTwoCurrent = "$($currentWords[0]) $($currentWords[1])"
        $firstTwoNext = "$($nextWords[0]) $($nextWords[1])"
        
        if ($firstTwoCurrent -eq $firstTwoNext) {
            $violations += "❌ [BIBLE] TAUTOLOGY: Consecutive lines start with '$firstTwoCurrent'. Vary your sentence structure!"
        }
    }
}

# 1.10 Gamer Slang Ban (ALL AGENTS)
if ($content -match "nerfed|buffed|OP\s|broken|nerf") {
    $violations += "❌ [BIBLE] GAMER SLANG: 'nerfed/buffed/OP/broken' запрещены. Будь профессионалом."
}

# 1.11 Georgian Language Check (ALL AGENTS)
# Check for long English-only sequences (50+ chars without Georgian)
if ($nonCodeContent -match '[A-Za-z\s]{50,}') {
    $englishMatches = [regex]::Matches($nonCodeContent, '[A-Za-z\s]{50,}')
    foreach ($m in $englishMatches) {
        # Skip if it's in a prompt block or brand name
        if ($m.Value -notmatch 'Prompt|Format|Quality|Subject|Style|Negative|Camera|Lighting|Environment|Composition') {
            $violations += "⚠️ [BIBLE] LONG ENGLISH: Найден длинный английский текст. Контент должен быть на грузинском!"
        }
    }
}

# 1.12 Georgian Hashtags ONLY (ALL AGENTS)
# Check that hashtags are in Georgian script (except brand names)
$hashtagMatches = [regex]::Matches($content, '#[\w\p{L}]+')
$allowedBrands = @('AI', 'OpenAI', 'ChatGPT', 'Claude', 'Google', 'Gemini', 'AndrewAltair', 'GPT', 'Perplexity', 'Grok', 'ElonMusk', 'xAI', 'Meta', 'Apple', 'Microsoft', 'Anthropic', 'DeepMind', 'Neuralink', 'Tesla', 'SpaceX', 'TikTok', 'YouTube', 'Facebook', 'Instagram')
$englishHashtags = @()
foreach ($h in $hashtagMatches) {
    $tag = $h.Value -replace '^#', ''
    # If tag is all Latin letters and NOT a brand
    if ($tag -match '^[A-Za-z0-9]+$' -and $tag -notin $allowedBrands) {
        $englishHashtags += "#$tag"
    }
}
if ($englishHashtags.Count -gt 0) {
    $violations += "❌ [BIBLE] ENGLISH HASHTAGS: Только грузинские хэштеги! Замени: $($englishHashtags -join ', ')"
}

# 1.13 Hashtag Count (ALL AGENTS) — Minimum 10
if ($hashtagMatches.Count -lt 10 -and $hashtagMatches.Count -gt 0) {
    $violations += "❌ [BIBLE] HASHTAG COUNT: Минимум 10 хэштегов! Найдено: $($hashtagMatches.Count)"
}

# ==========================================
# 🧩 2. AGENT MODULES
# ==========================================

switch ($Agent) {
    "Alpha" {
        Write-Host "🔍 Сканирую по ALPHA NEWS протоколам..." -ForegroundColor Cyan
        # Alpha: Check for visual strategy in prompts
        $prompts = [regex]::Matches($content, '```[\s\S]*?```') | ForEach-Object { $_.Value }
        $strategies = @("staring directly into", "Tilt-Shift", "Datamoshing", "Fisheye Lens", "Renaissance painting")
        $hasStrategy = $false
        foreach ($s in $strategies) {
            if ($prompts -match $s) { $hasStrategy = $true; break }
        }
        if (-not $hasStrategy -and $prompts.Count -gt 0) {
            $violations += "⚠️ [ALPHA] VISUAL STRATEGY: Добавь агрессивные модификаторы в промпт."
        }

        # Alpha: HOOK POST LENGTH VALIDATION (500-1000 chars)
        # SKIP for JSON files (Deep Dive has different rules)
        if (-not $isJson) {
            # Remove prompts, code blocks, hashtags, and metadata from count
            $hookClean = $content -replace '```[\s\S]*?```', '' -replace 'Prompt[\s\S]*?Negative Prompt:[^\n]+', '' -replace '#[\w\p{L}]+', '' -replace '---[\s\S]*?---', ''
            $hookLength = $hookClean.Trim().Length
            
            if ($hookLength -lt 500) {
                $violations += "❌ [ALPHA] HOOK POST LENGTH: Минимум 500 символов! Найдено: $hookLength"
            }
            if ($hookLength -gt 1200) {
                $violations += "⚠️ [ALPHA] HOOK POST TOO LONG: Максимум 1000 символов! Найдено: $hookLength"
            }
        }
        else {
            # JSON Specific Checks for Alpha (Deep Dive = 15,000-20,000 chars)
            $jsonLength = $content.Length
            if ($jsonLength -lt 15000) {
                $violations += "❌ [ALPHA] DEEP DIVE LENGTH: Минимум 15,000 символов! Найдено: $jsonLength"
            }
            if ($jsonLength -gt 22000) {
                $violations += "⚠️ [ALPHA] DEEP DIVE TOO LONG: Рекомендуемый максимум 20,000 символов! Найдено: $jsonLength"
            }

            # Alpha: Category Validation (Must be Georgian)
            $validCategories = @('ბიზნესი', 'ტექნოლოგიები', 'ეკონომიკა', 'პოლიტიკა', 'საზოგადოება', 'მეცნიერება', 'განათლება', 'მსოფლიო')
            if ($jsonObj.meta.category -notin $validCategories) {
                 $violations += "❌ [ALPHA] INVALID CATEGORY: '$($jsonObj.meta.category)' не валидна. Используй: $($validCategories -join ', ')"
            }
        }
    }

    "Eden" {
        Write-Host "🔍 Сканирую по EDEN AI протоколам..." -ForegroundColor Cyan
        # Eden: Must have Memory Tags
        if ($content -notmatch '<!-- MEMORY_TAGS') {
            $violations += "❌ [EDEN] MEMORY TAGS отсутствуют в конце файла."
        }
        # Eden: Check for audio.md (only Eden has music)
        $directory = Split-Path -Path $Path -Parent
        $audioPath = Join-Path -Path $directory -ChildPath "audio.md"
        if (-not (Test-Path $audioPath)) {
            $violations += "❌ [EDEN] audio.md ОТСУТСТВУЕТ. Только Eden генерирует музыку!"
        }
        
        # Eden: DESCRIPTION POST LENGTH (500-1000 chars)
        # Parse description_post.md content (before hashtags and metadata)
        $beforeHashtags = ($content -split '\n#[A-Za-zა-ჰ]')[0]
        $descriptionClean = $beforeHashtags -replace '```[\s\S]*?```', '' -replace '---[\s\S]*?---', '' -replace '<!-- MEMORY_TAGS[\s\S]*-->', '' -replace '\r?\n', ' '
        $descriptionClean = $descriptionClean.Trim()
        if ($descriptionClean.Length -lt 500) {
            $violations += "❌ [EDEN] DESCRIPTION LENGTH: Минимум 500 символов! Найдено: $($descriptionClean.Length)"
        }
        if ($descriptionClean.Length -gt 1200) {
            $violations += "⚠️ [EDEN] DESCRIPTION TOO LONG: Рекомендуемый максимум 1000 символов! Найдено: $($descriptionClean.Length)"
        }
        
        # Eden: FIRST COMMENT CHECK
        if ($content -notmatch 'პირველი კომენტარი:|First Comment:') {
            $violations += "❌ [EDEN] FIRST COMMENT: Отсутствует первый комментарий для разжигания дискуссии!"
        }
        
        # =============================================
        # 🆕 NEW EDEN-SPECIFIC CHECKS (2026-01-23)
        # =============================================
        
        # Eden: HOOK REPETITION CHECK (Detect "შენი შვილი" overuse)
        $hookPatterns = @('შენი შვილი', 'შენი შვილის', 'შენ გგონია', 'შენი ფსიქიკა', 'შენი ტელეფონი')
        $hookCount = 0
        foreach ($h in $hookPatterns) {
            $hookCount += ([regex]::Matches($content, $h)).Count
        }
        if ($hookCount -gt 3) {
            $violations += "❌ [EDEN] HOOK FATIGUE: Слишком много 'შენი...' паттернов ($hookCount). Vary your hooks! Use Cold Fact or Prophecy."
        }
        
        # Eden: RED EMOJI OVERLOAD CHECK
        $redEmojis = @('🛑', '⛔', '🚨', '❌', '🔴')
        $redEmojiCount = 0
        foreach ($e in $redEmojis) {
            $redEmojiCount += ([regex]::Matches($content, $e)).Count
        }
        if ($redEmojiCount -gt 2) {
            $violations += "⚠️ [EDEN] RED EMOJI OVERLOAD: Слишком много красных эмодзи ($redEmojiCount). Они раздражают! Используй ⚠️ или 💀."
        }
        
        # Eden: WEAK FIRST COMMENT CHECK (Lazy CTA detection)
        if ($content -match 'პირველი კომენტარი:') {
            $firstCommentSection = ($content -split 'პირველი კომენტარი:')[1]
            if ($firstCommentSection) {
                $firstCommentClean = ($firstCommentSection -split '---')[0].Trim()
                # Check for weak patterns
                if ($firstCommentClean -match 'რამდენ დროს|რას ფიქრობ|შეაფასე 1-10|გნებავთ') {
                    $violations += "❌ [EDEN] WEAK FIRST COMMENT: Вопрос слишком банальный! Используй CTA к сайту или провокацию."
                }
                # Check for length (too short = lazy)
                if ($firstCommentClean.Length -lt 50) {
                    $violations += "⚠️ [EDEN] SHORT FIRST COMMENT: Первый комментарий слишком короткий ($($firstCommentClean.Length) символов)."
                }
            }
        }

        # Eden: ANDREWALTAIR.GE BRANDING CHECK
        if ($content -notmatch 'AndrewAltair\.ge|ANDREWALTAIR\.GE|ჩემს საიტზე') {
            $violations += "⚠️ [EDEN] BRANDING MISSING: Нет упоминания сайта AndrewAltair.ge в посте!"
        }
    }

    "Deep" {
        Write-Host "🔍 Сканирую по DEEP SCIENCE протоколам..." -ForegroundColor Cyan
        # Deep: Must have Tilt-Shift markers
        # Deep: Must have Tilt-Shift markers
        if ($content -match 'Prompt:' -and $content -notmatch 'Tilt-shift|Macro|Miniature|Diorama') {
            $violations += "⚠️ [DEEP] MINIATURE STYLE: Промпт должен содержать Tilt-shift/Macro/Diorama."
        }
        
        # Deep: HOOK POST LENGTH VALIDATION (500-1000 chars) - Mirrors Alpha
        if (-not $isJson) {
            # Remove prompts, code blocks, hashtags, and metadata from count
            $hookClean = $content -replace '```[\s\S]*?```', '' -replace 'Prompt[\s\S]*?Negative Prompt:[^\n]+', '' -replace '#[\w\p{L}]+', '' -replace '---[\s\S]*?---', ''
            $hookLength = $hookClean.Trim().Length
            
            if ($hookLength -lt 500) {
                $violations += "❌ [DEEP] HOOK POST LENGTH: Минимум 500 символов! Найдено: $hookLength"
            }
            if ($hookLength -gt 1200) {
                $violations += "⚠️ [DEEP] HOOK POST TOO LONG: Максимум 1000 символов! Найдено: $hookLength"
            }
        }
        else {
            # JSON Specific Checks for Deep (Deep Dive = 15,000-20,000 chars)
            $jsonLength = $content.Length
            if ($jsonLength -lt 15000) {
                $violations += "❌ [DEEP] DEEP DIVE LENGTH: Минимум 15,000 символов! Найдено: $jsonLength"
            }
            if ($jsonLength -gt 22000) {
                $violations += "⚠️ [DEEP] DEEP DIVE TOO LONG: Рекомендуемый максимум 20,000 символов! Найдено: $jsonLength"
            }
        }
    }

    "Tutor" {
        Write-Host "🔍 Сканирую по ALPHA TUTOR протоколам..." -ForegroundColor Cyan
        # Tutor: Check for Blueprint style markers
        if ($content -match 'Prompt:' -and $content -notmatch 'Blueprint|schematic|architectural|grid paper') {
            $violations += "⚠️ [TUTOR] BLUEPRINT STYLE: Промпт должен содержать Blueprint/schematic стиль."
        }
        # Tutor: Georgian language check
        if ($content -match '^[A-Za-z]{50,}') {
            $violations += "⚠️ [TUTOR] LANGUAGE: Контент должен быть на грузинском!"
        }
    }

    "Prompt" {
        Write-Host "🔍 Сканирую по PROMPT MASTER протоколам..." -ForegroundColor Cyan
        # Prompt Master: Check for gender-neutral language
        if ($content -match '\b(man|woman|he|she|his|her|boy|girl)\b') {
            $violations += "❌ [PROMPT] GENDER WORDS: Используй нейтральные 'The Subject', 'The Character', 'The Model'!"
        }
        # Prompt Master: Check for ANDREWALTAIR.GE branding
        if ($content -notmatch 'ANDREWALTAIR\.GE|AndrewAltair\.GE') {
            $violations += "❌ [PROMPT] BRANDING: Отсутствует 'ANDREWALTAIR.GE' в промпте!"
        }
        # Prompt Master: Check for aspect ratio
        if ($content -match '```' -and $content -notmatch '--ar\s+(16:9|9:16)') {
            $violations += "❌ [PROMPT] ASPECT RATIO: Добавь --ar 16:9 или --ar 9:16!"
        }
        # Prompt Master: Check for version
        if ($content -match '```' -and $content -notmatch '--v\s+6') {
            $violations += "❌ [PROMPT] VERSION: Добавь --v 6.0!"
        }
        # Prompt Master: Check for exactly 3 categories
        $categoryMatches = [regex]::Matches($content, '📂.*?კატეგორიები[\s\S]*?(🎨|📸|🖌️|✨|📈|💻|💼|🧊|👗|🎮|📦)')
        # Simple check - look for category section
        if ($content -match 'კატეგორიები' -and ($content -split '(🎨|📸|🖌️|✨|📈|💻|💼|🧊|👗|🎮|📦)').Count -lt 4) {
            $violations += "⚠️ [PROMPT] CATEGORIES: Нужно ровно 3 категории!"
        }
    }

    "Architect" {
        Write-Host "🔍 Сканирую по ALPHA ARCHITECT протоколам..." -ForegroundColor Cyan
        # Architect: Check for course structure elements
        if ($content -match 'მოდული|Module' -and $content -notmatch 'მიზანი|Goal') {
            $violations += "⚠️ [ARCHITECT] MODULE STRUCTURE: Каждый модуль должен иметь цель (მიზანი)!"
        }
        # Architect: Check for homework
        if ($content -match 'მოდული|Module' -and $content -notmatch 'დავალება|Homework|Action') {
            $violations += "⚠️ [ARCHITECT] HOMEWORK: Модули должны иметь домашние задания!"
        }
    }

    "OnGe" {
        Write-Host "🔍 Сканирую по ALPHA ONGE протоколам..." -ForegroundColor Cyan
        # OnGe: No swearing
        $swearWords = @('fuck', 'shit', 'damn', 'hell', 'ჯანდაბა', 'წყეულა', 'შევეცი')
        foreach ($sw in $swearWords) {
            if ($content -match $sw) {
                $violations += "❌ [ONGE] SWEARING: '$sw' запрещено! OnGe = чистый контент."
            }
        }
        # OnGe: Check for Trojan Horse CTA (soft sell)
        if ($content -match 'იყიდე|შეიძინე|Buy now') {
            $violations += "⚠️ [ONGE] HARD SELL: Используй soft CTA, не прямые продажи!"
        }
    }

    "Brain" {
        Write-Host "🔍 Сканирую по SECOND BRAIN протоколам..." -ForegroundColor Cyan
        # Brain: This is a personal advisor, minimal content checks
        # Just ensure it's conversational
        Write-Host "ℹ️ Second Brain = личный советник. Минимальные проверки." -ForegroundColor Gray
    }

    "Explore" {
        Write-Host "🔍 Сканирую по EXPLORE протоколам..." -ForegroundColor Cyan
        # Explore: This is a conversational agent, minimal content checks
        Write-Host "ℹ️ Explore = разговорный агент. Минимальные проверки." -ForegroundColor Gray
    }

    Default {
        Write-Host "⚠️ UNKNOWN AGENT: Применены только проверки Библии." -ForegroundColor Yellow
    }
}

# ==========================================
# 📋 3. FIRST COMMENT CHECK (ALL AGENTS)
# ==========================================
# Relaxed check - just verify content has substantial text after all separators
# SKIP for JSON
if (-not $isJson) {
    $afterTelegram = $content -split '---\s*\[TELEGRAM|--- \[START OF TELEGRAM' | Select-Object -Last 1
    if ($afterTelegram.Length -lt 100) {
        $violations += "⚠️ [ALL] FIRST COMMENT: Проверь наличие первого комментария."
    }
}

# ==========================================
# 🏁 VERDICT
# ==========================================
Write-Host ""
Write-Host "═══════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  GLOBAL VALIDATOR - $Agent | $Path" -ForegroundColor Cyan
Write-Host "═══════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

if ($violations.Count -eq 0) {
    Write-Host "✅ ВСЕ ПРОВЕРКИ ПРОЙДЕНЫ. БИБЛИЯ СОБЛЮДЕНА." -ForegroundColor Green
    exit 0
}
else {
    Write-Host "🚨 НАРУШЕНИЙ: $($violations.Count)" -ForegroundColor Red
    Write-Host ""
    foreach ($v in $violations) {
        Write-Host $v -ForegroundColor Yellow
    }
    Write-Host ""
    Write-Host "ИСПРАВЬ ПЕРЕД ПУБЛИКАЦИЕЙ!" -ForegroundColor Red
    exit 1
}
