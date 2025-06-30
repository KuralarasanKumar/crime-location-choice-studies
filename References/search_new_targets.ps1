# COMPREHENSIVE SEARCH FOR NEW TARGET STUDIES
# After adding ~88 new files, search for target studies

$sourceDir = "c:\Users\kukumar\OneDrive - UGent\Job\crimsyndata\-crime-location-choice-studies\snatching work\References\PDFs"
$deleteDir = "c:\Users\kukumar\OneDrive - UGent\Job\crimsyndata\-crime-location-choice-studies\snatching work\References\PDFs\ToDelete"

Write-Host "🔍 SEARCHING FOR NEW TARGET STUDIES IN 115 FILES" -ForegroundColor Yellow
Write-Host "===============================================" -ForegroundColor Yellow

$allFiles = Get-ChildItem -Path $sourceDir -Name "*.pdf" | Sort-Object
Write-Host "Total files to search: $($allFiles.Count)" -ForegroundColor Cyan

# Target authors and key terms from the table
$targetPatterns = @{
    "Chamberlain_S43" = @("*chamberlain*", "*traveling alone*", "*together*", "*neighborhood context*", "*individual and group*")
    "Chamberlain_S33" = @("*chamberlain*", "*boggess*", "*relative difference*", "*burglary location*", "*ecological*")
    "Baudains" = @("*baudains*", "*target choice*", "*extreme events*", "*london riots*")
    "Jacques" = @("*jacques*", "*dealers*", "*solicit*", "*customers*", "*drugs*")
    "Luykx" = @("*luykx*", "*attractiveness*", "*opportunity*", "*accessibility*", "*burglars*")
    "Nieuwbeerta" = @("*nieuwbeerta*", "*residential burglars*", "*target areas*")
    "Clare" = @("*clare*", "*barriers*", "*connectors*", "*residential burglars*", "*macro-level*")
    "Hanayama" = @("*hanayama*", "*past crime data*", "*attractiveness index*")
    "Johnson_Summers" = @("*johnson*", "*summers*", "*ecological theories*", "*spatial decision*")
    "Lammers" = @("*lammers*", "*biting once*", "*co-offenders*", "*awareness space*")
    "Song" = @("*song*", "*legal activities*", "*mobility flows*", "*thieves*")
    "Xiao" = @("*xiao*", "*blocked by barriers*", "*physical*", "*social barriers*")
    "Yue" = @("*yue*", "*people on street*", "*streetscape*", "*street theft*")
    "Cai" = @("*cai*", "*divergent*", "*neighborhood context*", "*spatial knowledge*")
    "Additional_Frith" = @("*frith*", "*street network*", "*spatial decision*")
}

$newTargetStudies = @()
$likelyNonTargets = @()

Write-Host "`n🎯 SCANNING FOR TARGET STUDIES..." -ForegroundColor Cyan

foreach ($category in $targetPatterns.Keys) {
    $patterns = $targetPatterns[$category]
    
    foreach ($file in $allFiles) {
        $fileName = $file.ToLower()
        $matchCount = 0
        $matchedTerms = @()
        
        foreach ($pattern in $patterns) {
            if ($fileName -like $pattern) {
                $matchCount++
                $matchedTerms += $pattern
            }
        }
        
        if ($matchCount -ge 1) {
            $newTargetStudies += [PSCustomObject]@{
                Category = $category
                File = $file
                MatchCount = $matchCount
                MatchedTerms = ($matchedTerms -join ", ")
            }
        }
    }
}

Write-Host "`n✅ POTENTIAL NEW TARGET STUDIES FOUND:" -ForegroundColor Green
$newTargetStudies | Sort-Object Category, MatchCount -Descending | ForEach-Object {
    Write-Host "📄 $($_.Category): $($_.File)" -ForegroundColor White
    Write-Host "   Matches: $($_.MatchedTerms)" -ForegroundColor Gray
    Write-Host ""
}

# Also search for obvious non-targets that should be moved
$nonTargetKeywords = @(
    "*corruption*", "*corrupt*", "*organizational*", "*injustice*", "*privacy*", "*geoprivacy*",
    "*graffiti*", "*networks*", "*taxonomy*", "*statistics*", "*teaching*", "*programming*",
    "*whistleblowing*", "*freedom of information*", "*genealogy*", "*masking*", "*anonymity*",
    "*tutoring*", "*differential privacy*", "*geographical masking*", "*open data*"
)

Write-Host "`n❌ OBVIOUS NON-TARGET FILES TO MOVE:" -ForegroundColor Red
$nonTargetCount = 0
foreach ($pattern in $nonTargetKeywords) {
    $matches = $allFiles | Where-Object { $_ -like $pattern }
    foreach ($match in $matches) {
        Write-Host "MOVE: $match" -ForegroundColor Red
        $nonTargetCount++
    }
}

Write-Host "`n📊 SUMMARY:" -ForegroundColor Cyan
Write-Host "Potential new target studies: $($newTargetStudies.Count)" -ForegroundColor Green
Write-Host "Obvious non-targets to move: $nonTargetCount" -ForegroundColor Red
Write-Host "Total files analyzed: $($allFiles.Count)" -ForegroundColor White
