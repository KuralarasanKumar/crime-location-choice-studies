# MANUAL VERIFICATION OF ALL FILES AGAINST THE TABLE
# Cross-referencing each file with the target studies table

Write-Host "MANUAL VERIFICATION OF ALL 32 FILES" -ForegroundColor Yellow
Write-Host "===================================" -ForegroundColor Yellow

$files = @(
    "Bernasco - 2010 - A Sentimental Journey To Crime  Effects of Reside.pdf",
    "Bernasco - 2010 - A SENTIMENTAL JOURNEY TO CRIME EFFECTS OF RESIDEN.pdf",
    "Bernasco - 2010 - Modeling Micro-Level Crime Location Choice Applic.pdf",
    "Bernasco - 2019 - Adolescent Offenders' Current Whereabouts Predict .pdf",
    "Bernasco and Block - 2009 - Where offenders choose to attack A discrete choic-1.pdf",
    "Bernasco and Block - 2009 - WHERE OFFENDERS CHOOSE TO ATTACK A DISCRETE CHOIC.pdf",
    "Bernasco and Kooistra - 2010 - Effects of residential history on commercial robbe.pdf",
    "Bernasco et al. - 2013 - Go where the money is modeling street robbers' lo.pdf",
    "Bernasco et al. - 2015 - Learning where to offend Effects of past on futur.pdf",
    "Bernasco et al. - 2017 - Social Interactions and Crime Revisited An Invest.pdf",
    "Curtis-Ham et al. - 2022 - The Importance of Importance Sampling Exploring M.pdf",
    "Curtis-Ham et al. - 2025 - Familiar Locations and Similar Activities Examining the Contributions of Reliable and Relevant Know-1.pdf",
    "Curtis-Ham et al. - 2025 - Familiar Locations and Similar Activities Examining the Contributions of Reliable and Relevant Know.pdf",
    "Curtis-Ham et al. - Relationships Between Offenders' Crime Locations a.pdf",
    "Frith - 2019 - Modelling taste heterogeneity regarding offence lo.pdf",
    "Gill et al. - 2019 - The Rational Foraging Terrorist Analysing the Distances Travelled to Commit Terrorist Violence-1.pdf",
    "Gill et al. - 2019 - The Rational Foraging Terrorist Analysing the Distances Travelled to Commit Terrorist Violence.pdf",
    "Kuralarasan and Bernasco - 2022 - Location Choice of Snatching Offenders in Chennai .pdf",
    "Langton and Steenbeek - 2017 - Residential burglary target selection An analysis.pdf",
    "Long and Liu - 2021 - Do Migrant and Native Robbers Target Different Pla.pdf",
    "Marchment and Gill - 2019 - Modelling the spatial decision making of terrorist.pdf",
    "Menting - 2018 - AWARENESS x OPPORTUNITY TESTING INTERACTIONS BETW.pdf",
    "Rowan et al. - 2022 - Situating Crime Pattern Theory Into The Explanation Of Co-Offending Considering Area-Level Converge.pdf",
    "Smith and Brown - 2007 - Discrete choice analysis of spatial attack sites-1.pdf",
    "Smith and Brown - 2007 - Discrete choice analysis of spatial attack sites.pdf",
    "Townsley et al. - 2015 - Burglar Target Selection A Cross-national Compari.pdf",
    "van Sleeuwen et al. - 2021 - When Do Offenders Commit Crime An Analysis of Tem.pdf",
    "Vandeviver and Bernasco - 2020 - Location, Location, Location Effects of Neighbo.pdf",
    "Xue and Brown - 2006 - Spatial analysis with preference specification of .pdf",
    "Xue and Brown - 2006 - Spatial analysis with preference specification of latent decision makers for criminal event predicti-1.pdf",
    "Xue and Brown - 2006 - Spatial analysis with preference specification of latent decision makers for criminal event predicti.pdf",
    "Yifei Xue and Brown - 2003 - A decision model for spatial site selection by criminals a foundation for law enforcement decision.pdf"
)

# Files that need further investigation
$needInvestigation = @(
    "Bernasco et al. - 2017 - Social Interactions and Crime Revisited An Invest.pdf",
    "Gill et al. - 2019 - The Rational Foraging Terrorist Analysing the Distances Travelled to Commit Terrorist Violence-1.pdf",
    "Gill et al. - 2019 - The Rational Foraging Terrorist Analysing the Distances Travelled to Commit Terrorist Violence.pdf",
    "van Sleeuwen et al. - 2021 - When Do Offenders Commit Crime An Analysis of Tem.pdf",
    "Yifei Xue and Brown - 2003 - A decision model for spatial site selection by criminals a foundation for law enforcement decision.pdf"
)

Write-Host "`nFILES THAT NEED TITLE VERIFICATION:" -ForegroundColor Red
foreach ($file in $needInvestigation) {
    Write-Host "CHECK: $file" -ForegroundColor Yellow
}

Write-Host "`nPOSSIBLE ADDITIONAL TARGET STUDIES:" -ForegroundColor Cyan

# Check if "Social Interactions and Crime Revisited" could be S02
Write-Host "1. 'Social Interactions and Crime Revisited' - Could this be S02 'Do Street Robbery Location Choices Vary Over Time'?" -ForegroundColor Yellow

# Check Gill "Rational Foraging" papers
Write-Host "2. Gill 'Rational Foraging Terrorist' papers - Are these in your table? Need to verify." -ForegroundColor Yellow

# Check van Sleeuwen "When Do Offenders Commit Crime"
Write-Host "3. van Sleeuwen 'When Do Offenders Commit Crime' - Could this be S22 'Right place, right time'?" -ForegroundColor Yellow

# Check Yifei Xue 2003 paper
Write-Host "4. Yifei Xue & Brown 2003 - Could this be related to S54 or another Xue study?" -ForegroundColor Yellow

Write-Host "`nRECOMMENDATION:" -ForegroundColor Green
Write-Host "You should manually check the actual content/titles of these 5 files to see if they match studies in your table." -ForegroundColor White
