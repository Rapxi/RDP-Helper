#Requires AutoHotkey v2.0
#SingleInstance Force

CoordMode("Pixel", "Client")

Class Helper {

    static Root() {
        path := A_ScriptDir

        loop {
            if DirExist(path . "\src")
                return path
            SplitPath(path, , &path)
        }
    }

    static BetterClick(x, y) {
        MouseMove(x, y, 10)
        sleep 30
        Click
        sleep 200
    }

    static Logger(Message, Level := "INFO") {
        Time := FormatTime(, "HH:mm-dd/MM/yyyy")

        Logging := Level . " | " . Message . " | " . Time

        LogDir := Helper.Root() "\logs"
        DirCreate(LogDir)

        Log_File := LogDir . "\" . FormatTime(, "dd-MM-yyyy") . ".log"

        FileAppend(Logging . "`n", Log_File)
    }
}


AIO() {
    global SaveCompleted := false

    RDP.Script()

    while !SaveCompleted {
        Sleep 100
    }

    RDP.Wrapper()

    RDP.App()
    sleep 200

    Helper.BetterClick(288, 403)

}
Class RDP {
    static Number_Of_Connections() {
        RunWait '*RunAs "C:\Program Files\RDP Wrapper\autoupdate.bat"'

        ConnectionScript := Helper.Root() "\src\scripts\Number-Of-Connections.ps1"

        RunWait '*RunAs powershell.exe  -ExecutionPolicy Bypass -File "' ConnectionScript '"'
    }


    static RDP_EXE_NOT_INSTALLED() {
        counter := 0
        loop {
            counter++

            AppScript := Helper.Root() "\src\scripts\Application.ps1"

            RunWait '*RunAs powershell.exe -ExecutionPolicy Bypass -File "' AppScript '"'
            sleep 200

            If FileExist("C:\Users\" A_UserName "\Downloads\rdp.exe") {
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

    static Open_RDP_EXE() {
        Run "C:\Users\" A_UserName "\Downloads\rdp.exe"

        WinWaitActive("ahk_exe rdp.exe")
    }

    static RDP_SETTINGS() {
        WinWaitActive("ahk_exe rdp.exe")
        sleep 500

        WinActivate("ahk_exe rdp.exe")
        sleep 500

        Helper.BetterClick(119, 86)
        Helper.BetterClick(120, 86)
        Helper.Logger("Click on Computers (127.0.0.2)")

        SendInput("127.0.0.2")
        sleep 500

        Helper.BetterClick(348, 218)
        Helper.Logger("Click on Manage Profiles")

        Helper.BetterClick(48, 322)
        Helper.Logger("Click on Add in Manage Profiles GUI")

        SendInput("{R}")
        sleep 30

        SendInput("{D}")
        sleep 30

        SendInput("{P}")
        sleep 200

        Helper.BetterClick(162, 101)
        Helper.Logger("Click on Username")

        FileR := FileOpen(Helper.Root() "\Profile.txt", "r")

        User := FileR.ReadLine()
        Pass := FileR.ReadLine()

        FileR.Close()

        SendInput(User)
        sleep 200

        Helper.BetterClick(162, 124)
        Helper.Logger("Click on Password")

        SendInput(Pass)

        Helper.BetterClick(162, 153)
        Helper.Logger("Click on confirm Password")

        SendInput(Pass)
        sleep 200

        Helper.BetterClick(193, 242)
        sleep 200

        Helper.BetterClick(280, 100)
        sleep 200

        SendInput("{Left}")
        sleep 30

        SendInput("{Enter}")
        sleep 200

        WinActivate("ahk_exe rdp.exe")

        Helper.BetterClick(543, 371)
        ;Helper.BetterClick(210, 316)
        ; Helper.BetterClick(288, 403) Uncomment if you want it to connect automatically
    }

    static Not_Listening() {
        MsgBox("Please restart your pc and press the All in One Button")

        return
    }

    static Script() {
        psScript := Helper.Root() "\src\scripts\Admin-Policy.ps1"

        RunWait '*RunAs powershell.exe  -ExecutionPolicy Bypass -File "' psScript '"'

        global SaveCompleted := true
    }

    static Wrapper() {
        WrapperScript := Helper.Root() "\src\scripts\Wrapper.ps1"

        RunWait '*RunAs powershell.exe  -ExecutionPolicy Bypass -File "' WrapperScript '"'
        RunWait '*RunAs "C:\Program Files\RDP Wrapper\autoupdate.bat"'

        ListeningScript := Helper.Root() "\src\scripts\listening-check.ps1"

        exitcode := RunWait('*RunAs powershell.exe  -NoProfile -ExecutionPolicy Bypass -File "' ListeningScript '"')

        if !(exitcode = 0) {
            MsgBox("Please Restart your Pc`nClick on the Download RDP++ Button after Restarting")
            ExitApp
        }
    }

    static Create_Favorite() {

        WinWaitActive("ahk_exe rdp.exe")
        WinActivate("ahk_exe rdp.exe")
        sleep 500

        Helper.BetterClick(330, 410)
        Helper.BetterClick(320, 459)
        Helper.BetterClick(45, 324)
        Helper.BetterClick(205, 55)
        sleep 200

        SendInput("{R}")
        sleep 30

        SendInput("{D}")
        sleep 30

        SendInput("{P}")
        Sleep 200

        Helper.BetterClick(254, 102)
        sleep 200

        SendInput('/v:127.0.0.2 /i:""RDP"" /title:""RDP"" /nodrives /nosound /nowallpaper /o:""keyboardhook:i:1"" /w:1920 /h:1080')
        sleep 500

        Helper.BetterClick(360, 233)
        sleep 500
        Helper.BetterClick(257, 100)
        Helper.BetterClick(514, 322)

        sleep 300
        WinActivate("ahk_exe rdp.exe")
        Helper.BetterClick(367, 79)

        sleep 300
        Helper.BetterClick(546, 370)
        
        ;Helper.BetterClick(354, 81)
        ;Helper.BetterClick(550, 368)
    }

    static App() {
        RDP.RDP_EXE_NOT_INSTALLED()

        RDP.Open_RDP_EXE()

        RDP.RDP_SETTINGS()

        RDP.Create_Favorite()
    }

}