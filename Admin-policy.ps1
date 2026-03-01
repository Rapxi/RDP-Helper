# Elevate first
if (-not ([Security.Principal.WindowsPrincipal] `
            [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
            [Security.Principal.WindowsBuiltInRole]::Administrator)) {

    Start-Process powershell "-ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

Write-Host "Running as Administrator..." -ForegroundColor Green
Write-Host ""

# Prompt for username and password
$username = Read-Host "Enter the username to create"
$password = Read-Host "Enter the password for this user"

# Convert plain-text password to SecureString for creating the user
$passwordSecure = ConvertTo-SecureString $password -AsPlainText -Force

# Save credentials as plain text for AHK .ReadLine() use
$FilePath = Join-Path $PSScriptRoot "Profile.txt"
@(
    $username
    $password
) | Set-Content -Path $FilePath -Encoding UTF8

# Create local user if it doesn't exist
if (-not (Get-LocalUser -Name $username -ErrorAction SilentlyContinue)) {
    try {
        New-LocalUser -Name $username `
            -Password $passwordSecure `
            -PasswordNeverExpires `
            -AccountNeverExpires `
            -ErrorAction Stop
        Write-Host "User created successfully." -ForegroundColor Green
    }
    catch {
        Write-Host "Failed to create user: $($_.Exception.Message)" -ForegroundColor Red
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

# Restart RDP service (no reboot required)
Restart-Service -Name TermService -Force


# Create the key if it doesn't exist
if (-not (Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services")) {
    New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services" -Force
}

# Limit Number of Connections = 999999
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services" -Name "MaxInstanceCount" -Value 999999 -Type DWord



# Auto-detect active network adapter (prefers Ethernet over WiFi)
$networkAdapter = Get-NetIPAddress -AddressFamily IPv4 |
Where-Object { $_.IPAddress -notlike "127.*" -and $_.PrefixOrigin -ne "WellKnown" } |
ForEach-Object {
    $alias = $_.InterfaceAlias
    $priority = switch -Wildcard ($alias) {
        "Ethernet*" { 1 }
        "Wi-Fi*" { 2 }
        "Wireless*" { 2 }
        default { 3 }
    }
    [PSCustomObject]@{ Adapter = $_; Priority = $priority }
} |
Sort-Object Priority |
Select-Object -First 1 -ExpandProperty Adapter

# Check something was found
if (-not $networkAdapter) {
    Write-Host "No active network adapter found. Exiting." -ForegroundColor Red
    exit
}

$localIP = $networkAdapter.IPAddress
$prefixLength = $networkAdapter.PrefixLength
$subnet = ($localIP -replace "\.\d+$", ".0") + "/$prefixLength"

# Remove any existing RDP firewall rules to avoid conflicts
Remove-NetFirewallRule -DisplayName "Remote Desktop*" -ErrorAction SilentlyContinue

# Allow RDP only from the detected internal subnet
New-NetFirewallRule `
    -DisplayName "RDP - Internal Only" `
    -Direction Inbound `
    -Protocol TCP `
    -LocalPort 3389 `
    -RemoteAddress $subnet `
    -Action Allow `
    -Profile Any

# Block RDP from everything else
New-NetFirewallRule `
    -DisplayName "RDP - Block External" `
    -Direction Inbound `
    -Protocol TCP `
    -LocalPort 3389 `
    -RemoteAddress "0.0.0.0/0" `
    -Action Block `
    -Profile Any

gpupdate /force

Write-Host ""
Write-Host "Remote Desktop enabled successfully." -ForegroundColor Green
Write-Host "Setup complete." -ForegroundColor Cyan