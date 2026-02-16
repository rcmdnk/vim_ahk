; Utilities
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
    this.About.Version := "v0.16.1"
    this.About.Date := "14/Feb/2026"
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
    GroupAdd("VimLBSelectGroup", "ahk_exe notepad.exe")  ; Notepad

    ; Following applications do not copy the line break
    GroupAdd("VimNoLBCopyGroup", "ahk_exe evernote.exe") ; Evernote

    ; Need Ctrl for Up/Down
    GroupAdd("VimCtrlUpDownGroup", "ahk_exe onenote.exe") ; OneNote Desktop, before Windows 10

    ; Need Home twice
    GroupAdd("VimDoubleHomeGroup", "ahk_exe code.exe") ; Visual Studio Code

    ; The following can emulate ^. For others, ^ works the same as 0.
    ; It does not work for Notepad on Windows 11.
    ; GroupAdd("VimCaretMove", "ahk_exe notepad.exe") ; Notepad

    ; The following start cursor from the same place after selection.
    ; Others start right/left (by cursor) point of the selection
    GroupAdd("VimCursorSameAfterSelect", "ahk_exe notepad.exe") ; Notepad
    GroupAdd("VimCursorSameAfterSelect", "ahk_exe explorer.exe") ; Explorer

    ; Q-Dir
    GroupAdd("VimQdir", "ahk_exe q-dir_x64.exe") ; q-dir
    GroupAdd("VimQdir", "ahk_exe q-dir.exe") ; q-dir

    ; Configuration values for Read/Write ini
    ; setting, default, val, description, info
    this.Conf := Map()
    this.AddToConf("VimEscNormal", 1, 1
      , "ESC to enter the normal mode"
      , "If checked, pressing ESC enters normal mode.")
    this.AddToConf("VimEscNormalDirect", 1, 1
      , "ESC to enter the normal mode directly even if converting in IME"
      , "If checked, ESC enters normal mode even while IME is converting.`nIf not checked, ESC behaves as normal ESC while IME is converting.")
    this.AddToConf("VimSendEscNormal", 0, 0
      , "Send ESC by ESC at the normal mode"
      , "If checked, a short ESC press sends ESC in normal mode.`nEnable ESC to enter normal mode first.")
    this.AddToConf("VimLongEscNormal", 0, 0
      , "Long press ESC to enter the normal mode"
      , "If checked, short and long press behavior of ESC is swapped.`nEnable ESC to enter normal mode first.")
    this.AddToConf("VimCtrlBracketToEsc", 1, 1
      , "Ctrl-[ to ESC"
      , "If checked, Ctrl-[ behaves as ESC.`nIf Ctrl-[ to normal mode is disabled, Ctrl-[ always sends ESC.`nIf both are checked, long press Ctrl-[ sends ESC.")
    this.AddToConf("VimCtrlBracketNormal", 1, 1
      , "Ctrl-[ to enter the normal mode"
      , "If checked, pressing Ctrl-[ enters normal mode.")
    this.AddToConf("VimCtrlBracketNormalDirect", 1, 1
      , "Ctrl-[ to enter the normal mode directly even if converting in IME"
      , "If checked, Ctrl-[ enters normal mode even while IME is converting.`nIf not checked, Ctrl-[ behaves as ESC while IME is converting.")
    this.AddToConf("VimSendCtrlBracketNormal", 0, 0
      , "Send Ctrl-[ by Ctrl-[ at the normal mode"
      , "If checked, a short Ctrl-[ press sends Ctrl-[ in normal mode.`nEnable Ctrl-[ to enter normal mode first.")
    this.AddToConf("VimLongCtrlBracketNormal", 0, 0
      , "Long press Ctrl-[ to enter the normal mode"
      , "If checked, short and long press behavior of Ctrl-[ is swapped.`nEnable Ctrl-[ to enter normal mode first.")
    this.AddToConf("VimChangeCaretWidth", 0, 0
      , "Change to thick text caret when in normal mode"
      , "If checked, caret width changes by mode (thick in normal/visual, thin in insert).`nIt may not work in all applications and can briefly change window focus.")
    this.AddToConf("VimRestoreIME", 1, 1
      , "Restore IME status at entering the insert mode"
      , "If checked, IME status is saved in insert mode and restored when returning to insert mode.")
    this.AddToConf("VimJJ", 0, 0
      , "JJ to enter the normal mode"
      , "If checked, `jj` enters normal mode from insert mode.")
    this.AddToConf("VimTwoLetter", "", ""
      , "Two-letter to enter the normal mode"
      , "Two-letter mappings to enter normal mode from insert mode.`nSet one pair per line.`nEach pair must be exactly two different letters.")
    this.AddToConf("VimDisableUnused", 1, 1
      , "Disable unused keys in the normal mode"
      , "Disable level for unused keys outside insert mode:`n1: Do not disable unused keys`n2: Disable alphabets (+Shift) and symbols`n3: Disable all, including modified keys (e.g. Ctrl+Z)")
    this.AddToConf("VimSetTitleMatchMode", "2", "2"
      , "SetTitleMatchMode"
      , "SetTitleMatchMode mode:`n1: Start with`n2: Contain`n3: Exact match`nRegEx: Regular expression")
    this.AddToConf("VimSetTitleMatchModeFS", "Fast", "Fast"
      , "SetTitleMatchMode"
      , "SetTitleMatchMode speed:`nFast: Text is not detected for some edit controls`nSlow: Works for all windows, but slower")
    this.AddToConf("VimIconCheckInterval", 1000, 1000
      , "Icon check interval (ms)"
      , "Interval (ms) to check vim_ahk status and update tray icon.`nIf set to 0, the original AHK icon is used.")
    this.AddToConf("VimVerbose", 1, 1
      , "Verbose level"
      , "Verbose level:`n1: No output`n2: Minimum tooltip (mode only)`n3: Tooltip (all information)`n4: Debug message box (does not auto-close)")
    this.AddToConf("VimAppList", "Allow List", "Allow List"
      , "Application list usage"
      , "Application list mode:`nAll: Enable vim_ahk on all applications (ignore the list)`nAllow List: Use list as allow list`nDeny List: Use list as deny list")
    this.AddToConf("VimGroup", DefaultGroup, DefaultGroup
      , "Application list"
      , "Applications where vim_ahk is enabled.`nSet one application per line.`nEach line can be Window Title, Class, or Process.")

    this.CheckBoxes := ["VimEscNormal", "VimEscNormalDirect", "VimSendEscNormal", "VimLongEscNormal", "VimCtrlBracketToEsc", "VimCtrlBracketNormal", "VimCtrlBracketNormalDirect", "VimSendCtrlBracketNormal", "VimLongCtrlBracketNormal", "VimRestoreIME", "VimJJ", "VimChangeCaretWidth"]

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
                  , "ahk_exe notepad.exe"   ; Notepad
                  , "ahk_exe onenote.exe"   ; OneNote Desktop
                  , "ahk_exe applicationframehost.exe" ; Some Windows applications use this, including OneNote at Windows 10
                  , "ahk_exe powerpnt.exe"  ; PowerPoint
                  , "ahk_exe terapad.exe"   ; TeraPad
                  , "ahk_exe texstudio.exe" ; TeXstudio
                  , "ahk_exe texworks.exe"  ; Texworks
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
