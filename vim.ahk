; Auto-execute section {{{
VimAhkConfObj := new VimAhkConf()

; Read Ini
VimAhkIni.ReadIni()

; Set group
VimAhkConfObj.SetGroup(VimAhkConfObj.Conf["VimGroup"]["val"])

; Menu
Menu, VimSubMenu, Add, Settings, MenuVimSettings
Menu, VimSubMenu, Add
Menu, VimSubMenu, Add, Vim Check, MenuVimCheck
Menu, VimSubMenu, Add, Status, MenuVimStatus
Menu, VimSubMenu, Add, About vim_ahk, MenuVimAbout

Menu, Tray, Add
Menu, Tray, Add, VimMenu, :VimSubMenu

; Set initial icon
VimAhkIcon.SetIcon(VimAhkState.Mode, VimAhkConfObj.Conf["VimIcon"]["val"])

; Set Timer for status check
if(VimAhkConfObj.Conf["VimIconCheck"]["val"] == 1){
  SetTimer, VimStatusCheckTimer, % VimAhkConfObj.Conf["VimIconCheckInterval"]["val"]
}

Return

; }}}

; Class {{{
class VimAhkAbout{
  static Version := "v0.5.0"
  static Date := "24/Sep/2019"
  static Author := "rcmdnk"
  static Description := "Vim emulation with AutoHotkey, everywhere in Windows."
  static Homepage := "https://github.com/rcmdnk/vim_ahk"
}

class VimAhkDebug{
  static CheckModeValue := true
  static PossibleVimModes := ["Vim_Normal", "Insert", "Replace", "Vim_ydc_y"
  , "Vim_ydc_c", "Vim_ydc_d", "Vim_VisualLine", "Vim_VisualFirst"
  , "Vim_VisualChar", "Command", "Command_w", "Command_q", "Z", ""
  , "r_once", "r_repeat", "Vim_VisualLineFirst"]

  CheckValidMode(Mode, FullMatch=true){
    if (VimAhkDebug.CheckModeValue == false){
      Return
    }
    try {
      InOrBlank:= (not full_match) ? "in " : ""
      if not VimHasValue(VimAhkDebug.PossibleVimModes, Mode, FullMatch){
        throw Exception("Invalid mode specified",-2,
        ( Join
  "'" Mode "' is not " InOrBlank " a valid mode as defined by the VimPossibleVimModes
   array at the top of vim.ahk. This may be a typo.
   Fix this error by using an existing mode,
   or adding your mode to the array.")
        )
      }
    }catch e{
      MsgBox % "Warning: " e.Message "`n" e.Extra "`n`n Called in " e.What " at line " e.Line
    }
  }
}

class VimAhkIni{
  static IniDir := A_AppData . "\AutoHotkey"
  static Ini := A_AppData . "\AutoHotkey"  . "\vim_ahk.ini"
  static Section := "Vim Ahk Settings"

  ReadIni(){
    global VimAhkConfObj
    for k, v in VimAhkConfObj.Conf {
      current := v["val"]
      IniRead, val, % VimAhkIni.Ini, % VimAhkIni.Section, %k%, %current%
      %k% := val
      v["val"] := val
    }
  }

  WriteIni(){
    global VimAhkConfObj
    IfNotExist, VimAhkIni.IniDir
      FileCreateDir, VimAhkIni.IniDir

    for k, v in VimAhkConfObj.Conf {
      IniWrite, % v["val"], % VimAhkIni.Ini, % VimAhkIni.Section, %k%
    }
  }
}

class VimAhkIcon{
  static Icons := {Normal: A_LineFile . "\..\icons\normal.ico"
                 , Insert: A_LineFile .  "\..\icons\insert.ico"
                 , Visual: A_LineFile . "\..\icons\visual.ico"
                 , Command: A_LineFile . "\..\icons\command.ico"
                 , Disabled: A_LineFile . "\..\icons\disabled.ico"
                 , Default: A_AhkPath}
  SetIcon(Mode="", VimIcon=1){
    icon :=
    if (VimIcon == 0){
      icon := VimAhkIcon.Icons["Default"]
    }else if InStr(Mode, "Normal"){
      icon := VimAhkIcon.Icons["Normal"]
    }else if InStr(Mode, "Insert"){
      icon := VimAhkIcon.Icons["Insert"]
    }else if InStr(Mode, "Visual"){
      icon := VimAhkIcon.Icons["Visual"]
    }else if InStr(Mode, "Command"){
      icon := VimAhkIcon.Icons["Command"]
    }else if InStr(Mode, "Disabled"){
      icon := VimAhkIcon.Icons["Disabled"]
    }
    if FileExist(icon){
      Menu, Tray, Icon, %icon%
      if (VimIcon == 1){
        Menu, VimSubMenu, Icon, Status, %icon%
      }
    }
  }
}

class VimAhkConf{
  __New(){
    this.GroupDel := ","
    this.GroupN := 0
    this.GroupName := "VimGroup" . GroupN

    ; Enable vim mode for following applications
    this.Group :=                                     "ahk_exe notepad.exe"   ; NotePad
    this.Group := this.Group . this.GroupDel . "ahk_exe explorer.exe"  ; Explorer
    this.Group := this.Group . this.GroupDel . "ahk_exe wordpad.exe"   ; WordPad
    this.Group := this.Group . this.GroupDel . "ahk_exe TeraPad.exe"   ; TeraPad
    this.Group := this.Group . this.GroupDel . "作成"                  ;Thunderbird, 日本語
    this.Group := this.Group . this.GroupDel . "Write:"                ;Thuderbird, English
    this.Group := this.Group . this.GroupDel . "ahk_exe POWERPNT.exe"  ; PowerPoint
    this.Group := this.Group . this.GroupDel . "ahk_exe WINWORD.exe"   ; Word
    this.Group := this.Group . this.GroupDel . "ahk_exe Evernote.exe"  ; Evernote
    this.Group := this.Group . this.GroupDel . "ahk_exe Code.exe"      ; Visual Studio Code
    this.Group := this.Group . this.GroupDel . "ahk_exe onenote.exe"   ; OneNote Desktop
    this.Group := this.Group . this.GroupDel . "OneNote"               ; OneNote in Windows 10
    this.Group := this.Group . this.GroupDel . "ahk_exe texworks.exe"  ; TexWork
    this.Group := this.Group . this.GroupDel . "ahk_exe texstudio.exe" ; TexStudio

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

    ; Configuration values for Read/Write ini
    this.Conf := {VimRestoreIME: {default: 1, val: 1
        , description: "Restore IME status at entering Insert mode"
        , popup: "Restore IME status at entering Insert mode."}
      , VimJJ: {default: 0, val: 0
        , description: "JJ enters Normal mode"
        , popup: "Assign JJ enters Normal mode."}
      , VimJK: {default: 0, val: 0
        , description: "JK enters Normal mode"
        , popup: "Assign JK enters Normal mode."}
      , VimSD: {default: 0, val: 0
        , description: "SD enters Normal mode"
        , popup: "Assign SD enters Normal mode."}
      , VimIcon: {default: 1, val: 1
        , description: "Enable tray icon"
        , popup: "Enable tray icon for Vim Modes."}
      , VimIconCheck: {default: 1, val: 1
        , description: "Enable tray icon check"
        , popup: "Enable tray icon check for Vim Modes."}
      , VimDisableUnused: {default: 1, val: 1
        , description: "Disable unused keys in Normal mode"
        , popup: "Set how to disable unused keys in Normal mode."}
      , VimIconCheckInterval: {default: 1000, val: 1000
        , description: "Icon check interval (ms)"
        , popup: "Interval (ms) to check if current window is for Ahk Vim or not,`nand set tray icon."}
      , VimVerbose: {default: 1, val: 1
        , description: "Verbose level"
        , popup: "Verbose level`n`n1: No pop up`n2: Minimum tool tips of status`n: More info in tool tips`n4: Debug mode with a message box, which doesn't disappear automatically"}
      , VimGroup: {default: this.Group, val: this.Group
        , description: "Application"
        , popup: "Set one application per line.`n`nIt can be any of Window Title, Class or Process.`nYou can check these values by Window Spy (in the right click menu of tray icon)."}}
    this.CheckBoxes := ["VimRestoreIME", "VimJJ", "VimJK", "VimSD", "VimIcon", "VimIconCheck"]

    this.Popup := {}
    for k, v in this.Conf {
      this.Popup[k] := v["popup"]
    }
    this.Popup["VimGroupText"] := this.Conf["VimGroup"]["popup"]
    this.Popup["VimGroupList"] := this.Conf["VimGroup"]["popup"]

    this.Popup["VimDisableUnusedValue"] := this.Conf["VimDisableUnused"]["popup"]
    this.Popup["VimDisableUnusedLevel"] := this.Conf["VimDisableUnused"]["popup"]

    this.Popup["VimIconCheckIntervalText"] := this.Conf["VimIconCheckInterval"]["popup"]
    this.Popup["VimIconCheckIntervalEdit"] := this.Conf["VimIconCheckInterval"]["popup"]

    this.Popup["VimVerboseValue"] := this.Conf["VimVerbose"]["popup"]
    this.Popup["VimVerboseLevel"] := this.Conf["VimVerbose"]["popup"]

    this.Popup["VimGuiSettingsOK"] := "Reflect changes and exit"
    this.Popup["VimGuiSettingsReset"] := "Reset to the default values"
    this.Popup["VimGuiSettingsCancel"] := "Don't change and exit"
    this.Popup["VimAhkGitHub"] := VimAhkAbout.Homepage

    ; Disable unused keys in Normal mode
    this.DisableUnused := ["1: Do not disable unused keys"
      , "2: Disable alphabets (+shift) and symbols"
      , "3: Disable all including keys with modifiers (e.g. Ctrl+Z)"]

    ; Tray Icon check interval

    ; Verbose level, 1: No pop up, 2: Minimum tool tips of status, 3: More info in tool tips, 4: Debug mode with a message box, which doesn't disappear automatically
    this.Verbose := ["1: No pop up", "2: Minimum tool tips"
      , "3: Tool tips" ,"4: Popup message"]

    this.CheckUserDefault()
  }

  CheckUserDefault(){
    for k, v in this.Conf {
      if(%k% != ""){
        this.Conf[k][val] := %k%
      }
    }
  }

  SetGroup(group){
    this.GroupN++
    this.GroupName := "VimGroup" . GroupN
    Loop, Parse, % group, % this.GroupDel
    {
      if(A_LoopField != ""){
        GroupAdd, % this.GroupName, %A_LoopField%
      }
    }
  }
}


; }}} Setting variables


class VimAhkState{
  static Mode := "Insert"
  static g := 0
  static n := 0
  static LineCopy := 0
  static LastIME := 0
  static CurrControl := ""
  static PrevControl := ""
}

; Class }}}

