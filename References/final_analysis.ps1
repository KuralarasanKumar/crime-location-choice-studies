# Final Analysis Script - What PDFs do we have vs. what we need

# List of ALL 50 studies from the table with their expected filenames/authors
$targetStudies = @{
    "S01" = @{ "Authors" = "Bernasco et al."; "Year" = "2013"; "Title" = "Go where the money is" }
    "S02" = @{ "Authors" = "Bernasco et al."; "Year" = "2017"; "Title" = "Do Street Robbery Location Choices Vary" }
    "S03" = @{ "Authors" = "Clare et al."; "Year" = "2009"; "Title" = "Formal evaluation of the impact of barriers" }
    "S04" = @{ "Authors" = "Townsley et al."; "Year" = "2015"; "Title" = "Burglar Target Selection.*AU" }
    "S05" = @{ "Authors" = "Townsley et al."; "Year" = "2016"; "Title" = "Target Selection Models with Preference" }
    "S06" = @{ "Authors" = "Lammers et al."; "Year" = "2015"; "Title" = "Biting Once Twice" }
    "S07" = @{ "Authors" = "Lammers"; "Year" = "2017"; "Title" = "Co-offenders.*crime location choice" }
    "S08" = @{ "Authors" = "Menting et al."; "Year" = "2016"; "Title" = "Family Matters" }
    "S09" = @{ "Authors" = "van Sleeuwen et al."; "Year" = "2018"; "Title" = "A Time for a Crime" }
    "S10" = @{ "Authors" = "Xiao et al."; "Year" = "2021"; "Title" = "Burglars blocked by barriers" }
    "S11" = @{ "Authors" = "Kuralarasan.*Bernasco"; "Year" = "2022"; "Title" = "Location Choice of Snatching" }
    "S12" = @{ "Authors" = "Townsley et al."; "Year" = "2015"; "Title" = "Burglar Target Selection.*UK" }
    "S13" = @{ "Authors" = "Menting"; "Year" = "2018"; "Title" = "Awareness.*Opportunity" }
    "S14" = @{ "Authors" = "Song et al."; "Year" = "2019"; "Title" = "Crime Feeds on Legal Activities" }
    "S15" = @{ "Authors" = "Long et al."; "Year" = "2018"; "Title" = "Assessing the influence of prior" }
    "S16" = @{ "Authors" = "Long et al."; "Year" = "2021"; "Title" = "Ambient population and surveillance" }
    "S17" = @{ "Authors" = "Long.*Liu"; "Year" = "2021"; "Title" = "Do Migrant and Native Robbers" }
    "S18" = @{ "Authors" = "Long.*Liu"; "Year" = "2022"; "Title" = "Do juvenile.*young adult.*adult offenders" }
    "S19" = @{ "Authors" = "Curtis-Ham et al."; "Year" = "2022"; "Title" = "Relationships Between Offenders" }
    "S20" = @{ "Authors" = "Vandeviver.*Bernasco"; "Year" = "2020"; "Title" = "Location.*Location.*Location" }
    "S21" = @{ "Authors" = "Menting et al."; "Year" = "2020"; "Title" = "Activity Space and Visiting Frequency" }
    "S22" = @{ "Authors" = "van Sleeuwen et al."; "Year" = "2021"; "Title" = "Right place.*right time" }
    "S23" = @{ "Authors" = "Bernasco.*Nieuwbeerta"; "Year" = "2005"; "Title" = "How do residential burglars select" }
    "S24" = @{ "Authors" = "Bernasco"; "Year" = "2006"; "Title" = "Co-offending and the Choice of Target" }
    "S25" = @{ "Authors" = "Townsley et al."; "Year" = "2015"; "Title" = "Burglar Target Selection.*NL" }
    "S26" = @{ "Authors" = "Bernasco.*Luykx"; "Year" = "2003"; "Title" = "Effect.*Attractiveness.*Opportunity" }
    "S27" = @{ "Authors" = "Bernasco et al."; "Year" = "2015"; "Title" = "Learning where to offend" }
    "S28" = @{ "Authors" = "Frith"; "Year" = "2019"; "Title" = "Modelling taste heterogeneity" }
    "S29" = @{ "Authors" = "Hanayama et al."; "Year" = "2018"; "Title" = "usefulness of past crime data" }
    "S30" = @{ "Authors" = "Bernasco"; "Year" = "2019"; "Title" = "Adolescent offenders.*current whereabouts" }
    "S31" = @{ "Authors" = "Bernasco.*Jacques"; "Year" = "2015"; "Title" = "Where Do Dealers Solicit" }
    "S32" = @{ "Authors" = "Bernasco.*Block"; "Year" = "2009"; "Title" = "Where offenders choose to attack" }
    "S33" = @{ "Authors" = "Chamberlain.*Boggess"; "Year" = "2016"; "Title" = "Relative Difference and Burglary" }
    "S34" = @{ "Authors" = "Bernasco"; "Year" = "2010"; "Title" = "Sentimental Journey.*Crime" }
    "S35" = @{ "Authors" = "Bernasco"; "Year" = "2010"; "Title" = "Modeling micro-level crime location" }
    "S36" = @{ "Authors" = "Bernasco.*Kooistra"; "Year" = "2010"; "Title" = "Effects of.*residential history.*commercial" }
    "S37" = @{ "Authors" = "Frith et al."; "Year" = "2017"; "Title" = "Role of the Street Network" }
    "S38" = @{ "Authors" = "Baudains et al."; "Year" = "2013"; "Title" = "Target Choice During Extreme Events" }
    "S39" = @{ "Authors" = "Johnson.*Summers"; "Year" = "2015"; "Title" = "Testing Ecological Theories" }
    "S40" = @{ "Authors" = "Vandeviver et al."; "Year" = "2015"; "Title" = "discrete spatial choice.*burglary target.*house-level" }
    "S41" = @{ "Authors" = "Langton.*Steenbeek"; "Year" = "2017"; "Title" = "Residential burglary target selection.*property-level" }
    "S42" = @{ "Authors" = "Marchment.*Gill"; "Year" = "2019"; "Title" = "Modelling the spatial decision making of terrorists" }
    "S43" = @{ "Authors" = "Chamberlain et al."; "Year" = "2022"; "Title" = "Traveling Alone or Together" }
    "S44" = @{ "Authors" = "Curtis-Ham et al."; "Year" = "2022"; "Title" = "Importance of Importance Sampling" }
    "S45" = @{ "Authors" = "Yue et al."; "Year" = "2023"; "Title" = "people on the street.*streetscape" }
    "S46" = @{ "Authors" = "Kuralarasan et al."; "Year" = "2024"; "Title" = "Graffiti Writers Choose Locations" }
    "S47" = @{ "Authors" = "Rowan.*Appleby.*McGloin"; "Year" = "2022"; "Title" = "Situating Crime Pattern Theory" }
    "S48" = @{ "Authors" = "Smith.*Brown"; "Year" = "2007"; "Title" = "discrete choice analysis of spatial attack" }
    "S49" = @{ "Authors" = "Cai et al."; "Year" = "2024"; "Title" = "divergent decisionmaking" }
    "S50" = @{ "Authors" = "Curtis-Ham et al."; "Year" = "2025"; "Title" = "familiar locations and similar activities" }
    "S54" = @{ "Authors" = "Xue.*Brown"; "Year" = "2006"; "Title" = "spatial analysis with preference specification" }
}

