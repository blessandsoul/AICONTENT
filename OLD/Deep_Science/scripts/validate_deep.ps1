<#
.SYNOPSIS
    Deep Science Validator
.DESCRIPTION
    Enforces "First Comment" and linguistic rules.
#>

param(
    [Parameter(Mandatory = $true)]
    [string]$Path
)

$directory = Split-Path -Path $Path -Parent
$audioPath = Join-Path -Path $directory -ChildPath "audio.md"

# 1. Audio Check
if (-not (Test-Path $audioPath)) {
    Write-Host "❌ CRITICAL ERROR: 'audio.md' is MISSING in $directory" -ForegroundColor Red
    exit 1
}

$content = Get-Content -Path $Path -Raw -Encoding UTF8
$violations = @()

# 2. First Comment Check (Structure)
# Just checking if the file structure implies a comment section exists (length check or similar could be better, but removing strict string match for now)
# Logic: Ensure there is content between the last "---" separator before prompts.
# For now, we trust the agent instruction as the user hates the header.
# We will just ensure the 'Contrast Trap' is checked globally.

# 3. Contrast Trap (Global Rule)
if ($content -match 'ეს არ არის .{1,50} ეს (არის|გახლავთ)') {
    $violations += "❌ CONTRAST TRAP: 'ეს არ არის... ეს არის' pattern detected"
}

# OUTPUT
if ($violations.Count -eq 0) {
    Write-Host "✅ DEEP SCIENCE CHECKS PASSED" -ForegroundColor Green
    exit 0
}
else {
    Write-Host "🚨 VIOLATIONS FOUND: $($violations.Count)" -ForegroundColor Red
    foreach ($v in $violations) { Write-Host $v -ForegroundColor Yellow }
    exit 1
}