; Menu functions {{{
MenuVimSettings(){
  ;global VimAhkConfObj
  global
  Gui, VimGuiSettings:+LabelVimGuiSettings
  Gui, VimGuiSettings:-MinimizeBox
  Gui, VimGuiSettings:-Resize
  VimSettingHeight := VimAhkConfObj.Checkboxes.Length() * 22 + 370
  Gui, VimGuiSettings:Add, GroupBox, xm X+10 YM+10 Section W370 H%VimSettingHeight%, Settings
  VimCheckboxesCreated := 0
  for i, k in VimAhkConfObj.Checkboxes {
    if(VimCheckboxesCreated == 0){
      y := "YS+20"
    }else{
      y := "Y+10"
    }
    Gui, VimGuiSettings:Add, Checkbox, XS+10 %y% v%k%, % VimAhkConfObj.Conf[k]["description"]
    VimCheckboxesCreated  := 1
    if(VimAhkConfObj.Conf[k]["val"] == 1){
      GuiControl, VimGuiSettings:, %k%, 1
    }
  }
  Gui, VimGuiSettings:Add, Text, XS+10 Y+20 gVimDisableUnusedLevel vVimDisableUnusedLevel, % VimAhkConfObj.Conf["VimDisableUnused"]["description"]
  DisableUnused := VimAhkConfObj.DisableUnused
  Gui, VimGuiSettings:Add, DropDownList, % "W320 vVimDisableUnusedValue Choose"VimAhkConfObj.Conf["VimDisableUnused"]["val"], % DisableUnused[1]"|"DisableUnused[2]"|"DisableUnused[3]
  Gui, VimGuiSettings:Add, Text, XS+10 Y+20 gVimIconCheckIntervalText vVimIconCheckIntervalText, % VimAhkConfObj.Conf["VimIconCheckInterval"]["description"]
  Gui, VimGuiSettings:Add, Edit, vVimIconCheckIntervalEdit
  Gui, VimGuiSettings:Add, UpDown, vVimIconCheckInterval Range100-1000000, % VimAhkConfObj.Conf["VimIconCheckInterval"]["val"]
  Gui, VimGuiSettings:Add, Text, XS+10 Y+20 gVimVerboseLevel vVimVerboseLevel, % VimAhkConfObj.Conf["VimVerbose"]["description"]
  Verbose := VimAhkConfObj.Verbose
  Gui, VimGuiSettings:Add, DropDownList, % "vVimVerboseValue Choose"VimAhkConfObj.Conf["VimVerbose"]["val"], % Verbose[1]"|"Verbose[2]"|"Verbose[3]"|"Verbose[4]
  Gui, VimGuiSettings:Add, Text, XS+10 Y+20 gVimGroupText vVimGroupText, % VimAhkConfObj.Conf["VimGroup"]["description"]
  StringReplace, VimGroupList, % VimAhkConfObj.Conf["VimGroup"]["val"], % VimAhkConfObj.GroupDel, `n, All
  Gui, VimGuiSettings:Add, Edit, XS+10 Y+10 R10 W300 Multi vVimGroupList, %VimGroupList%
  Gui, VimGuiSettings:Add, Text, XM+20 Y+30, Check
  Gui, VimGuiSettings:Font, Underline
  Gui, VimGuiSettings:Add, Text, X+5 cBlue gVimAhkGitHub vVimAhkGitHub, HELP
  Gui, VimGuiSettings:Font, Norm
  Gui, VimGuiSettings:Add, Text, X+5, for further information.
  Gui, VimGuiSettings:Add, Button, gVimGuiSettingsOK vVimGuiSettingsOK xm W100 X45 Y+10 Default, &OK
  Gui, VimGuiSettings:Add, Button, gVimGuiSettingsReset vVimGuiSettingsReset W100 X+10, &Reset
  Gui, VimGuiSettings:Add, Button, gVimGuiSettingsCancel vVimGuiSettingsCancel W100 X+10, &Cancel
  Gui, VimGuiSettings:Show, W410, Vim Ahk Settings
  OnMessage(0x200, "VimMouseMove")
}

; Dummy Labels, to enable popup over the text
VimDisableUnusedLevel(){
}
VimIconCheckIntervalText(){
}
VimVerboseLevel(){
}
VimGroupText(){
}

VimMouseMove(){
  VimAhkState.CurrControl := A_GuiControl
  if(VimAhkState.CurrControl != VimAhkState.PrevControl){
    VimAhkState.PrevControl := VimAhkState.CurrControl
    ToolTip
    if(VimAhkState.CurrControl != "" && InStr(VimAhkState.CurrControl, " ") == 0){
      SetTimer, VimDisplayToolTip, 1000
    }
  }
  Return
}

VimDisplayToolTip(){
  global VimAhkConfObj
  SetTimer, VimDisplayToolTip, Off
  if(VimAhkConfObj.Popup.HasKey(VimAhkState.CurrControl)){
    ToolTip % VimAhkConfObj.Popup[VimAhkState.CurrControl]
    SetTimer, VimRemoveToolTip, 60000
  }
}

VimRemoveToolTip(){
  SetTimer, VimRemoveToolTip, Off
  ToolTip
}

VimV2Conf(){
  global
  Loop, % VimAhkConfObj.DisableUnused.Length() {
    if(VimDisableUnusedValue == VimAhkConfObj.DisableUnused[A_Index]){
      VimDisableUnused := A_Index
      Break
    }
  }
  Loop, % VimAhkConfObj.Verbose.Length() {
    if(VimVerboseValue == VimAhkConfObj.Verbose[A_Index]){
      VimVerbose := A_Index
      Break
    }
  }
  VimGroup := ""
  Loop, Parse, VimGroupList, `n
  {
    if(! InStr(VimGroup, A_LoopField)){
      if(VimGroup == ""){
        VimGroup := A_LoopField
      }else{
        VimGroup := VimGroup . VimAhkConfObj.GroupDel . A_LoopField
      }
    }
  }
  for k, v in VimAhkConfObj.Conf {
    v["val"] := %k%
  }
  VimSet()
}

VimSet(){
  global VimAhkConfObj
  VimAhkIcon.SetIcon(VimAhkState.Mode, VimAhkConfObj.Conf["VimIcon"]["val"])
  if(VimAhkConfObj.Conf["VimIconCheck"]["val"] == 1){
    SetTimer, VimStatusCheckTimer, % VimAhkConfObj.Conf["VimIconCheckInterval"]["val"]
  }else{
    SetTimer, VimStatusCheckTimer, OFF
  }
  VimAhkConfObj.SetGroup(VimAhkConfObj.Conf["VimGroup"]["val"])
}

VimGuiSettings(){
  SetTimer, VimDisplayToolTip, Off
  ToolTip
  Gui, VimGuiSettings:Destroy
}
VimGuiSettingsOK(){
  Gui, VimGuiSettings:Submit
  VimV2Conf()
  VimAhkIni.WriteIni()
  VimGuiSettings()
}
VimGuiSettingsCancel(){
  VimGuiSettings()
}
VimGuiSettingsClose(){
  VimGuiSettings()
}
VimGuiSettingsEscape(){
  VimGuiSettings()
}

VimGuiSettingsReset(){
  global VimAhkConfObj
  IfExist, VimAhkIni.Ini
    FileDelete, VimAhkIni.Ini

  for k, v in VimAhkConfObj.Conf {
    VimAhkConfObj.Conf[k]["val"] := v["default"]
  }

  VimSet()

  SetTimer, VimDisplayToolTip, Off
  ToolTip
  Gui, VimGuiSettings:Destroy
  MenuVimSettings()
}

VimAhkGitHub(){
  Run % VimAhkAbout.Homepage
}

MenuVimCheck(){
  global VimAhkConfObj
  ; Additional message is necessary before checking current window.
  ; Otherwise process name cannot be retrieved...?
  Msgbox, , Vim Ahk, Checking current window...
  WinGet, process, PID, A
  WinGet, name, ProcessName, ahk_pid %process%
  WinGetClass, class, ahk_pid %process%
  WinGetTitle, title, ahk_pid %process%
  if WinActive("ahk_group" . VimAhkConfObj.GroupName){
    Msgbox, 0x40, Vim Ahk,
    (
      Supported
      Process name: %name%
      Class       : %class%
      Title       : %title%
    )
  }else{
    Msgbox, 0x10, Vim Ahk,
    (
      Not supported
      Process name: %name%
      Class       : %class%
      Title       : %title%
    )
  }
}

MenuVimStatus(){
  global VimVerboseMax
  VimCheckMode(VimVerboseMax, , , , 1)
}

MenuVimAbout(){
  Gui, VimGuiAbout:+LabelVimGuiAbout
  Gui, VimGuiAbout:-MinimizeBox
  Gui, VimGuiAbout:-Resize
  Gui, VimGuiAbout:Add, Text, , % "Vim Ahk (vim_ahk):`n" VimAhkAbout.Description
  Gui, VimGuiAbout:Font, Underline
  Gui, VimGuiAbout:Add, Text, Y+0 cBlue gVimAhkGitHub, Homepage
  Gui, VimGuiAbout:Font, Norm
  Gui, VimGuiAbout:Add, Text, , % "Author: " VimAhkAbout.Author
  Gui, VimGuiAbout:Add, Text, , % "Version: " VimAhkAbout.Version
  Gui, VimGuiAbout:Add, Text, Y+0, % "Last update: " VimAhkAbout.Date
  Gui, VimGuiAbout:Add, Text, , Script path:`n%A_LineFile%
  Gui, VimGuiAbout:Add, Text, , % "Setting file:`n" VimAhkIni.Ini
  Gui, VimGuiAbout:Add, Button, gVimGuiAboutOK X200 W100 Default, &OK
  Gui, VimGuiAbout:Show, W500, Vim Ahk
}

VimGuiAboutOK(){
  Gui, VimGuiAbout:Destroy
}
VimGuiAboutClose(){
  Gui, VimGuiAbout:Destroy
}
VimGuiAboutEscape(){
  Gui, VimGuiAbout:Destroy
}
; }}}

