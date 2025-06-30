# Simple Final Organization Script
# This script will:
# 1. Create a FinalStudies folder with all identified target studies
# 2. Search for target studies using flexible patterns
# 3. Generate a final verification report

$workspaceRoot = "c:\Users\kukumar\OneDrive - UGent\Job\crimsyndata\-crime-location-choice-studies\snatching work"
$referencesDir = Join-Path $workspaceRoot "References"
$finalStudiesDir = Join-Path $referencesDir "FinalOrganizedStudies"
$pdfDir = Join-Path $referencesDir "PDFs"
$newPdfDir = Join-Path $referencesDir "new pdf"
$myLibraryFilesDir = Join-Path $newPdfDir "My Library\files"
$analysisDir = Join-Path $referencesDir "Analysis_Results"
$reportPath = Join-Path $analysisDir "final_report.txt"
$toDeleteDir = Join-Path $pdfDir "ToDelete"

# Create directories if they don't exist
if (-not (Test-Path $finalStudiesDir)) {
    New-Item -Path $finalStudiesDir -ItemType Directory -Force
}

if (-not (Test-Path $analysisDir)) {
    New-Item -Path $analysisDir -ItemType Directory -Force
}

if (-not (Test-Path $toDeleteDir)) {
    New-Item -Path $toDeleteDir -ItemType Directory -Force
}

