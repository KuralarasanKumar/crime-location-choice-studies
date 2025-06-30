# SIMPLE BUT COMPREHENSIVE SEARCH FOR ALL TARGET STUDIES
$sourceDir = "c:\Users\kukumar\OneDrive - UGent\Job\crimsyndata\-crime-location-choice-studies\snatching work\References\PDFs"

Write-Host "COMPREHENSIVE SEARCH FOR ALL TARGET STUDIES" -ForegroundColor Yellow
Write-Host "===========================================" -ForegroundColor Yellow

$allFiles = Get-ChildItem -Path $sourceDir -Name "*.pdf" | Sort-Object
Write-Host "Searching through $($allFiles.Count) files..." -ForegroundColor Cyan

# Search for specific authors and key terms that might be missed
$additionalSearches = @{
    "Chamberlain" = @("*chamberlain*")
    "Baudains" = @("*baudains*")
    "Jacques" = @("*jacques*")
    "Luykx" = @("*luykx*")
    "Nieuwbeerta" = @("*nieuwbeerta*")
    "Clare" = @("*clare*")
    "Hanayama" = @("*hanayama*")
    "Johnson_Summers" = @("*johnson*", "*summers*")
    "Lammers" = @("*lammers*")
    "Song" = @("*song*")
    "Xiao" = @("*xiao*")
    "Yue" = @("*yue*")
    "Cai" = @("*cai*")
    "Appleby" = @("*appleby*")
    "Boggess" = @("*boggess*")
    "Block" = @("*block*")
}

Write-Host "`nSEARCHING FOR POTENTIALLY MISSED AUTHORS:" -ForegroundColor Green

$newFinds = @()
foreach ($authorGroup in $additionalSearches.Keys) {
    $patterns = $additionalSearches[$authorGroup]
    
    foreach ($pattern in $patterns) {
        $matches = $allFiles | Where-Object { $_ -like $pattern }
        if ($matches) {
            foreach ($match in $matches) {
                $newFinds += [PSCustomObject]@{
                    Author = $authorGroup
                    File = $match
                    Pattern = $pattern
                }
                Write-Host "FOUND: $authorGroup - $match" -ForegroundColor Green
            }
        }
    }
}

Write-Host "`nSEARCHING FOR KEY TERMS THAT MIGHT INDICATE TARGET STUDIES:" -ForegroundColor Cyan

# Search for specific terms that appear in target studies
$keyTerms = @(
    "*burglary*", "*robbery*", "*robbers*", "*offenders*", "*crime location*",
    "*spatial decision*", "*discrete choice*", "*target selection*", "*location choice*",
    "*activity space*", "*awareness space*", "*crime pattern*", "*routine activities*",
    "*co-offending*", "*residential*", "*commercial*", "*street*", "*neighborhood*",
    "*ecological*", "*environmental*", "*spatial*", "*mobility*", "*accessibility*"
)

$termMatches = @()
foreach ($term in $keyTerms) {
    $matches = $allFiles | Where-Object { $_ -like $term }
    foreach ($match in $matches) {
        $termMatches += [PSCustomObject]@{
            Term = $term
            File = $match
        }
    }
}

# Group by file to see which files have multiple relevant terms
$fileGroups = $termMatches | Group-Object File | Where-Object { $_.Count -ge 3 } | Sort-Object Count -Descending

Write-Host "`nFILES WITH MULTIPLE CRIME/LOCATION TERMS (potential targets):" -ForegroundColor Yellow
foreach ($group in $fileGroups) {
    Write-Host "FILE: $($group.Name) (matches $($group.Count) terms)" -ForegroundColor White
    $terms = ($group.Group | Select-Object -ExpandProperty Term | Sort-Object -Unique) -join ", "
    Write-Host "  Terms: $terms" -ForegroundColor Gray
}

Write-Host "`nCHECKING FOR AUTHOR COMBINATIONS:" -ForegroundColor Magenta

# Check for files that might have multiple authors from our target list
$targetAuthorLastNames = @("Bernasco", "Curtis-Ham", "Chamberlain", "Baudains", "Jacques", "Luykx", 
                          "Nieuwbeerta", "Clare", "Frith", "Hanayama", "Johnson", "Summers", "Kuralarasan",
                          "Lammers", "Langton", "Steenbeek", "Long", "Liu", "Marchment", "Gill",
                          "Menting", "van Sleeuwen", "Song", "Townsley", "Vandeviver", "Xiao", "Xue", 
                          "Brown", "Yue", "Rowan", "Appleby", "McGloin", "Smith", "Cai", "Block", "Kooistra")

foreach ($file in $allFiles) {
    $authorCount = 0
    $foundAuthors = @()
    
    foreach ($author in $targetAuthorLastNames) {
        if ($file -like "*$author*") {
            $authorCount++
            $foundAuthors += $author
        }
    }
    
    if ($authorCount -ge 1) {
        Write-Host "AUTHOR MATCH: $file" -ForegroundColor Green
        Write-Host "  Authors: $($foundAuthors -join ', ')" -ForegroundColor Gray
    }
}

Write-Host "`nSUMMARY OF COMPREHENSIVE SEARCH COMPLETE" -ForegroundColor Cyan
