# Final Push Script
# This script handles the nested Git repository issue and authentication

$repoName = "crime-location-choice-studies"
$username = "KuralarasanKumar"
$remoteUrl = "https://github.com/$username/$repoName.git"

# Change to the workspace directory
$workspacePath = "c:\Users\kukumar\OneDrive - UGent\Job\crimsyndata\-crime-location-choice-studies\snatching work"
Set-Location $workspacePath

Write-Host "Starting the final push process..." -ForegroundColor Green

# Check for nested Git repositories and remove them
Write-Host "Checking for nested Git repositories..."
$nestedGitFolders = Get-ChildItem -Path $workspacePath -Recurse -Force -Directory -Filter ".git" | 
    Where-Object { $_.FullName -ne (Join-Path $workspacePath ".git") }

if ($nestedGitFolders.Count -gt 0) {
    Write-Host "Found $($nestedGitFolders.Count) nested Git repositories. Removing them..." -ForegroundColor Yellow
    foreach ($folder in $nestedGitFolders) {
        Write-Host "Removing: $($folder.FullName)"
        Remove-Item -Path $folder.FullName -Recurse -Force
    }
}

# Clean up any existing Git setup in the main folder
Write-Host "Cleaning up existing Git setup..."
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

# Create a .gitignore file to exclude unnecessary files
$gitIgnoreContent = @"
# Ignore system files
.DS_Store
Thumbs.db

# Ignore R specific files
.Rhistory
.RData
.Rproj.user/
"@

$gitIgnoreContent | Out-File -FilePath ".gitignore" -Encoding utf8
Write-Host "Created .gitignore file"

# Add files by folder to avoid the nested repository issue
Write-Host "Adding files folder by folder to avoid issues..."

# Function to safely add files
function Add-FilesToGit {
    param (
        [string]$path
    )
    
    $items = Get-ChildItem -Path $path -Force | Where-Object { $_.Name -ne ".git" }
    foreach ($item in $items) {
        if (-not ($item.PSIsContainer)) {
            # It's a file, add it
            Write-Host "Adding file: $($item.Name)"
            git add $item.FullName
        } else {
            # It's a directory, process its contents
            Write-Host "Processing directory: $($item.Name)"
            Add-FilesToGit -path $item.FullName
        }
    }
}

# Add files recursively
Add-FilesToGit -path $workspacePath

# Create an empty commit if needed
Write-Host "Creating commit..."
git commit -m "Complete workspace with organized crime location choice studies" --allow-empty

# Add GitHub remote
Write-Host "Adding remote: $remoteUrl"
git remote add origin $remoteUrl

# Push to GitHub with token-based authentication
Write-Host "Preparing to push to GitHub..."

Write-Host "`nIMPORTANT: GitHub requires personal access token for authentication." -ForegroundColor Yellow
Write-Host "You may need to create a personal access token at: https://github.com/settings/tokens" -ForegroundColor Yellow
Write-Host "Select the 'repo' scope when creating the token." -ForegroundColor Yellow

$useToken = Read-Host "Do you want to use a personal access token for authentication? (y/n)"

if ($useToken -eq 'y') {
    $token = Read-Host "Enter your GitHub personal access token" -AsSecureString
    $tokenPlain = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto(
        [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($token)
    )
    
    # Set the token URL with authentication
    $tokenUrl = "https://$username`:$tokenPlain@github.com/$username/$repoName.git"
    
    # Update the remote with the token
    git remote set-url origin $tokenUrl
    
    Write-Host "Pushing to GitHub..."
    git push -u origin main --force
    
    # Reset the URL to remove the token from Git config
    git remote set-url origin $remoteUrl
} else {
    Write-Host "Pushing to GitHub... You may be prompted for credentials."
    git push -u origin main --force
}

Write-Host "`nPush process completed!" -ForegroundColor Green
Write-Host "Check your repository at: https://github.com/$username/$repoName"
