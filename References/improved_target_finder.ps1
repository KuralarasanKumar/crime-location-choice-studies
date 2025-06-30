# Improved Target PDF Finder Script
# This script uses more flexible matching patterns to find target studies

# Define paths
$mainPDFPath = "c:\Users\kukumar\OneDrive - UGent\Job\crimsyndata\-crime-location-choice-studies\snatching work\References\PDFs"
$newPDFPath = "c:\Users\kukumar\OneDrive - UGent\Job\crimsyndata\-crime-location-choice-studies\snatching work\References\new pdf"
$myLibraryPath = "c:\Users\kukumar\OneDrive - UGent\Job\crimsyndata\-crime-location-choice-studies\snatching work\References\new pdf\My Library\files"
$targetOutputFolder = "c:\Users\kukumar\OneDrive - UGent\Job\crimsyndata\-crime-location-choice-studies\snatching work\References\ImprovedTargetStudies"

# Create output folder if it doesn't exist
if (-not (Test-Path $targetOutputFolder)) {
    New-Item -ItemType Directory -Path $targetOutputFolder -Force | Out-Null
    Write-Host "Created folder: $targetOutputFolder"
}

# Define study patterns with multiple variations for more flexible matching
$studyPatterns = @{
    "S01" = @("Bernasco", "2013", "Go where the money is", "street robbers", "modeling street")
    "S02" = @("Bernasco", "2017", "Street Robbery Location", "Time of Day", "Day of Week", "Chicago")
    "S03" = @("Clare", "2009", "barriers", "connectors", "residential burglars", "macro-level")
    "S04" = @("Townsley", "2015", "Burglar Target Selection", "Cross-national", "Australia", "statistical local areas")
    "S05" = @("Townsley", "2016", "Target Selection Models", "Preference Variation Between Offenders")
    "S06" = @("Lammers", "2015", "Biting Once", "Twice", "Influence of Prior", "crime location")
    "S07" = @("Lammers", "2017", "Co-offenders", "Co-offending", "groups", "shared awareness")
    "S08" = @("Menting", "2016", "Family Matters", "Family Members", "Residential Areas", "Crime Location")
    "S09" = @("Sleeuwen", "2018", "Time for a Crime", "Temporal Aspects", "Repeat Offenders")
    "S10" = @("Xiao", "2021", "Burglars blocked by barriers", "China", "burglars target location")
    "S11" = @("Kuralarasan", "2022", "Location Choice of Snatching", "Chennai City", "Snatching Offenders")
    "S12" = @("Townsley", "2015", "Burglar Target Selection", "Cross-national", "UK", "Super Output Areas")
    "S13" = @("Menting", "2018", "Awareness", "Opportunity", "Testing Interactions", "Activity Nodes")
    "S14" = @("Song", "2019", "Crime Feeds", "Legal Activities", "Daily Mobility", "Thieves")
    "S15" = @("Long", "2018", "Assessing the influence of prior", "street robbery", "location choices")
    "S16" = @("Long", "2021", "Ambient population", "surveillance cameras", "guardianship role")
    "S17" = @("Long", "Liu", "2021", "Migrant", "Native", "Robbers", "Different Places")
    "S18" = @("Long", "Liu", "2022", "juvenile", "young adult", "adult offenders", "Chinese context")
    "S19" = @("Curtis-Ham", "2022", "Relationships", "Offenders", "Crime Locations", "Prior Activity")
    "S20" = @("Vandeviver", "Bernasco", "2020", "Location, Location, Location", "Neighborhood", "House Attributes")
    "S21" = @("Menting", "2020", "Activity Space", "Visiting Frequency", "Crime Location Choice", "Online Self-Report")
    "S22" = @("Sleeuwen", "2021", "Right place", "right time", "crime pattern theory", "time-specific")
    "S23" = @("Bernasco", "Nieuwbeerta", "2005", "residential burglars", "select target areas", "analysis of criminal location")
    "S24" = @("Bernasco", "2006", "Co-offending", "Choice of Target", "Burglary")
    "S25" = @("Townsley", "2015", "Burglar Target Selection", "Cross-national", "Netherlands", "NL")
    "S26" = @("Bernasco", "2003", "Effect Attractiveness", "Opportunity", "Residential Burglary")
    "S27" = @("Bernasco", "2015", "Learning where to offend", "Effects of past", "future burglary")
    "S28" = @("Frith", "2019", "Modelling taste heterogeneity", "offence location choices")
    "S29" = @("Hanayama", "2018", "usefulness of past crime data", "attractiveness index")
    "S30" = @("Bernasco", "2019", "Adolescent offenders", "Current Whereabouts", "future crime")
    "S31" = @("Bernasco", "Jacques", "2015", "Where Do Dealers", "Solicit Customers")
    "S32" = @("Bernasco", "Block", "2009", "Where offenders choose to attack", "discrete choice", "Chicago")
    "S33" = @("Chamberlain", "Boggess", "2016", "Relative Difference", "Burglary Location", "ecological characteristics")
    "S34" = @("Bernasco", "2010", "Sentimental Journey", "Crime", "Residential History")
    "S35" = @("Bernasco", "2010", "Modeling micro-level", "crime location choice", "discrete choice framework")
    "S36" = @("Bernasco", "Kooistra", "2010", "residential history", "commercial robbers", "Effects of Residential")
    "S37" = @("Frith", "2017", "Role of the Street Network", "Burglars", "Spatial Decision-Making")
    "S38" = @("Baudains", "2013", "Target Choice", "Extreme Events", "London Riots", "spatial choice")
    "S39" = @("Johnson", "Summers", "2015", "Testing Ecological Theories", "Offender Spatial Decision")
    "S40" = @("Vandeviver", "2015", "discrete spatial choice model", "burglary", "house-level")
    "S41" = @("Langton", "Steenbeek", "2017", "Residential burglary", "target selection", "property-level")
    "S42" = @("Marchment", "Gill", "2019", "spatial decision making", "terrorists", "discrete choice")
    "S43" = @("Chamberlain", "2022", "Traveling Alone", "Together", "Neighborhood Context")
    "S44" = @("Curtis-Ham", "2022", "Importance of Importance Sampling", "Methods of Sampling")
    "S45" = @("Yue", "2023", "effect of people", "street", "streetscape", "location choice")
    "S46" = @("Kuralarasan", "2024", "Graffiti Writers", "Locations", "Optimize Exposure")
    "S47" = @("Rowan", "2022", "Situating Crime Pattern Theory", "Co-Offending", "Convergence")
    "S48" = @("Smith", "Brown", "2007", "discrete choice analysis", "spatial attack sites")
    "S49" = @("Cai", "2024", "divergent decisionmaking", "context", "neighborhood context")
    "S50" = @("Curtis-Ham", "2025", "familiar locations", "similar activities", "reliable", "relevant knowledge")
}

