# Final Comprehensive Verification Script
# This script systematically checks every PDF against the 50 target studies

$pdfFolder = "C:\Users\kukumar\OneDrive - UGent\Job\crimsyndata\-crime-location-choice-studies\snatching work\References\PDFs"
$outputFile = "C:\Users\kukumar\OneDrive - UGent\Job\crimsyndata\-crime-location-choice-studies\snatching work\References\FINAL_VERIFICATION_REPORT.txt"

# Define the 50 target studies with key identifiers
$targetStudies = @(
    @{ID="S43"; Keywords=@("Chamberlain", "2022", "Traveling Alone", "Together", "Neighborhood Context", "Juvenile", "Adult", "Burglary"); AuthorYear="Chamberlain et al., 2022"},
    @{ID="S33"; Keywords=@("Chamberlain", "Boggess", "2016", "Relative Difference", "Burglary Location", "Ecological Characteristics", "Home Neighborhood"); AuthorYear="A. W. Chamberlain & Boggess, 2016"},
    @{ID="S38"; Keywords=@("Baudains", "2013", "Target Choice", "Extreme Events", "Discrete Spatial Choice", "2011 London Riots", "LSOA"); AuthorYear="Baudains et al., 2013"},
    @{ID="S32"; Keywords=@("Bernasco", "Block", "2009", "Where offenders choose", "attack", "discrete choice", "robberies", "Chicago"); AuthorYear="Bernasco & Block, 2009"},
    @{ID="S31"; Keywords=@("Bernasco", "Jacques", "2015", "Where Do Dealers", "Solicit Customers", "Sell Them Drugs"); AuthorYear="Bernasco & Jacques, 2015"},
    @{ID="S36"; Keywords=@("Bernasco", "Kooistra", "2010", "Effects of Residential history", "Commercial Robbers", "Crime Location Choices"); AuthorYear="Bernasco & Kooistra, 2010"},
    @{ID="S26"; Keywords=@("Bernasco", "Luykx", "2003", "Effect Attractiveness Opportunity", "Accessibility", "Burglars", "Residential Burglary", "Urban Neighborhoods"); AuthorYear="Bernasco & Luykx, 2003"},
    @{ID="S23"; Keywords=@("Bernasco", "Nieuwbeerta", "2005", "residential burglars", "select target areas", "analysis of criminal location choice"); AuthorYear="Bernasco & Nieuwbeerta, 2005"},
    @{ID="S01"; Keywords=@("Bernasco", "2013", "Go where the money is", "street robbers", "location choices"); AuthorYear="Bernasco et al., 2013"},
    @{ID="S27"; Keywords=@("Bernasco", "2015", "Learning where to offend", "Effects of past", "future burglary locations", "LSOA"); AuthorYear="Bernasco et al., 2015"},
    @{ID="S02"; Keywords=@("Bernasco", "2017", "Street Robbery Location Choices", "time of day", "day of week", "Chicago"); AuthorYear="Bernasco et al., 2017"},
    @{ID="S24"; Keywords=@("Bernasco", "2006", "Co-offending", "Choice of Target Areas", "Burglary"); AuthorYear="Bernasco, 2006"},
    @{ID="S34"; Keywords=@("Bernasco", "2010", "Sentimental Journey To Crime", "Residential History", "Crime Location Choice"); AuthorYear="Bernasco, 2010a"},
    @{ID="S35"; Keywords=@("Bernasco", "2010", "Modeling micro-level crime location choice", "discrete choice framework", "crime at places"); AuthorYear="Bernasco, 2010b"},
    @{ID="S30"; Keywords=@("Bernasco", "2019", "Adolescent offenders", "current whereabouts", "predict locations", "future crime"); AuthorYear="Bernasco, 2019"},
    @{ID="S03"; Keywords=@("Clare", "2009", "Formal evaluation", "impact of barriers", "connectors", "residential burglars", "macro-level offending"); AuthorYear="Clare et al., 2009"},
    @{ID="S19"; Keywords=@("Curtis-Ham", "2022", "Relationships Between Offenders", "Crime Locations", "Prior Activity Locations", "Police Data"); AuthorYear="Curtis-Ham et al., 2022a"},
    @{ID="S44"; Keywords=@("Curtis-Ham", "2022", "Importance of Importance Sampling", "Methods of Sampling", "alternatives", "Discrete Choice Models"); AuthorYear="Curtis-Ham et al., 2022b"},
    @{ID="S37"; Keywords=@("Frith", "2017", "Role of the Street Network", "Burglars", "Spatial Decision-Making"); AuthorYear="Frith et al., 2017"},
    @{ID="S28"; Keywords=@("Frith", "2019", "Modelling taste heterogeneity", "offence location choices", "Census output area"); AuthorYear="Frith, 2019"},
    @{ID="S29"; Keywords=@("Hanayama", "2018", "usefulness of past crime data", "attractiveness index", "residential burglars"); AuthorYear="Hanayama et al., 2018"},
    @{ID="S39"; Keywords=@("Johnson", "Summers", "2015", "Testing Ecological Theories", "Offender Spatial Decision Making", "Discrete Choice Model", "LSOA"); AuthorYear="Johnson & Summers, 2015"},
    @{ID="S46"; Keywords=@("Kuralarasa", "2024", "Graffiti Writers Choose Locations", "Optimize Exposure"); AuthorYear="Kuralarasa et al, 2024"},
    @{ID="S11"; Keywords=@("Kuralarasan", "Bernasco", "2022", "Location Choice", "Snatching Offenders", "Chennai City", "Wards"); AuthorYear="Kuralarasan & Bernasco, 2022"},
    @{ID="S06"; Keywords=@("Lammers", "2015", "Biting Once Twice", "Influence of Prior", "subsequent Crime Location Choice"); AuthorYear="Lammers et al., 2015"},
    @{ID="S07"; Keywords=@("Lammers", "2017", "Co-offenders", "crime location choice", "co-offending groups", "shared awareness space"); AuthorYear="Lammers, 2017"},
    @{ID="S41"; Keywords=@("Langton", "Steenbeek", "2017", "Residential burglary target selection", "property-level", "Google Street View"); AuthorYear="Langton & Steenbeek, 2017"},
    @{ID="S17"; Keywords=@("Long", "Liu", "2021", "Migrant", "Native Robbers", "Target Different Places"); AuthorYear="Long & Liu, 2021"},
    @{ID="S18"; Keywords=@("Long", "Liu", "2022", "juvenile", "young adult", "adult offenders", "target different places", "Chinese context"); AuthorYear="Long & Liu, 2022"},
    @{ID="S15"; Keywords=@("Long", "2018", "Assessing the influence of prior", "subsequent street robbery", "location choices", "ZG City", "China"); AuthorYear="Long et al., 2018"},
    @{ID="S16"; Keywords=@("Long", "2021", "Ambient population", "surveillance cameras", "guardianship role", "street robbers"); AuthorYear="Long et al., 2021"},
    @{ID="S42"; Keywords=@("Marchment", "Gill", "2019", "Modelling the spatial decision making", "terrorists", "discrete choice approach"); AuthorYear="Marchment & Gill, 2019"},
    @{ID="S08"; Keywords=@("Menting", "2016", "Family Matters", "Effects of Family Members", "Residential Areas", "Crime Location Choice"); AuthorYear="Menting et al., 2016"},
    @{ID="S21"; Keywords=@("Menting", "2020", "Influence of Activity Space", "Visiting Frequency", "Crime Location Choice", "Online Self-Report Survey"); AuthorYear="Menting et al., 2020"},
    @{ID="S13"; Keywords=@("Menting", "2018", "Awareness", "Opportunity", "Testing Interactions", "Activity Nodes", "Criminal Opportunity"); AuthorYear="Menting, 2018"},
    @{ID="S09"; Keywords=@("van Sleeuwen", "2018", "Time for a Crime", "Temporal Aspects", "Repeat Offenders", "Crime Location Choices"); AuthorYear="S. E. M. van Sleeuwen et al., 2018"},
    @{ID="S22"; Keywords=@("van Sleeuwen", "2021", "Right place", "right time", "crime pattern theory", "time-specific"); AuthorYear="S. van Sleeuwen et al., 2021"},
    @{ID="S14"; Keywords=@("Song", "2019", "Crime Feeds on Legal Activities", "Daily Mobility Flows", "Thieves", "Target Location Choices"); AuthorYear="Song et al., 2019"},
    @{ID="S04"; Keywords=@("Townsley", "2015", "Burglar Target Selection", "Cross-national Comparison", "statistical local areas", "AU"); AuthorYear="Townsley et al., 2015"},
    @{ID="S12"; Keywords=@("Townsley", "2015", "Burglar Target Selection", "Cross-national Comparison", "Super Output Areas", "UK"); AuthorYear="Townsley et al., 2015"},
    @{ID="S25"; Keywords=@("Townsley", "2015", "Burglar Target Selection", "Cross-national Comparison", "NL"); AuthorYear="Townsley et al., 2015"},
    @{ID="S05"; Keywords=@("Townsley", "2016", "Target Selection Models", "Preference Variation", "Between Offenders"); AuthorYear="Townsley et al., 2016"},
    @{ID="S20"; Keywords=@("Vandeviver", "Bernasco", "2020", "Location Location Location", "Effects of Neighborhood", "House Attributes", "Burglars", "Target Selection"); AuthorYear="Vandeviver & Bernasco, 2020"},
    @{ID="S40"; Keywords=@("Vandeviver", "2015", "discrete spatial choice model", "burglary target selection", "house-level"); AuthorYear="Vandeviver et al., 2015"},
    @{ID="S10"; Keywords=@("Xiao", "2021", "Burglars blocked by barriers", "impact of physical and social barriers", "residential burglars", "China"); AuthorYear="Xiao et al., 2021"},
    @{ID="S54"; Keywords=@("Xue", "Brown", "2006", "spatial analysis", "preference specification", "latent decision makers", "criminal event prediction"); AuthorYear="Xue & Brown, 2006"},
    @{ID="S45"; Keywords=@("Yue", "2023", "Investigating the effect", "people on the street", "streetscape physical environment", "street theft crime", "street view images"); AuthorYear="Yue et al., 2023"},
    @{ID="S47"; Keywords=@("Rowan", "Appleby", "McGloin", "2022", "Situating Crime Pattern Theory", "Co-Offending", "Area-Level Convergence Spaces"); AuthorYear="Rowan, Appleby & McGloin, 2022"},
    @{ID="S48"; Keywords=@("Smith", "Brown", "2007", "discrete choice analysis", "spatial attack sites"); AuthorYear="Smith & Brown, 2007"},
    @{ID="S49"; Keywords=@("Cai", "2024", "divergent decisionmaking", "neighborhood context", "physical disorder", "spatial knowledge", "burglars location choice"); AuthorYear="Cai et al., 2024"},
    @{ID="S50"; Keywords=@("Curtis-Ham", "2025", "familiar locations", "similar activities", "contributions of reliable", "relevant knowledge", "offenders crime location choices"); AuthorYear="Curtis-Ham et al., 2025"}
)

