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
    this.About.Version := "v0.7.1"
    this.About.Date := "22/Apr/2020"
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
    GroupAdd, VimCursorSameAfterSelect, ahk_exe explorer.exe ; Explorer

    ; Configuration values for Read/Write ini
    this.Conf := {}
    this.AddToConf("VimRestoreIME", 1, 1
      , "Restore IME status at entering insert mode:"
      , "Restore IME status at entering insert mode.")
    this.AddToConf("VimLongEscNormal", 0, 0
      , "Long press esc to enter normal mode:"
      , "Hold esc to enter normal, allowing single press to send esc to window")
    this.AddToConf("VimJJ", 0, 0
      , "JJ enters Normal mode:"
      , "Assign JJ enters Normal mode.")
    this.AddToConf("VimTwoLetter", "", ""
      , "Two-letter to enter Normal mode:"
      , "When these two letters are pressed together in insert mode, enters normal mode.`n`nSet one per line, exactly two letters per line.`nThe two letters must be different.")
    this.AddToConf("VimDisableUnused", 1, 1
      , "Disable unused keys in Normal mode:"
      , "1: Do not disable unused keys`n2: Disable alphabets (+shift) and symbols`n3: Disable all including keys with modifiers (e.g. Ctrl+Z)")
    this.AddToConf("VimSetTitleMatchMode", "2", "2"
      , "SetTitleMatchMode:"
      , "[Mode] 1: Start with, 2: Contain, 3: Exact match.`n[Fast/Slow] Fast: Text is not detected for such edit control, Slow: Works for all windows, but slow.")
    this.AddToConf("VimSetTitleMatchModeFS", "Fast", "Fast"
      , "SetTitleMatchMode"
      , "[Mode]1: Start with, 2: Contain, 3: Exact match.`n[Fast/Slow]: Fast: Text is not detected for such edit control, Slow: Works for all windows, but slow.")
    this.AddToConf("VimIconCheckInterval", 1000, 1000
      , "Icon check interval (ms):"
      , "Interval to check vim_ahk status (ms) and change tray icon. If it is set to 0, the original AHK icon is set.")
    this.AddToConf("VimVerbose", 1, 1
      , "Verbose level:"
      , "1: Nothing `n2: Minimum tooltip of status`n3: More info in tooltip`n4: Debug mode with a message box, which doesn't disappear automatically")
    this.AddToConf("VimGroup", DefaultGroup, DefaultGroup
      , "Application:"
      , "Set one application per line.`n`nIt can be any of Window Title, Class or Process.`nYou can check these values by Window Spy (in the right click menu of tray icon).")

    this.CheckBoxes := ["VimRestoreIME", "VimJJ", "VimLongEscNormal"]

    ; Other ToolTip Information
    this.Info := {}
    for k, v in this.Conf {
      this.Info[k] := v["info"]
      textKey := k "Text"
      this.Info[textKey] := v["info"]
    }
    this.SetInfo("VimGroup", "List")
    this.SetInfo("VimTwoLetter", "List")
    this.SetInfo("VimDisableUnused", "Value")
    this.SetInfo("VimSetTitleMatchMode", "Value")
    this.SetInfo("VimIconCheckInterval", "Edit")
    this.SetInfo("VimVerbose", "Value")

    this.Info["VimSettingOK"] := "Reflect changes and exit"
    this.Info["VimSettingReset"] := "Reset to the default values"
    this.Info["VimSettingCancel"] := "Don't change and exit"

    ; Initialize
    this.Initialize()
  }

  SetInfo(variable, variablevaluename){
    key := % variable variablevaluename
    this.Info[key] := this.Conf[variable]["info"]
  }

  AddToConf(setting, default, val, description, info){
    this.Conf[setting] :=  {"default": default, "val": val, "description": description, "info": info}
  }

  SetExistValue(){
    for k, v in this.Conf {
      if(%k% != ""){
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

  AddToTwoLetterMap(l1, l2){
    this.Conf["VimTwoLetter"]["val"] := this.Conf["VimTwoLetter"]["val"] . this.GroupDel . l1 . l2
  }
}
