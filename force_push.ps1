# Final force push script
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

# Configure the remote with token embedded in URL
$remoteUrl = "https://${repoOwner}:${plainToken}@github.com/${repoOwner}/${repoName}.git"

# Remove any existing 'origin' remote
Write-Host "Configuring remote..." -ForegroundColor Yellow
git remote remove origin
git remote add origin $remoteUrl

# Check if all files are added
Write-Host "Making sure all files are added..." -ForegroundColor Yellow
git add -A

# Check if we have a commit
$hasCommit = git log -1 --oneline
if (-not $hasCommit) {
    Write-Host "Creating initial commit..." -ForegroundColor Yellow
    git commit -m "Initial commit of Crime Location Choice Studies workspace" --allow-empty
}

# Force push to GitHub
Write-Host "Force pushing to GitHub..." -ForegroundColor Green
git push -u origin main --force

# Clean up - replace remote URL to remove token from config
$publicUrl = "https://github.com/$repoOwner/$repoName.git"
git remote set-url origin $publicUrl

Write-Host "Done! Your workspace should now be on GitHub at:" -ForegroundColor Green
Write-Host "$publicUrl" -ForegroundColor Cyan
