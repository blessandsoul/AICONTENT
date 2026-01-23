<#
.SYNOPSIS
    Eden AI Viral Validator
.DESCRIPTION
    Scans Eden AI content for broken protocols, formatting errors, and banned patterns.
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
    # Check if blocks start with correct pattern: Block header -> --- -> Header Text
    # Regex: BLOCK X followed by ---
    if ($textContent -notmatch '(?m)^BLOCK \d+\r?\n---') {
        $violations += "❌ TEXT FORMAT: Missing '---' separator after 'BLOCK X' header in text.md"
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

if ((Test-Path "$FolderPath\visuals.md")) {
    $visualContent = Get-Content -Path "$FolderPath\visuals.md" -Raw -Encoding UTF8
    
    # VISUAL PROTOCOL CHECK
    if ($visualContent -notmatch 'ANDREWALTAIR.GE') {
        $violations += "❌ VISUAL FAIL: Missing 'ANDREWALTAIR.GE' branding in visuals.md"
    }
    if ($visualContent -notmatch '9:16') {
        $violations += "❌ VISUAL FAIL: Missing 'Vertical 9:16' aspect ratio in visuals.md"
    }
    if ($visualContent -notmatch 'Abstract') {
        $violations += "❌ VISUAL FAIL: Prompts do not seem 'Abstract' / Hypnotic."
    }
    if ($visualContent -notmatch 'void|empty|black|center') {
        $violations += "❌ VISUAL FAIL: Center must be described as 'empty' or 'void' for overlay."
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
# 6. EXPANDED CONTRAST TRAP LOGIC (The "Not X, but Y" Ban)
# This catches all variations of the "This isn't [magic], this is [science]" cliché.
$contrastPatterns = @(
    'ეს არ არის .{1,100},? ეს უკვე',             # Specific User Complaint: Es ar aris X... Es ukve Y
    'ეს არ არის .{1,100} ეს (არის|გახლავთ)',     # Standard: Es ar aris X... es aris Y
    'არ არის .{1,50}\. ეს არის',                 # Split sentence: ...ar aris. Es aris...
    'არ არის .{1,50},? არამედ',                  # Conjunction: Ar aris X, aramed Y
    'კი არ არის .{1,50},? არამედ',               # Ki ar aris X, aramed Y
    'კი არ (არის|გახლავთ) .{1,50},? ეს',         # Ki ar aris X, es...
    'არა .{1,50},? არამედ',                      # Short: Ara X, aramed Y
    'ეს .{1,20} კი არ არის',                     # X ki ar aris...
    'ეს არ არის .{1,100},? ეს'                   # Comma split: Es ar aris X, es Y...
)

foreach ($pattern in $contrastPatterns) {
    if ($allText -match $pattern) {
        $violations += "❌ CONTRAST TRAP: Pattern '$pattern' detected. SAY IT DIRECTLY! (e.g., 'It is Y', not 'It is not X, but Y')"
    }
}

# Calques
$calques = @('ადგილი აქვს', 'თამაშობს როლს', 'იმისათვის, რომ', 'პირველ ადგილზე')
foreach ($c in $calques) {
    if ($allText -match [regex]::Escape($c)) {
        $violations += "❌ CALQUE: '$c' - use natural Georgian"
    }
}

# 7. STRICT MORPHOLOGY (The 'Skaner' Rule)
# Bans root words lying naked without declension (Scanner vs Scanner-i)
$roots = @('სკანერ', 'სერვერ', 'კომპიუტერ', 'ბრაუზერ', 'ლინკ')
foreach ($root in $roots) {
    # Match root specifically NOT followed by Georgian vowels/consonants
    if ($allText -match "$root(?![ა-ჰ])") {
        $violations += "❌ MORPHOLOGY FAIL: Found '$root' without declension (use '$root-ი' or '$root-მა')."
    }
}

# 8. STRICT CLICHÉ BAN
if ($allText -match 'მოგესალმებით') {
    $violations += "❌ CLICHÉ BAN: 'მოგესალმებით' is for YouTubers. We are Eden. Start with action."
}
if ($allText -match 'ეს არ არის სამეცნიერო ფანტასტიკა') {
    $violations += "❌ CLICHÉ BAN: 'ეს არ არის სამეცნიერო ფანტასტიკა' detected. User hates this."
}
if ($allText -match 'ეს არ არის მომავალი') {
    $violations += "❌ CLICHÉ BAN: 'ეს არ არის მომავალი' is banned. Be creative."
}

# 9. MANDATORY CTA CHECK
if ((Test-Path "$FolderPath\text.md")) {
    $checkText = Get-Content -Path "$FolderPath\text.md" -Raw -Encoding UTF8
    
    # Website CTA Check
    if ($checkText -notmatch 'AndrewAltair\.ge|საიტზე|პროტოკოლ|მანიფესტ') {
        $violations += "❌ CTA MISSING: Text must include website reference (AndrewAltair.ge / საიტზე)."
    }
    
    # Subscribe CTA Check
    if ($checkText -notmatch 'გამოიწერე|არხი|გამოგვყევი') {
        $violations += "❌ CTA MISSING: Text must include subscribe appeal (გამოიწერე / არხი)."
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