Write-Host "Starting Final Comprehensive Verification..." -ForegroundColor Green
Write-Host "Checking $(Get-ChildItem $pdfFolder -Filter "*.pdf" | Measure-Object).Count PDF files against 50 target studies..." -ForegroundColor Yellow

$allPdfs = Get-ChildItem $pdfFolder -Filter "*.pdf" | Where-Object { $_.Name -ne "_.pdf" }
$foundTargets = @()
$possibleTargets = @()
$nonTargets = @()

# Initialize output content
$output = @()
$output += "=" * 80
$output += "FINAL COMPREHENSIVE VERIFICATION REPORT"
$output += "Generated: $(Get-Date)"
$output += "=" * 80
$output += ""

foreach ($pdf in $allPdfs) {
    $filename = $pdf.Name
    $matchFound = $false
    $bestMatch = $null
    $confidence = "NONE"
    
    Write-Host "Checking: $filename" -ForegroundColor Cyan
    
    # Check against each target study
    foreach ($study in $targetStudies) {
        $keywordMatches = 0
        $totalKeywords = $study.Keywords.Count
        
        foreach ($keyword in $study.Keywords) {
            if ($filename -like "*$keyword*") {
                $keywordMatches++
            }
        }
        
        $matchPercentage = ($keywordMatches / $totalKeywords) * 100
        
        # High confidence match (50%+ keywords OR specific author-year patterns)
        if ($matchPercentage -ge 50 -or 
            ($filename -like "*$($study.ID.Substring(1))*" -and $keywordMatches -ge 2) -or
            ($keywordMatches -ge 3)) {
            $bestMatch = $study
            $confidence = "HIGH"
            $matchFound = $true
            break
        }
        # Medium confidence match (25%+ keywords)
        elseif ($matchPercentage -ge 25 -or $keywordMatches -ge 2) {
            if ($bestMatch -eq $null) {
                $bestMatch = $study
                $confidence = "MEDIUM"
                $matchFound = $true
            }
        }
        # Low confidence match (1+ keywords)
        elseif ($keywordMatches -ge 1) {
            if ($bestMatch -eq $null) {
                $bestMatch = $study
                $confidence = "LOW"
                $matchFound = $true
            }
        }
    }
    
    # Categorize file
    if ($confidence -eq "HIGH") {
        $foundTargets += @{
            Filename = $filename
            StudyID = $bestMatch.ID
            AuthorYear = $bestMatch.AuthorYear
            Confidence = $confidence
        }
        Write-Host "  → HIGH CONFIDENCE TARGET: $($bestMatch.ID) - $($bestMatch.AuthorYear)" -ForegroundColor Green
    }
    elseif ($confidence -eq "MEDIUM") {
        $possibleTargets += @{
            Filename = $filename
            StudyID = $bestMatch.ID
            AuthorYear = $bestMatch.AuthorYear
            Confidence = $confidence
        }
        Write-Host "  → MEDIUM CONFIDENCE TARGET: $($bestMatch.ID) - $($bestMatch.AuthorYear)" -ForegroundColor Yellow
    }
    elseif ($confidence -eq "LOW") {
        $possibleTargets += @{
            Filename = $filename
            StudyID = $bestMatch.ID
            AuthorYear = $bestMatch.AuthorYear
            Confidence = $confidence
        }
        Write-Host "  → LOW CONFIDENCE TARGET: $($bestMatch.ID) - $($bestMatch.AuthorYear)" -ForegroundColor DarkYellow
    }
    else {
        # Check if it's obviously not a target (corruption, networks, privacy, etc.)
        $nonTargetKeywords = @("corruption", "network", "privacy", "teaching", "taxonomy", "graffiti", "statistics", "access", "organizational", "injustice")
        $isObviousNonTarget = $false
        foreach ($keyword in $nonTargetKeywords) {
            if ($filename -like "*$keyword*") {
                $isObviousNonTarget = $true
                break
            }
        }
        
        $nonTargets += @{
            Filename = $filename
            IsObviousNonTarget = $isObviousNonTarget
        }
        
        if ($isObviousNonTarget) {
            Write-Host "  → OBVIOUS NON-TARGET (should be moved to ToDelete)" -ForegroundColor Red
        } else {
            Write-Host "  → UNKNOWN - needs manual verification" -ForegroundColor Gray
        }
    }
}

