# Final Organization and Verification Script
# This script will:
# 1. Create a FinalStudies folder with all identified target studies
# 2. Search for missing studies using more flexible patterns
# 3. Generate a final verification report

$workspaceRoot = "c:\Users\kukumar\OneDrive - UGent\Job\crimsyndata\-crime-location-choice-studies\snatching work"
$referencesDir = Join-Path $workspaceRoot "References"
$finalStudiesDir = Join-Path $referencesDir "FinalStudies"
$pdfDir = Join-Path $referencesDir "PDFs"
$newPdfDir = Join-Path $referencesDir "new pdf"
$myLibraryFilesDir = Join-Path $newPdfDir "My Library\files"
$reportPath = Join-Path $referencesDir "Analysis_Results\final_verification_report.txt"

# Create directories if they don't exist
if (-not (Test-Path $finalStudiesDir)) {
    New-Item -Path $finalStudiesDir -ItemType Directory -Force | Out-Null
}

# Ensure Analysis_Results directory exists
$analysisDir = Join-Path $referencesDir "Analysis_Results"
if (-not (Test-Path $analysisDir)) {
    New-Item -Path $analysisDir -ItemType Directory -Force | Out-Null
}

# Define all studies with their details based on the table
$targetStudies = @(
    @{ID = "S01"; AuthorYear = "Bernasco et al., 2013"; Title = "Go where the money is: Modeling street robbers' location choices"; SearchPatterns = @("Bernasco", "2013", "Go where the money") },
    @{ID = "S02"; AuthorYear = "Bernasco et al., 2017"; Title = "Do Street Robbery Location Choices Vary Over Time of Day or Day of Week? A Test in Chicago"; SearchPatterns = @("Bernasco", "2017", "Street Robbery Location", "Test in Chicago") },
    @{ID = "S03"; AuthorYear = "Clare et al., 2009"; Title = "Formal evaluation of the impact of barriers and connectors on residential burglars' macro-level offending location choices"; SearchPatterns = @("Clare", "2009", "barriers and connectors", "burglars") },
    @{ID = "S04"; AuthorYear = "Townsley et al., 2015"; Title = "Burglar Target Selection: A Cross-national Comparison (statistical local areas - AU)"; SearchPatterns = @("Townsley", "2015", "Burglar Target Selection", "Cross-national", "Australia", "AU") },
    @{ID = "S05"; AuthorYear = "Townsley et al., 2016"; Title = "Target Selection Models with Preference Variation Between Offenders"; SearchPatterns = @("Townsley", "2016", "Target Selection Models", "Preference Variation") },
    @{ID = "S06"; AuthorYear = "Lammers et al., 2015"; Title = "Biting Once Twice: the Influence of Prior on Subsequent Crime Location Choice"; SearchPatterns = @("Lammers", "2015", "Biting Once Twice", "crime location choice") },
    @{ID = "S07"; AuthorYear = "Lammers, 2017"; Title = "Co-offenders' crime location choice: Do co-offending groups commit crimes in their shared awareness space?"; SearchPatterns = @("Lammers", "2017", "Co-offending groups", "awareness space") },
    @{ID = "S08"; AuthorYear = "Menting et al., 2016"; Title = "Family Matters: Effects of Family Members' Residential Areas on Crime Location Choice"; SearchPatterns = @("Menting", "2016", "FAMILY MATTERS") },
    @{ID = "S09"; AuthorYear = "van Sleeuwen et al., 2018"; Title = "A Time for a Crime: Temporal Aspects of Repeat Offenders' Crime Location Choices"; SearchPatterns = @("Sleeuwen", "2018", "A Time for a Crime") },
    @{ID = "S10"; AuthorYear = "Xiao et al., 2021"; Title = "Burglars blocked by barriers The impact of physical and social barriers on residential burglars target location choices in China"; SearchPatterns = @("Xiao", "2021", "Burglars blocked by barriers", "China") },
    @{ID = "S11"; AuthorYear = "Kuralarasan & Bernasco, 2022"; Title = "Location Choice of Snatching Offenders in Chennai City (Wards)"; SearchPatterns = @("Kuralarasan", "2022", "Location Choice", "Snatching Offenders", "Chennai") },
    @{ID = "S12"; AuthorYear = "Townsley et al., 2015"; Title = "Burglar Target Selection: A Cross-national Comparison (Super Output Areas - UK)"; SearchPatterns = @("Townsley", "2015", "Burglar Target Selection", "UK", "Super Output Areas") },
    @{ID = "S13"; AuthorYear = "Menting, 2018"; Title = "Awareness×Opportunity: Testing Interactions Between Activity Nodes and Criminal Opportunity in Predicting Crime Location Choice"; SearchPatterns = @("Menting", "2018", "AWARENESS x OPPORTUNITY") },
    @{ID = "S14"; AuthorYear = "Song et al., 2019"; Title = "Crime Feeds on Legal Activities: Daily Mobility Flows Help to Explain Thieves' Target Location Choices"; SearchPatterns = @("Song", "2019", "Crime Feeds on Legal Activities") },
    @{ID = "S15"; AuthorYear = "Long et al., 2018"; Title = "Assessing the influence of prior on subsequent street robbery location choices: A case study in ZG City, China"; SearchPatterns = @("Long", "2018", "Assessing the influence of prior", "robbery location") },
    @{ID = "S16"; AuthorYear = "Long et al., 2021"; Title = "Ambient population and surveillance cameras: The guardianship role in street robbers' crime location choice"; SearchPatterns = @("Long", "2021", "Ambient population", "surveillance cameras") },
    @{ID = "S17"; AuthorYear = "Long & Liu, 2021"; Title = "Do Migrant and Native Robbers Target Different Places?"; SearchPatterns = @("Long", "Liu", "2021", "Migrant and Native Robbers") },
    @{ID = "S18"; AuthorYear = "Long & Liu, 2022"; Title = "Do juvenile, young adult, and adult offenders target different places in the Chinese context?"; SearchPatterns = @("Long", "Liu", "2022", "juvenile, young adult", "Chinese context") },
    @{ID = "S19"; AuthorYear = "Curtis-Ham et al., 2022"; Title = "Relationships Between Offenders' Crime Locations and Different Prior Activity Locations as Recorded in Police Data"; SearchPatterns = @("Curtis-Ham", "2022", "Relationships Between Offenders", "Prior Activity") },
    @{ID = "S20"; AuthorYear = "Vandeviver & Bernasco, 2020"; Title = "Location Location Location": Effects of Neighborhood and House Attributes on Burglars' Target Selection'"; SearchPatterns = @("Vandeviver", "Bernasco", "2020", "Location, Location, Location") },
    @{ID = "S21"; AuthorYear = "Menting et al., 2020"; Title = "The Influence of Activity Space and Visiting Frequency on Crime Location Choice: Findings from an Online Self-Report Survey"; SearchPatterns = @("Menting", "2020", "activity space", "visiting frequency") },
    @{ID = "S22"; AuthorYear = "van Sleeuwen et al., 2021"; Title = "Right place, right time? Making crime pattern theory time-specific"; SearchPatterns = @("Sleeuwen", "2021", "Right place, right time") },
    @{ID = "S23"; AuthorYear = "Bernasco & Nieuwbeerta, 2005"; Title = "How do residential burglars select target areas?"; SearchPatterns = @("Bernasco", "Nieuwbeerta", "2005", "residential burglars select target areas") },
    @{ID = "S24"; AuthorYear = "Bernasco, 2006"; Title = "Co-offending and the Choice of Target Areas in Burglary"; SearchPatterns = @("Bernasco", "2006", "Co-offending", "choice of target areas") },
    @{ID = "S25"; AuthorYear = "Townsley et al., 2015"; Title = "Burglar Target Selection: A Cross-national Comparison (NL)"; SearchPatterns = @("Townsley", "2015", "Burglar Target Selection", "Netherlands", "NL") },
    @{ID = "S26"; AuthorYear = "Bernasco & Luykx, 2003"; Title = "Effect Attractiveness Opportunity And Accessibility To Burglars On Residential Burglary Rates Of Urban Neighborhoods"; SearchPatterns = @("Bernasco", "2003", "Attractiveness Opportunity", "Residential Burglary Rates") },
    @{ID = "S27"; AuthorYear = "Bernasco et al., 2015"; Title = "Learning where to offend: Effects of past on future burglary locations"; SearchPatterns = @("Bernasco", "2015", "Learning where to offend") },
    @{ID = "S28"; AuthorYear = "Frith, 2019"; Title = "Modelling taste heterogeneity regarding offence location choices"; SearchPatterns = @("Frith", "2019", "taste heterogeneity", "offence location choices") },
    @{ID = "S29"; AuthorYear = "Hanayama et al., 2018"; Title = "The usefulness of past crime data as an attractiveness index for residential burglars"; SearchPatterns = @("Hanayama", "2018", "usefulness of past crime data") },
    @{ID = "S30"; AuthorYear = "Bernasco, 2019"; Title = "Adolescent offenders' current whereabouts predict locations of their future crime"; SearchPatterns = @("Bernasco", "2019", "Adolescent Offenders", "whereabouts") },
    @{ID = "S31"; AuthorYear = "Bernasco & Jacques, 2015"; Title = "Where Do Dealers Solicit Customers and Sell Them Drugs"; SearchPatterns = @("Bernasco", "Jacques", "2015", "Where Do Dealers Solicit") },
    @{ID = "S32"; AuthorYear = "Bernasco & Block, 2009"; Title = "Where offenders choose to attack: A discrete choice model of robberies in Chicago"; SearchPatterns = @("Bernasco", "Block", "2009", "offenders choose to attack") },
    @{ID = "S33"; AuthorYear = "Chamberlain & Boggess, 2016"; Title = "Relative Difference and Burglary Location: Can Ecological Characteristics of a Burglar's Home Neighborhood Predict Offense Location?"; SearchPatterns = @("Chamberlain", "Boggess", "2016", "Relative difference and burglary location") },
    @{ID = "S34"; AuthorYear = "Bernasco, 2010"; Title = "A Sentimental Journey To Crime : Effects of Residential History on Crime Location Choice"; SearchPatterns = @("Bernasco", "2010", "Sentimental Journey To Crime") },
    @{ID = "S35"; AuthorYear = "Bernasco, 2010"; Title = "Modeling micro-level crime location choice: Application of the discrete choice framework to crime at places"; SearchPatterns = @("Bernasco", "2010", "Modeling Micro-Level Crime Location Choice") },
    @{ID = "S36"; AuthorYear = "Bernasco & Kooistra, 2010"; Title = "Effects of Residential history on Commercial Robbers' Crime Location Choices"; SearchPatterns = @("Bernasco", "Kooistra", "2010", "residential history") },
    @{ID = "S37"; AuthorYear = "Frith et al., 2017"; Title = "Role of the Street Network in Burglars' Spatial Decision-Making"; SearchPatterns = @("Frith", "2017", "ROLE OF THE STREET NETWORK") },
    @{ID = "S38"; AuthorYear = "Baudains et al., 2013"; Title = "Target Choice During Extreme Events: A Discrete Spatial Choice Model of the 2011 London Riots"; SearchPatterns = @("Baudains", "2013", "TARGET CHOICE DURING EXTREME EVENTS") },
    @{ID = "S39"; AuthorYear = "Johnson & Summers, 2015"; Title = "Testing Ecological Theories of Offender Spatial Decision Making Using a Discrete Choice Model"; SearchPatterns = @("Johnson", "Summers", "2015", "Testing Ecological Theories") },
    @{ID = "S40"; AuthorYear = "Vandeviver et al., 2015"; Title = "A discrete spatial choice model of burglary target selection at the house-level"; SearchPatterns = @("Vandeviver", "2015", "discrete spatial choice model", "house-level") },
    @{ID = "S41"; AuthorYear = "Langton & Steenbeek, 2017"; Title = "Residential burglary target selection: An analysis at the property-level using Google Street View"; SearchPatterns = @("Langton", "Steenbeek", "2017", "Residential burglary target selection") },
    @{ID = "S42"; AuthorYear = "Marchment & Gill, 2019"; Title = "Modelling the spatial decision making of terrorists: The discrete choice approach"; SearchPatterns = @("Marchment", "Gill", "2019", "spatial decision making of terrorists") },
    @{ID = "S43"; AuthorYear = "Chamberlain et al., 2022"; Title = "Traveling Alone or Together? Neighborhood Context on Individual and Group Juvenile and Adult Burglary Decisions"; SearchPatterns = @("Chamberlain", "2022", "Traveling Alone or Together") },
    @{ID = "S44"; AuthorYear = "Curtis-Ham et al., 2022"; Title = "The Importance of Importance Sampling: Exploring Methods of Sampling from Alternatives in Discrete Choice Models of Crime Location Choice"; SearchPatterns = @("Curtis-Ham", "2022", "Importance of Importance Sampling") },
    @{ID = "S45"; AuthorYear = "Yue et al., 2023"; Title = "Investigating the effect of people on the street and streetscape physical environment on the location choice of street theft crime offenders using street view images and a discrete spatial choice model"; SearchPatterns = @("Yue", "2023", "effect of people on the street", "street theft crime") },
    @{ID = "S46"; AuthorYear = "Kuralarasan et al, 2024"; Title = "Graffiti Writers Choose Locations That Optimize Exposure"; SearchPatterns = @("Kuralarasan", "2024", "Graffiti Writers") },
    @{ID = "S47"; AuthorYear = "Rowan et al., 2022"; Title = "Situating Crime Pattern Theory Into The Explanation Of Co-Offending: Considering Area-Level Convergence Spaces"; SearchPatterns = @("Rowan", "2022", "Situating Crime Pattern Theory", "Co-Offending") },
    @{ID = "S48"; AuthorYear = "Smith & Brown, 2007"; Title = "Discrete choice analysis of spatial attack sites"; SearchPatterns = @("Smith", "Brown", "2007", "Discrete choice analysis", "spatial attack sites") },
    @{ID = "S49"; AuthorYear = "Cai et al., 2024"; Title = "Divergent decisionmaking in context neighborhood context shapes effects of physical disorder and spatial knowledge on burglars location choice"; SearchPatterns = @("Cai", "2024", "divergent decisionmaking", "context") },
    @{ID = "S50"; AuthorYear = "Curtis-Ham et al., 2025"; Title = "Familiar locations and similar activities examining the contributions of reliable and relevant knowledge in offenders crime location choices"; SearchPatterns = @("Curtis-Ham", "2025", "familiar locations", "similar activities") }
)

# Enhanced flexible search patterns for more thorough matching
$alternativeSearchPatterns = @{
    "S02" = @("Bernasco", "2017", "Day of Week", "Chicago");
    "S03" = @("Clare", "evaluation", "barriers", "burglars");
    "S04" = @("Townsley", "Cross-national", "Australia");
    "S06" = @("Lammers", "Biting", "crime location");
    "S07" = @("Lammers", "co-offending", "shared", "space");
    "S10" = @("Xiao", "barriers", "China");
    "S12" = @("Townsley", "Cross-national", "UK");
    "S15" = @("Long", "prior", "robbery", "China");
    "S16" = @("Long", "population", "cameras", "guardianship");
    "S18" = @("Long", "juvenile", "adult", "Chinese");
    "S19" = @("Curtis-Ham", "Crime Locations", "Prior Activity");
    "S25" = @("Townsley", "Cross-national", "Netherlands");
    "S26" = @("Bernasco", "2003", "Attractiveness", "Burglary");
    "S36" = @("Bernasco", "2010", "Commercial Robbers");
    "S45" = @("Yue", "street view", "theft");
    "S49" = @("Cai", "neighborhood", "burglars")
}

# Function to search for PDFs using search patterns and create a more flexible match
function Search-TargetPDFs {
    param (
        [Parameter(Mandatory = $true)]
        [string]$StudyID,
        
        [Parameter(Mandatory = $true)]
        [string[]]$SearchPatterns
    )

    # Directories to search
    $searchDirectories = @(
        $pdfDir,
        $newPdfDir,
        (Join-Path $newPdfDir "My Library\files")
    )
    
    # Search for PDFs matching search patterns
    $matchingPDFs = @()
    
    foreach ($dir in $searchDirectories) {
        if (Test-Path $dir) {
            $pdfs = Get-ChildItem -Path $dir -Filter "*.pdf" -Recurse
            
            foreach ($pdf in $pdfs) {
                $fileName = $pdf.Name
                
                # Check if all search patterns are in the filename (case-insensitive)
                $matchAll = $true
                foreach ($pattern in $SearchPatterns) {
                    if ($fileName -notmatch [regex]::Escape($pattern)) {
                        $matchAll = $false
                        break
                    }
                }
                
                if ($matchAll) {
                    $matchingPDFs += $pdf.FullName
                }
            }
        }
    }

    # If no matches, try alternative patterns if available
    if ($matchingPDFs.Count -eq 0 -and $alternativeSearchPatterns.ContainsKey($StudyID)) {
        $altPatterns = $alternativeSearchPatterns[$StudyID]
        foreach ($dir in $searchDirectories) {
            if (Test-Path $dir) {
                $pdfs = Get-ChildItem -Path $dir -Filter "*.pdf" -Recurse
                
                foreach ($pdf in $pdfs) {
                    $fileName = $pdf.Name
                    
                    # Check if all alternative search patterns are in the filename (case-insensitive)
                    $matchAll = $true
                    foreach ($pattern in $altPatterns) {
                        if ($fileName -notmatch [regex]::Escape($pattern)) {
                            $matchAll = $false
                            break
                        }
                    }
                    
                    if ($matchAll) {
                        $matchingPDFs += $pdf.FullName
                    }
                }
            }
        }
    }
    
    # More flexible search as a last resort
    if ($matchingPDFs.Count -eq 0) {
        # Try just author and year for more flexibility
        $authorYear = $SearchPatterns | Where-Object { $_ -match "\d{4}" } | Select-Object -First 1
        $author = $SearchPatterns | Where-Object { $_ -notmatch "\d{4}" } | Select-Object -First 1
        
        if ($authorYear -and $author) {
            foreach ($dir in $searchDirectories) {
                if (Test-Path $dir) {
                    $pdfs = Get-ChildItem -Path $dir -Filter "*.pdf" -Recurse
                    
                    foreach ($pdf in $pdfs) {
                        $fileName = $pdf.Name
                        
                        if ($fileName -match [regex]::Escape($author) -and $fileName -match [regex]::Escape($authorYear)) {
                            $matchingPDFs += $pdf.FullName
                        }
                    }
                }
            }
        }
    }
    
    # Even more flexible search as a last resort
    if ($matchingPDFs.Count -eq 0) {
        $year = $SearchPatterns | Where-Object { $_ -match "\d{4}" } | Select-Object -First 1
        
        if ($year) {
            foreach ($dir in $searchDirectories) {
                if (Test-Path $dir) {
                    $pdfs = Get-ChildItem -Path $dir -Filter "*.pdf" -Recurse
                    
                    foreach ($pdf in $pdfs) {
                        $fileName = $pdf.Name
                        
                        # Get only the first author's last name for maximum flexibility
                        $firstAuthor = $SearchPatterns | Where-Object { $_ -notmatch "\d{4}" } | Select-Object -First 1
                        if ($firstAuthor -and $fileName -match [regex]::Escape($firstAuthor) -and $fileName -match [regex]::Escape($year)) {
                            $matchingPDFs += $pdf.FullName
                        }
                    }
                }
            }
        }
    }
    
    return $matchingPDFs
}

# Function to copy PDF to final destination
function Copy-PDFToFinalDestination {
    param (
        [string]$SourcePDF,
        [string]$StudyID
    )
    
    $destinationDir = Join-Path $finalStudiesDir $StudyID
    if (-not (Test-Path $destinationDir)) {
        New-Item -Path $destinationDir -ItemType Directory -Force | Out-Null
    }
    
    $destinationFile = Join-Path $destinationDir (Split-Path $SourcePDF -Leaf)
    
    # Only copy if it doesn't exist or is different
    if (-not (Test-Path $destinationFile) -or 
        (Get-FileHash $SourcePDF).Hash -ne (Get-FileHash $destinationFile).Hash) {
        Copy-Item -Path $SourcePDF -Destination $destinationFile -Force
        return $destinationFile
    } else {
        return $destinationFile
    }
}

# Initialize report content
$reportContent = @"
# FINAL VERIFICATION REPORT

Created on $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

## SUMMARY

"@

$foundCount = 0
$missingCount = 0
$foundStudies = @()
$missingStudies = @()

# Process each target study
foreach ($study in $targetStudies) {
    $studyID = $study.ID
    $matchingPDFs = Search-TargetPDFs -StudyID $studyID -SearchPatterns $study.SearchPatterns
    
    if ($matchingPDFs.Count -gt 0) {
        $foundCount++
        $foundStudies += $studyID
        
        # Get the first matching PDF and copy it
        $primaryPDF = $matchingPDFs[0]
        $destinationFile = Copy-PDFToFinalDestination -SourcePDF $primaryPDF -StudyID $studyID
        
        # Record the result for the study
        $reportContent += @"

### $studyID - $($study.Title)
* Status: FOUND
* Author(s): $($study.AuthorYear)
* Source: $primaryPDF
* Destination: $destinationFile

"@
    } else {
        $missingCount++
        $missingStudies += $studyID
        
        # Record the missing study
        $reportContent += @"

### $studyID - $($study.Title)
* Status: MISSING
* Author(s): $($study.AuthorYear)
* Search Patterns: $($study.SearchPatterns -join ", ")
* Alternative Patterns: $($alternativeSearchPatterns[$studyID] -join ", ")

"@
    }
}

# Finalize report content
$totalStudies = $targetStudies.Count
$percentFound = [math]::Round(($foundCount / $totalStudies) * 100, 1)

$reportContent = $reportContent.Replace("## SUMMARY", @"
## SUMMARY

Total studies: $totalStudies
Studies found: $foundCount ($percentFound percent)
Studies missing: $missingCount

## FOUND STUDIES ($foundCount)
$($foundStudies -join ", ")

## MISSING STUDIES ($missingCount)
$($missingStudies -join ", ")

## DETAILED RESULTS
"@)

# Save the report
$reportContent | Out-File -FilePath $reportPath -Force

# Create a cleanup script for irrelevant PDFs
$cleanupScriptPath = Join-Path $referencesDir "final_cleanup_irrelevant_pdfs.ps1"
$cleanupScriptContent = @"
# Final Cleanup of Irrelevant PDFs
# This script moves all PDFs that are not part of the target studies to a ToDelete folder

`$workspaceRoot = "c:\Users\kukumar\OneDrive - UGent\Job\crimsyndata\-crime-location-choice-studies\snatching work"
`$referencesDir = Join-Path `$workspaceRoot "References"
`$finalStudiesDir = Join-Path `$referencesDir "FinalStudies"
`$pdfDir = Join-Path `$referencesDir "PDFs"
`$toDeleteDir = Join-Path `$pdfDir "ToDelete"
`$reportPath = Join-Path `$referencesDir "Analysis_Results\final_cleanup_report.txt"

# Create ToDelete directory if it doesn't exist
if (-not (Test-Path `$toDeleteDir)) {
    New-Item -Path `$toDeleteDir -ItemType Directory -Force | Out-Null
}

# Get all PDFs in the FinalStudies directory
`$targetPDFs = Get-ChildItem -Path `$finalStudiesDir -Filter "*.pdf" -Recurse | 
    ForEach-Object { Split-Path `$_.Name -Leaf }

