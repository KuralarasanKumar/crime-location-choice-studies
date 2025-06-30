# DOI and Citation Finder for Missing Studies

$missingStudies = @(
    @{
        "SNo" = "S03"
        "Authors" = "Clare, J., Fernandez, J., & Morgan, F."
        "Year" = "2009"
        "Title" = "Formal evaluation of the impact of barriers and connectors on residential burglars' macro-level offending location choices"
        "Journal" = "Australian & New Zealand Journal of Criminology"
        "SearchTerms" = @("Clare", "barriers", "connectors", "burglars", "macro-level")
        "DOI" = "10.1375/acri.42.2.139"
    },
    @{
        "SNo" = "S05"
        "Authors" = "Townsley, M., Johnson, S. D., & Ratcliffe, J. H."
        "Year" = "2016"
        "Title" = "Target Selection Models with Preference Variation Between Offenders"
        "Journal" = "Journal of Quantitative Criminology"
        "SearchTerms" = @("Townsley", "Target Selection", "Preference Variation", "2016")
        "DOI" = "10.1007/s10940-015-9264-7"
    },
    @{
        "SNo" = "S06"
        "Authors" = "Lammers, M., Menting, B., Ruiter, S., & Bernasco, W."
        "Year" = "2015"
        "Title" = "Biting Once, Twice: the Influence of Prior on Subsequent Crime Location Choice"
        "Journal" = "Criminology"
        "SearchTerms" = @("Lammers", "Biting Once Twice", "Prior", "Subsequent", "Crime Location")
        "DOI" = "10.1111/1745-9125.12077"
    },
    @{
        "SNo" = "S07"
        "Authors" = "Lammers, M."
        "Year" = "2017"
        "Title" = "Co-offenders' crime location choice: Do co-offending groups commit crimes in their shared awareness space?"
        "Journal" = "British Journal of Criminology"
        "SearchTerms" = @("Lammers", "Co-offenders", "shared awareness space", "2017")
        "DOI" = "10.1093/bjc/azx027"
    },
    @{
        "SNo" = "S08"
        "Authors" = "Menting, B., Lammers, M., Ruiter, S., & Bernasco, W."
        "Year" = "2016"
        "Title" = "Family Matters: Effects of Family Members' Residential Areas on Crime Location Choice"
        "Journal" = "Criminology"
        "SearchTerms" = @("Menting", "Family Matters", "Family Members", "Residential Areas")
        "DOI" = "10.1111/1745-9125.12109"
    },
    @{
        "SNo" = "S09"
        "Authors" = "van Sleeuwen, S. E. M., Ruiter, S., & Menting, B."
        "Year" = "2018"
        "Title" = "A Time for a Crime: Temporal Aspects of Repeat Offenders' Crime Location Choices"
        "Journal" = "Journal of Research in Crime and Delinquency"
        "SearchTerms" = @("van Sleeuwen", "Time for Crime", "Temporal Aspects", "Repeat Offenders")
        "DOI" = "10.1177/0022427817739999"
    },
    @{
        "SNo" = "S10"
        "Authors" = "Xiao, L., Liu, L., Song, G., Ruiter, S., & Zhou, S."
        "Year" = "2021"
        "Title" = "Burglars blocked by barriers: The impact of physical and social barriers on residential burglars' target location choices in China"
        "Journal" = "Applied Geography"
        "SearchTerms" = @("Xiao", "Burglars blocked", "barriers", "China", "2021")
        "DOI" = "10.1016/j.apgeog.2021.102464"
    },
    @{
        "SNo" = "S14"
        "Authors" = "Song, G., Liu, L., Bernasco, W., Xiao, L., Zhou, S., & Liao, W."
        "Year" = "2019"
        "Title" = "Crime Feeds on Legal Activities: Daily Mobility Flows Help to Explain Thieves' Target Location Choices"
        "Journal" = "Journal of Quantitative Criminology"
        "SearchTerms" = @("Song", "Crime Feeds", "Legal Activities", "Daily Mobility", "Thieves")
        "DOI" = "10.1007/s10940-018-9404-5"
    },
    @{
        "SNo" = "S15"
        "Authors" = "Long, D., Liu, L., Feng, J., Zhou, S., & Jing, F."
        "Year" = "2018"
        "Title" = "Assessing the influence of prior on subsequent street robbery location choices: A case study in ZG City, China"
        "Journal" = "Cities"
        "SearchTerms" = @("Long", "prior", "subsequent", "street robbery", "ZG City")
        "DOI" = "10.1016/j.cities.2018.05.016"
    },
    @{
        "SNo" = "S16"
        "Authors" = "Long, D., Liu, L., Xu, M., Chen, J., & Lu, Y."
        "Year" = "2021"
        "Title" = "Ambient population and surveillance cameras: The guardianship role in street robbers' crime location choice"
        "Journal" = "Cities"
        "SearchTerms" = @("Long", "Ambient population", "surveillance cameras", "guardianship", "street robbers")
        "DOI" = "10.1016/j.cities.2021.103140"
    },
    @{
        "SNo" = "S18"
        "Authors" = "Long, D., & Liu, L."
        "Year" = "2022"
        "Title" = "Do juvenile, young adult, and adult offenders target different places in the Chinese context?"
        "Journal" = "Crime Science"
        "SearchTerms" = @("Long", "Liu", "juvenile", "young adult", "adult offenders", "Chinese")
        "DOI" = "10.1186/s40163-022-00162-4"
    },
    @{
        "SNo" = "S21"
        "Authors" = "Menting, B., Lammers, M., Ruiter, S., & Bernasco, W."
        "Year" = "2020"
        "Title" = "The Influence of Activity Space and Visiting Frequency on Crime Location Choice: Findings from an Online Self-Report Survey"
        "Journal" = "British Journal of Criminology"
        "SearchTerms" = @("Menting", "Activity Space", "Visiting Frequency", "Online Self-Report")
        "DOI" = "10.1093/bjc/azz060"
    },
    @{
        "SNo" = "S23"
        "Authors" = "Bernasco, W., & Nieuwbeerta, P."
        "Year" = "2005"
        "Title" = "How do residential burglars select target areas?: A new approach to the analysis of criminal location choice"
        "Journal" = "Criminology"
        "SearchTerms" = @("Bernasco", "Nieuwbeerta", "residential burglars", "target areas", "criminal location choice")
        "DOI" = "10.1111/j.1745-9125.2005.00020.x"
    },
    @{
        "SNo" = "S29"
        "Authors" = "Hanayama, N., Ito, A., & Takahashi, H."
        "Year" = "2018"
        "Title" = "The usefulness of past crime data as an attractiveness index for residential burglars"
        "Journal" = "Security Journal"
        "SearchTerms" = @("Hanayama", "past crime data", "attractiveness index", "residential burglars")
        "DOI" = "10.1057/s41284-017-0099-8"
    },
    @{
        "SNo" = "S31"
        "Authors" = "Bernasco, W., & Jacques, S."
        "Year" = "2015"
        "Title" = "Where Do Dealers Solicit Customers and Sell Them Drugs? A Discrete Choice Analysis of Dealers' Location Choices"
        "Journal" = "Journal of Research in Crime and Delinquency"
        "SearchTerms" = @("Bernasco", "Jacques", "Dealers", "Solicit", "Customers", "Drugs")
        "DOI" = "10.1177/0022427814567314"
    },
    @{
        "SNo" = "S33"
        "Authors" = "Chamberlain, A. W., & Boggess, L. N."
        "Year" = "2016"
        "Title" = "Relative Difference and Burglary Location: Can Ecological Characteristics of a Burglar's Home Neighborhood Predict Offense Location?"
        "Journal" = "Crime & Delinquency"
        "SearchTerms" = @("Chamberlain", "Boggess", "Relative Difference", "Burglary Location", "Ecological")
        "DOI" = "10.1177/0011128714541204"
    },
    @{
        "SNo" = "S38"
        "Authors" = "Baudains, P., Braithwaite, A., & Johnson, S. D."
        "Year" = "2013"
        "Title" = "Target Choice During Extreme Events: A Discrete Spatial Choice Model of the 2011 London Riots"
        "Journal" = "Criminology"
        "SearchTerms" = @("Baudains", "Target Choice", "Extreme Events", "London Riots", "2011")
        "DOI" = "10.1111/1745-9125.12004"
    },
    @{
        "SNo" = "S39"
        "Authors" = "Johnson, S. D., & Summers, L."
        "Year" = "2015"
        "Title" = "Testing Ecological Theories of Offender Spatial Decision Making Using a Discrete Choice Model"
        "Journal" = "Crime and Delinquency"
        "SearchTerms" = @("Johnson", "Summers", "Ecological Theories", "Offender Spatial", "Discrete Choice")
        "DOI" = "10.1177/0011128713512471"
    },
    @{
        "SNo" = "S40"
        "Authors" = "Vandeviver, C., Van Daele, S., & Vander Beken, T."
        "Year" = "2015"
        "Title" = "A discrete spatial choice model of burglary target selection at the house-level"
        "Journal" = "Applied Geography"
        "SearchTerms" = @("Vandeviver", "discrete spatial choice", "burglary target", "house-level")
        "DOI" = "10.1016/j.apgeog.2015.04.004"
    },
    @{
        "SNo" = "S43"
        "Authors" = "Chamberlain, A., Drawve, G., & Holt, T. J."
        "Year" = "2022"
        "Title" = "Traveling Alone or Together? Neighborhood Context on Individual and Group Juvenile and Adult Burglary Decisions"
        "Journal" = "Justice Quarterly"
        "SearchTerms" = @("Chamberlain", "Traveling Alone", "Together", "Neighborhood Context", "Juvenile")
        "DOI" = "10.1080/07418825.2020.1777833"
    },
    @{
        "SNo" = "S45"
        "Authors" = "Yue, H., Zhu, X., Ye, X., & Guo, W."
        "Year" = "2023"
        "Title" = "Investigating the effect of people on the street and streetscape physical environment on the location choice of street theft crime offenders using street view images and a discrete spatial choice model"
        "Journal" = "ISPRS International Journal of Geo-Information"
        "SearchTerms" = @("Yue", "people on street", "streetscape", "street theft", "street view")
        "DOI" = "10.3390/ijgi12030103"
    },
    @{
        "SNo" = "S47"
        "Authors" = "Rowan, Z. R., Appleby, R. D., & McGloin, J. M."
        "Year" = "2022"
        "Title" = "Situating Crime Pattern Theory Into The Explanation Of Co-Offending: Considering Area-Level Convergence Spaces"
        "Journal" = "British Journal of Criminology"
        "SearchTerms" = @("Rowan", "Appleby", "McGloin", "Crime Pattern Theory", "Co-Offending")
        "DOI" = "10.1093/bjc/azab093"
    },
    @{
        "SNo" = "S49"
        "Authors" = "Cai, J., Huang, B., & Song, Y."
        "Year" = "2024"
        "Title" = "divergent decisionmaking in context neighborhood context shapes effects of physical disorder and spatial knowledge on burglars location choice"
        "Journal" = "Not published in journal"
        "SearchTerms" = @("Cai", "divergent", "decisionmaking", "neighborhood context", "physical disorder")
        "DOI" = "Not available"
    }
)

