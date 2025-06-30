##############################################################
# Final Workspace Cleanup Script
# This script will delete all unnecessary files and folders
# while preserving essential components like the final organized PDFs,
# main reports, and key reference files.
##############################################################

# Set error action preference to stop on error
$ErrorActionPreference = "Stop"

# Base path
$basePath = "c:\Users\kukumar\OneDrive - UGent\Job\crimsyndata\-crime-location-choice-studies\snatching work"

# Create a log file
$logPath = Join-Path $basePath "workspace_cleanup_log.txt"
"Workspace Cleanup Log - $(Get-Date)" | Out-File $logPath

# Function to log messages
function LogMessage {
    param (
        [string]$message
    )
    Write-Host $message
    $message | Out-File $logPath -Append
}

LogMessage "Starting workspace cleanup process..."

# 1. Create a "FinalOrganized" folder to store all essential files
$finalFolder = Join-Path $basePath "FinalOrganized"
if (-not (Test-Path $finalFolder)) {
    New-Item -ItemType Directory -Path $finalFolder | Out-Null
    LogMessage "Created FinalOrganized folder"
}

# 2. Copy the main reference file
$mainRefFile = Join-Path $basePath "crime_location_choice_studies.md"
if (Test-Path $mainRefFile) {
    Copy-Item $mainRefFile -Destination $finalFolder
    LogMessage "Copied main reference file: crime_location_choice_studies.md"
} else {
    LogMessage "WARNING: Main reference file not found"
}

# 3. Create essential folders in the final folder
$finalPdfsFolder = Join-Path $finalFolder "OrganizedStudies"
$finalReportsFolder = Join-Path $finalFolder "Reports"
$finalScriptsFolder = Join-Path $finalFolder "Scripts"

if (-not (Test-Path $finalPdfsFolder)) { New-Item -ItemType Directory -Path $finalPdfsFolder | Out-Null }
if (-not (Test-Path $finalReportsFolder)) { New-Item -ItemType Directory -Path $finalReportsFolder | Out-Null }
if (-not (Test-Path $finalScriptsFolder)) { New-Item -ItemType Directory -Path $finalScriptsFolder | Out-Null }

# 4. Copy organized PDFs to the final folder
$ultraSimpleOrg = Join-Path $basePath "References\UltraSimpleOrganization"
if (Test-Path $ultraSimpleOrg) {
    LogMessage "Copying organized studies from UltraSimpleOrganization..."
    Copy-Item -Path $ultraSimpleOrg\* -Destination $finalPdfsFolder -Recurse
    LogMessage "Copied organized studies successfully"
} else {
    LogMessage "WARNING: UltraSimpleOrganization folder not found"
}

# 5. Copy important reports
$reportsSource = Join-Path $basePath "References\Analysis_Results"
if (Test-Path $reportsSource) {
    LogMessage "Copying important reports..."
    
    # Important report files to keep
    $reportsToKeep = @(
        "final_organization_summary.txt",
        "ultra_simple_report.txt",
        "final_report.txt"
    )
    
    foreach ($report in $reportsToKeep) {
        $reportPath = Join-Path $reportsSource $report
        if (Test-Path $reportPath) {
            Copy-Item $reportPath -Destination $finalReportsFolder
            LogMessage "Copied report: $report"
        } else {
            LogMessage "Report not found: $report"
        }
    }
} else {
    LogMessage "WARNING: Analysis_Results folder not found"
}

# 6. Copy the most important script
$mainScript = Join-Path $basePath "References\flexible_search_script.ps1"
if (Test-Path $mainScript) {
    Copy-Item $mainScript -Destination $finalScriptsFolder
    LogMessage "Copied main script: flexible_search_script.ps1"
} else {
    LogMessage "WARNING: Main script flexible_search_script.ps1 not found"
}

# 7. Create a README file in the final folder
$readmePath = Join-Path $finalFolder "README.md"
$readmeContent = @"
# Crime Location Choice Studies - Organized Workspace

This folder contains the organized files for the Crime Location Choice Studies project.

## Folder Structure

- **OrganizedStudies/** - Contains organized PDFs for each study, arranged by study ID
- **Reports/** - Contains important summary reports and analysis results
- **Scripts/** - Contains the main script used for finding and organizing the studies
- **crime_location_choice_studies.md** - Main reference file with the table of studies

## Summary

The workspace has been cleaned up and organized to contain only the essential files.
Original data was processed to find and organize PDFs for the studies listed in the main reference table.
According to the final organization summary, 40 out of 50 studies were found and organized.

For more details, please refer to the reports in the Reports folder.

Last updated: $(Get-Date)
"@

$readmeContent | Out-File $readmePath
LogMessage "Created README.md file in the final folder"

# 8. After everything is copied, ask for confirmation before deleting
LogMessage "All essential files have been copied to the FinalOrganized folder."
LogMessage "Ready to delete unnecessary files. The following will be kept:"
LogMessage "- FinalOrganized folder with all essential files"

$confirmation = Read-Host "Do you want to proceed with deleting all other files and folders? (y/n)"

if ($confirmation -eq 'y') {
    # Get all items in the base path except the FinalOrganized folder
    Get-ChildItem -Path $basePath | Where-Object { $_.Name -ne "FinalOrganized" } | ForEach-Object {
        if ($_.Name -eq "workspace_cleanup_log.txt") {
            # Skip the log file for now
            continue
        }
        
        if ($_.Name -eq "final_workspace_cleanup.ps1") {
            # Skip this script itself
            continue
        }
        
        # Delete the item
        if ($_.PSIsContainer) {
            LogMessage "Deleting folder: $($_.FullName)"
        } else {
            LogMessage "Deleting file: $($_.FullName)"
        }
        
        Remove-Item -Path $_.FullName -Recurse -Force
    }
    
    # Copy the log file to the final folder before deleting the original
    Copy-Item $logPath -Destination (Join-Path $finalReportsFolder "workspace_cleanup_log.txt")
    
    LogMessage "Cleanup complete. All unnecessary files and folders have been deleted."
    LogMessage "The essential files are preserved in the FinalOrganized folder."
} else {
    LogMessage "Cleanup cancelled. No files were deleted."
    LogMessage "You can find all essential files in the FinalOrganized folder."
}
