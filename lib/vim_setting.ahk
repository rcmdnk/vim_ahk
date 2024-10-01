#Include %A_LineFile%\..\vim_gui.ahk


class VimSetting Extends VimGui{
  __New(Vim){
    super.__New(Vim, "Vim Ahk Settings")

    this.ResetObj := ObjBindMethod(this, "Reset")
    this.CancelObj := ObjBindMethod(this, "Cancel")
  }

  AddConf(ControlType, Key, Options, Text:="", V:=False){
    if(ControlType == "Text"){
      Text := this.Vim.GetDescription(Key)
    }
    if(V){
      Options := Options " v" Key
    }
    Obj := this.Obj.Add(ControlType, Options, Text)
    if(ControlType == "Text"){
      ; Pseudo click event to show tooltop
      Obj.OnEvent("Click", DoNothing(Obj, Info) => "")
    }
    this.Vim.AddToolTip(Obj.Hwnd, this.Vim.GetInfo(Key))
  }

  MakeGui(){
    this.Obj.Opt("-MinimizeBox -Resize")
    created := 0
    for i, k in this.Vim.Checkboxes {
      if(created == 0){
        y := "YM"
        created := 1
      }else{
        y := "Y+10"
      }
      if(inStr(k, "Long") or inStr(k, "Send")) {
        x := "30"
      }else{
        x := "10"
      }
      this.AddConf("Checkbox", k, "XM+" x " " y, this.Vim.GetDescription(k), True)
      this.Obj[k].Value := this.Vim.GetVal(k)
    }
    this.AddConf("Text", "VimTwoLetter", "XM+10 Y+15")
    this.AddConf("Edit", "VimTwoLetter", "XM+10 Y+5 R4 W100 Multi", StrReplace(this.Vim.GetVal("VimTwoLetter"), this.Vim.GroupDel, "`n", 0, , -1), True)
    this.AddConf("Text", "VimDisableUnused", "XM+10 Y+15")
    this.AddConf("DDL", "VimDisableUnused", "X+5 Y+-16 W30 Choose" this.Vim.GetVal("VimDisableUnused"), [1, 2, 3], True)
    this.AddConf("Text", "VimSetTitleMatchMode", "XM+10 Y+15")
    if(this.Vim.GetVal("VimSetTitleMatchMode") == "RegEx"){
      matchmode := 4
    }else{
      matchmode := this.Vim.GetVal("VimSetTitleMatchMode")
    }
    this.AddConf("DDL","VimSetTitleMatchMode",  "X+5 Y+-16 W60 Choose" matchmode, [1, 2, 3, "RegEx"], True)
    if(this.Vim.GetVal("VimSetTitleMatchModeFS") == "Fast"){
      matchmodefs := 1
    }else{
      matchmodefs := 2
    }
    this.AddConf("DDL", "VimSetTitleMatchModeFS", "X+5 Y+-20 W50 Choose" matchmodefs, ["Fast", "Slow"], True)
    this.AddConf("Text", "VimIconCheckInterval", "XM+10 Y+10")
    this.AddConf("Edit", "VimIconCheckInterval", "X+5 Y+-16 W70")
    this.AddConf("UpDown", "VimIconCheckInterval", "Range0-1000000", this.Vim.GetVal("VimIconCheckInterval"), True)
    this.AddConf("Text", "VimVerbose", "XM+10 Y+10")
    this.AddConf("DDL", "VimVerbose", "X+5 Y+-16 W30 Choose" this.Vim.GetVal("VimVerbose"), [1, 2, 3, 4], True)
    this.AddConf("Text", "VimAppList", "XM+10 Y+10")
    if(this.Vim.GetVal("VimAppList") == "All"){
      matchapplist := 1
    }else if(this.Vim.GetVal("VimAppList") == "Allow List"){
      matchapplist := 2
    }else{
      matchapplist := 3
    }
    this.AddConf("DDL", "VimAppList", "X+5 Y+-16 W100 Choose" matchapplist, ["All", "Allow List", "Deny List"], True)
    this.AddConf("Text", "VimGroup", "XM+10 Y+5")
    this.AddConf("Edit", "VimGroup", "XM+10 Y+5 R10 W300 Multi", StrReplace(this.Vim.GetVal("VimGroup"), this.Vim.GroupDel, "`n", 0, , -1), True)
    this.Obj.AddText("XM+10 Y+10", "Check")
    this.Obj.SetFont("Underline")
    this.AddClick("Text", "X+5 cBlue", "HELP", this.Vim.about.OpenHomepageObj, this.Vim.About.Homepage)
    this.Obj.SetFont("Norm")
    this.Obj.AddText("X+5", "for further information.")

    this.AddClick("Button", "X10 W100 Y+10 Default", "OK", this.OKObj, "Reflect changes and exit")
    this.AddClick("Button", "X+10 W100", "Reset", this.ResetObj, "Reset to the default values")
    this.AddClick("Button", "X+10 W100", "Cancel", this.CancelObj, "Don't change and exit")
  }