; AutoHotkey settings {{{

#UseHook On ; Make it a bit slow, but can avoid infinitude loop
            ; Same as "$" for each hotkey
#InstallKeybdHook ; For checking key history
                  ; Use ~500kB memory?
#HotkeyInterval 2000 ; Hotkey interval (default 2000 milliseconds).
#MaxHotkeysPerInterval 70 ; Max hotkeys per interval (default 50).
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
VimCheckMode(verbose=1, Mode="", g=0, n=0, LineCopy=-1, force=0){
  if(force == 0) and ((verbose <= 1) or ((Mode == "") and (g == 0) and (n == 0) and (LineCopy == -1))){
    Return
  }else if(verbose == 2){
    VimStatus(VimAhkState.Mode, 1) ; 1 sec is minimum for TrayTip
  }else if(verbose == 3){
    VimStatus(VimAhkState.Mode "`r`ng=" VimAhkState.g "`r`nn=" VimAhkState.n "`r`nLineCopy=" VimAhkState.LineCopy, 4)
  }
  if(verbose >= 4){
    Msgbox, , Vim Ahk, % "Mode: " . VimAhkState.Mode . "`nVim_g: " . VimAhkState.g . "`nVim_n: " . VimAhkState.n . "`nVimLineCopy: " . VimAhkState.LineCopy
  }
  Return
}

VimSetMode(Mode="", g=0, n=0, LineCopy=-1){
  global VimAhkConfObj
  VimAhkDebug.CheckValidMode(Mode)
  if(Mode != ""){
    VimAhkState.Mode := Mode
    If(Mode == "Insert") and (VimAhkConfObj.Conf["VimRestoreIME"]["val"] == 1){
      VIM_IME_SET(VimAhkState.LastIME)
    }
    VimAhkIcon.SetIcon(VimAhkState.Mode, VimAhkConfObj.Conf["VimIcon"]["val"])
  }
  if(g != -1){
    VimAhkState.g := g
  }
  if(n != -1){
    VimAhkState.n := n
  }
  if(LineCopy!=-1){
    VimAhkState.LineCopy := LineCopy
  }
  VimCheckMode(VimAhkConfObj.Conf["VimVerbose"]["val"], Mode, g, n, LineCopy)
  Return
}

VimIsCurrentVimMode(mode){
  VimAhkDebug.CheckValidMode(mode)
  return (mode == VimAhkState.Mode)
}

VimStrIsInCurrentVimMode(str){
  VimAhkDebug.CheckValidMode(str, false)
  return (inStr(VimAhkState.Mode, str))
}

VimHasValue(haystack, needle, full_match = true){
  if(!isObject(haystack)){
    return false
  }else if(haystack.Length()==0){
    return false
  }
  for index,value in haystack{
    if full_match{
      if (value==needle){
        return true
      }
    }else{
      if (inStr(value, needle)){
        return true
      }
    }
  }
  return false
}

VimStatus(Title, lines=1){
  WinGetPos, , , W, H, A
  Tooltip, %Title%, W - 110, H - 30 - (lines) * 20
  SetTimer, VimRemoveStatus, 1000
}

VimRemoveStatus(){
  SetTimer, VimRemoveStatus, off
  Tooltip
}

VimStatusCheckTimer(){
  global VimAhkConfObj
  if WinActive("ahk_group " . VimAhkConfObj.GroupName)
  {
    VimAhkIcon.SetIcon(VimAhkState.Mode, VimAhkConfObj.Conf["VimIcon"]["val"])
  }else{
    VimAhkIcon.SetIcon("Disabled", VimAhkConfObj.Conf["VimIcon"]["val"])
  }
}

VimStartStatusCheck(){
  SetTimer, VimStatusCheckTimer, off
}

VimStopStatusCheck(){
  SetTimer, VimStatusCheckTimer, off
}

; Vim mode {{{
#If

; Launch Settings {{{
^!+v::
  MenuVimSettings()
Return

; }}}

#If WinActive("ahk_group " . VimAhkConfObj.GroupName)
; Check Mode {{{
^!+c::
  VimCheckMode(VimVerboseMax, VimAhkState.Mode)
Return
; }}}

; Enter vim normal mode {{{
VimSetNormal(){
  VimAhkState.LastIME := VIM_IME_Get()
  if(VimAhkState.LastIME){
    if(VIM_IME_GetConverting(A)){
      Send,{Esc}
      Return
    }else{
      VIM_IME_SET()
    }
  }
  if(VimStrIsInCurrentVimMode( "Visual") or VimStrIsInCurrentVimMode( "ydc")){
    Send, {Right}
    if WinActive("ahk_group VimCursorSameAfterSelect"){
      Send, {Left}
    }
  }
  VimSetMode("Vim_Normal")
}

Esc:: ; Just send Esc at converting, long press for normal Esc.
^[:: ; Go to Normal mode (for vim) with IME off even at converting.
  KeyWait, Esc, T0.5
  if(ErrorLevel){ ; long press to Esc
    Send,{Esc}
    Return
  }
  VimSetNormal()
Return

#If WinActive("ahk_group " . VimAhkConfObj.GroupName) and (VimStrIsInCurrentVimMode( "Insert")) and (VimAhkConfObj.Conf["VimJJ"]["val"] == 1)
~j up:: ; jj: go to Normal mode.
  Input, jout, I T0.1 V L1, j
  if(ErrorLevel == "EndKey:J"){
    SendInput, {BackSpace 2}
    VimSetNormal()
  }
Return
; }}}

#If WinActive("ahk_group " . VimAhkConfObj.GroupName) and (VimStrIsInCurrentVimMode( "Insert")) and (VimAhkConfObj.Conf["VimJK"]["val"] == 1)
j & k::
k & j::
  SendInput, {BackSpace 1}
  VimSetNormal()
Return
; }}}

#If WinActive("ahk_group " . VimAhkConfObj.GroupName) and (VimStrIsInCurrentVimMode( "Insert")) and (VimAhkConfObj.Conf["VimSD"]["val"] == 1)
s & d::
d & s::
  SendInput, {BackSpace 1}
  VimSetNormal()
Return
; }}}

; Enter vim insert mode (Exit vim normal mode) {{{
#If WinActive("ahk_group " . VimAhkConfObj.GroupName) && (VimAhkState.Mode == "Vim_Normal")
i::VimSetMode("Insert")

+i::
  Send, {Home}
  VimSetMode("Insert")
Return

a::
  Send, {Right}
  VimSetMode("Insert")
Return

+a::
  Send, {End}
  VimSetMode("Insert")
Return

o::
  Send,{End}{Enter}
  VimSetMode("Insert")
Return

+o::
  Send, {Up}{End}{Enter}
  VimSetMode("Insert")
Return
; }}}

; Repeat {{{
#If WinActive("ahk_group " . VimAhkConfObj.GroupName) and (VimStrIsInCurrentVimMode("Vim_"))
1::
2::
3::
4::
5::
6::
7::
8::
9::
  n_repeat := VimAhkState.n*10 + A_ThisHotkey
  VimSetMode("", 0, n_repeat)
Return

#If WinActive("ahk_group " . VimAhkConfObj.GroupName) and (VimStrIsInCurrentVimMode("Vim_")) and (VimAhkState.n > 0)
0:: ; 0 is used as {Home} for VimAhkState.n=0
  n_repeat := VimAhkState.n*10 + A_ThisHotkey
  VimSetMode("", 0, n_repeat)
Return
; }}}

; Normal Mode Basic {{{
#If WinActive("ahk_group " . VimAhkConfObj.GroupName) and (VimAhkState.Mode == "Vim_Normal")
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
    StringUpper, Clipboard, Clipboard
  }else if(Clipboard is upper){
    StringLower, Clipboard, Clipboard
  }
  Send, ^v
  Clipboard := bak
Return

+z::VimSetMode("Z")
#If WinActive("ahk_group " . VimAhkConfObj.GroupName) and (VimAhkState.Mode == "Z")
+z::
  Send, ^s
  Send, !{F4}
  VimSetMode("Vim_Normal")
Return

+q::
  Send, !{F4}
  VimSetMode("Vim_Normal")
Return

#If WinActive("ahk_group " . VimAhkConfObj.GroupName) and (VimAhkState.Mode == "Vim_Normal")
Space::Send, {Right}

; period
.::Send, +^{Right}{BS}^v
; }}}

