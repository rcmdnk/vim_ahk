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
#Include %A_LineFile%\..\vim_setting_schema.ahk
#Include %A_LineFile%\..\vim_setting.ahk
#Include %A_LineFile%\..\vim_state.ahk
#Include %A_LineFile%\..\vim_tooltip.ahk

; Key Bindings
#Include %A_LineFile%\..\vim_bind.ahk

class VimAhk{
  __About(){
    this.About.Version := "v0.16.7"
    this.About.Date := "2/Aug/2026"
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
    ; G sends {End} (not Ctrl+End) to scroll to bottom in these apps.
    GroupAdd("VimNonEditor", "ahk_exe explorer.exe")  ; Explorer
    GroupAdd("VimNonEditor", "ahk_exe q-dir_x64.exe") ; Q-dir
    GroupAdd("VimNonEditor", "ahk_exe q-dir.exe")     ; Q-dir
    GroupAdd("VimNonEditor", "ahk_exe chrome.exe")    ; Google Chrome
    GroupAdd("VimNonEditor", "ahk_exe msedge.exe")    ; Microsoft Edge
    GroupAdd("VimNonEditor", "ahk_exe firefox.exe")   ; Firefox
    GroupAdd("VimNonEditor", "ahk_exe waterfox.exe")  ; Waterfox
    GroupAdd("VimNonEditor", "ahk_exe brave.exe")     ; Brave
    GroupAdd("VimNonEditor", "ahk_exe vivaldi.exe")   ; Vivaldi
    GroupAdd("VimNonEditor", "ahk_exe opera.exe")     ; Opera

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

    ; Shift-Enter to insert line break in these applications
    GroupAdd("VimShiftEnter", "ahk_exe ChatGPT.exe") ;
    GroupAdd("VimShiftEnter", "ahk_exe Claude.exe") ;
    GroupAdd("VimShiftEnter", "ahk_exe Cursor.exe") ;
    GroupAdd("VimShiftEnter", "ahk_exe slack.exe") ;
    GroupAdd("VimShiftEnter", "ahk_exe ms-teams.exe") ;
    GroupAdd("VimShiftEnter", "ahk_exe Teams.exe") ; Old version
    GroupAdd("VimShiftEnter", "ahk_exe Discord.exe") ;
    GroupAdd("VimShiftEnter", "ahk_exe WhatsApp.exe") ;
    GroupAdd("VimShiftEnter", "ahk_exe Zoom.exe") ;
    GroupAdd("VimShiftEnter", "ahk_exe PhoneExperienceHost.exe") ;
    GroupAdd("VimShiftEnter", "ahk_exe LINE.exe") ;

    ; Control-Enter to insert line break in these applications
    ;GroupAdd("VimCtrlEnter", "...") ;

    ; Configuration values for Read/Write ini
    this.Conf := VimSettingSchema.Build(DefaultGroup)

    this.CheckBoxes := ["VimEscNormal", "VimEscNormalDirect", "VimSendEscNormal", "VimLongEscNormal", "VimCtrlBracketToEsc", "VimCtrlBracketNormal", "VimCtrlBracketNormalDirect", "VimSendCtrlBracketNormal", "VimLongCtrlBracketNormal", "VimRestoreIME", "VimJJ", "VimChangeCaretWidth"]

    ; Initialize
    this.Initialize()
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

  SetValues(Values){
    for Key, Value in Values {
      this.Conf[Key]["val"] := Value
    }
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
    Values := VimSettingSchema.NormalizeValues(
      this.Conf, VimSettingSchema.Values(this.Conf), this.GroupDel)
    this.SetValues(Values)
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
