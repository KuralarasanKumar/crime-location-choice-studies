# THOROUGH VERIFICATION OF ALL 115 FILES
# Cross-check every file against the target studies table

$sourceDir = "c:\Users\kukumar\OneDrive - UGent\Job\crimsyndata\-crime-location-choice-studies\snatching work\References\PDFs"

Write-Host "COMPREHENSIVE VERIFICATION OF ALL 115 FILES" -ForegroundColor Yellow
Write-Host "===========================================" -ForegroundColor Yellow

# Get all files
$allFiles = Get-ChildItem -Path $sourceDir -Name "*.pdf" | Sort-Object
Write-Host "Total files to check: $($allFiles.Count)" -ForegroundColor Cyan

# Define ALL target studies from your table with multiple search patterns
$targetStudies = @{
    "S01" = @("Bernasco", "Go where the money", "street robbers", "location choices", "2013")
    "S02" = @("Bernasco", "Street Robbery Location Choices", "Time of Day", "Day of Week", "2017")
    "S03" = @("Clare", "barriers and connectors", "residential burglars", "macro-level", "2009")
    "S04" = @("Townsley", "Burglar Target Selection", "Cross-national", "statistical local areas", "AU", "2015")
    "S05" = @("Townsley", "Target Selection Models", "Preference Variation", "2016")
    "S06" = @("Lammers", "Biting Once Twice", "prior", "subsequent", "2015")
    "S07" = @("Lammers", "Co-offenders", "crime location choice", "shared awareness", "2017")
    "S08" = @("Menting", "Family Matters", "Family Members", "Residential Areas", "2016")
    "S09" = @("van Sleeuwen", "Time for a Crime", "Temporal Aspects", "Repeat Offenders", "2018")
    "S10" = @("Xiao", "Burglars blocked", "barriers", "physical and social", "China", "2021")
    "S11" = @("Kuralarasan", "Bernasco", "Snatching Offenders", "Chennai", "2022")
    "S12" = @("Townsley", "Burglar Target Selection", "Super Output Areas", "UK", "2015")
    "S13" = @("Menting", "Awareness", "Opportunity", "Activity Nodes", "2018")
    "S14" = @("Song", "Crime Feeds", "Legal Activities", "Mobility Flows", "2019")
    "S15" = @("Long", "prior on subsequent", "street robbery", "ZG City", "2018")
    "S16" = @("Long", "Ambient population", "surveillance cameras", "guardianship", "2021")
    "S17" = @("Long", "Liu", "Migrant and Native", "Robbers", "2021")
    "S18" = @("Long", "Liu", "juvenile", "young adult", "Chinese context", "2022")
    "S19" = @("Curtis-Ham", "Relationships", "Crime Locations", "Prior Activity", "2022")
    "S20" = @("Vandeviver", "Bernasco", "Location Location Location", "2020")
    "S21" = @("Menting", "Activity Space", "Visiting Frequency", "Self-Report", "2020")
    "S22" = @("van Sleeuwen", "Right place", "right time", "crime pattern theory", "2021")
    "S23" = @("Bernasco", "Nieuwbeerta", "residential burglars", "target areas", "2005")
    "S24" = @("Bernasco", "Co-offending", "Target Areas", "Burglary", "2006")
    "S25" = @("Townsley", "Burglar Target Selection", "NL", "2015")
    "S26" = @("Bernasco", "Luykx", "Attractiveness", "Opportunity", "Accessibility", "2003")
    "S27" = @("Bernasco", "Learning where to offend", "past", "future", "2015")
    "S28" = @("Frith", "taste heterogeneity", "offence location", "2019")
    "S29" = @("Hanayama", "past crime data", "attractiveness index", "2018")
    "S30" = @("Bernasco", "Adolescent offenders", "whereabouts", "2019")
    "S31" = @("Bernasco", "Jacques", "Dealers Solicit", "Customers", "Drugs", "2015")
    "S32" = @("Bernasco", "Block", "offenders choose to attack", "Chicago", "2009")
    "S33" = @("Chamberlain", "Boggess", "Relative Difference", "burglary location", "2016")
    "S34" = @("Bernasco", "Sentimental Journey", "Crime", "2010")
    "S35" = @("Bernasco", "Modeling micro-level", "crime location choice", "2010")
    "S36" = @("Bernasco", "Kooistra", "Commercial Robbers", "2010")
    "S37" = @("Frith", "Street Network", "Burglars", "Spatial Decision", "2017")
    "S38" = @("Baudains", "Target Choice", "Extreme Events", "London Riots", "2013")
    "S39" = @("Johnson", "Summers", "Ecological Theories", "Spatial Decision", "2015")
    "S40" = @("Vandeviver", "discrete spatial choice", "house-level", "2015")
    "S41" = @("Langton", "Steenbeek", "burglary target selection", "property-level", "2017")
    "S42" = @("Marchment", "Gill", "spatial decision making", "terrorists", "2019")
    "S43" = @("Chamberlain", "Traveling Alone", "Together", "Neighborhood Context", "2022")
    "S44" = @("Curtis-Ham", "Importance Sampling", "2022")
    "S45" = @("Yue", "people on street", "streetscape", "street theft", "2023")
    "S46" = @("Kuralarasa", "Graffiti Writers", "Optimize Exposure", "2024")
    "S47" = @("Rowan", "Appleby", "McGloin", "Crime Pattern Theory", "Co-Offending", "2022")
    "S48" = @("Smith", "Brown", "discrete choice", "spatial attack sites", "2007")
    "S49" = @("Cai", "divergent", "neighborhood context", "spatial knowledge", "2024")
    "S50" = @("Curtis-Ham", "familiar locations", "similar activities", "2025")
    "S54" = @("Xue", "Brown", "spatial analysis", "preference specification", "2006")
}

