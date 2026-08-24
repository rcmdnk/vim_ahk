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
    this.ConfiguredGroupN := 0
    this.ConfiguredGroups := Map()

    DefaultGroup := this.SetDefaultActiveWindows()

    ; Configuration values for Read/Write ini
    this.Conf := VimSettingSchema.Build(DefaultGroup, this.GroupDel)

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
    VimSettingSchema.ValidateExclusiveGroups(this.Conf, Values, this.GroupDel)
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

  ; AutoHotkey can only append rules to window groups; existing rules cannot be cleared.
  ; Whenever settings are applied, new groups are built before the current mapping is replaced.
  ; Old groups remain until the script exits and are no longer queried.
  SetConfiguredGroups(){
    this.ConfiguredGroupN++
    Groups := Map()
    for , Setting in this.Conf {
      Group := Setting["group"]
      if (Group == "") {
        continue
      }
      GroupName := Group "_" this.ConfiguredGroupN
      Groups[Group] := GroupName
      Loop Parse, Setting["val"], this.GroupDel {
        if (A_LoopField != "") {
          GroupAdd(GroupName, A_LoopField)
        }
      }
    }
    this.ConfiguredGroups := Groups
  }

  IsConfiguredGroup(Group){
    return this.ConfiguredGroups.Has(Group)
      and WinActive("ahk_group " this.ConfiguredGroups[Group])
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
    this.SetConfiguredGroups()
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