  UpdateGui(){
    this.UpdateGuiValue()
  }

  UpdateGuiValue(){
    for i, k in this.Vim.Checkboxes {
      this.Obj[k].Value := this.Vim.GetVal(k)
    }
    this.Obj["VimTwoLetter"].Value := StrReplace(this.Vim.GetVal("VimTwoLetter"), this.Vim.GroupDel, "`n", 0, , -1)
    this.Obj["VimDisableUnused"].Value := this.Vim.GetVal("VimDisableUnused")
    this.Obj["VimIconCheckInterval"].Value := this.Vim.GetVal("VimIconCheckInterval")
    if(this.Vim.GetVal("VimSetTitleMatchMode") == "RegEx"){
      matchmode := 4
    }else{
      matchmode := this.Vim.GetVal("VimSetTitleMatchMode")
    }
    this.Obj["VimSetTitleMatchMode"].Value := matchmode
    if(this.Vim.GetVal("VimSetTitleMatchModeFS") == "Fast"){
      matchmodefs := 1
    }else{
      matchmodefs := 2
    }
    this.Obj["VimSetTitleMatchModeFS"].Value := matchmodefs
    this.Obj["VimVerbose"].Value := this.Vim.GetVal("VimVerbose")
    if(this.Vim.GetVal("VimAppList") == "All"){
      matchapplist := 1
    }else if(this.Vim.GetVal("VimAppList") == "Allow List"){
      matchapplist := 2
    }else{
      matchapplist := 3
    }
    this.Obj["VimAppList"].Value := matchapplist
    this.Obj["VimGroup"].Value := StrReplace(this.Vim.GetVal("VimGroup"), this.Vim.GroupDel, "`n", 0, , -1)
  }

  VimV2Conf(){
    for k, v in this.Vim.Conf {
      if(k == "VimGroup" || k == "VimTwoLetter"){
        v["val"] := this.VimParseList(this.Obj[k].Value)
      }else if(k == "VimSetTitleMatchMode" && this.Obj[k].Value == 4){
        v["val"] := "RegEx"
      }else if(k == "VimSetTitleMatchModeFS"){
        if(this.Obj[k].Value == 1){
          v["val"] := "Fast"
        }else{
          v["val"] := "Slow"
        }
      }else if(k == "VimAppList"){
        if(this.Obj[k].Value == 1){
          v["val"] = "All"
        }else if(this.Obj[k].Value == 2){
          v["val"] = "Allow List"
        }else{
          v["val"] = "Deny List"
        }
      }else{
        v["val"] := this.Obj[k].Value
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

  OK(Obj, Info){
    this.Obj.Submit()
    this.VimV2Conf()
    this.Vim.Setup()
    this.vim.Ini.WriteIni()
    this.Hide(Obj)
  }

  Cancel(Obj, Info){
    this.Hide(Obj)
  }

  Reset(Obj, Info){
    this.Vim.SetConfDefault()
    this.UpdateGuiValue()
  }
}
