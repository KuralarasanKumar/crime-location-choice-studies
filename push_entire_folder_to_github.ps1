# Push to GitHub Script
# This script initializes a Git repository and pushes the entire folder to GitHub
# Configured for: https://github.com/KuralarasanKumar/crime-location-choice-studies

# Function to check if Git is installed
function Test-GitInstalled {
    try {
        $gitVersion = git --version
        Write-Host "Git is installed: $gitVersion"
        return $true
    }
    catch {
        Write-Host "Git is not installed. Please install Git before proceeding."
        return $false
    }
}

# Define parameters
$repoName = "crime-location-choice-studies"
$mainFolderPath = "c:\Users\kukumar\OneDrive - UGent\Job\crimsyndata\-crime-location-choice-studies\snatching work"

# Check if Git is installed
if (-not (Test-GitInstalled)) {
    Write-Host "Please install Git from https://git-scm.com/downloads and retry."
    exit
}

# Change to the main folder
Set-Location $mainFolderPath

# Check if Git user is configured
$gitUserName = & git config --global user.name 2>&1
$gitUserEmail = & git config --global user.email 2>&1

Write-Host "Current Git user configuration:"
Write-Host "Name: $gitUserName"
Write-Host "Email: $gitUserEmail"

# Prompt to configure Git user if not already configured
if ([string]::IsNullOrWhiteSpace($gitUserName) -or [string]::IsNullOrWhiteSpace($gitUserEmail)) {
    Write-Host "Git user is not fully configured. This is required for making commits." -ForegroundColor Yellow
    
    if ([string]::IsNullOrWhiteSpace($gitUserName)) {
        $newUserName = Read-Host "Enter your name for Git commits"
        if (-not [string]::IsNullOrWhiteSpace($newUserName)) {
            & git config --global user.name $newUserName
            Write-Host "Git user name set to: $newUserName"
        }
    }
    
    if ([string]::IsNullOrWhiteSpace($gitUserEmail)) {
        $newUserEmail = Read-Host "Enter your email for Git commits"
        if (-not [string]::IsNullOrWhiteSpace($newUserEmail)) {
            & git config --global user.email $newUserEmail
            Write-Host "Git user email set to: $newUserEmail"
        }
    }
}

# Set Git configuration for initial branch name
Write-Host "Setting default branch name to main..."
git config --global init.defaultBranch main

# Increase Git buffer size for potentially large commits
Write-Host "Configuring Git for larger file handling..."
git config --global http.postBuffer 524288000

# Check if .git folder already exists
if (Test-Path -Path ".git" -PathType Container) {
    Write-Host "Git repository already initialized."
} else {
    # Initialize Git repository in the main snatching work folder
    Write-Host "Initializing Git repository in $mainFolderPath..."
    git init
}

# Create a .gitignore file to exclude unnecessary files
$gitIgnoreContent = @"
# PDF files are already cleaned up, we'll include them in the repository
# Uncomment the line below only if you need to exclude PDFs again
# *.pdf

# Ignore backup files
*.bak
*.tmp
*.temp

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

# Add all files to Git
Write-Host "Adding all files to Git..."

# Check if FinalOrganized has a .git folder inside it
$finalOrgGitPath = Join-Path $mainFolderPath "FinalOrganized\.git"
if (Test-Path $finalOrgGitPath) {
    Write-Host "WARNING: Found nested Git repository in FinalOrganized folder. This can cause issues." -ForegroundColor Yellow
    Write-Host "Removing nested Git repository..."
    
    try {
        Remove-Item -Path $finalOrgGitPath -Recurse -Force
        Write-Host "Successfully removed nested Git repository."
    }
    catch {
        Write-Host "Failed to remove nested Git repository: $($_.Exception.Message)" -ForegroundColor Red
        Write-Host "Attempting to continue..."
    }
}

