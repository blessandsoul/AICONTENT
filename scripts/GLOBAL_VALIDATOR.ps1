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

$content = Get-Content -Path $Path -Raw -Encoding UTF8
$violations = @()

# ==========================================
# 🛡️ 1. THE BIBLE (CORE CHECK - ALL AGENTS)
# ==========================================
Write-Host "🔍 Сканирую по БИБЛИИ..." -ForegroundColor Cyan

# 1.1 Contrast Trap
if ($content -match 'ეს არ არის .{1,70} ეს (არის|გახლავთ)') {
    $violations += "❌ [BIBLE] CONTRAST TRAP: 'ეს არ არის... ეს არის' структура обнаружена."
}

# 1.2 Passive Voice
$passivePatterns = @('მიერაა', 'მიერ არის', 'იყო შექმნილი', 'არის შექმნილი', 'იქნა')
foreach ($p in $passivePatterns) {
    if ($content -match $p) {
        $violations += "❌ [BIBLE] PASSIVE VOICE: '$p' обнаружено."
    }
}

# 1.3 Calques
$calques = @('ადგილი აქვს', 'თამაშობს როლს', 'იმისათვის, რომ', 'პირველ ადგილზე', 'მიიღო გადაწყვეტილება')
foreach ($c in $calques) {
    if ($content -match [regex]::Escape($c)) {
        $violations += "❌ [BIBLE] CALQUE: '$c'. Используй естественный грузинский."
    }
}

# 1.4 Colon Headlines
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

        # Alpha: HASHTAG VALIDATION
        $hashtagMatches = [regex]::Matches($content, '#[\w\p{L}]+')
        $hashtagCount = $hashtagMatches.Count
        if ($hashtagCount -lt 10) {
            $violations += "❌ [ALPHA] HASHTAGS: Минимум 10 хэштегов! Найдено: $hashtagCount"
        }
        
        # Alpha: Check for English-only hashtags (excluding brand names)
        $allowedEnglish = @('AI', 'OpenAI', 'ChatGPT', 'Claude', 'Google', 'Gemini', 'AndrewAltair', 'GPT', 'Perplexity')
        $englishOnlyHashtags = @()
        foreach ($h in $hashtagMatches) {
            $tag = $h.Value -replace '^#', ''
            # If tag is all Latin letters and NOT in allowed list
            if ($tag -match '^[A-Za-z0-9]+$' -and $tag -notin $allowedEnglish) {
                $englishOnlyHashtags += "#$tag"
            }
        }
        if ($englishOnlyHashtags.Count -gt 0) {
            $violations += "❌ [ALPHA] ENGLISH HASHTAGS: Замени на грузинские! $($englishOnlyHashtags -join ', ')"
        }

        # Alpha: CHARACTER LENGTH VALIDATION
        # Split content into Facebook and Telegram sections
        $sections = $content -split '---'
        $facebookSection = $sections[0]
        $telegramSection = if ($sections.Count -gt 1) { $sections[1] } else { "" }
        
        # Remove prompts and code blocks from count
        $fbClean = $facebookSection -replace '```[\s\S]*?```', '' -replace 'Prompt:[\s\S]*?Negative Prompt:[^\n]+', ''
        $tgClean = $telegramSection -replace '```[\s\S]*?```', ''
        
        $fbLength = $fbClean.Length
        $tgLength = $tgClean.Length
        
        if ($fbLength -lt 3500) {
            $violations += "❌ [ALPHA] FACEBOOK LENGTH: Минимум 3500 символов! Найдено: $fbLength"
        }
        if ($tgLength -gt 0 -and $tgLength -lt 750) {
            $violations += "❌ [ALPHA] TELEGRAM LENGTH: Минимум 750 символов! Найдено: $tgLength"
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
        
        # Eden: MINIMUM DESCRIPTION LENGTH (500 chars)
        # Get content before hashtags line (starts with #)
        $beforeHashtags = ($content -split '\n#[A-Za-zა-ჰ]')[0]
        $descriptionClean = $beforeHashtags -replace '```[\s\S]*?```', '' -replace '---[\s\S]*?---', '' -replace '<!-- MEMORY_TAGS[\s\S]*-->', '' -replace '\r?\n', ' '
        $descriptionClean = $descriptionClean.Trim()
        if ($descriptionClean.Length -lt 500) {
            $violations += "❌ [EDEN] DESCRIPTION LENGTH: Минимум 500 символов! Найдено: $($descriptionClean.Length)"
        }
        
        # Eden: FIRST COMMENT CHECK
        if ($content -notmatch 'პირველი კომენტარი:|First Comment:') {
            $violations += "❌ [EDEN] FIRST COMMENT: Отсутствует первый комментарий для разжигания дискуссии!"
        }
        
        # Eden: HASHTAG CHECK (Only brand names in English)
        $hashtagMatches = [regex]::Matches($content, '#[\w\p{L}]+')
        $allowedEnglish = @('Grok', 'AI', 'OpenAI', 'ChatGPT', 'Claude', 'Google', 'Gemini', 'AndrewAltair', 'GPT', 'Perplexity', 'ElonMusk', 'EdenAI', 'xAI', 'Meta', 'Apple', 'Microsoft', 'Anthropic', 'DeepMind', 'Neuralink', 'Tesla', 'SpaceX')
        $englishOnlyHashtags = @()
        foreach ($h in $hashtagMatches) {
            $tag = $h.Value -replace '^#', ''
            # If tag is all Latin letters and NOT in allowed list
            if ($tag -match '^[A-Za-z0-9]+$' -and $tag -notin $allowedEnglish) {
                $englishOnlyHashtags += "#$tag"
            }
        }
        if ($englishOnlyHashtags.Count -gt 0) {
            $violations += "❌ [EDEN] ENGLISH HASHTAGS: Замени на грузинские! $($englishOnlyHashtags -join ', ')"
        }
    }

    "Deep" {
        Write-Host "🔍 Сканирую по DEEP SCIENCE протоколам..." -ForegroundColor Cyan
        # Deep: No "Gamer" slang
        if ($content -match "nerfed|buffed|OP\s|broken|nerf") {
            $violations += "❌ [DEEP] GAMER SLANG: Будь научным, без геймерского сленга."
        }
        # Deep: Must have Tilt-Shift markers
        if ($content -match 'Prompt:' -and $content -notmatch 'Tilt-shift|Macro|Miniature|Diorama') {
            $violations += "⚠️ [DEEP] MINIATURE STYLE: Промпт должен содержать Tilt-shift/Macro/Diorama."
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

    Default {
        Write-Host "⚠️ UNKNOWN AGENT: Применены только проверки Библии." -ForegroundColor Yellow
    }
}

# ==========================================
# 📋 3. FIRST COMMENT CHECK (ALL AGENTS)
# ==========================================
# Relaxed check - just verify content has substantial text after all separators
$afterTelegram = $content -split '---\s*\[TELEGRAM|--- \[START OF TELEGRAM' | Select-Object -Last 1
if ($afterTelegram.Length -lt 100) {
    $violations += "⚠️ [ALL] FIRST COMMENT: Проверь наличие первого комментария."
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
