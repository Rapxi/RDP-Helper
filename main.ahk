#Requires AutoHotkey v2.0.18+
#SingleInstance Force

CoordMode("Pixel", "Client")

MyGui := Gui()
MyGui.Show("w400 h150")
ScriptBtn := MyGui.Add("Button", "x20 y20 w360 h30", "Create An Admin")
ScriptBtn.OnEvent("Click", (*) => Script())
Script() {
    psScript := A_ScriptDir "\Admin-Policy.ps1"
    Run '*RunAs powershell.exe  -ExecutionPolicy Bypass -File "' psScript '"'
}
WrapperBtn := MyGui.Add("Button", "x20 y60 w360 h30", "Update RDP Wrapper")
WrapperBtn.OnEvent("Click", (*) => Wrapper())
Wrapper() {
    WrapperScript := A_ScriptDir "\Wrapper.ps1"
    RunWait '*RunAs powershell.exe  -ExecutionPolicy Bypass -File "' WrapperScript '"'
    RunWait '*RunAs "C:\Program Files\RDP Wrapper\autoupdate.bat"'
}
AppBtn := MyGui.Add("Button", "x20 y100 w360 h30", "Download RDP++")
AppBtn.OnEvent("Click", (*) => App())
App() {
    AppScript := A_ScriptDir "\Application.ps1"
    RunWait '*RunAs powershell.exe -ExecutionPolicy Bypass -File "' AppScript '"'
}