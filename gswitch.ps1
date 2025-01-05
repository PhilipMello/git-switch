# Author
$author = "Philip Mello <@Microsoft>"
# Version
$version = "1.2"
# License
$license = "MIT"
# Date
$currentDate = (Get-Date).ToString("MMM dd, yyyy")
# GitHub
$github = "https://github.com/PhilipMello/git-switch"

$script = "GitHub Account Switch"
$description = "Multiple Github Accounts into one CLI"

Write-Host @"
        _____         _ _       _     
       / ____|       (_) |     | |      $version
  __ _| (_____      ___| |_ ___| |__    $currentDate
 / _. |\___ \ \ /\ / / | __/ __| |_ \   $author
| (_| |____) \ V  V /| | || (__| | | |  $license
 \___ |_____/ \_/\_/ |_|\__\___|_| |_|
  __/ |                               
 |___/  $github                            

# --------------------------------------------------------------
# Script     : $script
# Description: $description
# --------------------------------------------------------------
# How to use: Execute gswitch
# Examples:
# Manual: gswitch -h OR gswitch --h OR gswitch --help
# Switch account using parameter: gswitch --account1
# --------------------------------------------------------------
"@

function github-generate-sshkey {
    Write-Host "Go to your GitHub Portal and add your SSH Key https://github.com/settings/ssh/new"

    # Prompt user for the number of accounts to create
    $numAccounts = Read-Host "How many GitHub accounts do you want to create (0-9)?"

    # Validate input
    if (-not ($numAccounts -match '^[0-9]+$') -or $numAccounts -lt 0 -or $numAccounts -gt 9) {
        Write-Host "Invalid number. Please enter a number between 0 and 9."
        exit 1
    }

    # Generate SSH keys for each account
    for ($i = 0; $i -lt $numAccounts; $i++) {
        $githubEmailAccount = Read-Host "Type your GitHub email account for account #$i"

        # Basic email format validation
        if ($githubEmailAccount -notmatch '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$') {
            Write-Host "Invalid email format. Please try again."
            continue
        }

        ssh-keygen -t ed25519 -C "$githubEmailAccount" -f "$HOME/.ssh/id_ed25519_account_$i"
        Write-Host "
        +-----------------------------------------------------------+
        | SSH key generated for: $githubEmailAccount
        | Key saved as: $HOME/.ssh/id_ed25519_account_$i
        +-----------------------------------------------------------+
        "
    }
}

function github-connection-test {
    Write-Host "Github connection testing..."
    ssh -T git@github.com
}

function github-set-account {
    $githubSetAccountName = Read-Host "Enter your Github Account Name"
    $githubSetAccountEmail = Read-Host "Enter your Github Account Email"
    git config user.name "$githubSetAccountName"
    git config user.email "$githubSetAccountEmail"
}

function github-account-switch {
    Write-Host "You're logged in as:"
    ssh -T git@github.com

    $emails = @()
    $files = @()

    Get-ChildItem -Path ~/.ssh/id_* -File | ForEach-Object {
        $content = Get-Content $_.FullName | Select-String -Pattern '[A-Za-z0-9._%+-]+@([A-Za-z0-9._%+-]+)?'
        if ($content) {
            $emails += $content.Matches.Value
            $files += $_.Name
        }
    }

    if ($emails.Count -eq 0) {
        Write-Host "No accounts found."
        exit 1
    }

    Write-Host "Select an email:"
    for ($i = 0; $i -lt $emails.Count; $i++) {
        Write-Host "$($i + 1). $($emails[$i])"
    }

    $choice = Read-Host "Enter the number of your account"
    if (-not ($choice -match '^[0-9]+$') -or $choice -lt 1 -or $choice -gt $emails.Count) {
        Write-Host "Invalid choice. Exiting."
        exit 1
    }

    $selectedEmail = $emails[$choice - 1]
    $selectedFile = $files[$choice - 1]

    Write-Host "Github Account $selectedEmail Selected!"
    Copy-Item -Path ~/.ssh/$selectedFile -Destination ~/.ssh/id_ed25519.pub
    ssh -T git@github.com
}

function github-fix-permissions {
    Write-Host "Fixing SSH file permissions..."
    icacls $HOME\.ssh /grant "$($env:UserName):(OI)(CI)F"
    icacls $HOME\.ssh\id_* /inheritance:r /grant "$($env:UserName):F"
    Write-Host "
    +-----------------------------------------------------------+
    | Files permissions have been fixed
    +-----------------------------------------------------------+
    "
}

function github-show-config {
    Write-Host "Run gSwitch in git directory level"
    git config --get-regexp "name|email"
}

function github-show-accounts {
    Write-Host "Showing accounts in ~/.ssh"
    Get-Content ~/.ssh/id_* | Select-String -Pattern '[A-Za-z0-9._%+-]+@([A-Za-z0-9._%+-]+)?' | ForEach-Object {
        Write-Host "-----------------------------------------"
        Write-Host "| Email: $($_.Matches[0].Value) |"
        Write-Host "-----------------------------------------"
    }
}

function manual {
    Write-Host "Generate 2 SSH Keys and rename GitHub account to id_ed25519_account1 and GitHub account 2 to id_ed25519_account2 in ~/.ssh"
    Write-Host "Parameters:
    --account1          Switch to GitHub Account 1
    --account2          Switch to GitHub Account 2
    "
    exit 0
}

if ($args -contains "-h" -or $args -contains "--help" -or $args -contains "--h") {
    manual
} elseif ($args -contains "--account1") {
    Copy-Item -Path ~/.ssh/id_ed25519_account1 -Destination ~/.ssh/id_ed25519
    Copy-Item -Path ~/.ssh/id_ed25519_account1.pub -Destination ~/.ssh/id_ed25519.pub
    Write-Host "Github Account #1 has been selected!"
    ssh -T git@github.com
    exit 0
} elseif ($args -contains "--account2") {
    Copy-Item -Path ~/.ssh/id_ed25519_account2 -Destination ~/.ssh/id_ed25519
    Copy-Item -Path ~/.ssh/id_ed25519_account2.pub -Destination ~/.ssh/id_ed25519.pub
    Write-Host "Github Account #2 has been selected!"
    ssh -T git@github.com
    exit 0
}

Write-Host "Choose an option:"
Write-Host "1. Switch GitHub Account"
Write-Host "2. Generate SSH Key"
Write-Host "3. Test Github SSH connection"
Write-Host "4. Set Github account"
Write-Host "5. Fix SSH file permissions"
Write-Host "6. Show current GitHub config"
Write-Host "7. Show Account in: ~/.ssh"

$option = Read-Host

switch ($option) {
    "1" { github-account-switch }
    "2" { github-generate-sshkey }
    "3" { github-connection-test }
    "4" { github-set-account }
    "5" { github-fix-permissions }
    "6" { github-show-config }
    "7" { github-show-accounts }
    default { Write-Host "Invalid option" }
}
