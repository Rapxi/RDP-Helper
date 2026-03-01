#Requires AutoHotkey v2.0.18+
#SingleInstance Force
CoordMode("Pixel", "Client")

MyGui := Gui()
MyGui.Show("w400 h400")

ManualGB := MyGui.Add("GroupBox", "x10 y10 w380 h135 Center", "Manual")

ScriptBtn := MyGui.Add("Button", "x20 y30 w360 h30", "Create An Admin")
ScriptBtn.OnEvent("Click", (*) => Script())

WrapperBtn := MyGui.Add("Button", "x20 y70 w360 h30", "Update RDP Wrapper")
WrapperBtn.OnEvent("Click", (*) => Wrapper())

AppBtn := MyGui.Add("Button", "x20 y110 w360 h30", "Download RDP++")
AppBtn.OnEvent("Click", (*) => App())

ErrorFixingGB := MyGui.Add("GroupBox", "x10 y150 w380 h175 Center", "Error Fixing")

NumberOfConnectionsBtn := MyGui.Add("Button", "x20 y170 w360 h30", "Number Of Connections Fix")
NumberOfConnectionsBtn.OnEvent("Click", (*) => NumberOfConnections())

OpenRDPBtn := MyGui.Add("Button", "x20 y210 w360 h30", "Open RDP++")
OpenRDPBtn.OnEvent("Click", (*) => OpenRDPEXE())

RDPSettingsBtn := MyGui.Add("Button", "x20 y250 w360 h30", "Start RDP")
RDPSettingsBtn.OnEvent("Click", (*) => RDPSETTINGS())

NotListeningBtn := MyGui.Add("Button", "x20 y290 w360 h30", "Not Listening Fix")
NotListeningBtn.OnEvent("Click", (*) => NotListening())

AutomaticSetupGB := MyGui.Add("GroupBox", "x10 y330 w380 h55 Center", "Automatic Setup")
AIOBtn := MyGui.Add("Button", "x20 y350 w360 h30", "All In One")
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

NumberOfConnections() {
    RunWait '*RunAs "C:\Program Files\RDP Wrapper\autoupdate.bat"'
    ConnectionScript := A_ScriptDir "\Number-Of-Connections.ps1"
    RunWait '*RunAs powershell.exe  -ExecutionPolicy Bypass -File "' ConnectionScript '"'
}
RDPEXENOTINSTALLED() {
    counter := 0
    loop {
        counter++
        AppScript := A_ScriptDir "\Application.ps1"
        RunWait '*RunAs powershell.exe -ExecutionPolicy Bypass -File "' AppScript '"'
        sleep 200
        If FileExist("C:\Users\" A_UserName "\Downloads\rdp.exe") {
            MsgBox("RDP++ Installed")
            break
        }
        If counter > 9 {
            Run "https://www.donkz.nl/download/remote-desktop-plus/?tmstv=1771179612"
            sleep 200
            MsgBox("Brodie it aint working js install from here")
            break
        }
    }
}
OpenRDPEXE() {
    Run "C:\Users\" A_UserName "\Downloads\rdp.exe"
    WinWaitActive("ahk_exe rdp.exe")
}
RDPSETTINGS() {
    WinWaitActive("ahk_exe rdp.exe")
    sleep 500
    WinActivate("ahk_exe rdp.exe")
    sleep 500
    BetterClick(119, 86)
    BetterClick(120, 86)
    LocalHost := "127.0.0.2"
    LocalHostArr := StrSplit(LocalHost)
    for index, value in LocalHostArr {
        SendInput("{" value "}")
        sleep 30
    }
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
        else {
            SendInput("{" value "}")
            sleep 30
        }
    }
    sleep 200
    PassInputFunc() {
        PassArr := StrSplit(Pass)
        for index, value in PassArr {
            if value = " " {
                SendInput("{Space}")
            }
            else {
                SendInput("{" value "}")
                sleep 30
            }
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
NotListening() {
    MsgBox("Please restart your pc and press the All in One Button")
}
BetterClick(x, y) {
    MouseMove(x, y, 10)
    sleep 30
    Click
    sleep 200
}

Script() {
    psScript := A_ScriptDir "\Admin-Policy.ps1"
    RunWait '*RunAs powershell.exe  -ExecutionPolicy Bypass -File "' psScript '"'
    global SaveCompleted := true
}

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

App() {
    RDPEXENOTINSTALLED()
    OpenRDPEXE()
    RDPSETTINGS()
}
F3:: ExitApp
F4:: Reload
F9:: RDPEXENOTINSTALLED()