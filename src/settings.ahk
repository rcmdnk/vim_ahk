VimSection := "Vim Ahk Settings"

; Ini file
VimIniDir := % A_AppData . "\AutoHotkey"
VimIni := % VimIniDir . "\vim_ahk.ini"

; Application groups {{{

VimGroupDel := ","
VimGroupN := 0

; Enable vim mode for following applications
VimGroup_TT := "Set one application per line.`n`nIt can be any of Window Title, Class or Process.`nYou can check these values by Window Spy (in the right click menu of tray icon)."
;VimGroupList_TT := VimGroup_TT
VimGroupText_TT := VimGroup_TT
VimGroupIni :=                             "ahk_exe notepad.exe"   ; NotePad
VimGroupIni := VimGroupIni . VimGroupDel . "ahk_exe explorer.exe"  ; Explorer
VimGroupIni := VimGroupIni . VimGroupDel . "ahk_exe wordpad.exe"   ; WordPad
VimGroupIni := VimGroupIni . VimGroupDel . "ahk_exe TeraPad.exe"   ; TeraPad
VimGroupIni := VimGroupIni . VimGroupDel . "作成"                  ;Thunderbird, 日本語
VimGroupIni := VimGroupIni . VimGroupDel . "Write:"                ;Thuderbird, English
VimGroupIni := VimGroupIni . VimGroupDel . "ahk_exe POWERPNT.exe"  ; PowerPoint
VimGroupIni := VimGroupIni . VimGroupDel . "ahk_exe WINWORD.exe"   ; Word
VimGroupIni := VimGroupIni . VimGroupDel . "ahk_exe Evernote.exe"  ; Evernote
VimGroupIni := VimGroupIni . VimGroupDel . "ahk_exe Code.exe"      ; Visual Studio Code
VimGroupIni := VimGroupIni . VimGroupDel . "ahk_exe onenote.exe"   ; OneNote Desktop
VimGroupIni := VimGroupIni . VimGroupDel . "OneNote"               ; OneNote in Windows 10
VimGroupIni := VimGroupIni . VimGroupDel . "ahk_exe texworks.exe"  ; TexWork
VimGroupIni := VimGroupIni . VimGroupDel . "ahk_exe texstudio.exe" ; TexStudio

VimGroup := VimGroupIni

; Following application select the line break at Shift + End.
GroupAdd, VimLBSelectGroup, ahk_exe POWERPNT.exe ; PowerPoint
GroupAdd, VimLBSelectGroup, ahk_exe WINWORD.exe  ; Word
GroupAdd, VimLBSelectGroup, ahk_exe wordpad.exe  ; WordPad

; OneNote before Windows 10
GroupAdd, VimOneNoteGroup, ahk_exe onenote.exe ; OneNote Desktop

; Need Home twice
GroupAdd, VimDoubleHomeGroup, ahk_exe Code.exe ; Visual Studio Code

; Followings can emulate ^. For others, ^ works as same as 0
GroupAdd, VimCaretMove, ahk_exe notepad.exe ; NotePad

; Followings start cursor from the same place after selection.
; Others start right/left (by cursor) point of the selection
GroupAdd, VimCursorSameAfterSelect, ahk_exe notepad.exe ; NotePad
GroupAdd, VimCursorSameAfterSelect, ahk_exe exproloer.exe ; Explorer
; }}}

; Disable unused keys in Normal mode
VimDisableUnusedIni := 3
if VimDisableUnused is not integer
  VimDisableUnused := VimDisableUnusedIni
VimDisableUnused1 := "1: Do not disable unused keys"
VimDisableUnused2 := "2: Disable alphabets (+shift) and symbols"
VimDisableUnused3 := "3: Disable all including keys with modifiers (e.g. Ctrl+Z)"
vimDisableUnusedMax := 3
VimDisableUnusedValue := ""
VimDisableUnusedValue_TT := "Disable unused keys in Normal mode"
VimDisableUnusedLevel_TT := VimDisableUnusedValue_TT

