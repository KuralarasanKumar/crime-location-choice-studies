# This script analyzes the PDFs folder to identify which target studies are present
# Extracts author names and study titles from the file table in the markdown document
# Compares them with PDF filenames to find matches

$ErrorActionPreference = "Stop"

# Define the paths
$pdfFolderPath = "c:\Users\kukumar\OneDrive - UGent\Job\crimsyndata\-crime-location-choice-studies\snatching work\References\PDFs"
$mdFilePath = "c:\Users\kukumar\OneDrive - UGent\Job\crimsyndata\-crime-location-choice-studies\snatching work\crime_location_choice_studies.md"
$outputPath = "c:\Users\kukumar\OneDrive - UGent\Job\crimsyndata\-crime-location-choice-studies\snatching work\References\comprehensive_target_studies_found.txt"

# Read the markdown file content
$mdContent = Get-Content -Path $mdFilePath -Raw

# Extract table rows from markdown
$tablePattern = "(?s)\|\s*S\. No\s*\|\s*Title of the study.*?(\|[\s\S]*?\|)(?:\s*\d+\s*$|\s*\n\s*\n|\s*$)"
$tableMatches = [regex]::Match($mdContent, $tablePattern)
if ($tableMatches.Success) {
    $tableRows = ($tableMatches.Groups[1].Value -split "`n") | Where-Object { $_ -match "^\s*\|.*\|\s*$" }
} else {
    Write-Error "Table not found in the markdown file"
    exit 1
}

# Create a list to store study information
$studies = @()

# Parse each table row
foreach ($row in $tableRows) {
    if ($row -match "^\s*\|\s*(\d+)\s*\|\s*(.*?)\s*\|\s*\((.*?)\).*\|") {
        $studyNum = $Matches[1]
        $title = $Matches[2].Trim()
        $citation = $Matches[3].Trim()
        
        # Extract authors by splitting on commas and removing year
        $authors = ($citation -replace "\s*\d{4}\s*$", "").Split(",") | ForEach-Object { $_.Trim() }
        
        # Add to studies list
        $studies += [PSCustomObject]@{
            Number = $studyNum
            Title = $title
            Citation = $citation
            Authors = $authors
            MainAuthor = $authors[0].Split()[-1]  # Last name of first author
            Year = if ($citation -match "\d{4}$") { $Matches[0] } else { "Unknown" }
        }
    }
}

# Get list of all PDF files
$allPdfFiles = Get-ChildItem -Path $pdfFolderPath -Filter "*.pdf" | Where-Object { $_.DirectoryName -notmatch "ToDelete" }

# Create a result object
$results = @{
    FoundStudies = @()
    MissingStudies = @()
    PossibleMatches = @()
}

# Function to normalize text for comparison
function Normalize-Text {
    param ([string]$text)
    return $text.ToLower() -replace "[^a-z0-9]", ""
}

