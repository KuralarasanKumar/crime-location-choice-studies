# Comprehensive Folder Scan for Target Studies
# This script will scan all PDFs in the workspace and match them to the target studies

# Define the paths to scan
$mainPDFPath = "c:\Users\kukumar\OneDrive - UGent\Job\crimsyndata\-crime-location-choice-studies\snatching work\References\PDFs"
$newPDFPath = "c:\Users\kukumar\OneDrive - UGent\Job\crimsyndata\-crime-location-choice-studies\snatching work\References\new pdf"
$myLibraryPath = "c:\Users\kukumar\OneDrive - UGent\Job\crimsyndata\-crime-location-choice-studies\snatching work\References\new pdf\My Library\files"

# Create output folder if it doesn't exist
$outputFolder = "c:\Users\kukumar\OneDrive - UGent\Job\crimsyndata\-crime-location-choice-studies\snatching work\References\Analysis_Results"
if (-not (Test-Path $outputFolder)) {
    New-Item -ItemType Directory -Path $outputFolder -Force | Out-Null
}

# Define target authors and keywords from the studies table
$targetAuthors = @(
    "Chamberlain", "Bernasco", "Block", "Jacques", "Kooistra", "Luykx", 
    "Nieuwbeerta", "Curtis-Ham", "Clare", "Frith", "Hanayama", 
    "Johnson", "Summers", "Kuralarasan", "Lammers", "Langton", 
    "Steenbeek", "Long", "Liu", "Marchment", "Gill", "Menting", 
    "Sleeuwen", "Song", "Townsley", "Vandeviver", "Xiao", 
    "Xue", "Brown", "Yue", "Rowan", "Appleby", "McGloin", 
    "Smith", "Cai"
)

# Keywords from study titles to help identify target studies
$targetKeywords = @(
    "location choice", "spatial decision", "target selection", 
    "offender", "burglary", "robbery", "crime location", 
    "discrete choice", "offend", "criminal", "residential",
    "crime pattern", "terrorist", "target area", "attack site"
)

# Define output files
$foundStudiesFile = Join-Path $outputFolder "comprehensive_found_studies.txt"
$missingStudiesFile = Join-Path $outputFolder "comprehensive_missing_studies.txt"
$nonTargetFile = Join-Path $outputFolder "comprehensive_non_target_files.txt"

# Create a hashtable to store search patterns for each study
$studyPatterns = @{
    "S01" = @("Bernasco", "2013", "Go where the money is")
    "S02" = @("Bernasco", "2017", "Street Robbery Location")
    "S03" = @("Clare", "2009", "barriers and connectors")
    "S04" = @("Townsley", "2015", "Burglar Target Selection", "Cross-national", "AU")
    "S05" = @("Townsley", "2016", "Target Selection Models")
    "S06" = @("Lammers", "2015", "Biting Once Twice")
    "S07" = @("Lammers", "2017", "Co-offenders")
    "S08" = @("Menting", "2016", "Family Matters")
    "S09" = @("Sleeuwen", "2018", "A Time for a Crime")
    "S10" = @("Xiao", "2021", "Burglars blocked by barriers")
    "S11" = @("Kuralarasan", "2022", "Location Choice of Snatching")
    "S12" = @("Townsley", "2015", "Burglar Target Selection", "Cross-national", "UK")
    "S13" = @("Menting", "2018", "Awareness", "Opportunity")
    "S14" = @("Song", "2019", "Crime Feeds on Legal Activities")
    "S15" = @("Long", "2018", "Assessing the influence of prior")
    "S16" = @("Long", "2021", "Ambient population and surveillance")
    "S17" = @("Long", "2021", "Migrant and Native Robbers")
    "S18" = @("Long", "2022", "juvenile, young adult")
    "S19" = @("Curtis-Ham", "2022", "Relationships Between Offenders")
    "S20" = @("Vandeviver", "2020", "Location Location Location")
    "S21" = @("Menting", "2020", "Activity Space and Visiting Frequency")
    "S22" = @("Sleeuwen", "2021", "Right place, right time")
    "S23" = @("Bernasco", "2005", "How do residential burglars select target areas")
    "S24" = @("Bernasco", "2006", "Co-offending and the Choice of Target Areas")
    "S25" = @("Townsley", "2015", "Burglar Target Selection", "Cross-national", "NL")
    "S26" = @("Bernasco", "2003", "Effect Attractiveness Opportunity")
    "S27" = @("Bernasco", "2015", "Learning where to offend")
    "S28" = @("Frith", "2019", "Modelling taste heterogeneity")
    "S29" = @("Hanayama", "2018", "usefulness of past crime data")
    "S30" = @("Bernasco", "2019", "Adolescent offenders")
    "S31" = @("Bernasco", "2015", "Where Do Dealers Solicit")
    "S32" = @("Bernasco", "2009", "Where offenders choose to attack")
    "S33" = @("Chamberlain", "2016", "Relative Difference and Burglary Location")
    "S34" = @("Bernasco", "2010", "Sentimental Journey To Crime")
    "S35" = @("Bernasco", "2010", "Modeling micro-level crime location choice")
    "S36" = @("Bernasco", "2010", "Effects of Residential history")
    "S37" = @("Frith", "2017", "Role of the Street Network")
    "S38" = @("Baudains", "2013", "Target Choice During Extreme Events")
    "S39" = @("Johnson", "2015", "Testing Ecological Theories")
    "S40" = @("Vandeviver", "2015", "discrete spatial choice model of burglary")
    "S41" = @("Langton", "2017", "Residential burglary target selection")
    "S42" = @("Marchment", "2019", "spatial decision making of terrorists")
    "S43" = @("Chamberlain", "2022", "Traveling Alone or Together")
    "S44" = @("Curtis-Ham", "2022", "Importance of Importance Sampling")
    "S45" = @("Yue", "2023", "effect of people on the street")
    "S46" = @("Kuralarasa", "2024", "Graffiti Writers Choose Locations")
    "S47" = @("Rowan", "2022", "Situating Crime Pattern Theory")
    "S48" = @("Smith", "2007", "discrete choice analysis of spatial attack sites")
    "S49" = @("Cai", "2024", "divergent decisionmaking in context")
    "S50" = @("Curtis-Ham", "2025", "familiar locations and similar activities")
}

