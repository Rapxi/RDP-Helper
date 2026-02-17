#Requires AutoHotkey v2.0.18+
#SingleInstance Force
CoordMode("Pixel", "Client")

MyGui := Gui()
MyGui.Show("w400 h200")
ScriptBtn := MyGui.Add("Button", "x20 y20 w360 h30", "Create An Admin")
ScriptBtn.OnEvent("Click", (*) => Script())
Script() {
    psScript := A_ScriptDir "\Admin-Policy.ps1"
    RunWait '*RunAs powershell.exe  -ExecutionPolicy Bypass -File "' psScript '"'
    global SaveCompleted := true
}
WrapperBtn := MyGui.Add("Button", "x20 y60 w360 h30", "Update RDP Wrapper")
WrapperBtn.OnEvent("Click", (*) => Wrapper())
Wrapper() {
    WrapperScript := A_ScriptDir "\Wrapper.ps1"
    RunWait '*RunAs powershell.exe  -ExecutionPolicy Bypass -File "' WrapperScript '"'
    RunWait '*RunAs "C:\Program Files\RDP Wrapper\autoupdate.bat"'

    ListeningScript := A_ScriptDir "\listening-check.ps1"

    exitcode := RunWait('*RunAs powershell.exe  -NoProfile -ExecutionPolicy Bypass -File "' ListeningScript '"')

    if !(exitcode = 0) {
        MsgBox("Please Restart your Pc`nClick on the Download RDP++ Button after Restarting")
        ExitApp
    }
}
BetterClick(x, y) {
    MouseMove(x, y, 10)
    sleep 30
    Click
    sleep 200
}
AppBtn := MyGui.Add("Button", "x20 y100 w360 h30", "Download RDP++")
AppBtn.OnEvent("Click", (*) => App())
App() {
    AppScript := A_ScriptDir "\Application.ps1"
    RunWait '*RunAs powershell.exe -ExecutionPolicy Bypass -File "' AppScript '"'
    sleep 200
    Run "C:\Users\" A_UserName "\Downloads\rdp.exe"
    WinWaitActive("ahk_exe rdp.exe")
    sleep 500
    WinActivate("ahk_exe rdp.exe")
    sleep 500
    BetterClick(348, 218)
    BetterClick(48, 322)
    SendInput("{R}")
    sleep 30
    SendInput("{D}")
    sleep 30
    SendInput("{P}")
    sleep 200
    BetterClick(162, 101)

    FileR := FileOpen(A_ScriptDir "\Profile.txt", "r")
    User := FileR.ReadLine()
    Pass := FileR.ReadLine()
    FileR.Close()
    UserArr := StrSplit(User)
    for index, value in UserArr {
        if value = " " {
            SendInput("{Space}")
        }
        SendInput("{" value "}")
        sleep 30
    }
    sleep 200
    PassInputFunc() {
        PassArr := StrSplit(Pass)
        for index, value in PassArr {
            if value = " " {
                SendInput("{Space}")
            }
            SendInput("{" value "}")
            sleep 30
        }
    }
    sleep 200
    BetterClick(162, 124)
    PassInputFunc()
    BetterClick(162, 153)
    PassInputFunc()
    sleep 200
    MouseMove(191, 249, 10)
    SendInput("{Left}")
    sleep 30
    SendInput("{Enter}")
    sleep 200
    BetterClick(543, 371)
    BetterClick(210, 316)
    BetterClick(288, 403)
}
AIOBtn := MyGui.Add("Button", "x20 y160 w360 h30", "All In One")
AIOBtn.OnEvent("Click", (*) => AIO())
AIO() {
    global SaveCompleted := false

    Script()
    while !SaveCompleted {
        Sleep 100
    }
    Wrapper()
    App()
}
F3:: ExitApp
F4:: Reload