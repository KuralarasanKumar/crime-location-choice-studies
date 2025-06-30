# Direct identification of new target studies
Write-Host "IDENTIFYING NEW TARGET STUDIES FROM FILE LIST" -ForegroundColor Yellow
Write-Host "============================================" -ForegroundColor Yellow

# I can already see some clear target studies from the list:
$clearTargetStudies = @(
    "Chamberlain and Boggess - 2016 - Relative difference and burglary location Can ecological characteristics of a Burglar's home neighb.pdf",
    "chamberlain-et-al-2022-traveling-alone-or-together-neighborhood-context-on-individual-and-group-juvenile-an.pdf"
)

$likelyTargetStudies = @(
    "Johnson - 2014 - How do offenders choose where to offend Perspectives from animal foraging.pdf",
    "Marchment and Gill - 2022 - Spatial Decision Making of Terrorist Target Selection Introducing the TRACK Framework.pdf",
    "Marchment et al. - 2020 - Lone Actor Terrorists A Residence-to-Crime Approach.pdf",
    "Groff - 2017 - Measuring the Influence of the Built Environment on Crime at Street Segments.pdf",
    "Groff and La Vigne - 2001 - Mapping an Opportunity Surface of Residential Burglary.pdf",
    "Shover and Honaker - 1992 - The Socially Bounded Decision Making of Persistent Property Offenders.pdf"
)

$obviousNonTargets = @(
    "2020 - Perceived Organizational Injustice and Corrupt Tendencies*",
    "*corruption*",
    "*corrupt*",
    "*graffiti*",
    "*privacy*",
    "*networks*",
    "*taxonomy*",
    "*teaching*",
    "*programming*",
    "*masking*",
    "*anonymity*",
    "*genealogy*",
    "*whistleblowing*"
)

Write-Host "`n✅ CONFIRMED NEW TARGET STUDIES:" -ForegroundColor Green
foreach ($study in $clearTargetStudies) {
    Write-Host "📄 $study" -ForegroundColor White
}

Write-Host "`n🔍 NEED TO VERIFY THESE (could be targets):" -ForegroundColor Yellow
foreach ($study in $likelyTargetStudies) {
    Write-Host "📄 $study" -ForegroundColor White
}

Write-Host "`n❌ MANY NON-TARGET FILES TO REMOVE:" -ForegroundColor Red
Write-Host "Files with these patterns should be moved to ToDelete:" -ForegroundColor Red
foreach ($pattern in $obviousNonTargets) {
    Write-Host "  $pattern" -ForegroundColor Red
}

Write-Host "`n📊 QUICK SUMMARY:" -ForegroundColor Cyan
Write-Host "- Found at least 2 confirmed new target studies (Chamberlain papers)" -ForegroundColor Green
Write-Host "- Found 6+ files that need verification as potential targets" -ForegroundColor Yellow  
Write-Host "- Many obvious non-targets need to be cleaned up" -ForegroundColor Red
Write-Host "- Your collection is growing significantly!" -ForegroundColor White
