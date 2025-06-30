# Clean up irrelevant PDFs that were moved back but are not in our target list

$irrelevantFiles = @(
    "Baumer et al. - 1998 - The Influence of Crack Cocaine on Robbery, Burglar.pdf",
    "Clare and Hamilton - 2003 - Writing research transforming data into text.pdf",
    "Davies and Johnson - 2015 - Examining the Relationship Between Road Structure .pdf",
    "Lammers and Bernasco - 2013 - Are mobile offenders less likely to be caught The.pdf",
    "Summers - 2022 - Black insurgent aesthetics and the public imaginar.pdf",
    "Natthaphong Pančhaburī, ณัฐพงษ์ ปัญจบุรี, Mahāwitthayālai Chīang Mai. Samnak Songsœ̄m Sinlapa Watthanatham - Unknown - Nithān phư̄.pdf"
)

$mainPath = ".\PDFs"
$toDeletePath = ".\PDFs\ToDelete"

Write-Host "Cleaning up irrelevant files from main PDFs folder..." -ForegroundColor Yellow

foreach ($fileName in $irrelevantFiles) {
    $filePath = Join-Path $mainPath $fileName
    if (Test-Path $filePath) {
        Write-Host "Moving back to ToDelete: $fileName" -ForegroundColor Cyan
        $destination = Join-Path $toDeletePath $fileName
        Move-Item -Path $filePath -Destination $destination
        Write-Host "  Moved successfully" -ForegroundColor Green
    } else {
        Write-Host "File not found: $fileName" -ForegroundColor Red
    }
}

Write-Host "`nCleanup completed!" -ForegroundColor Green