# Define target authors for secondary matching
$targetAuthors = @(
    "Bernasco", "Block", "Clare", "Townsley", "Lammers", "Menting", 
    "Sleeuwen", "Xiao", "Kuralarasan", "Song", "Long", "Liu", 
    "Curtis-Ham", "Vandeviver", "Nieuwbeerta", "Frith", "Hanayama", 
    "Jacques", "Chamberlain", "Boggess", "Kooistra", "Baudains", 
    "Johnson", "Summers", "Langton", "Steenbeek", "Marchment", "Gill", 
    "Yue", "Rowan", "Appleby", "McGloin", "Smith", "Brown", "Cai"
)

# Define target keywords for tertiary matching
$targetKeywords = @(
    "location choice", "target selection", "discrete choice", 
    "spatial decision", "choice model", "criminal location", 
    "residential burglary", "street robbery", "offender", 
    "spatial attack", "crime pattern theory", "burglary target"
)

# Function to check if a file matches any of the patterns for a study
function Test-StudyMatch {
    param (
        [string]$filename,
        [array]$patterns
    )
    
    $matchCount = 0
    $requiredMatches = [math]::Min(2, $patterns.Count) # Require at least 2 pattern matches or all if less than 2 patterns
    
    foreach ($pattern in $patterns) {
        if ($filename -match [regex]::Escape($pattern)) {
            $matchCount++
        }
    }
    
    return ($matchCount -ge $requiredMatches)
}

