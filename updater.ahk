#Requires AutoHotkey v2.0

class GithubClass {
    link := ""

    __New(github_user, repo) {
        this.link := "https://github.com/" github_user "/" repo
    }

    GetLatestVersionURL(item) {
        return this.link "/releases/latest/download/" item
    }
}

macro_path := A_ScriptDir "\Main.ahk"

try FileDelete(macro_path)

Sleep 1000

try {
    g := GithubClass("Rapxi", "RDP-Helper")

    Download(g.GetLatestVersionURL("Main.ahk"), macro_path)

    if !FileExist(macro_path)
        throw Error("Download failed: file does not exist.")

    if FileGetSize(macro_path) < 100000
        throw Error("Download failed: file is too small.")

    f := FileOpen(macro_path, "r")
    sig := f.Read(2)
    f.Close()

    if sig != "MZ"
        throw Error("Download failed: file is not a valid EXE.")

} catch Error as e {
    MsgBox "Updater error:`n" e.Message
    ExitApp
}

Sleep 500
Run macro_path
ExitApp