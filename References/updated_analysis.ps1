# Updated Analysis: Check for newly added target studies
# This script will identify which of the 50 target studies are now present

$targetStudies = @(
    @{ "SNo" = "S01"; "KeyTerms" = @("Bernasco", "2013", "Go where the money", "street robbers") },
    @{ "SNo" = "S02"; "KeyTerms" = @("Bernasco", "2017", "Street Robbery Location Choices", "Time of Day") },
    @{ "SNo" = "S03"; "KeyTerms" = @("Clare", "2009", "barriers", "connectors", "burglars") },
    @{ "SNo" = "S04"; "KeyTerms" = @("Townsley", "2015", "Burglar Target Selection", "AU", "statistical local") },
    @{ "SNo" = "S05"; "KeyTerms" = @("Townsley", "2016", "Target Selection", "Preference Variation") },
    @{ "SNo" = "S06"; "KeyTerms" = @("Lammers", "2015", "Biting Once", "Twice", "Prior") },
    @{ "SNo" = "S07"; "KeyTerms" = @("Lammers", "2017", "Co-offenders", "shared awareness") },
    @{ "SNo" = "S08"; "KeyTerms" = @("Menting", "2016", "Family Matters", "Family Members") },
    @{ "SNo" = "S09"; "KeyTerms" = @("Sleeuwen", "2018", "Time for Crime", "Temporal Aspects") },
    @{ "SNo" = "S10"; "KeyTerms" = @("Xiao", "2021", "Burglars blocked", "barriers") },
    @{ "SNo" = "S11"; "KeyTerms" = @("Kuralarasan", "Bernasco", "2022", "Snatching", "Chennai") },
    @{ "SNo" = "S12"; "KeyTerms" = @("Townsley", "2015", "Burglar Target Selection", "UK", "Super Output") },
    @{ "SNo" = "S13"; "KeyTerms" = @("Menting", "2018", "Awareness", "Opportunity") },
    @{ "SNo" = "S14"; "KeyTerms" = @("Song", "2019", "Crime Feeds", "Legal Activities") },
    @{ "SNo" = "S15"; "KeyTerms" = @("Long", "2018", "prior", "subsequent", "ZG City") },
    @{ "SNo" = "S16"; "KeyTerms" = @("Long", "2021", "Ambient population", "surveillance cameras") },
    @{ "SNo" = "S17"; "KeyTerms" = @("Long", "Liu", "2021", "Migrant", "Native Robbers") },
    @{ "SNo" = "S18"; "KeyTerms" = @("Long", "Liu", "2022", "juvenile", "young adult", "adult offenders") },
    @{ "SNo" = "S19"; "KeyTerms" = @("Curtis-Ham", "2022", "Relationships", "Offenders", "Crime Locations") },
    @{ "SNo" = "S20"; "KeyTerms" = @("Vandeviver", "Bernasco", "2020", "Location Location Location") },
    @{ "SNo" = "S21"; "KeyTerms" = @("Menting", "2020", "Activity Space", "Visiting Frequency") },
    @{ "SNo" = "S22"; "KeyTerms" = @("Sleeuwen", "2021", "Right place", "right time") },
    @{ "SNo" = "S23"; "KeyTerms" = @("Bernasco", "Nieuwbeerta", "2005", "residential burglars", "target areas") },
    @{ "SNo" = "S24"; "KeyTerms" = @("Bernasco", "2006", "Co-offending", "Choice of Target") },
    @{ "SNo" = "S25"; "KeyTerms" = @("Townsley", "2015", "Burglar Target Selection", "NL") },
    @{ "SNo" = "S26"; "KeyTerms" = @("Bernasco", "Luykx", "2003", "Attractiveness", "Opportunity") },
    @{ "SNo" = "S27"; "KeyTerms" = @("Bernasco", "2015", "Learning where to offend") },
    @{ "SNo" = "S28"; "KeyTerms" = @("Frith", "2019", "taste heterogeneity") },
    @{ "SNo" = "S29"; "KeyTerms" = @("Hanayama", "2018", "past crime data", "attractiveness") },
    @{ "SNo" = "S30"; "KeyTerms" = @("Bernasco", "2019", "Adolescent", "whereabouts") },
    @{ "SNo" = "S31"; "KeyTerms" = @("Bernasco", "Jacques", "2015", "Dealers", "Solicit") },
    @{ "SNo" = "S32"; "KeyTerms" = @("Bernasco", "Block", "2009", "offenders choose to attack") },
    @{ "SNo" = "S33"; "KeyTerms" = @("Chamberlain", "Boggess", "2016", "Relative Difference") },
    @{ "SNo" = "S34"; "KeyTerms" = @("Bernasco", "2010", "Sentimental Journey") },
    @{ "SNo" = "S35"; "KeyTerms" = @("Bernasco", "2010", "Modeling micro-level") },
    @{ "SNo" = "S36"; "KeyTerms" = @("Bernasco", "Kooistra", "2010", "residential history", "commercial") },
    @{ "SNo" = "S37"; "KeyTerms" = @("Frith", "2017", "Street Network", "Burglars") },
    @{ "SNo" = "S38"; "KeyTerms" = @("Baudains", "2013", "Extreme Events", "London Riots") },
    @{ "SNo" = "S39"; "KeyTerms" = @("Johnson", "Summers", "2015", "Ecological Theories") },
    @{ "SNo" = "S40"; "KeyTerms" = @("Vandeviver", "2015", "discrete spatial choice", "house-level") },
    @{ "SNo" = "S41"; "KeyTerms" = @("Langton", "Steenbeek", "2017", "burglary target", "property-level") },
    @{ "SNo" = "S42"; "KeyTerms" = @("Marchment", "Gill", "2019", "spatial decision", "terrorists") },
    @{ "SNo" = "S43"; "KeyTerms" = @("Chamberlain", "2022", "Traveling Alone", "Together") },
    @{ "SNo" = "S44"; "KeyTerms" = @("Curtis-Ham", "2022", "Importance Sampling") },
    @{ "SNo" = "S45"; "KeyTerms" = @("Yue", "2023", "people on street", "streetscape") },
    @{ "SNo" = "S46"; "KeyTerms" = @("Kuralarasan", "2024", "Graffiti Writers") },
    @{ "SNo" = "S47"; "KeyTerms" = @("Rowan", "Appleby", "McGloin", "2022", "Crime Pattern Theory") },
    @{ "SNo" = "S48"; "KeyTerms" = @("Smith", "Brown", "2007", "discrete choice", "spatial attack") },
    @{ "SNo" = "S49"; "KeyTerms" = @("Cai", "2024", "divergent", "decisionmaking") },
    @{ "SNo" = "S50"; "KeyTerms" = @("Curtis-Ham", "2025", "familiar locations") },
    @{ "SNo" = "S54"; "KeyTerms" = @("Xue", "Brown", "2006", "spatial analysis", "preference specification") }
)

