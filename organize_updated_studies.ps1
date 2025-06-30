# Organization Script for Updated Studies
# This script organizes the newly added studies

# Define paths
$finalOrganizedPath = "c:\Users\kukumar\OneDrive - UGent\Job\crimsyndata\-crime-location-choice-studies\snatching work\FinalOrganized\OrganizedStudies"
$finalOrganizedStudiesPath = "c:\Users\kukumar\OneDrive - UGent\Job\crimsyndata\-crime-location-choice-studies\snatching work\References\FinalOrganizedStudies"
$reportsPath = "c:\Users\kukumar\OneDrive - UGent\Job\crimsyndata\-crime-location-choice-studies\snatching work\FinalOrganized\Reports"

# Create log file
$logFile = Join-Path $reportsPath "updated_organization_log.txt"
"Updated Organization Log - $(Get-Date)" | Out-File -FilePath $logFile -Force

# Function to log messages
function Write-Log {
    param (
        [string]$message
    )
    Write-Host $message
    $message | Out-File -FilePath $logFile -Append
}

Write-Log "Starting organization of newly added studies..."

# Get the list of study folders in FinalOrganizedStudies
$studyFolders = Get-ChildItem -Path $finalOrganizedStudiesPath -Directory

Write-Log "Found $($studyFolders.Count) studies in FinalOrganizedStudies"

# Track which studies were previously missing and have now been found
$previouslyMissingStudies = @("S02", "S03", "S07", "S10", "S15", "S16", "S18", "S19", "S45", "S49")
$newlyFoundStudies = @()

# Process each study folder
foreach ($folder in $studyFolders) {
    $studyId = $folder.Name
    $targetFolder = Join-Path $finalOrganizedPath $studyId
    
    # Check if this study already exists in the target location
    if (-not (Test-Path $targetFolder)) {
        # This is a new study, create the folder in the target location
        New-Item -ItemType Directory -Path $targetFolder -Force | Out-Null
        Write-Log "Created new folder for $studyId"
        
        # Check if this was one of the previously missing studies
        if ($previouslyMissingStudies -contains $studyId) {
            $newlyFoundStudies += $studyId
            Write-Log "$studyId was previously missing and has now been found"
        }
    }
    
    # Get PDF files in the source folder
    $pdfFiles = Get-ChildItem -Path $folder.FullName -Filter "*.pdf"
    
    foreach ($pdf in $pdfFiles) {
        $targetFile = Join-Path $targetFolder $pdf.Name
        
        # Copy the PDF file
        Copy-Item -Path $pdf.FullName -Destination $targetFile -Force
        Write-Log "Copied $($pdf.Name) to $studyId folder"
    }
}

# Handle the loose PDFs in the FinalOrganized/OrganizedStudies folder
Write-Log "`nProcessing loose PDF files in the OrganizedStudies folder..."

$looseFiles = Get-ChildItem -Path $finalOrganizedPath -Filter "*.pdf"

foreach ($file in $looseFiles) {
    # Try to determine which study this belongs to from the filename
    $studyId = $null
    
    # Check if file matches any of the previously missing studies
    foreach ($id in $previouslyMissingStudies) {
        if ($file.Name -match $id.Substring(1)) {
            $studyId = $id
            break
        }
    }
    
    # If we identified a study ID, move the file
    if ($studyId) {
        $targetFolder = Join-Path $finalOrganizedPath $studyId
        
        # Create folder if it doesn't exist
        if (-not (Test-Path $targetFolder)) {
            New-Item -ItemType Directory -Path $targetFolder -Force | Out-Null
            Write-Log "Created new folder for $studyId"
            $newlyFoundStudies += $studyId
        }
        
        # Move the file
        $targetFile = Join-Path $targetFolder $file.Name
        Move-Item -Path $file.FullName -Destination $targetFile -Force
        Write-Log "Moved loose file $($file.Name) to $studyId folder"
    } else {
        Write-Log "Could not determine study ID for loose file: $($file.Name)"
    }
}

# Generate updated report
$reportFile = Join-Path $reportsPath "updated_organization_report.txt"

$allStudyFolders = Get-ChildItem -Path $finalOrganizedPath -Directory
$foundStudies = $allStudyFolders.Name | Sort-Object

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
Write-Log "`nGenerated updated organization report"

Write-Log "`nOrganization completed!"
Write-Log "Found studies: $($foundStudies.Count) out of 50"
Write-Log "Newly added studies: $($newlyFoundStudies.Count)"
Write-Log "Still missing studies: $($stillMissingStudies.Count)"
