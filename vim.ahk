; Auto-execute section {{{
; About vim_ahk
VimVersion := "v0.1.0"
VimDate := "09/Nov/2017"
VimAuthor := "rcmdnk"
VimDescription := "Vim emulation with AutoHotKey, everywhere in Windows."
VimHomepage := "https://github.com/rcmdnk/vim_ahk"

; Ini file
VimIniDir := % A_AppData . "\AutoHotkey"
VimIni := % VimIniDir . "\vim_ahk.ini"

VimSection := "Vim Ahk Settings"

; Icon places
VimIconNormal := % A_LineFile . "\..\icons\normal.ico"
VimIconInsert := % A_LineFile . "\..\icons\insert.ico"
VimIconVisual := % A_LineFile . "\..\icons\visual.ico"
VimIconCommand := % A_LineFile . "\..\icons\command.ico"
VimIconDisabled := % A_AhkPath

; Application groups {{{

; Enable vim mode for following applications
GroupAdd VimGroup, ahk_exe notepad.exe ; NotePad
GroupAdd VimGroup, ahk_exe wordpad.exe ; WordPad
GroupAdd VimGroup, ahk_exe TeraPad.exe ; TeraPad
GroupAdd VimGroup, ahk_exe explorer.exe
GroupAdd VimGroup, 作成 ;Thunderbird, 日本語
GroupAdd VimGroup, Write: ;Thuderbird, English
GroupAdd VimGroup, ahk_exe POWERPNT.exe ; PowerPoint
GroupAdd VimGroup, ahk_exe WINWORD.exe ; Word
GroupAdd VimGroup, ahk_exe Evernote.exe ; Evernote
GroupAdd VimGroup, ahk_exe Code.exe ; Visual Studio Code
GroupAdd VimGroup, ahk_exe onenote.exe ; OneNote Desktop
GroupAdd VimGroup, OneNote ; OneNote in Windows 10
GroupAdd VimGroup, ahk_exe texworks.exe ; TexWork
GroupAdd VimGroup, ahk_exe texstudio.exe ; TexStudio

; Following application select the line break at Shift + End.
GroupAdd LBSelect, ahk_exe POWERPNT.exe ; PowerPoint
GroupAdd LBSelect, ahk_exe WINWORD.exe ; Word
GroupAdd LBSelect, ahk_exe wordpad.exe ; WordPad

; OneNote before Windows 10
GroupAdd OneNoteGroup, ahk_exe onenote.exe ; OneNote Desktop

; Need Home twice
GroupAdd DoubleHome, ahk_exe Code.exe ; Visual Studio Code
; }}}

; Setting variables
; First check if they are already set (in mother script).
; Second read settings if it exits.

; Verbose level, 1: No pop up, 2: Minimum tool tips of status, 3: More info in tool tips, 4: Debug mode with a message box, which doesn't disappear automatically
if VimVerbose is not integer
  VimVerbose := 1
VimVerbose1 := "1: No pop up"
VimVerbose2 := "2: Minimum tool tips"
VimVerbose3 := "3: Tool tips"
VimVerbose4 := "4: Popup message"
vimVerboseMax := 4
VimVerboseValue := ""
VimVerboseValue_TT := "Verbose level`n`n1: No pop up`n2: Minimum tool tips of status`n: More info in tool tips`n4: Debug mode with a message box, which doesn't disappear automatically"
VimVerboseLevel_TT := VimVerboseValue_TT

; If IME status is restored or not at entering insert mode. 1 for restoring. 0 for not to restore (always IME off at enterng insert mode).
if VimRestoreIME is not integer
  VimRestoreIME := 1
VimRestoreIME_TT := "Check to restore IME status at entering insert mode."

; Set 1 to asign jj to enter Normal mode
if VimJJ is not integer
  VimJJ := 0
VimJJ_TT := "Check to asign jj to enter Normal mode"

; Set 1 to enable Tray Icon for Vim Modes`nSet 0 for original Icon
if VimIcon is not integer
  VimIcon := 1
VimIcon_TT := "Check to enable Tray Icon for Vim Modes"
VimAhkGitHub_TT := VimHomepage

; Read Ini
VimReadIni()

; Starting variables
VimMode := "Insert"
Vim_g := 0
Vim_n := 0
VimLineCopy := 0
VimLastIME := 0

; Menu
;Menu, VimSubMenu, Add, Vim Check, MenuVimCheck
Menu, VimSubMenu, Add, Settings, MenuVimSettings
Menu, VimSubMenu, Add
Menu, VimSubMenu, Add, Status, MenuVimStatus
Menu, VimSubMenu, Add, About vim_ahk, MenuVimAbout

Menu, Tray, Add
Menu, Tray, Add, VimMenu, :VimSubMenu

; Set initial icon
VimSetIcon(VimMode)

Return

; }}}

; Menu functions {{{
;MenuVimCheck:
;  ; Additional message is necessary before checking current window.
;  ; Otherwise process name cannot be retrieved...?
;  Msgbox, , Vim Ahk, Checking current window...
;  WinGet, process, PID, A
;  WinGet, name, ProcessName, ahk_pid %process%
;  WinGetClass, class, ahk_pid %process%
;  WinGetTitle, title, ahk_pid %process%
;  if WInActive("ahk_group VimGroup"){
;    Msgbox, 0x40, Vim Ahk,
;    (
;      Supported
;      Process name: %name%
;      Class       : %class%
;      Title       : %title%
;    )
;  }else{
;    Msgbox, 0x10, Vim Ahk,
;    (
;      Not supported
;      Process name: %name%
;      Class       : %class%
;      Title       : %title%
;    )
;  }
;Return

MenuVimStatus:
  VimCheckMode(VimVerboseMax, , , , 1)
Return

MenuVimSettings:
  Gui, VimGuiSettings:+LabelVimGuiSettings
  Gui, VimGuiSettings:-MinimizeBox
  Gui, VimGuiSettings:-Resize
  if(VimRestoreIME == 1){
    Gui, VimGuiSettings:Add, Checkbox, xm Checked vVimRestoreIME, Restore IIME
  }else{
    Gui, VimGuiSettings:Add, Checkbox, xm vVimRestoreIME, Restore IIME
  }
  if(VimJJ == 1){
    Gui, VimGuiSettings:Add, Checkbox, xm Checked vVimJJ, JJ
  }else{
    Gui, VimGuiSettings:Add, Checkbox, xm vVimJJ, JJ
  }
  if(VimIcon == 1){
    Gui, VimGuiSettings:Add, Checkbox, xm Checked vVimIcon, Icon
  }else{
    Gui, VimGuiSettings:Add, Checkbox, xm vVimIcon, Icon
  }
  Gui, VimGuiSettings:Add, Text, Y+20 vVimVerboseLevel, Verbose level
  Gui, VimGuiSettings:Add, DropDownList, vVimVerboseValue Choose%VimVerbose%, %VimVerbose1%|%VimVerbose2%|%VimVerbose3%|%VimVerbose4%
  Gui, VimGuiSettings:Add, Text, Y+20, Check
  Gui, VimGuiSettings:Font, Underline
  Gui, VimGuiSettings:Add, Text, X+5 cBlue gVimAhkGitHub vVimAhkGitHub, HELP
  Gui, VimGuiSettings:Font, Norm
  Gui, VimGuiSettings:Add, Text, X+5, for further information.
  Gui, VimGuiSettings:Add, Button, gVimGuiSettingsOK xm W100 X45 Y+20 Default ,OK
  Gui, VimGuiSettings:Add, Button, gVimGuiSettingsCannel W100 X+10, Cancel
  Gui, VimGuiSettings:Show, W300, Vim Ahk Settings
  OnMessage(0x200, "WimMouseMove")
Return

WimMouseMove(){
  static CurrControl, PrevControl, _TT
  CurrControl := A_GuiControl
  if(CurrControl != PrevControl and not InStr(CurrControl, " ")){
    ToolTip
    SetTimer, VimDisplayToolTip, 1000
    PrevControl := CurrControl
  }
  Return

  VimDisplayToolTip:
  SetTimer, VimDisplayToolTip, Off
  ToolTip % %CurrControl%_TT
  SetTimer, VimRemoveToolTip, 60000
  return

  VimRemoveToolTip:
  SetTimer, VimRemoveToolTip, Off
  ToolTip
  return
}

VimGuiSettingsOK:
  Gui, VimGuiSettings:Submit
  Loop, %VimVerboseMax% {
    if(VimVerboseValue == VimVerbose%A_Index%){
      VimVerbose := A_Index
      Break
    }
  }
  VimWriteIni()
VimGuiSettingsCannel:
VimGuiSettingsClose:
VimGuiSettingsEscape:
  Gui, VimGuiSettings:Destroy
Return

VimVerboseLevel: ; Dummy to assign Gui Control
Return

VimAhkGitHub:
  Run %VimHomepage%
Return

MenuVimAbout:
  Gui, VimGuiAbout:+LabelVimGuiAbout
  Gui, VimGuiAbout:-MinimizeBox
  Gui, VimGuiAbout:-Resize
  Gui, VimGuiAbout:Add, Text, , Vim Ahk (vim_ahk):`n%VimDescription%
  Gui, VimGuiAbout:Font, Underline
  Gui, VimGuiAbout:Add, Text, Y+0 cBlue gVimAhkGitHub, Homepage
  Gui, VimGuiAbout:Font, Norm
  Gui, VimGuiAbout:Add, Text, , Author: %VimAuthor%
  Gui, VimGuiAbout:Add, Text, , Version: %VimVersion%
  Gui, VimGuiAbout:Add, Text, Y+0, Last update: %VimDate%
  Gui, VimGuiAbout:Add, Text, , Script path:`n%A_LineFile%
  Gui, VimGuiAbout:Add, Text, , Setting file:`n%VimIni%
  Gui, VimGuiAbout:Add, Button, gVimGuiAboutOK X200 W100 Default, OK
  Gui, VimGuiAbout:Show, W500, Vim Ahk
Return

VimGuiAboutOK:
VimGuiAboutClose:
VimGuiAboutEscape:
  Gui, VimGuiAbout:Destroy
Return
; }}}

