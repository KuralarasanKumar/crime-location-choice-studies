# Direct folder upload script
# This script tries to upload files by focusing on directories

Write-Host @"
==================================================
      DIRECT FOLDER UPLOAD - LAST RESORT
==================================================

This script will:
1. Initialize a fresh Git repository
2. Upload your folders one at a time
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

# Clean up any previous Git setup
if (Test-Path ".git") {
    Write-Host "Removing existing Git repository..." -ForegroundColor Yellow
    Remove-Item -Recurse -Force -Path ".git"
}

# Remove nested Git repositories
$nestedGits = Get-ChildItem -Path $workspacePath -Recurse -Force -Directory -Filter ".git"
foreach ($git in $nestedGits) {
    Write-Host "Removing nested Git: $($git.FullName)" -ForegroundColor Yellow
    Remove-Item -Path $git.FullName -Recurse -Force
}

# Initialize Git
Write-Host "Initializing Git repository..." -ForegroundColor Green
git init
git checkout -b main

# Set up remote
$remoteUrl = "https://${repoOwner}:${plainToken}@github.com/${repoOwner}/${repoName}.git"
git remote add origin $remoteUrl

# Create .gitignore
$gitignoreContent = @"
# R specific
.Rproj.user/
.Rhistory
.RData
.Ruserdata

# System files
.DS_Store
Thumbs.db
*~
*.bak
*.tmp
"@
$gitignoreContent | Out-File -FilePath ".gitignore" -Encoding UTF8
git add .gitignore

# Get all top-level folders and root files
$topLevelItems = Get-ChildItem -Path $workspacePath

# First commit .gitignore
git commit -m "Initial commit - Add .gitignore"

# Now add and commit each top-level folder/file individually
foreach ($item in $topLevelItems) {
    if ($item.Name -eq ".git" -or $item.Name -eq ".gitignore") {
        continue
    }
    
    Write-Host "Processing $($item.Name)..." -ForegroundColor Yellow
    
    try {
        git add $item.Name
        git commit -m "Add $($item.Name)" --allow-empty
    }
    catch {
        Write-Host "Error processing $($item.Name): $_" -ForegroundColor Red
    }
}

# Push everything
Write-Host "Pushing to GitHub..." -ForegroundColor Green
git push -u origin main --force

# Clean up - replace remote URL to remove token from config
$publicUrl = "https://github.com/$repoOwner/$repoName.git"
git remote set-url origin $publicUrl

Write-Host @"

==================================================
             UPLOAD COMPLETED
==================================================
Your workspace should now be on GitHub at:
$publicUrl
==================================================
"@ -ForegroundColor Green