# Function to check if a file matches a target study
function Match-TargetStudy {
    param (
        [string]$filePath,
        [hashtable]$patterns
    )
    
    $fileName = [System.IO.Path]::GetFileName($filePath)
    
    foreach ($studyId in $patterns.Keys) {
        $matchCount = 0
        $requiredMatches = [Math]::Min(2, $patterns[$studyId].Count)
        
        foreach ($pattern in $patterns[$studyId]) {
            if ($fileName -match [regex]::Escape($pattern)) {
                $matchCount++
            }
        }
        
        if ($matchCount -ge $requiredMatches) {
            return $studyId
        }
    }
    
    return $null
}

# Function to scan folders and match PDFs to target studies
function Scan-ForTargetStudies {
    param (
        [string]$folderPath,
        [string]$folderDescription
    )
    
    Write-Host "Scanning $folderDescription at $folderPath..."
    
    $foundStudies = @{}
    $nonTargetFiles = @()
    
    # Check if the folder exists
    if (-not (Test-Path $folderPath)) {
        Write-Host "Folder not found: $folderPath"
        return $foundStudies, $nonTargetFiles
    }
    
    # Get all PDF files in the folder and subfolders
    $pdfFiles = Get-ChildItem -Path $folderPath -Filter "*.pdf" -Recurse -ErrorAction SilentlyContinue
    
    Write-Host "Found $($pdfFiles.Count) PDF files in $folderDescription"
    
    foreach ($file in $pdfFiles) {
        $studyId = Match-TargetStudy -filePath $file.FullName -patterns $studyPatterns
        
        if ($studyId) {
            if (-not $foundStudies.ContainsKey($studyId)) {
                $foundStudies[$studyId] = @()
            }
            $foundStudies[$studyId] += $file.FullName
        } else {
            # Check if the file might still be relevant based on author or keywords
            $isRelevant = $false
            foreach ($author in $targetAuthors) {
                if ($file.Name -match $author) {
                    $isRelevant = $true
                    break
                }
            }
            
            if (-not $isRelevant) {
                foreach ($keyword in $targetKeywords) {
                    if ($file.Name -match [regex]::Escape($keyword)) {
                        $isRelevant = $true
                        break
                    }
                }
            }
            
            if (-not $isRelevant) {
                $nonTargetFiles += $file.FullName
            }
        }
    }
    
    return $foundStudies, $nonTargetFiles
}

