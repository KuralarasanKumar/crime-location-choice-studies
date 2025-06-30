# Simple analysis of current PDFs vs target studies

Write-Host "=== CHECKING YOUR TARGET STUDIES ===" -ForegroundColor Yellow

# Get crime location choice PDFs (filter out obviously irrelevant ones)
$pdfFiles = Get-ChildItem -Path ".\PDFs" -Filter "*.pdf" | Where-Object { 
    $_.Name -notlike "*corruption*" -and 
    $_.Name -notlike "*graffiti*" -and
    $_.Name -notlike "*police*" -and
    $_.Name -notlike "*access*" -and
    $_.Name -notlike "*privacy*" -and
    $_.Name -notlike "*network*" -and
    $_.Name -notlike "*tutoring*" -and
    $_.Name -notlike "*taxonomy*" -and
    $_.Name -notlike "*8875*" -and
    $_.Name -ne "_.pdf" -and
    $_.Name -ne "ToDelete"
}

Write-Host "Found $($pdfFiles.Count) potentially relevant PDF files"
Write-Host ""

# Known target studies we can identify
$knownMatches = @()

foreach ($file in $pdfFiles) {
    $name = $file.Name
    
    # Check for specific studies
    if ($name -like "*Bernasco*2013*money*") { $knownMatches += "S01 - Bernasco et al 2013 - Go where the money is" }
    if ($name -like "*Bernasco*2017*Street Robbery*") { $knownMatches += "S02 - Bernasco et al 2017 - Street Robbery Choices" }
    if ($name -like "*Kuralarasan*Bernasco*2022*Snatching*") { $knownMatches += "S11 - Kuralarasan & Bernasco 2022 - Snatching Chennai" }
    if ($name -like "*Menting*2018*AWARENESS*OPPORTUNITY*") { $knownMatches += "S13 - Menting 2018 - Awareness Opportunity" }
    if ($name -like "*Long*Liu*2021*Migrant*Native*") { $knownMatches += "S17 - Long & Liu 2021 - Migrant Native Robbers" }
    if ($name -like "*Curtis-Ham*Relationships*") { $knownMatches += "S19 - Curtis-Ham et al 2022a - Relationships" }
    if ($name -like "*Vandeviver*Bernasco*2020*Location*") { $knownMatches += "S20 - Vandeviver & Bernasco 2020 - Location Location Location" }
    if ($name -like "*Sleeuwen*2021*") { $knownMatches += "S22 - van Sleeuwen et al 2021 - Right place right time" }
    if ($name -like "*Frith*2019*taste*") { $knownMatches += "S28 - Frith 2019 - taste heterogeneity" }
    if ($name -like "*Bernasco*2019*Adolescent*") { $knownMatches += "S30 - Bernasco 2019 - Adolescent whereabouts" }
    if ($name -like "*Bernasco*Block*2009*") { $knownMatches += "S32 - Bernasco & Block 2009 - Where offenders choose" }
    if ($name -like "*Bernasco*2010*Sentimental*") { $knownMatches += "S34 - Bernasco 2010a - Sentimental Journey" }
    if ($name -like "*Bernasco*2010*Modeling*micro*") { $knownMatches += "S35 - Bernasco 2010b - Modeling micro-level" }
    if ($name -like "*Bernasco*Kooistra*2010*") { $knownMatches += "S36 - Bernasco & Kooistra 2010 - residential history" }
    if ($name -like "*Frith*2017*Street Network*") { $knownMatches += "S37 - Frith et al 2017 - Street Network" }
    if ($name -like "*Langton*Steenbeek*2017*") { $knownMatches += "S41 - Langton & Steenbeek 2017 - burglary target" }
    if ($name -like "*Marchment*Gill*2019*") { $knownMatches += "S42 - Marchment & Gill 2019 - terrorists" }
    if ($name -like "*Curtis-Ham*Importance*Sampling*") { $knownMatches += "S44 - Curtis-Ham et al 2022b - Importance Sampling" }
    if ($name -like "*Kuralarasan*2024*Graffiti*") { $knownMatches += "S46 - Kuralarasan et al 2024 - Graffiti Writers" }
    if ($name -like "*Rowan*Crime Pattern Theory*") { $knownMatches += "S47 - Rowan et al 2022 - Crime Pattern Theory" }
    if ($name -like "*Smith*Brown*2007*discrete*choice*") { $knownMatches += "S48 - Smith & Brown 2007 - discrete choice" }
    if ($name -like "*Curtis-Ham*2025*familiar*") { $knownMatches += "S50 - Curtis-Ham et al 2025 - familiar locations" }
    if ($name -like "*Xue*Brown*2006*spatial*analysis*") { $knownMatches += "S54 - Xue & Brown 2006 - spatial analysis" }
    if ($name -like "*Townsley*2015*Burglar*Target*") { $knownMatches += "S04/12/25 - Townsley et al 2015 - Cross-national" }
    if ($name -like "*Bernasco*Luykx*2003*") { $knownMatches += "S26 - Bernasco & Luykx 2003 - Attractiveness" }
    if ($name -like "*Bernasco*2015*Learning*") { $knownMatches += "S27 - Bernasco et al 2015 - Learning where to offend" }
}

Write-Host "=== CONFIRMED TARGET STUDIES FOUND ===" -ForegroundColor Green
foreach ($match in $knownMatches | Sort-Object) {
    Write-Host "✅ $match" -ForegroundColor Green
}

Write-Host ""
Write-Host "=== SUMMARY ===" -ForegroundColor Yellow
Write-Host "✅ CONFIRMED FOUND: $($knownMatches.Count) target studies" -ForegroundColor Green
Write-Host "📁 TOTAL PDF FILES: $($pdfFiles.Count)" -ForegroundColor Cyan
Write-Host "🎯 TARGET: 50 studies total" -ForegroundColor White

if ($knownMatches.Count -gt 28) {
    Write-Host ""
    Write-Host "EXCELLENT! You have added new target studies!" -ForegroundColor Green
}

Write-Host ""
Write-Host "=== ALL PDF FILES IN FOLDER ===" -ForegroundColor Cyan
$pdfFiles | Sort-Object Name | ForEach-Object { Write-Host "📄 $($_.Name)" -ForegroundColor White }

Write-Host ""
Write-Host "=== RECOMMENDATION ===" -ForegroundColor Yellow
Write-Host "1. Review the list above to manually identify any additional target studies" -ForegroundColor White
Write-Host "2. Move irrelevant files to ToDelete folder to keep collection clean" -ForegroundColor White
