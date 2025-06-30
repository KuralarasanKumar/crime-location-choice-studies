# Search for Missing Studies Script
# This script specifically looks for the 10 previously missing studies

# Define paths
$mainPDFPath = "c:\Users\kukumar\OneDrive - UGent\Job\crimsyndata\-crime-location-choice-studies\snatching work\References\PDFs"
$newPDFPath = "c:\Users\kukumar\OneDrive - UGent\Job\crimsyndata\-crime-location-choice-studies\snatching work\References\new pdf"
$myLibraryPath = "c:\Users\kukumar\OneDrive - UGent\Job\crimsyndata\-crime-location-choice-studies\snatching work\References\new pdf\My Library\files"

# Create organized folder for the missing studies
$organizedFolder = "c:\Users\kukumar\OneDrive - UGent\Job\crimsyndata\-crime-location-choice-studies\snatching work\References\CompletedStudies"
if (-not (Test-Path $organizedFolder)) {
    New-Item -ItemType Directory -Path $organizedFolder -Force
}

# Copy existing organized studies to the new folder
$ultraSimpleOrg = "c:\Users\kukumar\OneDrive - UGent\Job\crimsyndata\-crime-location-choice-studies\snatching work\References\UltraSimpleOrganization"
if (Test-Path $ultraSimpleOrg) {
    Write-Host "Copying existing organized studies..."
    Copy-Item -Path $ultraSimpleOrg\* -Destination $organizedFolder -Recurse
}

# Define flexible search patterns for the 10 missing studies
$missingStudies = @{
    "S02" = @(@("Bernasco", "2017", "Street Rob"), @("Bernasco", "2017", "Chicago"), @("Bernasco", "2017", "Day of Week"), @("Bernasco", "Day of Week"), @("Bernasco", "Street", "Robbery", "Chicago"))
    "S03" = @(@("Clare", "2009", "barrier"), @("Clare", "2009", "burglar"), @("Clare", "2009", "formal evaluation"), @("Clare", "barrier", "burglars"), @("Clare", "burglar", "formal"))
    "S07" = @(@("Lammers", "2017", "Co-offend"), @("Lammers", "2017", "awareness space"), @("Lammers", "Co-offending"), @("Lammers", "awareness", "space"))
    "S10" = @(@("Xiao", "2021", "barrier"), @("Xiao", "2021", "China"), @("Xiao", "2021", "burglars"), @("Xiao", "barrier", "China"), @("Xiao", "burglars", "China"))
    "S15" = @(@("Long", "2018", "prior"), @("Long", "2018", "robbery"), @("Long", "2018", "location"), @("Long", "prior", "robbery"), @("Long", "robbery", "location"))
    "S16" = @(@("Long", "2021", "Ambient"), @("Long", "2021", "surveillance"), @("Long", "2021", "cameras"), @("Long", "Ambient", "surveillance"), @("Long", "surveillance", "cameras"))
    "S18" = @(@("Long", "2022", "juvenile"), @("Long", "2022", "adult"), @("Long", "2022", "Chinese"), @("Long", "juvenile", "adult"), @("Long", "adult", "Chinese"))
    "S19" = @(@("Curtis-Ham", "2022", "Relationship"), @("Curtis-Ham", "2022", "Crime Location"), @("Curtis-Ham", "2022", "Prior Activity"), @("Curtis-Ham", "Relationship", "Crime"), @("Curtis-Ham", "Crime", "Prior"))
    "S45" = @(@("Yue", "2023", "street"), @("Yue", "2023", "physical"), @("Yue", "2023", "street theft"), @("Yue", "street", "theft"), @("Yue", "physical", "theft"))
    "S49" = @(@("Cai", "2024", "divergent"), @("Cai", "2024", "neighborhood"), @("Cai", "2024", "burglars"), @("Cai", "divergent", "neighborhood"), @("Cai", "neighborhood", "burglars"))
}

# Function to check if file matches a study with flexible patterns
function Test-FlexibleMatch {
    param (
        [string]$fileName,
        [array]$patterns
    )
    
    foreach ($patternSet in $patterns) {
        $matchCount = 0
        $requiredMatches = [Math]::Min(2, $patternSet.Count) # Require at least 2 matches
        
        foreach ($pattern in $patternSet) {
            if ($fileName -match [regex]::Escape($pattern)) {
                $matchCount++
            }
        }
        
        if ($matchCount -ge $requiredMatches) {
            return $true
        }
    }
    
    return $false
}

# Add more flexible broad matching for very difficult to find studies
function Test-BroadMatch {
    param (
        [string]$fileName,
        [string]$studyId
    )
    
    switch ($studyId) {
        "S02" { return ($fileName -match "Bernasco" -and $fileName -match "2017" -and ($fileName -match "Street" -or $fileName -match "Chicago" -or $fileName -match "Day")) }
        "S03" { return ($fileName -match "Clare" -and $fileName -match "2009") }
        "S07" { return ($fileName -match "Lammers" -and $fileName -match "2017") }
        "S10" { return ($fileName -match "Xiao" -and $fileName -match "2021") }
        "S15" { return ($fileName -match "Long" -and $fileName -match "2018") }
        "S16" { return ($fileName -match "Long" -and $fileName -match "2021" -and ($fileName -match "Ambient" -or $fileName -match "surveillance")) }
        "S18" { return ($fileName -match "Long" -and $fileName -match "2022") }
        "S19" { return ($fileName -match "Curtis-Ham" -and $fileName -match "2022") }
        "S45" { return ($fileName -match "Yue" -and $fileName -match "2023") }
        "S49" { return ($fileName -match "Cai" -and $fileName -match "2024") }
        default { return $false }
    }
}

