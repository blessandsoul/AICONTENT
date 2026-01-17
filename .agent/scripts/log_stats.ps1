<#
.SYNOPSIS
    Log performance statistics for Eden AI / Alpha News posts
.DESCRIPTION
    Automatically updates results.md, performance_log.md, and MASTER_INDEX.md
.PARAMETER PostFolder
    Path to the published post folder (e.g., "Eden_AI/output/published/20260116_merge_labs")
.PARAMETER TikTokViews
    TikTok view count
.PARAMETER TikTokLikes
    TikTok likes
.PARAMETER TikTokComments
    TikTok comments
.PARAMETER TikTokShares
    TikTok shares
.PARAMETER TikTokSaves
    TikTok saves
.PARAMETER TikTokAvgWatch
    Average watch time (e.g., "15.37s")
.PARAMETER TikTokCompletion
    Completion rate percentage (e.g., 7)
.PARAMETER TikTokNewSubs
    New subscribers from TikTok
.PARAMETER TikTokFYP
    For You Page traffic percentage (e.g., 98.3)
.PARAMETER FBViews
    Facebook views
.PARAMETER FBReactions
    Facebook reactions count
.PARAMETER FBClicks
    Facebook clicks
.PARAMETER FBComments
    Facebook comments
.PARAMETER FBShares
    Facebook shares/reposts
.PARAMETER FBAvgWatch
    Facebook average watch time (e.g., "18s")
.PARAMETER FBDropoff
    Facebook drop-off point (e.g., "0:32")
.PARAMETER Verdict
    WIN, NEUTRAL, or FLOP
.PARAMETER Topic
    Topic description for performance_log
.PARAMETER HookType
    Hook type used
.PARAMETER Villain
    Named villain figure(s)
.EXAMPLE
    .\log_stats.ps1 -PostFolder "Eden_AI/output/published/20260116_merge_labs" -TikTokViews 1400 -FBViews 4749 -Verdict WIN
#>

param(
    [Parameter(Mandatory = $true)]
    [string]$PostFolder,
    
    # TikTok Stats
    [int]$TikTokViews = 0,
    [int]$TikTokLikes = 0,
    [int]$TikTokComments = 0,
    [int]$TikTokShares = 0,
    [int]$TikTokSaves = 0,
    [string]$TikTokAvgWatch = "0s",
    [double]$TikTokCompletion = 0,
    [int]$TikTokNewSubs = 0,
    [double]$TikTokFYP = 0,
    
    # Facebook Stats
    [int]$FBViews = 0,
    [int]$FBReactions = 0,
    [int]$FBClicks = 0,
    [int]$FBComments = 0,
    [int]$FBShares = 0,
    [string]$FBAvgWatch = "0s",
    [string]$FBDropoff = "0:00",
    
    # Meta
    [ValidateSet("WIN", "NEUTRAL", "FLOP")]
    [string]$Verdict = "NEUTRAL",
    [string]$Topic = "",
    [string]$HookType = "",
    [string]$Villain = ""
)

$ROOT = "C:\Users\User\Desktop\AICONTENT"
$FullPostPath = Join-Path $ROOT $PostFolder
$Today = Get-Date -Format "yyyy-MM-dd"
$PostDate = (Split-Path $PostFolder -Leaf) -replace '^(\d{4})(\d{2})(\d{2}).*', '$1-$2-$3'

# Determine agent type from path
if ($PostFolder -match "Eden_AI") {
    $Agent = "Eden_AI"
    $PerformanceLog = "$ROOT\Eden_AI\analytics\performance_log.md"
}
elseif ($PostFolder -match "Alpha_News") {
    $Agent = "Alpha_News"
    $PerformanceLog = "$ROOT\Alpha_News\analytics\performance_log.md"
}
elseif ($PostFolder -match "Deep_Science") {
    $Agent = "Deep_Science"
    $PerformanceLog = "$ROOT\Deep_Science\analytics\performance_log.md"
}
else {
    Write-Error "Unknown agent type in path: $PostFolder"
    exit 1
}

# Validate folder exists
if (-not (Test-Path $FullPostPath)) {
    Write-Error "Post folder not found: $FullPostPath"
    exit 1
}

