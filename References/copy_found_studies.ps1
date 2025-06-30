# Simple Script to Copy Found Studies
# This script will copy the PDFs from the report to the CompleteTargetStudies folder

# Define paths
$reportPath = "c:\Users\kukumar\OneDrive - UGent\Job\crimsyndata\-crime-location-choice-studies\snatching work\References\CompleteTargetStudies\comprehensive_search_report.txt"
$outputFolder = "c:\Users\kukumar\OneDrive - UGent\Job\crimsyndata\-crime-location-choice-studies\snatching work\References\CompleteTargetStudies"

# Check if the report exists
if (-not (Test-Path $reportPath)) {
    Write-Host "Report file not found: $reportPath"
    exit
}

# Read the report content
$content = Get-Content $reportPath -Raw

# Extract study sections using regex
$pattern = '(?sm)^### (S\d+)\r?\n((?:- .*\r?\n)+)'
$matches = [regex]::Matches($content, $pattern)

Write-Host "Found $($matches.Count) studies in the report"
$copiedCount = 0

foreach ($match in $matches) {
    $studyId = $match.Groups[1].Value
    $filesText = $match.Groups[2].Value
    
    # Extract file paths
    $filePaths = $filesText -split "\r?\n" | Where-Object { $_ -match "^- (.+)$" } | ForEach-Object { $Matches[1] }
    
    if ($filePaths.Count -gt 0) {
        # Use the first file path
        $sourceFile = $filePaths[0]
        $destFile = Join-Path $outputFolder "$studyId.pdf"
        
        if (Test-Path $sourceFile) {
            try {
                Copy-Item -Path $sourceFile -Destination $destFile -Force
                Write-Host "Copied study ${studyId} from ${sourceFile}"
                $copiedCount++
            }
            catch {
                $errorMsg = $_.Exception.Message
                Write-Host "Error copying study ${studyId}: ${errorMsg}"
            }
        }
        else {
            Write-Host "Source file not found: ${sourceFile}"
        }
    }
}

Write-Host "`r`nSuccessfully copied ${copiedCount} studies to ${outputFolder}"
