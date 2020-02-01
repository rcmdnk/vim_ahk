class VimSetting Extends VimGui{
  __New(vim){
    this.Vim := vim
    base.__New("Vim Ahk Settings")
    this.DisplayToolTipObj := ObjBindMethod(this, "DisplayToolTip")
    this.RemoveToolTipObj := ObjBindMethod(this, "RemoveToolTip")

    this.Vim.DisplayToolTipObjs.Push(this.DisplayToolTipObj)
  }

  MakeGui(){
    global VimRestoreIME, VimJJ, VimJK, VimSD
    global VimDisableUnused, VimSetTitleMatchMode, VimSetTitleMatchModeFS, VimIconCheckInterval, VimVerbose, VimGroup, VimGroupList, VimTwoLetterEscList
    global VimDisableUnusedText, VimSetTitleMatchModeText, VimIconCheckIntervalText, VimIconCheckIntervalEdit, VimVerboseText, VimGroupText, VimHomepage, VimGuiOK, VimGuiReset, VimGuiCancel, VimTwoLetterEscText
    this.VimVal2V()
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
      kk := %k%
      GuiControl, % this.Hwnd ":", % k, % kk
    }
    Gui, % this.Hwnd ":Add", Text, % "XM+10 Y+5 g" this.__Class ".TwoLetterEscText vVimTwoLetterEscText", % this.Vim.Conf["VimTwoLetterEsc"]["description"]
    Gui, % this.Hwnd ":Add", Edit, XM+10 Y+5 R4 W100 Multi vVimTwoLetterEscList, % VimTwoLetterEscList
    Gui, % this.Hwnd ":Add", Text, % "XM+10 Y+15 g" this.__Class ".DisableUnusedText vVimDisableUnusedText", % this.Vim.Conf["VimDisableUnused"]["description"]
    Gui, % this.Hwnd ":Add", DropDownList, % "X+5 Y+-16 W30 vVimDisableUnused Choose" VimDisableUnused, 1|2|3
    Gui, % this.Hwnd ":Add", Text, % "XM+10 Y+15 g" this.__Class ".SetTitleMatchModeText vVimSetTitleMatchModeText", % this.Vim.Conf["VimSetTitleMatchMode"]["description"]
    if(VimSetTitleMatchMode == "RegEx"){
      matchmode := 4
    }else{
      matchmode := %VimSetTitleMatchMode%
    }
    Gui, % this.Hwnd ":Add", DropDownList, % "X+5 Y+-16 W60 vVimSetTitleMatchMode Choose" matchmode, 1|2|3|RegEx
    if(VimSetTitleMatchModeFS == "Fast"){
      matchmodefs := 1
    }else{
      matchmodefs := 2
    }
    Gui, % this.Hwnd ":Add", DropDownList, % "X+5 Y+-20 W50 vVimSetTitleMatchModeFS Choose" matchmodefs, Fast|Slow
    Gui, % this.Hwnd ":Add", Text, % "XM+10 Y+10 g" this.__Class ".IconCheckIntervalText vVimIconCheckIntervalText", % this.Vim.Conf["VimIconCheckInterval"]["description"]
    Gui, % this.Hwnd ":Add", Edit, X+5 Y+-16 W70 vVimIconCheckIntervalEdit
    Gui, % this.Hwnd ":Add", UpDown, vVimIconCheckInterval Range0-1000000, % VimIconCheckInterval
    Gui, % this.Hwnd ":Add", Text, % "XM+10 Y+10 g" this.__Class ".VerboseText vVimVerboseText", % this.Vim.Conf["VimVerbose"]["description"]
    Gui, % this.Hwnd ":Add", DropDownList, % "X+5 Y+-16 W30 vVimVerbose Choose"VimVerbose, 1|2|3|4
    Gui, % this.Hwnd ":Add", Text, % "XM+10 Y+5 g" this.__Class ".GroupText vVimGroupText", % this.Vim.Conf["VimGroup"]["description"]
    Gui, % this.Hwnd ":Add", Edit, XM+10 Y+5 R10 W300 Multi vVimGroupList, % VimGroupList
    Gui, % this.Hwnd ":Add", Text, XM+10 Y+10, Check
    Gui, % this.Hwnd ":Font", Underline
    Gui, % this.Hwnd ":Add", Text, +HwndHomepageHwnd X+5 cBlue vVimHomepage, HELP
    homepage := ObjBindMethod(this.Vim.About, "OpenHomepage")
    GuiControl, +G, % HomepageHwnd, % homepage
    Gui, % this.Hwnd ":Font", Norm
    Gui, % this.Hwnd ":Add", Text, X+5, for further information.

    Gui, % this.Hwnd ":Add", Button, +HwndOKHwnd vVimGuiOK X10 W100 Y+10 Default, &OK
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
    this.VimVal2V()
    this.UpdateGuiValue()
  }

  UpdateGuiValue(){
    global VimRestoreIME, VimJJ, VimJK, VimSD
    global VimDisableUnused, VimSetTitleMatchMode, VimSetTitleMatchModeFS, VimIconCheckInterval, VimVerbose, VimGroup, VimGroupList, VimTwoLetterEsc, VimTwoLetterEscList
    for i, k in this.Vim.Checkboxes {
      kk := %k%
      GuiControl, % this.Hwnd ":", % k, % kk
    }
    GuiControl, % this.Hwnd ":", VimTwoLetterEscList, % VimTwoLetterEscList
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

  TwoLetterEscText(){
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
      this.Vim.RemoveToolTip()
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
    this.Vim.SetRemoveToolTip(60000)
  }

  ; Converts variable to config text/entry?
  VimV2Conf(){
    global VimRestoreIME, VimJJ, VimJK, VimSD
    global VimDisableUnused, VimSetTitleMatchMode, VimSetTitleMatchModeFS, VimIconCheckInterval, VimVerbose, VimGroup, VimGroupList, VimTwoLetterEsc, VimTwoLetterEscList
    VimGroup := this.VimParseList(VimGroupList)
    VimTwoLetterEsc := this.VimParseList(VimTwoLetterEscList)
    for k, v in this.Vim.Conf {
      v["val"] := %k%
    }
  }

  VimParseList(list){
    result := ""
    tmpArray := []
    Loop, Parse, list, `n
    {
      if(! tmpArray.Haskey(A_LoopField)){
        tmpArray.push(A_LoopField)
        if(result == ""){
          result := A_LoopField
        }else{
          result := result . this.Vim.GroupDel . A_LoopField
        }
      }
    }
    return result
  }

  ; Converts config elements to a variable?
  VimConf2V(vd){
    global VimRestoreIME, VimJJ
    global VimDisableUnused, VimSetTitleMatchMode, VimSetTitleMatchModeFS, VimIconCheckInterval, VimVerbose, VimGroup, VimGroupList, VimTwoLetterEscList
    StringReplace, VimGroupList, % this.Vim.Conf["VimGroup"][vd], % this.Vim.GroupDel, `n, All
    StringReplace, VimTwoLetterEscList, % this.Vim.Conf["VimTwoLetterEsc"][vd], % this.Vim.GroupDel, `n, All
    for k, v in this.Vim.Conf {
      %k% := v[vd]
    }
  }

  VimVal2V(){
    this.vimConf2V("val")
  }

  VimDefault2V(){
    this.vimConf2V("default")
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
    this.VimDefault2V()
    this.UpdateGuiValue()
  }

  OpenHomepage(){
    ToolTip
    Run % this.Homepage
  }
}
