Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services" -Name "MaxInstanceCount" -Value 999999 -Type DWord

gpupdate /force