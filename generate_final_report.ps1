# Finalize Organization and Generate Report
# This script generates a final report based on the current state of organized studies

# Define paths
$finalOrganizedPath = "c:\Users\kukumar\OneDrive - UGent\Job\crimsyndata\-crime-location-choice-studies\snatching work\FinalOrganized\OrganizedStudies"
$reportsPath = "c:\Users\kukumar\OneDrive - UGent\Job\crimsyndata\-crime-location-choice-studies\snatching work\FinalOrganized\Reports"

# Create log file
$logFile = Join-Path $reportsPath "final_updated_organization_log.txt"
"Final Updated Organization Log - $(Get-Date)" | Out-File -FilePath $logFile -Force

# Function to log messages
function Write-Log {
    param (
        [string]$message
    )
    Write-Host $message
    $message | Out-File -FilePath $logFile -Append
}

Write-Log "Generating final updated report..."

# Generate updated report
$reportFile = Join-Path $reportsPath "updated_organization_report.txt"

# Get all study folders in the final organized location
$allStudyFolders = Get-ChildItem -Path $finalOrganizedPath -Directory
$foundStudies = $allStudyFolders.Name | Sort-Object

# Define previously missing studies
$previouslyMissingStudies = @("S02", "S03", "S07", "S10", "S15", "S16", "S18", "S19", "S45", "S49")

# Check which previously missing studies are now found
$newlyFoundStudies = $foundStudies | Where-Object { $previouslyMissingStudies -contains $_ }

# Determine which studies are still missing
$allStudies = 1..50 | ForEach-Object { "S" + $_.ToString("00") }
$stillMissingStudies = $allStudies | Where-Object { $foundStudies -notcontains $_ }

$report = @"
# UPDATED ORGANIZATION REPORT

Date: $(Get-Date)

## OVERVIEW

The organization of PDFs for the Crime Location Choice Studies has been updated with newly found articles.

## FOUND STUDIES ($(($foundStudies | Measure-Object).Count) out of 50)

$($foundStudies -join ", ")

## NEWLY ADDED STUDIES ($(($newlyFoundStudies | Measure-Object).Count))

$($newlyFoundStudies -join ", ")

## STILL MISSING STUDIES ($(($stillMissingStudies | Measure-Object).Count))

$($stillMissingStudies -join ", ")

## ORGANIZATION DETAILS

- All found PDFs have been organized into folders in the FinalOrganized/OrganizedStudies directory.
- Each folder is named after the study ID (e.g., S01, S02) for easy reference.
- This report replaces the previous organization summary.
"@

$report | Out-File -FilePath $reportFile -Force
Write-Log "Generated updated organization report"

Write-Log "Organization completed!"
Write-Log "Found studies: $($foundStudies.Count) out of 50"
Write-Log "Newly added studies: $($newlyFoundStudies.Count)"
Write-Log "Still missing studies: $($stillMissingStudies.Count)"
Write-Log "Still missing: $($stillMissingStudies -join ', ')"
