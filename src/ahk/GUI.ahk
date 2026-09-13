#Requires AutoHotkey v2.0.18+
#SingleInstance Force
CoordMode("Pixel", "Client")

#Include Functions.ahk

MyGui := Gui()
MyGui.Show("w400 h440")

MyGui.Add("GroupBox", "x10 y10 w380 h135 Center", "Manual")

ScriptBtn := MyGui.Add("Button", "x20 y30 w360 h30", "Create An Admin")
ScriptBtn.OnEvent("Click", (*) => RDP.Script())

WrapperBtn := MyGui.Add("Button", "x20 y70 w360 h30", "Update RDP Wrapper")
WrapperBtn.OnEvent("Click", (*) => RDP.Wrapper())

AppBtn := MyGui.Add("Button", "x20 y110 w360 h30", "Download RDP++")
AppBtn.OnEvent("Click", (*) => RDP.App())

CreateFavoriteBtn := MyGui.Add("Button", "x20 y150 w360 h30", "Favorite User")
CreateFavoriteBtn.OnEvent("Click", (*) => RDP.Create_Favorite())

MyGui.Add("GroupBox", "x10 y190 w380 h175 Center", "Error Fixing")

NumberOfConnectionsBtn := MyGui.Add("Button", "x20 y210 w360 h30", "Number Of Connections Fix")
NumberOfConnectionsBtn.OnEvent("Click", (*) => RDP.Number_Of_Connections())

OpenRDPBtn := MyGui.Add("Button", "x20 y250 w360 h30", "Open RDP++")
OpenRDPBtn.OnEvent("Click", (*) => RDP.Open_RDP_EXE())

RDPSettingsBtn := MyGui.Add("Button", "x20 y290 w360 h30", "Start RDP")
RDPSettingsBtn.OnEvent("Click", (*) => RDP.RDP_SETTINGS())

NotListeningBtn := MyGui.Add("Button", "x20 y330 w360 h30", "Not Listening Fix")
NotListeningBtn.OnEvent("Click", (*) => RDP.Not_Listening())

MyGui.Add("GroupBox", "x10 y370 w380 h55 Center", "Automatic Setup")
AIOBtn := MyGui.Add("Button", "x20 y390 w360 h30", "All In One")
AIOBtn.OnEvent("Click", (*) => AIO())

F3:: ExitApp
F4:: Reload