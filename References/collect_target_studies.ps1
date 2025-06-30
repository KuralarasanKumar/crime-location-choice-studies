# Collect Target Studies Script
# This script copies specific target studies from search results to an organized folder

$rootFolder = "c:\Users\kukumar\OneDrive - UGent\Job\crimsyndata\-crime-location-choice-studies\snatching work\References"
$destinationFolder = Join-Path $rootFolder "FinalOrganizedStudies"

# Create destination folder if it doesn't exist
if (-not (Test-Path $destinationFolder)) {
    New-Item -ItemType Directory -Path $destinationFolder -Force
}

# Define specific file paths to copy
$filesToCopy = @{
    "S05_Townsley_2016_Target_Selection_Models.pdf" = "C:\Users\kukumar\OneDrive - UGent\Job\crimsyndata\-crime-location-choice-studies\snatching work\References\new pdf\My Library\files\39898\Townsley et al. - 2016 - Target Selection Models with Preference Variation .pdf"
    "S04-12-25_Townsley_2015_Burglar_Target_Selection.pdf" = "C:\Users\kukumar\OneDrive - UGent\Job\crimsyndata\-crime-location-choice-studies\snatching work\References\new pdf\My Library\files\31019\Townsley et al. - 2015 - Burglar Target Selection A Cross-national Compari.pdf"
    "S01_Bernasco_2013_Go_where_the_money_is.pdf" = "c:\Users\kukumar\OneDrive - UGent\Job\crimsyndata\-crime-location-choice-studies\snatching work\References\PDFs\Bernasco et al. - 2013 - Go where the money is modeling street robbers' lo.pdf"
    "S30_Bernasco_2019_Adolescent_offenders.pdf" = "c:\Users\kukumar\OneDrive - UGent\Job\crimsyndata\-crime-location-choice-studies\snatching work\References\PDFs\Bernasco - 2019 - Adolescent Offenders' Current Whereabouts Predict .pdf"
    "S50_Curtis-Ham_2025_familiar_locations.pdf" = "c:\Users\kukumar\OneDrive - UGent\Job\crimsyndata\-crime-location-choice-studies\snatching work\References\PDFs\Curtis-Ham et al. - 2025 - Familiar Locations and Similar Activities Examining the Contributions of Reliable and Relevant Know.pdf"
    "S11_Kuralarasan_2022_Location_Choice.pdf" = "c:\Users\kukumar\OneDrive - UGent\Job\crimsyndata\-crime-location-choice-studies\snatching work\References\PDFs\Kuralarasan and Bernasco - 2022 - Location Choice of Snatching Offenders in Chennai .pdf"
    "S13_Menting_2018_Awareness_Opportunity.pdf" = "c:\Users\kukumar\OneDrive - UGent\Job\crimsyndata\-crime-location-choice-studies\snatching work\References\PDFs\Menting - 2018 - AWARENESS x OPPORTUNITY TESTING INTERACTIONS BETW.pdf"
    "S17_Long_Liu_2021_Migrant_Native_Robbers.pdf" = "c:\Users\kukumar\OneDrive - UGent\Job\crimsyndata\-crime-location-choice-studies\snatching work\References\PDFs\Long and Liu - 2021 - Do Migrant and Native Robbers Target Different Pla.pdf"
    "S20_Vandeviver_2020_Location_Location.pdf" = "c:\Users\kukumar\OneDrive - UGent\Job\crimsyndata\-crime-location-choice-studies\snatching work\References\PDFs\Vandeviver and Bernasco - 2020 - Location, Location, Location Effects of Neighbo.pdf"
    "S28_Frith_2019_Modelling_taste.pdf" = "c:\Users\kukumar\OneDrive - UGent\Job\crimsyndata\-crime-location-choice-studies\snatching work\References\PDFs\Frith - 2019 - Modelling taste heterogeneity regarding offence lo.pdf"
    "S41_Langton_Steenbeek_2017_Residential_burglary.pdf" = "c:\Users\kukumar\OneDrive - UGent\Job\crimsyndata\-crime-location-choice-studies\snatching work\References\PDFs\Langton and Steenbeek - 2017 - Residential burglary target selection An analysis.pdf"
    "S42_Marchment_Gill_2019_spatial_decision_making.pdf" = "c:\Users\kukumar\OneDrive - UGent\Job\crimsyndata\-crime-location-choice-studies\snatching work\References\PDFs\Marchment and Gill - 2019 - Modelling the spatial decision making of terrorist.pdf"
    "S33_Chamberlain_2016_Relative_Difference.pdf" = "c:\Users\kukumar\OneDrive - UGent\Job\crimsyndata\-crime-location-choice-studies\snatching work\References\PDFs\Chamberlain and Boggess - 2016 - Relative difference and burglary location Can ecological characteristics of a Burglar's home neighb.pdf"
    "S43_Chamberlain_2022_Traveling_Alone.pdf" = "c:\Users\kukumar\OneDrive - UGent\Job\crimsyndata\-crime-location-choice-studies\snatching work\References\PDFs\chamberlain-et-al-2022-traveling-alone-or-together-neighborhood-context-on-individual-and-group-juvenile-an.pdf"
    "S47_Rowan_2022_Crime_Pattern_Theory.pdf" = "c:\Users\kukumar\OneDrive - UGent\Job\crimsyndata\-crime-location-choice-studies\snatching work\References\PDFs\Rowan et al. - 2022 - Situating Crime Pattern Theory Into The Explanation Of Co-Offending Considering Area-Level Converge.pdf"
    "S48_Smith_Brown_2007_spatial_attack_sites.pdf" = "c:\Users\kukumar\OneDrive - UGent\Job\crimsyndata\-crime-location-choice-studies\snatching work\References\PDFs\Smith and Brown - 2007 - Discrete choice analysis of spatial attack sites.pdf"
    "S27_Bernasco_2015_Learning_where_to_offend.pdf" = "c:\Users\kukumar\OneDrive - UGent\Job\crimsyndata\-crime-location-choice-studies\snatching work\References\PDFs\Bernasco et al. - 2015 - Learning where to offend Effects of past on futur.pdf"
    "S32_Bernasco_Block_2009_Where_offenders_choose.pdf" = "c:\Users\kukumar\OneDrive - UGent\Job\crimsyndata\-crime-location-choice-studies\snatching work\References\PDFs\Bernasco and Block - 2009 - Where offenders choose to attack A discrete choic-1.pdf"
    "S36_Bernasco_Kooistra_2010_Effects_Residential.pdf" = "c:\Users\kukumar\OneDrive - UGent\Job\crimsyndata\-crime-location-choice-studies\snatching work\References\PDFs\Bernasco and Kooistra - 2010 - Effects of residential history on commercial robbe.pdf"
    "S02_Bernasco_2017_Do_Street_Robbery.pdf" = "C:\Users\kukumar\OneDrive - UGent\Job\crimsyndata\-crime-location-choice-studies\snatching work\References\new pdf\My Library\files\13824\Bernasco et al. - 2017 - Social Interactions and Crime Revisited An Invest.pdf"
    "S19_Curtis-Ham_2022_Relationships.pdf" = "c:\Users\kukumar\OneDrive - UGent\Job\crimsyndata\-crime-location-choice-studies\snatching work\References\PDFs\Curtis-Ham et al. - Relationships Between Offenders' Crime Locations a.pdf"
    "S44_Curtis-Ham_2022_Importance_Sampling.pdf" = "c:\Users\kukumar\OneDrive - UGent\Job\crimsyndata\-crime-location-choice-studies\snatching work\References\PDFs\Curtis-Ham et al. - 2022 - The Importance of Importance Sampling Exploring M.pdf"
}

