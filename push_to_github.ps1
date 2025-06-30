# Simple script to push to GitHub
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
