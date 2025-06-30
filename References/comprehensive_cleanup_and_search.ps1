# Comprehensive cleanup and search for target studies
# Remove obvious non-target studies and find additional target studies

$sourceDir = "c:\Users\kukumar\OneDrive - UGent\Job\crimsyndata\-crime-location-choice-studies\snatching work\References\PDFs"
$deleteDir = "c:\Users\kukumar\OneDrive - UGent\Job\crimsyndata\-crime-location-choice-studies\snatching work\References\PDFs\ToDelete"

# Ensure ToDelete directory exists
if (!(Test-Path $deleteDir)) {
    New-Item -Path $deleteDir -ItemType Directory -Force
}

Write-Host "🔍 COMPREHENSIVE CLEANUP AND TARGET SEARCH" -ForegroundColor Yellow
Write-Host "==========================================" -ForegroundColor Yellow

# Get all PDF files in main folder
$allFiles = Get-ChildItem -Path $sourceDir -Name "*.pdf" | Sort-Object

Write-Host "`n📄 CURRENT FILES IN MAIN FOLDER: $($allFiles.Count)" -ForegroundColor Cyan

# Known authors/keywords for target studies from the table
$targetAuthors = @(
    "Bernasco", "Curtis-Ham", "Chamberlain", "Baudains", "Jacques", "Luykx", 
    "Nieuwbeerta", "Clare", "Frith", "Hanayama", "Johnson", "Summers", "Kuralarasan",
    "Lammers", "Langton", "Steenbeek", "Long", "Liu", "Marchment", "Gill",
    "Menting", "van Sleeuwen", "Song", "Townsley", "Vandeviver", "Xiao", "Xue", 
    "Brown", "Yue", "Rowan", "Appleby", "McGloin", "Smith", "Cai"
)

# Obvious non-target keywords (files that are clearly not crime location choice studies)
$nonTargetKeywords = @(
    "corruption", "corrupt", "organizational", "injustice", "housing design", "crime prevention",
    "evidence based policing", "pickpocketing", "air quality", "graffiti", "career and ideology",
    "freedom of information", "private security", "regulation", "bicycle theft", "metrorail",
    "assemblage", "weights-of-evidence", "ransom kidnapping", "policing and security", "addicted to",
    "recognition and respect", "neutralization techniques", "missing and sexually exploited",
    "uptown neighborhood", "open data", "core competences", "confidentiality", "geocoded health",
    "geographic masking", "cultural space", "youth crime", "schoolchildren", "college students",
    "psychological characteristics", "defence rights", "intelligence", "terrorism", "hive", "bees",
    "kick the", "spatial structure of sites", "crime potential modelling", "taggers", "tagging"
)

$confirmedTargets = @()
$likelyNonTargets = @()
$needReview = @()

Write-Host "`n🎯 ANALYZING FILES..." -ForegroundColor Cyan

foreach ($file in $allFiles) {
    $fileName = $file.ToLower()
    $isTargetAuthor = $false
    $isNonTarget = $false
    
    # Check if file contains target authors
    foreach ($author in $targetAuthors) {
        if ($fileName -like "*$($author.ToLower())*") {
            $isTargetAuthor = $true
            break
        }
    }
    
    # Check if file contains non-target keywords
    foreach ($keyword in $nonTargetKeywords) {
        if ($fileName -like "*$($keyword.ToLower())*") {
            $isNonTarget = $true
            break
        }
    }
    
    if ($isNonTarget) {
        $likelyNonTargets += $file
        Write-Host "❌ Non-target: $file" -ForegroundColor Red
    } elseif ($isTargetAuthor) {
        $confirmedTargets += $file
        Write-Host "✅ Target author: $file" -ForegroundColor Green
    } else {
        $needReview += $file
        Write-Host "🔍 Needs review: $file" -ForegroundColor Yellow
    }
}

Write-Host "`n📊 ANALYSIS RESULTS:" -ForegroundColor Cyan
Write-Host "Target author files: $($confirmedTargets.Count)" -ForegroundColor Green
Write-Host "Likely non-targets: $($likelyNonTargets.Count)" -ForegroundColor Red
Write-Host "Need manual review: $($needReview.Count)" -ForegroundColor Yellow

# Move obvious non-targets
Write-Host "`n🧹 MOVING OBVIOUS NON-TARGETS..." -ForegroundColor Yellow
$movedCount = 0

foreach ($file in $likelyNonTargets) {
    $sourcePath = Join-Path $sourceDir $file
    $destPath = Join-Path $deleteDir $file
    
    try {
        Move-Item -Path $sourcePath -Destination $destPath -Force
        $movedCount++
    } catch {
        Write-Host "❌ Failed to move: $file" -ForegroundColor Red
    }
}

Write-Host "✅ Moved $movedCount non-target files" -ForegroundColor Green

Write-Host "`n🎯 CONFIRMED TARGET STUDIES:" -ForegroundColor Green
Write-Host "=============================" -ForegroundColor Green
foreach ($file in $confirmedTargets) {
    Write-Host "📄 $file" -ForegroundColor White
}

Write-Host "`n🔍 FILES NEEDING MANUAL REVIEW:" -ForegroundColor Yellow
Write-Host "===============================" -ForegroundColor Yellow
foreach ($file in $needReview) {
    Write-Host "📄 $file" -ForegroundColor White
}