# Report content
$reportContent = "# TARGET STUDIES ORGANIZATION REPORT`r`n`r`n"
$reportContent += "Created on $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')`r`n`r`n"
$reportContent += "Destination folder: $destinationFolder`r`n`r`n"
$reportContent += "## COPIED FILES`r`n`r`n"

$successCount = 0
$errorCount = 0

foreach ($destFile in $filesToCopy.Keys) {
    $sourcePath = $filesToCopy[$destFile]
    $destPath = Join-Path $destinationFolder $destFile
    
    try {
        if (Test-Path $sourcePath) {
            Copy-Item -Path $sourcePath -Destination $destPath -Force
            $reportContent += "✅ $destFile`r`n"
            $reportContent += "  Source: $sourcePath`r`n`r`n"
            $successCount++
        }
        else {
            $reportContent += "❌ $destFile - SOURCE FILE NOT FOUND`r`n"
            $reportContent += "  Source path: $sourcePath`r`n`r`n"
            $errorCount++
        }
    }
    catch {
        $reportContent += "❌ $destFile - ERROR: $($_.Exception.Message)`r`n"
        $reportContent += "  Source path: $sourcePath`r`n`r`n"
        $errorCount++
    }
}

$reportContent += "`r`n## SUMMARY`r`n`r`n"
$reportContent += "Successfully copied: $successCount files`r`n"
$reportContent += "Failed to copy: $errorCount files`r`n"
$reportContent += "Total files attempted: $($filesToCopy.Count) files`r`n"

# Save report
$reportFile = Join-Path $rootFolder "final_organization_report.txt"
$reportContent | Out-File -FilePath $reportFile -Encoding utf8

Write-Host "File copying complete!"
Write-Host "Successfully copied: $successCount files"
Write-Host "Failed to copy: $errorCount files"
Write-Host "Report saved to: $reportFile"
