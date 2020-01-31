class VimSetting Extends VimGui{
  __New(vim){
    this.Vim := vim
    base.__New("Vim Ahk Settings")
    this.DisplayToolTipObj := ObjBindMethod(this, "DisplayToolTip")
    this.RemoveToolTipObj := ObjBindMethod(this, "RemoveToolTip")
  }

  MakeGui(){
    global VimRestoreIME, VimJJ, VimJK, VimSD
    global VimDisableUnused, VimSetTitleMatchMode, VimSetTitleMatchModeFS, VimIconCheckInterval, VimVerbose, VimGroup, VimGroupList
    global VimDisableUnusedText, VimSetTitleMatchModeText, VimIconCheckIntervalText, VimIconCheckIntervalEdit, VimVerboseText, VimGroupText, VimHomepage, VimGuiOK, VimGuiReset, VimGuiCancel
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
    Gui, % this.Hwnd ":Add", DropDownList, % "X+5 Y+-16 W30 vVimDisableUnused Choose" . this.Vim.Conf["VimDisableUnused"]["val"], 1|2|3
    Gui, % this.Hwnd ":Add", Text, % "XM+10 Y+15 g" . this.__Class . ".SetTitleMatchModeText vVimSetTitleMatchModeText", % this.Vim.Conf["VimSetTitleMatchMode"]["description"]
    if(this.Vim.Conf["VimSetTitleMatchMode"]["val"] == "RegEx"){
      matchmode := 4
    }else{
      matchmode := this.Vim.Conf["VimSetTitleMatchMode"]["val"]
    }
    Gui, % this.Hwnd ":Add", DropDownList, % "X+5 Y+-16 W60 vVimSetTitleMatchMode Choose"matchmode, 1|2|3|RegEx
    if(this.Vim.Conf["VimSetTitleMatchModeFS"]["val"] == "Fast"){
      matchmodefs := 1
    }else{
      matchmodefs := 2
    }
    Gui, % this.Hwnd ":Add", DropDownList, % "X+5 Y+-20 W50 vVimSetTitleMatchModeFS Choose"matchmodefs, Fast|Slow
    Gui, % this.Hwnd ":Add", Text, % "XM+10 Y+10 g" . this.__Class . ".IconCheckIntervalText vVimIconCheckIntervalText", % this.Vim.Conf["VimIconCheckInterval"]["description"]
    Gui, % this.Hwnd ":Add", Edit, X+5 Y+-16 W70 vVimIconCheckIntervalEdit
    Gui, % this.Hwnd ":Add", UpDown, vVimIconCheckInterval Range0-1000000, % this.Vim.Conf["VimIconCheckInterval"]["val"]
    Gui, % this.Hwnd ":Add", Text, % "XM+10 Y+10 g" . this.__Class . ".VerboseText vVimVerboseText", % this.Vim.Conf["VimVerbose"]["description"]
    Gui, % this.Hwnd ":Add", DropDownList, % "X+5 Y+-16 W30 vVimVerbose Choose"this.Vim.Conf["VimVerbose"]["val"], 1|2|3|4
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

    Gui, % this.Hwnd ":Add", Button, +HwndOKHwnd vVimGuiOK X45 W100 Y+10 Default, &OK
    this.OKHwnd := OKHwnd
    ok := ObjBindMethod(this, "OK")
    GuiControl, +G, % OKHwnd, % ok

    Gui, % this.Hwnd ":Add", Button, +HwndResetHwnd vVimGuiReset W100 X+10, &Reset
    this.ResetHwnd := ResetHwnd
    reset := ObjBindMethod(this, "Reset")
    GuiControl, +G, % ResetHwnd, % reset

    Gui, % this.Hwnd ":Add", Button, +HwndCancelHwnd vVimGuiCancel W100 X+10, &Cancel
    this.CancelHwnd := CancelHwnd
    cancel := ObjBindMethod(this, "Cancel")
    GuiControl, +G, % CancelHwnd, % cancel
  }

  UpdateGui(){
    this.VimConf2V()
    this.UpdateGuiValue()
  }

  UpdateGuiValue(){
    global VimRestoreIME, VimJJ, VimJK, VimSD
    global VimDisableUnused, VimSetTitleMatchMode, VimSetTitleMatchModeFS, VimIconCheckInterval, VimVerbose, VimGroup, VimGroupList
    for i, k in this.Vim.Checkboxes {
      kk := %k%
      GuiControl, % this.Hwnd ":", %k%, %kk%
    }
    GuiControl, % this.Hwnd ":Choose", VimDisableUnused, % VimDisableUnused
    GuiControl, % this.Hwnd ":", VimIconCheckInterval, % VimIconCheckInterval
    if(VimSetTitleMatchMode == "RegEx"){
      matchmode := 4
    }else{
      matchmode := VimSetTitleMatchMode
    }
    GuiControl, % this.Hwnd ":Choose", VimSetTitleMatchMode, % matchmode
    if(VimSetTitleMatchModeFS == "Fast"){
      matchmodefs := 1
    }else{
      matchmodefs := 2
    }
    GuiControl, % this.Hwnd ":Choose", VimSetTitleMatchModeFS, % matchmodefs
    GuiControl, % this.Hwnd ":Choose", VimVerbose, % VimVerbose
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
        display := this.DisplayToolTipObj
        SetTimer, % display, -1000
      }
    }
    Return
  }

  DisplayToolTip(){
    display := this.DisplayToolTipObj
    SetTimer, % display, Off
    ToolTip % this.Vim.Info[this.Vim.State.CurrControl]
    remove := this.RemoveToolTipObj
    SetTimer, % remove, -60000
  }

  RemoveToolTip(){
    display := this.DisplayToolTipObj
    remove := this.RemoveToolTipObj
    SetTimer, % display, Off
    SetTimer, % remove, Off
    ToolTip
  }

  VimV2Conf(){
    global VimRestoreIME, VimJJ, VimJK, VimSD
    global VimDisableUnused, VimSetTitleMatchMode, VimSetTitleMatchModeFS, VimIconCheckInterval, VimVerbose, VimGroup, VimGroupList
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
  }

  VimConf2V(){
    global VimRestoreIME, VimJJ, VimJK, VimSD
    global VimDisableUnused, VimSetTitleMatchMode, VimSetTitleMatchModeFS, VimIconCheckInterval, VimVerbose, VimGroup, VimGroupList
    StringReplace, VimGroupList, % this.Vim.Conf["VimGroup"]["val"], % this.Vim.GroupDel, `n, All
    for k, v in this.Vim.Conf {
      %k% := v["val"]
    }
  }

  VimDefaultConf2V(){
    global VimRestoreIME, VimJJ, VimJK, VimSD
    global VimDisableUnused, VimSetTitleMatchMode, VimSetTitleMatchModeFS, VimIconCheckInterval, VimVerbose, VimGroup, VimGroupList
    StringReplace, VimGroupList, % this.Vim.Conf["VimGroup"]["default"], % this.Vim.GroupDel, `n, All
    for k, v in this.Vim.Conf {
      %k% := v["default"]
    }
  }

  OK(){
    Gui, % this.Hwnd . ":Submit"
    this.VimV2Conf()
    this.Vim.Setup()
    this.vim.Ini.WriteIni()
    this.Hide()
  }
  Cancel(){
    this.Hide()
  }
  Reset(){
    this.VimDefaultConf2V()
    this.UpdateGuiValue()
  }

  OpenHomepage(){
    ToolTip
    Run % this.Homepage
  }
}
