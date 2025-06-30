# COMPREHENSIVE DETAILED SEARCH FOR ALL TARGET STUDIES
# Search for every single study from the table by multiple criteria

$sourceDir = "c:\Users\kukumar\OneDrive - UGent\Job\crimsyndata\-crime-location-choice-studies\snatching work\References\PDFs"

Write-Host "🔍 COMPREHENSIVE DETAILED SEARCH FOR MISSING TARGET STUDIES" -ForegroundColor Yellow
Write-Host "============================================================" -ForegroundColor Yellow

# Get all current files
$allFiles = Get-ChildItem -Path $sourceDir -Name "*.pdf" | Sort-Object
Write-Host "`n📄 SEARCHING THROUGH $($allFiles.Count) FILES..." -ForegroundColor Cyan

# ALL target studies from the table with multiple search terms
$targetStudies = @{
    "S43" = @("Chamberlain", "Traveling Alone or Together", "Neighborhood Context", "Individual and Group", "Juvenile and Adult", "Burglary Decisions")
    "S33" = @("Chamberlain", "Boggess", "Relative Difference", "Burglary Location", "Ecological Characteristics", "Burglar's Home")
    "S38" = @("Baudains", "Target Choice", "Extreme Events", "Discrete Spatial Choice", "2011 London Riots", "LSOA")
    "S32" = @("Bernasco", "Block", "Where offenders choose to attack", "discrete choice", "robberies", "Chicago")
    "S31" = @("Bernasco", "Jacques", "Where Do Dealers Solicit", "Customers", "Sell Them Drugs")
    "S36" = @("Bernasco", "Kooistra", "Effects of Residential history", "Commercial Robbers", "Crime Location")
    "S26" = @("Bernasco", "Luykx", "Effect Attractiveness", "Opportunity", "Accessibility", "Burglars", "Residential Burglary")
    "S23" = @("Bernasco", "Nieuwbeerta", "residential burglars select target areas", "criminal location choice")
    "S01" = @("Bernasco", "Go where the money is", "street robbers", "location choices")
    "S27" = @("Bernasco", "Learning where to offend", "past on future", "burglary locations", "LSOA")
    "S02" = @("Bernasco", "Street Robbery Location Choices", "Time of Day", "Day of Week", "Chicago")
    "S24" = @("Bernasco", "Co-offending", "Choice of Target Areas", "Burglary")
    "S34" = @("Bernasco", "Sentimental Journey", "Crime", "Residential History", "Crime Location Choice")
    "S35" = @("Bernasco", "Modeling micro-level", "crime location choice", "discrete choice framework")
    "S30" = @("Bernasco", "Adolescent offenders", "current whereabouts", "future crime")
    "S03" = @("Clare", "Formal evaluation", "barriers and connectors", "residential burglars", "macro-level", "offending location")
    "S19" = @("Curtis-Ham", "Relationships Between Offenders", "Crime Locations", "Prior Activity Locations", "Police Data")
    "S44" = @("Curtis-Ham", "Importance of Importance Sampling", "Methods of Sampling", "Discrete Choice Models")
    "S37" = @("Frith", "Role of the Street Network", "Burglars", "Spatial Decision-Making")
    "S28" = @("Frith", "Modelling taste heterogeneity", "offence location choices", "Census output area")
    "S29" = @("Hanayama", "usefulness of past crime data", "attractiveness index", "residential burglars")
    "S39" = @("Johnson", "Summers", "Testing Ecological Theories", "Offender Spatial Decision", "Discrete Choice Model")
    "S46" = @("Kuralarasa", "Graffiti Writers", "Choose Locations", "Optimize Exposure")
    "S11" = @("Kuralarasan", "Bernasco", "Location Choice", "Snatching Offenders", "Chennai City", "Wards")
    "S06" = @("Lammers", "Biting Once Twice", "Influence of Prior", "subsequent Crime Location Choice")
    "S07" = @("Lammers", "Co-offenders", "crime location choice", "shared awareness space")
    "S41" = @("Langton", "Steenbeek", "Residential burglary target selection", "property-level", "Google Street View")
    "S17" = @("Long", "Liu", "Migrant and Native Robbers", "Target Different Places")
    "S18" = @("Long", "Liu", "juvenile", "young adult", "adult offenders", "Chinese context")
    "S15" = @("Long", "Assessing the influence", "prior on subsequent", "street robbery", "ZG City", "China")
    "S16" = @("Long", "Ambient population", "surveillance cameras", "guardianship role", "street robbers")
    "S42" = @("Marchment", "Gill", "Modelling the spatial decision", "terrorists", "discrete choice approach")
    "S08" = @("Menting", "Family Matters", "Family Members", "Residential Areas", "Crime Location Choice")
    "S21" = @("Menting", "Influence of Activity Space", "Visiting Frequency", "Online Self-Report Survey")
    "S13" = @("Menting", "Awareness×Opportunity", "Testing Interactions", "Activity Nodes", "Criminal Opportunity")
    "S09" = @("van Sleeuwen", "Time for a Crime", "Temporal Aspects", "Repeat Offenders")
    "S22" = @("van Sleeuwen", "Right place", "right time", "crime pattern theory", "time-specific")
    "S14" = @("Song", "Crime Feeds on Legal Activities", "Daily Mobility Flows", "Thieves", "Target Location")
    "S04" = @("Townsley", "Burglar Target Selection", "Cross-national Comparison", "statistical local areas", "AU")
    "S12" = @("Townsley", "Burglar Target Selection", "Cross-national Comparison", "Super Output Areas", "UK")
    "S25" = @("Townsley", "Burglar Target Selection", "Cross-national Comparison", "NL")
    "S05" = @("Townsley", "Target Selection Models", "Preference Variation", "Offenders")
    "S20" = @("Vandeviver", "Bernasco", "Location Location Location", "Neighborhood and House Attributes", "Burglars")
    "S40" = @("Vandeviver", "discrete spatial choice model", "burglary target selection", "house-level")
    "S10" = @("Xiao", "Burglars blocked by barriers", "physical and social barriers", "residential burglars", "China")
    "S54" = @("Xue", "Brown", "spatial analysis", "preference specification", "latent decision makers", "criminal event prediction")
    "S45" = @("Yue", "effect of people on the street", "streetscape physical environment", "street theft crime", "street view images")
    "S47" = @("Rowan", "Appleby", "McGloin", "Crime Pattern Theory", "Co-Offending", "Area-Level Convergence")
    "S48" = @("Smith", "Brown", "discrete choice analysis", "spatial attack sites")
    "S49" = @("Cai", "divergent decisionmaking", "neighborhood context", "physical disorder", "spatial knowledge", "burglars")
    "S50" = @("Curtis-Ham", "familiar locations", "similar activities", "reliable and relevant knowledge", "offenders crime location")
}

