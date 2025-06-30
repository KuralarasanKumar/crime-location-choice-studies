# Move verified non-target studies to ToDelete folder
# Based on cross-reference with main table

$sourceDir = "c:\Users\kukumar\OneDrive - UGent\Job\crimsyndata\-crime-location-choice-studies\snatching work\References\PDFs"
$deleteDir = "c:\Users\kukumar\OneDrive - UGent\Job\crimsyndata\-crime-location-choice-studies\snatching work\References\PDFs\ToDelete"

# Ensure ToDelete directory exists
if (!(Test-Path $deleteDir)) {
    New-Item -Path $deleteDir -ItemType Directory -Force
}

# List of verified non-target files to move
$nonTargetFiles = @(
    "*Marchment and Gill - 2022 - Spatial Decision Making of Terrorist Target Selection*",
    "*Marchment et al. - 2020 - Lone Actor Terrorists A Residence-to-Crime Approach*",
    "*Groff - 2017 - Measuring the Influence of the Built Environment*",
    "*Groff and La Vigne - 2001 - Mapping an Opportunity Surface*",
    "*Johnson - 2014 - How do offenders choose where to offend Perspectives from animal foraging*",
    "*Shover and Honaker - 1992 - The Socially Bounded Decision Making*"
)

Write-Host "🧹 CLEANING UP VERIFIED NON-TARGET STUDIES" -ForegroundColor Yellow
Write-Host "=======================================" -ForegroundColor Yellow

$movedCount = 0

foreach ($pattern in $nonTargetFiles) {
    $files = Get-ChildItem -Path $sourceDir -Name $pattern -File
    foreach ($file in $files) {
        $sourcePath = Join-Path $sourceDir $file
        $destPath = Join-Path $deleteDir $file
        
        if (Test-Path $sourcePath) {
            try {
                Move-Item -Path $sourcePath -Destination $destPath -Force
                Write-Host "✅ Moved: $file" -ForegroundColor Green
                $movedCount++
            } catch {
                Write-Host "❌ Failed to move: $file" -ForegroundColor Red
                Write-Host "   Error: $($_.Exception.Message)" -ForegroundColor Red
            }
        }
    }
}

Write-Host "`n📊 SUMMARY:" -ForegroundColor Cyan
Write-Host "Moved $movedCount non-target files to ToDelete folder" -ForegroundColor White

# List remaining files in main folder
$remainingFiles = Get-ChildItem -Path $sourceDir -Name "*.pdf" | Sort-Object
Write-Host "`n📁 FILES REMAINING IN MAIN FOLDER: $($remainingFiles.Count)" -ForegroundColor Cyan
foreach ($file in $remainingFiles) {
    Write-Host "   📄 $file" -ForegroundColor White
}
