# Target Study Organization Script
# This script will organize target studies by copying them from all locations to the main PDFs folder

# Define the paths
$mainPDFPath = "c:\Users\kukumar\OneDrive - UGent\Job\crimsyndata\-crime-location-choice-studies\snatching work\References\PDFs"
$outputFolder = "c:\Users\kukumar\OneDrive - UGent\Job\crimsyndata\-crime-location-choice-studies\snatching work\References\Analysis_Results"
$foundStudiesFile = Join-Path $outputFolder "comprehensive_found_studies.txt"

# Create organization folder
$organizedFolder = Join-Path $mainPDFPath "OrganizedTargetStudies"
if (-not (Test-Path $organizedFolder)) {
    New-Item -ItemType Directory -Path $organizedFolder -Force | Out-Null
}

# Read the found studies file
$content = Get-Content $foundStudiesFile -Raw

# Extract study sections using regex
$pattern = '(?sm)^## (S\d+)\r?\nSearch patterns: (.*?)\r?\nFound files:\r?\n((?:- .*\r?\n)+)'
$matches = [regex]::Matches($content, $pattern)

$reportContent = "# TARGET STUDIES ORGANIZATION REPORT`r`n`r`n"
$reportContent += "Created on $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')`r`n`r`n"
$reportContent += "## ORGANIZED TARGET STUDIES`r`n`r`n"

# Process each study
foreach ($match in $matches) {
    $studyId = $match.Groups[1].Value
    $patterns = $match.Groups[2].Value
    $filesText = $match.Groups[3].Value
    
    # Extract file paths
    $filePaths = $filesText -split "\r?\n" | Where-Object { $_ -match "^- (.+)$" } | ForEach-Object { $Matches[1] }
    
    # Skip ToDelete folder files
    $filePaths = $filePaths | Where-Object { $_ -notmatch "ToDelete" }
    
    if ($filePaths.Count -gt 0) {
        # Create study folder
        $studyFolder = Join-Path $organizedFolder $studyId
        if (-not (Test-Path $studyFolder)) {
            New-Item -ItemType Directory -Path $studyFolder -Force | Out-Null
        }
        
        # Copy the first file found for this study
        $fileName = [System.IO.Path]::GetFileName($filePaths[0])
        $destPath = Join-Path $studyFolder $fileName
        
        if (-not (Test-Path $destPath)) {
            try {
                Copy-Item -Path $filePaths[0] -Destination $destPath -Force
                $reportContent += "### $studyId - $patterns`r`n"
                $reportContent += "- Source: $($filePaths[0])`r`n"
                $reportContent += "- Destination: $destPath`r`n`r`n"
            }
            catch {
                $reportContent += "### $studyId - $patterns`r`n"
                $reportContent += "- ERROR copying file: $($filePaths[0])`r`n"
                $reportContent += "- Error message: $($_.Exception.Message)`r`n`r`n"
            }
        }
    }
}

# Save report
$reportFile = Join-Path $outputFolder "target_studies_organization_report.txt"
$reportContent | Out-File -FilePath $reportFile -Encoding utf8

Write-Host "Organization complete! Report saved to $reportFile"
Write-Host "Target studies have been copied to $organizedFolder"
