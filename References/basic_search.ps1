# Basic PDF Search Script
# This script searches for specific authors and years in PDF filenames

$rootFolder = "c:\Users\kukumar\OneDrive - UGent\Job\crimsyndata\-crime-location-choice-studies\snatching work\References"
$resultsFile = Join-Path $rootFolder "basic_search_results.txt"

# Define authors to search for
$authors = @(
    "Townsley 2016", 
    "Townsley 2015",
    "Bernasco 2013",
    "Bernasco 2017",
    "Bernasco 2015", 
    "Bernasco 2010",
    "Bernasco 2019",
    "Bernasco 2009",
    "Curtis-Ham 2022",
    "Curtis-Ham 2025",
    "Clare 2009",
    "Kuralarasan 2022",
    "Menting 2018",
    "Long 2021",
    "Vandeviver 2020",
    "Frith 2019",
    "Langton 2017",
    "Marchment 2019",
    "Chamberlain 2022",
    "Chamberlain 2016",
    "Rowan 2022",
    "Smith 2007"
)

# Initialize results
$report = "# BASIC PDF SEARCH RESULTS`r`n`r`n"
$report += "Created: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')`r`n`r`n"

foreach ($author in $authors) {
    $report += "## $author`r`n"
    
    # Search for PDFs containing the author and year
    $mainPDFs = Get-ChildItem -Path "$rootFolder\PDFs" -Recurse -Include "*.pdf" -ErrorAction SilentlyContinue | 
                Where-Object { $_.Name -match $author }
                
    $newPDFs = Get-ChildItem -Path "$rootFolder\new pdf" -Recurse -Include "*.pdf" -ErrorAction SilentlyContinue | 
              Where-Object { $_.Name -match $author }
    
    $allMatches = $mainPDFs + $newPDFs
    
    $report += "Found $($allMatches.Count) matching files:`r`n"
    
    foreach ($match in $allMatches) {
        $report += "- $($match.FullName)`r`n"
    }
    
    $report += "`r`n"
}

# Save report to file
$report | Out-File -FilePath $resultsFile -Encoding utf8

Write-Host "Search complete. Results saved to: $resultsFile"
