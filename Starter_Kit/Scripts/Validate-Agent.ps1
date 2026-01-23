# Validate-Agent.ps1
# Simple validation script for agent structure

param(
    [Parameter(Mandatory = $true)]
    [string]$AgentPath
)

$errors = @()
$warnings = @()

Write-Host "🔍 Validating agent at: $AgentPath" -ForegroundColor Cyan
Write-Host ""

# Check if path exists
if (-not (Test-Path $AgentPath)) {
    Write-Host "❌ FATAL: Path does not exist: $AgentPath" -ForegroundColor Red
    exit 1
}

# Find SKILL.md
$skillFiles = Get-ChildItem -Path $AgentPath -Recurse -Filter "SKILL.md"

if ($skillFiles.Count -eq 0) {
    $errors += "No SKILL.md found"
}
else {
    Write-Host "✅ SKILL.md found: $($skillFiles[0].FullName)" -ForegroundColor Green
    
    # Check YAML frontmatter
    $content = Get-Content $skillFiles[0].FullName -Raw
    if ($content -match "^---\s*\n.*?name:.*?\n.*?description:.*?\n---") {
        Write-Host "✅ YAML frontmatter is valid" -ForegroundColor Green
    }
    else {
        $errors += "SKILL.md missing valid YAML frontmatter (name, description)"
    }
    
    # Check for essential sections
    if ($content -match "# 🔄|## Step|# Workflow") {
        Write-Host "✅ Workflow section found" -ForegroundColor Green
    }
    else {
        $warnings += "No workflow section detected"
    }
}

# Check for protocols folder
$protocolsPath = Get-ChildItem -Path $AgentPath -Recurse -Directory -Filter "protocols" | Select-Object -First 1
if ($protocolsPath) {
    $protocolFiles = Get-ChildItem -Path $protocolsPath.FullName -Filter "*.md"
    Write-Host "✅ Protocols folder found with $($protocolFiles.Count) file(s)" -ForegroundColor Green
}
else {
    $warnings += "No protocols folder found"
}

# Check for README
$readme = Get-ChildItem -Path $AgentPath -Filter "README.md" | Select-Object -First 1
if ($readme) {
    Write-Host "✅ README.md found" -ForegroundColor Green
}
else {
    $warnings += "No README.md in agent root"
}

# Summary
Write-Host ""
Write-Host "═══════════════════════════════════════" -ForegroundColor Cyan
Write-Host "VALIDATION SUMMARY" -ForegroundColor Cyan
Write-Host "═══════════════════════════════════════" -ForegroundColor Cyan

if ($errors.Count -eq 0 -and $warnings.Count -eq 0) {
    Write-Host "✅ ALL CHECKS PASSED" -ForegroundColor Green
}
else {
    if ($errors.Count -gt 0) {
        Write-Host ""
        Write-Host "❌ ERRORS ($($errors.Count)):" -ForegroundColor Red
        foreach ($err in $errors) {
            Write-Host "   - $err" -ForegroundColor Red
        }
    }
    
    if ($warnings.Count -gt 0) {
        Write-Host ""
        Write-Host "⚠️ WARNINGS ($($warnings.Count)):" -ForegroundColor Yellow
        foreach ($warn in $warnings) {
            Write-Host "   - $warn" -ForegroundColor Yellow
        }
    }
}

Write-Host ""

# Return exit code
if ($errors.Count -gt 0) {
    exit 1
}
else {
    exit 0
}