; Settings {{{

#UseHook On ; Make it a bit slow, but can avoid infinitude loop
            ; Same as "$" for each hotkey
#InstallKeybdHook ; For checking key history
                  ; Use ~500kB memory?

#HotkeyInterval 2000 ; Hotkey inteval (default 2000 milliseconds).
#MaxHotkeysPerInterval 70 ; Max hotkeys perinterval (default 50).
;}}}

; IME {{{
; Ref for IME: http://www6.atwiki.jp/eamat/pages/17.html

; Get IME Status. 0: Off, 1: On
VIM_IME_GET(WinTitle="A"){
  ControlGet,hwnd,HWND,,,%WinTitle%
  if(WinActive(WinTitle)){
    ptrSize := !A_PtrSize ? 4 : A_PtrSize
    VarSetCapacity(stGTI, cbSize:=4+4+(PtrSize*6)+16, 0)
    NumPut(cbSize, stGTI, 0, "UInt") ; DWORD cbSize;
    hwnd := DllCall("GetGUIThreadInfo", Uint,0, Uint, &stGTI)
        ? NumGet(stGTI, 8+PtrSize, "UInt") : hwnd
  }

  Return DllCall("SendMessage"
      , UInt, DllCall("imm32\ImmGetDefaultIMEWnd", Uint, hwnd)
      , UInt, 0x0283  ;Message : WM_IME_CONTROL
      ,  Int, 0x0005  ;wParam  : IMC_GETOPENSTATUS
      ,  Int, 0)      ;lParam  : 0
}
; Get input status. 1: Converting, 2: Have converting window, 0: Others
VIM_IME_GetConverting(WinTitle="A", ConvCls="", CandCls=""){
  ; Input windows, candidate windows (Add new IME with "|")
  ConvCls .= (ConvCls ? "|" : "")                 ;--- Input Window ---
    .  "ATOK\d+CompStr"                           ; ATOK
    .  "|imejpstcnv\d+"                           ; MS-IME
    .  "|WXGIMEConv"                              ; WXG
    .  "|SKKIME\d+\.*\d+UCompStr"                 ; SKKIME Unicode
    .  "|MSCTFIME Composition"                    ; Google IME
  CandCls .= (CandCls ? "|" : "")                 ;--- Candidate Window ---
    .  "ATOK\d+Cand"                              ; ATOK
    .  "|imejpstCandList\d+|imejpstcand\d+"       ; MS-IME 2002(8.1)XP
    .  "|mscandui\d+\.candidate"                  ; MS Office IME-2007
    .  "|WXGIMECand"                              ; WXG
    .  "|SKKIME\d+\.*\d+UCand"                    ; SKKIME Unicode
  CandGCls := "GoogleJapaneseInputCandidateWindow" ; Google IME

  ControlGet, hwnd, HWND, , , %WinTitle%
  if(WinActive(WinTitle)){
    ptrSize := !A_PtrSize ? 4 : A_PtrSize
    VarSetCapacity(stGTI, cbSize:=4+4+(PtrSize*6)+16, 0)
    NumPut(cbSize, stGTI, 0, "UInt")   ;   DWORD   cbSize;
    hwnd := DllCall("GetGUIThreadInfo", Uint, 0, Uint,&stGTI)
      ? NumGet(stGTI, 8+PtrSize, "UInt") : hwnd
  }

  WinGet, pid, PID,% "ahk_id " hwnd
  tmm := A_TitleMatchMode
  SetTitleMatchMode, RegEx
  ret := WinExist("ahk_class " . CandCls . " ahk_pid " pid) ? 2
      :  WinExist("ahk_class " . CandGCls                 ) ? 2
      :  WinExist("ahk_class " . ConvCls . " ahk_pid " pid) ? 1
      :  0
  SetTitleMatchMode, %tmm%
  Return ret
}

; Set IME, SetSts=0: Off, 1: On, return 0 for success, others for non-success
VIM_IME_SET(SetSts=0, WinTitle="A"){
  ControlGet, hwnd, HWND, , , %WinTitle%
  if(WinActive(WinTitle)){
    ptrSize := !A_PtrSize ? 4 : A_PtrSize
    VarSetCapacity(stGTI, cbSize:=4+4+(PtrSize*6)+16, 0)
    NumPut(cbSize, stGTI, 0, "UInt") ; DWORD cbSize;
    hwnd := DllCall("GetGUIThreadInfo", Uint, 0, Uint, &stGTI)
        ? NumGet(stGTI, 8+PtrSize, "UInt") : hwnd
  }

  Return DllCall("SendMessage"
    , UInt, DllCall("imm32\ImmGetDefaultIMEWnd", Uint, hwnd)
    , UInt, 0x0283  ;Message : WM_IME_CONTROL
    ,  Int, 0x006   ;wParam  : IMC_SETOPENSTATUS
    ,  Int, SetSts) ;lParam  : 0 or 1
}
; }}}

