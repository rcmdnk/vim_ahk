#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
; #warn

; Auto-execute section
VimScriptPath := A_LineFile
Vim := new VimAhk()
Return

#Include %A_LineFile%\..\lib\vim_ahk.ahk
