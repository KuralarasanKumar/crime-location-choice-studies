# Comprehensive Search for All 50 Target Studies
# This script will search for all 50 studies from the table using multiple search patterns

# Define paths
$mainPDFPath = "c:\Users\kukumar\OneDrive - UGent\Job\crimsyndata\-crime-location-choice-studies\snatching work\References\PDFs"
$newPDFPath = "c:\Users\kukumar\OneDrive - UGent\Job\crimsyndata\-crime-location-choice-studies\snatching work\References\new pdf"
$myLibraryPath = "c:\Users\kukumar\OneDrive - UGent\Job\crimsyndata\-crime-location-choice-studies\snatching work\References\new pdf\My Library\files"
$outputFolder = "c:\Users\kukumar\OneDrive - UGent\Job\crimsyndata\-crime-location-choice-studies\snatching work\References\CompleteTargetStudies"

# Create output folder if it doesn't exist
if (-not (Test-Path $outputFolder)) {
    New-Item -ItemType Directory -Path $outputFolder -Force | Out-Null
}

# Define all 50 target studies with multiple search patterns for each
# Format: StudyID = @(@(author1, year1, keyword1), @(author2, year2, keyword2), ...)
$targetStudies = @{
    # Bernasco Studies
    "S01" = @(@("Bernasco", "2013", "Go where the money is"), @("Bernasco", "2013", "street robbers"))
    "S02" = @(@("Bernasco", "2017", "Street Robbery Location"), @("Bernasco", "2017", "Test in Chicago"))
    "S23" = @(@("Bernasco", "2005", "residential burglars"), @("Bernasco", "2005", "target areas"))
    "S24" = @(@("Bernasco", "2006", "Co-offending"), @("Bernasco", "2006", "Target Areas"))
    "S26" = @(@("Bernasco", "2003", "Attractiveness Opportunity"), @("Bernasco", "2003", "Residential Burglary Rates"))
    "S27" = @(@("Bernasco", "2015", "Learning where to offend"), @("Bernasco", "2015", "past on future burglary"))
    "S30" = @(@("Bernasco", "2019", "Adolescent offenders"), @("Bernasco", "2019", "future crime"))
    "S31" = @(@("Bernasco", "2015", "Where Do Dealers Solicit"), @("Bernasco", "2015", "Jacques", "dealers"))
    "S32" = @(@("Bernasco", "2009", "Where offenders choose to attack"), @("Bernasco", "Block", "2009", "Chicago"))
    "S34" = @(@("Bernasco", "2010", "Sentimental Journey"), @("Bernasco", "2010", "Residential History"))
    "S35" = @(@("Bernasco", "2010", "Modeling micro-level"), @("Bernasco", "2010", "discrete choice framework"))
    "S36" = @(@("Bernasco", "2010", "residential history"), @("Bernasco", "Kooistra", "2010"))
    
    # Chamberlain Studies
    "S33" = @(@("Chamberlain", "2016", "Relative Difference"), @("Chamberlain", "Boggess", "2016", "burglary"))
    "S43" = @(@("Chamberlain", "2022", "Traveling Alone"), @("Chamberlain", "2022", "juvenile"))
    
    # Curtis-Ham Studies
    "S19" = @(@("Curtis-Ham", "2022", "Relationships Between Offenders"), @("Curtis-Ham", "2022", "Prior Activity"))
    "S44" = @(@("Curtis-Ham", "2022", "Importance of Importance Sampling"), @("Curtis-Ham", "2022", "Sampling"))
    "S50" = @(@("Curtis-Ham", "2025", "familiar locations"), @("Curtis-Ham", "2025", "similar activities"))
    
    # Clare Studies
    "S03" = @(@("Clare", "2009", "barriers and connectors"), @("Clare", "2009", "burglars"))
    
    # Townsley Studies
    "S04" = @(@("Townsley", "2015", "Burglar Target Selection", "Cross-national", "AU"), @("Townsley", "2015", "Australia"))
    "S05" = @(@("Townsley", "2016", "Target Selection Models"), @("Townsley", "2016", "Preference Variation"))
    "S12" = @(@("Townsley", "2015", "Burglar Target Selection", "UK"), @("Townsley", "2015", "Super Output Areas"))
    "S25" = @(@("Townsley", "2015", "Burglar Target Selection", "NL"), @("Townsley", "2015", "Netherlands"))
    
    # Lammers Studies
    "S06" = @(@("Lammers", "2015", "Biting Once Twice"), @("Lammers", "2015", "crime location choice"))
    "S07" = @(@("Lammers", "2017", "Co-offending groups"), @("Lammers", "2017", "awareness space"))
    
    # Menting Studies
    "S08" = @(@("Menting", "2016", "Family Matters"), @("Menting", "2016", "residential areas"))
    "S13" = @(@("Menting", "2018", "Awareness", "Opportunity"), @("Menting", "2018", "Activity Nodes"))
    "S21" = @(@("Menting", "2020", "Activity Space"), @("Menting", "2020", "Visiting Frequency"))
    
    # Sleeuwen Studies
    "S09" = @(@("Sleeuwen", "2018", "Time for a Crime"), @("Sleeuwen", "2018", "Temporal Aspects"))
    "S22" = @(@("Sleeuwen", "2021", "Right place, right time"), @("Sleeuwen", "2021", "crime pattern theory"))
    
    # Long Studies
    "S15" = @(@("Long", "2018", "Assessing the influence of prior"), @("Long", "2018", "robbery location"))
    "S16" = @(@("Long", "2021", "Ambient population"), @("Long", "2021", "surveillance cameras"))
    "S17" = @(@("Long", "2021", "Migrant and Native Robbers"), @("Long", "Liu", "2021", "Different Places"))
    "S18" = @(@("Long", "2022", "juvenile, young adult"), @("Long", "Liu", "2022", "Chinese context"))
    
    # Other Studies
    "S10" = @(@("Xiao", "2021", "Burglars blocked by barriers"), @("Xiao", "2021", "China"))
    "S11" = @(@("Kuralarasan", "2022", "Location Choice of Snatching"), @("Kuralarasan", "2022", "Chennai"))
    "S14" = @(@("Song", "2019", "Crime Feeds on Legal Activities"), @("Song", "2019", "Daily Mobility Flows"))
    "S20" = @(@("Vandeviver", "2020", "Location Location Location"), @("Vandeviver", "Bernasco", "2020"))
    "S28" = @(@("Frith", "2019", "Modelling taste heterogeneity"), @("Frith", "2019", "offence location"))
    "S29" = @(@("Hanayama", "2018", "usefulness of past crime data"), @("Hanayama", "2018", "attractiveness index"))
    "S37" = @(@("Frith", "2017", "Role of the Street Network"), @("Frith", "2017", "Spatial Decision-Making"))
    "S38" = @(@("Baudains", "2013", "Target Choice During Extreme Events"), @("Baudains", "2013", "London Riots"))
    "S39" = @(@("Johnson", "2015", "Testing Ecological Theories"), @("Johnson", "Summers", "2015"))
    "S40" = @(@("Vandeviver", "2015", "discrete spatial choice model"), @("Vandeviver", "2015", "house-level"))
    "S41" = @(@("Langton", "2017", "Residential burglary target selection"), @("Langton", "Steenbeek", "2017"))
    "S42" = @(@("Marchment", "2019", "spatial decision making of terrorists"), @("Marchment", "Gill", "2019"))
    "S45" = @(@("Yue", "2023", "effect of people on the street"), @("Yue", "2023", "street theft crime"))
    "S46" = @(@("Kuralarasa", "2024", "Graffiti Writers"), @("Kuralarasa", "2024", "Optimize Exposure"))
    "S47" = @(@("Rowan", "2022", "Crime Pattern Theory"), @(@("Rowan", "Appleby", "McGloin", "2022")))
    "S48" = @(@("Smith", "2007", "discrete choice analysis"), @("Smith", "Brown", "2007", "spatial attack sites"))
    "S49" = @(@("Cai", "2024", "divergent decisionmaking"), @("Cai", "2024", "context"))
}