Write-Host "=== DOWNLOAD LINKS GENERATOR ===" -ForegroundColor Yellow
Write-Host "Creating search links for all missing studies..." -ForegroundColor Cyan
Write-Host ""

foreach ($study in $missingStudies) {
    Write-Host "=== $($study.SNo): $($study.Authors) ($($study.Year)) ===" -ForegroundColor Green
    Write-Host "Title: $($study.Title)" -ForegroundColor White
    Write-Host "Journal: $($study.Journal)" -ForegroundColor Gray
    
    if ($study.DOI -ne "Not available") {
        Write-Host "DOI: $($study.DOI)" -ForegroundColor Cyan
        Write-Host "DOI Link: https://doi.org/$($study.DOI)" -ForegroundColor Blue
    }
    
    # Generate search URLs
    $searchTitle = $study.Title -replace '[^\w\s]', '' -replace '\s+', '+'
    $googleScholarUrl = "https://scholar.google.com/scholar?q=" + $searchTitle
    $researchGateUrl = "https://www.researchgate.net/search?q=" + $searchTitle
    
    Write-Host "Google Scholar: $googleScholarUrl" -ForegroundColor Magenta
    Write-Host "ResearchGate: $researchGateUrl" -ForegroundColor Magenta
    Write-Host ""
}

Write-Host "=== BATCH DOWNLOAD TIPS ===" -ForegroundColor Yellow
Write-Host "1. Copy DOI links and paste into your university library's DOI resolver" -ForegroundColor White
Write-Host "2. Use Google Scholar links to find open access versions" -ForegroundColor White
Write-Host "3. Check ResearchGate for author-shared copies" -ForegroundColor White
Write-Host "4. Contact authors directly if papers are behind paywalls" -ForegroundColor White
