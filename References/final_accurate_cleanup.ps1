# Remove the 4 confirmed non-target files identified in detailed search
$sourceDir = "c:\Users\kukumar\OneDrive - UGent\Job\crimsyndata\-crime-location-choice-studies\snatching work\References\PDFs"
$deleteDir = "c:\Users\kukumar\OneDrive - UGent\Job\crimsyndata\-crime-location-choice-studies\snatching work\References\PDFs\ToDelete"

$confirmedNonTargets = @(
    "*Social Interactions and Crime Revisited*",
    "*Rational Foraging Terrorist*",
    "*When Do Offenders Commit Crime*",
    "*Yifei Xue and Brown - 2003*"
)

Write-Host "REMOVING CONFIRMED NON-TARGET FILES" -ForegroundColor Yellow
Write-Host "===================================" -ForegroundColor Yellow

$movedCount = 0
foreach ($pattern in $confirmedNonTargets) {
    $files = Get-ChildItem -Path $sourceDir -Name $pattern -File
    foreach ($file in $files) {
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
}

Write-Host "`nMoved $movedCount confirmed non-target files" -ForegroundColor Green

# Final accurate count
$finalFiles = Get-ChildItem -Path $sourceDir -Name "*.pdf" | Sort-Object
Write-Host "`nFINAL ACCURATE COUNT: $($finalFiles.Count) TRUE TARGET STUDY FILES" -ForegroundColor Green

Write-Host "`nREMAINING TARGET STUDIES:" -ForegroundColor Cyan
foreach ($file in $finalFiles) {
    Write-Host "  $file" -ForegroundColor White
}

Write-Host "`nTOTAL CLEANUP SUMMARY:" -ForegroundColor Magenta
Write-Host "- Started with: ~100+ mixed files" -ForegroundColor White
Write-Host "- Non-target files moved: ~45+" -ForegroundColor White  
Write-Host "- True target studies remaining: $($finalFiles.Count)" -ForegroundColor White
Write-Host "- Completion rate: ~$(($finalFiles.Count / 50 * 100).ToString('F0'))% of 50 target studies" -ForegroundColor White
