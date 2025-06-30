# More flexible search script for finding target PDFs
# This script uses more lenient pattern matching to find files even with different naming conventions

$rootPath = "C:\Users\kukumar\OneDrive - UGent\Job\crimsyndata\-crime-location-choice-studies\snatching work\References"
$outputPath = Join-Path $rootPath "FlexTargetStudies"
$reportPath = Join-Path $rootPath "flexible_search_report.txt"

# Create output directory if it doesn't exist
if (-not (Test-Path $outputPath)) {
    New-Item -Path $outputPath -ItemType Directory -Force | Out-Null
}

# Clear previous report
"# Flexible Search Report for Target Studies" | Out-File -FilePath $reportPath
"Generated on $(Get-Date)" | Out-File -FilePath $reportPath -Append
"" | Out-File -FilePath $reportPath -Append

# List of target studies with multiple search patterns
$targetStudies = @(
    @{
        ID = "S01"
        Patterns = @(
            "Burglar Target Selection",
            "Target selection models - Townsley 2016",
            "Townsley.*2016.*Target",
            "Target.*Townsley.*2016",
            "Townsley.*selection.*2016"
        )
    },
    @{
        ID = "S02"
        Patterns = @(
            "Bernasco.*2017.*Street Robbery Location", 
            "Bernasco.*2017.*Test in Chicago",
            "Bernasco.*2017.*Street",
            "Bernasco.*Chicago.*2017"
        )
    },
    @{
        ID = "S03"
        Patterns = @(
            "Clare.*2009.*barriers and connectors", 
            "Clare.*2009.*burglars",
            "Clare.*barriers.*2009",
            "Clare.*burglary.*2009"
        )
    },
    @{
        ID = "S04"
        Patterns = @(
            "Townsley.*2015.*Burglar Target Selection.*Cross-national.*AU", 
            "Townsley.*2015.*Australia",
            "Townsley.*Cross-national.*2015",
            "Townsley.*Australia.*2015"
        )
    },
    @{
        ID = "S06"
        Patterns = @(
            "Lammers.*2015.*Biting Once Twice", 
            "Lammers.*2015.*crime location choice",
            "Lammers.*Biting.*2015",
            "Lammers.*location.*2015"
        )
    },
    @{
        ID = "S07"
        Patterns = @(
            "Lammers.*2017.*Co-offending groups", 
            "Lammers.*2017.*awareness space",
            "Lammers.*groups.*2017",
            "Lammers.*awareness.*2017",
            "Lammers.*co-offend.*2017"
        )
    },
    @{
        ID = "S10"
        Patterns = @(
            "Xiao.*2021.*Burglars blocked by barriers", 
            "Xiao.*2021.*China",
            "Xiao.*barriers.*2021",
            "Xiao.*China.*2021",
            "Xiao.*burglars.*2021"
        )
    },
    @{
        ID = "S12"
        Patterns = @(
            "Townsley.*2015.*Burglar Target Selection.*UK", 
            "Townsley.*2015.*Super Output Areas",
            "Townsley.*UK.*2015",
            "Townsley.*Output Areas.*2015"
        )
    },
    @{
        ID = "S15"
        Patterns = @(
            "Long.*2018.*Assessing the influence of prior", 
            "Long.*2018.*robbery location",
            "Long.*influence.*2018",
            "Long.*robbery.*2018"
        )
    },
    @{
        ID = "S16"
        Patterns = @(
            "Long.*2021.*Ambient population", 
            "Long.*2021.*surveillance cameras",
            "Long.*Ambient.*2021",
            "Long.*surveillance.*2021",
            "Long.*cameras.*2021"
        )
    },
    @{
        ID = "S18"
        Patterns = @(
            "Long.*2022.*juvenile.*young adult", 
            "Long.*Liu.*2022.*Chinese context",
            "Long.*juvenile.*2022",
            "Long.*Chinese.*2022"
        )
    },
    @{
        ID = "S19"
        Patterns = @(
            "Curtis-Ham.*2022.*Relationships Between Offenders", 
            "Curtis-Ham.*2022.*Prior Activity",
            "Curtis-Ham.*Relationships.*2022",
            "Curtis-Ham.*Activity.*2022"
        )
    },
    @{
        ID = "S25"
        Patterns = @(
            "Townsley.*2015.*Burglar Target Selection.*NL", 
            "Townsley.*2015.*Netherlands",
            "Townsley.*Netherlands.*2015",
            "Townsley.*NL.*2015"
        )
    },
    @{
        ID = "S26"
        Patterns = @(
            "Bernasco.*2003.*Attractiveness Opportunity", 
            "Bernasco.*2003.*Residential Burglary Rates",
            "Bernasco.*Attractiveness.*2003",
            "Bernasco.*Burglary Rates.*2003",
            "Bernasco.*2003"
        )
    },
    @{
        ID = "S36"
        Patterns = @(
            "Bernasco.*2010.*residential history", 
            "Bernasco.*Kooistra.*2010",
            "Bernasco.*history.*2010",
            "Bernasco.*Kooistra"
        )
    },
    @{
        ID = "S45"
        Patterns = @(
            "Yue.*2023.*effect of people on the street", 
            "Yue.*2023.*street theft crime",
            "Yue.*street.*2023",
            "Yue.*theft.*2023"
        )
    },
    @{
        ID = "S49"
        Patterns = @(
            "Cai.*2024.*divergent decisionmaking", 
            "Cai.*2024.*context",
            "Cai.*divergent.*2024",
            "Cai.*decision.*2024"
        )
    }
)

