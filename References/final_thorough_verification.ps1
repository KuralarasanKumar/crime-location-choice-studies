# Final Thorough Verification Script
# This script performs a comprehensive analysis of the PDFs folder 
# to identify which target studies from the table are present and which are missing

# Variables
$pdfFolder = "C:\Users\kukumar\OneDrive - UGent\Job\crimsyndata\-crime-location-choice-studies\snatching work\References\PDFs"
$mdFile = "C:\Users\kukumar\OneDrive - UGent\Job\crimsyndata\-crime-location-choice-studies\snatching work\crime_location_choice_studies.md"
$outputReport = "C:\Users\kukumar\OneDrive - UGent\Job\crimsyndata\-crime-location-choice-studies\snatching work\References\FINAL_THOROUGH_VERIFICATION.txt"

# Create timestamp
$timestamp = Get-Date -Format "MM/dd/yyyy HH:mm:ss"

# Read the markdown table and extract study information
Write-Host "Reading target studies from markdown file..."
$mdContent = Get-Content -Path $mdFile -Raw

# Parse the table to extract target studies
$tableRows = $mdContent -split "\r?\n" | Where-Object { $_ -match "^\|\s*\d+" }
$targetStudies = @()

foreach ($row in $tableRows) {
    $cells = $row -split "\|" | ForEach-Object { $_.Trim() }
    if ($cells.Count -ge 4 -and $cells[1] -match "^\d+$") {
        $studyNumber = $cells[1]
        $title = $cells[2]
        $citation = $cells[3]
        
        $targetStudies += [PSCustomObject]@{
            StudyNumber = $studyNumber
            Title = $title
            Citation = $citation
            AuthorYear = if ($citation -match "\((.*?),?\s*\d{4}\)") { $matches[1] } else { "" }
            Year = if ($citation -match "\d{4}") { $matches[0] } else { "" }
            Found = $false
            FilePath = ""
            Confidence = "Not Found"
        }
    }
}

Write-Host "Found $($targetStudies.Count) target studies in the markdown file."

# Get all PDFs in the folder
$pdfFiles = Get-ChildItem -Path $pdfFolder -Filter "*.pdf"
Write-Host "Found $($pdfFiles.Count) PDF files in the folder."

# Function to check if a PDF likely matches a target study
function Test-PDFMatch {
    param (
        [Parameter(Mandatory=$true)]
        [string]$pdfFilename,
        
        [Parameter(Mandatory=$true)]
        [object]$study
    )
    
    $score = 0
    $maxScore = 10
    
    # Check for author match
    $authorPattern = $study.AuthorYear
    if ($authorPattern -and $pdfFilename -match $authorPattern) {
        $score += 4
    }
    
    # Check for year match
    if ($study.Year -and $pdfFilename -match $study.Year) {
        $score += 2
    }
    
    # Check for keywords in the title
    $titleWords = $study.Title -split "\s+|,|\." | Where-Object { $_.Length -gt 4 } | Select-Object -First 5
    foreach ($word in $titleWords) {
        if ($pdfFilename -match [regex]::Escape($word)) {
            $score += 1
        }
    }
    
    # Return result with confidence level
    if ($score -ge 6) {
        return @{Match=$true; Confidence="High"; Score=$score}
    }
    elseif ($score -ge 3) {
        return @{Match=$true; Confidence="Medium"; Score=$score}
    }
    elseif ($score -ge 1) {
        return @{Match=$true; Confidence="Low"; Score=$score}
    }
    else {
        return @{Match=$false; Confidence="None"; Score=$score}
    }
}

# Analyze each PDF and check for matches
Write-Host "Analyzing PDFs and matching to target studies..."

$matchResults = @()
foreach ($pdf in $pdfFiles) {
    $pdfName = $pdf.Name
    $bestMatch = $null
    $bestScore = 0
    $bestStudy = $null
    
    foreach ($study in $targetStudies) {
        $matchResult = Test-PDFMatch -pdfFilename $pdfName -study $study
        
        if ($matchResult.Match -and $matchResult.Score -gt $bestScore) {
            $bestMatch = $matchResult
            $bestScore = $matchResult.Score
            $bestStudy = $study
        }
    }
    
    if ($bestMatch -ne $null) {
        $matchResults += [PSCustomObject]@{
            PDF = $pdfName
            StudyNumber = $bestStudy.StudyNumber
            Confidence = $bestMatch.Confidence
            Score = $bestMatch.Score
        }
        
        # Update target study if confidence is high
        if ($bestMatch.Confidence -eq "High" -and -not $bestStudy.Found) {
            $bestStudy.Found = $true
            $bestStudy.FilePath = $pdfName
            $bestStudy.Confidence = "High"
        }
    } else {
        $matchResults += [PSCustomObject]@{
            PDF = $pdfName
            StudyNumber = "None"
            Confidence = "None"
            Score = 0
        }
    }
}