# Scan each folder and collect results
Write-Host "Starting comprehensive scan of all PDF folders..."

$allFoundStudies = @{}
$allNonTargetFiles = @()

# Scan main PDFs folder
$mainFoundStudies, $mainNonTargetFiles = Scan-ForTargetStudies -folderPath $mainPDFPath -folderDescription "main PDFs folder"
foreach ($key in $mainFoundStudies.Keys) {
    if (-not $allFoundStudies.ContainsKey($key)) {
        $allFoundStudies[$key] = @()
    }
    $allFoundStudies[$key] += $mainFoundStudies[$key]
}
$allNonTargetFiles += $mainNonTargetFiles

# Scan new pdf folder
$newFoundStudies, $newNonTargetFiles = Scan-ForTargetStudies -folderPath $newPDFPath -folderDescription "new pdf folder"
foreach ($key in $newFoundStudies.Keys) {
    if (-not $allFoundStudies.ContainsKey($key)) {
        $allFoundStudies[$key] = @()
    }
    $allFoundStudies[$key] += $newFoundStudies[$key]
}
$allNonTargetFiles += $newNonTargetFiles

# Scan My Library folder
$libFoundStudies, $libNonTargetFiles = Scan-ForTargetStudies -folderPath $myLibraryPath -folderDescription "My Library folder"
foreach ($key in $libFoundStudies.Keys) {
    if (-not $allFoundStudies.ContainsKey($key)) {
        $allFoundStudies[$key] = @()
    }
    $allFoundStudies[$key] += $libFoundStudies[$key]
}
$allNonTargetFiles += $libNonTargetFiles

# Generate report of found studies
$foundReport = "# TARGET STUDIES FOUND IN YOUR FOLDERS`r`n`r`n"
$foundReport += "Found $($allFoundStudies.Keys.Count) out of 50 target studies`r`n`r`n"

foreach ($studyId in ($allFoundStudies.Keys | Sort-Object)) {
    $foundReport += "## $studyId`r`n"
    $patterns = $studyPatterns[$studyId]
    $foundReport += "Search patterns: $($patterns -join ", ")`r`n"
    $foundReport += "Found files:`r`n"
    
    foreach ($file in $allFoundStudies[$studyId]) {
        $relativePath = $file.Replace("c:\Users\kukumar\OneDrive - UGent\Job\crimsyndata\-crime-location-choice-studies\snatching work\", "")
        $foundReport += "- $relativePath`r`n"
    }
    $foundReport += "`r`n"
}

# Generate report of missing studies
$missingStudies = $studyPatterns.Keys | Where-Object { -not $allFoundStudies.ContainsKey($_) } | Sort-Object
$missingReport = "# MISSING TARGET STUDIES`r`n`r`n"
$missingReport += "Missing $($missingStudies.Count) out of 50 target studies`r`n`r`n"

foreach ($studyId in $missingStudies) {
    $missingReport += "## $studyId`r`n"
    $patterns = $studyPatterns[$studyId]
    $missingReport += "Search patterns: $($patterns -join ", ")`r`n`r`n"
}

# Generate report of non-target files
$nonTargetReport = "# NON-TARGET PDF FILES`r`n`r`n"
$nonTargetReport += "Found $($allNonTargetFiles.Count) files that do not match any target study patterns`r`n`r`n"

$allNonTargetFiles = $allNonTargetFiles | Sort-Object
foreach ($file in $allNonTargetFiles) {
    $relativePath = $file.Replace("c:\Users\kukumar\OneDrive - UGent\Job\crimsyndata\-crime-location-choice-studies\snatching work\", "")
    $nonTargetReport += "- $relativePath`r`n"
}

# Save reports to files
$foundReport | Out-File -FilePath $foundStudiesFile -Encoding utf8
$missingReport | Out-File -FilePath $missingStudiesFile -Encoding utf8
$nonTargetReport | Out-File -FilePath $nonTargetFile -Encoding utf8

# Output summary
Write-Host "`r`nScan completed!"
Write-Host "Found $($allFoundStudies.Keys.Count) out of 50 target studies"
Write-Host "Missing $($missingStudies.Count) target studies"
Write-Host "Identified $($allNonTargetFiles.Count) non-target PDF files"
Write-Host "`r`nDetailed reports saved to:"
Write-Host "- $foundStudiesFile"
Write-Host "- $missingStudiesFile"
Write-Host "- $nonTargetFile"
