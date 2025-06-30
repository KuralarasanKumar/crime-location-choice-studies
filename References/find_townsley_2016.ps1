# Very Simple File Finder Script

# Define base paths as strings
$pdfFolder = "C:/Users/kukumar/OneDrive - UGent/Job/crimsyndata/-crime-location-choice-studies/snatching work/References/PDFs"
$outputFolder = "C:/Users/kukumar/OneDrive - UGent/Job/crimsyndata/-crime-location-choice-studies/snatching work/References/FoundTargets" 

# Create output folder
if (!(Test-Path $outputFolder)) {
    New-Item -ItemType Directory -Path $outputFolder -Force
    Write-Output "Created output folder: $outputFolder"
}

# Check for the specific file mentioned in screenshot
$searchPattern = "*Target*selection*models*Townsley*2016*"
$files = Get-ChildItem -Path $pdfFolder -Recurse -Filter "*.pdf" | Where-Object { $_.Name -like $searchPattern }

if ($files.Count -gt 0) {
    Write-Output "Found $($files.Count) files matching '$searchPattern'"
    foreach ($file in $files) {
        Write-Output "Found: $($file.FullName)"
        
        # Copy to output folder
        $destPath = Join-Path $outputFolder "S05_Townsley_2016_Target_Selection_Models.pdf"
        Copy-Item -Path $file.FullName -Destination $destPath -Force
        Write-Output "Copied to: $destPath"
    }
} else {
    Write-Output "No files found matching '$searchPattern'"
}

# Try another pattern
$searchPattern2 = "*Townsley*2016*"
$files2 = Get-ChildItem -Path $pdfFolder -Recurse -Filter "*.pdf" | Where-Object { $_.Name -like $searchPattern2 }

if ($files2.Count -gt 0) {
    Write-Output "`nFound $($files2.Count) files matching broader pattern '$searchPattern2'"
    foreach ($file in $files2) {
        Write-Output "Found: $($file.Name)"
    }
} else {
    Write-Output "`nNo files found matching broader pattern '$searchPattern2'"
}
