# PowerShell script to search for missing PDFs in the ToDelete folder

$deleteDir = "c:\Users\kukumar\OneDrive - UGent\Job\crimsyndata\-crime-location-choice-studies\snatching work\References\PDFs\ToDelete"
$mainDir = "c:\Users\kukumar\OneDrive - UGent\Job\crimsyndata\-crime-location-choice-studies\snatching work\References\PDFs"

# List of missing studies to search for
$missingStudies = @(
    "Chamberlain",
    "Boggess", 
    "Baudains",
    "Jacques",
    "Nieuwbeerta",
    "Cai",
    "Clare",
    "Hanayama",
    "Johnson",
    "Summers",
    "Lammers",
    "Menting",
    "Rowan",
    "Appleby",
    "McGloin",
    "Sleeuwen",
    "Song",
    "Vandeviver",
    "Xiao",
    "Yue"
)

Write-Host "Searching ToDelete folder for missing studies..." -ForegroundColor Yellow
Write-Host "ToDelete folder path: $deleteDir" -ForegroundColor Cyan

if (Test-Path $deleteDir) {
    $foundFiles = @()
    
    foreach ($author in $missingStudies) {
        $searchPattern = "*$author*"
        $matchingFiles = Get-ChildItem -Path $deleteDir -Filter $searchPattern -ErrorAction SilentlyContinue
        
        if ($matchingFiles) {
            foreach ($file in $matchingFiles) {
                $foundFiles += $file
                Write-Host "FOUND: $($file.Name)" -ForegroundColor Green
            }
        }
    }
    
    Write-Host "`n=== SUMMARY ===" -ForegroundColor Yellow
    Write-Host "Found $($foundFiles.Count) potentially relevant files in ToDelete folder" -ForegroundColor Green
    
    if ($foundFiles.Count -gt 0) {
        Write-Host "`nDo you want to move these files back to the main folder? (y/N): " -ForegroundColor Yellow -NoNewline
        $response = Read-Host
        
        if ($response -eq 'y' -or $response -eq 'Y') {
            foreach ($file in $foundFiles) {
                $destinationPath = Join-Path $mainDir $file.Name
                Move-Item -Path $file.FullName -Destination $destinationPath
                Write-Host "Moved: $($file.Name)" -ForegroundColor Green
            }
            Write-Host "Files moved successfully!" -ForegroundColor Green
        } else {
            Write-Host "Files left in ToDelete folder." -ForegroundColor Yellow
        }
    }
} else {
    Write-Host "ToDelete folder not found!" -ForegroundColor Red
}
