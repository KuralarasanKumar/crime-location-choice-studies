# Townsley 2016 Search Script
# This script searches specifically for the Townsley 2016 paper

$rootFolder = "c:\Users\kukumar\OneDrive - UGent\Job\crimsyndata\-crime-location-choice-studies\snatching work\References"
$searchTerm = "Townsley 2016"
$resultsFile = Join-Path $rootFolder "townsley_search_results.txt"

# Initialize results
$report = "# TOWNSLEY 2016 SEARCH RESULTS`r`n`r`n"
$report += "Created: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')`r`n`r`n"
$report += "Searching for: '$searchTerm'`r`n`r`n"

# Search for PDFs containing 'Townsley 2016'
$mainPDFs = Get-ChildItem -Path "$rootFolder\PDFs" -Recurse -Include "*.pdf" -ErrorAction SilentlyContinue | 
            Where-Object { $_.Name -match $searchTerm }
            
$newPDFs = Get-ChildItem -Path "$rootFolder\new pdf" -Recurse -Include "*.pdf" -ErrorAction SilentlyContinue | 
          Where-Object { $_.Name -match $searchTerm }

$report += "## Results from PDFs folder:`r`n"
foreach ($file in $mainPDFs) {
    $report += "- $($file.FullName)`r`n"
}
$report += "`r`nTotal: $($mainPDFs.Count) files`r`n`r`n"

$report += "## Results from 'new pdf' folder:`r`n"
foreach ($file in $newPDFs) {
    $report += "- $($file.FullName)`r`n"
}
$report += "`r`nTotal: $($newPDFs.Count) files`r`n`r`n"

# Also try an even broader search
$report += "## Broader search for files containing 'Townsley':`r`n"

$allTownsley = Get-ChildItem -Path "$rootFolder" -Recurse -Include "*.pdf" -ErrorAction SilentlyContinue | 
               Where-Object { $_.Name -match "Townsley" }

foreach ($file in $allTownsley) {
    $report += "- $($file.FullName)`r`n"
}
$report += "`r`nTotal: $($allTownsley.Count) files`r`n"

# Save report to file
$report | Out-File -FilePath $resultsFile -Encoding utf8

Write-Host "Search complete. Results saved to: $resultsFile"
