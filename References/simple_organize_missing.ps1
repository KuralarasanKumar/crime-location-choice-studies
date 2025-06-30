# Simple Script to Organize Missing PDFs
Write-Host "Starting to organize missing studies..."

# Define the path to the new PDF folder
$newPDFPath = "c:\Users\kukumar\OneDrive - UGent\Job\crimsyndata\-crime-location-choice-studies\snatching work\References\new pdf"

# Create the CompletedStudies folder if it doesn't exist
$organizedFolder = "c:\Users\kukumar\OneDrive - UGent\Job\crimsyndata\-crime-location-choice-studies\snatching work\References\CompletedStudies"
if (-not (Test-Path $organizedFolder)) {
    New-Item -ItemType Directory -Path $organizedFolder -Force
}

# Copy the existing organized studies if available
$ultraSimpleOrg = "c:\Users\kukumar\OneDrive - UGent\Job\crimsyndata\-crime-location-choice-studies\snatching work\References\UltraSimpleOrganization"
if (Test-Path $ultraSimpleOrg) {
    Write-Host "Copying existing organized studies..."
    Get-ChildItem -Path $ultraSimpleOrg -Directory | ForEach-Object {
        $studyDir = Join-Path $organizedFolder $_.Name
        if (-not (Test-Path $studyDir)) {
            Copy-Item -Path $_.FullName -Destination $organizedFolder -Recurse
        }
    }
}

# Define the missing studies and their search patterns
$missingStudies = @{
    "S02" = @("Bernasco", "2017", "Street", "Chicago", "Day of Week")
    "S03" = @("Clare", "2009", "barrier", "burglar", "formal evaluation")
    "S07" = @("Lammers", "2017", "Co-offending", "awareness space")
    "S10" = @("Xiao", "2021", "barrier", "China", "burglars")
    "S15" = @("Long", "2018", "prior", "robbery", "location")
    "S16" = @("Long", "2021", "Ambient", "surveillance", "cameras")
    "S18" = @("Long", "2022", "juvenile", "adult", "Chinese")
    "S19" = @("Curtis-Ham", "2022", "Relationship", "Crime Location", "Prior Activity")
    "S45" = @("Yue", "2023", "street", "physical", "street theft")
    "S49" = @("Cai", "2024", "divergent", "neighborhood", "burglars")
}

# Function to check if a file matches a study
function Match-Study {
    param (
        [string]$fileName,
        [string]$studyId,
        [array]$keywords
    )
    
    # First check for main author and year
    $mainAuthor = $keywords[0]
    $year = $keywords[1]
    
    if ($fileName -match $mainAuthor -and $fileName -match $year) {
        Write-Host "  Found potential match for $studyId: $fileName"
        return $true
    }
    
    # For more generic matching, check if any 3 keywords match
    $matchCount = 0
    foreach ($keyword in $keywords) {
        if ($fileName -match $keyword) {
            $matchCount++
        }
    }
    
    if ($matchCount -ge 3) {
        Write-Host "  Found potential match for $studyId with $matchCount keywords: $fileName"
        return $true
    }
    
    return $false
}

# Process each missing study
foreach ($studyId in $missingStudies.Keys) {
    Write-Host "Looking for $studyId..."
    $keywords = $missingStudies[$studyId]
    $studyFolder = Join-Path $organizedFolder $studyId
    
    if (Test-Path $studyFolder) {
        Write-Host "  $studyId already organized, skipping."
        continue
    }
    
    # Create the study folder
    New-Item -ItemType Directory -Path $studyFolder -Force | Out-Null
    
    # Check all PDFs in the new pdf folder
    $foundMatch = $false
    Get-ChildItem -Path $newPDFPath -Filter "*.pdf" -Recurse | ForEach-Object {
        if (Match-Study -fileName $_.Name -studyId $studyId -keywords $keywords) {
            Copy-Item -Path $_.FullName -Destination (Join-Path $studyFolder "$studyId.pdf")
            Write-Host "  Copied $($_.Name) to $studyId folder"
            $foundMatch = $true
        }
    }
    
    if (-not $foundMatch) {
        Write-Host "  No match found for $studyId"
        # Remove empty folder if no match found
        Remove-Item -Path $studyFolder -Force
    }
}

# Generate summary report
Write-Host "Generating summary report..."

$reportPath = Join-Path $organizedFolder "complete_organization_report.txt"
$studyFolders = Get-ChildItem -Path $organizedFolder -Directory
$foundCount = $studyFolders.Count

# Find which studies are still missing
$allStudyIds = 1..50 | ForEach-Object { "S{0:D2}" -f $_ }
$foundStudies = $studyFolders.Name
$stillMissing = $allStudyIds | Where-Object { $foundStudies -notcontains $_ }

$report = @"
# COMPLETE PDF ORGANIZATION SUMMARY

Date: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')

## OVERVIEW

We've organized the PDFs for the Crime Location Choice Studies as requested.
Here's a summary of what was done:

1. We found and organized $foundCount out of 50 studies ($([math]::Round(($foundCount / 50) * 100))%).
2. The remaining $($stillMissing.Count) studies ($([math]::Round(($stillMissing.Count / 50) * 100))%) could not be found in the available PDF files.

## FOUND STUDIES ($foundCount)

$($foundStudies -join ", ")

## MISSING STUDIES ($($stillMissing.Count))

$($stillMissing -join ", ")

## ORGANIZATION DETAILS

- All found PDFs have been organized into folders in the 'CompletedStudies' directory.
- Each folder is named after the study ID (e.g., S01, S02) for easy reference.
- The most recent search focused specifically on finding the 10 previously missing studies.
"@

$report | Out-File -FilePath $reportPath -Encoding utf8

Write-Host "Organization complete! Report saved to $reportPath"
Write-Host "Found and organized $foundCount out of 50 target studies"
if ($stillMissing.Count -gt 0) {
    Write-Host "Still missing: $($stillMissing -join ', ')"
} else {
    Write-Host "All studies have been found and organized!"
}