# Get all PDF files (excluding irrelevant ones)
$allFiles = Get-ChildItem -Path ".\PDFs" -Filter "*.pdf" | Where-Object { 
    $_.Name -notlike "*corruption*" -and 
    $_.Name -notlike "*police*" -and 
    $_.Name -notlike "*graffiti*" -and
    $_.Name -ne "ToDelete" -and
    $_.Name -notlike "*access*" -and
    $_.Name -notlike "*privacy*" -and
    $_.Name -notlike "*geomasking*" -and
    $_.Name -notlike "*network*" -and
    $_.Name -notlike "*tutoring*" -and
    $_.Name -notlike "*taxonomy*" -and
    $_.Name -notlike "*ransom*" -and
    $_.Name -notlike "*bicycle*" -and
    $_.Name -notlike "*genealogy*" -and
    $_.Name -notlike "*whistleblowing*" -and
    $_.Name -notlike "*statistics*" -and
    $_.Name -notlike "*programming*"
}

Write-Host "=== UPDATED ANALYSIS: TARGET STUDIES CHECK ===" -ForegroundColor Yellow
Write-Host "Checking which target studies are now present..." -ForegroundColor Cyan
Write-Host ""

$foundStudies = @()
$stillMissing = @()

foreach ($study in $targetStudies) {
    $found = $false
    $matchedFile = ""
    
    # Check each PDF file
    foreach ($file in $allFiles) {
        $fileName = $file.Name
        $matchCount = 0
        
        # Count how many key terms match
        foreach ($term in $study.KeyTerms) {
            if ($fileName -like "*$term*") {
                $matchCount++
            }
        }
        
        # If most key terms match, consider it found
        $threshold = [Math]::Max(2, [Math]::Floor($study.KeyTerms.Count * 0.6))
        if ($matchCount -ge $threshold) {
            $found = $true
            $matchedFile = $fileName
            break
        }
    }
    
    if ($found) {
        $foundStudies += @{ "SNo" = $study.SNo; "File" = $matchedFile }
        Write-Host "✅ $($study.SNo) FOUND: $matchedFile" -ForegroundColor Green
    } else {
        $stillMissing += $study.SNo
        Write-Host "❌ $($study.SNo) STILL MISSING" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "=== SUMMARY ===" -ForegroundColor Yellow
Write-Host "✅ FOUND: $($foundStudies.Count) studies" -ForegroundColor Green
Write-Host "❌ STILL MISSING: $($stillMissing.Count) studies" -ForegroundColor Red
Write-Host "🎯 TOTAL TARGET: $($targetStudies.Count) studies" -ForegroundColor Cyan
Write-Host "📈 COMPLETION: $([Math]::Round(($foundStudies.Count / $targetStudies.Count) * 100, 1))%" -ForegroundColor Magenta

Write-Host ""
Write-Host "=== STILL MISSING ===" -ForegroundColor Red
$stillMissing | ForEach-Object { Write-Host "❌ $_" -ForegroundColor Red }

if ($foundStudies.Count -gt 28) {
    Write-Host ""
    Write-Host "GREAT PROGRESS! You have added new target studies!" -ForegroundColor Green
}

# Also check for any irrelevant files that should be moved to ToDelete
Write-Host ""
Write-Host "=== CHECKING FOR IRRELEVANT FILES ===" -ForegroundColor Yellow
$irrelevantFiles = Get-ChildItem -Path ".\PDFs" -Filter "*.pdf" | Where-Object { 
    $_.Name -like "*corruption*" -or 
    $_.Name -like "*police*" -or 
    $_.Name -like "*graffiti*" -or
    $_.Name -like "*access*" -or
    $_.Name -like "*privacy*" -or
    $_.Name -like "*geomasking*" -or
    $_.Name -like "*network*" -or
    $_.Name -like "*tutoring*" -or
    $_.Name -like "*taxonomy*" -or
    $_.Name -like "*ransom*" -or
    $_.Name -like "*bicycle*" -or
    $_.Name -like "*genealogy*" -or
    $_.Name -like "*whistleblowing*" -or
    $_.Name -like "*statistics*" -or
    $_.Name -like "*programming*" -or
    $_.Name -like "*8875*" -or
    $_.Name -eq "_.pdf"
}

if ($irrelevantFiles.Count -gt 0) {
    Write-Host "Found $($irrelevantFiles.Count) irrelevant files that should be moved to ToDelete:" -ForegroundColor Red
    $irrelevantFiles | ForEach-Object { Write-Host "  📄 $($_.Name)" -ForegroundColor Gray }
    
    $response = Read-Host "`nMove these irrelevant files to ToDelete folder? (y/N)"
    if ($response -eq "y" -or $response -eq "Y") {
        foreach ($file in $irrelevantFiles) {
            $destination = Join-Path ".\PDFs\ToDelete" $file.Name
            Move-Item -Path $file.FullName -Destination $destination
            Write-Host "Moved: $($file.Name)" -ForegroundColor Green
        }
        Write-Host "Cleanup completed!" -ForegroundColor Green
    }
}
