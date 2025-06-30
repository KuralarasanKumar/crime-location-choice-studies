# Ultra Simple Target Studies Search Script
# This script uses a very basic approach to find target studies

# Define paths
$mainPDFPath = "c:\Users\kukumar\OneDrive - UGent\Job\crimsyndata\-crime-location-choice-studies\snatching work\References\PDFs"
$newPDFPath = "c:\Users\kukumar\OneDrive - UGent\Job\crimsyndata\-crime-location-choice-studies\snatching work\References\new pdf"

# Create output folder
$outputFolder = "c:\Users\kukumar\OneDrive - UGent\Job\crimsyndata\-crime-location-choice-studies\snatching work\References\SimpleSearchResults"
if (-not (Test-Path $outputFolder)) {
    New-Item -ItemType Directory -Path $outputFolder -Force
}

# Define simple search terms for each study
$searchTerms = @{
    "S01_Bernasco_2013_Go_where_the_money_is" = "Go where the money is"
    "S02_Bernasco_2017_Street_Robbery" = "Street Robbery"
    "S03_Clare_2009_barriers_connectors" = "Clare 2009"
    "S04_Townsley_2015_Cross_national_AU" = "Townsley 2015"
    "S05_Townsley_2016_Target_Selection" = "Townsley 2016"
    "S06_Lammers_2015_Biting_Once" = "Lammers 2015"
    "S07_Lammers_2017_Co_offending" = "Lammers 2017"
    "S08_Menting_2016_Family_Matters" = "Menting 2016"
    "S09_Sleeuwen_2018_Time_Crime" = "Sleeuwen 2018"
    "S10_Xiao_2021_Burglars_barriers" = "Xiao 2021"
    "S11_Kuralarasan_2022_Chennai" = "Kuralarasan 2022"
    "S12_Townsley_2015_Cross_national_UK" = "Townsley 2015"
    "S13_Menting_2018_Awareness_Opportunity" = "Menting 2018"
    "S14_Song_2019_Crime_Feeds" = "Song 2019"
    "S15_Long_2018_prior_influence" = "Long 2018"
    "S16_Long_2021_Ambient_population" = "Long 2021"
    "S17_Long_2021_Migrant_Native" = "Long 2021"
    "S18_Long_2022_juvenile_adult" = "Long 2022"
    "S19_Curtis_Ham_2022_Relationships" = "Curtis-Ham 2022"
    "S20_Vandeviver_2020_Location" = "Vandeviver 2020"
    "S21_Menting_2020_Activity_Space" = "Menting 2020"
    "S22_Sleeuwen_2021_Right_place" = "Sleeuwen 2021"
    "S23_Bernasco_2005_burglars" = "Bernasco 2005"
    "S24_Bernasco_2006_Co_offending" = "Bernasco 2006"
    "S25_Townsley_2015_Cross_national_NL" = "Townsley 2015"
    "S26_Bernasco_2003_Attractiveness" = "Bernasco 2003"
    "S27_Bernasco_2015_Learning" = "Bernasco 2015"
    "S28_Frith_2019_taste" = "Frith 2019"
    "S29_Hanayama_2018_past_crime" = "Hanayama 2018"
    "S30_Bernasco_2019_Adolescent" = "Bernasco 2019"
    "S31_Bernasco_2015_Dealers" = "Jacques 2015"
    "S32_Bernasco_2009_attack" = "Bernasco 2009"
    "S33_Chamberlain_2016_Relative" = "Chamberlain 2016"
    "S34_Bernasco_2010_Sentimental" = "Bernasco 2010"
    "S35_Bernasco_2010_Modeling" = "Bernasco 2010"
    "S36_Bernasco_2010_Kooistra" = "Kooistra 2010"
    "S37_Frith_2017_Street_Network" = "Frith 2017"
    "S38_Baudains_2013_Target_Choice" = "Baudains 2013"
    "S39_Johnson_2015_Ecological" = "Johnson 2015"
    "S40_Vandeviver_2015_discrete" = "Vandeviver 2015"
    "S41_Langton_2017_Residential" = "Langton 2017"
    "S42_Marchment_2019_spatial" = "Marchment 2019"
    "S43_Chamberlain_2022_Traveling" = "Chamberlain 2022"
    "S44_Curtis_Ham_2022_Importance" = "Importance Sampling"
    "S45_Yue_2023_street" = "Yue 2023"
    "S46_Kuralarasa_2024_Graffiti" = "Kuralarasa 2024"
    "S47_Rowan_2022_Crime_Pattern" = "Rowan 2022"
    "S48_Smith_2007_spatial_attack" = "Smith 2007"
    "S49_Cai_2024_divergent" = "Cai 2024"
    "S50_Curtis_Ham_2025_familiar" = "Curtis-Ham 2025"
}

# Simple search function
function Find-Files {
    param (
        [string]$folderPath,
        [string]$searchTerm
    )
    
    # Get all PDF files in the folder and subfolders
    $pdfFiles = Get-ChildItem -Path $folderPath -Filter "*.pdf" -Recurse -ErrorAction SilentlyContinue
    
    # Return files that match the search term
    return $pdfFiles | Where-Object { $_.Name -like "*$searchTerm*" }
}

# Create report
$reportContent = "# SIMPLE SEARCH RESULTS`r`n`r`n"
$reportContent += "Created on $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')`r`n`r`n"

$foundCount = 0
$totalCount = $searchTerms.Count

foreach ($key in $searchTerms.Keys) {
    $term = $searchTerms[$key]
    
    # Search in main PDFs folder
    $mainResults = Find-Files -folderPath $mainPDFPath -searchTerm $term
    
    # Search in new pdf folder
    $newResults = Find-Files -folderPath $newPDFPath -searchTerm $term
    
    $allResults = $mainResults + $newResults
    
    if ($allResults.Count -gt 0) {
        $foundCount++
        
        # Copy the first found file
        $sourceFile = $allResults[0]
        $destPath = Join-Path $outputFolder "$key.pdf"
        
        try {
            Copy-Item -Path $sourceFile.FullName -Destination $destPath -Force
            Write-Host "Copied $key from $($sourceFile.FullName)"
        }
        catch {
            Write-Host "Error copying $key: $($_.Exception.Message)"
        }
        
        $reportContent += "## $key`r`n"
        $reportContent += "Search term: $term`r`n"
        $reportContent += "Found files: $($allResults.Count)`r`n"
        
        foreach ($file in $allResults) {
            $reportContent += "- $($file.FullName)`r`n"
        }
        
        $reportContent += "`r`n"
    }
}

# Add missing studies section
$reportContent += "## MISSING STUDIES`r`n`r`n"
$missingCount = $totalCount - $foundCount
$reportContent += "Total missing: $missingCount out of $totalCount`r`n`r`n"

foreach ($key in $searchTerms.Keys) {
    $term = $searchTerms[$key]
    
    # Search in main PDFs folder
    $mainResults = Find-Files -folderPath $mainPDFPath -searchTerm $term
    
    # Search in new pdf folder
    $newResults = Find-Files -folderPath $newPDFPath -searchTerm $term
    
    $allResults = $mainResults + $newResults
    
    if ($allResults.Count -eq 0) {
        $reportContent += "### $key`r`n"
        $reportContent += "Search term: $term`r`n`r`n"
    }
}

# Save report
$reportPath = Join-Path $outputFolder "simple_search_report.txt"
$reportContent | Out-File -FilePath $reportPath -Encoding utf8

Write-Host "`r`nSearch complete! Found $foundCount out of $totalCount studies"
Write-Host "Results saved to $outputFolder"
Write-Host "Report saved to $reportPath"
