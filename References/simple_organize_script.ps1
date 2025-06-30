# Simple Target Studies Organization Script

# Define paths
$mainPDFPath = "c:\Users\kukumar\OneDrive - UGent\Job\crimsyndata\-crime-location-choice-studies\snatching work\References\PDFs"
$outputFolder = "c:\Users\kukumar\OneDrive - UGent\Job\crimsyndata\-crime-location-choice-studies\snatching work\References\SimpleFinalOrganization"

# Create output folder if it doesn't exist
if (-not (Test-Path $outputFolder)) {
    New-Item -ItemType Directory -Path $outputFolder -Force | Out-Null
}

# Define target studies with their file patterns
$targetStudies = @{
    "S01_Bernasco_2013_Go_where_the_money_is" = "Bernasco et al. - 2013 - Go where the money is modeling street robbers"
    "S02_Bernasco_2017_Do_Street_Robbery" = "Bernasco et al. - 2017 - Social Interactions"
    "S11_Kuralarasan_2022_Location_Choice" = "Kuralarasan and Bernasco - 2022 - Location Choice of Snatching"
    "S13_Menting_2018_Awareness_Opportunity" = "Menting - 2018 - AWARENESS"
    "S17_Long_Liu_2021_Migrant_Native_Robbers" = "Long and Liu - 2021 - Do Migrant and Native"
    "S19_Curtis-Ham_2022_Relationships" = "Curtis-Ham et al. - Relationships Between"
    "S20_Vandeviver_2020_Location_Location" = "Vandeviver and Bernasco - 2020 - Location, Location"
    "S27_Bernasco_2015_Learning_where_to_offend" = "Bernasco et al. - 2015 - Learning where to offend"
    "S28_Frith_2019_Modelling_taste" = "Frith - 2019 - Modelling taste heterogeneity"
    "S30_Bernasco_2019_Adolescent_offenders" = "Bernasco - 2019 - Adolescent Offenders"
    "S32_Bernasco_Block_2009_Where_offenders_choose" = "Bernasco and Block - 2009 - Where offenders choose"
    "S33_Chamberlain_2016_Relative_Difference" = "Chamberlain and Boggess - 2016 - Relative difference"
    "S36_Bernasco_Kooistra_2010_Effects_Residential" = "Bernasco and Kooistra - 2010 - Effects of residential"
    "S41_Langton_Steenbeek_2017_Residential_burglary" = "Langton and Steenbeek - 2017 - Residential burglary"
    "S42_Marchment_Gill_2019_spatial_decision_making" = "Marchment and Gill - 2019 - Modelling the spatial decision"
    "S43_Chamberlain_2022_Traveling_Alone" = "chamberlain-et-al-2022-traveling-alone"
    "S44_Curtis-Ham_2022_Importance_Sampling" = "Curtis-Ham et al. - 2022 - The Importance of Importance"
    "S47_Rowan_2022_Crime_Pattern_Theory" = "Rowan et al. - 2022 - Situating Crime Pattern Theory"
    "S48_Smith_Brown_2007_spatial_attack_sites" = "Smith and Brown - 2007 - Discrete choice analysis"
    "S50_Curtis-Ham_2025_familiar_locations" = "Curtis-Ham et al. - 2025 - Familiar Locations"
    "S04-12-25_Townsley_2015_Burglar_Target_Selection" = "Townsley et al. - 2015 - Burglar Target Selection"
}

# Function to find and copy target studies
function Find-And-Copy-TargetStudies {
    param (
        [string]$searchPath
    )
    
    Write-Host "Searching for target studies in $searchPath..."
    
    # Get all PDF files in the folder and subfolders
    $allPDFs = Get-ChildItem -Path $searchPath -Filter "*.pdf" -Recurse -ErrorAction SilentlyContinue
    Write-Host "Found $($allPDFs.Count) PDF files to examine"
    
    foreach ($targetStudyKey in $targetStudies.Keys) {
        $pattern = $targetStudies[$targetStudyKey]
        $matchingFiles = $allPDFs | Where-Object { $_.Name -like "*$pattern*" -and $_.FullName -notlike "*ToDelete*" }
        
        if ($matchingFiles.Count -gt 0) {
            # Use the first matching file
            $sourceFile = $matchingFiles[0]
            $destFile = Join-Path $outputFolder "$targetStudyKey.pdf"
            
            try {
                Copy-Item -Path $sourceFile.FullName -Destination $destFile -Force
                Write-Host "Copied $($sourceFile.Name) to $destFile"
            }
            catch {
                Write-Host "Error copying $($sourceFile.Name): $($_.Exception.Message)"
            }
        }
    }
}

# Search for target studies in main PDFs folder
Find-And-Copy-TargetStudies -searchPath $mainPDFPath

# Also search in new pdf folder
$newPDFPath = "c:\Users\kukumar\OneDrive - UGent\Job\crimsyndata\-crime-location-choice-studies\snatching work\References\new pdf"
if (Test-Path $newPDFPath) {
    Find-And-Copy-TargetStudies -searchPath $newPDFPath
}

# Create a summary report
$reportPath = Join-Path $outputFolder "organization_summary.txt"
$report = "# TARGET STUDIES ORGANIZATION SUMMARY`r`n`r`n"
$report += "Created on $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')`r`n`r`n"

# Check which target studies were successfully copied
$copiedStudies = Get-ChildItem -Path $outputFolder -Filter "*.pdf"
$report += "Successfully organized $($copiedStudies.Count) out of $($targetStudies.Count) target studies:`r`n`r`n"

foreach ($study in $copiedStudies) {
    $studyName = [System.IO.Path]::GetFileNameWithoutExtension($study.Name)
    $report += "- $studyName`r`n"
}

$report += "`r`nMissing studies:`r`n`r`n"
foreach ($targetStudyKey in $targetStudies.Keys) {
    $found = $false
    foreach ($study in $copiedStudies) {
        if ([System.IO.Path]::GetFileNameWithoutExtension($study.Name) -eq $targetStudyKey) {
            $found = $true
            break
        }
    }
    
    if (-not $found) {
        $report += "- $targetStudyKey`r`n"
    }
}

$report | Out-File -FilePath $reportPath -Encoding utf8

Write-Host "`r`nOrganization complete! Summary report saved to $reportPath"
Write-Host "Target studies have been copied to $outputFolder"
