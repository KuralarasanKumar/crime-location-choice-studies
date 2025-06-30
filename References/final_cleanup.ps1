# Move final non-target files to ToDelete
$sourceDir = "c:\Users\kukumar\OneDrive - UGent\Job\crimsyndata\-crime-location-choice-studies\snatching work\References\PDFs"
$deleteDir = "c:\Users\kukumar\OneDrive - UGent\Job\crimsyndata\-crime-location-choice-studies\snatching work\References\PDFs\ToDelete"

$finalNonTargets = @(
    "Armitage - 2006 - Predicting and Preventing Developing A Risk Assessment Mechanism For Residential Housing.pdf",
    "Beken - Toegang tot data van politie en justitie nogmoeilijker dan het al was.pdf",
    "Detoegankelijkheidvancijfers.pdf",
    "Detoegankelijkheidvancijfers-1.pdf",
    "Devroe - Een analyse van 15 jaar politie en justitie onderzoek in België.pdf",
    "Prenzler - 2012 - Policing and security in practice challenges and achievements.pdf",
    "Vilalta and Fondevila - 2019 - Modeling Crime in an Uptown Neighborhood The Case of Santa Fe in Mexico City.pdf",
    "Youth,_crime,_and_cultural_spa.pdf"
)

Write-Host "MOVING FINAL NON-TARGET FILES" -ForegroundColor Yellow
Write-Host "==============================" -ForegroundColor Yellow

$movedCount = 0
foreach ($file in $finalNonTargets) {
    $sourcePath = Join-Path $sourceDir $file
    $destPath = Join-Path $deleteDir $file
    
    if (Test-Path $sourcePath) {
        try {
            Move-Item -Path $sourcePath -Destination $destPath -Force
            Write-Host "Moved: $file" -ForegroundColor Green
            $movedCount++
        } catch {
            Write-Host "Failed to move: $file" -ForegroundColor Red
        }
    }
}

Write-Host "`nMoved $movedCount final non-target files" -ForegroundColor Green

# Show final count
$remainingFiles = Get-ChildItem -Path $sourceDir -Name "*.pdf" | Sort-Object
Write-Host "`nFINAL COUNT: $($remainingFiles.Count) TARGET STUDY FILES REMAINING" -ForegroundColor Cyan

Write-Host "`nALL REMAINING FILES (TARGET STUDIES ONLY):" -ForegroundColor Green
foreach ($file in $remainingFiles) {
    Write-Host "  $file" -ForegroundColor White
}