# Define all studies with their details based on the table
$targetStudies = @(
    @{ID = "S01"; AuthorYear = "Bernasco et al., 2013"; Title = "Go where the money is: Modeling street robbers' location choices"; Keywords = @("Bernasco", "2013", "Go where") },
    @{ID = "S02"; AuthorYear = "Bernasco et al., 2017"; Title = "Do Street Robbery Location Choices Vary Over Time of Day or Day of Week? A Test in Chicago"; Keywords = @("Bernasco", "2017", "Chicago") },
    @{ID = "S03"; AuthorYear = "Clare et al., 2009"; Title = "Formal evaluation of the impact of barriers and connectors on residential burglars' macro-level offending location choices"; Keywords = @("Clare", "2009", "barriers") },
    @{ID = "S04"; AuthorYear = "Townsley et al., 2015"; Title = "Burglar Target Selection: A Cross-national Comparison (statistical local areas - AU)"; Keywords = @("Townsley", "2015", "Australia") },
    @{ID = "S05"; AuthorYear = "Townsley et al., 2016"; Title = "Target Selection Models with Preference Variation Between Offenders"; Keywords = @("Townsley", "2016", "Target Selection") },
    @{ID = "S06"; AuthorYear = "Lammers et al., 2015"; Title = "Biting Once Twice: the Influence of Prior on Subsequent Crime Location Choice"; Keywords = @("Lammers", "2015", "Biting") },
    @{ID = "S07"; AuthorYear = "Lammers, 2017"; Title = "Co-offenders' crime location choice: Do co-offending groups commit crimes in their shared awareness space?"; Keywords = @("Lammers", "2017", "awareness") },
    @{ID = "S08"; AuthorYear = "Menting et al., 2016"; Title = "Family Matters: Effects of Family Members' Residential Areas on Crime Location Choice"; Keywords = @("Menting", "2016", "FAMILY") },
    @{ID = "S09"; AuthorYear = "van Sleeuwen et al., 2018"; Title = "A Time for a Crime: Temporal Aspects of Repeat Offenders' Crime Location Choices"; Keywords = @("Sleeuwen", "2018", "Time") },
    @{ID = "S10"; AuthorYear = "Xiao et al., 2021"; Title = "Burglars blocked by barriers The impact of physical and social barriers on residential burglars target location choices in China"; Keywords = @("Xiao", "2021", "China") },
    @{ID = "S11"; AuthorYear = "Kuralarasan & Bernasco, 2022"; Title = "Location Choice of Snatching Offenders in Chennai City (Wards)"; Keywords = @("Kuralarasan", "2022", "Chennai") },
    @{ID = "S12"; AuthorYear = "Townsley et al., 2015"; Title = "Burglar Target Selection: A Cross-national Comparison (Super Output Areas - UK)"; Keywords = @("Townsley", "2015", "UK") },
    @{ID = "S13"; AuthorYear = "Menting, 2018"; Title = "Awareness×Opportunity: Testing Interactions Between Activity Nodes and Criminal Opportunity in Predicting Crime Location Choice"; Keywords = @("Menting", "2018", "AWARENESS") },
    @{ID = "S14"; AuthorYear = "Song et al., 2019"; Title = "Crime Feeds on Legal Activities: Daily Mobility Flows Help to Explain Thieves' Target Location Choices"; Keywords = @("Song", "2019", "Feeds") },
    @{ID = "S15"; AuthorYear = "Long et al., 2018"; Title = "Assessing the influence of prior on subsequent street robbery location choices: A case study in ZG City, China"; Keywords = @("Long", "2018", "robbery") },
    @{ID = "S16"; AuthorYear = "Long et al., 2021"; Title = "Ambient population and surveillance cameras: The guardianship role in street robbers' crime location choice"; Keywords = @("Long", "2021", "cameras") },
    @{ID = "S17"; AuthorYear = "Long & Liu, 2021"; Title = "Do Migrant and Native Robbers Target Different Places?"; Keywords = @("Long", "Liu", "2021", "Migrant") },
    @{ID = "S18"; AuthorYear = "Long & Liu, 2022"; Title = "Do juvenile, young adult, and adult offenders target different places in the Chinese context?"; Keywords = @("Long", "Liu", "2022", "juvenile") },
    @{ID = "S19"; AuthorYear = "Curtis-Ham et al., 2022"; Title = "Relationships Between Offenders' Crime Locations and Different Prior Activity Locations as Recorded in Police Data"; Keywords = @("Curtis-Ham", "2022", "Prior Activity") },
    @{ID = "S20"; AuthorYear = "Vandeviver & Bernasco, 2020"; Title = "Location Location Location: Effects of Neighborhood and House Attributes on Burglars' Target Selection"; Keywords = @("Vandeviver", "Bernasco", "2020") },
    @{ID = "S21"; AuthorYear = "Menting et al., 2020"; Title = "The Influence of Activity Space and Visiting Frequency on Crime Location Choice: Findings from an Online Self-Report Survey"; Keywords = @("Menting", "2020", "activity space") },
    @{ID = "S22"; AuthorYear = "van Sleeuwen et al., 2021"; Title = "Right place, right time? Making crime pattern theory time-specific"; Keywords = @("Sleeuwen", "2021", "Right place") },
    @{ID = "S23"; AuthorYear = "Bernasco & Nieuwbeerta, 2005"; Title = "How do residential burglars select target areas?"; Keywords = @("Bernasco", "Nieuwbeerta", "2005") },
    @{ID = "S24"; AuthorYear = "Bernasco, 2006"; Title = "Co-offending and the Choice of Target Areas in Burglary"; Keywords = @("Bernasco", "2006", "Co-offending") },
    @{ID = "S25"; AuthorYear = "Townsley et al., 2015"; Title = "Burglar Target Selection: A Cross-national Comparison (NL)"; Keywords = @("Townsley", "2015", "Netherlands") },
    @{ID = "S26"; AuthorYear = "Bernasco & Luykx, 2003"; Title = "Effect Attractiveness Opportunity And Accessibility To Burglars On Residential Burglary Rates Of Urban Neighborhoods"; Keywords = @("Bernasco", "2003", "Attractiveness") },
    @{ID = "S27"; AuthorYear = "Bernasco et al., 2015"; Title = "Learning where to offend: Effects of past on future burglary locations"; Keywords = @("Bernasco", "2015", "Learning") },
    @{ID = "S28"; AuthorYear = "Frith, 2019"; Title = "Modelling taste heterogeneity regarding offence location choices"; Keywords = @("Frith", "2019", "heterogeneity") },
    @{ID = "S29"; AuthorYear = "Hanayama et al., 2018"; Title = "The usefulness of past crime data as an attractiveness index for residential burglars"; Keywords = @("Hanayama", "2018", "usefulness") },
    @{ID = "S30"; AuthorYear = "Bernasco, 2019"; Title = "Adolescent offenders' current whereabouts predict locations of their future crime"; Keywords = @("Bernasco", "2019", "Adolescent") },
    @{ID = "S31"; AuthorYear = "Bernasco & Jacques, 2015"; Title = "Where Do Dealers Solicit Customers and Sell Them Drugs"; Keywords = @("Bernasco", "Jacques", "2015", "Dealers") },
    @{ID = "S32"; AuthorYear = "Bernasco & Block, 2009"; Title = "Where offenders choose to attack: A discrete choice model of robberies in Chicago"; Keywords = @("Bernasco", "Block", "2009") },
    @{ID = "S33"; AuthorYear = "Chamberlain & Boggess, 2016"; Title = "Relative Difference and Burglary Location: Can Ecological Characteristics of a Burglar's Home Neighborhood Predict Offense Location?"; Keywords = @("Chamberlain", "Boggess", "2016") },
    @{ID = "S34"; AuthorYear = "Bernasco, 2010"; Title = "A Sentimental Journey To Crime : Effects of Residential History on Crime Location Choice"; Keywords = @("Bernasco", "2010", "Sentimental") },
    @{ID = "S35"; AuthorYear = "Bernasco, 2010"; Title = "Modeling micro-level crime location choice: Application of the discrete choice framework to crime at places"; Keywords = @("Bernasco", "2010", "Micro-Level") },
    @{ID = "S36"; AuthorYear = "Bernasco & Kooistra, 2010"; Title = "Effects of Residential history on Commercial Robbers' Crime Location Choices"; Keywords = @("Bernasco", "Kooistra", "2010") },
    @{ID = "S37"; AuthorYear = "Frith et al., 2017"; Title = "Role of the Street Network in Burglars' Spatial Decision-Making"; Keywords = @("Frith", "2017", "STREET NETWORK") },
    @{ID = "S38"; AuthorYear = "Baudains et al., 2013"; Title = "Target Choice During Extreme Events: A Discrete Spatial Choice Model of the 2011 London Riots"; Keywords = @("Baudains", "2013", "London Riots") },
    @{ID = "S39"; AuthorYear = "Johnson & Summers, 2015"; Title = "Testing Ecological Theories of Offender Spatial Decision Making Using a Discrete Choice Model"; Keywords = @("Johnson", "Summers", "2015") },
    @{ID = "S40"; AuthorYear = "Vandeviver et al., 2015"; Title = "A discrete spatial choice model of burglary target selection at the house-level"; Keywords = @("Vandeviver", "2015", "house-level") },
    @{ID = "S41"; AuthorYear = "Langton & Steenbeek, 2017"; Title = "Residential burglary target selection: An analysis at the property-level using Google Street View"; Keywords = @("Langton", "Steenbeek", "2017") },
    @{ID = "S42"; AuthorYear = "Marchment & Gill, 2019"; Title = "Modelling the spatial decision making of terrorists: The discrete choice approach"; Keywords = @("Marchment", "Gill", "2019", "terrorists") },
    @{ID = "S43"; AuthorYear = "Chamberlain et al., 2022"; Title = "Traveling Alone or Together? Neighborhood Context on Individual and Group Juvenile and Adult Burglary Decisions"; Keywords = @("Chamberlain", "2022", "Traveling") },
    @{ID = "S44"; AuthorYear = "Curtis-Ham et al., 2022"; Title = "The Importance of Importance Sampling: Exploring Methods of Sampling from Alternatives in Discrete Choice Models of Crime Location Choice"; Keywords = @("Curtis-Ham", "2022", "Sampling") },
    @{ID = "S45"; AuthorYear = "Yue et al., 2023"; Title = "Investigating the effect of people on the street and streetscape physical environment on the location choice of street theft crime offenders using street view images and a discrete spatial choice model"; Keywords = @("Yue", "2023", "street view") },
    @{ID = "S46"; AuthorYear = "Kuralarasan et al, 2024"; Title = "Graffiti Writers Choose Locations That Optimize Exposure"; Keywords = @("Kuralarasan", "2024", "Graffiti") },
    @{ID = "S47"; AuthorYear = "Rowan et al., 2022"; Title = "Situating Crime Pattern Theory Into The Explanation Of Co-Offending: Considering Area-Level Convergence Spaces"; Keywords = @("Rowan", "2022", "Pattern Theory") },
    @{ID = "S48"; AuthorYear = "Smith & Brown, 2007"; Title = "Discrete choice analysis of spatial attack sites"; Keywords = @("Smith", "Brown", "2007", "attack sites") },
    @{ID = "S49"; AuthorYear = "Cai et al., 2024"; Title = "Divergent decisionmaking in context neighborhood context shapes effects of physical disorder and spatial knowledge on burglars location choice"; Keywords = @("Cai", "2024", "divergent") },
    @{ID = "S50"; AuthorYear = "Curtis-Ham et al., 2025"; Title = "Familiar locations and similar activities examining the contributions of reliable and relevant knowledge in offenders crime location choices"; Keywords = @("Curtis-Ham", "2025", "familiar") }
)

