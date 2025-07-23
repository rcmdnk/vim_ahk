﻿; Utilities
#Include %A_LineFile%\..\util\vim_ahk_setting.ahk
#Include %A_LineFile%\..\util\vim_ime.ahk

; Classes, Functions
#Include %A_LineFile%\..\vim_about.ahk
#Include %A_LineFile%\..\vim_check.ahk
#Include %A_LineFile%\..\vim_icon.ahk
#Include %A_LineFile%\..\vim_caret.ahk
#Include %A_LineFile%\..\vim_hotkey.ahk
#Include %A_LineFile%\..\vim_ini.ahk
#Include %A_LineFile%\..\vim_menu.ahk
#Include %A_LineFile%\..\vim_move.ahk
#Include %A_LineFile%\..\vim_setting.ahk
#Include %A_LineFile%\..\vim_state.ahk
#Include %A_LineFile%\..\vim_tooltip.ahk

; Key Bindings
#Include %A_LineFile%\..\vim_bind.ahk

class VimAhk{
  __About(){
    this.About.Version := "v0.14.2"
    this.About.Date := "14/Dec/2024"
    this.About.Author := "rcmdnk"
    this.About.Description := "Vim emulation with AutoHotkey, everywhere in Windows."
    this.About.Homepage := "https://github.com/rcmdnk/vim_ahk"
  }

