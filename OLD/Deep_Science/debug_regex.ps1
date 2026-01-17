param(
    [string]$Path
)
$content = Get-Content -Path $Path -Raw -Encoding UTF8
$nonCodeContent = $content -replace '```[\s\S]*?```', ''
$matches = [regex]::Matches($nonCodeContent, '[\p{So}\p{Cs}]\s+[ა-ჰ\w]+.*?:\s')
foreach ($m in $matches) {
    Write-Host "MATCH FOUND: '$($m.Value)'" -ForegroundColor Red
}