# Function to search for PDFs using keywords
function Find-StudyPDFs {
    param (
        [Parameter(Mandatory = $true)]
        [string]$StudyID,
        
        [Parameter(Mandatory = $true)]
        [string[]]$Keywords
    )

    # Directories to search
    $searchDirectories = @(
        $pdfDir,
        $newPdfDir,
        (Join-Path $newPdfDir "My Library\files")
    )
    
    $matchingPDFs = @()
    
    foreach ($dir in $searchDirectories) {
        if (Test-Path $dir) {
            $pdfs = Get-ChildItem -Path $dir -Filter "*.pdf" -Recurse
            
            foreach ($pdf in $pdfs) {
                $fileName = $pdf.Name
                
                # Check if all keywords are in the filename
                $matchAll = $true
                foreach ($keyword in $Keywords) {
                    if ($fileName -notmatch [regex]::Escape($keyword)) {
                        $matchAll = $false
                        break
                    }
                }
                
                if ($matchAll) {
                    $matchingPDFs += $pdf.FullName
                }
                # Try just checking author and year for more flexibility
                elseif (($Keywords.Count -gt 1) -and ($fileName -match [regex]::Escape($Keywords[0])) -and ($fileName -match [regex]::Escape($Keywords[1]))) {
                    $matchingPDFs += $pdf.FullName
                }
            }
        }
    }
    
    return $matchingPDFs
}

