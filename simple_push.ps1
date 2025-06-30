# Ultra Simple Push Script
# This script adds all files and pushes them to GitHub

$repoName = "crime-location-choice-studies"
$username = "KuralarasanKumar"
$remoteUrl = "https://github.com/$username/$repoName.git"

# Change to the workspace directory
$workspacePath = "c:\Users\kukumar\OneDrive - UGent\Job\crimsyndata\-crime-location-choice-studies\snatching work"
Set-Location $workspacePath

Write-Host "Starting the ultra simple push process..." -ForegroundColor Green

# Clean up any existing Git setup
Write-Host "Cleaning up any existing Git setup..."
if (Test-Path ".git") {
    Write-Host "Removing existing Git repository..."
    Remove-Item -Recurse -Force -Path ".git"
}

# Initialize fresh Git repository
Write-Host "Initializing new Git repository..."
git init

# Make sure we're on the main branch
Write-Host "Setting up main branch..."
git branch -M main

# Add remote
Write-Host "Adding remote origin: $remoteUrl"
git remote add origin $remoteUrl

# Make sure there's a .gitignore file
if (-not (Test-Path ".gitignore")) {
    Write-Host "Creating .gitignore file..."
    @"
# Ignore system files
.DS_Store
Thumbs.db

# Ignore R specific files
.Rhistory
.RData
.Rproj.user/
"@ | Out-File -FilePath ".gitignore" -Encoding utf8
}

# Add all files
Write-Host "Adding all files to Git..."
git add .

# Commit changes
Write-Host "Committing changes..."
$commitOutput = git commit -m "Complete workspace with organized crime location choice studies" 2>&1

if ($LASTEXITCODE -ne 0) {
    Write-Host "Commit issue detected: $commitOutput" -ForegroundColor Yellow
    
    # Check if the issue is "nothing to commit"
    if ($commitOutput -like "*nothing to commit*") {
        Write-Host "No changes to commit. Creating an empty commit to ensure we can push..."
        git commit --allow-empty -m "Initial setup for crime location choice studies"
    } else {
        # Try forcing the add and commit
        Write-Host "Trying forced add and commit..."
        git add -A
        git commit -m "Complete workspace with organized crime location choice studies" --allow-empty
    }
}

# Push to GitHub with force to override any conflicting history
Write-Host "Pushing to GitHub with force option..."
git push -u origin main --force

Write-Host "Push process completed!" -ForegroundColor Green
Write-Host "Check your repository at: $remoteUrl"
