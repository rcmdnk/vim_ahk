class VimSetting Extends VimGui{
  __New(vim){
    this.Vim := vim
    base.__New("Vim Ahk Settings")
  }

  MakeGui(){
    global VimRestoreIME, VimJJ, VimJK, VimSD
    global VimDisableUnused, VimDisableUnusedValue, VimSetTitleMatchMode, VimSetTitleMatchModeFS, VimIconCheckInterval, VimVerbose, VimVerboseValue, VimGroup, VimGroupList
    global VimDisableUnusedText, VimSetTitleMatchModeText, VimIconCheckIntervalText, VimIconCheckIntervalEdit, VimVerboseText, VimGroupText, VimHomepage
    Gui, % this.Hwnd ":-MinimizeBox"
    Gui, % this.Hwnd ":-Resize"
    created := 0
    for i, k in this.Vim.Checkboxes {
      if(created == 0){
        y := "YM"
      }else{
        y := "Y+10"
      }
      Gui, % this.Hwnd ":Add", Checkbox, XM+10 %y% v%k%, % this.Vim.Conf[k]["description"]
      created  := 1
      GuiControl, % this.Hwnd ":", %k%, % this.Vim.Conf[k]["val"]
    }
    Gui, % this.Hwnd ":Add", Text, % "XM+10 Y+15 g" . this.__Class . ".DisableUnusedText vVimDisableUnusedText", % this.Vim.Conf["VimDisableUnused"]["description"]
    disableUnused := this.Vim.DisableUnused
    Gui, % this.Hwnd ":Add", DropDownList, % "W320 vVimDisableUnusedValue Choose" . this.Vim.Conf["VimDisableUnused"]["val"], % disableUnused[1]"|"disableUnused[2]"|"disableUnused[3]
    Gui, % this.Hwnd ":Add", Text, % "XM+10 Y+15 g" . this.__Class . ".SetTitleMatchModeText vVimSetTitleMatchModeText", % this.Vim.Conf["VimSetTitleMatchMode"]["description"]
    if(this.Vim.Conf["VimSetTitleMatchMode"]["val"] == "RegEx"){
      matchmode := 4
    }else{
      matchmode := this.Vim.Conf["VimSetTitleMatchMode"]["val"]
    }
    Gui, % this.Hwnd ":Add", DropDownList, % "X+5 Y+-16 W70 vVimSetTitleMatchMode Choose"matchmode, 1|2|3|RegEx
    if(this.Vim.Conf["VimSetTitleMatchModeFS"]["val"] == "Fast"){
      matchmodefs := 1
    }else{
      matchmodefs := 2
    }
    Gui, % this.Hwnd ":Add", DropDownList, % "X+5 Y+-20 W70 vVimSetTitleMatchModeFS Choose"matchmodefs, Fast|Slow
    Gui, % this.Hwnd ":Add", Text, % "XM+10 Y+10 g" . this.__Class . ".IconCheckIntervalText vVimIconCheckIntervalText", % this.Vim.Conf["VimIconCheckInterval"]["description"]
    Gui, % this.Hwnd ":Add", Edit, X+5 Y+-16 W70 vVimIconCheckIntervalEdit
    Gui, % this.Hwnd ":Add", UpDown, vVimIconCheckInterval Range0-1000000, % this.Vim.Conf["VimIconCheckInterval"]["val"]
    Gui, % this.Hwnd ":Add", Text, % "XM+10 Y+10 g" . this.__Class . ".VerboseText vVimVerboseText", % this.Vim.Conf["VimVerbose"]["description"]
    verbose := this.Vim.Verbose
    Gui, % this.Hwnd ":Add", DropDownList, % "X+5 Y+-16 vVimVerboseValue Choose"this.Vim.Conf["VimVerbose"]["val"], % verbose[1]"|"verbose[2]"|"verbose[3]"|"verbose[4]
    Gui, % this.Hwnd ":Add", Text, % "XM+10 Y+5 g" . this.__Class . ".GroupText vVimGroupText", % this.Vim.Conf["VimGroup"]["description"]
    StringReplace, VimGroupList, % this.Vim.Conf["VimGroup"]["val"], % this.Vim.GroupDel, `n, All
    Gui, % this.Hwnd ":Add", Edit, XM+10 Y+5 R10 W300 Multi vVimGroupList, %VimGroupList%
    Gui, % this.Hwnd ":Add", Text, XM+10 Y+10, Check
    Gui, % this.Hwnd ":Font", Underline
    Gui, % this.Hwnd ":Add", Text, +HwndHomepageHwnd X+5 cBlue vVimHomepage, HELP
    homepage := ObjBindMethod(this.Vim.About, "OpenHomepage")
    GuiControl, +G, % HomepageHwnd, % homepage
    Gui, % this.Hwnd ":Font", Norm
    Gui, % this.Hwnd ":Add", Text, X+5, for further information.

    Gui, % this.Hwnd ":Add", Button, +HwndOKHwnd X45 W100 Y+10 Default, &OK
    this.OKHwnd := OKHwnd
    ok := ObjBindMethod(this, "OK")
    GuiControl, +G, % OKHwnd, % ok

    Gui, % this.Hwnd ":Add", Button, +HwndResetHwnd W100 X+10, &Reset
    this.ResetHwnd := ResetHwnd
    reset := ObjBindMethod(this, "Reset")
    GuiControl, +G, % ResetHwnd, % reset

    Gui, % this.Hwnd ":Add", Button, +HwndCancelHwnd W100 X+10, &Cancel
    this.CancelHwnd := CancelHwnd
    cancel := ObjBindMethod(this, "Cancel")
    GuiControl, +G, % CancelHwnd, % cancel
  }

  UpdateGui(){
    global VimRestoreIME, VimJJ, VimJK, VimSD
    global VimDisableUnused, VimDisableUnusedValue, VimSetTitleMatchMode, VimSetTitleMatchModeFS, VimIconCheckInterval, VimVerbose, VimVerboseValue, VimGroup, VimGroupList
    this.VimConf2V()
    for i, k in this.Vim.Checkboxes {
      GuiControl, % this.Hwnd ":", %k%, % this.Vim.Conf[k]["val"]
    }
    GuiControl, % this.Hwnd ":Choose", VimDisableUnusedValue, % VimDisableUnused
    GuiControl, % this.Hwnd ":", VimIconCheckInterval, % VimIconCheckInterval
    if(this.Vim.Conf["VimSetTitleMatchMode"]["val"] == "RegEx"){
      matchmode := 4
    }else{
      matchmode := this.Vim.Conf["VimSetTitleMatchMode"]["val"]
    }
    GuiControl, % this.Hwnd ":Choose", VimSetTitleMatchMode, % matchmode
    if(this.Vim.Conf["VimSetTitleMatchModeFS"]["val"] == "Fast"){
      matchmodefs := 1
    }else{
      matchmodefs := 2
    }
    GuiControl, % this.Hwnd ":Choose", VimSetTitleMatchModeFS, % matchmodefs
    GuiControl, % this.Hwnd ":Choose", VimVerboseValue, % VimVerbose
    GuiControl, % this.Hwnd ":", VimGroupList, % VimGroupList
  }

  ; Dummy Labels, to enable tooltip over the text
  DisableUnusedText(){
  }
  SetTitleMatchModeText(){
  }
  IconCheckIntervalText(){
  }
  VerboseText(){
  }
  GroupText(){
  }

  OnMouseMove(wp, lp, msg, hwnd){
    this.Vim.State.CurrControl := A_GuiControl
    if(this.Vim.State.CurrControl != this.Vim.State.PrevControl){
      this.Vim.State.PrevControl := this.Vim.State.CurrControl
      this.RemoveToolTip()
      if(this.Vim.Info.HasKey(this.Vim.State.CurrControl)){
        display := ObjBindMethod(this, "DisplayToolTip")
        SetTimer, % display, -1000
      }
    }
    Return
  }

  DisplayToolTip(){
    display := ObjBindMethod(this, "DisplayToolTip")
    SetTimer, % display, Off
    ToolTip % this.Vim.Info[this.Vim.State.CurrControl]
    remove := ObjBindMethod(this, "RemoveToolTip")
    SetTimer, % remove, -60000
  }

  RemoveToolTip(){
    display := ObjBindMethod(this, "DisplayToolTip")
    remove := ObjBindMethod(this, "RemoveToolTip")
    SetTimer, % display, Off
    SetTimer, % remove, Off
    ToolTip
  }

  VimV2Conf(){
    global VimRestoreIME, VimJJ, VimJK, VimSD
    global VimDisableUnused, VimDisableUnusedValue, VimSetTitleMatchMode, VimSetTitleMatchModeFS, VimIconCheckInterval, VimVerbose, VimVerboseValue, VimGroup, VimGroupList
    Loop, % this.Vim.DisableUnused.Length() {
      if(VimDisableUnusedValue == this.Vim.DisableUnused[A_Index]){
        VimDisableUnused := A_Index
        Break
      }
    }
    Loop, % this.Vim.Verbose.Length() {
      if(VimVerboseValue == this.Vim.Verbose[A_Index]){
        VimVerbose := A_Index
        Break
      }
    }
    VimGroup := ""
    tmpArray := []
    Loop, Parse, VimGroupList, `n
    {
      if(! tmpArray.Haskey(A_LoopField)){
        tmpArray.push(A_LoopField)
        if(VimGroup == ""){
          VimGroup := A_LoopField
        }else{
          VimGroup := VimGroup . this.Vim.GroupDel . A_LoopField
        }
      }
    }
    for k, v in this.Vim.Conf {
      v["val"] := %k%
    }
    this.Vim.Setup()
  }

  VimConf2V(){
    global VimRestoreIME, VimJJ, VimJK, VimSD
    global VimDisableUnused, VimDisableUnusedValue, VimSetTitleMatchMode, VimSetTitleMatchModeFS, VimIconCheckInterval, VimVerbose, VimVerboseValue, VimGroup, VimGroupList
    VimDisableUnusedValue = this.Vim.VimDisableUnused[VimDisableUnused]
    VimVerboseValue = this.Vim.Verbose[VimVerbose]
    StringReplace, VimGroupList, % this.Vim.Conf["VimGroup"]["val"], % this.Vim.GroupDel, `n, All
    for k, v in this.Vim.Conf {
      %k% := v["val"]
    }
  }

  OK(){
    Gui, % this.Hwnd . ":Submit"
    this.VimV2Conf()
    this.vim.Ini.WriteIni()
    this.Hide()
  }
  Cancel(){
    this.Hide()
  }

  Reset(){
    for k, v in this.Vim.Conf {
      this.Vim.Conf[k]["val"] := v["default"]
    }
    this.Vim.Ini.WriteIni()
    this.Hide()
    this.ShowGui()
  }

  OpenHomepage(){
    ToolTip
    Run % this.Homepage
  }
}