# Function to copy PDF to the FinalStudies folder
function Copy-ToFinalFolder {
    param (
        [Parameter(Mandatory = $true)]
        [string]$SourcePDF,
        
        [Parameter(Mandatory = $true)]
        [string]$StudyID
    )
    
    $studyDir = Join-Path $finalStudiesDir $StudyID
    if (-not (Test-Path $studyDir)) {
        New-Item -Path $studyDir -ItemType Directory -Force | Out-Null
    }
    
    $destinationFile = Join-Path $studyDir (Split-Path $SourcePDF -Leaf)
    Copy-Item -Path $SourcePDF -Destination $destinationFile -Force
    
    return $destinationFile
}

# Initialize summary counts
$foundCount = 0
$missingCount = 0

# Arrays to store results
$foundStudies = @()
$missingStudies = @()
$studyResults = @()

# Process each target study
foreach ($study in $targetStudies) {
    $studyID = $study.ID
    $matchingPDFs = Find-StudyPDFs -StudyID $studyID -Keywords $study.Keywords
    
    if ($matchingPDFs.Count -gt 0) {
        $foundCount++
        $foundStudies += $studyID
        
        # Copy the first matching PDF to the final folder
        $destination = Copy-ToFinalFolder -SourcePDF $matchingPDFs[0] -StudyID $studyID
        
        # Record result
        $studyResults += [PSCustomObject]@{
            StudyID = $studyID
            Title = $study.Title
            Author = $study.AuthorYear
            Status = "FOUND"
            Source = $matchingPDFs[0]
            Destination = $destination
            AdditionalMatches = $matchingPDFs.Count - 1
        }
    } else {
        $missingCount++
        $missingStudies += $studyID
        
        # Record result
        $studyResults += [PSCustomObject]@{
            StudyID = $studyID
            Title = $study.Title
            Author = $study.AuthorYear
            Status = "MISSING"
            Source = "N/A"
            Destination = "N/A"
            AdditionalMatches = 0
        }
    }
}

