# PowerShell script to organize PDFs based on crime location choice studies table
# This script will create two folders: "Keep" and "ToDelete" and move files accordingly

# Create directories
$baseDir = "c:\Users\kukumar\OneDrive - UGent\Job\crimsyndata\-crime-location-choice-studies\snatching work\References\PDFs"
$keepDir = Join-Path $baseDir "Keep"
$deleteDir = Join-Path $baseDir "ToDelete"

New-Item -ItemType Directory -Path $keepDir -Force
New-Item -ItemType Directory -Path $deleteDir -Force

# List of relevant PDF files to keep (based on your crime location choice studies table)
$relevantFiles = @(
    "Bernasco - 2006 - Co‐offending and the choice of target areas in bur.pdf",
    "Bernasco - 2010 - A Sentimental Journey To Crime  Effects of Reside.pdf",
    "Bernasco - 2010 - A SENTIMENTAL JOURNEY TO CRIME EFFECTS OF RESIDEN.pdf",
    "Bernasco - 2010 - Modeling Micro-Level Crime Location Choice Applic.pdf",
    "Bernasco - 2019 - Adolescent Offenders' Current Whereabouts Predict .pdf",
    "Bernasco and Block - 2009 - Where offenders choose to attack A discrete choic-1.pdf",
    "Bernasco and Block - 2009 - WHERE OFFENDERS CHOOSE TO ATTACK A DISCRETE CHOIC.pdf",
    "Bernasco and Kooistra - 2010 - Effects of residential history on commercial robbe.pdf",
    "Bernasco and Luykx - 2003 - EFFECTS OF ATTRACTIVENESS, OPPORTUNITY AND ACCESSI.pdf",
    "Bernasco et al. - 2013 - Go where the money is modeling street robbers' lo.pdf",
    "Bernasco et al. - 2015 - Learning where to offend Effects of past on futur.pdf",
    "Bernasco et al. - 2017 - Social Interactions and Crime Revisited An Invest.pdf",
    "Curtis-Ham et al. - 2022 - The Importance of Importance Sampling Exploring M.pdf",
    "Curtis-Ham et al. - 2025 - Familiar Locations and Similar Activities Examining the Contributions of Reliable and Relevant Know.pdf",
    "Curtis-Ham et al. - Relationships Between Offenders' Crime Locations a.pdf",
    "Frith - 2019 - Modelling taste heterogeneity regarding offence lo.pdf",
    "Frith et al. - 2017 - ROLE OF THE STREET NETWORK IN BURGLARS' SPATIAL DE.pdf",
    "Kuralarasan and Bernasco - 2022 - Location Choice of Snatching Offenders in Chennai .pdf",
    "Kuralarasan et al. - 2024 - Graffiti Writers Choose Locations That Optimize Exposure.pdf",
    "Langton and Steenbeek - 2017 - Residential burglary target selection An analysis.pdf",
    "Long and Liu - 2021 - Do Migrant and Native Robbers Target Different Pla.pdf",
    "Marchment and Gill - 2019 - Modelling the spatial decision making of terrorist.pdf",
    "Smith and Brown - 2007 - Discrete choice analysis of spatial attack sites.pdf",
    "Townsley et al. - 2015 - Burglar Target Selection A Cross-national Compari.pdf",
    "Vandeviver and Bernasco - 2020 - Location, Location, Location Effects of Neighbo.pdf",
    "Xue and Brown - 2006 - Spatial analysis with preference specification of latent decision makers for criminal event predicti.pdf",
    "Xue and Brown - 2006 - Spatial analysis with preference specification of .pdf"
)

# Get all PDF files in the directory
$allFiles = Get-ChildItem -Path $baseDir -Filter "*.pdf" | Where-Object { $_.Name -notin @("Keep", "ToDelete") }

$keptCount = 0
$deletedCount = 0

# Process each file
foreach ($file in $allFiles) {
    $fileName = $file.Name
    $isRelevant = $false
    
    # Check if this file matches any of our relevant files
    foreach ($relevantFile in $relevantFiles) {
        if ($fileName -eq $relevantFile) {
            $isRelevant = $true
            break
        }
    }
    
    if ($isRelevant) {
        # Move to Keep folder
        Move-Item -Path $file.FullName -Destination $keepDir
        Write-Host "KEPT: $fileName" -ForegroundColor Green
        $keptCount++
    } else {
        # Move to ToDelete folder
        Move-Item -Path $file.FullName -Destination $deleteDir
        Write-Host "MARKED FOR DELETION: $fileName" -ForegroundColor Red
        $deletedCount++
    }
}

Write-Host "`n=== SUMMARY ===" -ForegroundColor Yellow
Write-Host "Files kept: $keptCount" -ForegroundColor Green
Write-Host "Files marked for deletion: $deletedCount" -ForegroundColor Red
Write-Host "`nReview the files in the 'Keep' and 'ToDelete' folders before permanently deleting." -ForegroundColor Yellow
Write-Host "If satisfied, you can delete the 'ToDelete' folder and move files from 'Keep' back to the main PDFs folder." -ForegroundColor Yellow