# Check each study against the PDF files
foreach ($study in $studies) {
    $found = $false
    $possibleMatches = @()

    # Main author last name and year pattern
    $mainAuthorLastName = $study.MainAuthor
    $year = $study.Year
    
    # First, look for exact matches with author and title
    foreach ($pdfFile in $allPdfFiles) {
        $pdfName = $pdfFile.Name
        
        # Check for main author + title match
        if (($pdfName -match [regex]::Escape($mainAuthorLastName)) -and 
            ($pdfName -match [regex]::Escape($study.Title.Substring(0, [Math]::Min(30, $study.Title.Length))))) {
            $found = $true
            $results.FoundStudies += [PSCustomObject]@{
                StudyNumber = $study.Number
                StudyTitle = $study.Title
                PDFFile = $pdfName
                MatchType = "Author and Title Match"
            }
            break
        }
        
        # Check for main author + year match with partial title
        if (($pdfName -match [regex]::Escape($mainAuthorLastName)) -and 
            ($pdfName -match $year) -and
            ($study.Title.Split() | Where-Object { $_.Length -gt 4 } | 
                ForEach-Object { if ($pdfName -match [regex]::Escape($_)) { return $true } })) {
            $found = $true
            $results.FoundStudies += [PSCustomObject]@{
                StudyNumber = $study.Number
                StudyTitle = $study.Title
                PDFFile = $pdfName
                MatchType = "Author, Year and Partial Title Match"
            }
            break
        }
        
        # Check for second-level matches (possible matches)
        if (($pdfName -match [regex]::Escape($mainAuthorLastName)) -and ($pdfName -match $year)) {
            $possibleMatches += $pdfName
        }
        elseif ($study.Authors.Count -gt 1 -and $pdfName -match "et al" -and $pdfName -match [regex]::Escape($mainAuthorLastName)) {
            $possibleMatches += $pdfName
        }
        elseif ($study.Title.Split() | Where-Object { $_.Length -gt 6 } | 
                ForEach-Object { 
                    $keyword = $_
                    if ($pdfName -match [regex]::Escape($keyword)) { 
                        return $true 
                    }
                }) {
            $possibleMatches += $pdfName
        }
    }
    
    # Check specific cases we know might exist
    # Example: For "chamberlain-et-al-2022-traveling-alone-or-together-neighborhood-context-on-individual-and-group-juvenile-an.pdf"
    if ($study.Number -eq "43" -and -not $found) {
        $chamberlainFile = $allPdfFiles | Where-Object { $_.Name -match "chamberlain.*2022.*traveling" }
        if ($chamberlainFile) {
            $found = $true
            $results.FoundStudies += [PSCustomObject]@{
                StudyNumber = $study.Number
                StudyTitle = $study.Title
                PDFFile = $chamberlainFile.Name
                MatchType = "Special Case Match"
            }
        }
    }
    
    # Check specific case for Chamberlain & Boggess 2016
    if ($study.Number -eq "33" -and -not $found) {
        $chamberlainFile = $allPdfFiles | Where-Object { $_.Name -match "Chamberlain.*Boggess.*2016" }
        if ($chamberlainFile) {
            $found = $true
            $results.FoundStudies += [PSCustomObject]@{
                StudyNumber = $study.Number
                StudyTitle = $study.Title
                PDFFile = $chamberlainFile.Name
                MatchType = "Special Case Match"
            }
        }
    }

    # Check specific case for Curtis-Ham 2022 "The Importance of Importance Sampling"
    if ($study.Number -eq "44" -and -not $found) {
        $curtisHamFile = $allPdfFiles | Where-Object { $_.Name -match "Curtis-Ham.*2022.*Importance" }
        if ($curtisHamFile) {
            $found = $true
            $results.FoundStudies += [PSCustomObject]@{
                StudyNumber = $study.Number
                StudyTitle = $study.Title
                PDFFile = $curtisHamFile.Name
                MatchType = "Special Case Match"
            }
        }
    }
    
    # Check specific case for Groff 2017
    if ($study.Number -eq "38" -and -not $found) {
        $groffFile = $allPdfFiles | Where-Object { $_.Name -match "Groff.*2017.*Built Environment" }
        if ($groffFile) {
            $found = $true
            $results.FoundStudies += [PSCustomObject]@{
                StudyNumber = $study.Number
                StudyTitle = $study.Title
                PDFFile = $groffFile.Name
                MatchType = "Special Case Match"
            }
        }
    }
    
    # Check specific case for Johnson 2014
    if ($study.Number -eq "39" -and -not $found) {
        $johnsonFile = $allPdfFiles | Where-Object { $_.Name -match "Johnson.*2014.*offenders choose" }
        if ($johnsonFile) {
            $found = $true
            $results.FoundStudies += [PSCustomObject]@{
                StudyNumber = $study.Number
                StudyTitle = $study.Title
                PDFFile = $johnsonFile.Name
                MatchType = "Special Case Match"
            }
        }
    }
    
    # Add special case for Smith & Brown 2007
    if ($study.Number -eq "48" -and -not $found) {
        $smithBrownFile = $allPdfFiles | Where-Object { $_.Name -match "Smith.*Brown.*2007.*spatial attack sites" }
        if ($smithBrownFile) {
            $found = $true
            $results.FoundStudies += [PSCustomObject]@{
                StudyNumber = $study.Number
                StudyTitle = $study.Title
                PDFFile = $smithBrownFile.Name
                MatchType = "Special Case Match"
            }
        }
    }
    
    # Add special case for Curtis-Ham 2025
    if ($study.Number -eq "50" -and -not $found) {
        $curtisHam2025File = $allPdfFiles | Where-Object { $_.Name -match "Curtis-Ham.*2025.*Familiar Locations" }
        if ($curtisHam2025File) {
            $found = $true
            $results.FoundStudies += [PSCustomObject]@{
                StudyNumber = $study.Number
                StudyTitle = $study.Title
                PDFFile = $curtisHam2025File.Name
                MatchType = "Special Case Match"
            }
        }
    }
    
    # Add special case for Kuralarasan & Bernasco 2022
    if ($study.Number -eq "11" -and -not $found) {
        $kuralFile = $allPdfFiles | Where-Object { $_.Name -match "Kuralarasan.*Bernasco.*2022" }
        if ($kuralFile) {
            $found = $true
            $results.FoundStudies += [PSCustomObject]@{
                StudyNumber = $study.Number
                StudyTitle = $study.Title
                PDFFile = $kuralFile.Name
                MatchType = "Special Case Match"
            }
        }
    }
    
    # Add special case for Marchment & Gill 2022
    if ($study.Number -eq "42" -and -not $found) {
        $marchmentFile = $allPdfFiles | Where-Object { $_.Name -match "Marchment.*Gill.*2022" -or $_.Name -match "Marchment.*Gill.*2019" }
        if ($marchmentFile) {
            $found = $true
            $results.FoundStudies += [PSCustomObject]@{
                StudyNumber = $study.Number
                StudyTitle = $study.Title
                PDFFile = $marchmentFile.Name
                MatchType = "Special Case Match"
            }
        }
    }
    
    # Add special case for Xue & Brown 2006
    if ($study.Number -eq "54" -and -not $found) {
        $xueFile = $allPdfFiles | Where-Object { $_.Name -match "Xue.*Brown.*2006.*spatial analysis" }
        if ($xueFile) {
            $found = $true
            $results.FoundStudies += [PSCustomObject]@{
                StudyNumber = $study.Number
                StudyTitle = $study.Title
                PDFFile = $xueFile.Name
                MatchType = "Special Case Match"
            }
        }
    }
    
    # Add special case for Rowan et al. 2022
    if ($study.Number -eq "47" -and -not $found) {
        $rowanFile = $allPdfFiles | Where-Object { $_.Name -match "Rowan.*2022.*Crime Pattern" }
        if ($rowanFile) {
            $found = $true
            $results.FoundStudies += [PSCustomObject]@{
                StudyNumber = $study.Number
                StudyTitle = $study.Title
                PDFFile = $rowanFile.Name
                MatchType = "Special Case Match"
            }
        }
    }
    
    # Store the study as missing if not found
    if (-not $found) {
        $results.MissingStudies += $study
        
        # Add possible matches if any
        if ($possibleMatches.Count -gt 0) {
            $results.PossibleMatches += [PSCustomObject]@{
                StudyNumber = $study.Number
                StudyTitle = $study.Title
                PossiblePDFFiles = $possibleMatches
            }
        }
    }
}

