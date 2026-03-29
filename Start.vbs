Set WshShell = CreateObject("WScript.Shell")

' Finde den Ordner heraus, in dem dieses Skript liegt
strPath = WScript.ScriptFullName
strFolder = Left(strPath, InStrRev(strPath, "\"))

' Starte die PowerShell komplett unsichtbar (die "0" am Ende macht das Fenster unsichtbar)
WshShell.Run "powershell.exe -ExecutionPolicy Bypass -WindowStyle Hidden -File """ & strFolder & "01_Start.ps1""", 0, False