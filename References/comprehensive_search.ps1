# Comprehensive search for missing PDFs
# Search the ToDelete folder for remaining missing studies

$toDeletePath = ".\PDFs\ToDelete"
$mainPath = ".\PDFs"

# Define missing studies with multiple search patterns
$missingStudies = @{
    "Chamberlain_2022" = @("Chamberlain", "2022", "Traveling Alone", "Together", "Neighborhood Context")
    "Chamberlain_Boggess_2016" = @("Chamberlain", "Boggess", "2016", "Relative Difference", "Burglary Location")
    "Baudains_2013" = @("Baudains", "2013", "Target Choice", "Extreme Events", "London Riots")
    "Bernasco_Jacques_2015" = @("Jacques", "2015", "Dealers", "Solicit", "Customers", "Drugs")
    "Bernasco_Nieuwbeerta_2005" = @("Nieuwbeerta", "2005", "residential burglars", "target areas")
    "Cai_2024" = @("Cai", "2024", "divergent", "decisionmaking", "neighborhood context")
    "Clare_2009" = @("Clare", "2009", "barriers", "connectors", "residential burglars")
    "Hanayama_2018" = @("Hanayama", "2018", "past crime data", "attractiveness", "residential burglars")
    "Johnson_Summers_2015" = @("Johnson", "Summers", "2015", "Ecological Theories", "Offender Spatial")
    "Lammers_2015" = @("Lammers", "2015", "Biting Once", "Twice", "Prior")
    "Lammers_2017" = @("Lammers", "2017", "Co-offenders", "crime location choice", "awareness space")
    "Long_Liu_2022" = @("Long", "Liu", "2022", "juvenile", "young adult", "adult offenders")
    "Long_2018" = @("Long", "2018", "prior", "subsequent", "street robbery", "ZG City")
    "Long_2021" = @("Long", "2021", "Ambient population", "surveillance cameras", "guardianship")
    "Menting_2016" = @("Menting", "2016", "Family Matters", "Family Members")
    "Menting_2020" = @("Menting", "2020", "Activity Space", "Visiting Frequency")
    "Rowan_2022" = @("Rowan", "Appleby", "McGloin", "2022", "Crime Pattern Theory", "Co-Offending")
    "Sleeuwen_2018" = @("Sleeuwen", "2018", "Time for Crime", "Temporal Aspects", "Repeat Offenders")
    "Song_2019" = @("Song", "2019", "Crime Feeds", "Legal Activities", "Daily Mobility")
    "Townsley_2016" = @("Townsley", "2016", "Target Selection", "Preference Variation")
    "Vandeviver_2015" = @("Vandeviver", "2015", "discrete spatial choice", "burglary target", "house-level")
    "Xiao_2021" = @("Xiao", "2021", "Burglars blocked", "barriers", "physical", "social")
    "Yue_2023" = @("Yue", "2023", "people on street", "streetscape", "street view", "street theft")
}

Write-Host "Searching for remaining missing studies in ToDelete folder..." -ForegroundColor Yellow
Write-Host "ToDelete folder: $(Resolve-Path $toDeletePath)" -ForegroundColor Cyan

$foundFiles = @()

# Get all PDF files in ToDelete folder
$allFiles = Get-ChildItem -Path $toDeletePath -Filter "*.pdf" -Recurse

Write-Host "Scanning $($allFiles.Count) files..." -ForegroundColor Gray

foreach ($study in $missingStudies.Keys) {
    $patterns = $missingStudies[$study]
    Write-Host "`nSearching for: $study" -ForegroundColor Green
    
    foreach ($file in $allFiles) {
        $fileName = $file.Name
        $matchCount = 0
        
        # Check how many patterns match
        foreach ($pattern in $patterns) {
            if ($fileName -like "*$pattern*") {
                $matchCount++
            }
        }
        
        # If at least 2 patterns match, it's likely our file
        if ($matchCount -ge 2) {
            Write-Host "  POTENTIAL MATCH: $fileName (matched $matchCount patterns)" -ForegroundColor Cyan
            $foundFiles += @{
                "Study" = $study
                "File" = $file
                "Matches" = $matchCount
                "Patterns" = ($patterns | Where-Object { $fileName -like "*$_*" }) -join ", "
            }
        }
    }
}

Write-Host "`n=== SEARCH RESULTS ===" -ForegroundColor Yellow
if ($foundFiles.Count -gt 0) {
    Write-Host "Found $($foundFiles.Count) potential matches:" -ForegroundColor Green
    
    foreach ($found in $foundFiles) {
        Write-Host "  $($found.Study): $($found.File.Name)" -ForegroundColor White
        Write-Host "    Matched patterns: $($found.Patterns)" -ForegroundColor Gray
        Write-Host "    Match strength: $($found.Matches)/$($missingStudies[$found.Study].Count)" -ForegroundColor Gray
        Write-Host ""
    }
    
    $response = Read-Host "Do you want to move these files to the main folder? (y/N)"
    if ($response -eq "y" -or $response -eq "Y") {
        foreach ($found in $foundFiles) {
            $destination = Join-Path $mainPath $found.File.Name
            Move-Item -Path $found.File.FullName -Destination $destination
            Write-Host "Moved: $($found.File.Name)" -ForegroundColor Green
        }
        Write-Host "Files moved successfully!" -ForegroundColor Green
    }
} else {
    Write-Host "No additional matches found in ToDelete folder." -ForegroundColor Red
}

Write-Host "`nSearch completed!" -ForegroundColor Yellow