Write-Host "`n📊 LOGGING STATS FOR: $PostFolder" -ForegroundColor Cyan
Write-Host "=" * 60

# ============================================
# 1. CREATE/UPDATE results.md
# ============================================

$ResultsPath = Join-Path $FullPostPath "results.md"
$PostName = (Split-Path $PostFolder -Leaf) -replace '^\d{8}_', ''
$TotalTikTokEngagement = $TikTokLikes + $TikTokComments + $TikTokShares + $TikTokSaves
$TotalFBEngagement = $FBReactions + $FBClicks + $FBComments + $FBShares

$ResultsContent = @"
# 📊 Results: $PostName

**Published:** $PostDate
**Logged:** $Today

---

## 🎬 TikTok Performance

| Metric | Value |
|--------|-------|
| **Views** | $($TikTokViews.ToString("N0")) |
| **Likes** | $TikTokLikes |
| **Comments** | $TikTokComments |
| **Shares** | $TikTokShares |
| **Saves** | $TikTokSaves |
| **Avg Watch Time** | $TikTokAvgWatch |
| **Completion Rate** | $TikTokCompletion% |
| **New Subscribers** | $TikTokNewSubs |

### Traffic Sources
- 🔥 For You Page: **$TikTokFYP%**

---

## 📘 Facebook Performance

| Metric | Value |
|--------|-------|
| **Views** | $($FBViews.ToString("N0")) |
| **Reactions** | $FBReactions |
| **Clicks** | $FBClicks |
| **Comments** | $FBComments |
| **Reposts** | $FBShares |
| **Avg Watch Time** | $FBAvgWatch |
| **Drop-off Point** | $FBDropoff |

### Total Engagement: $TotalFBEngagement

---

## 🎯 VERDICT: $Verdict

### Summary
- **TikTok:** $($TikTokViews.ToString("N0")) views, $TotalTikTokEngagement engagement
- **Facebook:** $($FBViews.ToString("N0")) views, $TotalFBEngagement engagement
- **FYP Traffic:** $TikTokFYP%
- **Completion:** $TikTokCompletion%
"@

Set-Content -Path $ResultsPath -Value $ResultsContent -Encoding UTF8
Write-Host "✅ Created: $ResultsPath" -ForegroundColor Green

# ============================================
# 2. UPDATE performance_log.md
# ============================================

if (Test-Path $PerformanceLog) {
    $LogContent = Get-Content $PerformanceLog -Raw
    
    # Create new entry line
    $ViewsFormatted = if ($TikTokViews -ge 1000) { "$([math]::Round($TikTokViews/1000, 1))K TT" } else { "$TikTokViews TT" }
    $FBViewsFormatted = if ($FBViews -ge 1000) { "$([math]::Round($FBViews/1000, 1))K FB" } else { "$FBViews FB" }
    $Notes = "FYP: $TikTokFYP%, Completion: $TikTokCompletion%, FB Engagement: $TotalFBEngagement"
    
    $NewEntry = "| $PostDate | $Topic | $ViewsFormatted / $FBViewsFormatted | $HookType | $Villain | $Notes |"
    
    # Find the line after the header row and insert
    # Look for the pattern after "| Date | Topic |" header
    if ($LogContent -match '(\| Date \| Topic \|[^\r\n]*\r?\n\|[-\|]+\r?\n)') {
        $HeaderSection = $Matches[1]
        # Find all existing entries (lines starting with |)
        $Lines = $LogContent -split "`r?`n"
        $InsertIndex = -1
        for ($i = 0; $i -lt $Lines.Count; $i++) {
            if ($Lines[$i] -match '^\| Date \| Topic \|') {
                # Found header, skip header and separator
                $InsertIndex = $i + 2
                # Find the last entry line
                while ($InsertIndex -lt $Lines.Count -and $Lines[$InsertIndex] -match '^\| \d{4}') {
                    $InsertIndex++
                }
                break
            }
        }
        
        if ($InsertIndex -gt 0) {
            $Lines = [System.Collections.ArrayList]@($Lines)
            $Lines.Insert($InsertIndex, $NewEntry)
            $LogContent = $Lines -join "`r`n"
            Set-Content -Path $PerformanceLog -Value $LogContent -Encoding UTF8
            Write-Host "✅ Updated: $PerformanceLog" -ForegroundColor Green
        }
    }
}
else {
    Write-Warning "Performance log not found: $PerformanceLog"
}

