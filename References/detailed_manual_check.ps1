# COMPREHENSIVE MANUAL ANALYSIS - Target Studies Detection

Write-Host "=== COMPREHENSIVE TARGET STUDIES ANALYSIS ===" -ForegroundColor Yellow
Write-Host "Manually checking each file against the 50 target studies..." -ForegroundColor Cyan
Write-Host ""

# Get all PDF files excluding ToDelete
$allFiles = Get-ChildItem -Path ".\PDFs" -Filter "*.pdf" | Where-Object { $_.Name -ne "ToDelete" }

Write-Host "Total files to analyze: $($allFiles.Count)" -ForegroundColor Gray
Write-Host ""

# Manual mapping of target studies found
$targetStudiesFound = @()

foreach ($file in $allFiles) {
    $name = $file.Name
    $found = $false
    $studyInfo = ""
    
    # S01 - Bernasco et al. 2013 - Go where the money is
    if ($name -like "*Bernasco*2013*money*") {
        $targetStudiesFound += "S01 - Bernasco et al. 2013 - Go where the money is"
        $studyInfo = "S01"
        $found = $true
    }
    
    # S02 - Bernasco et al. 2017 - Do Street Robbery Location Choices Vary
    if ($name -like "*Bernasco*2017*") {
        $targetStudiesFound += "S02 - Bernasco et al. 2017 - Street Robbery Location Choices"
        $studyInfo = "S02"
        $found = $true
    }
    
    # S11 - Kuralarasan & Bernasco 2022 - Snatching Chennai
    if ($name -like "*Kuralarasan*Bernasco*2022*Snatching*Chennai*") {
        $targetStudiesFound += "S11 - Kuralarasan & Bernasco 2022 - Snatching Chennai"
        $studyInfo = "S11"
        $found = $true
    }
    
    # S13 - Menting 2018 - Awareness Opportunity
    if ($name -like "*Menting*2018*AWARENESS*OPPORTUNITY*") {
        $targetStudiesFound += "S13 - Menting 2018 - Awareness x Opportunity"
        $studyInfo = "S13"
        $found = $true
    }
    
    # S17 - Long & Liu 2021 - Migrant Native Robbers
    if ($name -like "*Long*Liu*2021*Migrant*Native*") {
        $targetStudiesFound += "S17 - Long & Liu 2021 - Migrant Native Robbers"
        $studyInfo = "S17"
        $found = $true
    }
    
    # S19 - Curtis-Ham 2022 - Relationships
    if ($name -like "*Curtis-Ham*Relationships*Offenders*Crime*Locations*") {
        $targetStudiesFound += "S19 - Curtis-Ham et al. 2022a - Relationships Between Offenders"
        $studyInfo = "S19"
        $found = $true
    }
    
    # S20 - Vandeviver & Bernasco 2020 - Location Location Location
    if ($name -like "*Vandeviver*Bernasco*2020*Location*") {
        $targetStudiesFound += "S20 - Vandeviver & Bernasco 2020 - Location Location Location"
        $studyInfo = "S20"
        $found = $true
    }
    
    # S22 - van Sleeuwen et al. 2021 - When Do Offenders Commit Crime
    if ($name -like "*Sleeuwen*2021*When*Do*Offenders*Commit*Crime*") {
        $targetStudiesFound += "S22 - van Sleeuwen et al. 2021 - When Do Offenders Commit Crime"
        $studyInfo = "S22"
        $found = $true
    }
    
    # S28 - Frith 2019 - taste heterogeneity
    if ($name -like "*Frith*2019*taste*heterogeneity*") {
        $targetStudiesFound += "S28 - Frith 2019 - Modelling taste heterogeneity"
        $studyInfo = "S28"
        $found = $true
    }
    
    # S30 - Bernasco 2019 - Adolescent
    if ($name -like "*Bernasco*2019*Adolescent*") {
        $targetStudiesFound += "S30 - Bernasco 2019 - Adolescent Offenders Current Whereabouts"
        $studyInfo = "S30"
        $found = $true
    }
    
    # S32 - Bernasco & Block 2009 - Where offenders choose to attack
    if ($name -like "*Bernasco*Block*2009*offenders*choose*attack*") {
        $targetStudiesFound += "S32 - Bernasco & Block 2009 - Where offenders choose to attack"
        $studyInfo = "S32"
        $found = $true
    }
    
    # S34 - Bernasco 2010 - Sentimental Journey
    if ($name -like "*Bernasco*2010*Sentimental*Journey*") {
        $targetStudiesFound += "S34 - Bernasco 2010a - A Sentimental Journey To Crime"
        $studyInfo = "S34"
        $found = $true
    }
    
    # S35 - Bernasco 2010 - Modeling micro-level
    if ($name -like "*Bernasco*2010*Modeling*Micro-Level*") {
        $targetStudiesFound += "S35 - Bernasco 2010b - Modeling Micro-Level Crime Location Choice"
        $studyInfo = "S35"
        $found = $true
    }
    
    # S36 - Bernasco & Kooistra 2010 - residential history commercial
    if ($name -like "*Bernasco*Kooistra*2010*residential*history*commercial*") {
        $targetStudiesFound += "S36 - Bernasco & Kooistra 2010 - Effects of residential history"
        $studyInfo = "S36"
        $found = $true
    }
    
    # S41 - Langton & Steenbeek 2017 - Residential burglary target selection
    if ($name -like "*Langton*Steenbeek*2017*Residential*burglary*target*selection*") {
        $targetStudiesFound += "S41 - Langton & Steenbeek 2017 - Residential burglary target selection"
        $studyInfo = "S41"
        $found = $true
    }
    
    # S42 - Marchment & Gill 2019 - spatial decision making terrorists
    if ($name -like "*Marchment*Gill*2019*spatial*decision*making*terrorist*") {
        $targetStudiesFound += "S42 - Marchment & Gill 2019 - Modelling spatial decision making terrorists"
        $studyInfo = "S42"
        $found = $true
    }
    
    # S44 - Curtis-Ham 2022 - Importance Sampling
    if ($name -like "*Curtis-Ham*2022*Importance*Sampling*") {
        $targetStudiesFound += "S44 - Curtis-Ham et al. 2022b - Importance of Importance Sampling"
        $studyInfo = "S44"
        $found = $true
    }
    
    # S47 - Rowan et al. 2022 - Crime Pattern Theory Co-Offending
    if ($name -like "*Rowan*2022*Crime*Pattern*Theory*Co-Offending*") {
        $targetStudiesFound += "S47 - Rowan et al. 2022 - Situating Crime Pattern Theory Co-Offending"
        $studyInfo = "S47"
        $found = $true
    }
    
    # S48 - Smith & Brown 2007 - discrete choice spatial attack
    if ($name -like "*Smith*Brown*2007*discrete*choice*spatial*attack*") {
        $targetStudiesFound += "S48 - Smith & Brown 2007 - Discrete choice analysis spatial attack sites"
        $studyInfo = "S48"
        $found = $true
    }
    
    # S50 - Curtis-Ham 2025 - familiar locations
    if ($name -like "*Curtis-Ham*2025*Familiar*Locations*Similar*Activities*") {
        $targetStudiesFound += "S50 - Curtis-Ham et al. 2025 - Familiar Locations Similar Activities"
        $studyInfo = "S50"
        $found = $true
    }
    
    # S54 - Xue & Brown 2006 - spatial analysis preference specification
    if ($name -like "*Xue*Brown*2006*spatial*analysis*preference*specification*") {
        $targetStudiesFound += "S54 - Xue & Brown 2006 - Spatial analysis preference specification"
        $studyInfo = "S54"
        $found = $true
    }
    
    # S04/12/25 - Townsley et al. 2015 - Burglar Target Selection Cross-national
    if ($name -like "*Townsley*2015*Burglar*Target*Selection*Cross-national*") {
        $targetStudiesFound += "S04/12/25 - Townsley et al. 2015 - Burglar Target Selection Cross-national"
        $studyInfo = "S04/12/25"
        $found = $true
    }
    
    # S27 - Bernasco et al. 2015 - Learning where to offend
    if ($name -like "*Bernasco*2015*Learning*where*to*offend*") {
        $targetStudiesFound += "S27 - Bernasco et al. 2015 - Learning where to offend"
        $studyInfo = "S27"
        $found = $true
    }
    
    # Display results
    if ($found) {
        Write-Host "✅ FOUND: $studyInfo - $name" -ForegroundColor Green
    } else {
        # Check if it might be a target study we missed
        if ($name -like "*Bernasco*" -or $name -like "*Curtis-Ham*" -or $name -like "*Long*" -or $name -like "*Menting*" -or 
            $name -like "*Townsley*" -or $name -like "*Frith*" -or $name -like "*Lammers*" -or $name -like "*Vandeviver*" -or
            $name -like "*Chamberlain*" -or $name -like "*Clare*" -or $name -like "*Song*" -or $name -like "*Xiao*" -or
            $name -like "*Johnson*" -or $name -like "*Hanayama*" -or $name -like "*Yue*" -or $name -like "*Cai*") {
            Write-Host "🔍 POTENTIAL TARGET: $name" -ForegroundColor Yellow
        } else {
            Write-Host "❌ IRRELEVANT: $name" -ForegroundColor Red
        }
    }
}

Write-Host ""
Write-Host "=== SUMMARY ===" -ForegroundColor Yellow
Write-Host "✅ CONFIRMED TARGET STUDIES FOUND: $($targetStudiesFound.Count)" -ForegroundColor Green
Write-Host "🎯 TOTAL TARGET: 50 studies" -ForegroundColor Cyan
$completion = [Math]::Round(($targetStudiesFound.Count / 50) * 100, 1)
Write-Host "📈 COMPLETION: $completion%" -ForegroundColor Magenta

Write-Host ""
Write-Host "=== CONFIRMED TARGET STUDIES ===" -ForegroundColor Green
$targetStudiesFound | Sort-Object | ForEach-Object { Write-Host "✅ $_" -ForegroundColor Green }