# Initialize report content
`$reportContent = @"
# FINAL CLEANUP REPORT

Created on `$(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

## SUMMARY
"@

# Create Analysis_Results directory if it doesn't exist
if (-not (Test-Path (Join-Path `$referencesDir "Analysis_Results"))) {
    New-Item -Path (Join-Path `$referencesDir "Analysis_Results") -ItemType Directory -Force | Out-Null
}

# Process PDFs in the main PDFs directory
`$movedCount = 0
`$relevantCount = 0

if (Test-Path `$pdfDir) {
    `$pdfs = Get-ChildItem -Path `$pdfDir -Filter "*.pdf" -File
    
    foreach (`$pdf in `$pdfs) {
        `$isTarget = `$false
        
        foreach (`$targetPDF in `$targetPDFs) {
            if (`$pdf.Name -eq `$targetPDF) {
                `$isTarget = `$true
                break
            }
        }
        
        if (-not `$isTarget) {
            # This is not a target PDF, move it to ToDelete
            Move-Item -Path `$pdf.FullName -Destination (Join-Path `$toDeleteDir `$pdf.Name) -Force
            `$movedCount++
            `$reportContent += "`nMoved to ToDelete: `$(`$pdf.Name)"
        } else {
            `$relevantCount++
            `$reportContent += "`nKept (relevant): `$(`$pdf.Name)"
        }
    }
}

# Finalize report content
`$reportContent = `$reportContent.Replace("## SUMMARY", @"
## SUMMARY

Total PDFs processed in main PDFs directory: `$(`$movedCount + `$relevantCount)
Relevant PDFs kept: `$relevantCount
Irrelevant PDFs moved to ToDelete: `$movedCount
"@)

# Save the report
`$reportContent | Out-File -FilePath `$reportPath -Force

Write-Host "Cleanup complete. See `$reportPath for details."
"@

# Save the cleanup script
$cleanupScriptContent | Out-File -FilePath $cleanupScriptPath -Force

Write-Host "Organization and verification process complete."
Write-Host "See $reportPath for detailed results."
Write-Host "Running cleanup script to move irrelevant PDFs to ToDelete folder..."

# Run the cleanup script
& $cleanupScriptPath

Write-Host "All operations completed."
