; Onenote requires signin before starting useability.
; This subverts that.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
#SingleInstance Force
SetTitleMatchMode 2
#include %A_ScriptDir%\vim_onenote_library.ahk
DetectHiddenWindows, on 

; Open remote desktop link to same computer, to force gui stuff to run
EnvGet,rdpPass,rdpPass
; If blank, get defualt pw from reg
if rdpPass==
    RegRead, rdpPass,HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon,DefaultPassword
run, "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Accessories\Remote Desktop Connection.lnk"
sleep, 2000
send 127.0.0.4:3389{return}
sleep, 3000
ToolTip, %rdpPass%, 0,0
send appveyor{tab}%rdpPass%{return}
sleep, 3000
send {left}{return}
sleep, 3000


; Registry entry to run GUI stuff on remote desktop
RegContents =
(
Windows Registry Editor Version 5.00`r
`r
[HKEY_LOCAL_MACHINE\Software\Microsoft\Terminal Server Client]`r
"RemoteDesktop_SuppressWhenMinimized"=dword:2`r
[HKEY_CURRENT_USER\Software\Microsoft\Terminal Server Client]`r
"RemoteDesktop_SuppressWhenMinimized"=dword:2`r
[HKEY_CURRENT_USER\Software\Wow6432Node\Microsoft\Terminal Server Client]`r
"RemoteDesktop_SuppressWhenMinimized"=dword:2`r
)
RegFileName=%A_ScriptDir%\guiRun.reg
RegFile := FileOpen(RegFileName, "w")
RegFile.Write(RegContents)
RegFile.Close()
run %RegFileName%
sleep, 100
send {return}
sleep, 100
send {return}
sleep, 100
send {return}

; Program that unlocks the remote desktop to allow GUIS to run.
loop, 7
    Run % "*RunAs C:\Windows\System32\tscon.exe " (A_Index-1) " /dest:console",,HIDE

; Env variables encrypted by appveyor.
; Store login info to use for onenote registration.
; Env variables encrypted by appveyor.
; Store login info to use for onenote registration.
EnvGet,ONUser,OnenoteUser
EnvGet,ONPass,OnenotePass

run, gvim,,,VimPID
Run, OneNote,,,OneNotePID

sleep, 2500
WinActivate,OneNote
WaitForWindowToActivate("OneNote")
sleep, 2500
send {return}
WaitForWindowToActivate("Accounts")
sleep, 2000
send %ONUser%
send {return}
sleep, 3500
send %ONPass%{return}
WaitForWindowToActivate("Office")
send {return}
sleep, 200
WinActivate,OneNote
WaitForWindowToActivate("OneNote ") ; Wait for onenote to start
; wait for notebook load
sleep, 3500


/* Not using this method because it is too unreliable for testing

; Demo .one file to skip new notebook creation
UrlDownloadToFile, https://www.onenotegem.com/uploads/8/5/1/8/8518752/things_to_do_list.one, %A_Scriptdir%\test.one

; This registry entry bypasses the signin.
RegContents =
(
Windows Registry Editor Version 5.00`r
`r
[HKEY_CURRENT_USER\Software\Microsoft\Office\16.0\OneNote]`r
"FirstBootStatus"=dword:01000101`r
"OneNoteName"="OneNote"`r
)
RegFileName=%A_ScriptDir%\avoidONSignin.reg
RegFile := FileOpen(RegFileName, "w")
RegFile.Write(RegContents)
RegFile.Close()
run %RegFileName%
sleep, 50
send {return}
sleep, 50
send {return}
sleep, 50
send {return}

Run, OneNote,,,OneNotePID
; WaitForWindowToActivate(" - Microsoft OneNote "); Wait for onenote to start
sleep, 500
send {return}
WinActivate,OneNote
WaitForWindowToActivate("OneNote")
; Skip signin dialogues, add new notebook.
send {return}
sleep, 100
send {return}
sleep, 500

run C:\projects\vim-keybindings-for-onenote\test.one
sleep, 200
WaitForWindowToActivate("OneNote "); Wait for onenote to start
sleep, 501
WinActivate,OneNote
WaitForWindowToActivate("OneNote")
send ^n{return}
sleep, 700
send {return}
*/