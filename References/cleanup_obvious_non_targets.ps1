# Clean up obvious non-target files
# Moves files that are clearly not target studies to ToDelete folder

$pdfFolder = "C:\Users\kukumar\OneDrive - UGent\Job\crimsyndata\-crime-location-choice-studies\snatching work\References\PDFs"
$toDeleteFolder = "C:\Users\kukumar\OneDrive - UGent\Job\crimsyndata\-crime-location-choice-studies\snatching work\References\PDFs\ToDelete"

# Files identified as obvious non-targets
$obviousNonTargets = @(
    "Brent et al. - 2011 - Social Network Analysis in the Study of Nonhuman Primates A Historical Perspective.pdf",
    "Ferrell - 1995 - Urban Graffiti Crime, Control, and Resistance.pdf",
    "Geoprivacy.PhD.Thesis.FrameworkText.RK.pdf",
    "Girvan and Newman - 2002 - Community structure in social and biological networks.pdf",
    "Krathwohl - 2002 - A Revision of Bloom's Taxonomy An Overview.pdf",
    "Lachmann - 1988 - Graffiti as Career and Ideology.pdf",
    "Mateo - Is there a Personality Trait which Correlates to Gray Corruption Tolerance in a Philippine.pdf",
    "Sweeney - 2002 - k-ANONYMITY A MODEL FOR PROTECTING PRIVACY.pdf",
    "Watts and Strogatz - 1998 - Collective dynamics of 'small-world' networks.pdf"
)

# Additional corruption/non-target files that are clearly not about crime location choice
$additionalNonTargets = @(
    "2020 - Perceived Organizational Injustice and Corrupt Tendencies in Public Sector Employees Mediating Role.pdf",
    "Amini et al. - 2022 - Individualism and attitudes towards reporting corruption evidence from post-communist economies.pdf",
    "Anderson - 2009 - A taxonomy for learning, teaching, and assessing a revision of Bloom's taxonomy of educational obje.pdf",
    "Andriani and Ashyrov - 2022 - Corruption and life satisfaction Evidence from a transition survey.pdf",
    "Asomah et al. - 2023 - Are women less corrupt than men Evidence from Ghana.pdf",
    "Cameron et al. - 2005 - Do Attitudes Towards Corruption Differ Across Cultures Experimental Evidence from Australia, India,.pdf",
    "Costa Neto et al. - 2024 - Service to demands and corruption tolerance brazilian voters' perception of `"rouba, mas faz`" policy.pdf",
    "Han - 2023 - Examining Determinants of Corruption at the Individual Level in South Asia.pdf",
    "Ogungbamila et al. - 2024 - Whistleblowing and Corrupt Tendencies among Selected Employees in Three Public Organizations Roles.pdf",
    "Wang and Sun - 2016 - Absolute power leads to absolute corruption Impact of power on corruption depending on the concepts.pdf"
)

Write-Host "Cleaning up obvious non-target files..." -ForegroundColor Yellow

$moveCount = 0
$allNonTargets = $obviousNonTargets + $additionalNonTargets

foreach ($filename in $allNonTargets) {
    $sourcePath = Join-Path $pdfFolder $filename
    $destPath = Join-Path $toDeleteFolder $filename
    
    if (Test-Path $sourcePath) {
        try {
            Move-Item $sourcePath $destPath -Force
            Write-Host "✓ Moved: $filename" -ForegroundColor Green
            $moveCount++
        }
        catch {
            Write-Host "✗ Failed to move: $filename" -ForegroundColor Red
        }
    }
    else {
        Write-Host "? Not found: $filename" -ForegroundColor Gray
    }
}

Write-Host "`nCleanup complete!" -ForegroundColor Green
Write-Host "Moved $moveCount files to ToDelete folder" -ForegroundColor Cyan

# Show remaining file count
$remainingFiles = Get-ChildItem $pdfFolder -Filter "*.pdf" | Where-Object { $_.Name -ne "_.pdf" }
Write-Host "Remaining PDFs in main folder: $($remainingFiles.Count)" -ForegroundColor Yellow
