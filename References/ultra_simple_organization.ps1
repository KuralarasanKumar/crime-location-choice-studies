# Ultra Simple Organization Script
# This script uses minimal PowerShell features to avoid syntax issues

$workspaceRoot = "c:\Users\kukumar\OneDrive - UGent\Job\crimsyndata\-crime-location-choice-studies\snatching work"
$referencesDir = Join-Path $workspaceRoot "References"
$finalDir = Join-Path $referencesDir "UltraSimpleOrganization"
$pdfDir = Join-Path $referencesDir "PDFs"
$newPdfDir = Join-Path $referencesDir "new pdf"
$analysisDir = Join-Path $referencesDir "Analysis_Results"
$reportFile = Join-Path $analysisDir "ultra_simple_report.txt"

# Create necessary directories
if (-not (Test-Path $finalDir)) {
    New-Item -Path $finalDir -ItemType Directory -Force | Out-Null
}

if (-not (Test-Path $analysisDir)) {
    New-Item -Path $analysisDir -ItemType Directory -Force | Out-Null
}

# Simple array of study definitions with ID, author, year, and key terms to search for
$studies = @(
    @{ID="S01"; Author="Bernasco"; Year="2013"; Terms=@("Go where", "money", "robbers")},
    @{ID="S02"; Author="Bernasco"; Year="2017"; Terms=@("Day of Week", "Chicago", "Street Robbery")},
    @{ID="S03"; Author="Clare"; Year="2009"; Terms=@("barriers", "connectors", "burglars")},
    @{ID="S04"; Author="Townsley"; Year="2015"; Terms=@("Burglar Target", "Australia", "Cross-national")},
    @{ID="S05"; Author="Townsley"; Year="2016"; Terms=@("Target Selection", "Preference", "Variation")},
    @{ID="S06"; Author="Lammers"; Year="2015"; Terms=@("Biting", "Once", "Twice")},
    @{ID="S07"; Author="Lammers"; Year="2017"; Terms=@("Co-offending", "groups", "shared")},
    @{ID="S08"; Author="Menting"; Year="2016"; Terms=@("Family", "Matters", "Members")},
    @{ID="S09"; Author="Sleeuwen"; Year="2018"; Terms=@("Time", "Crime", "Temporal")},
    @{ID="S10"; Author="Xiao"; Year="2021"; Terms=@("Burglars", "barriers", "China")},
    @{ID="S11"; Author="Kuralarasan"; Year="2022"; Terms=@("Snatching", "Chennai", "Location Choice")},
    @{ID="S12"; Author="Townsley"; Year="2015"; Terms=@("UK", "Super Output", "Cross-national")},
    @{ID="S13"; Author="Menting"; Year="2018"; Terms=@("Awareness", "Opportunity", "Testing", "Interactions")},
    @{ID="S14"; Author="Song"; Year="2019"; Terms=@("Crime Feeds", "Legal Activities", "Mobility")},
    @{ID="S15"; Author="Long"; Year="2018"; Terms=@("influence", "prior", "robbery")},
    @{ID="S16"; Author="Long"; Year="2021"; Terms=@("Ambient population", "surveillance cameras", "guardianship")},
    @{ID="S17"; Author="Long"; Year="2021"; Terms=@("Migrant", "Native", "Robbers")},
    @{ID="S18"; Author="Long"; Year="2022"; Terms=@("juvenile", "young", "adult")},
    @{ID="S19"; Author="Curtis-Ham"; Year="2022"; Terms=@("Relationships", "Offenders", "Prior Activity")},
    @{ID="S20"; Author="Vandeviver"; Year="2020"; Terms=@("Location, Location", "Neighborhood", "House Attributes")},
    @{ID="S21"; Author="Menting"; Year="2020"; Terms=@("Activity Space", "Visiting Frequency", "Self-Report")},
    @{ID="S22"; Author="Sleeuwen"; Year="2021"; Terms=@("Right place", "right time", "pattern theory")},
    @{ID="S23"; Author="Bernasco"; Year="2005"; Terms=@("residential burglars", "select target", "Nieuwbeerta")},
    @{ID="S24"; Author="Bernasco"; Year="2006"; Terms=@("Co-offending", "Choice of Target", "Burglary")},
    @{ID="S25"; Author="Townsley"; Year="2015"; Terms=@("Netherlands", "NL", "Cross-national")},
    @{ID="S26"; Author="Bernasco"; Year="2003"; Terms=@("Attractiveness", "Opportunity", "Accessibility")},
    @{ID="S27"; Author="Bernasco"; Year="2015"; Terms=@("Learning", "where to offend", "Effects of past")},
    @{ID="S28"; Author="Frith"; Year="2019"; Terms=@("taste", "heterogeneity", "offence location")},
    @{ID="S29"; Author="Hanayama"; Year="2018"; Terms=@("usefulness", "past crime data", "attractiveness")},
    @{ID="S30"; Author="Bernasco"; Year="2019"; Terms=@("Adolescent", "whereabouts", "future crime")},
    @{ID="S31"; Author="Bernasco"; Year="2015"; Terms=@("Dealers", "Solicit", "Jacques")},
    @{ID="S32"; Author="Bernasco"; Year="2009"; Terms=@("Block", "attack", "Chicago")},
    @{ID="S33"; Author="Chamberlain"; Year="2016"; Terms=@("Relative Difference", "Burglary Location", "Boggess")},
    @{ID="S34"; Author="Bernasco"; Year="2010"; Terms=@("Sentimental", "Journey", "Residential History")},
    @{ID="S35"; Author="Bernasco"; Year="2010"; Terms=@("Modeling", "Micro-Level", "framework")},
    @{ID="S36"; Author="Bernasco"; Year="2010"; Terms=@("Kooistra", "Commercial Robbers", "Residential history")},
    @{ID="S37"; Author="Frith"; Year="2017"; Terms=@("STREET NETWORK", "Burglars", "SPATIAL")},
    @{ID="S38"; Author="Baudains"; Year="2013"; Terms=@("London Riots", "TARGET CHOICE", "EXTREME EVENTS")},
    @{ID="S39"; Author="Johnson"; Year="2015"; Terms=@("Summers", "Ecological Theories", "Spatial Decision")},
    @{ID="S40"; Author="Vandeviver"; Year="2015"; Terms=@("house-level", "burglary target", "discrete spatial")},
    @{ID="S41"; Author="Langton"; Year="2017"; Terms=@("burglary target", "property-level", "Google Street", "Steenbeek")},
    @{ID="S42"; Author="Marchment"; Year="2019"; Terms=@("terrorists", "spatial decision", "Gill")},
    @{ID="S43"; Author="Chamberlain"; Year="2022"; Terms=@("Traveling Alone", "Together", "Group")},
    @{ID="S44"; Author="Curtis-Ham"; Year="2022"; Terms=@("Importance Sampling", "Alternatives", "Discrete Choice")},
    @{ID="S45"; Author="Yue"; Year="2023"; Terms=@("street view", "theft crime", "physical environment")},
    @{ID="S46"; Author="Kuralarasan"; Year="2024"; Terms=@("Graffiti", "Writers", "Optimize Exposure")},
    @{ID="S47"; Author="Rowan"; Year="2022"; Terms=@("Crime Pattern Theory", "Co-Offending", "Convergence")},
    @{ID="S48"; Author="Smith"; Year="2007"; Terms=@("Brown", "Discrete choice analysis", "spatial attack")},
    @{ID="S49"; Author="Cai"; Year="2024"; Terms=@("divergent", "neighborhood context", "burglars")},
    @{ID="S50"; Author="Curtis-Ham"; Year="2025"; Terms=@("Familiar locations", "similar activities", "knowledge")}
)

