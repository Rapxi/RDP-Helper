$urlapp = "https://www.donkz.nl/download/remote-desktop-plus/?tmstv=1771179612"
$outputdownapp = "$env:USERPROFILE\Downloads\rdp.exe"

Invoke-WebRequest -Uri $urlapp -OutFile $outputdownapp