# Fix Loose Files Script
# This script identifies and moves loose PDF files to their appropriate study folders

# Define paths
$finalOrganizedPath = "c:\Users\kukumar\OneDrive - UGent\Job\crimsyndata\-crime-location-choice-studies\snatching work\FinalOrganized\OrganizedStudies"
$reportsPath = "c:\Users\kukumar\OneDrive - UGent\Job\crimsyndata\-crime-location-choice-studies\snatching work\FinalOrganized\Reports"

# Study pattern mappings for the remaining loose files
$fileToStudyMapping = @{
    "Bernasco et al. - 2017 - Do Street Robbery Location Choices Vary Over Time of Day or Day of Week A Test in Chicago.pdf" = "S02"
    "Clare et al. - 2009 - Formal Evaluation of the Impact of Barriers and Connectors on Residential Burglars' Macro-Level Offe.pdf" = "S03"
    "Curtis-Ham et al. - Relationships Between Offenders' Crime Locations a.pdf" = "S19"
    "Long et al. - Do juvenile, young adult, and adult offenders target different places in the Chinese context.pdf" = "S18"
}

# Log file
$logFile = Join-Path $reportsPath "fix_loose_files_log.txt"
"Fix Loose Files Log - $(Get-Date)" | Out-File -FilePath $logFile -Force

# Function to log messages
function Write-Log {
    param (
        [string]$message
    )
    Write-Host $message
    $message | Out-File -FilePath $logFile -Append
}

Write-Log "Starting to fix loose PDF files..."

# Get all loose PDF files
$looseFiles = Get-ChildItem -Path $finalOrganizedPath -Filter "*.pdf"

foreach ($file in $looseFiles) {
    # Check if this file is in our mapping
    if ($fileToStudyMapping.ContainsKey($file.Name)) {
        $studyId = $fileToStudyMapping[$file.Name]
        $targetFolder = Join-Path $finalOrganizedPath $studyId
        
        # Create folder if it doesn't exist
        if (-not (Test-Path $targetFolder)) {
            New-Item -ItemType Directory -Path $targetFolder -Force | Out-Null
            Write-Log "Created new folder for $studyId"
        }
        
        # Move the file
        $targetPath = Join-Path $targetFolder $file.Name
        Move-Item -Path $file.FullName -Destination $targetPath -Force
        Write-Log "Moved $($file.Name) to $studyId folder"
    } else {
        Write-Log "Could not determine study ID for: $($file.Name)"
    }
}

Write-Log "Finished fixing loose PDF files."
