# Simple Target Finder Script
# This script uses a more basic approach to find target studies

# Define paths
$mainPDFPath = Join-Path $PWD "PDFs"
$newPDFPath = Join-Path $PWD "new pdf"
$targetOutputFolder = Join-Path $PWD "ImprovedTargetStudies"

# Create output folder if needed
if (-not (Test-Path $targetOutputFolder)) {
    New-Item -ItemType Directory -Path $targetOutputFolder -Force | Out-Null
    Write-Host "Created output folder: $targetOutputFolder"
}

# Define studies with flexible search patterns
$targetStudies = @{
    "S05_Townsley_2016_Target_Selection_Models" = @("Townsley", "2016", "Target Selection")
    "S02_Bernasco_2017_Street_Robbery_Location_Chicago" = @("Bernasco", "2017", "Robbery")
    "S03_Clare_2009_barriers_connectors" = @("Clare", "2009")
    "S04_Townsley_2015_Burglar_Target_Selection_AU" = @("Townsley", "2015", "Australia")
    "S06_Lammers_2015_Biting_Once_Twice" = @("Lammers", "2015")
    "S07_Lammers_2017_Co_offending_groups" = @("Lammers", "2017")
    "S10_Xiao_2021_Burglars_blocked_barriers" = @("Xiao", "2021")
    "S12_Townsley_2015_Burglar_Target_Selection_UK" = @("Townsley", "2015", "UK")
    "S14_Song_2019_Crime_Feeds_Legal_Activities" = @("Song", "2019")
    "S15_Long_2018_Assessing_influence_prior" = @("Long", "2018")
    "S16_Long_2021_Ambient_population_surveillance" = @("Long", "2021", "Ambient")
    "S18_Long_2022_juvenile_young_adult" = @("Long", "2022")
    "S23_Bernasco_Nieuwbeerta_2005_residential_burglars" = @("Bernasco", "Nieuwbeerta", "2005")
    "S24_Bernasco_2006_Co_offending_Target" = @("Bernasco", "2006", "Co-offending")
    "S25_Townsley_2015_Burglar_Target_NL" = @("Townsley", "2015", "Netherlands")
    "S26_Bernasco_2003_Effect_Attractiveness" = @("Bernasco", "2003")
}

# Function to search for a file matching patterns
function Find-FileByPatterns {
    param (
        [string]$folderPath,
        [array]$patterns
    )
    
    $allFiles = Get-ChildItem -Path $folderPath -Filter "*.pdf" -Recurse -ErrorAction SilentlyContinue
    
    foreach ($file in $allFiles) {
        $matchCount = 0
        $requiredMatches = [math]::Min(2, $patterns.Count)
        
        foreach ($pattern in $patterns) {
            if ($file.Name -like "*$pattern*") {
                $matchCount++
            }
        }
        
        if ($matchCount -ge $requiredMatches) {
            return $file.FullName
        }
    }
    
    return $null
}

# Process each target study
$foundStudies = @()
$missingStudies = @()

foreach ($studyKey in $targetStudies.Keys) {
    $patterns = $targetStudies[$studyKey]
    
    # Try to find in main PDFs folder
    $filePath = Find-FileByPatterns -folderPath $mainPDFPath -patterns $patterns
    
    # If not found in main folder, try new pdf folder
    if (-not $filePath) {
        $filePath = Find-FileByPatterns -folderPath $newPDFPath -patterns $patterns
    }
    
    if ($filePath) {
        $destFileName = "$studyKey.pdf"
        $destPath = Join-Path $targetOutputFolder $destFileName
        
        try {
            Copy-Item -Path $filePath -Destination $destPath -Force
            Write-Host "Found and copied $studyKey from $filePath"
            $foundStudies += $studyKey
        }
        catch {
            Write-Host "Error copying $studyKey: $($_.Exception.Message)" -ForegroundColor Red
            $missingStudies += $studyKey
        }
    }
    else {
        Write-Host "Could not find $studyKey" -ForegroundColor Yellow
        $missingStudies += $studyKey
    }
}

# Generate report
$reportContent = "# SIMPLE TARGET FINDER RESULTS`r`n`r`n"
$reportContent += "Created on $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')`r`n`r`n"
$reportContent += "## FOUND STUDIES ($($foundStudies.Count))`r`n`r`n"

foreach ($study in $foundStudies | Sort-Object) {
    $reportContent += "- $study`r`n"
}

$reportContent += "`r`n## MISSING STUDIES ($($missingStudies.Count))`r`n`r`n"

foreach ($study in $missingStudies | Sort-Object) {
    $patterns = $targetStudies[$study] -join ", "
    $reportContent += "- $study (Search patterns: $patterns)`r`n"
}

$reportPath = Join-Path $targetOutputFolder "simple_search_report.txt"
$reportContent | Out-File -FilePath $reportPath -Encoding utf8

Write-Host "`r`nSearch completed!"
Write-Host "Found and copied $($foundStudies.Count) target studies"
Write-Host "Missing $($missingStudies.Count) target studies"
Write-Host "Report saved to: $reportPath"