# Check for duplicate high confidence matches and resolve
$highConfidenceMatches = $matchResults | Where-Object { $_.Confidence -eq "High" } | Group-Object -Property StudyNumber

foreach ($group in $highConfidenceMatches) {
    if ($group.Count -gt 1) {
        # Multiple high confidence matches for the same study
        # Keep the one with the highest score
        $bestMatch = $group.Group | Sort-Object -Property Score -Descending | Select-Object -First 1
        
        # Update all other matches to medium confidence
        foreach ($match in $group.Group) {
            if ($match.PDF -ne $bestMatch.PDF) {
                $match.Confidence = "Medium"
            }
        }
    }
}

# Generate report
Write-Host "Generating comprehensive verification report..."

$reportContent = @"
================================================================================
FINAL THOROUGH VERIFICATION REPORT
Generated: $timestamp
================================================================================

SUMMARY:
Total PDFs analyzed: $($pdfFiles.Count)
Target studies found (high confidence): $($targetStudies | Where-Object { $_.Confidence -eq "High" } | Measure-Object).Count
Target studies found (medium confidence): $($targetStudies | Where-Object { $_.Confidence -eq "Medium" } | Measure-Object).Count
Target studies not found: $($targetStudies | Where-Object { -not $_.Found } | Measure-Object).Count

================================================================================
HIGH CONFIDENCE MATCHES
================================================================================
"@

foreach ($study in ($targetStudies | Where-Object { $_.Confidence -eq "High" } | Sort-Object -Property StudyNumber)) {
    $reportContent += @"

S$($study.StudyNumber): $($study.Title)
   Citation: $($study.Citation)
   File: $($study.FilePath)
"@
}

$reportContent += @"

================================================================================
MEDIUM CONFIDENCE MATCHES
================================================================================
"@

$mediumMatches = $matchResults | Where-Object { $_.Confidence -eq "Medium" } | Sort-Object -Property StudyNumber
foreach ($match in $mediumMatches) {
    $study = $targetStudies | Where-Object { $_.StudyNumber -eq $match.StudyNumber } | Select-Object -First 1
    
    $reportContent += @"

S$($match.StudyNumber): $($study.Title)
   PDF: $($match.PDF)
   Score: $($match.Score)
"@
}

$reportContent += @"

================================================================================
LOW CONFIDENCE MATCHES
================================================================================
"@

$lowMatches = $matchResults | Where-Object { $_.Confidence -eq "Low" } | Sort-Object -Property StudyNumber
foreach ($match in $lowMatches) {
    $study = $targetStudies | Where-Object { $_.StudyNumber -eq $match.StudyNumber } | Select-Object -First 1
    if ($study) {
        $reportContent += @"

S$($match.StudyNumber): $($study.Title)
   PDF: $($match.PDF)
   Score: $($match.Score)
"@
    }
}

$reportContent += @"

================================================================================
MISSING TARGET STUDIES
================================================================================
"@

$missingStudies = $targetStudies | Where-Object { -not $_.Found } | Sort-Object -Property StudyNumber
foreach ($study in $missingStudies) {
    $reportContent += @"

S$($study.StudyNumber): $($study.Title)
   Citation: $($study.Citation)
"@
}

$reportContent += @"

================================================================================
UNMATCHED PDFs
================================================================================
"@

$unmatchedPDFs = $matchResults | Where-Object { $_.StudyNumber -eq "None" -or $_.Confidence -eq "None" } | Sort-Object -Property PDF
foreach ($pdf in $unmatchedPDFs) {
    $reportContent += @"
$($pdf.PDF)
"@
}

# Save the report
$reportContent | Out-File -FilePath $outputReport -Encoding utf8

Write-Host "Report generated and saved to $outputReport"
Write-Host "Verification complete!"
