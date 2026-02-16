
if (-not ([Security.Principal.WindowsPrincipal] `
            [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
            [Security.Principal.WindowsBuiltInRole]::Administrator)) {

    Start-Process powershell "-ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

Write-Host "Running as Administrator..." -ForegroundColor Green

Write-Host "Please write down the username and password for future use"
$username = Read-Host "Enter the username to create"
$password = Read-Host "Enter the password for this user" -AsSecureString


# Create local user if not exists
if (-not (Get-LocalUser -Name $username -ErrorAction SilentlyContinue)) {
    try {
        New-LocalUser -Name $username `
            -Password $password `
            -PasswordNeverExpires `
            -AccountNeverExpires `
            -ErrorAction Stop
        Write-Host "User created successfully." -ForegroundColor Green
    }
    catch {
        Write-Host "Failed to create user." -ForegroundColor Yellow
    }
}
else {
    Write-Host "User already exists. Skipping creation." -ForegroundColor Yellow
}


# Add to Administrators group
Add-LocalGroupMember -Group "Administrators" -Member $username -ErrorAction SilentlyContinue
Write-Host "User added to Administrators group." -ForegroundColor Green


# Enable Remote Desktop
Set-ItemProperty `
    -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server' `
    -Name 'fDenyTSConnections' `
    -Value 0

# Enable firewall rule for RDP
Enable-NetFirewallRule -DisplayGroup "Remote Desktop"

# Restart Remote Desktop Service
Restart-Service -Name TermService -Force

Write-Host "Remote Desktop enabled." -ForegroundColor Green

# Update Group Policy
gpupdate /force

Write-Host "Group Policy updated." -ForegroundColor Green
Write-Host "Setup complete." -ForegroundColor Cyan