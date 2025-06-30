# Token-based Push Script
# This script focuses on token-based authentication to push to GitHub

Write-Host @"
==================================================
         GITHUB AUTHENTICATION SCRIPT
==================================================

This script will help you push your workspace to GitHub
using token-based authentication.

You'll need to:
1. Create a Personal Access Token on GitHub
   - Go to https://github.com/settings/tokens
   - Click "Generate new token"
   - Select "repo" scope
   - Copy the generated token

2. Use this token instead of your password when prompted
==================================================
"@ -ForegroundColor Cyan

# Define repository information
$repoOwner = "KuralarasanKumar"
$repoName = "crime-location-choice-studies"
$workspacePath = "c:\Users\kukumar\OneDrive - UGent\Job\crimsyndata\-crime-location-choice-studies\snatching work"

# Change to workspace directory
Set-Location $workspacePath

# Prepare .gitignore file
$gitignoreContent = @"
# Ignore system files
.DS_Store
Thumbs.db
*.bak
*.tmp
*.temp

# Ignore R specific files
.Rhistory
.RData
.Rproj.user/
"@

$gitignoreContent | Out-File -FilePath ".gitignore" -Encoding utf8
Write-Host "Created .gitignore file" -ForegroundColor Green

# Remove any nested Git repositories
Write-Host "Checking for nested Git repositories..." -ForegroundColor Yellow
$nestedGitFolders = Get-ChildItem -Path $workspacePath -Recurse -Force -Directory -Filter ".git" | 
    Where-Object { $_.FullName -ne (Join-Path $workspacePath ".git") }

if ($nestedGitFolders.Count -gt 0) {
    foreach ($folder in $nestedGitFolders) {
        Write-Host "Removing nested Git repository: $($folder.FullName)" -ForegroundColor Yellow
        Remove-Item -Path $folder.FullName -Recurse -Force -ErrorAction SilentlyContinue
    }
}

# Reset Git completely
Write-Host "`nResetting Git repository completely..." -ForegroundColor Yellow
if (Test-Path ".git") {
    Remove-Item -Recurse -Force -Path ".git" -ErrorAction SilentlyContinue
}

# Initialize fresh Git repository
Write-Host "Initializing new Git repository..." -ForegroundColor Green
& git init
& git checkout -b main

# Now ask for the token
Write-Host "`nPlease enter your GitHub Personal Access Token" -ForegroundColor Yellow
Write-Host "You can create one at: https://github.com/settings/tokens" -ForegroundColor Yellow
Write-Host "Make sure to give it 'repo' scope permissions" -ForegroundColor Yellow
$token = Read-Host "Enter your token" -AsSecureString
$BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($token)
$plainToken = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)

# Configure the remote with token embedded in URL
$remoteUrl = "https://${repoOwner}:${plainToken}@github.com/${repoOwner}/${repoName}.git"
& git remote add origin $remoteUrl

# Add files using git command directly (not using recursive function)
Write-Host "`nAdding all files to Git..." -ForegroundColor Green
& git add .

# Commit changes
Write-Host "Committing changes..." -ForegroundColor Green
& git commit -m "Initial commit of Crime Location Choice Studies workspace" --allow-empty

# Push to GitHub
Write-Host "`nPushing to GitHub..." -ForegroundColor Green
& git push -u origin main --force

# Clean up - replace remote URL to remove token from config
$publicUrl = "https://github.com/$repoOwner/$repoName.git"
& git remote set-url origin $publicUrl

Write-Host "`nDone! Your workspace should now be on GitHub at:" -ForegroundColor Green
Write-Host "$publicUrl" -ForegroundColor Cyan
