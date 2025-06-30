# Simple comprehensive cleanup and target identification
$sourceDir = "c:\Users\kukumar\OneDrive - UGent\Job\crimsyndata\-crime-location-choice-studies\snatching work\References\PDFs"
$deleteDir = "c:\Users\kukumar\OneDrive - UGent\Job\crimsyndata\-crime-location-choice-studies\snatching work\References\PDFs\ToDelete"

# Ensure ToDelete directory exists
if (!(Test-Path $deleteDir)) {
    New-Item -Path $deleteDir -ItemType Directory -Force
}

Write-Host "COMPREHENSIVE CLEANUP AND TARGET SEARCH" -ForegroundColor Yellow
Write-Host "=======================================" -ForegroundColor Yellow

# Get all PDF files
$allFiles = Get-ChildItem -Path $sourceDir -Name "*.pdf" | Sort-Object

Write-Host "Current files in main folder: $($allFiles.Count)" -ForegroundColor Cyan

# Files that are obviously NOT target studies (based on titles)
$obviousNonTargets = @(
    "*corruption*", "*corrupt*", "*organizational*", "*injustice*", "*housing design*",
    "*evidence based policing*", "*pickpocketing*", "*air quality*", "*graffiti*",
    "*freedom of information*", "*private security*", "*regulation*", "*bicycle theft*",
    "*neutralization*", "*missing and sexually*", "*open data*", "*confidentiality*",
    "*geocoded health*", "*geographic masking*", "*cultural space*", "*youth crime*",
    "*schoolchildren*", "*psychological characteristics*", "*defence rights*",
    "*intelligence*", "*assemblage*", "*weights-of-evidence*", "*ransom kidnapping*",
    "*addicted to*", "*recognition and respect*", "*taggers*", "*tagging*"
)

Write-Host "`nMoving obvious non-target studies..." -ForegroundColor Yellow
$movedCount = 0

foreach ($pattern in $obviousNonTargets) {
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

Write-Host "`nMoved $movedCount non-target files" -ForegroundColor Green

# Now list remaining files
$remainingFiles = Get-ChildItem -Path $sourceDir -Name "*.pdf" | Sort-Object
Write-Host "`nREMAINING FILES: $($remainingFiles.Count)" -ForegroundColor Cyan

$targetAuthors = @("Bernasco", "Curtis-Ham", "Chamberlain", "Baudains", "Jacques", "Luykx", 
                   "Nieuwbeerta", "Clare", "Frith", "Hanayama", "Johnson", "Summers", "Kuralarasan",
                   "Lammers", "Langton", "Steenbeek", "Long", "Liu", "Marchment", "Gill",
                   "Menting", "van Sleeuwen", "Song", "Townsley", "Vandeviver", "Xiao", "Xue", 
                   "Brown", "Yue", "Rowan", "Appleby", "McGloin", "Smith", "Cai")

$confirmedTargets = @()
$needReview = @()

foreach ($file in $remainingFiles) {
    $isTargetAuthor = $false
    
    foreach ($author in $targetAuthors) {
        if ($file -like "*$author*") {
            $isTargetAuthor = $true
            break
        }
    }
    
    if ($isTargetAuthor) {
        $confirmedTargets += $file
    } else {
        $needReview += $file
    }
}

Write-Host "`nCONFIRMED TARGET STUDIES: $($confirmedTargets.Count)" -ForegroundColor Green
foreach ($file in $confirmedTargets) {
    Write-Host "  $file" -ForegroundColor White
}

Write-Host "`nNEED MANUAL REVIEW: $($needReview.Count)" -ForegroundColor Yellow
foreach ($file in $needReview) {
    Write-Host "  $file" -ForegroundColor White
}