# ============================================
# 3. UPDATE MASTER_INDEX.md
# ============================================

$MasterIndex = "$ROOT\MASTER_INDEX.md"
if (Test-Path $MasterIndex) {
    $IndexContent = Get-Content $MasterIndex -Raw
    
    # Generate ID
    $DatePart = $PostDate -replace '-', ''
    $NamePart = ($PostName -split '_')[0].ToUpper()
    $ID = "${Agent}_${DatePart}_${NamePart}" -replace 'Eden_AI', 'EDEN' -replace 'Alpha_News', 'ALPHA' -replace 'Deep_Science', 'DEEP'
    
    # Get title from post.md or story.md
    $TitleFile = Join-Path $FullPostPath "story.md"
    if (-not (Test-Path $TitleFile)) { $TitleFile = Join-Path $FullPostPath "post.md" }
    if (-not (Test-Path $TitleFile)) { $TitleFile = Join-Path $FullPostPath "description_post.md" }
    
    $Title = $PostName -replace '_', ' '
    if (Test-Path $TitleFile) {
        $FirstLine = (Get-Content $TitleFile -First 5 | Where-Object { $_ -match '\S' } | Select-Object -First 1)
        if ($FirstLine) {
            $Title = ($FirstLine -replace '^[#\s]+', '' -replace '^\*+', '').Substring(0, [Math]::Min(20, $FirstLine.Length))
        }
    }
    
    # Platform
    $Platform = if ($Agent -eq "Eden_AI") { "TikTok/FB" } else { "FB/TG" }
    
    # Check if entry already exists
    if ($IndexContent -notmatch [regex]::Escape($PostFolder)) {
        $NewIndexEntry = "| $PostDate | $ID | $Title | ``$PostFolder`` | $Platform | $Verdict |"
        
        # Find the agent section and add entry
        $SectionHeader = switch ($Agent) {
            "Eden_AI" { "## 🎬 EDEN AI" }
            "Alpha_News" { "## 📰 ALPHA NEWS" }
            "Deep_Science" { "## 🔬 DEEP SCIENCE" }
        }
        
        $Lines = $IndexContent -split "`r?`n"
        $InsertIndex = -1
        $InSection = $false
        
        for ($i = 0; $i -lt $Lines.Count; $i++) {
            if ($Lines[$i] -match [regex]::Escape($SectionHeader)) {
                $InSection = $true
            }
            if ($InSection -and $Lines[$i] -match '^\|[-\|]+\|$') {
                $InsertIndex = $i + 1
                # Find last entry in this table
                while ($InsertIndex -lt $Lines.Count -and $Lines[$InsertIndex] -match '^\| \d{4}') {
                    $InsertIndex++
                }
                break
            }
        }
        
        if ($InsertIndex -gt 0) {
            $Lines = [System.Collections.ArrayList]@($Lines)
            $Lines.Insert($InsertIndex, $NewIndexEntry)
            $IndexContent = $Lines -join "`r`n"
            Set-Content -Path $MasterIndex -Value $IndexContent -Encoding UTF8
            Write-Host "✅ Updated: $MasterIndex" -ForegroundColor Green
        }
    }
    else {
        # Update existing entry verdict
        $IndexContent = $IndexContent -replace "(\| [^|]+ \| [^|]+ \| [^|]+ \| ``$([regex]::Escape($PostFolder))`` \| [^|]+ \|) \w+ \|", "`$1 $Verdict |"
        Set-Content -Path $MasterIndex -Value $IndexContent -Encoding UTF8
        Write-Host "✅ Updated verdict in: $MasterIndex" -ForegroundColor Green
    }
}
else {
    Write-Warning "Master index not found: $MasterIndex"
}

Write-Host "`n" + "=" * 60
Write-Host "🎯 STATS LOGGED SUCCESSFULLY!" -ForegroundColor Green
Write-Host "   Verdict: $Verdict" -ForegroundColor $(if ($Verdict -eq "WIN") { "Green" } elseif ($Verdict -eq "FLOP") { "Red" } else { "Yellow" })
Write-Host "=" * 60 + "`n"
