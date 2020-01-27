class VimConf{
  __New(setup=true){
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
    this.Popup["VimHomepage"] := VimAbout.Homepage

    ; Disable unused keys in Normal mode
    this.DisableUnused := ["1: Do not disable unused keys"
      , "2: Disable alphabets (+shift) and symbols"
      , "3: Disable all including keys with modifiers (e.g. Ctrl+Z)"]

    ; Tray Icon check interval

    ; Verbose level, 1: No pop up, 2: Minimum tool tips of status, 3: More info in tool tips, 4: Debug mode with a message box, which doesn't disappear automatically
    this.Verbose := ["1: No pop up", "2: Minimum tool tips"
      , "3: Tool tips" ,"4: Popup message"]

    this.CheckUserDefault()

    if(setup==true){
      this.Setup()
    }
  }

  CheckUserDefault(){
    for k, v in this.Conf {
      if(%k% != ""){
        this.Conf[k]["val"] := %k%
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

  Setup(){
    VimIni.ReadIni()
    this.SetGroup(this.Conf["VimGroup"]["val"])
    VimMenu.SetMenu()
    VimIconMng.SetIcon(VimState.Mode, this.Conf["VimIcon"]["val"])
    if(this.Conf["VimIconCheck"]["val"] == 1){
      SetTimer, VimStatusCheckTimer, % this.Conf["VimIconCheckInterval"]["val"]
    }
  }
}