; Replace {{{
#If WinActive("ahk_group " . VimAhkConfObj.GroupName) and (VimAhkState.Mode == "Vim_Normal")
r::VimSetMode("r_once")
+r::VimSetMode("r_repeat")

#If WinActive("ahk_group " . VimAhkConfObj.GroupName) and (VimAhkState.Mode == "r_once")
~a::
~+a::
~b::
~+b::
~c::
~+c::
~d::
~+d::
~e::
~+e::
~f::
~+f::
~g::
~+g::
~h::
~+h::
~i::
~+i::
~j::
~+j::
~k::
~+k::
~l::
~+l::
~m::
~+m::
~n::
~+n::
~o::
~+o::
~p::
~+p::
~q::
~+q::
~r::
~+r::
~s::
~+s::
~t::
~+t::
~u::
~+u::
~v::
~+v::
~w::
~+w::
~x::
~+x::
~y::
~+y::
~z::
~+z::
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

#If WinActive("ahk_group " . VimAhkConfObj.GroupName) and (VimAhkState.Mode == "r_repeat")
~a::
~+a::
~b::
~+b::
~c::
~+c::
~d::
~+d::
~e::
~+e::
~f::
~+f::
~g::
~+g::
~h::
~+h::
~i::
~+i::
~j::
~+j::
~k::
~+k::
~l::
~+l::
~m::
~+m::
~n::
~+n::
~o::
~+o::
~p::
~+p::
~q::
~+q::
~r::
~+r::
~s::
~+s::
~t::
~+t::
~u::
~+u::
~v::
~+v::
~w::
~+w::
~x::
~+x::
~y::
~+y::
~z::
~+z::
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
#If WinActive("ahk_group " . VimAhkConfObj.GroupName) and (VimStrIsInCurrentVimMode("Vim_")) and (not VimAhkState.g)
g::VimSetMode("", 1)
; }}}

