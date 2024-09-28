#Include %A_LineFile%\..\vim_gui.ahk


class VimSetting Extends VimGui{
  __New(Vim){
    super.__New(Vim, "Vim Ahk Settings")

    this.Vim := Vim

    this.OKObj := ObjBindMethod(this, "OK")
    this.ResetObj := ObjBindMethod(this, "Reset")
    this.CancelObj := ObjBindMethod(this, "Cancel")
  }

  MakeGui(){
    this.Hwnd.Opt("-MinimizeBox -Resize")
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
      this.Hwnd.AddCheckbox(k " XM+" x " " y " v" k, this.GetDescription(k))
      this.HwndAll.Push(this.Hwnd[k])
      created  := 1
      this.Hwnd[k].Value := this.GetVal(k)
    }
    this.Hwnd.AddText("XM+10 Y+15 vVimTwoLetterText", this.GetDescription("VimTwoLetter"))
    this.Hwnd.AddEdit("XM+10 Y+5 R4 W100 Multi vVimTwoLetter", StrReplace(this.GetVal("VimTwoLetter"), this.Vim.GroupDel, "`n", 0, , -1))
    this.Hwnd.AddText("XM+10 Y+15 vVimDisableUnusedText", this.GetDescription("VimDisableUnused"))
    this.Hwnd.AddDDL("X+5 Y+-16 W30 vVimDisableUnused Choose" this.GetVal("VimDisableUnused"), [1, 2, 3])
    this.HwndAll.Push(this.Hwnd["VimDisableUnused"])
    this.Hwnd.AddText("XM+10 Y+15 vVimSetTitleMatchModeText", this.GetDescription("VimSetTitleMatchMode"))
    if(this.GetVal("VimSetTitleMatchMode") == "RegEx"){
      matchmode := 4
    }else{
      matchmode := this.GetVal("VimSetTitleMatchMode")
    }
    this.Hwnd.AddDDL("X+5 Y+-16 W60 vVimSetTitleMatchMode Choose" matchmode, [1, 2, 3, "RegEx"])
    this.HwndAll.Push(this.Hwnd["VimSetTitleMatchMode"])
    if(this.GetVal("VimSetTitleMatchModeFS") == "Fast"){
      matchmodefs := 1
    }else{
      matchmodefs := 2
    }
    this.Hwnd.AddDDL("X+5 Y+-20 W50 vVimSetTitleMatchModeFS Choose" matchmodefs, ["Fast", "Slow"])
    this.HwndAll.Push(this.Hwnd["VimSetTitleMatchModeFS"])
    this.Hwnd.AddText("XM+10 Y+10  vVimIconCheckIntervalText", this.GetDescription("VimIconCheckInterval"))
    this.Hwnd.AddEdit("X+5 Y+-16 W70 vVimIconCheckIntervalEdit")
    this.HwndAll.Push(this.Hwnd["VimIconCheckIntervalEdit"])
    this.Hwnd.AddUpDown("vVimIconCheckInterval Range0-1000000", this.GetVal("VimIconCheckInterval"))
    this.HwndAll.Push(this.Hwnd["VimIconCheckInterval"])
    this.Hwnd.AddText("XM+10 Y+10 vVimVerboseText", this.GetDescription("VimVerbose"))
    this.Hwnd.AddDDL("X+5 Y+-16 W30 vVimVerbose Choose" this.GetVal("VimVerbose"), [1, 2, 3, 4])
    this.HwndAll.Push(this.Hwnd["VimVerbose"])
    this.Hwnd.AddText("XM+10 Y+10 vVimAppListText", this.GetDescription("VimAppList"))
    if(this.GetVal("VimAppList") == "All"){
      matchapplist := 1
    }else if(this.GetVal("VimAppList") == "Allow List"){
      matchapplist := 2
    }else{
      matchapplist := 3
    }
    this.Hwnd.AddDDL("X+5 Y+-16 W100 vVimAppList Choose" matchapplist, ["All", "Allow List", "Deny List"])
    this.HwndAll.Push(this.Hwnd["VimAppList"])
    this.Hwnd.AddText("XM+10 Y+5 vVimGroupText", this.GetDescription("VimGroup"))
    this.Hwnd.AddEdit("XM+10 Y+5 R10 W300 Multi vVimGroup", StrReplace(this.GetVal("VimGroup"), this.Vim.GroupDel, "`n", 0, , -1))
    this.HwndAll.Push(this.Hwnd["VimGroup"])
    this.Hwnd.AddText("XM+10 Y+10", "Check")
    this.Hwnd.SetFont("Underline")
    this.Hwnd.AddText("X+5 cBlue vVimHomepage", "HELP").OnEvent("Click", this.Vim.about.OpenHomepageObj)
    this.Hwnd.SetFont("Norm")
    this.Hwnd.AddText("X+5", "for further information.")