$foundCount = 0
$missingCount = 0
$reportContent = "ULTRA SIMPLE ORGANIZATION REPORT`r`n"
$reportContent += "Generated on: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')`r`n`r`n"
$reportContent += "RESULTS:`r`n`r`n"

# Search directories to look for PDFs
$searchDirs = @(
    $pdfDir,
    $newPdfDir,
    (Join-Path $newPdfDir "My Library\files")
)

# Process each study
foreach ($study in $studies) {
    $studyId = $study.ID
    $studyAuthor = $study.Author
    $studyYear = $study.Year
    $matchedPdfs = @()
    
    foreach ($dir in $searchDirs) {
        if (Test-Path $dir) {
            $pdfs = Get-ChildItem -Path $dir -Filter "*.pdf" -Recurse
            
            foreach ($pdf in $pdfs) {
                $fileName = $pdf.Name
                
                # Simple check - if filename contains both author and year, it's likely a match
                if ($fileName -match $studyAuthor -and $fileName -match $studyYear) {
                    # Additional verification with at least one term
                    $foundTerm = $false
                    foreach ($term in $study.Terms) {
                        if ($fileName -match [regex]::Escape($term)) {
                            $foundTerm = $true
                            break
                        }
                    }
                    
                    # If we found at least one term, consider it a match
                    if ($foundTerm) {
                        $matchedPdfs += $pdf.FullName
                    }
                }
            }
        }
    }
    
    # Process matches for this study
    if ($matchedPdfs.Count -gt 0) {
        $foundCount++
        $studyDir = Join-Path $finalDir $studyId
        if (-not (Test-Path $studyDir)) {
            New-Item -Path $studyDir -ItemType Directory -Force | Out-Null
        }
        
        # Copy the first match to the study directory
        $primaryPdf = $matchedPdfs[0]
        $fileName = Split-Path $primaryPdf -Leaf
        $destination = Join-Path $studyDir $fileName
        Copy-Item -Path $primaryPdf -Destination $destination -Force
        
        # Add to report
        $reportContent += "$studyId - FOUND`r`n"
        $reportContent += "  Source: $primaryPdf`r`n"
        $reportContent += "  Destination: $destination`r`n"
        if ($matchedPdfs.Count -gt 1) {
            $reportContent += "  Additional matches: $($matchedPdfs.Count - 1)`r`n"
        }
        $reportContent += "`r`n"
    }
    else {
        $missingCount++
        $reportContent += "$studyId - MISSING`r`n"
        $reportContent += "  Author: $studyAuthor`r`n"
        $reportContent += "  Year: $studyYear`r`n"
        $reportContent += "  Search Terms: $($study.Terms -join ', ')`r`n"
        $reportContent += "`r`n"
    }
}

# Add summary to report
$totalStudies = $studies.Count
$percentFound = [math]::Round(($foundCount / $totalStudies) * 100)
$summary = "SUMMARY:`r`n"
$summary += "Total Studies: $totalStudies`r`n"
$summary += "Found: $foundCount ($percentFound%)`r`n"
$summary += "Missing: $missingCount`r`n`r`n"
$reportContent = $summary + $reportContent

# Save report
$reportContent | Out-File -FilePath $reportFile -Force

Write-Host "Organization complete!"
Write-Host "Found: $foundCount of $totalStudies studies ($percentFound%)"
Write-Host "Report saved to: $reportFile"