# Function to identify the study ID for a given file
function Get-StudyID {
    param (
        [string]$filePath
    )
    
    $filename = [System.IO.Path]::GetFileNameWithoutExtension($filePath)
    
    # Try primary matching with study patterns
    foreach ($studyID in $studyPatterns.Keys) {
        if (Test-StudyMatch -filename $filename -patterns $studyPatterns[$studyID]) {
            return $studyID
        }
    }
    
    # Try secondary matching with authors + keywords
    foreach ($author in $targetAuthors) {
        if ($filename -match [regex]::Escape($author)) {
            foreach ($keyword in $targetKeywords) {
                if ($filename -match [regex]::Escape($keyword)) {
                    # If we have an author and keyword match, try to determine the study ID
                    foreach ($studyID in $studyPatterns.Keys) {
                        $authorMatch = $false
                        $keywordMatch = $false
                        
                        foreach ($pattern in $studyPatterns[$studyID]) {
                            if ($author -match [regex]::Escape($pattern)) {
                                $authorMatch = $true
                            }
                            if ($keyword -match [regex]::Escape($pattern)) {
                                $keywordMatch = $true
                            }
                        }
                        
                        if ($authorMatch -and $keywordMatch) {
                            return $studyID
                        }
                    }
                }
            }
        }
    }
    
    # No match found
    return $null
}

# Function to recursively search folders for target studies
function Find-TargetStudies {
    param (
        [string]$searchPath
    )
    
    Write-Host "Searching for target studies in: $searchPath"
    
    # Get all PDF files in the folder and subfolders
    $pdfFiles = Get-ChildItem -Path $searchPath -Filter "*.pdf" -Recurse -ErrorAction SilentlyContinue
    Write-Host "Found $($pdfFiles.Count) PDF files to examine"
    
    $foundStudies = @{}
    
    foreach ($file in $pdfFiles) {
        $studyID = Get-StudyID -filePath $file.FullName
        
        if ($studyID) {
            if (-not $foundStudies.ContainsKey($studyID)) {
                $foundStudies[$studyID] = @()
            }
            $foundStudies[$studyID] += $file.FullName
        }
    }
    
    return $foundStudies
}

# Search for target studies in all paths
$allFoundStudies = @{}

# Search main PDFs folder
$mainFolderStudies = Find-TargetStudies -searchPath $mainPDFPath
foreach ($studyID in $mainFolderStudies.Keys) {
    if (-not $allFoundStudies.ContainsKey($studyID)) {
        $allFoundStudies[$studyID] = @()
    }
    $allFoundStudies[$studyID] += $mainFolderStudies[$studyID]
}

# Search new PDF folder
$newFolderStudies = Find-TargetStudies -searchPath $newPDFPath
foreach ($studyID in $newFolderStudies.Keys) {
    if (-not $allFoundStudies.ContainsKey($studyID)) {
        $allFoundStudies[$studyID] = @()
    }
    $allFoundStudies[$studyID] += $newFolderStudies[$studyID]
}

# Copy found studies to target folder
Write-Host "`nCopying found studies to $targetOutputFolder..."
$copiedStudies = @()

foreach ($studyID in $allFoundStudies.Keys | Sort-Object) {
    $files = $allFoundStudies[$studyID]
    if ($files.Count -gt 0) {
        $file = $files[0] # Use the first file found for this study
        $filename = "$studyID - $([System.IO.Path]::GetFileName($file))"
        $destPath = Join-Path $targetOutputFolder $filename
        
        try {
            Copy-Item -Path $file -Destination $destPath -Force
            $copiedStudies += $studyID
            Write-Host "Copied $studyID to $destPath"
        }
        catch {
            Write-Host "Error copying $studyID: $($_.Exception.Message)" -ForegroundColor Red
        }
    }
}

# Generate report
$reportContent = "# IMPROVED TARGET STUDIES SEARCH RESULTS`r`n`r`n"
$reportContent += "Created on $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')`r`n`r`n"

$reportContent += "## FOUND STUDIES ($($copiedStudies.Count) of 50)`r`n`r`n"
foreach ($studyID in $copiedStudies | Sort-Object) {
    $reportContent += "- $studyID`r`n"
}

$reportContent += "`r`n## MISSING STUDIES ($((50 - $copiedStudies.Count)) of 50)`r`n`r`n"
$missingStudies = $studyPatterns.Keys | Where-Object { $copiedStudies -notcontains $_ } | Sort-Object
foreach ($studyID in $missingStudies) {
    $patterns = $studyPatterns[$studyID] -join ", "
    $reportContent += "- $studyID (Search patterns: $patterns)`r`n"
}

$reportPath = Join-Path $targetOutputFolder "improved_search_report.txt"
$reportContent | Out-File -FilePath $reportPath -Encoding utf8

Write-Host "`nImproved search completed!"
Write-Host "Found and copied $($copiedStudies.Count) of 50 target studies"
Write-Host "Missing $((50 - $copiedStudies.Count)) studies"
Write-Host "Report saved to: $reportPath"