  __New(ScriptPath){
    this.ScriptPath := ScriptPath
    this.Enabled := True


    ; Classes
    this.About := VimAbout(this)
    this.Check := VimCheck(this)
    this.Icon := VimIcon(this)
    this.Caret := VimCaret(this)
    this.VimHotkey := VimHotkey(this)
    this.Ini := VimIni(this)
    this.VimMenu := VimMenu(this)
    this.Move := VimMove(this)
    this.Setting := VimSetting(this)
    this.State := VimState(this)
    this.VimToolTip := VimToolTip(this)

    ; Group Settings
    this.GroupDel := ","
    this.GroupN := 0
    this.GroupName := "VimGroup" this.GroupN

    DefaultGroup := this.SetDefaultActiveWindows()

    ; On following applications, Enter works as Enter at the normal mode.
    GroupAdd("VimNonEditor", "ahk_exe explorer.exe")  ; Explorer
    GroupAdd("VimNonEditor", "ahk_exe q-dir_x64.exe") ; Q-dir
    GroupAdd("VimNonEditor", "ahk_exe q-dir.exe")     ; Q-dir

    ; Following applications select the line break at Shift + End.
    GroupAdd("VimLBSelectGroup", "ahk_exe powerpnt.exe") ; PowerPoint
    GroupAdd("VimLBSelectGroup", "ahk_exe winword.exe")  ; Word
    GroupAdd("VimLBSelectGroup", "ahk_exe wordpad.exe")  ; WordPad

    ; Following applications do not copy the line break
    GroupAdd("VimNoLBCopyGroup", "ahk_exe evernote.exe") ; Evernote

    ; Need Ctrl for Up/Down
    GroupAdd("VimCtrlUpDownGroup", "ahk_exe onenote.exe") ; OneNote Desktop, before Windows 10

    ; Need Home twice
    GroupAdd("VimDoubleHomeGroup", "ahk_exe code.exe") ; Visual Studio Code

    ; Followings can emulate ^. For others, ^ works as same as 0
    ; It does not work for NotePad at Windows 11
    ; GroupAdd("VimCaretMove", "ahk_exe notepad.exe") ; NotePad

    ; Followings start cursor from the same place after selection.
    ; Others start right/left (by cursor) point of the selection
    GroupAdd("VimCursorSameAfterSelect", "ahk_exe notepad.exe") ; NotePad
    GroupAdd("VimCursorSameAfterSelect", "ahk_exe explorer.exe") ; Explorer

    ; Q-Dir
    GroupAdd("VimQdir", "ahk_exe q-dir_x64.exe") ; q-dir
    GroupAdd("VimQdir", "ahk_exe q-dir.exe") ; q-dir

    ; Configuration values for Read/Write ini
    ; setting, default, val, description, info
    this.Conf := Map()
    this.AddToConf("VimEscNormal", 1, 1
      , "ESC to enter the normal mode"
      , "Use ESC to enter the normal mode, long press ESC to send ESC.")
    this.AddToConf("VimSendEscNormal", 0, 0
      , "Send ESC by ESC at the normal mode"
      , "If not checked, short press ESC does not send anything at the normal mode.`nEnable ESC to enter the normal mode first.")
    this.AddToConf("VimLongEscNormal", 0, 0
      , "Long press ESC to enter the normal mode"
      , "Swap short press and long press behaviors for ESC.`nEnable ESC to enter Normal mode first.")
    this.AddToConf("VimCtrlBracketToEsc", 1, 1
      , "Ctrl-[ to ESC"
      , "Send ESC by Ctrl-[.`nThis changes Ctrl-[ behavir even if Ctrl-[ to enter the normal mode is enabled.`nIf both Ctlr-[ to ESC and Ctlr-[ to enter the normal mode are enabled, long press Ctrl-[ sends ESC instead of Ctrl-[.")
    this.AddToConf("VimCtrlBracketNormal", 1, 1
      , "Ctrl-[ to enter the normal mode"
      , "Use Ctrl-[ to enter the normal mode, long press Ctrl-[ to send Ctrl-[.")
    this.AddToConf("VimSendCtrlBracketNormal", 0, 0
      , "Send Ctrl-[ by Ctrl-[ at the normal mode"
      , "If not checked, short press Ctrl-[ does not send anything at the normal mode.`nEnable Ctrl-[ to enter the normal mode first.")
    this.AddToConf("VimLongCtrlBracketNormal", 0, 0
      , "Long press Ctrl-[ to enter the normal mode:"
      , "Swap short press and long press behaviors for Ctrl-[.`nEnable Ctrl-[ to enter the normal mode first.")
    this.AddToConf("VimChangeCaretWidth", 0, 0
      , "Change to thick text caret when in normal mode"
      , "When entering normal mode, sets the text cursor/caret to a thick bar, then sets back to thin when exiting normal mode.`nDoesn't work with all windows, and causes the current window to briefly lose focus when changing mode.")
    this.AddToConf("VimRestoreIME", 1, 1
      , "Restore IME status at entering the insert mode"
      , "Save the IME status in the insert mode, and restore it at entering the insert mode.")
    this.AddToConf("VimJJ", 0, 0
      , "JJ to enter the normal mode"
      , "Use JJ to enter the normal mode.")
    this.AddToConf("VimTwoLetter", "", ""
      , "Two-letter to enter the normal mode"
      , "When these two letters are pressed together in insert mode, enters the normal mode.`n`nSet one per line, exactly two letters per line.`nThe two letters must be different.")
    this.AddToConf("VimDisableUnused", 1, 1
      , "Disable unused keys in the normal mode"
      , "1: Do not disable unused keys`n2: Disable alphabets (+shift) and symbols`n3: Disable all including keys with modifiers (e.g. Ctrl+Z)")
    this.AddToConf("VimSetTitleMatchMode", "2", "2"
      , "SetTitleMatchMode"
      , "[Mode] 1: Start with, 2: Contain, 3: Exact match, RegExp: Regular expression.`n[Fast/Slow] Fast: Text is not detected for such edit control, Slow: Works for all windows, but slow.")
    this.AddToConf("VimSetTitleMatchModeFS", "Fast", "Fast"
      , "SetTitleMatchMode"
      , "[Mode]1: Start with, 2: Contain, 3: Exact match, RegExp: Regular expression.`n[Fast/Slow]: Fast: Text is not detected for such edit control, Slow: Works for all windows, but slow.")
    this.AddToConf("VimIconCheckInterval", 1000, 1000
      , "Icon check interval (ms)"
      , "Interval to check vim_ahk status (ms) and change tray icon. If it is set to 0, the original AHK icon is set.")
    this.AddToConf("VimVerbose", 1, 1
      , "Verbose level"
      , "1: Nothing `n2: Minimum tooltip (mode information only)`n3: Tooltip (all information)`n4: Debug mode with a message box, which doesn't disappear automatically")
    this.AddToConf("VimAppList", "Allow List", "Allow List"
      , "Application list usage"
      , "All: Enable on all application (the application list is ignored) `nAllow List: Use the application list as an allow list`nDeny List: Use the application list as a deny list")
    this.AddToConf("VimGroup", DefaultGroup, DefaultGroup
      , "Application"
      , "Set one application per line.`n`nIt can be any of Window Title, Class or Process.`nYou can check these values by Window Spy (in the right click menu of tray icon).")

    this.CheckBoxes := ["VimEscNormal", "VimSendEscNormal", "VimLongEscNormal", "VimCtrlBracketToEsc", "VimCtrlBracketNormal", "VimSendCtrlBracketNormal", "VimLongCtrlBracketNormal", "VimRestoreIME", "VimJJ", "VimChangeCaretWidth"]

    ; Initialize
    this.Initialize()
  }

