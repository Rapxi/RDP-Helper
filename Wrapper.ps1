# URLs
$urlwrap = "https://github.com/stascorp/rdpwrap/releases/download/v1.6.2/RDPWrap-v1.6.2.zip"
$urlautoupd = "https://github.com/asmtron/rdpwrap/raw/master/autoupdate_v1.2.zip"

# Download locations
$outputdownwrap = "$env:USERPROFILE\Downloads\RDPWrap-v1.6.2.zip"
$outputdownautoupd = "$env:USERPROFILE\Downloads\autoupdate_v1.2.zip"

# Destination folder (make sure quotes are correct)
$outputwrap = "C:\Program Files\RDP Wrapper"

# Create destination folder if it doesn't exist
if (-not (Test-Path $outputwrap)) { New-Item -ItemType Directory -Path $outputwrap }

# Download files
Invoke-WebRequest -Uri $urlwrap -OutFile $outputdownwrap
Invoke-WebRequest -Uri $urlautoupd -OutFile $outputdownautoupd

# Extract ZIPs
Expand-Archive -Path $outputdownwrap -DestinationPath $outputwrap -Force
Expand-Archive -Path $outputdownautoupd -DestinationPath $outputwrap -Force

Write-Host "RDP Wrapper files downloaded and extracted." -ForegroundColor Green