# Prepare report output
$report = @"
# Comprehensive Target Studies Analysis Report
Generated on $(Get-Date)

## Summary
- Total target studies: $($studies.Count)
- Found studies: $($results.FoundStudies.Count)
- Missing studies: $($results.MissingStudies.Count)
- Studies with possible matches: $($results.PossibleMatches.Count)

## Found Studies ($($results.FoundStudies.Count))
| Study # | Study Title | PDF File | Match Type |
|---------|------------|----------|-----------|
$($results.FoundStudies | ForEach-Object { "| $($_.StudyNumber) | $($_.StudyTitle) | $($_.PDFFile) | $($_.MatchType) |" } | Out-String)

## Missing Studies ($($results.MissingStudies.Count))
| Study # | Study Title | Citation |
|---------|------------|----------|
$($results.MissingStudies | ForEach-Object { "| $($_.Number) | $($_.Title) | $($_.Citation) |" } | Out-String)

## Possible Matches ($($results.PossibleMatches.Count))
$($results.PossibleMatches | ForEach-Object { 
    "### Study #$($_.StudyNumber): $($_.StudyTitle)`n"
    "Possible matching files:`n"
    $_.PossiblePDFFiles | ForEach-Object { "- $_`n" }
    "`n"
})

## Recommendations
1. Review the possible matches to confirm if any are actual matches
2. Consider searching for the missing studies from academic databases
3. Check for any files in the ToDelete folder that might be relevant
"@

# Write the report to file
$report | Out-File -FilePath $outputPath

Write-Host "Analysis complete. Results saved to $outputPath"