  AddToConf(setting, default, val, description, info){
    this.Conf[setting] :=  Map("default", default, "val", val, "description", description, "info", info)
  }

  SetConfDefault(){
    for k, v in this.Conf {
      v["val"] := v["default"]
    }
  }

  SetExistValue(){
    for k, v in this.Conf {
      if(IsSet(%k%)){
        v["default"] := %k%
        v["val"] := %k%
      }
    }
  }

  GetConf(Key, Data){
    return this.Conf[Key][Data]
  }

  GetVal(Key){
    return this.GetConf(Key, "val")
  }

  GetDefault(Key){
    return this.GetConf(Key, "default")
  }

  GetDescription(Key){
    return this.GetConf(Key, "description")
  }

  GetInfo(Key){
    return this.GetConf(Key, "info")
  }

  SetGroup(){
    this.GroupN++
    this.GroupName := "VimGroup" this.GroupN
    Loop Parse, this.GetConf("VimGroup", "val"), this.GroupDel {
      if(A_LoopField != ""){
        GroupAdd(this.GroupName, A_LoopField)
      }
    }
  }

  Setup(){
    SetTitleMatchMode(this.GetVal("VimSetTitleMatchMode"))
    SetTitleMatchMode(this.GetVal("VimSetTitleMatchModeFS"))
    this.State.SetStatusCheck()
    this.SetGroup()
    this.VimHotkey.Set()
  }

  Initialize(){
    this.__About()
    this.SetExistValue()
    this.Ini.ReadIni()
    this.VimMenu.SetMenu()
    this.Setup()
  }

  SetDefaultActiveWindows(){
    DefaultList := ["ahk_exe evernote.exe"  ; Evernote
                  , "ahk_exe explorer.exe"  ; Explorer
                  , "ahk_exe notepad.exe"   ; NotePad
                  , "ahk_exe onenote.exe"   ; OneNote Desktop
                  , "ahk_exe applicationframehost.exe" ; Some Windows applications use this, including OneNote at Windows 10
                  , "ahk_exe powerpnt.exe"  ; PowerPoint
                  , "ahk_exe terapad.exe"   ; TeraPad
                  , "ahk_exe texstudio.exe" ; TexStudio
                  , "ahk_exe texworks.exe"  ; TexWork
                  , "Write:"                ; Thunderbird, English
                  , "作成"                  ; Thunderbird, 日本語
                  , "ahk_exe code.exe"      ; Visual Studio Code
                  , "ahk_exe winword.exe"   ; Word
                  , "ahk_exe wordpad.exe"   ; WordPad
                  , "ahk_exe q-dir_x64.exe" ; Q-dir
                  , "ahk_exe q-dir.exe"     ; Q-dir
                  , "ahk_exe obsidian.exe"] ; Obsidian

    DefaultGroup := ""
    for i, v in DefaultList
    {
      if(DefaultGroup == ""){
        DefaultGroup := v
      }else{
        DefaultGroup := DefaultGroup this.GroupDel v
      }
    }
    Return DefaultGroup
  }

  IsVimGroup(){
    if(not this.Enabled){
      Return False
    }else if(this.GetVal("VimAppList") == "Allow List"){
      Return WinActive("ahk_group " . this.GroupName)
    }else if(this.GetVal("VimAppList") == "Deny List"){
      Return !WinActive("ahk_group " . this.GroupName)
    }
    Return True
  }

  ; Ref: https://www.reddit.com/r/AutoHotkey/comments/4ma5b8/identifying_end_of_line_when_typing_with_ahk_and/
  CheckChr(Key){
    BlockInput("Send")
    ClipSaved := ClipboardAll()
    A_Clipboard := ""
    SendInput("{Shift Down}{Right}{Shift up}{Ctrl down}c{Ctrl Up}{Left}")
    Sleep(10)
    ret := False
    If (A_Clipboard ~= Key){
      ret := True
    }
    sleep(10)
    A_Clipboard := ClipSaved
    BlockInput("Off")
    Return ret
  }

  AddToolTip(Hwnd, Text){
    this.VimToolTip.Info[Hwnd] := Text
  }
}