# Add files individually to avoid potential issues
Write-Host "Adding files individually to avoid issues..."
$fileList = Get-ChildItem -Path $mainFolderPath -Exclude ".git" -Force
foreach ($item in $fileList) {
    Write-Host "Adding: $($item.Name)"
    & git add --force $item.FullName 2>&1
}

# Prepare commit message
$defaultMessage = "Initial commit of Crime Location Choice Studies workspace with organized PDFs"
Write-Host "Default commit message: $defaultMessage"
$useCustomMessage = Read-Host "Do you want to use a custom commit message? (y/n)"

if ($useCustomMessage -eq 'y') {
    $commitMessage = Read-Host "Enter your commit message"
    if ([string]::IsNullOrWhiteSpace($commitMessage)) {
        $commitMessage = $defaultMessage
    }
} else {
    $commitMessage = $defaultMessage
}

# Check if we have changes to commit
$gitStatus = & git status --porcelain

if ([string]::IsNullOrWhiteSpace($gitStatus)) {
    Write-Host "No changes to commit. All files may already be committed."
    
    # Check if we have any commits at all
    $commitCount = & git rev-list --count HEAD 2>&1
    if ($LASTEXITCODE -ne 0) {
        # No commits yet, create an initial empty commit
        Write-Host "No previous commits found. Creating initial commit..."
        & git commit --allow-empty -m "Initial commit for Crime Location Choice Studies"
    }
} else {
    # Commit the changes
    Write-Host "Committing changes..."
    $commitOutput = & git commit -m $commitMessage 2>&1
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Commit failed: $commitOutput" -ForegroundColor Red
        Write-Host "Trying to commit with --allow-empty option..."
        & git commit --allow-empty -m $commitMessage
    }
}

# Setup GitHub repository (you'll need to create this on GitHub first)
Write-Host "`nNow you need to connect this local repository to your GitHub repository."
Write-Host "Please make sure you've created the '$repoName' repository on GitHub."

# Prompt for GitHub connection
$proceed = Read-Host "Have you created the '$repoName' repository on GitHub? (y/n)"
if ($proceed -ne 'y') {
    Write-Host "Please create the repository on GitHub first and then run this script again."
    return
}

# Add GitHub remote repository
Write-Host "`nAdding GitHub as the remote origin..."
Write-Host "You'll be prompted to enter your GitHub credentials."

# Set up GitHub repository URL with your username
$username = "KuralarasanKumar"
Write-Host "Using GitHub username: $username"

# Determine if we should use HTTPS or SSH
$useSSH = Read-Host "Do you want to use SSH for connecting to GitHub? (y/n)"
if ($useSSH -eq 'y') {
    $remoteUrl = "git@github.com:$username/$repoName.git"
} else {
    $remoteUrl = "https://github.com/$username/$repoName.git"
}

git remote add origin $remoteUrl

# Function to run git commands with error handling
function Invoke-GitCommand {
    param (
        [string]$command,
        [string]$errorMessage = "Git command failed"
    )
    
    Write-Host "Executing: git $command"
    $output = & git $command.Split(" ") 2>&1
    $exitCode = $LASTEXITCODE
    
    Write-Host "Command output: $output"
    Write-Host "Exit code: $exitCode"
    
    if ($exitCode -ne 0) {
        Write-Host "ERROR: $errorMessage" -ForegroundColor Red
        Write-Host "Error details: $output" -ForegroundColor Red
        return $false
    }
    
    return $true
}

# First let's verify the remote is set up correctly
Write-Host "`nVerifying remote setup..."
$remoteResult = & git remote -v 2>&1
Write-Host "Current remotes: $remoteResult"

# Try removing the remote if it exists already
& git remote remove origin 2>&1

# Add the remote again
Write-Host "Re-adding remote origin as: $remoteUrl"
if (-not (Invoke-GitCommand "remote add origin $remoteUrl" "Failed to add remote")) {
    Write-Host "Failed to set up the remote. Please check your GitHub credentials and repository URL."
    return
}

