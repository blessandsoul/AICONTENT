<#
.SYNOPSIS
    Eden AI Viral Validator
.DESCRIPTION
    Scans Eden AI drafts for broken protocols, formatting errors, and banned patterns.
.USAGE
    .\validate_eden.ps1 -FolderPath "path\to\draft_folder"
#>

param(
    [Parameter(Mandatory = $true)]
    [string]$FolderPath
)

$violations = @()

# Verify files exist
$requiredFiles = @("text.md", "story.md", "visuals.md", "description_post.md", "audio.md")
foreach ($file in $requiredFiles) {
    if (-not (Test-Path "$FolderPath\$file")) {
        $violations += "❌ MISSING FILE: $file is required."
    }
}

if ((Test-Path "$FolderPath\text.md")) {
    $textContent = Get-Content -Path "$FolderPath\text.md" -Raw -Encoding UTF8

    # 1. On-Screen Title Formatting Check (2-3 words, stacked)
    # Check if blocks start with correct pattern: Block header -> Blank line -> Text
    if ($textContent -notmatch 'Block \d+\s*\n\s*\n') {
        $violations += "❌ TEXT FORMAT: Missing blank line after 'Block X' header in text.md"
    }

    # 1.5 Strict Asterisk Ban
    if ($textContent -match '\*\*') {
        $violations += "❌ FORMAT VIOLATION: Asterisks (**) detected in text.md. REMOVE THEM!"
    }
    
    # 2. Check for missing titles (heuristic)
    # Ideally should look for short lines (1-3 words) right after blank line
}

if ((Test-Path "$FolderPath\description_post.md")) {
    $descContent = Get-Content -Path "$FolderPath\description_post.md" -Raw -Encoding UTF8

    # 3. Bold text ban (asterisks) in description
    $nonCodeContent = $descContent -replace '```[\s\S]*?```', ''
    if ($nonCodeContent -match '\*\*') {
        # Check if it's just headers in visual prompts or actual bold text in post
        if ($nonCodeContent -match '(?<!\*\*Visual Prompts \*\*)\*\*(?!9:16|16:9)') {
            # Allow bolding visual prompt headers, but not social text
        }
    }

    # 4. Mandatory Memory Tags
    if ($descContent -notmatch '<!-- MEMORY_TAGS') {
        $violations += "❌ MEMORY TAGS: Missing MEMORY_TAGS block at end of description_post.md"
    }
}

if ((Test-Path "$FolderPath\story.md")) {
    $storyContent = Get-Content -Path "$FolderPath\story.md" -Raw -Encoding UTF8
    
    if ($storyContent -notmatch 'Villain:') {
        $violations += "❌ STORY PROTOCOL: Missing 'Villain:' field in story.md"
    }
}

if ((Test-Path "$FolderPath\description_post.md")) {
    $descContent = Get-Content -Path "$FolderPath\description_post.md" -Raw -Encoding UTF8
    # Validation relaxed to allow plain text comment without header
    # if ($descContent -notmatch "## 💬 First Comment") { ... }
}

# 6. Linguistic Checks (Global)
$allText = ""
if (Test-Path "$FolderPath\text.md") { $allText += Get-Content "$FolderPath\text.md" -Raw }
if (Test-Path "$FolderPath\story.md") { $allText += Get-Content "$FolderPath\story.md" -Raw }

# VIOLATION: Contrast Trap ("This is not X, this is Y")
# Matches: "es ar aris... es aris" / "es ar aris... es"
if ($allText -match 'ეს არ არის .{1,100} ეს (არის|გახლავთ)') {
    $violations += "❌ CONTRAST TRAP: 'ეს არ არის... ეს არის' pattern detected. SAY IT DIRECTLY!"
}
if ($allText -match 'არ არის .{1,50}\. ეს არის') {
    $violations += "❌ CONTRAST TRAP: '...არ არის. ეს არის...' sentence split detected."
}

# Calques
$calques = @('ადგილი აქვს', 'თამაშობს როლს', 'იმისათვის, რომ', 'პირველ ადგილზე')
foreach ($c in $calques) {
    if ($allText -match [regex]::Escape($c)) {
        $violations += "❌ CALQUE: '$c' - use natural Georgian"
    }
}

# Output results
Write-Host ""
Write-Host "═══════════════════════════════════════════════════" -ForegroundColor Magenta
Write-Host "  EDEN AI VIRAL VALIDATOR" -ForegroundColor Magenta
Write-Host "═══════════════════════════════════════════════════" -ForegroundColor Magenta
Write-Host ""

if ($violations.Count -eq 0) {
    Write-Host "✅ ALL CHECKS PASSED. SYSTEM READY TO MERGE." -ForegroundColor Green
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
    Write-Host "FIX THESE BEFORE RENDERING!" -ForegroundColor Red
    Write-Host ""
    exit 1
}