$foundStudies = @{}
$detailedMatches = @()

Write-Host "`n🔍 SEARCHING FOR EACH TARGET STUDY..." -ForegroundColor Cyan

foreach ($studyId in $targetStudies.Keys) {
    $searchTerms = $targetStudies[$studyId]
    $found = $false
    
    foreach ($file in $allFiles) {
        $fileName = $file.ToLower()
        $matchCount = 0
        $matchedTerms = @()
        
        foreach ($term in $searchTerms) {
            if ($fileName -like "*$($term.ToLower())*") {
                $matchCount++
                $matchedTerms += $term
            }
        }
        
        # If we find 2+ matching terms, it's likely the right study
        if ($matchCount -ge 2) {
            if (-not $foundStudies.ContainsKey($studyId)) {
                $foundStudies[$studyId] = @()
            }
            $foundStudies[$studyId] += $file
            $detailedMatches += [PSCustomObject]@{
                StudyID = $studyId
                File = $file
                MatchCount = $matchCount
                MatchedTerms = ($matchedTerms -join ", ")
            }
            $found = $true
        }
    }
    
    if (-not $found) {
        Write-Host "❌ NOT FOUND: $studyId" -ForegroundColor Red
    }
}

Write-Host "`n✅ DETAILED MATCHES FOUND:" -ForegroundColor Green
Write-Host "=========================" -ForegroundColor Green

$detailedMatches | Sort-Object StudyID | ForEach-Object {
    Write-Host "📄 $($_.StudyID): $($_.File)" -ForegroundColor White
    Write-Host "   Matched terms: $($_.MatchedTerms)" -ForegroundColor Gray
    Write-Host ""
}

Write-Host "`n📊 SUMMARY:" -ForegroundColor Cyan
Write-Host "Found studies: $($foundStudies.Keys.Count)" -ForegroundColor Green
Write-Host "Missing studies: $(50 - $foundStudies.Keys.Count)" -ForegroundColor Red

Write-Host "`n❌ MISSING STUDIES:" -ForegroundColor Red
$allStudyIds = @("S01", "S02", "S03", "S04", "S05", "S06", "S07", "S08", "S09", "S10", 
                 "S11", "S12", "S13", "S14", "S15", "S16", "S17", "S18", "S19", "S20",
                 "S21", "S22", "S23", "S24", "S25", "S26", "S27", "S28", "S29", "S30",
                 "S31", "S32", "S33", "S34", "S35", "S36", "S37", "S38", "S39", "S40",
                 "S41", "S42", "S43", "S44", "S45", "S46", "S47", "S48", "S49", "S50")

foreach ($id in $allStudyIds) {
    if (-not $foundStudies.ContainsKey($id)) {
        Write-Host "❌ $id - NOT FOUND" -ForegroundColor Red
    }
}
