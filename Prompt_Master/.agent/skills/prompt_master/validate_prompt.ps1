# Prompt Master Validation Script
# Validates post.md and prompt.md against agent protocols

param(
    [Parameter(Mandatory = $true)]
    [string]$PostPath
)

$errors = @()
$warnings = @()

# Read post content
if (!(Test-Path $PostPath)) {
    Write-Host "❌ ERROR: File not found: $PostPath" -ForegroundColor Red
    exit 1
}

$content = Get-Content $PostPath -Raw -Encoding UTF8
$lines = Get-Content $PostPath -Encoding UTF8

Write-Host "`n🔍 Validating Prompt Master Post..." -ForegroundColor Cyan
Write-Host "📄 File: $PostPath`n" -ForegroundColor Gray

# === PROTOCOL CHECKS ===

# Check 1: ANDREWALTAIR.GE branding
Write-Host "Checking branding integration..." -ForegroundColor Yellow
if ($content -notmatch "ANDREWALTAIR\.GE") {
    $errors += "❌ PROTOCOL 2 VIOLATION: 'ANDREWALTAIR.GE' not found in prompt"
}
else {
    Write-Host "  ✅ ANDREWALTAIR.GE branding present" -ForegroundColor Green
}

# Check 2: Aspect ratio --ar 16:9 or 9:16
Write-Host "Checking aspect ratio..." -ForegroundColor Yellow
if ($content -notmatch "--ar (16:9|9:16)") {
    $errors += "❌ PROTOCOL 3 VIOLATION: Aspect Ratio must be 16:9 or 9:16"
}
else {
    Write-Host "  ✅ Valid Aspect Ratio present" -ForegroundColor Green
}

# Check 3: Midjourney version
Write-Host "Checking Midjourney version..." -ForegroundColor Yellow
if ($content -notmatch "--v 6\.0") {
    $warnings += "⚠️ '--v 6.0' not found (might be using different version)"
}
else {
    Write-Host "  ✅ Midjourney v6.0 specified" -ForegroundColor Green
}

# Check 4: Gender neutrality (in code block only)
Write-Host "Checking gender neutrality..." -ForegroundColor Yellow
$codeBlockMatch = [regex]::Match($content, '```markdown([\s\S]*?)```')
if ($codeBlockMatch.Success) {
    $promptContent = $codeBlockMatch.Groups[1].Value
    $genderWords = @("(?<!\w)(man|woman|boy|girl|he|she|his|her)(?!\w)")
    foreach ($pattern in $genderWords) {
        if ($promptContent -match $pattern) {
            $errors += "❌ PROTOCOL 1 VIOLATION: Gender word '$($matches[0])' found in prompt. Use 'The Subject/Character/Model' instead."
        }
    }
    if ($errors.Count -eq 0 -or $errors[-1] -notmatch "PROTOCOL 1") {
        Write-Host "  ✅ Gender-neutral language used" -ForegroundColor Green
    }
}

# Check 5: Exactly 3 categories
Write-Host "Checking categories..." -ForegroundColor Yellow
$categoryMatches = [regex]::Matches($content, '(?m)^[🎨📸🖌️✨📈💻💼🧊👗🎮📦].+\(.+\)')
$categoryCount = $categoryMatches.Count
if ($categoryCount -ne 3) {
    $errors += "❌ PROTOCOL 4 VIOLATION: Found $categoryCount categories (must be exactly 3)"
}
else {
    Write-Host "  ✅ Exactly 3 categories present" -ForegroundColor Green
}

# Check 6: 15 hashtags (Georgian)
Write-Host "Checking hashtags..." -ForegroundColor Yellow
$hashtagLine = $lines | Where-Object { $_ -match '^#[\u10A0-\u10FF]' } | Select-Object -First 1
if ($hashtagLine) {
    $hashtags = [regex]::Matches($hashtagLine, '#[\u10A0-\u10FFa-zA-Z0-9]+')
    $hashtagCount = $hashtags.Count
    if ($hashtagCount -lt 15) {
        $errors += "❌ Found only $hashtagCount hashtags (need 15)"
    }
    elseif ($hashtagCount -gt 15) {
        $warnings += "⚠️ Found $hashtagCount hashtags (recommended: 15)"
    }
    else {
        Write-Host "  ✅ 15 hashtags present" -ForegroundColor Green
    }
}
else {
    $errors += "❌ No Georgian hashtag line found"
}

# Check 7: 6-digit code
Write-Host "Checking product code..." -ForegroundColor Yellow
if ($content -match "კოდი\s*[—-]\s*(\d{6})") {
    Write-Host "  ✅ 6-digit code present: $($matches[1])" -ForegroundColor Green
}
elseif ($content -match "კოდი:\s*\*\*(\d{6})\*\*") {
    Write-Host "  ✅ 6-digit code present: $($matches[1])" -ForegroundColor Green
}
else {
    $errors += "❌ 6-digit product code not found or wrong format"
}

# Check 8: Code block exists
Write-Host "Checking prompt code block..." -ForegroundColor Yellow
if ($content -notmatch '```markdown[\s\S]+```') {
    $errors += "❌ Markdown code block with prompt not found"
}
else {
    Write-Host "  ✅ Prompt code block present" -ForegroundColor Green
}

# Check 9: Negative prompt
Write-Host "Checking negative prompt..." -ForegroundColor Yellow
if ($content -notmatch "--negative_prompt:") {
    $warnings += "⚠️ Negative prompt not found"
}
else {
    Write-Host "  ✅ Negative prompt present" -ForegroundColor Green
}

# === RESULTS ===

Write-Host "`n" + ("=" * 50) -ForegroundColor Cyan
Write-Host "VALIDATION RESULTS" -ForegroundColor Cyan
Write-Host ("=" * 50) -ForegroundColor Cyan

if ($errors.Count -eq 0 -and $warnings.Count -eq 0) {
    Write-Host "`n✅ ALL CHECKS PASSED!" -ForegroundColor Green
    exit 0
}

if ($warnings.Count -gt 0) {
    Write-Host "`n⚠️ WARNINGS ($($warnings.Count)):" -ForegroundColor Yellow
    foreach ($warning in $warnings) {
        Write-Host "  $warning" -ForegroundColor Yellow
    }
}

if ($errors.Count -gt 0) {
    Write-Host "`n❌ ERRORS ($($errors.Count)):" -ForegroundColor Red
    foreach ($err in $errors) {
        Write-Host "  $err" -ForegroundColor Red
    }
    Write-Host "`n❌ VALIDATION FAILED" -ForegroundColor Red
    exit 1
}

Write-Host "`n⚠️ PASSED WITH WARNINGS" -ForegroundColor Yellow
exit 0