# Function to scan a directory for missing studies with very flexible matching
function Find-MissingStudies {
    param (
        [string]$folderPath
    )
    
    Write-Host "Scanning $folderPath for missing studies..."
    
    $foundStudies = @{}
    
    # Check if the folder exists
    if (-not (Test-Path $folderPath)) {
        Write-Host "Folder not found: $folderPath"
        return $foundStudies
    }
    
    # Get all PDF files in the folder and subfolders
    $pdfFiles = Get-ChildItem -Path $folderPath -Filter "*.pdf" -Recurse -ErrorAction SilentlyContinue
    
    Write-Host "Found $($pdfFiles.Count) PDF files to examine"
    
    foreach ($file in $pdfFiles) {
        foreach ($studyId in $missingStudies.Keys) {
            $patterns = $missingStudies[$studyId]
            
            if ((Test-FlexibleMatch -fileName $file.Name -patterns $patterns) -or 
                (Test-BroadMatch -fileName $file.Name -studyId $studyId)) {
                
                if (-not $foundStudies.ContainsKey($studyId)) {
                    $foundStudies[$studyId] = @()
                }
                
                $foundStudies[$studyId] += $file.FullName
            }
        }
    }
    
    return $foundStudies
}

# Main script execution
$allFoundStudies = @{}

# Scan main PDFs folder
$mainResults = Find-MissingStudies -folderPath $mainPDFPath
foreach ($studyId in $mainResults.Keys) {
    if (-not $allFoundStudies.ContainsKey($studyId)) {
        $allFoundStudies[$studyId] = @()
    }
    $allFoundStudies[$studyId] += $mainResults[$studyId]
}

# Scan new pdf folder
$newResults = Find-MissingStudies -folderPath $newPDFPath
foreach ($studyId in $newResults.Keys) {
    if (-not $allFoundStudies.ContainsKey($studyId)) {
        $allFoundStudies[$studyId] = @()
    }
    $allFoundStudies[$studyId] += $newResults[$studyId]
}

# Scan My Library folder if it exists
if (Test-Path $myLibraryPath) {
    $libResults = Find-MissingStudies -folderPath $myLibraryPath
    foreach ($studyId in $libResults.Keys) {
        if (-not $allFoundStudies.ContainsKey($studyId)) {
            $allFoundStudies[$studyId] = @()
        }
        $allFoundStudies[$studyId] += $libResults[$studyId]
    }
}

# Organize found studies
Write-Host "Organizing found missing studies..."

foreach ($studyId in $allFoundStudies.Keys) {
    if ($allFoundStudies[$studyId].Count -gt 0) {
        $studyFolder = Join-Path $organizedFolder $studyId
        
        # Create study folder if it doesn't exist
        if (-not (Test-Path $studyFolder)) {
            New-Item -ItemType Directory -Path $studyFolder -Force | Out-Null
        }
        
        $sourcePath = $allFoundStudies[$studyId][0] # Use the first found file
        $destPath = Join-Path $studyFolder "$studyId.pdf"
        
        try {
            Copy-Item -Path $sourcePath -Destination $destPath -Force
            Write-Host "Copied $studyId from $sourcePath"
        }
        catch {
            Write-Host "Error copying ${studyId}: $($_.Exception.Message)"
        }
    }
}

# Generate updated organization report
$reportPath = Join-Path $organizedFolder "complete_organization_report.txt"
$report = "# COMPLETE PDF ORGANIZATION SUMMARY`r`n`r`n"
$report += "Date: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')`r`n`r`n"

# Count organized studies
$organizedStudyFolders = Get-ChildItem -Path $organizedFolder -Directory
$foundCount = $organizedStudyFolders.Count

# Calculate missing studies
$stillMissing = @()
foreach ($studyId in $missingStudies.Keys) {
    if (-not (Test-Path (Join-Path $organizedFolder $studyId))) {
        $stillMissing += $studyId
    }
}

$report += "## OVERVIEW`r`n`r`n"
$report += "We've organized the PDFs for the Crime Location Choice Studies as requested.`r`n"
$report += "Here's a summary of what was done:`r`n`r`n"
$report += "1. We found and organized $foundCount out of 50 studies ($(($foundCount / 50) * 100)%).`r`n"
$report += "2. The remaining $(50 - $foundCount) studies ($(((50 - $foundCount) / 50) * 100)%) could not be found in the available PDF files.`r`n`r`n"

$report += "## FOUND STUDIES ($foundCount)`r`n`r`n"
$report += ($organizedStudyFolders.Name | Sort-Object) -join ", "
$report += "`r`n`r`n"

$report += "## MISSING STUDIES ($(50 - $foundCount))`r`n`r`n"
if ($stillMissing.Count -gt 0) {
    $report += ($stillMissing | Sort-Object) -join ", "
    $report += "`r`n`r`n"
} else {
    $report += "All studies have been found and organized!`r`n`r`n"
}

$report += "## ORGANIZATION DETAILS`r`n`r`n"
$report += "- All found PDFs have been organized into folders in the 'CompletedStudies' directory.`r`n"
$report += "- Each folder is named after the study ID (e.g., S01, S02) for easy reference.`r`n"
$report += "- The most recent search focused specifically on finding the 10 previously missing studies.`r`n`r`n"

$report | Out-File -FilePath $reportPath -Encoding utf8

Write-Host "`r`nOrganization complete! Report saved to $reportPath"
Write-Host "Found and organized $foundCount out of 50 target studies"
if ($stillMissing.Count -gt 0) {
    Write-Host "Still missing: $($stillMissing -join ', ')"
} else {
    Write-Host "All studies have been found and organized!"
}
