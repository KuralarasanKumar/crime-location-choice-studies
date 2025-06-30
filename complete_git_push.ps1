# Complete Git Push Script - Add, Commit, and Push
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

# Ask for the token
Write-Host "Please enter your GitHub Personal Access Token" -ForegroundColor Yellow
$token = Read-Host "Enter your token" -AsSecureString
$BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($token)
$plainToken = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)

# Remove nested Git repositories
Write-Host "Checking for nested Git repositories..." -ForegroundColor Yellow
$nestedGitFolders = Get-ChildItem -Path $workspacePath -Recurse -Force -Directory -Filter ".git" | 
    Where-Object { $_.FullName -ne (Join-Path $workspacePath ".git") }

if ($nestedGitFolders.Count -gt 0) {
    foreach ($folder in $nestedGitFolders) {
        Write-Host "Removing nested Git repository: $($folder.FullName)" -ForegroundColor Yellow
        Remove-Item -Path $folder.FullName -Recurse -Force -ErrorAction SilentlyContinue
    }
}

# Make sure we have a Git repository
if (-not (Test-Path ".git")) {
    Write-Host "Initializing Git repository..." -ForegroundColor Green
    git init
    git checkout -b main
}

# Configure the remote with token embedded in URL
$remoteUrl = "https://${repoOwner}:${plainToken}@github.com/${repoOwner}/${repoName}.git"

# Update remote
Write-Host "Configuring remote..." -ForegroundColor Yellow
git remote remove origin 2>$null
git remote add origin $remoteUrl

# Add all files explicitly
Write-Host "Adding all files to Git..." -ForegroundColor Green
git add .gitignore
git add "*.md" "*.pdf" "*.pptx" "*.potx" "*.odp" "*.html" "*.Rproj" "*.csv" "*.ps1"
git add "20250115_Analysis & Results" "20250116_Analysis & Results" "20250117_Analysis & Results" 
git add "20250513_Analysis & Results" "20250513_output_spatial_scale" "20250521_Analysis & Results"
git add "20250521_output_spatial_scale" "Data" "Drafts" "FinalOrganized" "Multiscale_literature" 
git add "README_files" "References" "Script"

# Commit changes
Write-Host "Committing changes..." -ForegroundColor Green
git commit -m "Initial complete commit of Crime Location Choice Studies workspace" --allow-empty

# Force push to GitHub
Write-Host "Force pushing to GitHub..." -ForegroundColor Green
git push -u origin main --force

# Clean up - replace remote URL to remove token from config
$publicUrl = "https://github.com/$repoOwner/$repoName.git"
git remote set-url origin $publicUrl

Write-Host "`nDone! Your workspace should now be on GitHub at:" -ForegroundColor Green
Write-Host "$publicUrl" -ForegroundColor Cyan
