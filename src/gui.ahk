; Icon places
VimIconNormal := % A_LineFile . "\..\icons\normal.ico"
VimIconInsert := % A_LineFile . "\..\icons\insert.ico"
VimIconVisual := % A_LineFile . "\..\icons\visual.ico"
VimIconCommand := % A_LineFile . "\..\icons\command.ico"
VimIconDisabled := % A_LineFile . "\..\icons\disabled.ico"
VimIconDefault := % A_AhkPath

; Checkboxes {{{

; If IME status is restored or not at entering insert mode. 1 for restoring. 0 for not to restore (always IME off at enterng insert mode).
VimCheckboxes := [{name: "VimRestoreIME", default: 1
, description: "Restore IME status at entering Insert mode"
, popup: "Restore IME status at entering Insert mode."}]

; Set 1 to asign jj to enter Normal mode
VimCheckboxes.push({name: "VimJJ", default: 0
, description: "JJ enters Normal mode"
, popup: "Assign JJ enters Normal mode."})

; Set 1 to asign jk to enter Normal mode
VimCheckboxes.push({name: "VimJK", default: 0
, description: "JK enters Normal mode"
, popup: "Assign JK enters Normal mode."})

; Set 1 to asign sd to enter Normal mode
VimCheckboxes.push({name: "VimSD", default: 0
, description: "SD enters Normal mode"
, popup: "Assign SD enters Normal mode."})

;; Set 1 to enable Tray Icon for Vim Modes. Set 0 for original Icon
VimCheckboxes.push({name: "VimIcon", default: 1
, description: "Enable tray icon"
, popup: "Enable tray icon for Vim Modes."})

; Set 1 to enable Tray Icon check
VimCheckboxes.push({name: "VimIconCheck", default: 1
, description: "Enable tray icon check"
, popup: "Enable tray icon check."})

for i, s in VimCheckboxes {
  name := s["name"]
  %name%_TT := s["popup"]
  if %name% is not integer
  %name% := s["default"]
}

; }}} Checkboxes

; Menu and tray {{{
;Menu, VimSubMenu, Add, Vim Check, MenuVimCheck
Menu, VimSubMenu, Add, Settings, MenuVimSettings
Menu, VimSubMenu, Add
Menu, VimSubMenu, Add, Status, MenuVimStatus
Menu, VimSubMenu, Add, About vim_ahk, MenuVimAbout

Menu, Tray, Add
Menu, Tray, Add, VimMenu, :VimSubMenu

; Set initial icon
VimSetIcon(VimMode)

; Set Timer for status check
if(VimIconCheck == 1){
  SetTimer, VimStatusCheckTimer, %VimIconCheckInterval%
}
; }}} Menu and tray