# Get all current PDF files
$currentFiles = Get-ChildItem -Path ".\PDFs" -Filter "*.pdf" -Exclude "ToDelete"

Write-Host "=== COMPREHENSIVE ANALYSIS ===" -ForegroundColor Yellow
Write-Host "Checking which of the 50 target studies we have..." -ForegroundColor Cyan

$foundStudies = @()
$missingStudies = @()

foreach ($studyId in $targetStudies.Keys | Sort-Object) {
    $study = $targetStudies[$studyId]
    $found = $false
    $matchedFile = ""
    
    foreach ($file in $currentFiles) {
        $fileName = $file.Name
        
        # Check if file matches this study (authors, year, and some title keywords)
        if ($fileName -match $study.Authors -and 
            $fileName -match $study.Year -and 
            $fileName -match $study.Title) {
            $found = $true
            $matchedFile = $fileName
            break
        }
    }
    
    if ($found) {
        $foundStudies += @{ "ID" = $studyId; "File" = $matchedFile }
        Write-Host "✅ $studyId FOUND: $matchedFile" -ForegroundColor Green
    } else {
        $missingStudies += @{ "ID" = $studyId; "Authors" = $study.Authors; "Year" = $study.Year; "Title" = $study.Title }
        Write-Host "❌ $studyId MISSING: $($study.Authors) $($study.Year)" -ForegroundColor Red
    }
}

Write-Host "`n=== SUMMARY ===" -ForegroundColor Yellow
Write-Host "✅ FOUND: $($foundStudies.Count) studies" -ForegroundColor Green
Write-Host "❌ MISSING: $($missingStudies.Count) studies" -ForegroundColor Red
Write-Host "🎯 TOTAL TARGET: $($targetStudies.Count) studies" -ForegroundColor Cyan

Write-Host "`n=== MISSING STUDIES DETAILS ===" -ForegroundColor Red
foreach ($missing in $missingStudies) {
    Write-Host "❌ $($missing.ID): $($missing.Authors) ($($missing.Year))" -ForegroundColor Red
}

Write-Host "`n=== NEXT STEPS ===" -ForegroundColor Yellow
Write-Host "1. Download the $($missingStudies.Count) missing PDFs from academic databases" -ForegroundColor White
Write-Host "2. Contact authors if papers are not publicly available" -ForegroundColor White
Write-Host "3. Check institutional access through your university library" -ForegroundColor White
