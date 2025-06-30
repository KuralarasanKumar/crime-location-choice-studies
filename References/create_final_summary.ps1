# Create a final summary report of the organization process

$summaryContent = @"
# FINAL PDF ORGANIZATION SUMMARY

Date: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

## OVERVIEW

We've organized the PDFs for the Crime Location Choice Studies as requested. Here's a summary of what was done:

1. We searched for and identified PDFs corresponding to the 50 studies in the "Crime Location Choice Studies: Units of Analysis" table.
2. We found 40 out of 50 studies (80%) and organized them into individual folders.
3. The remaining 10 studies (20%) could not be found in the available PDF files.

## FOUND STUDIES (40)

S01, S04, S05, S06, S08, S09, S11, S12, S13, S14, S17, S20, S21, S22, S23, S24, S25, S26, S27, S28, S29, S30, S31, S32, S33, S34, S35, S36, S37, S38, S39, S40, S41, S42, S43, S44, S46, S47, S48, S50

## MISSING STUDIES (10)

S02, S03, S07, S10, S15, S16, S18, S19, S45, S49

## ORGANIZATION DETAILS

- All found PDFs have been organized into folders in the "UltraSimpleOrganization" directory.
- Each folder is named after the study ID (e.g., S01, S02) for easy reference.
- A detailed report of all found and missing studies is available in the "Analysis_Results/ultra_simple_report.txt" file.

## RECOMMENDATIONS FOR MISSING STUDIES

To complete the collection, the following studies need to be located:

1. S02: Bernasco et al., 2017 - Do Street Robbery Location Choices Vary Over Time of Day or Day of Week? A Test in Chicago
2. S03: Clare et al., 2009 - Formal evaluation of the impact of barriers and connectors on residential burglars' macro-level offending location choices
3. S07: Lammers, 2017 - Co-offenders' crime location choice: Do co-offending groups commit crimes in their shared awareness space?
4. S10: Xiao et al., 2021 - Burglars blocked by barriers The impact of physical and social barriers on residential burglars target location choices in China
5. S15: Long et al., 2018 - Assessing the influence of prior on subsequent street robbery location choices: A case study in ZG City, China
6. S16: Long et al., 2021 - Ambient population and surveillance cameras: The guardianship role in street robbers' crime location choice
7. S18: Long & Liu, 2022 - Do juvenile, young adult, and adult offenders target different places in the Chinese context?
8. S19: Curtis-Ham et al., 2022 - Relationships Between Offenders' Crime Locations and Different Prior Activity Locations as Recorded in Police Data
9. S45: Yue et al., 2023 - Investigating the effect of people on the street and streetscape physical environment on the location choice of street theft crime offenders using street view images and a discrete spatial choice model
10. S49: Cai et al., 2024 - Divergent decisionmaking in context neighborhood context shapes effects of physical disorder and spatial knowledge on burglars location choice

These studies may need to be downloaded or acquired from academic databases or other sources.
"@

$summaryPath = "c:\Users\kukumar\OneDrive - UGent\Job\crimsyndata\-crime-location-choice-studies\snatching work\References\Analysis_Results\final_organization_summary.txt"
$summaryContent | Out-File -FilePath $summaryPath -Force

Write-Host "Final summary report created at: $summaryPath"
