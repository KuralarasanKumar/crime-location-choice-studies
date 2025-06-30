$repoOwner = "KuralarasanKumar"
$repoName = "crime-location-choice-studies"

# Ask for the token
Write-Host "Please enter your GitHub Personal Access Token" -ForegroundColor Yellow
$token = Read-Host "Enter your token" -AsSecureString
$BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($token)
$plainToken = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)

# Configure the remote with token embedded in URL
$remoteUrl = "https://${repoOwner}:${plainToken}@github.com/${repoOwner}/${repoName}.git"

# Remove any existing 'origin' remote
git remote remove origin

# Add the new remote
git remote add origin $remoteUrl

# Push to GitHub
Write-Host "Pushing to GitHub..." -ForegroundColor Green
git push -u origin main --force

# Clean up - replace remote URL to remove token from config
$publicUrl = "https://github.com/$repoOwner/$repoName.git"
git remote set-url origin $publicUrl

Write-Host "Done! Your workspace should now be on GitHub at:" -ForegroundColor Green
Write-Host "$publicUrl" -ForegroundColor Cyan

# Set strict mode for safety
Set-StrictMode -Version Latest

# Set your variables
$repoUrl = "https://github.com/KuralarasanKumar/crime-location-choice-studies.git"
$token = "YOUR_GITHUB_TOKEN_HERE"  # <-- Replace with your actual GitHub Personal Access Token
$remoteName = "origin"
$commitMsg = "Initial commit"


# Enable long paths in Git and Windows (requires admin for system-wide)
try {
    git config --system core.longpaths true
}
catch {
    Write-Host "Could not set git longpaths system-wide. Trying for current repo..." -ForegroundColor Yellow
    git config core.longpaths true
}
try {
    Set-ItemProperty -Path 'HKLM:\\SYSTEM\\CurrentControlSet\\Control\\FileSystem' -Name 'LongPathsEnabled' -Value 1 -ErrorAction Stop
    Write-Host "Windows long paths enabled." -ForegroundColor Green
}
catch {
    Write-Host "Could not enable Windows long paths (need admin). Please enable manually if you see path errors." -ForegroundColor Yellow
}

# Remove any nested .git folders (except root)
Get-ChildItem -Path . -Recurse -Directory -Force -ErrorAction SilentlyContinue | Where-Object { $_.Name -eq ".git" -and $_.FullName -ne (Join-Path (Get-Location) ".git") } | ForEach-Object { Remove-Item -Recurse -Force $_.FullName }

# Initialize git if not already
if (-not (Test-Path ".git")) {
    git init
}

# Add all files
git add --all

# Commit
git commit -m $commitMsg

# Remove existing remote if present
if (git remote | Select-String $remoteName) {
    git remote remove $remoteName
}

# Add remote with token in URL
$repoUrlWithToken = $repoUrl -replace "https://", "https://$token@"
git remote add $remoteName $repoUrlWithToken

# Pull remote changes first to avoid push rejection
Write-Host "Pulling remote changes (allowing unrelated histories)..." -ForegroundColor Yellow
git pull $remoteName main --allow-unrelated-histories

# Push to GitHub
Write-Host "Pushing to GitHub..." -ForegroundColor Green
git branch -M main
git push -u $remoteName main

# Remove token from remote URL for security
git remote set-url $remoteName $repoUrl

Write-Host "Push complete. Remote URL cleaned up."