VimMove(key=""){
  shift = 0
  if(VimStrIsInCurrentVimMode( "Visual") or VimStrIsInCurrentVimMode( "ydc")){
    shift := 1
  }
  if(shift == 1){
    Send, {Shift Down}
  }
  ; Left/Right
  if(not VimStrIsInCurrentVimMode( "Line")){
    ; For some cases, need '+' directly to continue to select
    ; especially for cases using shift as original keys
    ; For now, caret does not work even add + directly

    ; 1 character
    if(key == "h"){
      Send, {Left}
    }else if(key == "l"){
      Send, {Right}
    ; Home/End
    }else if(key == "0"){
      Send, {Home}
    }else if(key == "$"){
      if(shift == 1){
        Send, +{End}
      }else{
        Send, {End}
      }
    }else if(key == "^"){
      if(shift == 1){
        if WinActive("ahk_group VimCaretMove"){
          Send, {Home}
          Send, ^{Right}
          Send, ^{Left}
        }else{
          Send, {Home}
        }
      }else{
        if WinActive("ahk_group VimCaretMove"){
          Send, +{Home}
          Send, +^{Right}
          Send, +^{Left}
        }else{
          Send, +{Home}
        }
      }
    ; Words
    }else if(key == "w"){
      if(shift == 1){
        Send, +^{Right}
      }else{
        Send, ^{Right}
      }
    }else if(key == "b"){
      if(shift == 1){
        Send, +^{Left}
      }else{
        Send, ^{Left}
      }
    }
  }
  ; Up/Down
  if(VimAhkState.Mode == "Vim_VisualLineFirst") and (key == "k" or key == "^u" or key == "^b" or key == "g"){
    Send, {Shift Up}{End}{Home}{Shift Down}{Up}
    VimSetMode("Vim_VisualLine")
  }
  if(VimStrIsInCurrentVimMode( "Vim_ydc")) and (key == "k" or key == "^u" or key == "^b" or key == "g"){
    VimAhkState.LineCopy := 1
    Send,{Shift Up}{Home}{Down}{Shift Down}{Up}
  }
  if(VimStrIsInCurrentVimMode("Vim_ydc")) and (key == "j" or key == "^d" or key == "^f" or key == "+g"){
    VimAhkState.LineCopy := 1
    Send,{Shift Up}{Home}{Shift Down}{Down}
  }

  ; 1 character
  if(key == "j"){
    ; Only for OneNote of less than windows 10?
    if WinActive("ahk_group VimOneNoteGroup"){
      Send ^{Down}
    } else {
      Send,{Down}
    }
  }else if(key="k"){
    if WinActive("ahk_group VimOneNoteGroup"){
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

  if(VimAhkState.Mode == "Vim_ydc_y"){
    Clipboard :=
    Send, ^c
    ClipWait, 1
    VimSetMode("Vim_Normal")
  }else if(VimAhkState.Mode == "Vim_ydc_d"){
    Clipboard :=
    Send, ^x
    ClipWait, 1
    VimSetMode("Vim_Normal")
  }else if(VimAhkState.Mode == "Vim_ydc_c"){
    Clipboard :=
    Send, ^x
    ClipWait, 1
    VimSetMode("Insert")
  }
  VimSetMode("", 0, 0)
}
VimMoveLoop(key=""){
  if(VimAhkState.n == 0){
    VimAhkState.n := 1
  }
  Loop, % VimAhkState.n {
    VimMove(key)
  }
}
#If WinActive("ahk_group " . VimAhkConfObj.GroupName) and (VimStrIsInCurrentVimMode("Vim_"))
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
#If WinActive("ahk_group " . VimAhkConfObj.GroupName) and (VimStrIsInCurrentVimMode( "Vim_")) and (VimAhkState.g)
g::VimMove("g")
; }}} Move

