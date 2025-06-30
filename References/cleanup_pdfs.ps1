# PowerShell script to clean up after PDF organization
# This script will:
# 1. Move files from Keep folder back to main PDFs folder
# 2. Delete the ToDelete folder (with confirmation)

$baseDir = "c:\Users\kukumar\OneDrive - UGent\Job\crimsyndata\-crime-location-choice-studies\snatching work\References\PDFs"
$keepDir = Join-Path $baseDir "Keep"
$deleteDir = Join-Path $baseDir "ToDelete"

Write-Host "=== PDF CLEANUP SCRIPT ===" -ForegroundColor Yellow
Write-Host "Base directory: $baseDir" -ForegroundColor Cyan

# Step 1: Move files from Keep back to main folder
if (Test-Path $keepDir) {
    $keepFiles = Get-ChildItem -Path $keepDir -Filter "*.pdf"
    $keepCount = $keepFiles.Count
    
    Write-Host "`nStep 1: Moving $keepCount files from Keep folder back to main PDFs folder..." -ForegroundColor Green
    
    foreach ($file in $keepFiles) {
        $destinationPath = Join-Path $baseDir $file.Name
        Move-Item -Path $file.FullName -Destination $destinationPath
        Write-Host "Moved: $($file.Name)" -ForegroundColor Green
    }
    
    # Remove empty Keep folder
    Remove-Item -Path $keepDir -Force
    Write-Host "Removed empty Keep folder" -ForegroundColor Green
} else {
    Write-Host "Keep folder not found - skipping step 1" -ForegroundColor Yellow
}

# Step 2: Check ToDelete folder size and confirm deletion
if (Test-Path $deleteDir) {
    $deleteFiles = Get-ChildItem -Path $deleteDir -Filter "*.pdf"
    $deleteCount = $deleteFiles.Count
    $totalSize = ($deleteFiles | Measure-Object -Property Length -Sum).Sum / 1MB
    
    Write-Host "`nStep 2: ToDelete folder contains:" -ForegroundColor Red
    Write-Host "  - $deleteCount PDF files" -ForegroundColor Red
    Write-Host "  - Total size: $([math]::Round($totalSize, 2)) MB" -ForegroundColor Red
    
    # Ask for confirmation before deleting
    $confirmation = Read-Host "`nAre you sure you want to permanently delete these $deleteCount files? (y/N)"
    
    if ($confirmation -eq 'y' -or $confirmation -eq 'Y') {
        Write-Host "Deleting ToDelete folder and all contents..." -ForegroundColor Red
        Remove-Item -Path $deleteDir -Recurse -Force
        Write-Host "ToDelete folder and $deleteCount files have been permanently deleted!" -ForegroundColor Red
    } else {
        Write-Host "Deletion cancelled. ToDelete folder preserved." -ForegroundColor Yellow
    }
} else {
    Write-Host "ToDelete folder not found - skipping step 2" -ForegroundColor Yellow
}

# Step 3: Final summary
Write-Host "`n=== FINAL SUMMARY ===" -ForegroundColor Yellow
$finalFiles = Get-ChildItem -Path $baseDir -Filter "*.pdf"
$finalCount = $finalFiles.Count
Write-Host "Main PDFs folder now contains: $finalCount files" -ForegroundColor Green

Write-Host "`nCleanup complete! Your workspace now contains only the relevant crime location choice studies PDFs." -ForegroundColor Green
