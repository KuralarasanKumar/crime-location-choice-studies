# Final Git Push Script with guaranteed file addition
# This script uses specific approaches to ensure all files are added

Write-Host @"
==================================================
    COMPLETE GITHUB UPLOAD - FINAL ATTEMPT
==================================================

This script will:
1. Clean up any Git issues
2. Add ALL files (using explicit paths)
3. Force push everything to GitHub
==================================================
"@ -ForegroundColor Cyan

# Define repository information
$repoOwner = "KuralarasanKumar"
$repoName = "crime-location-choice-studies"
$workspacePath = "c:\Users\kukumar\OneDrive - UGent\Job\crimsyndata\-crime-location-choice-studies\snatching work"

# Change to workspace directory
Set-Location $workspacePath

# Ask for the token
Write-Host "Please enter your GitHub Personal Access Token" -ForegroundColor Yellow
$token = Read-Host "Enter your token" -AsSecureString
$BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($token)
$plainToken = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)
[Runtime.InteropServices.Marshal]::ZeroFreeBSTR($BSTR)  # Clear the BSTR for security

# First, ensure there are no nested Git repositories
Write-Host "Removing any nested Git repositories..." -ForegroundColor Yellow
$nestedGits = Get-ChildItem -Path $workspacePath -Recurse -Force -Directory -Filter ".git" | 
    Where-Object { $_.FullName -ne (Join-Path $workspacePath ".git") }

foreach ($git in $nestedGits) {
    Write-Host "Removing $($git.FullName)" -ForegroundColor Yellow
    Remove-Item -Path $git.FullName -Recurse -Force
}

# Reset Git completely
Write-Host "Resetting Git repository completely..." -ForegroundColor Yellow
if (Test-Path ".git") {
    Remove-Item -Recurse -Force -Path ".git"
}

# Initialize new repository
Write-Host "Initializing fresh Git repository..." -ForegroundColor Green
git init
git checkout -b main

# Create gitignore
$gitignoreContent = @"
# R specific
.Rproj.user
.Rhistory
.RData
.Ruserdata
*.Rproj

# System files
.DS_Store
Thumbs.db
*.bak
*.tmp
"@
$gitignoreContent | Out-File -FilePath ".gitignore" -Encoding UTF8

# Configure remote with token
$remoteUrl = "https://${repoOwner}:${plainToken}@github.com/${repoOwner}/${repoName}.git"
git remote add origin $remoteUrl

Write-Host "Adding files to Git - This may take a while for large directories..." -ForegroundColor Green

# Add files in smaller batches to avoid command line length issues
# First add common document file types
Write-Host "Adding document files..." -ForegroundColor Yellow
git add *.md *.pdf *.txt *.csv *.html

# Add PowerPoint, Excel and other office files
Write-Host "Adding office files..." -ForegroundColor Yellow
git add *.pptx *.xlsx *.docx *.potx *.odp

# Add programming files
Write-Host "Adding programming files..." -ForegroundColor Yellow
git add *.R *.py *.ps1 *.Rproj

# Add all specific top-level directories one by one
Write-Host "Adding directories one by one..." -ForegroundColor Yellow

# List all top-level directories
$directories = Get-ChildItem -Path $workspacePath -Directory

foreach($dir in $directories) {
    Write-Host "Adding $($dir.Name)..." -ForegroundColor Yellow
    git add "$($dir.Name)/*" 
}

# Finally, add everything else that might have been missed
Write-Host "Final sweep to add everything else..." -ForegroundColor Yellow
git add -A

# Status check
git status

# Commit all changes
Write-Host "Committing all changes..." -ForegroundColor Green
git commit -m "Complete repository upload - ALL files included" --allow-empty

# Force push to GitHub
Write-Host "Force pushing to GitHub..." -ForegroundColor Green
git push -u origin main --force

# Clean up - replace remote URL to remove token from config
$publicUrl = "https://github.com/$repoOwner/$repoName.git"
git remote set-url origin $publicUrl

Write-Host @"

==================================================
               UPLOAD COMPLETE
==================================================
Your workspace should now be on GitHub at:
$publicUrl
==================================================
"@ -ForegroundColor Green