# Function to match file to target study
function Match-TargetStudy {
    param (
        [string]$filePath,
        [hashtable]$targetStudyPatterns
    )
    
    $fileName = [System.IO.Path]::GetFileName($filePath)
    
    foreach ($studyId in $targetStudyPatterns.Keys) {
        $patternSets = $targetStudyPatterns[$studyId]
        
        foreach ($patterns in $patternSets) {
            $matchesAllPatterns = $true
            
            foreach ($pattern in $patterns) {
                if ($fileName -notlike "*$pattern*") {
                    $matchesAllPatterns = $false
                    break
                }
            }
            
            if ($matchesAllPatterns) {
                return $studyId
            }
        }
    }
    
    return $null
}

# Function to search for target studies in a folder
function Find-TargetStudies {
    param (
        [string]$folderPath,
        [string]$folderDescription
    )
    
    Write-Host "Searching for target studies in $folderDescription at $folderPath..."
    
    $foundStudies = @{}
    
    # Check if the folder exists
    if (-not (Test-Path $folderPath)) {
        Write-Host "Folder not found: $folderPath"
        return $foundStudies
    }
    
    # Get all PDF files in the folder and subfolders
    $pdfFiles = Get-ChildItem -Path $folderPath -Filter "*.pdf" -Recurse -ErrorAction SilentlyContinue
    
    Write-Host "Found $($pdfFiles.Count) PDF files in $folderDescription"
    
    foreach ($file in $pdfFiles) {
        if ($file.FullName -notlike "*ToDelete*") {
            $studyId = Match-TargetStudy -filePath $file.FullName -targetStudyPatterns $targetStudies
            
            if ($studyId) {
                if (-not $foundStudies.ContainsKey($studyId)) {
                    $foundStudies[$studyId] = @()
                }
                $foundStudies[$studyId] += $file.FullName
            }
        }
    }
    
    return $foundStudies
}