; Copy/Cut/Paste (ydcxp){{{
; YDC
#If WinActive("ahk_group " . VimAhkConfObj.GroupName) and (VimAhkState.Mode == "Vim_Normal")
y::VimSetMode("Vim_ydc_y", 0, -1, 0)
d::VimSetMode("Vim_ydc_d", 0, -1, 0)
c::VimSetMode("Vim_ydc_c", 0, -1, 0)
+y::
  VimSetMode("Vim_ydc_y", 0, 0, 1)
  Sleep, 150 ; Need to wait (For variable change?)
  if WinActive("ahk_group VimDoubleHomeGroup"){
    Send, {Home}
  }
  Send, {Home}+{End}
  if not WinActive("ahk_group VimLBSelectGroup"){
    VimMove("l")
  }else{
    VimMove("")
  }
  Send, {Left}{Home}
Return

+d::
  VimSetMode("Vim_ydc_d", 0, 0, 0)
  if not WinActive("ahk_group VimLBSelectGroup"){
    VimMove("$")
  }else{
    Send, {Shift Down}{End}{Left}
    VimMove("")
  }
Return

+c::
  VimSetMode("Vim_ydc_c",0,0,0)
  if not WinActive("ahk_group VimLBSelectGroup"){
    VimMove("$")
  }else{
    Send, {Shift Down}{End}{Left}
    VimMove("")
  }
Return

#If WinActive("ahk_group " . VimAhkConfObj.GroupName) and (VimAhkState.Mode == "Vim_ydc_y")
y::
  VimAhkState.LineCopy := 1
  if WinActive("ahk_group VimDoubleHomeGroup"){
    Send, {Home}
  }
  Send, {Home}+{End}
  if not WinActive("ahk_group VimLBSelectGroup"){
    VimMove("l")
  }else{
    VimMove("")
  }
  Send, {Left}{Home}
Return

#If WinActive("ahk_group " . VimAhkConfObj.GroupName) and (VimAhkState.Mode == "Vim_ydc_d")
d::
  VimAhkState.LineCopy := 1
  if WinActive("ahk_group DoubleHome"){
    Send, {Home}
  }
  Send, {Home}+{End}
  if not WinActive("ahk_group VimLBSelectGroup"){
    VimMove("l")
  }else{
    VimMove("")
  }
Return

#If WinActive("ahk_group " . VimAhkConfObj.GroupName) and (VimAhkState.Mode == "Vim_ydc_c")
c::
  VimAhkState.LineCopy := 1
  if WinActive("ahk_group DoubleHome"){
    Send, {Home}
  }
  Send, {Home}+{End}
  if not WinActive("ahk_group VimLBSelectGroup"){
    VimMove("l")
  }else{
    VimMove("")
  }
Return

#If WinActive("ahk_group " . VimAhkConfObj.GroupName) and (VimAhkState.Mode == "Vim_Normal")
; X
x::Send, {Delete}
+x::Send, {BS}

; Paste
#If WinActive("ahk_group " . VimAhkConfObj.GroupName) and (VimAhkState.Mode == "Vim_Normal")
p::
  ;i:=0
  ;;Send, {p Up}
  ;Loop {
  ;  if !GetKeyState("p", "P"){
  ;    break
  ;  }
  ;  if(VimAhkState.LineCopy == 1){
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
  if(VimAhkState.LineCopy == 1){
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
  if(VimAhkState.LineCopy == 1){
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
#If WinActive("ahk_group " . VimAhkConfObj.GroupName) and (VimAhkState.Mode == "Vim_Normal")
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
#If WinActive("ahk_group " . VimAhkConfObj.GroupName) and (VimStrIsInCurrentVimMode( "Visual"))
y::
  Clipboard :=
  Send, ^c
  Send, {Right}
  if WinActive("ahk_group VimCursorSameAfterSelect"){
    Send, {Left}
  }
  ClipWait, 1
  if(VimStrIsInCurrentVimMode( "Line")){
    VimSetMode("Vim_Normal", 0, 0, 1)
  }else{
    VimSetMode("Vim_Normal", 0, 0, 0)
  }
Return

d::
  Clipboard :=
  Send, ^x
  ClipWait, 1
  if(VimStrIsInCurrentVimMode("Line")){
    VimSetMode("Vim_Normal", 0, 0, 1)
  }else{
    VimSetMode("Vim_Normal", 0, 0, 0)
  }
Return

x::
  Clipboard :=
  Send, ^x
  ClipWait, 1
  if(VimStrIsInCurrentVimMode( "Line")){
    VimSetMode("Vim_Normal", 0, 0, 1)
  }else{
    VimSetMode("Vim_Normal", 0, 0, 0)
  }
Return

c::
  Clipboard :=
  Send, ^x
  ClipWait, 1
  if(VimStrIsInCurrentVimMode( "Line")){
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
#If WinActive("ahk_group " . VimAhkConfObj.GroupName) and (VimAhkState.Mode == "Vim_Normal")
/::
  Send, ^f
  VimSetMode("Insert")
Return

*::
  bak := ClipboardAll
  Clipboard=
  Send, ^{Left}+^{Right}^c
  ClipWait, 1
  Send, ^f
  Send, ^v!f
  clipboard := bak
  VimSetMode("Insert")
Return

n::Send, {F3}
+n::Send, +{F3}
; }}} Search

; Vim comamnd mode {{{
#If WinActive("ahk_group " . VimAhkConfObj.GroupName) and (VimAhkState.Mode == "Vim_Normal")
:::VimSetMode("Command") ;(:)
`;::VimSetMode("Command") ;(;)
#If WinActive("ahk_group " . VimAhkConfObj.GroupName) and (VimAhkState.Mode == "Command")
w::VimSetMode("Command_w")
q::VimSetMode("Command_q")
h::
  Send, {F1}
  VimSetMode("Vim_Normal")
Return

#If WinActive("ahk_group " . VimAhkConfObj.GroupName) and (VimAhkState.Mode == "Command_w")
Return::
  Send, ^s
  VimSetMode("Vim_Normal")
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

#If WinActive("ahk_group " . VimAhkConfObj.GroupName) and (VimAhkState.Mode == "Command_q")
Return::
  Send, !{F4}
  VimSetMode("Insert")
Return
; }}} Vim command mode

; Disable other keys {{{
#If WinActive("ahk_group " . VimAhkConfObj.GroupName) and (VimStrIsInCurrentVimMode( "ydc") or VimStrIsInCurrentVimMode( "Command") or (VimAhkState.Mode == "Z"))
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

#If WinActive("ahk_group " . VimAhkConfObj.GroupName) and VimStrIsInCurrentVimMode("Vim_") and (VimAhkConfObj.Conf["VimDisableUnused"]["val"] == 2)
a::
b::
c::
d::
e::
f::
g::
h::
i::
j::
k::
l::
m::
n::
o::
p::
q::
r::
s::
t::
u::
v::
w::
x::
y::
z::
+a::
+b::
+c::
+d::
+e::
+f::
+g::
+h::
+i::
+j::
+k::
+l::
+m::
+n::
+o::
+p::
+q::
+r::
+s::
+t::
+u::
+v::
+w::
+x::
+y::
+z::
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

#If WinActive("ahk_group " . VimAhkConfObj.GroupName) and VimStrIsInCurrentVimMode("Vim_") and (VimAhkConfObj.Conf["VimDisableUnused"]["val"] == 3)
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

; Reset the condition
#If

; vim: foldmethod=marker
; vim: foldmarker={{{,}}}
