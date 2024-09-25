class VimSetting Extends VimGui{
  __New(vim){
    this.Vim := vim
    super.__New(vim, "Vim Ahk Settings")
  }

  MakeGui(){
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
      if(inStr(k, "Long") or inStr(k, "Send")) {
        x := "30"
      }else{
        x := "10"
      }
      Gui, % this.Hwnd ":Add", Checkbox, % "+HwndHwnd" k " XM+" x " " y " v" k, % this.Vim.Conf[k]["description"]
      hwnd := "Hwnd" k
      this.HwndAll.Push(%hwnd%)
      created  := 1
      GuiControl, % this.Hwnd ":", % k, % %k%
    }
    Gui, % this.Hwnd ":Add", Text, % "XM+10 Y+15 g" this.__Class ".TwoLetterText vVimTwoLetterText", % this.Vim.Conf["VimTwoLetter"]["description"]
    Gui, % this.Hwnd ":Add", Edit, XM+10 Y+5 R4 W100 Multi vVimTwoLetterList, % StrReplace(this.GetVal("VimTwoLetter"), this.Vim.GroupDel, "`n", 0, , -1)
    Gui, % this.Hwnd ":Add", Text, % "XM+10 Y+15 g" this.__Class ".DisableUnusedText vVimDisableUnusedText", % this.Vim.Conf["VimDisableUnused"]["description"]
    Gui, % this.Hwnd ":Add", DropDownList, % "+HwndHwndDisableUnused X+5 Y+-16 W30 vVimDisableUnused Choose" this.GetVal("VimDisableUnused"), 1|2|3
    this.HwndAll.Push(HwndDisableUnused)
    Gui, % this.Hwnd ":Add", Text, % "XM+10 Y+15 g" this.__Class ".SetTitleMatchModeText vVimSetTitleMatchModeText", % this.Vim.Conf["VimSetTitleMatchMode"]["description"]
    if(this.GetVal("VimSetTitleMatchMode") == "RegEx"){
      matchmode := 4
    }else{
      matchmode := this.GetVal("VimSetTitleMatchMode")
    }
    Gui, % this.Hwnd ":Add", DropDownList, % "+HwndHwndSetTitleMachMode X+5 Y+-16 W60 vVimSetTitleMatchMode Choose" matchmode, 1|2|3|RegEx
    this.HwndAll.Push(HwndSetTitleMachMode)
    if(this.GetVal("VimSetTitleMatchModeFS") == "Fast"){
      matchmodefs := 1
    }else{
      matchmodefs := 2
    }
    Gui, % this.Hwnd ":Add", DropDownList, % "+HwndHwndSetTitleMachModeFS X+5 Y+-20 W50 vVimSetTitleMatchModeFS Choose" matchmodefs, Fast|Slow
    this.HwndAll.Push(HwndSetTitleMachModeFS)
    Gui, % this.Hwnd ":Add", Text, % "XM+10 Y+10 g" this.__Class ".IconCheckIntervalText vVimIconCheckIntervalText", % this.Vim.Conf["VimIconCheckInterval"]["description"]
    Gui, % this.Hwnd ":Add", Edit, +HwndHwndIconCheckIntervalEdit X+5 Y+-16 W70 vVimIconCheckIntervalEdit
    this.HwndAll.Push(HwndIconCheckIntervalEdit)
    Gui, % this.Hwnd ":Add", UpDown, +HwndHwndIconCheckInterval vVimIconCheckInterval Range0-1000000, % this.GetVal("VimIconCheckInterval")
    this.HwndAll.Push(HwndIconCheckInterval)
    Gui, % this.Hwnd ":Add", Text, % "XM+10 Y+10 g" this.__Class ".VerboseText vVimVerboseText", % this.Vim.Conf["VimVerbose"]["description"]
    Gui, % this.Hwnd ":Add", DropDownList, % "+HwndHwndVerbose X+5 Y+-16 W30 vVimVerbose Choose"this.GetVal("VimVerbose"), 1|2|3|4
    Gui, % this.Hwnd ":Add", Text, % "XM+10 Y+10 g" this.__Class ".AppListText vVimAppListText", % this.Vim.Conf["VimAppList"]["description"]
    Gui, % this.Hwnd ":Add", DropDownList, % "+HwndHwndAppList X+5 Y+-16 W100 vVimAppList Choose"this.GetVal("VimAppList"), All|Allow List|Deny List
    this.HwndAll.Push(HwndVerbose)
    Gui, % this.Hwnd ":Add", Text, % "XM+10 Y+5 g" this.__Class ".GroupText vVimGroupText", % this.Vim.Conf["VimGroup"]["description"]
    Gui, % this.Hwnd ":Add", Edit, +HwndHwndGroupList XM+10 Y+5 R10 W300 Multi vVimGroupList, % StrReplace(this.GetVal("VimGroup"), this.Vim.GroupDel, "`n", 0, , -1)
    this.HwndAll.Push(HwndGroupList)
    Gui, % this.Hwnd ":Add", Text, XM+10 Y+10, Check
    Gui, % this.Hwnd ":Font", Underline
    Gui, % this.Hwnd ":Add", Text, X+5 cBlue vVimHomepage, HELP
    homepage := ObjBindMethod(this.Vim.About, "OpenHomepage")
    GuiControl, +G, VimHomepage, % homepage
    Gui, % this.Hwnd ":Font", Norm
    Gui, % this.Hwnd ":Add", Text, X+5, for further information.

    Gui, % this.Hwnd ":Add", Button, +HwndHwndOK vVimSettingOK X10 W100 Y+10 Default, &OK
    this.HwndAll.Push(HwndOK)
    ok := ObjBindMethod(this, "OK")
    GuiControl, +G, VimSettingOK, % ok

    Gui, % this.Hwnd ":Add", Button, +HwndHwndReset vVimSettingReset W100 X+10, &Reset
    this.HwndAll.Push(HwndReset)
    reset := ObjBindMethod(this, "Reset")
    GuiControl, +G, VimSettingReset, % reset

    Gui, % this.Hwnd ":Add", Button, +HwndHwndCancel vVimSettingCancel W100 X+10, &Cancel
    this.HwndAll.Push(HwndCancel)
    cancel := ObjBindMethod(this, "Cancel")
    GuiControl, +G, VimSettingCancel, % cancel
  }

  UpdateGui(){
    this.UpdateGuiValue()
  }

  UpdateGuiValue(){
    for i, k in this.Vim.Checkboxes {
      GuiControl, % this.Hwnd ":", % k, % this.GetVal(k)
    }
    GuiControl, % this.Hwnd ":", VimTwoLetterList, % StrReplace(this.GetVal("VimTwoLetter"), this.Vim.GroupDel, "`n", 0, , -1)
    GuiControl, % this.Hwnd ":Choose", VimDisableUnused, % this.GetVal("VimDisableUnused")
    GuiControl, % this.Hwnd ":", VimIconCheckInterval, % this.GetVal("VimIconCheckInterval")
    if(this.GetVal("VimSetTitleMatchMode") == "RegEx"){
      matchmode := 4
    }else{
      matchmode := this.GetVal("VimSetTitleMatchMode")
    }
    GuiControl, % this.Hwnd ":Choose", VimSetTitleMatchMode, % matchmode
    if(this.GetVal("VimSetTitleMatchModeFS") == "Fast"){
      matchmodefs := 1
    }else{
      matchmodefs := 2
    }
    GuiControl, % this.Hwnd ":Choose", VimSetTitleMatchModeFS, % matchmodefs
    GuiControl, % this.Hwnd ":Choose", VimVerbose, this.GetVal("VimVerbose")
    GuiControl, % this.Hwnd ":Choose", VimAppList, this.GetVal("VimAppList")
    GuiControl, % this.Hwnd ":", VimGroupList, this.GetVal("VimGroupList")
  }

  ; Dummy Labels, to enable tooltip over the text
  DisableUnusedText(){
  }

  TwoLetterText(){
  }

  SetTitleMatchModeText(){
  }

  IconCheckIntervalText(){
  }

  VerboseText(){
  }

  AppListText(){
  }

  GroupText(){
  }

  VimV2Conf(){
    for k, v in this.Vim.Conf {
      if(k == "VimGroup" || k == "VimTwoLetter"){
        v["val"] := this.VimParseList(this.Hwnd[k].Value)
      }else if(k == "VimSetTitleMatchMode" && this.Hwnd[k].Value == 4){
        v["val"] := "RegEx"
      }else if(k == "VimSetTitleMatchModeFS"){
        if(this.Hwnd[k].Value == 1){
          v["val"] := "Fast"
        }else{
          v["val"] := "Slow"
        }
      }else if(k == "VimAppList"){
        if(this.Hwnd[k].Value == 1){
          v["val"] = "All"
        }else if(this.Hwnd[k].Value == 2){
          v["val"] = "Allow List"
        }else{
          v["val"] = "Deny List"
        }
      }else{
        v["val"] := this.Hwnd[k].Value
      }
    }
  }

  VimParseList(list){
    result := ""
    tmpArray := []
    Loop Parse, list, "`n" {
      if(! tmpArray.Has(A_LoopField)){
        tmpArray.push(A_LoopField)
        if(result == ""){
          result := A_LoopField
        }else{
          result := result this.Vim.GroupDel A_LoopField
        }
      }
    }
    return result
  }

  VimDefault2V(){
    for k, v in this.Vim.Conf {
      v["val"] := v["default"]
    }
  }

  GetConf(name, key){
    return this.Vim.Conf[name][key]
  }

  GetVal(name){
    return this.GetConf(name, "val")
  }

  GetDefault(name){
    return this.GetConf(name, "default")
  }

  GetDescription(name){
    return this.GetConf(name, "description")
  }

  OK(){
    Gui, % this.Hwnd ":Submit"
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
}