; Basic Functions {{{
VimSetIcon(Mode=""){
  global VimIcon, VimIconNormal, VimIconInsert, VimIconVisual, VimIconCommand, VimIconDisabled
  icon :=
  if InStr(Mode, "Normal"){
    icon := VimIconNormal
  }else if InStr(Mode, "Insert"){
    icon := VimIconInsert
  }else if InStr(Mode, "Visual"){
    icon := VimIconVisual
  }else if InStr(Mode, "Command"){
    icon := VimIconCommand
  }else if InStr(Mode, "Disabled"){
    icon := VimIconDisabled
  }
  if FileExist(icon){
    Menu, VimSubMenu, Icon, Status, %icon%
    if(VimIcon !=1 ){
      Return
    }
    Menu, Tray, Icon, %icon%
  }
}

VimSetMode(Mode="", g=0, n=0, LineCopy=-1){
  global
  if(Mode != ""){
    VimMode := Mode
    If(Mode == "Insert") and (VimRestoreIME == 1){
      VIM_IME_SET(VimLastIME)
    }
    VimSetIcon(VimMode)
  }
  if(g != -1){
    Vim_g := g
  }
  if(n != -1){
    Vim_n := n
  }
  if(LineCopy!=-1){
    VimLineCopy := LineCopy
  }
  VimCheckMode(VimVerbose, Mode, g, n, LineCopy)
  Return
}

VimCheckMode(verbose=1, Mode="", g=0, n=0, LineCopy=-1, force=0){
  global

  if(force == 0) and ((verbose <= 1) or ((Mode == "") and (g == 0) and (n == 0) and (LineCopy == -1))){
    Return
  }else if(verbose == 2){
    VimStatus(VimMode) ; 1 sec is minimum for TrayTip
  }else if(verbose == 3){
    VimStatus(VimMode "`r`ng=" Vim_g "`r`nn=" Vim_n "`r`nLineCopy=" VimLineCopy)
  }
  if(verbose >= 4){
    Msgbox, , Vim Ahk, VimMode: %VimMode%`nVim_g: %Vim_g%`nVim_n: %Vim_n%`nVimLineCopy: %VimLineCopy%
  }
  Return
}

VimStatus(Title){
  ;WinGetPos, , , W, H, A
  ;Tooltip, %Title%, W - 110, H - 100
  Tooltip, %Title%, 0, 0
  SetTimer, VimRemoveStatus, 1000
}

VimRemoveStatus:
  SetTimer, VimRemoveStatus, off
  Tooltip
Return

VimReadIni(ini=""){
  global
  if(ini == ""){
    ini := VimIni
  }
  IniRead, VimVerbose, %ini%, %VimSection%, VimVerbose, %VimVerbose%
  IniRead, VimRestoreIME, %ini%, %VimSection%, VimRestoreIME, %VimRestoreIME%
  IniRead, VimJJ, %ini%, %VimSection%, VimJJ, %VimJJ%
  IniRead, VimIcon, %ini%, %VimSection%, VimIcon, %VimIcon%
}

VimWriteIni(ini=""){
  global
  if(ini == ""){
    ini := VimIni
  }
  IfNotExist, %ini%\..\
    FileCreateDir, %ini%\..\

  IniWrite, %VimVerbose%, %ini%, %VimSection%, VimVerbose
  IniWrite, %VimRestoreIME%, %ini%, %VimSection%, VimRestoreIME
  IniWrite, %VimJJ%, %ini%, %VimSection%, VimJJ
  IniWrite, %VimIcon%, %ini%, %VimSection%, VimIcon
}

VimSetGuiOffset(offset=0){
  VimGuiAbout := offset + 1
  VimGuiSettings := offset + 2
  VimGuiVerbose := offset + 3
}
; }}}

; Vim mode {{{
#IfWInActive, ahk_group VimGroup

; Check Mode {{{
^!+c::
  VimCheckMode(VimVerboseMax, VimMode)
  Return
; }}}

; Enter vim normal mode {{{
Esc:: ; Just send Esc at converting, long press for normal Esc.
  KeyWait, Esc, T0.5
  if (ErrorLevel){ ; long press
    Send,{Esc}
    Return
  }
  VimLastIME := VIM_IME_Get()
  if(VimLastIME){
    if(VIM_IME_GetConverting(A)){
      Send,{Esc}
    }else{
      VIM_IME_SET()
      VimSetMode("Vim_Normal")
    }
  }else{
    VimSetMode("Vim_Normal")
  }
Return

^[:: ; Go to Normal mode (for vim) with IME off even at converting.
  KeyWait, [, T0.5
  if(ErrorLevel){ ; long press to Esc
    Send, {Esc}
    Return
  }
  VimLastIME:=VIM_IME_Get()
  if(VimLastIME){
    if(VIM_IME_GetConverting(A)){
      Send,{Esc}
    }else{
      VIM_IME_SET()
      VimSetMode("Vim_Normal")
    }
  }else{
    VimSetMode("Vim_Normal")
  }
Return

#If WInActive("ahk_group VimGroup") and (InStr(VimMode, "Insert")) and (VimJJ == 1)
~j up:: ; jj: go to Normal mode.
  Input, jout, I T0.1 V L1, j
  if(ErrorLevel == "EndKey:J"){
    SendInput, {BackSpace 2}
    VimSetMode("Vim_Normal")
  }
Return
; }}}

; Enter vim insert mode (Exit vim normal mode) {{{
#If WInActive("ahk_group VimGroup") && (VimMode == "Vim_Normal")
i::VimSetMode("Insert")

+i::
  Send, {Home}
  Sleep, 200
  VimSetMode("Insert")
Return

a::
  Send, {Right}
  VimSetMode("Insert")
Return

+a::
  Send, {End}
  Sleep, 200
  VimSetMode("Insert")
Return

o::
  Send,{End}{Enter}
  VimSetMode("Insert")
Return

+o::
  Send, {Up}{End}{Enter}
  Sleep, 200
  VimSetMode("Insert")
Return
; }}}

; Repeat {{{
#If WInActive("ahk_group VimGroup") and (InStr(VimMode,"Vim_"))
1::
2::
3::
4::
5::
6::
7::
8::
9::
  n_repeat := Vim_n*10 + A_ThisHotkey
  VimSetMode("", 0, n_repeat)
Return

#If WInActive("ahk_group VimGroup") and (InStr(VimMode,"Vim_")) and (Vim_n > 0)
0:: ; 0 is used as {Home} for Vim_n=0
  n_repeat := Vim_n*10 + A_ThisHotkey
  VimSetMode("", 0, n_repeat)
Return
; }}}

; Normal Mode Basic {{{
#If WInActive("ahk_group VimGroup") and (VimMode == "Vim_Normal")
; Undo/Redo
u::Send,^z
^r::Send,^y

; Combine lines
+j::Send, {Down}{Home}{BS}{Space}{Left}

; Change case
~::
  bak := ClipboardAll
  Clipboard =
  Send, +{Right}^x
  ClipWait, 1
  if(Clipboard is lower){
    ;Msgbox, , Vim Ahk, %Clipboard% is lower
    StringUpper, Clipboard, Clipboard
  }else if(Clipboard is upper){
    ;Msgbox, , Vim Ahk, %Clipboard% is upper
    StringLower, Clipboard, Clipboard
  }else{
    ;Msgbox, , Vim Ahk, %Clipboard% is others
  }
  Send, ^v
  Clipboard := bak
Return

+z::VimSetMode("Z")
#If WInActive("ahk_group VimGroup") and (VimMode == "Z")
+z::
  Send, ^s
  Send, !{F4}
  VimSetMode("Vim_Normal")
Return

+q::
  Send, !{F4}
  VimSetMode("Vim_Normal")
Return

#If WInActive("ahk_group VimGroup") and (VimMode == "Vim_Normal")
Space::Send, {Right}

; period
.::Send, +^{Right}{BS}^v
; }}}

; Replace {{{
#If WInActive("ahk_group VimGroup") and (VimMode == "Vim_Normal")
r::VimSetMode("r_once")
+r::VimSetMode("r_repeat")

#If WInActive("ahk_group VimGroup") and (VimMode == "r_once")
~a::
~b::
~c::
~d::
~e::
~f::
~g::
~h::
~i::
~j::
~k::
~l::
~m::
~n::
~o::
~p::
~q::
~r::
~s::
~t::
~u::
~v::
~w::
~x::
~y::
~z::
~0::
~1::
~2::
~3::
~4::
~5::
~6::
~7::
~8::
~9::
~`::
~~::
~!::
~@::
~#::
~$::
~%::
~^::
~&::
~*::
~(::
~)::
~-::
~_::
~=::
~+::
~[::
~{::
~]::
~}::
~\::
~|::
~;::
~'::
~"::
~,::
~<::
~.::
~>::
~Space::
  Send, {Del}
  VimSetMode("Vim_Normal")
Return

::: ; ":" can't be used with "~"?
  Send, {:}{Del}
  VimSetMode("Vim_Normal")
Return

#If WInActive("ahk_group VimGroup") and (VimMode == "r_repeat")
~a::
~b::
~c::
~d::
~e::
~f::
~g::
~h::
~i::
~j::
~k::
~l::
~m::
~n::
~o::
~p::
~q::
~r::
~s::
~t::
~u::
~v::
~w::
~x::
~y::
~z::
~0::
~1::
~2::
~3::
~4::
~5::
~6::
~7::
~8::
~9::
~`::
~~::
~!::
~@::
~#::
~$::
~%::
~^::
~&::
~*::
~(::
~)::
~-::
~_::
~=::
~+::
~[::
~{::
~]::
~}::
~\::
~|::
~;::
~'::
~"::
~,::
~<::
~.::
~>::
~Space::
  Send, {Del}
Return

:::
  Send, {:}{Del}
Return
; }}}

; Move {{{
; g {{{
#If WInActive("ahk_group VimGroup") and (InStr(VimMode,"Vim_")) and (not Vim_g)
g::VimSetMode("", 1)
; }}}

VimMove(key="", shift=0){
  global
  if(InStr(VimMode, "Visual") or InStr(VimMode, "ydc") or shift == 1){
    Send, {Shift Down}
  }
  ; Left/Right
  if(not InStr(VimMode, "Line")){
    ; 1 character
    if(key == "h"){
      Send, {Left}
    }else if(key == "l"){
      Send, {Right}
    ; Home/End
    }else if(key == "0"){
      Send, {Home}
    }else if(key == "$"){
      Send, {End}
    }else if(key == "^"){
      Send, {End}^{Right}
    ; Words
    }else if(key == "w"){
      Send, ^{Right}
    }else if(key == "b"){
      Send, ^{Left}
    }
  }
  ; Up/Down
  if(VimMode == "Vim_VisualLineFirst") and (key == "k" or key == "^u" or key == "^b" or key == "g"){
    Send, {Shift Up}{End}{Home}{Shift Down}{Up}
    VimSetMode("Vim_VisualLine")
  }
  if(InStr(VimMode, "Vim_ydc")) and (key == "k" or key == "^u" or key == "^b" or key == "g"){
    VimLineCopy := 1
    Send,{Shift Up}{Home}{Down}{Shift Down}{Up}
  }
  if(InStr(VimMode,"Vim_ydc")) and (key == "j" or key == "^d" or key == "^f" or key == "+g"){
    VimLineCopy := 1
    Send,{Shift Up}{Home}{Shift Down}{Down}
  }

  ; 1 character
  if(key == "j"){
    ; Only for OneNote of less than windows 10?
    if WinActive("ahk_group OneNoteGroup"){
      Send ^{Down}
    } else {
      Send,{Down}
    }
  }else if(key="k"){
    if WinActive("ahk_group OneNoteGroup"){
      Send ^{Up}
    }else{
      Send,{Up}
    }
  ; Page Up/Down
  }else if(key == "^u"){
    Send, {Up 10}
  }else if(key == "^d"){
    Send, {Down 10}
  }else if(key == "^b"){
    Send, {PgUp}
  }else if(key == "^f"){
    Send, {PgDn}
  }else if(key == "g"){
    Send, ^{Home}
  }else if(key == "+g"){
    ;Send, ^{End}{Home}
    Send, ^{End}
  }
  Send,{Shift Up}

  if(VimMode == "Vim_ydc_y"){
    Clipboard :=
    Send, ^c
    ClipWait, 1
    VimSetMode("Vim_Normal")
  }else if(VimMode == "Vim_ydc_d"){
    Clipboard :=
    Send, ^x
    ClipWait, 1
    VimSetMode("Vim_Normal")
  }else if(VimMode == ="Vim_ydc_c"){
    Clipboard :=
    Send, ^x
    ClipWait, 1
    VimSetMode("Insert")
  }
  VimSetMode("", 0, 0)
}
VimMoveLoop(key="", shift=0){
  global
  if(Vim_n == 0){
    Vim_n := 1
  }
  Loop, %Vim_n%{
    VimMove(key, shift)
  }
}
#If WInActive("ahk_group VimGroup") and (InStr(VimMode,"Vim_"))
; 1 character
h::VimMoveLoop("h")
j::VimMoveLoop("j")
k::VimMoveLoop("k")
l::VimMoveLoop("l")
^h::VimMoveLoop("h")
^j::VimMoveLoop("j")
^k::VimMoveLoop("k")
^l::VimMoveLoop("l")
; Home/End
0::VimMove("0")
$::VimMove("$")
^a::VimMove("0") ; Emacs like
^e::VimMove("$") ; Emacs like
^::VimMove("^")
; Words
w::VimMoveLoop("w")
+w::VimMoveLoop("w") ; +w/e/+e are same as w
e::VimMoveLoop("w")
+e::VimMoveLoop("w")
b::VimMoveLoop("b")
+b::VimMoveLoop("b") ; +b = b
; Page Up/Down
^u::VimMoveLoop("^u")
^d::VimMoveLoop("^d")
^b::VimMoveLoop("^b")
^f::VimMoveLoop("^f")
; G
+g::VimMove("+g")
; gg
#If WInActive("ahk_group VimGroup") and (InStr(VimMode, "Vim_")) and (Vim_g)
g::VimMove("g")
; }}} Move

; Copy/Cut/Paste (ydcxp){{{
; YDC
#If WInActive("ahk_group VimGroup") and (VimMode == "Vim_Normal")
y::VimSetMode("Vim_ydc_y", 0, -1, 0)
d::VimSetMode("Vim_ydc_d", 0, -1, 0)
c::VimSetMode("Vim_ydc_c", 0, -1, 0)
+y::
  VimSetMode("Vim_ydc_y", 0, 0, 1)
  Sleep, 150 ; Need to wait (For variable change?)
  if WinActive("ahk_group DoubleHome"){
    Send, {Home}
  }
  Send, {Home}+{End}
  if not WinActive("ahk_group LBSelect"){
    VimMove("l")
  }else{
    VimMove("")
  }
  Send, {Left}{Home}
Return

+d::
  VimSetMode("Vim_ydc_d", 0, 0, 0)
  if not WinActive("ahk_group LBSelect"){
    VimMove("$")
  }else{
    Send, {Shift Down}{End}{Left}
    VimMove("")
  }
Return

+c::
  VimSetMode("Vim_ydc_c",0,0,0)
  if not WinActive("ahk_group LBSelect"){
    VimMove("$")
  }else{
    Send, {Shift Down}{End}{Left}
    VimMove("")
  }
Return

#If WInActive("ahk_group VimGroup") and (VimMode == "Vim_ydc_y")
y::
  VimLineCopy := 1
  if WinActive("ahk_group DoubleHome"){
    Send, {Home}
  }
  Send, {Home}+{End}
  if not WinActive("ahk_group LBSelect"){
    VimMove("l")
  }else{
    VimMove("")
  }
  Send, {Left}{Home}
Return

#If WInActive("ahk_group VimGroup") and (VimMode == "Vim_ydc_d")
d::
  VimLineCopy := 1
  if WinActive("ahk_group DoubleHome"){
    Send, {Home}
  }
  Send, {Home}+{End}
  if not WinActive("ahk_group LBSelect"){
    VimMove("l")
  }else{
    VimMove("")
  }
Return

#If WInActive("ahk_group VimGroup") and (VimMode == "Vim_ydc_c")
c::
  VimLineCopy := 1
  if WinActive("ahk_group DoubleHome"){
    Send, {Home}
  }
  Send, {Home}+{End}
  if not WinActive("ahk_group LBSelect"){
    VimMove("l")
  }else{
    VimMove("")
  }
Return

#If WInActive("ahk_group VimGroup") and (VimMode == "Vim_Normal")
; X
x::Send, {Delete}
+x::Send, {BS}

; Paste
#If WInActive("ahk_group VimGroup") and (VimMode == "Vim_Normal")
p::
  ;i:=0
  ;;Send, {p Up}
  ;Loop {
  ;  if !GetKeyState("p", "P"){
  ;    break
  ;  }
  ;  if(VimLineCopy == 1){
  ;    Send, {End}{Enter}^v{BS}{Home}
  ;  }else{
  ;    Send, {Right}
  ;    Send, ^v
  ;    ;Sleep, 1000
  ;    Send, ^{Left}
  ;  }
  ;  ;TrayTip,i,%i%,
  ;  if(i == 0){
  ;    Sleep, 500
  ;  }else if(i > 100){
  ;    Msgbox, , Vim Ahk, Stop at 100!!!
  ;    break
  ;  }else{
  ;    Sleep, 0
  ;  }
  ;  i+=1
  ;  break
  ;}
  if(VimLineCopy == 1){
    Send, {End}{Enter}^v{BS}{Home}
  }else{
    Send, {Right}
    Send, ^v
    ;Sleep, 1000
    Send, {Left}
    ;;Send, ^{Left}
  }
  KeyWait, p ; To avoid repeat, somehow it calls <C-p>, print...
Return

+p::
  if(VimLineCopy == 1){
    Send, {Up}{End}{Enter}^v{BS}{Home}
  }else{
    Send, ^v
    ;Send,^{Left}
  }
  KeyWait, p
Return
; }}} Copy/Cut/Paste (ydcxp)

; Vim visual mode {{{

; Visual Char/Block/Line
#If WInActive("ahk_group VimGroup") and (VimMode == "Vim_Normal")
v::VimSetMode("Vim_VisualChar")
^v::
  Send, ^b
  VimSetMode("Vim_VisualChar")
Return

+v::
  VimSetMode("Vim_VisualLineFirst")
  Send, {Home}+{Down}
Return

; ydc
#If WInActive("ahk_group VimGroup") and (InStr(VimMode, "Visual"))
y::
  Clipboard :=
  Send, ^c
  Send, {Right}
  Send, {Left}
  ClipWait, 1
  if(InStr(VimMode, "Line")){
    VimSetMode("Vim_Normal", 0, 0, 1)
  }else{
    VimSetMode("Vim_Normal", 0, 0, 0)
  }
Return

d::
  Clipboard :=
  Send, ^x
  ClipWait, 1
  if(InStr(VimMode,"Line")){
    VimSetMode("Vim_Normal", 0, 0, 1)
  }else{
    VimSetMode("Vim_Normal", 0, 0, 0)
  }
Return

x::
  Clipboard :=
  Send, ^x
  ClipWait, 1
  if(InStr(VimMode, "Line")){
    VimSetMode("Vim_Normal", 0, 0, 1)
  }else{
    VimSetMode("Vim_Normal", 0, 0, 0)
  }
Return

c::
  Clipboard :=
  Send, ^x
  ClipWait, 1
  if(InStr(VimMode, "Line")){
    VimSetMode("Insert", 0, 0, 1)
  }else{
    VimSetMode("Insert", 0, 0, 0)
  }
Return

*::
  bak := ClipboardAll
  Clipboard :=
  Send, ^c
  ClipWait, 1
  Send, ^f
  Send, ^v!f
  clipboard := bak
  VimSetMode("Vim_Normal")
Return
; }}} Vim visual mode

; Search {{{
#If WInActive("ahk_group VimGroup") and (VimMode == "Vim_Normal")
/::
  Send, ^f
  VimSetMode("Inseret")
Return

*::
  bak := ClipboardAll
  Clipboard=
  Send, ^{Left}+^{Right}^c
  ClipWait, 1
  Send, ^f
  Send, ^v!f
  clipboard := bak
  VimSetMode("Inseret")
Return

n::Send, {F3}
+n::Send, +{F3}
; }}} Search

; Vim comamnd mode {{{
#If WInActive("ahk_group VimGroup") and (VimMode == "Vim_Normal")
:::VimSetMode("Command") ;(:)
`;::VimSetMode("Command") ;(;)
#If WInActive("ahk_group VimGroup") and (VimMode == "Command")
w::VimSetMode("Command_w")
q::VimSetMode("Command_q")
h::
  Send, {F1}
  VimSetMode("Vim_Normal")
Return

#If WInActive("ahk_group VimGroup") and (VimMode == "Command_w")
Return::
  Send, ^s
  VimSetMode("Insert")
Return

q::
  Send, ^s
  Send, !{F4}
  VimSetMode("Insert")
Return

Space::
  Send, !fa
  VimSetMode("Insert")
Return

#If WInActive("ahk_group VimGroup") and (VimMode == "Command_q")
Return::
  Send, !{F4}
  VimSetMode("Insert")
Return
; }}} Vim command mode

; Disable other keys {{{
#If WInActive("ahk_group VimGroup") and (InStr(VimMode, "ydc") or InStr(VimMode, "Command") or (VimMode == "Z"))
*a::
*b::
*c::
*d::
*e::
*f::
*g::
*h::
*i::
*j::
*k::
*l::
*m::
*n::
*o::
*p::
*q::
*r::
*s::
*t::
*u::
*v::
*w::
*x::
*y::
*z::
0::
1::
2::
3::
4::
5::
6::
7::
8::
9::
`::
~::
!::
@::
#::
$::
%::
^::
&::
*::
(::
)::
-::
_::
=::
+::
[::
{::
]::
}::
\::
|::
:::
`;::
'::
"::
,::
<::
.::
>::
Space::
  VimSetMode("Vim_Normal")
Return

#If WInActive("ahk_group VimGroup") and (InStr(VimMode,"Vim_") or (1 == 2))
*a::
*b::
*c::
*d::
*e::
*f::
*g::
*h::
*i::
*j::
*k::
*l::
*m::
*n::
*o::
*p::
*q::
*r::
*s::
*t::
*u::
*v::
*w::
*x::
*y::
*z::
0::
1::
2::
3::
4::
5::
6::
7::
8::
9::
`::
~::
!::
@::
#::
$::
%::
^::
&::
*::
(::
)::
-::
_::
=::
+::
[::
{::
]::
}::
\::
|::
:::
`;::
'::
"::
,::
<::
.::
>::
Space::
Return
; }}}
; }}} Vim Mode

; vim: foldmethod=marker
; vim: foldmarker={{{,}}}
