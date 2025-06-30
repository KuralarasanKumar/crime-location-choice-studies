# Simple but accurate analysis of current PDFs vs target studies

Write-Host "=== CURRENT PDF ANALYSIS ===" -ForegroundColor Yellow

# Get all PDF files
$pdfFiles = Get-ChildItem -Path ".\PDFs" -Filter "*.pdf" | Where-Object { $_.Name -ne "ToDelete" }

Write-Host "Found $($pdfFiles.Count) PDF files in main folder:" -ForegroundColor Cyan
Write-Host ""

# List all files
foreach ($file in $pdfFiles | Sort-Object Name) {
    Write-Host "📄 $($file.Name)" -ForegroundColor White
}

Write-Host ""
Write-Host "=== MANUAL VERIFICATION NEEDED ===" -ForegroundColor Yellow
Write-Host "Please manually verify which of these correspond to your 50 target studies." -ForegroundColor Cyan
Write-Host ""

# Show what we know we have for sure based on previous analysis
Write-Host "=== CONFIRMED MATCHES (from previous analysis) ===" -ForegroundColor Green
$confirmedMatches = @(
    "S01 - Bernasco et al. 2013 - Go where the money is",
    "S02 - Bernasco et al. 2017 - Do Street Robbery Location Choices Vary",
    "S11 - Kuralarasan & Bernasco 2022 - Location Choice of Snatching Offenders",
    "S13 - Menting 2018 - Awareness×Opportunity (NEW!)",
    "S17 - Long & Liu 2021 - Do Migrant and Native Robbers Target Different Places",
    "S19 - Curtis-Ham et al. 2022a - Relationships Between Offenders' Crime Locations",
    "S20 - Vandeviver & Bernasco 2020 - Location Location Location",
    "S22 - van Sleeuwen et al. 2021 - Right place, right time (NEW!)",
    "S24 - Bernasco 2006 - Co-offending and the Choice of Target Areas",
    "S26 - Bernasco & Luykx 2003 - Effect Attractiveness Opportunity",
    "S27 - Bernasco et al. 2015 - Learning where to offend",
    "S28 - Frith 2019 - Modelling taste heterogeneity",
    "S30 - Bernasco 2019 - Adolescent offenders' current whereabouts",
    "S32 - Bernasco & Block 2009 - Where offenders choose to attack",
    "S34 - Bernasco 2010a - A Sentimental Journey To Crime",
    "S35 - Bernasco 2010b - Modeling micro-level crime location choice",
    "S36 - Bernasco & Kooistra 2010 - Effects of Residential history",
    "S37 - Frith et al. 2017 - Role of the Street Network",
    "S41 - Langton & Steenbeek 2017 - Residential burglary target selection",
    "S42 - Marchment & Gill 2019 - Modelling the spatial decision making of terrorists",
    "S44 - Curtis-Ham et al. 2022b - The Importance of Importance Sampling",
    "S46 - Kuralarasan et al. 2024 - Graffiti Writers Choose Locations",
    "S48 - Smith & Brown 2007 - discrete choice analysis of spatial attack sites",
    "S50 - Curtis-Ham et al. 2025 - familiar locations and similar activities",
    "S54 - Xue & Brown 2006 - spatial analysis with preference specification",
    "S04/12/25 - Townsley et al. 2015 - Burglar Target Selection (covers 3 studies)"
)

foreach ($match in $confirmedMatches) {
    Write-Host "✅ $match" -ForegroundColor Green
}

Write-Host ""
Write-Host "ESTIMATED STATUS:" -ForegroundColor Yellow
Write-Host "✅ FOUND: ~28-29 studies" -ForegroundColor Green
Write-Host "❌ MISSING: ~21-22 studies" -ForegroundColor Red
Write-Host "🎯 TARGET: 50 studies total" -ForegroundColor Cyan
