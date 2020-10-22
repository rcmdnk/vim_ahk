; Utilities
#Include %A_LineFile%\..\util\vim_ahk_setting.ahk
#Include %A_LineFile%\..\util\vim_ime.ahk

; Classes, Functions
#Include %A_LineFile%\..\vim_about.ahk
#Include %A_LineFile%\..\vim_check.ahk
#Include %A_LineFile%\..\vim_gui.ahk
#Include %A_LineFile%\..\vim_icon.ahk
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
    this.About.Version := "v0.8.5"
    this.About.Date := "20/Oct/2020"
    this.About.Author := "rcmdnk"
    this.About.Description := "Vim emulation with AutoHotkey, everywhere in Windows."
    this.About.Homepage := "https://github.com/rcmdnk/vim_ahk"
    this.Info["VimHomepage"] := this.About.Homepage
  }

  __New(setup=true){
    ; Classes
    this.About := new VimAbout(this)
    this.Check := new VimCheck(this)
    this.Icon := new VimIcon(this)
    this.Ini := new VimIni(this)
    this.VimMenu := new VimMenu(this)
    this.Move := new VimMove(this)
    this.Setting := new VimSetting(this)
    this.State := new VimState(this)
    this.VimToolTip := new VimToolTip(this)

    ; Group Settings
    this.GroupDel := ","
    this.GroupN := 0
    this.GroupName := "VimGroup" GroupN

    DefaultGroup := this.SetDefaultActiveWindows()

    ; Following applications select the line break at Shift + End.
    GroupAdd, VimLBSelectGroup, ahk_exe POWERPNT.exe ; PowerPoint
    GroupAdd, VimLBSelectGroup, ahk_exe WINWORD.exe  ; Word
    GroupAdd, VimLBSelectGroup, ahk_exe wordpad.exe  ; WordPad

    ; Following applications do not copy the line break
    GroupAdd, VimNoLBCopyGroup, ahk_exe Evernote.exe ; Evernote

    ; Need Ctrl for Up/Down
    GroupAdd, VimCtrlUpDownGroup, ahk_exe onenote.exe ; OneNote Desktop, before Windows 10

    ; Need Home twice
    GroupAdd, VimDoubleHomeGroup, ahk_exe Code.exe ; Visual Studio Code

    ; Followings can emulate ^. For others, ^ works as same as 0
    GroupAdd, VimCaretMove, ahk_exe notepad.exe ; NotePad

    ; Followings start cursor from the same place after selection.
    ; Others start right/left (by cursor) point of the selection
    GroupAdd, VimCursorSameAfterSelect, ahk_exe notepad.exe ; NotePad
    GroupAdd, VimCursorSameAfterSelect, ahk_exe explorer.exe ; Explorer

    ; Configuration values for Read/Write ini
    this.Conf := {}
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
      , "[Mode] 1: Start with, 2: Contain, 3: Exact match.`n[Fast/Slow] Fast: Text is not detected for such edit control, Slow: Works for all windows, but slow.")
    this.AddToConf("VimSetTitleMatchModeFS", "Fast", "Fast"
      , "SetTitleMatchMode"
      , "[Mode]1: Start with, 2: Contain, 3: Exact match.`n[Fast/Slow]: Fast: Text is not detected for such edit control, Slow: Works for all windows, but slow.")
    this.AddToConf("VimIconCheckInterval", 1000, 1000
      , "Icon check interval (ms)"
      , "Interval to check vim_ahk status (ms) and change tray icon. If it is set to 0, the original AHK icon is set.")
    this.AddToConf("VimVerbose", 1, 1
      , "Verbose level"
      , "1: Nothing `n2: Minimum tooltip (mode information only)`n3: Tooltip (all information)`n4: Debug mode with a message box, which doesn't disappear automatically")
    this.AddToConf("VimGroup", DefaultGroup, DefaultGroup
      , "Application"
      , "Set one application per line.`n`nIt can be any of Window Title, Class or Process.`nYou can check these values by Window Spy (in the right click menu of tray icon).")

    this.CheckBoxes := ["VimEscNormal", "VimSendEscNormal", "VimLongEscNormal", "VimCtrlBracketToEsc", "VimCtrlBracketNormal", "VimSendCtrlBracketNormal", "VimLongCtrlBracketNormal", "VimRestoreIME", "VimJJ"]

    ; ToolTip Information
    this.Info := {}
    for k, v in this.Conf {
      info := k ":`n" v["info"]
      this.Info[k] := info
      for i, type in ["Text", "List", "Value", "Edit"] {
        textKey := k type
        this.Info[textKey] := info
      }
    }

    this.Info["VimSettingOK"] := "Reflect changes and exit"
    this.Info["VimSettingReset"] := "Reset to the default values"
    this.Info["VimSettingCancel"] := "Don't change and exit"

    ; Initialize
    this.Initialize()
  }

  AddToConf(setting, default, val, description, info){
    this.Conf[setting] :=  {"default": default, "val": val, "description": description, "info": info}
  }

  SetExistValue(){
    for k, v in this.Conf {
      if(%k% != ""){
        this.Conf[k]["default"] := %k%
        this.Conf[k]["val"] := %k%
      }
    }
  }

  SetGroup(){
    this.GroupN++
    this.GroupName := "VimGroup" this.GroupN
    Loop, Parse, % this.Conf["VimGroup"]["val"], % this.GroupDel
    {
      if(A_LoopField != ""){
        GroupAdd, % this.GroupName, %A_LoopField%
      }
    }
  }

  LoadTwoLetterMaps() {
    this.TwoLetterNormalIsSet := False
    Loop, Parse, % this.Conf["VimTwoLetter"]["val"], % this.GroupDel
    {
      if(A_LoopField != ""){
        this.TwoLetterNormalIsSet := True
        key1 := SubStr(A_LoopField, 1, 1)
        key2 := SubStr(A_LoopField, 2, 1)
        this.SetTwoLetterMap(key1, key2)
      }
    }
  }

  SetTwoLetterMap(key1, key2){
    EnterNormal := ObjBindMethod(this, "TwoLetterEnterNormal")
    Enabled := ObjBindMethod(this, "TwoLetterNormalMapsEnabled")
    HotKey If, % Enabled
    HotKey, %key1% & %key2%, % EnterNormal
    HotKey, %key2% & %key1%, % EnterNormal
  }

  TwoLetterNormalMapsEnabled(){
    Return WinActive("ahk_group " this.GroupName) && (this.State.StrIsInCurrentVimMode("Insert")) && this.TwoLetterNormalIsSet
  }

  TwoLetterEnterNormal(){
    SendInput, {BackSpace 1}
    this.State.SetNormal()
  }

  Setup(){
    SetTitleMatchMode, % this.Conf["VimSetTitleMatchMode"]["val"]
    SetTitleMatchMode, % this.Conf["VimSetTitleMatchModeFS"]["val"]
    this.State.SetStatusCheck()
    this.SetGroup()
    this.LoadTwoLetterMaps()
  }

  Initialize(){
    this.__About()
    this.SetExistValue()
    this.Ini.ReadIni()
    this.VimMenu.SetMenu()
    this.Setup()
  }

  SetDefaultActiveWindows(){
    DefaultList := ["ahk_exe Evernote.exe"  ; Evernote
                  , "ahk_exe explorer.exe"  ; Explorer
                  , "ahk_exe notepad.exe"   ; NotePad
                  , "OneNote"               ; OneNote at Windows 10
                  , "ahk_exe onenote.exe"   ; OneNote Desktop
                  , "ahk_exe POWERPNT.exe"  ; PowerPoint
                  , "ahk_exe TeraPad.exe"   ; TeraPad
                  , "ahk_exe texstudio.exe" ; TexStudio
                  , "ahk_exe texworks.exe"  ; TexWork
                  , "Write:"                ; Thunderbird, English
                  , "作成"                  ; Thunderbird, 日本語
                  , "ahk_exe Code.exe"      ; Visual Studio Code
                  , "ahk_exe WINWORD.exe"   ; Word
                  , "ahk_exe wordpad.exe"]  ; WordPad

    DefaultGroup := ""
    For i, v in DefaultList
    {
      if(DefaultGroup == ""){
        DefaultGroup := v
      }else{
        DefaultGroup := DefaultGroup this.GroupDel v
      }
    }
    Return DefaultGroup
  }
}