# Search for target studies in all folders
$allFoundStudies = @{}

# Main PDFs folder
$mainFolderResults = Find-TargetStudies -folderPath $mainPDFPath -folderDescription "main PDFs folder"
foreach ($key in $mainFolderResults.Keys) {
    if (-not $allFoundStudies.ContainsKey($key)) {
        $allFoundStudies[$key] = @()
    }
    $allFoundStudies[$key] += $mainFolderResults[$key]
}

# New PDF folder
$newFolderResults = Find-TargetStudies -folderPath $newPDFPath -folderDescription "new pdf folder"
foreach ($key in $newFolderResults.Keys) {
    if (-not $allFoundStudies.ContainsKey($key)) {
        $allFoundStudies[$key] = @()
    }
    $allFoundStudies[$key] += $newFolderResults[$key]
}

# My Library folder
$libFolderResults = Find-TargetStudies -folderPath $myLibraryPath -folderDescription "My Library folder"
foreach ($key in $libFolderResults.Keys) {
    if (-not $allFoundStudies.ContainsKey($key)) {
        $allFoundStudies[$key] = @()
    }
    $allFoundStudies[$key] += $libFolderResults[$key]
}

# Copy found studies to the output folder
$foundCount = 0
$missingStudies = @()

foreach ($studyId in $targetStudies.Keys | Sort-Object) {
    if ($allFoundStudies.ContainsKey($studyId) -and $allFoundStudies[$studyId].Count -gt 0) {
        $foundCount++
        $sourceFile = $allFoundStudies[$studyId][0]
        $destFile = Join-Path $outputFolder "$studyId.pdf"            try {
                Copy-Item -Path $sourceFile -Destination $destFile -Force
                Write-Host "Copied study ${studyId} from ${sourceFile}"
            }
            catch {
                $errorMsg = $_.Exception.Message
                Write-Host "Error copying study ${studyId}: ${errorMsg}"
            }
    }
    else {
        $missingStudies += $studyId
    }
}

# Generate report
$reportContent = "# COMPREHENSIVE TARGET STUDIES SEARCH REPORT`r`n`r`n"
$reportContent += "Created on $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')`r`n`r`n"
$reportContent += "## SUMMARY`r`n`r`n"
$reportContent += "Total studies found: $foundCount out of 50 ($(($foundCount / 50) * 100)%)`r`n"
$reportContent += "Total studies missing: $($missingStudies.Count) out of 50`r`n`r`n"

$reportContent += "## FOUND STUDIES ($foundCount)`r`n`r`n"
foreach ($studyId in ($allFoundStudies.Keys | Sort-Object)) {
    $reportContent += "### $studyId`r`n"
    foreach ($file in $allFoundStudies[$studyId]) {
        $relativePath = $file.Replace("c:\Users\kukumar\OneDrive - UGent\Job\crimsyndata\-crime-location-choice-studies\snatching work\", "")
        $reportContent += "- $relativePath`r`n"
    }
    $reportContent += "`r`n"
}

$reportContent += "## MISSING STUDIES ($($missingStudies.Count))`r`n`r`n"
foreach ($studyId in $missingStudies) {
    $reportContent += "### $studyId`r`n"
    $patterns = $targetStudies[$studyId] | ForEach-Object { $_ -join ", " }
    $reportContent += "Search patterns: $($patterns -join " | ")`r`n`r`n"
}

# Save report
$reportFile = Join-Path $outputFolder "comprehensive_search_report.txt"
$reportContent | Out-File -FilePath $reportFile -Encoding utf8

Write-Host "`r`nSearch complete!"
Write-Host "Found $foundCount out of 50 target studies"
Write-Host "Missing $($missingStudies.Count) target studies"
Write-Host "Report saved to $reportFile"