# Check if the remote already has content
Write-Host "`nChecking if the repository already has content on GitHub..."
$remoteFetch = & git ls-remote --exit-code origin 2>&1
$repoExists = $LASTEXITCODE -eq 0

if ($repoExists) {
    Write-Host "The repository exists on GitHub."
    
    # Check if force push is needed
    $forcePush = Read-Host "The remote repository already exists. Do you want to force push? This will overwrite any existing content on GitHub (y/n)"
    
    if ($forcePush -eq 'y') {
        Write-Host "Force pushing to GitHub..."
        $pushResult = Invoke-GitCommand "push -u origin main --force" "Failed to force push to GitHub"
        if (-not $pushResult) {
            Write-Host "Troubleshooting steps:" -ForegroundColor Yellow
            Write-Host "1. Verify you have write permissions to the repository" -ForegroundColor Yellow
            Write-Host "2. Check if you need to authenticate with GitHub" -ForegroundColor Yellow
            Write-Host "3. Try authenticating manually: git push -u origin main --force" -ForegroundColor Yellow
            return
        }
    } else {
        # Try regular push first, and if it fails, offer options
        Write-Host "Attempting to push to GitHub..."
        $pushOutput = & git push -u origin main 2>&1
        $pushSuccess = $LASTEXITCODE -eq 0
        
        Write-Host "Push output: $pushOutput"
        Write-Host "Push success: $pushSuccess"
        
        if (-not $pushSuccess) {
            Write-Host "Push failed. This could be because the remote repository has content that doesn't exist locally."
            Write-Host "Options:"
            Write-Host "1. Force push (will overwrite remote content)"
            Write-Host "2. Pull first, then push (might cause merge conflicts)"
            Write-Host "3. Abort"
            
            $choice = Read-Host "Enter your choice (1-3)"
            
            switch ($choice) {
                "1" {
                    Write-Host "Force pushing to GitHub..."
                    git push -u origin main --force
                }
                "2" {
                    Write-Host "Pulling from GitHub first..."
                    git pull origin main
                    Write-Host "Now pushing to GitHub..."
                    git push -u origin main
                }
                "3" {
                    Write-Host "Operation aborted. No changes were pushed to GitHub."
                    return
                }
                default {
                    Write-Host "Invalid choice. Operation aborted."
                    return
                }
            }
        }
    }
} else {
    # Repository doesn't exist or is empty, proceed with normal push
    Write-Host "Repository appears to be empty or newly created. Proceeding with normal push..."
    $pushResult = Invoke-GitCommand "push -u origin main" "Failed to push to GitHub"
    
    if (-not $pushResult) {
        Write-Host "Trying alternative approaches:" -ForegroundColor Yellow
        
        # Try setting the branch explicitly
        Write-Host "Attempt 1: Setting branch explicitly..." -ForegroundColor Yellow
        Invoke-GitCommand "branch -M main" "Failed to set branch"
        $pushResult = Invoke-GitCommand "push -u origin main" "Failed to push to GitHub"
        
        if (-not $pushResult) {
            # Try with force option as last resort
            Write-Host "Attempt 2: Trying force push as last resort..." -ForegroundColor Yellow
            $pushResult = Invoke-GitCommand "push -u origin main --force" "Failed to force push to GitHub"
            
            if (-not $pushResult) {
                Write-Host "All push attempts failed. Please try the following manual steps:" -ForegroundColor Red
                Write-Host "1. Run: git push -u origin main --force" -ForegroundColor Yellow
                Write-Host "2. Check GitHub credentials and permissions" -ForegroundColor Yellow
                Write-Host "3. Verify your repository URL: $remoteUrl" -ForegroundColor Yellow
                return
            }
        }
    }
}

Write-Host "`nDone! Your entire 'snatching work' folder has been pushed to GitHub at: $remoteUrl"