# Generate summary report
$output += "SUMMARY:"
$output += "Total PDFs analyzed: $($allPdfs.Count)"
$output += "High confidence targets found: $($foundTargets.Count)"
$output += "Medium/Low confidence targets: $($possibleTargets.Count)"
$output += "Non-targets/Unknown: $($nonTargets.Count)"
$output += ""

$output += "COMPLETION RATE:"
$totalTargetsFound = ($foundTargets.Count + ($possibleTargets | Where-Object { $_.Confidence -eq "MEDIUM" }).Count)
$completionRate = [math]::Round(($totalTargetsFound / 50) * 100, 1)
$output += "Estimated completion: $completionRate% ($totalTargetsFound out of 50 studies)"
$output += ""

# List high confidence targets
$output += "HIGH CONFIDENCE TARGET STUDIES FOUND ($($foundTargets.Count)):"
$output += "-" * 50
foreach ($target in $foundTargets | Sort-Object StudyID) {
    $output += "$($target.StudyID): $($target.AuthorYear)"
    $output += "   File: $($target.Filename)"
    $output += ""
}

# List medium confidence targets
$mediumTargets = $possibleTargets | Where-Object { $_.Confidence -eq "MEDIUM" }
$output += "MEDIUM CONFIDENCE TARGETS ($($mediumTargets.Count)):"
$output += "-" * 50
foreach ($target in $mediumTargets | Sort-Object StudyID) {
    $output += "$($target.StudyID): $($target.AuthorYear)"
    $output += "   File: $($target.Filename)"
    $output += ""
}

