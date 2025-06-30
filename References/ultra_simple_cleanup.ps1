# Ultra Simple Cleanup Script
# This script will move all PDFs that are not part of the target studies to a ToDelete folder

$workspaceRoot = "c:\Users\kukumar\OneDrive - UGent\Job\crimsyndata\-crime-location-choice-studies\snatching work"
$referencesDir = Join-Path $workspaceRoot "References"
$finalDir = Join-Path $referencesDir "UltraSimpleOrganization"
$pdfDir = Join-Path $referencesDir "PDFs"
$toDeleteDir = Join-Path $pdfDir "ToDelete"

# Create ToDelete directory if it doesn't exist
if (-not (Test-Path $toDeleteDir)) {
    New-Item -Path $toDeleteDir -ItemType Directory -Force | Out-Null
}

# Get all PDFs in the organized folders (these are the target studies we want to keep)
$organizedPDFs = Get-ChildItem -Path $finalDir -Filter "*.pdf" -Recurse | 
    ForEach-Object { $_.Name }

Write-Host "Found $($organizedPDFs.Count) organized target PDFs"

$movedCount = 0
$keptCount = 0

# Process PDFs in the main PDFs directory
if (Test-Path $pdfDir) {
    $pdfs = Get-ChildItem -Path $pdfDir -Filter "*.pdf" -File | 
        Where-Object { $_.DirectoryName -ne $toDeleteDir }
    
    Write-Host "Found $($pdfs.Count) PDFs in main PDFs directory"
    
    foreach ($pdf in $pdfs) {
        $isTarget = $false
        
        foreach ($targetPDF in $organizedPDFs) {
            if ($pdf.Name -eq $targetPDF) {
                $isTarget = $true
                break
            }
        }
        
        if (-not $isTarget) {
            # Not a target study, move to ToDelete
            try {
                Move-Item -Path $pdf.FullName -Destination (Join-Path $toDeleteDir $pdf.Name) -Force
                $movedCount++
                Write-Host "Moved to ToDelete: $($pdf.Name)"
            }
            catch {
                Write-Host "Error moving $($pdf.Name): $_"
            }
        } else {
            $keptCount++
            Write-Host "Kept (relevant): $($pdf.Name)"
        }
    }
}

Write-Host "`nCleanup Results:"
Write-Host "PDFs kept as relevant: $keptCount"
Write-Host "PDFs moved to ToDelete: $movedCount"