# Function to search for PDFs based on multiple patterns
function Find-PDFs {
    param (
        [string]$BasePath,
        [string[]]$SearchPatterns
    )
    
    $allPdfs = Get-ChildItem -Path $BasePath -Filter "*.pdf" -Recurse -File -ErrorAction SilentlyContinue
    $matchedFiles = @()
    
    foreach ($pattern in $SearchPatterns) {
        $pattern = $pattern -replace "\s+", ".*"
        $matched = $allPdfs | Where-Object { $_.Name -match $pattern -or $_.FullName -match $pattern }
        $matchedFiles += $matched
    }
    
    # Return unique files
    return $matchedFiles | Select-Object -Unique
}

# Map to track which studies were found
$studiesFound = @{}

# Process each target study
foreach ($study in $targetStudies) {
    $id = $study.ID
    $patterns = $study.Patterns
    
    # Search for matching PDFs
    $matchingFiles = Find-PDFs -BasePath $rootPath -SearchPatterns $patterns
    
    # Record results in report
    "### $id" | Out-File -FilePath $reportPath -Append
    if ($matchingFiles.Count -gt 0) {
        $studiesFound[$id] = $true
        "FOUND: $($matchingFiles.Count) file(s)" | Out-File -FilePath $reportPath -Append
        
        foreach ($file in $matchingFiles) {
            "- $($file.FullName)" | Out-File -FilePath $reportPath -Append
            
            # Copy the file to the output directory
            $destFile = Join-Path $outputPath "$id - $($file.Name)"
            Copy-Item -Path $file.FullName -Destination $destFile -Force
            
            # Print on console for immediate feedback
            Write-Host "Found $id: $($file.Name)"
        }
    } else {
        "NOT FOUND" | Out-File -FilePath $reportPath -Append
        foreach ($pattern in $patterns) {
            "- Search pattern: $pattern" | Out-File -FilePath $reportPath -Append
        }
    }
    "" | Out-File -FilePath $reportPath -Append
}

# Summary of results
"## SUMMARY" | Out-File -FilePath $reportPath -Append
$foundCount = ($studiesFound.Keys).Count
$totalCount = $targetStudies.Count

"Found $foundCount out of $totalCount target studies" | Out-File -FilePath $reportPath -Append
"" | Out-File -FilePath $reportPath -Append

# List missing studies
"## MISSING STUDIES" | Out-File -FilePath $reportPath -Append
foreach ($study in $targetStudies) {
    $id = $study.ID
    if (-not $studiesFound.ContainsKey($id)) {
        "$id" | Out-File -FilePath $reportPath -Append
    }
}

Write-Host "Search complete. Found $foundCount out of $totalCount target studies."
Write-Host "Results saved to $reportPath"
Write-Host "Files copied to $outputPath"
