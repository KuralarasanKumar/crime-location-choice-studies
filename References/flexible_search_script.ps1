# Flexible Target Studies Search Script
# This script uses flexible matching patterns to find target studies

# Define paths
$mainPDFPath = "c:\Users\kukumar\OneDrive - UGent\Job\crimsyndata\-crime-location-choice-studies\snatching work\References\PDFs"
$newPDFPath = "c:\Users\kukumar\OneDrive - UGent\Job\crimsyndata\-crime-location-choice-studies\snatching work\References\new pdf"
$myLibraryPath = "c:\Users\kukumar\OneDrive - UGent\Job\crimsyndata\-crime-location-choice-studies\snatching work\References\new pdf\My Library\files"

# Create organized folder for the target studies
$organizedFolder = "c:\Users\kukumar\OneDrive - UGent\Job\crimsyndata\-crime-location-choice-studies\snatching work\References\FlexibleMatchResults"
if (-not (Test-Path $organizedFolder)) {
    New-Item -ItemType Directory -Path $organizedFolder -Force
}

# Define flexible search patterns for each study
$targetStudies = @{
    "S01" = @(@("Bernasco", "2013", "money"), @("Bernasco", "2013", "robber"))
    "S02" = @(@("Bernasco", "2017", "Street Rob"), @("Bernasco", "2017", "Chicago"), @("Bernasco", "2017", "Day of Week"))
    "S03" = @(@("Clare", "2009", "barrier"), @("Clare", "2009", "burglar"), @("Clare", "2009", "formal evaluation"))
    "S04" = @(@("Townsley", "2015", "Burglar", "Australia"), @("Townsley", "2015", "Cross-national", "statistical local"), @("Townsley", "2015", "AU"))
    "S05" = @(@("Townsley", "2016", "Target Selection"), @("Townsley", "2016", "Preference"), @("Townsley", "2016", "Variation"))
    "S06" = @(@("Lammers", "2015", "Biting"), @("Lammers", "2015", "location choice"), @("Lammers", "2015", "Prior"))
    "S07" = @(@("Lammers", "2017", "Co-offend"), @("Lammers", "2017", "awareness space"))
    "S08" = @(@("Menting", "2016", "Family"), @("Menting", "2016", "Residential"), @("Menting", "2016", "Crime Location"))
    "S09" = @(@("Sleeuwen", "2018", "Time"), @("Sleeuwen", "2018", "Temporal"), @("Sleeuwen", "2018", "Repeat"))
    "S10" = @(@("Xiao", "2021", "barrier"), @("Xiao", "2021", "China"), @("Xiao", "2021", "burglars"))
    "S11" = @(@("Kuralarasan", "2022", "Snatching"), @("Kuralarasan", "2022", "Chennai"), @("Kuralarasan", "2022", "Location Choice"))
    "S12" = @(@("Townsley", "2015", "Burglar", "UK"), @("Townsley", "2015", "Cross-national", "Super Output"), @("Townsley", "2015"))
    "S13" = @(@("Menting", "2018", "Awareness"), @("Menting", "2018", "Opportunity"), @("Menting", "2018", "Activity"))
    "S14" = @(@("Song", "2019", "Crime Feed"), @("Song", "2019", "Mobility"), @("Song", "2019", "Target Location"))
    "S15" = @(@("Long", "2018", "prior"), @("Long", "2018", "robbery"), @("Long", "2018", "location"))
    "S16" = @(@("Long", "2021", "Ambient"), @("Long", "2021", "surveillance"), @("Long", "2021", "cameras"))
    "S17" = @(@("Long", "2021", "Migrant"), @("Long", "2021", "Native"), @("Long", "2021", "Robbers"))
    "S18" = @(@("Long", "2022", "juvenile"), @("Long", "2022", "adult"), @("Long", "2022", "Chinese"))
    "S19" = @(@("Curtis-Ham", "2022", "Relationship"), @("Curtis-Ham", "2022", "Crime Location"), @("Curtis-Ham", "2022", "Prior Activity"))
    "S20" = @(@("Vandeviver", "2020", "Location"), @("Vandeviver", "2020", "Neighborhood"), @("Vandeviver", "2020", "House"))
    "S21" = @(@("Menting", "2020", "Activity Space"), @("Menting", "2020", "Visiting"), @("Menting", "2020", "Survey"))
    "S22" = @(@("Sleeuwen", "2021", "Right place"), @("Sleeuwen", "2021", "right time"), @("Sleeuwen", "2021", "crime pattern"))
    "S23" = @(@("Bernasco", "2005", "residential burglar"), @("Bernasco", "2005", "target area"), @("Bernasco", "2005", "analysis"))
    "S24" = @(@("Bernasco", "2006", "Co-offending"), @("Bernasco", "2006", "Target"), @("Bernasco", "2006", "Area"))
    "S25" = @(@("Townsley", "2015", "Burglar", "NL"), @("Townsley", "2015", "Cross-national", "Neighborhood"), @("Townsley", "2015"))
    "S26" = @(@("Bernasco", "2003", "Attractiveness"), @("Bernasco", "2003", "Opportunity"), @("Bernasco", "2003", "Residential Burglary"))
    "S27" = @(@("Bernasco", "2015", "Learning"), @("Bernasco", "2015", "offend"), @("Bernasco", "2015", "location"))
    "S28" = @(@("Frith", "2019", "taste"), @("Frith", "2019", "heterogeneity"), @("Frith", "2019", "offence location"))
    "S29" = @(@("Hanayama", "2018", "past crime"), @("Hanayama", "2018", "attractiveness"), @("Hanayama", "2018", "residential"))
    "S30" = @(@("Bernasco", "2019", "Adolescent"), @("Bernasco", "2019", "whereabouts"), @("Bernasco", "2019", "future crime"))
    "S31" = @(@("Bernasco", "2015", "Dealer"), @("Bernasco", "2015", "Solicit"), @("Bernasco", "2015", "Jacques"))
    "S32" = @(@("Bernasco", "2009", "attack"), @("Bernasco", "2009", "Block"), @("Bernasco", "2009", "Chicago"))
    "S33" = @(@("Chamberlain", "2016", "Relative"), @("Chamberlain", "2016", "Difference"), @("Chamberlain", "2016", "burglary"))
    "S34" = @(@("Bernasco", "2010", "Sentimental"), @("Bernasco", "2010", "Journey"), @("Bernasco", "2010", "Residential History"))
    "S35" = @(@("Bernasco", "2010", "Modeling"), @("Bernasco", "2010", "Micro"), @("Bernasco", "2010", "Application"))
    "S36" = @(@("Bernasco", "2010", "Kooistra"), @("Bernasco", "2010", "Residential history"), @("Bernasco", "2010", "Commercial"))
    "S37" = @(@("Frith", "2017", "Street Network"), @("Frith", "2017", "Burglar"), @("Frith", "2017", "Decision"))
    "S38" = @(@("Baudains", "2013", "Target Choice"), @("Baudains", "2013", "Extreme"), @("Baudains", "2013", "London Riots"))
    "S39" = @(@("Johnson", "2015", "Ecological"), @("Johnson", "2015", "Spatial Decision"), @("Johnson", "2015", "Summers"))
    "S40" = @(@("Vandeviver", "2015", "discrete"), @("Vandeviver", "2015", "house-level"), @("Vandeviver", "2015", "burglary"))
    "S41" = @(@("Langton", "2017", "Residential burglar"), @("Langton", "2017", "target selection"), @("Langton", "2017", "Street View"))
    "S42" = @(@("Marchment", "2019", "spatial"), @("Marchment", "2019", "terrorist"), @("Marchment", "2019", "decision"))
    "S43" = @(@("Chamberlain", "2022", "Traveling"), @("Chamberlain", "2022", "Alone"), @("Chamberlain", "2022", "Together"))
    "S44" = @(@("Curtis-Ham", "2022", "Importance"), @("Curtis-Ham", "2022", "Sampling"), @("Curtis-Ham", "2022", "Discrete Choice"))
    "S45" = @(@("Yue", "2023", "street"), @("Yue", "2023", "physical"), @("Yue", "2023", "street theft"))
    "S46" = @(@("Kuralarasa", "2024", "Graffiti"), @("Kuralarasa", "2024", "location"), @("Kuralarasa", "2024", "exposure"))
    "S47" = @(@("Rowan", "2022", "Crime Pattern"), @("Rowan", "2022", "Co-Offending"), @("Rowan", "2022", "Convergence"))
    "S48" = @(@("Smith", "2007", "Brown"), @("Smith", "2007", "spatial attack"), @("Smith", "2007", "discrete choice"))
    "S49" = @(@("Cai", "2024", "divergent"), @("Cai", "2024", "neighborhood"), @("Cai", "2024", "burglars"))
    "S50" = @(@("Curtis-Ham", "2025", "familiar"), @("Curtis-Ham", "2025", "similar"), @("Curtis-Ham", "2025", "reliable"))
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

# Function to scan a directory for target studies
function Find-TargetStudies {
    param (
        [string]$folderPath
    )
    
    Write-Host "Scanning $folderPath..."
    
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
        foreach ($studyId in $targetStudies.Keys) {
            $patterns = $targetStudies[$studyId]
            
            if (Test-FlexibleMatch -fileName $file.Name -patterns $patterns) {
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
$mainResults = Find-TargetStudies -folderPath $mainPDFPath
foreach ($studyId in $mainResults.Keys) {
    if (-not $allFoundStudies.ContainsKey($studyId)) {
        $allFoundStudies[$studyId] = @()
    }
    $allFoundStudies[$studyId] += $mainResults[$studyId]
}

# Scan new pdf folder
$newResults = Find-TargetStudies -folderPath $newPDFPath
foreach ($studyId in $newResults.Keys) {
    if (-not $allFoundStudies.ContainsKey($studyId)) {
        $allFoundStudies[$studyId] = @()
    }
    $allFoundStudies[$studyId] += $newResults[$studyId]
}

# Scan My Library folder if it exists
if (Test-Path $myLibraryPath) {
    $libResults = Find-TargetStudies -folderPath $myLibraryPath
    foreach ($studyId in $libResults.Keys) {
        if (-not $allFoundStudies.ContainsKey($studyId)) {
            $allFoundStudies[$studyId] = @()
        }
        $allFoundStudies[$studyId] += $libResults[$studyId]
    }
}

# Copy found studies to organized folder
Write-Host "Copying found target studies to $organizedFolder..."

foreach ($studyId in $allFoundStudies.Keys) {
    if ($allFoundStudies[$studyId].Count -gt 0) {
        $sourcePath = $allFoundStudies[$studyId][0] # Use the first found file
        $destPath = Join-Path $organizedFolder "$studyId.pdf"
        
        try {
            Copy-Item -Path $sourcePath -Destination $destPath -Force
            Write-Host "Copied $studyId from $sourcePath"
        }
        catch {
            Write-Host "Error copying $studyId: $($_.Exception.Message)"
        }
    }
}

# Generate report
$reportPath = Join-Path $organizedFolder "flexible_search_report.txt"
$report = "# FLEXIBLE SEARCH RESULTS`r`n`r`n"
$report += "Created on $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')`r`n`r`n"
$report += "## FOUND STUDIES ($($allFoundStudies.Keys.Count) out of 50)`r`n`r`n"

foreach ($studyId in ($allFoundStudies.Keys | Sort-Object)) {
    $report += "### $studyId`r`n"
    foreach ($filePath in $allFoundStudies[$studyId]) {
        $report += "- $filePath`r`n"
    }
    $report += "`r`n"
}

$report += "## MISSING STUDIES ($((50 - $allFoundStudies.Keys.Count)))`r`n`r`n"
foreach ($studyId in ($targetStudies.Keys | Sort-Object)) {
    if (-not $allFoundStudies.ContainsKey($studyId)) {
        $report += "### $studyId`r`n"
        $report += "Search patterns:`r`n"
        foreach ($patternSet in $targetStudies[$studyId]) {
            $report += "- " + ($patternSet -join ", ") + "`r`n"
        }
        $report += "`r`n"
    }
}

$report | Out-File -FilePath $reportPath -Encoding utf8

Write-Host "`r`nSearch complete! Report saved to $reportPath"
Write-Host "Found $($allFoundStudies.Keys.Count) out of 50 target studies"
Write-Host "Files have been copied to $organizedFolder"