# Generate report
$report = "# FINAL ORGANIZATION AND VERIFICATION REPORT`r`n`r`n"
$report += "Generated on: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')`r`n`r`n"

# Summary section
$percentFound = [math]::Round(($foundCount / $targetStudies.Count) * 100, 1)
$report += "## SUMMARY`r`n`r`n"
$report += "Total studies: $($targetStudies.Count)`r`n"
$report += "Studies found: $foundCount ($percentFound%)`r`n"
$report += "Studies missing: $missingCount`r`n`r`n"

# Found studies
$report += "## FOUND STUDIES ($foundCount)`r`n`r`n"
$report += ($foundStudies | ForEach-Object { "$_ " }) -join ", "
$report += "`r`n`r`n"

# Missing studies
$report += "## MISSING STUDIES ($missingCount)`r`n`r`n"
$report += ($missingStudies | ForEach-Object { "$_ " }) -join ", "
$report += "`r`n`r`n"

# Detailed results
$report += "## DETAILED RESULTS`r`n`r`n"

foreach ($result in $studyResults) {
    $report += "### $($result.StudyID) - $($result.Title)`r`n"
    $report += "* **Status**: $($result.Status)`r`n"
    $report += "* **Author(s)**: $($result.Author)`r`n"
    
    if ($result.Status -eq "FOUND") {
        $report += "* **Source**: $($result.Source)`r`n"
        $report += "* **Destination**: $($result.Destination)`r`n"
        if ($result.AdditionalMatches -gt 0) {
            $report += "* **Additional matches found**: $($result.AdditionalMatches)`r`n"
        }
    }
    
    $report += "`r`n"
}

# Save the report
$report | Out-File -FilePath $reportPath -Force

# Create a cleanup script to move irrelevant PDFs to ToDelete
$cleanupScript = @"
# Cleanup irrelevant PDFs
`$pdfDir = "$pdfDir"
`$toDeleteDir = "$toDeleteDir"
`$finalStudiesDir = "$finalStudiesDir"

# Ensure ToDelete directory exists
if (-not (Test-Path `$toDeleteDir)) {
    New-Item -Path `$toDeleteDir -ItemType Directory -Force | Out-Null
}

# Get all PDFs in the final organized folder (these are our target studies)
`$targetPDFs = Get-ChildItem -Path `$finalStudiesDir -Filter "*.pdf" -Recurse | 
    ForEach-Object { `$_.Name }

# Move irrelevant PDFs to ToDelete
if (Test-Path `$pdfDir) {
    `$pdfs = Get-ChildItem -Path `$pdfDir -Filter "*.pdf" -File | Where-Object { `$_.FullName -notlike "*`$toDeleteDir*" }
    
    foreach (`$pdf in `$pdfs) {
        if (`$targetPDFs -notcontains `$pdf.Name) {
            # Not a target PDF, move it to ToDelete
            Move-Item -Path `$pdf.FullName -Destination (Join-Path `$toDeleteDir `$pdf.Name) -Force
            Write-Host "Moved to ToDelete: `$(`$pdf.Name)"
        }
    }
}

Write-Host "Cleanup complete. Irrelevant PDFs have been moved to: `$toDeleteDir"
"@

$cleanupScriptPath = Join-Path $referencesDir "cleanup_irrelevant_pdfs.ps1"
$cleanupScript | Out-File -FilePath $cleanupScriptPath -Force

# Run the cleanup script
Write-Host "Organization complete. See report at: $reportPath"
Write-Host "Running cleanup script to move irrelevant PDFs to ToDelete folder..."

# Run the cleanup script
& $cleanupScriptPath

Write-Host "Process completed."