; Menu functions {{{
;MenuVimCheck:
;  ; Additional message is necessary before checking current window.
;  ; Otherwise process name cannot be retrieved...?
;  Msgbox, , Vim Ahk, Checking current window...
;  WinGet, process, PID, A
;  WinGet, name, ProcessName, ahk_pid %process%
;  WinGetClass, class, ahk_pid %process%
;  WinGetTitle, title, ahk_pid %process%
;  if WinActive("ahk_group" . VimGroupName){
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
  checkboxes_rows := VimCheckboxes.Length()
  height := checkboxes_rows * 22 + 370
  Gui, VimGuiSettings:Add, GroupBox, xm X+10 YM+10 Section W370 H%height%, Settings
  VimCheckboxesCreated := 0
  for i, s in VimCheckboxes {
    VimAddCheckbox(s["name"], s["default"], s["description"])
  }
  Gui, VimGuiSettings:Add, Text, XS+10 Y+20 gVimDisableUnusedLevel vVimDisableUnusedLevel, Disable unused keys in Normal mode
  Gui, VimGuiSettings:Add, DropDownList, W320 vVimDisableUnusedValue Choose%VimDisableUnused%, %VimDisableUnused1%|%VimDisableUnused2%|%VimDisableUnused3%
  Gui, VimGuiSettings:Add, Text, XS+10 Y+20 gVimIconCheckIntervalText vVimIconCheckIntervalText, Icon check interval (ms)
  Gui, VimGuiSettings:Add, Edit, gVimIconCheckIntervalEdit vVimIconCheckIntervalEdit
  Gui, VimGuiSettings:Add, UpDown, vVimIconCheckInterval Range100-1000000, %VimIconCheckInterval%
  Gui, VimGuiSettings:Add, Text, XS+10 Y+20 gVimVerboseLevel vVimVerboseLevel, Verbose level
  Gui, VimGuiSettings:Add, DropDownList, vVimVerboseValue Choose%VimVerbose%, %VimVerbose1%|%VimVerbose2%|%VimVerbose3%|%VimVerbose4%
  Gui, VimGuiSettings:Add, Text, XS+10 Y+20 gVimGroupText vVimGroupText, Applications
  StringReplace, VimGroupList, VimGroup, %VimGroupDel%, `n, All
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
Return

VimMouseMove(){
  global VimCurrControl, VimPrevControl
  VimCurrControl := A_GuiControl
  if(VimCurrControl != VimPrevControl){
    VimPrevControl := VimCurrControl
    ToolTip
    if(VimCurrControl != "" && InStr(VimCurrControl, " ") == 0){
      SetTimer, VimDisplayToolTip, 1000
      VimPrevControl := VimCurrControl
    }
  }
  Return
}

VimDisplayToolTip:
  SetTimer, VimDisplayToolTip, Off
  ToolTip % %VimCurrControl%_TT
  SetTimer, VimRemoveToolTip, 60000
Return

VimRemoveToolTip:
  SetTimer, VimRemoveToolTip, Off
  ToolTip
Return


VimGuiSettingsApply:
  VimSetGroup()
  Loop, %VimDisableUnusedMax% {
    if(VimDisableUnusedValue == VimDisableUnused%A_Index%){
      VimDisableUnused := A_Index
      Break
    }
  }
  Loop, %VimVerboseMax% {
    if(VimVerboseValue == VimVerbose%A_Index%){
      VimVerbose := A_Index
      Break
    }
  }
  if(VimIcon == 1){
     VimSetIcon(VimMode)
  }else{
     VimSetIcon("Default")
  }
  if(VimIconCheck == 1){
    SetTimer, VimStatusCheckTimer, %VimIconCheckInterval%
  }else{
    SetTimer, VimStatusCheckTimer, OFF
  }
Return

VimGuiSettingsOK:
  Gui, VimGuiSettings:Submit
  Gosub, VimGuiSettingsApply
  VimWriteIni()
VimGuiSettingsCancel:
VimGuiSettingsClose:
VimGuiSettingsEscape:
  SetTimer, VimDisplayToolTip, Off
  ToolTip
  Gui, VimGuiSettings:Destroy
Return

VimGuiSettingsReset:
  IfExist, %VimIni%
    FileDelete, %VimIni%

  for i, s in VimCheckboxes {
    name := s["name"]
    %name% := s["default"]
  }
  VimGroup := VimGroupIni
  VimDisableUnused := VimDisableUnusedIni
  VimIconCheckInterval := VimIconCheckIntervalIni
  VimVerbose := VimVerboseIni

  Gosub, VimGuiSettingsApply

  SetTimer, VimDisplayToolTip, Off
  ToolTip
  Gui, VimGuiSettings:Destroy
  Gosub, MenuVimSettings
Return

; Dummies for assigning Gui Control
VimGroupText:
Return
VimIconCheckIntervalText:
Return
VimIconCheckIntervalEdit:
Return
VimDisableUnusedLevel:
Return
VimVerboseLevel:
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
  Gui, VimGuiAbout:Add, Button, gVimGuiAboutOK X200 W100 Default, &OK
  Gui, VimGuiAbout:Show, W500, Vim Ahk
Return

VimGuiAboutOK:
VimGuiAboutClose:
VimGuiAboutEscape:
  Gui, VimGuiAbout:Destroy
Return

VimSetIcon(Mode=""){
  global VimIcon, VimIconNormal, VimIconInsert, VimIconVisual, VimIconCommand, VimIconDisabled, VimIconDefault
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
  }else if InStr(Mode, "Default"){
    icon := VimIconDefault
  }
  if FileExist(icon){
    if(InStr(Mode, "Default")){
      Menu, Tray, Icon, %icon%
    }else{
      Menu, VimSubMenu, Icon, Status, %icon%
      if(VimIcon == 1){
        Menu, Tray, Icon, %icon%
      }
    }
  }
}

VimStatus(Title, lines=1){
  global
  WinGetPos, , , W, H, A
  Tooltip, %Title%, W - 110, H - 30 - (lines) * 20
  SetTimer, VimRemoveStatus, 1000
}

; These labels might cause problems because it is now in the auto-run section, but was after it previously.
; TODO convert to function to fix autorun problems.
VimRemoveStatus:
  SetTimer, VimRemoveStatus, off
  Tooltip
Return

VimStatusCheckTimer:
  if WinActive("ahk_group " . VimGroupName)
  {
    VimSetIcon(VimMode)
  }else{
    VimSetIcon("Disabled")
  }
Return

VimStartStatusCheck:
  SetTimer, VimStatusCheckTimer, off
Return

VimStopStatusCheck:
  SetTimer, VimStatusCheckTimer, off
Return

VimAddCheckbox(name, defaultVal, description){
  global VimCheckboxesCreated
  if(VimCheckboxesCreated == 0){
    Gui, VimGuiSettings:Add, Checkbox, XS+10 YS+20 v%name%, %description%
    VimCheckboxesCreated  := 1
  }else{
    Gui, VimGuiSettings:Add, Checkbox, XS+10 Y+10 v%name%, %description%
  }

  if(%name% == 1){
    GuiControl, VimGuiSettings:, %name%, 1
  }
}

; vim: foldmethod=marker
; vim: foldmarker={{{,}}}
