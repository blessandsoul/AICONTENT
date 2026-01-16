<#
.SYNOPSIS
    GLOBAL SYSTEM VALIDATOR (The Sheriff)
.DESCRIPTION
    A modular validator that enforces:
    1. THE BIBLE (Global Rules for everyone)
    2. AGENT SPECIFIC RULES (Modular blocks)
.USAGE
    .\GLOBAL_VALIDATOR.ps1 -Path "path\to\content.md" -Agent "Alpha|Eden|Deep"
#>

param(
    [Parameter(Mandatory = $true)][string]$Path,
    [Parameter(Mandatory = $true)][string]$Agent
)

$content = Get-Content -Path $Path -Raw -Encoding UTF8
$violations = @()

# ==========================================
# 🛡️ 1. THE BIBLE (CORE CHECK)
# ==========================================
Write-Host "🔍 Scaning against THE BIBLE..." -ForegroundColor Cyan

# 1.1 Contrast Trap
if ($content -match 'ეს არ არის .{1,70} ეს (არის|გახლავთ)') {
    $violations += "❌ [BIBLE] CONTRAST TRAP: 'ეს არ არის... ეს არის' pattern detected."
}

# 1.2 Passive Voice
$passivePatterns = @('მიერაა', 'მიერ არის', 'იყო შექმნილი', 'არის შექმნილი', 'იქნა')
foreach ($p in $passivePatterns) {
    if ($content -match $p) {
        $violations += "❌ [BIBLE] PASSIVE VOICE: '$p' detected."
    }
}

# 1.3 Calques
$calques = @('ადგილი აქვს', 'თამაშობს როლს', 'იმისათვის, რომ', 'პირველ ადგილზე', 'მიიღო გადაწყვეტილება')
foreach ($c in $calques) {
    if ($content -match [regex]::Escape($c)) {
        $violations += "❌ [BIBLE] CALQUE: '$c' detected. Use natural Georgian."
    }
}

# 1.4 Colon Headlines
$nonCodeContent = $content -replace '```[\s\S]*?```', ''
if ($nonCodeContent -match '[\p{So}\p{Cs}]\s+[ა-ჰ\w]+.*?:\s') {
    $violations += "❌ [BIBLE] COLON HEADLINE: Replace ':' with ' - '"
}

# 1.5 Cyrillic Contamination
if ($content -match '[а-яА-ЯёЁ]') {
    $cyrillicMatches = [regex]::Matches($content, '\S*[а-яА-ЯёЁ]+\S*')
    foreach ($m in $cyrillicMatches) {
        if ($m.Value -notmatch 'Prompt|Format|Quality|Subject|Style|Archive') {
            $violations += "❌ [BIBLE] CYRILLIC DETECTED: '$($m.Value)'"
        }
    }
}

# ==========================================
# 🧩 2. AGENT MODULES
# ==========================================

switch ($Agent) {
    "Alpha" {
        Write-Host "🔍 Scaning against ALPHA NEWS Protocols..." -ForegroundColor Cyan
        # Alpha Constraint: Bold text is banned in body (allowed in prompts/headers)
        if ($nonCodeContent -match '\*\*') {
            $violations += "❌ [ALPHA] BOLD TEXT DETECTED. Use plain text only."
        }
    }

    "Eden" {
        Write-Host "🔍 Scaning against EDEN AI Protocols..." -ForegroundColor Cyan
        # Eden Constraint: Must have "First Comment" section
        # Eden Constraint: Shock Hook check (heuristic)
        if ($content -notmatch "First Comment") {
            $violations += "⚠️ [EDEN] FIRST COMMENT MISSING? (Check manually if not needed)"
        }
    }

    "Deep" {
        Write-Host "🔍 Scaning against DEEP SCIENCE Protocols..." -ForegroundColor Cyan
        # Deep Constraint: No "Gamer" slang
        if ($content -match "nerfed|buffed|OP|broken") {
            $violations += "❌ [DEEP] GAMER SLANG DETECTED. Be scientific."
        }
    }

    Default {
        Write-Host "⚠️ UNKNOWN AGENT: Only Bible checks applied." -ForegroundColor Yellow
    }
}

# ==========================================
# 🏁 VERDICT
# ==========================================
if ($violations.Count -eq 0) {
    Write-Host ""
    Write-Host "✅ ALL CHECKS PASSED. BIBLE COMPLIANT." -ForegroundColor Green
    exit 0
}
else {
    Write-Host ""
    Write-Host "🚨 VIOLATIONS FOUND: $($violations.Count)" -ForegroundColor Red
    foreach ($v in $violations) {
        Write-Host $v -ForegroundColor Yellow
    }
    exit 1
}
