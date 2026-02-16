
# Self-elevate if not admin
if (-not ([Security.Principal.WindowsPrincipal] `
    [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
    [Security.Principal.WindowsBuiltInRole]::Administrator)) {

    Start-Process powershell "-ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

Write-Host "Running as Administrator..." -ForegroundColor Green
Write-Host ""
Write-Host "Please write down the username and password for future use" -ForegroundColor Yellow

# Prompt for username + password
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
        Write-Host "Failed to create user." -ForegroundColor Red
        exit
    }
}
else {
    Write-Host "User already exists. Skipping creation." -ForegroundColor Yellow
}

# Add to Administrators group
Add-LocalGroupMember -Group "Administrators" -Member $username -ErrorAction SilentlyContinue
Write-Host "User added to Administrators group." -ForegroundColor Green

# Enable Remote Desktop (local setting)
Set-ItemProperty `
    -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server' `
    -Name 'fDenyTSConnections' `
    -Value 0

# Enforce via Local Policy (stronger method)
New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services" -Force | Out-Null

Set-ItemProperty `
    -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services" `
    -Name "fDenyTSConnections" `
    -Value 0
 
# Enable firewall rules
Enable-NetFirewallRule -DisplayGroup "Remote Desktop"

Restart-Service -Name TermService -Force

Write-Host ""
Write-Host "Remote Desktop enabled successfully." -ForegroundColor Green
Write-Host "Setup complete." -ForegroundColor Cyan