; Tray Icon check interval
VimIconCheckIntervalIni := 1000
if VimIconCheckInterval is not integer
  VimIconCheckInterval := VimIconCheckIntervalIni
VimIconCheckInterval_TT := "Interval (ms) to check if current window is for Ahk Vim or not,`nand set tray icon."
VimIconCheckIntervalText_TT := VimIconCheckInterval_TT
VimIconCheckIntervalEdit_TT := VimIconCheckInterval_TT

; Verbose level, 1: No pop up, 2: Minimum tool tips of status, 3: More info in tool tips, 4: Debug mode with a message box, which doesn't disappear automatically
VimVerboseIni := 1
if VimVerbose is not integer
  VimVerbose := VimVerboseIni
VimVerbose1 := "1: No pop up"
VimVerbose2 := "2: Minimum tool tips"
VimVerbose3 := "3: Tool tips"
VimVerbose4 := "4: Popup message"
vimVerboseMax := 4
VimVerboseValue := ""
VimVerboseValue_TT := "Verbose level`n`n1: No pop up`n2: Minimum tool tips of status`n: More info in tool tips`n4: Debug mode with a message box, which doesn't disappear automatically"
VimVerboseLevel_TT := VimVerboseValue_TT

; Other explanations for settings
VimGuiSettingsOK_TT := "Reflect changes and exit"
VimGuiSettingsReset_TT := "Reset to the default values"
VimGuiSettingsCancel_TT := "Don't change and exit"
VimAhkGitHub_TT := VimHomepage

VimReadIni(){
  global
  IniRead, VimGroup, %VimIni%, %VimSection%, VimGroup, %VimGroup%
  IniRead, VimDisableUnused, %VimIni%, %VimSection%, VimDisableUnused, %VimDisableUnused%
  IniRead, VimRestoreIME, %VimIni%, %VimSection%, VimRestoreIME, %VimRestoreIME%
  IniRead, VimJJ, %VimIni%, %VimSection%, VimJJ, %VimJJ%
  IniRead, VimJK, %VimIni%, %VimSection%, VimJK, %VimJK%
  IniRead, VimSD, %VimIni%, %VimSection%, VimSD, %VimSD%
  IniRead, VimIcon, %VimIni%, %VimSection%, VimIcon, %VimIcon%
  IniRead, VimIconCheck, %VimIni%, %VimSection%, VimIconCheck, %VimIconCheck%
  IniRead, VimIconCheckInterval, %VimIni%, %VimSection%, VimIconCheckInterval, %VimIconCheckInterval%
  IniRead, VimVerbose, %VimIni%, %VimSection%, VimVerbose, %VimVerbose%
}


; Read Ini
; VimReadIni()

; Set group
VimSetGroup()

VimWriteIni(){
  global
  IfNotExist, %VimIniDir%
    FileCreateDir, %VimIniDir%

  VimGroup := ""
  Loop, Parse, VimGroupList, `n
  {
    if(! InStr(VimGroup, A_LoopField)){
      if(VimGroup == ""){
        VimGroup := A_LoopField
      }else{
        VimGroup := VimGroup . VimGroupDel . A_LoopField
      }
    }
  }
  VimSetGroup()
  IniWrite, % VimGroup, % VimIni, % VimSection, VimGroup
  IniWrite, % VimDisableUnused, % VimIni, % VimSection, VimDisableUnused
  IniWrite, % VimRestoreIME, % VimIni, % VimSection, VimRestoreIME
  IniWrite, % VimJJ, % VimIni, % VimSection, VimJJ
  IniWrite, % VimJK, % VimIni, % VimSection, VimJK
  IniWrite, % VimSD, % VimIni, % VimSection, VimSD
  IniWrite, % VimIcon, % VimIni, % VimSection, VimIcon
  IniWrite, % VimIconCheck, % VimIni, % VimSection, VimIconCheck
  IniWrite, % VimIconCheckInterval, % VimIni, % VimSection, VimIconCheckInterval
  IniWrite, % VimVerbose, % VimIni, % VimSection, VimVerbose
}


; vim: foldmethod=marker
; vim: foldmarker={{{,}}}
