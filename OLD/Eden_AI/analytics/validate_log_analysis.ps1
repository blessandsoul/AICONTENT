param (
    [string]$LogPath = "c:\Users\User\Desktop\AICONTENT\Eden_AI\analytics\performance_log.md"
)

if (-not (Test-Path $LogPath)) {
    Write-Error "Log file not found at $LogPath"
    exit 1
}

$content = Get-Content $LogPath -Raw

# Extract lines that look like table rows after "## Post History"
$readingTable = $false
$lines = @()
$content -split "\r?\n" | ForEach-Object {
    $line = $_.Trim()
    if ($line -match "^## Post History") {
        $readingTable = $true
        return # continue to next line
    }
    if ($readingTable) {
        if ($line.StartsWith("|") -and $line -notmatch "^\|\s*Date" -and $line -notmatch "^\|\s*-") {
            $lines += $line
        }
        # Stop reading if we hit a new header or separator (and we already found some lines)
        if (($line -match "^##" -or $line -match "^---") -and $lines.Count -gt 0) {
            $readingTable = $false
        }
    }
}

Write-Host "---------------------------------------------------" -ForegroundColor Cyan
Write-Host "🔍 EDEN ANALYTICS VALIDATION PROTOCOL" -ForegroundColor Cyan
Write-Host "---------------------------------------------------"
Write-Host "Reading from: $LogPath"
Write-Host "Total Records Found: $($lines.Count)" -ForegroundColor Yellow
Write-Host ""
    
foreach ($line in $lines) {
    # Simple split by pipe, ignoring empty first/last elements
    $cols = $line.Trim().Trim('|') -split "\|"
    
    if ($cols.Count -ge 3) {
        $date = $cols[0].Trim()
        $topic = $cols[1].Trim()
        $views = $cols[2].Trim()
        $hook = if ($cols.Count -ge 4) { $cols[3].Trim() } else { "N/A" }
        
        Write-Host " [RECORD] $date | Views: $views" -ForegroundColor Green
        Write-Host "          Topic: $topic"
        Write-Host "          Hook:  $hook"
        Write-Host ""
    }
}

Write-Host "---------------------------------------------------"
Write-Host "⚠️  AGENT CHECKLIST:" -ForegroundColor Red
Write-Host "1. Did you assume 'Views' is the only metric? (Check Retention/Saves in detailed notes)" -ForegroundColor Red
Write-Host "2. Have you accounted for EVERY record listed above?" -ForegroundColor Red
Write-Host "---------------------------------------------------"
