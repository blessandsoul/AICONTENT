<#
.SYNOPSIS
    Alpha News Linguistic Validator
.DESCRIPTION
    Scans post.md for banned patterns. Returns non-zero exit code if violations found.
.USAGE
    .\validate_post.ps1 -Path "path\to\post.md"
#>

param(
    [Parameter(Mandatory = $true)]
    [string]$Path
)

$directory = Split-Path -Path $Path -Parent
$audioPath = Join-Path -Path $directory -ChildPath "audio.md"

if (-not (Test-Path $audioPath)) {
    Write-Host "❌ CRITICAL ERROR: 'audio.md' is MISSING in $directory" -ForegroundColor Red
    exit 1
}

$content = Get-Content -Path $Path -Raw -Encoding UTF8

$violations = @()

# 1. Contrast Trap (Georgian)
if ($content -match 'ეს არ არის .{1,50} ეს (არის|გახლავთ)') {
    $violations += "❌ CONTRAST TRAP: 'ეს არ არის... ეს არის' pattern detected"
}

# 2. Passive Voice markers
$passivePatterns = @('მიერაა', 'მიერ არის', 'იყო შექმნილი', 'არის შექმნილი', 'იქნა')
foreach ($p in $passivePatterns) {
    if ($content -match $p) {
        $violations += "❌ PASSIVE VOICE: '$p' detected"
    }
}

# 3. Mixed Script (Georgian + Latin/Cyrillic in same word)
# Match Georgian letter followed by Latin/Cyrillic or vice versa
if ($content -match '[ა-ჰ][a-zA-Zа-яА-ЯёЁ]|[a-zA-Zа-яА-ЯёЁ][ა-ჰ]') {
    $matches = [regex]::Matches($content, '\S*[ა-ჰ][a-zA-Zа-яА-ЯёЁ]\S*|\S*[a-zA-Zа-яА-ЯёЁ][ა-ჰ]\S*')
    foreach ($m in $matches) {
        $violations += "❌ MIXED SCRIPT: '$($m.Value)' - Georgian mixed with Latin/Cyrillic"
    }
}

# 4. Cyrillic contamination (standalone check)
if ($content -match '[а-яА-ЯёЁ]') {
    $cyrillicMatches = [regex]::Matches($content, '\S*[а-яА-ЯёЁ]+\S*')
    foreach ($m in $cyrillicMatches) {
        # Skip if it's in a code block or prompt section
        if ($m.Value -notmatch 'Prompt|Format|Primary|Secondary|Quality|Subject') {
            $violations += "❌ CYRILLIC DETECTED: '$($m.Value)'"
        }
    }
}

# 5. Calques
$calques = @('ადგილი აქვს', 'თამაშობს როლს', 'იმისათვის, რომ', 'პირველ ადგილზე')
foreach ($c in $calques) {
    if ($content -match [regex]::Escape($c)) {
        $violations += "❌ CALQUE: '$c' - use natural Georgian"
    }
}

# 6. Bold text (asterisks) - but not in code blocks
$nonCodeContent = $content -replace '```[\s\S]*?```', ''
if ($nonCodeContent -match '\*\*') {
    $violations += "❌ BOLD TEXT: ** detected outside code blocks"
}

# 7. Colon in headlines (emoji followed by text and colon)
if ($nonCodeContent -match '[\p{So}\p{Cs}]\s+[ა-ჰ\w]+.*?:\s') {
    $violations += "❌ COLON HEADLINE: Use ' - ' instead of ':'"
}

# 8. Rhetorical questions
$rhetoricalPatterns = @('რას ნიშნავს.*\?', 'გიფიქრიათ.*\?', 'წარმოიდგინეთ.*\?', 'რა იქნება თუ.*\?')
foreach ($r in $rhetoricalPatterns) {
    if ($content -match $r) {
        $violations += "❌ RHETORICAL QUESTION: Banned pattern detected"
    }
}

# 9. Ellipsis drama at end of sentences
if ($content -match '[ა-ჰa-zA-Z]\.\.\.(\s|$)') {
    $violations += "❌ ELLIPSIS DRAMA: Trailing '...' detected"
}

# 10. Forbidden CTA link after hashtags
if ($content -match '#\S+\s*\n\s*🔗') {
    $violations += "❌ FORBIDDEN CTA: '🔗' line after hashtags"
}

# 12. First Comment Check
# Strict header check removed to allow natural comment flow
# if ($content -notmatch "First Comment") { $violations += ... }

# 11. VISUAL STRATEGY CHECK (CRITICAL)
$strategies = @(
    "staring directly into", "pupil reflecting", "breaking the 4th wall", # 1. Uncanny
    "looming gigantically", "crushing a building", "Tilt-Shift",          # 2. Scale
    "Sodium Vapor", "Nuclear Green", "monochromatic anxiety",             # 3. Colors
    "reflective sunglasses", "nuclear explosion", "screaming face",       # 4. Reflection
    "melted off revealing", "wires growing out", "Translucent materials", # 5. Bio-Horror
    "glitching out of existence", "fragmented into pixels", "Datamoshing",# 6. Glitch
    "hurricane of flying", "Heavy volumetric fog", "particulate matter",  # 7. Atmosphere
    "grabbing the camera", "Fisheye Lens", "barrel distortion",           # 8. GoPro
    "Renaissance painting", "VHS tracking lines", "Chiaroscuro",          # 9. Genre
    "holding a PHOTREALISTIC", "smashed iPhone", "Real vs Toon"           # 10. Contrast
)

$hasStrategy = $false
# Check only within code blocks (prompts)
$prompts = [regex]::Matches($content, '```[\s\S]*?```') | ForEach-Object { $_.Value }
foreach ($s in $strategies) {
    if ($prompts -match $s) {
        $hasStrategy = $true
        break
    }
}

if (-not $hasStrategy) {
    $violations += "❌ VISUAL STRATEGY MISSING: Prompt must include aggressive modifiers from visual_strategies.md (e.g. 'Tilt-Shift', 'Datamoshing', 'Fisheye Lens')"
}

# Output results
Write-Host ""
Write-Host "═══════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  ALPHA NEWS VALIDATOR - $Path" -ForegroundColor Cyan
Write-Host "═══════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

if ($violations.Count -eq 0) {
    Write-Host "✅ ALL CHECKS PASSED" -ForegroundColor Green
    Write-Host ""
    exit 0
}
else {
    Write-Host "🚨 VIOLATIONS FOUND: $($violations.Count)" -ForegroundColor Red
    Write-Host ""
    foreach ($v in $violations) {
        Write-Host $v -ForegroundColor Yellow
    }
    Write-Host ""
    Write-Host "FIX THESE BEFORE PUBLISHING!" -ForegroundColor Red
    Write-Host ""
    exit 1
}