$foundStudies = @{}
$verifiedTargets = @()
$needVerification = @()
$obviousNonTargets = @()

Write-Host "`nCHECKING EACH FILE AGAINST TARGET STUDIES..." -ForegroundColor Cyan

foreach ($file in $allFiles) {
    $fileName = $file.ToLower()
    $isTarget = $false
    $matchedStudy = ""
    $confidence = "Low"
    
    # Check against each target study
    foreach ($studyId in $targetStudies.Keys) {
        $searchTerms = $targetStudies[$studyId]
        $matchCount = 0
        
        foreach ($term in $searchTerms) {
            if ($fileName -like "*$($term.ToLower())*") {
                $matchCount++
            }
        }
        
        # High confidence if 3+ matches, medium if 2, low if 1
        if ($matchCount -ge 3) {
            $isTarget = $true
            $matchedStudy = $studyId
            $confidence = "High"
            break
        } elseif ($matchCount -eq 2) {
            $isTarget = $true
            $matchedStudy = $studyId
            $confidence = "Medium"
            break
        } elseif ($matchCount -eq 1) {
            $isTarget = $true
            $matchedStudy = $studyId
            $confidence = "Low"
        }
    }
    
    if ($isTarget) {
        $verifiedTargets += [PSCustomObject]@{
            StudyID = $matchedStudy
            File = $file
            Confidence = $confidence
        }
        if ($confidence -eq "Low") {
            $needVerification += $file
        }
    } else {
        # Check if it's an obvious non-target
        $nonTargetTerms = @("corruption", "corrupt", "graffiti", "privacy", "geomasking", "networks", 
                           "taxonomy", "teaching", "programming", "whistleblowing", "genealogy", 
                           "masking", "anonymity", "differential privacy", "open data", "freedom of information",
                           "organizational", "injustice", "tutoring", "statistics", "bloom", "revision")
        
        $isNonTarget = $false
        foreach ($term in $nonTargetTerms) {
            if ($fileName -like "*$term*") {
                $isNonTarget = $true
                break
            }
        }
        
        if ($isNonTarget) {
            $obviousNonTargets += $file
        } else {
            $needVerification += $file
        }
    }
}

Write-Host "`n✅ VERIFIED TARGET STUDIES (High/Medium Confidence):" -ForegroundColor Green
$verifiedTargets | Where-Object { $_.Confidence -ne "Low" } | Sort-Object StudyID | ForEach-Object {
    Write-Host "📄 $($_.StudyID) ($($_.Confidence)): $($_.File)" -ForegroundColor White
}

Write-Host "`n🔍 NEED MANUAL VERIFICATION:" -ForegroundColor Yellow
$needVerification | ForEach-Object {
    Write-Host "📄 $_" -ForegroundColor Yellow
}

Write-Host "`n❌ OBVIOUS NON-TARGETS TO MOVE:" -ForegroundColor Red
$obviousNonTargets | ForEach-Object {
    Write-Host "📄 $_" -ForegroundColor Red
}

Write-Host "`n📊 COMPREHENSIVE SUMMARY:" -ForegroundColor Cyan
Write-Host "High/Medium confidence targets: $(($verifiedTargets | Where-Object { $_.Confidence -ne 'Low' }).Count)" -ForegroundColor Green
Write-Host "Need verification: $($needVerification.Count)" -ForegroundColor Yellow
Write-Host "Obvious non-targets: $($obviousNonTargets.Count)" -ForegroundColor Red
Write-Host "Total files checked: $($allFiles.Count)" -ForegroundColor White
