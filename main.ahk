#Requires AutoHotkey v2.0.18+
#SingleInstance Force

CoordMode("Pixel", "Client")

MyGui := Gui()
MyGui.Show("w400 h150")
ScriptBtn := MyGui.Add("Button", "x20 y20 w360 h30", "Create An Admin")
ScriptBtn.OnEvent("Click", (*) => Script())
Script() {
    psScript := A_ScriptDir "\Admin-Policy.ps1"
    RunWait '*RunAs powershell.exe  -ExecutionPolicy Bypass -File "' psScript '"'

    MsgBox("Please Note this is only for saving one profile.")
    UPGui := Gui()
    UPGui.Show("w200 h150")
    MyGui.Hide()

    UserGui := UPGui.Add("Text", "x20 y10 w160 h30", "Username")
    UserInput := UPGui.Add("Edit", "x20 y30 w160 h30")

    PassGui := UPGui.Add("Text", "x20 y70 w160 h30", "Password")
    PassInput := UPGui.Add("Edit", "x20 y90 w160 h30")

    SaveBtn := UPGui.Add("Button", "x20 y120 w160 h30", "Save")
    SaveBtn.OnEvent("Click", (*) => Save())
    Save() {
        FileW := FileOpen(A_ScriptDir "\Profile.txt", "w")
        FileW.WriteLine(Userinput.Value)
        FileW.WriteLine(PassInput.Value)
        FileW.Close()
        MsgBox("Saved")
        MyGui.Show()
        UpGui.Destroy()
    }
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


F3:: ExitApp
F4:: Reload