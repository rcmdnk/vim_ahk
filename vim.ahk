#Requires AutoHotkey v1.1

; Auto-execute section
VimScriptPath := A_LineFile
Vim := new VimAhk()
Return

#Include %A_LineFile%\..\lib\vim_ahk.ahk