# List obvious non-targets that should be cleaned up
$obviousNonTargets = $nonTargets | Where-Object { $_.IsObviousNonTarget -eq $true }
$output += "OBVIOUS NON-TARGETS TO CLEAN UP ($($obviousNonTargets.Count)):"
$output += "-" * 50
foreach ($nonTarget in $obviousNonTargets) {
    $output += "$($nonTarget.Filename)"
}
$output += ""

# Missing studies analysis
$foundStudyIDs = ($foundTargets + $mediumTargets).StudyID
$missingStudies = $targetStudies | Where-Object { $foundStudyIDs -notcontains $_.ID }

$output += "MISSING STUDIES THAT NEED TO BE FOUND ($($missingStudies.Count)):"
$output += "-" * 50
foreach ($missing in $missingStudies | Sort-Object ID) {
    $output += "$($missing.ID): $($missing.AuthorYear)"
}
$output += ""

# Files needing manual verification
$needVerification = $nonTargets | Where-Object { $_.IsObviousNonTarget -eq $false }
$lowConfidenceTargets = $possibleTargets | Where-Object { $_.Confidence -eq "LOW" }

$output += "FILES NEEDING MANUAL VERIFICATION ($($needVerification.Count + $lowConfidenceTargets.Count)):"
$output += "-" * 50
foreach ($file in $needVerification) {
    $output += "$($file.Filename) - UNKNOWN"
}
foreach ($file in $lowConfidenceTargets) {
    $output += "$($file.Filename) - LOW CONFIDENCE for $($file.StudyID)"
}

# Write to file
$output | Out-File -FilePath $outputFile -Encoding UTF8

Write-Host "`nVerification complete!" -ForegroundColor Green
Write-Host "Results saved to: $outputFile" -ForegroundColor Yellow
Write-Host "`nSUMMARY:" -ForegroundColor White
Write-Host "- High confidence targets: $($foundTargets.Count)" -ForegroundColor Green
Write-Host "- Medium confidence targets: $($mediumTargets.Count)" -ForegroundColor Yellow
Write-Host "- Estimated completion rate: $completionRate%" -ForegroundColor Cyan
Write-Host "- Files to clean up: $($obviousNonTargets.Count)" -ForegroundColor Red
Write-Host "- Missing studies: $($missingStudies.Count)" -ForegroundColor Magenta
