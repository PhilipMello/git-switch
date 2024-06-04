#about_Execution_Policies
#https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_execution_policies?view=powershell-7.4

# To run git-switch.ps1, set: Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
#
# To remove run: Set-ExecutionPolicy -ExecutionPolicy Undefined -Scope CurrentUser

function Show-Menu {
    param (
        [string]$Title = 'Choose an Option'
    )

    Clear-Host
    Write-Host "================ $Title ================"
    Write-Host "1: GitHub Account 1"
    Write-Host "2: GitHub Account 2"
    Write-Host "Q: Quit"
}

# Prompt user to choose an option
Show-Menu
$selection = Read-Host "Select GitHub Account"

switch ($selection) {
    '1' {
        # Execute command to rename file 1
        $gitHubAccount1 = "%userprofile%\.ssh\id_ed25519_account1"
        $gitHubAccount1_pub = "%userprofile%\.ssh\id_ed25519_account1.pub"
        $newFileName1 = "id_ed25519"
        $newFileName1_pub = "id_ed25519.pub"
        Rename-Item -Path $gitHubAccount1 -NewName $newFileName1
        Rename-Item -Path $gitHubAccount1_pub -NewName $newFileName1_pub
        Write-Host "Switched to GitHub Account 1"
    }
    '2' {
        # Execute command to rename file 2
        $gitHubAccount1 = "%userprofile%\.ssh\id_ed25519"
        $gitHubAccount1_pub = "%userprofile%\.ssh\id_ed25519.pub"
        $newFileName1 = "id_ed25519_account1"
        $newFileName1_pub = "id_ed25519_account1.pub"
        Rename-Item -Path $gitHubAccount1 -NewName $newFileName1
        Rename-Item -Path $gitHubAccount1_pub -NewName $newFileName1_pub
        Write-Host "Switched to GitHub Account 2"
    }
    'q' {
        Write-Host "Quitting..."
        return
    }
    default {
        Write-Host "Invalid option. Please choose 1, 2, or Q."
    }
}

# Display account changed message
Write-Host "GitHub Account changed"