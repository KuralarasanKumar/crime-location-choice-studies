# Final Target Studies Organization Script
# This script will organize all target studies in a single folder with proper naming

# Define paths
$mainPDFPath = "c:\Users\kukumar\OneDrive - UGent\Job\crimsyndata\-crime-location-choice-studies\snatching work\References\PDFs"
$outputFolder = "c:\Users\kukumar\OneDrive - UGent\Job\crimsyndata\-crime-location-choice-studies\snatching work\References\Analysis_Results"
$foundStudiesFile = Join-Path $outputFolder "comprehensive_found_studies.txt"

# Create organization folder
$organizedFolder = Join-Path $mainPDFPath "FinalTargetStudies"
if (-not (Test-Path $organizedFolder)) {
    New-Item -ItemType Directory -Path $organizedFolder -Force | Out-Null
}

# Read the found studies file
$content = Get-Content $foundStudiesFile -Raw -ErrorAction SilentlyContinue
if (-not $content) {
    Write-Host "Could not read the found studies file. Please run the scan script first."
    exit
}

# Create a hashtable to store study information from the crime_location_choice_studies.md file
$studyInfo = @{}

# Define the path to the crime_location_choice_studies.md file
$studiesFilePath = "c:\Users\kukumar\OneDrive - UGent\Job\crimsyndata\-crime-location-choice-studies\snatching work\crime_location_choice_studies.md"

# Read the studies file if it exists
if (Test-Path $studiesFilePath) {
    $studiesContent = Get-Content $studiesFilePath -Raw
    
    # Extract study information using regex
    $studyPattern = '\|\s*(\d+)\s*\|\s*(.*?)\s*\|\s*\((.*?)\)\s*\|'
    $studyMatches = [regex]::Matches($studiesContent, $studyPattern)
    
    foreach ($match in $studyMatches) {
        $number = $match.Groups[1].Value.Trim()
        $title = $match.Groups[2].Value.Trim()
        $citation = $match.Groups[3].Value.Trim()
        
        $studyId = "S" + $number.PadLeft(2, '0')
        $studyInfo[$studyId] = @{
            Title = $title
            Citation = $citation
        }
    }
}

# Extract study sections from the found studies file
$pattern = '(?sm)^## (S\d+)\r?\nSearch patterns: (.*?)\r?\nFound files:\r?\n((?:- .*\r?\n)+)'
$matches = [regex]::Matches($content, $pattern)

$reportContent = "# FINAL TARGET STUDIES ORGANIZATION REPORT`r`n`r`n"
$reportContent += "Created on $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')`r`n`r`n"
$reportContent += "## ORGANIZED TARGET STUDIES`r`n`r`n"

# Process each study
foreach ($match in $matches) {
    $studyId = $match.Groups[1].Value
    $patterns = $match.Groups[2].Value
    $filesText = $match.Groups[3].Value
    
    # Extract file paths
    $filePaths = $filesText -split "\r?\n" | Where-Object { $_ -match "^- (.+)$" } | ForEach-Object { $Matches[1] }
    
    # Skip files in ToDelete folder
    $filePaths = $filePaths | Where-Object { $_ -notmatch "ToDelete" }
    
    if ($filePaths.Count -gt 0) {
        # Get study info if available
        $title = ""
        $citation = ""
        if ($studyInfo.ContainsKey($studyId)) {
            $title = $studyInfo[$studyId].Title
            $citation = $studyInfo[$studyId].Citation
        }
        
        # Create a descriptive filename
        $descriptiveFilename = "$studyId - $citation - $title.pdf"
        # Clean up filename to remove invalid characters
        $descriptiveFilename = [System.IO.Path]::GetInvalidFileNameChars() | ForEach-Object {
            $descriptiveFilename = $descriptiveFilename.Replace($_, '_')
        }
        # Further cleanup - replace multiple underscores with a single one
        $descriptiveFilename = $descriptiveFilename -replace '_{2,}', '_'
        # Limit filename length
        if ($descriptiveFilename.Length -gt 180) {
            $descriptiveFilename = $descriptiveFilename.Substring(0, 177) + "..."
        }
        
        $destPath = Join-Path $organizedFolder $descriptiveFilename
        
        try {
            # Copy the file
            Copy-Item -Path $filePaths[0] -Destination $destPath -Force
            $reportContent += "### $studyId - $title`r`n"
            $reportContent += "- Source: $($filePaths[0])`r`n"
            $reportContent += "- Destination: $destPath`r`n`r`n"
        }
        catch {
            $reportContent += "### $studyId - $title`r`n"
            $reportContent += "- ERROR copying file: $($filePaths[0])`r`n"
            $reportContent += "- Error message: $($_.Exception.Message)`r`n`r`n"
        }
    }
}

# Save report
$reportFile = Join-Path $outputFolder "final_target_studies_organization_report.txt"
$reportContent | Out-File -FilePath $reportFile -Encoding utf8

# Create a simplified report with just the study IDs and titles
$simplifiedReport = "# ORGANIZED TARGET STUDIES SUMMARY`r`n`r`n"
$simplifiedReport += "Created on $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')`r`n`r`n"
$simplifiedReport += "Total Studies Found: $($matches.Count) out of 50`r`n`r`n"

# Add study IDs and titles to the simplified report
foreach ($match in $matches) {
    $studyId = $match.Groups[1].Value
    $title = ""
    $citation = ""
    if ($studyInfo.ContainsKey($studyId)) {
        $title = $studyInfo[$studyId].Title
        $citation = $studyInfo[$studyId].Citation
    }
    
    $simplifiedReport += "- ${studyId}: ${title} (${citation})`r`n"
}

# Save simplified report
$simplifiedReportFile = Join-Path $outputFolder "organized_studies_summary.txt"
$simplifiedReport | Out-File -FilePath $simplifiedReportFile -Encoding utf8

Write-Host "Organization complete! Reports saved to:"
Write-Host "- $reportFile"
Write-Host "- $simplifiedReportFile"
Write-Host "Target studies have been copied to $organizedFolder"