    this.Hwnd.AddButton("vVimSettingOK X10 W100 Y+10 Default", "OK").OnEvent("Click", this.OKObj)
    this.HwndAll.Push(this.Hwnd["VimSettingOK"])

    this.Hwnd.AddButton("vVimSettingReset W100 X+10", "Reset").OnEvent("Click", this.ResetObj)
    this.HwndAll.Push(this.Hwnd["VimSettingReset"])

    this.Hwnd.AddButton("vVimSettingCancel W100 X+10", "Cancel").OnEvent("Click", this.CancelObj)
    this.HwndAll.Push(this.Hwnd["VimSettingCancel"])
  }

  UpdateGui(){
    this.UpdateGuiValue()
  }

  UpdateGuiValue(){
    for i, k in this.Vim.Checkboxes {
      this.Hwnd[k].Value := this.GetVal(k)
    }
    this.Hwnd["VimTwoLetter"].Value := StrReplace(this.GetVal("VimTwoLetter"), this.Vim.GroupDel, "`n", 0, , -1)
    this.Hwnd["VimDisableUnused"].Value := this.GetVal("VimDisableUnused")
    this.Hwnd["VimIconCheckInterval"].Value := this.GetVal("VimIconCheckInterval")
    if(this.GetVal("VimSetTitleMatchMode") == "RegEx"){
      matchmode := 4
    }else{
      matchmode := this.GetVal("VimSetTitleMatchMode")
    }
    this.Hwnd["VimSetTitleMatchMode"].Value := matchmode
    if(this.GetVal("VimSetTitleMatchModeFS") == "Fast"){
      matchmodefs := 1
    }else{
      matchmodefs := 2
    }
    this.Hwnd["VimSetTitleMatchModeFS"].Value := matchmodefs
    this.Hwnd["VimVerbose"].Value := this.GetVal("VimVerbose")
    if(this.GetVal("VimAppList") == "All"){
      matchapplist := 1
    }else if(this.GetVal("VimAppList") == "Allow List"){
      matchapplist := 2
    }else{
      matchapplist := 3
    }
    this.Hwnd["VimAppList"].Value := matchapplist
    this.Hwnd["VimGroup"].Value := StrReplace(this.GetVal("VimGroup"), this.Vim.GroupDel, "`n", 0, , -1)
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

  VimParseList(List){
    result := ""
    tmpArray := []
    Loop Parse, List, "`n" {
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

  GetConf(Name, Key){
    return this.Vim.Conf[Name][Key]
  }

  GetVal(Name){
    return this.GetConf(Name, "val")
  }

  GetDefault(Name){
    return this.GetConf(Name, "default")
  }

  GetDescription(name){
    return this.GetConf(Name, "description")
  }

  OK(*){
    this.Hwnd.Submit()
    this.VimV2Conf()
    this.Vim.Setup()
    this.vim.Ini.WriteIni()
    this.Hide()
  }

  Cancel(*){
    this.Hide()
  }

  Reset(*){
    this.VimDefault2V()
    this.UpdateGuiValue()
  }
}
