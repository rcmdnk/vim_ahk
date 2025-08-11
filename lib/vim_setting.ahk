#Include %A_LineFile%\..\vim_gui.ahk


class VimSetting Extends VimGui{
  __New(Vim){
    super.__New(Vim, "Vim Ahk Settings")

    this.ResetObj := ObjBindMethod(this, "Reset")
    this.CancelObj := ObjBindMethod(this, "Cancel")
    this.ApplyObj := ObjBindMethod(this, "Apply")
    this.ImportObj := ObjBindMethod(this, "ImportIni")
    this.ExportObj := ObjBindMethod(this, "ExportIni")
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
    this.Obj.Opt("-Resize -MinimizeBox -MaximizeBox")
    this.Tab := this.Obj.Add("Tab3", "X+0 Y+0 W480 H360", ["Keys", "Applications", "Status", "Configuration file"])

    ; Tab 1: Keys
    this.Tab.UseTab(1)
    this.Obj.AddText("X+0 Y+0 Section", "")
    for i, k in this.Vim.Checkboxes {
      x := (inStr(k, "Long") or inStr(k, "Send")) ? "30" : "10"
      this.AddConf("Checkbox", k, "XS+" x " Y+6", this.Vim.GetDescription(k), True)
      this.Obj[k].Value := this.Vim.GetVal(k)
    }
    this.AddConf("Text", "VimTwoLetter", "XS+10 Y+15")
    this.AddConf("Edit", "VimTwoLetter", "XS+10 Y+5 R4 W100 Multi", StrReplace(this.Vim.GetVal("VimTwoLetter"), this.Vim.GroupDel, "`n", 0, , -1), True)
    this.AddConf("Text", "VimDisableUnused", "XS+10 Y+15")
    this.AddConf("DDL", "VimDisableUnused", "X+5 YP-4 W40 Choose" this.Vim.GetVal("VimDisableUnused"), [1, 2, 3], True)

    ; Tab 2: Applications (Merged with Matching & Lists)
    this.Tab.UseTab(2)
    this.Obj.AddText("X+0 Y+0 Section", "")
    ; (Disabled unused keys moved to Keys tab)
    this.AddConf("Text", "VimSetTitleMatchMode", "XS+10 Y+10")
    if(this.Vim.GetVal("VimSetTitleMatchMode") == "RegEx"){
      matchmode := 4
    }else{
      matchmode := this.Vim.GetVal("VimSetTitleMatchMode")
    }
    this.AddConf("DDL","VimSetTitleMatchMode",  "X+5 YP-4 W60 Choose" matchmode, [1, 2, 3, "RegEx"], True)
    if(this.Vim.GetVal("VimSetTitleMatchModeFS") == "Fast"){
      matchmodefs := 1
    }else{
      matchmodefs := 2
    }
    this.AddConf("DDL", "VimSetTitleMatchModeFS", "X+5 YP+0 W50 Choose" matchmodefs, ["Fast", "Slow"], True)

    ; Applications specific
    this.AddConf("Text", "VimAppList", "XS+10 Y+15")
    if(this.Vim.GetVal("VimAppList") == "All"){
      matchapplist := 1
    }else if(this.Vim.GetVal("VimAppList") == "Allow List"){
      matchapplist := 2
    }else{
      matchapplist := 3
    }
    this.AddConf("DDL", "VimAppList", "X+5 YP-4 W100 Choose" matchapplist, ["All", "Allow List", "Deny List"], True)
    this.AddConf("Text", "VimGroup", "XS+10 Y+5")
    this.AddConf("Edit", "VimGroup", "XS+10 Y+5 R10 W300 Multi", StrReplace(this.Vim.GetVal("VimGroup"), this.Vim.GroupDel, "`n", 0, , -1), True)

    ; Tab 3: Status
    this.Tab.UseTab(3)
    this.Obj.AddText("X+0 Y+0 Section", "")
    this.AddConf("Text", "VimIconCheckInterval", "XS+10 Y+10")
    this.AddConf("Edit", "VimIconCheckInterval", "X+5 YP-4 W70")
    this.AddConf("UpDown", "VimIconCheckInterval", "Range0-1000000", this.Vim.GetVal("VimIconCheckInterval"), True)
    this.AddConf("Text", "VimVerbose", "XS+10 Y+10")
    this.AddConf("DDL", "VimVerbose", "X+5 YP-4 W30 Choose" this.Vim.GetVal("VimVerbose"), [1, 2, 3, 4], True)

    ; Tab 4: Configuration file
    this.Tab.UseTab(4)
    this.Obj.AddText("X+0 Y+0 Section", "")
    SplitPath(this.Vim.Ini.Ini, &fileName, &iniDir)
    this.Obj.AddText("XS+10 Y+10", "Current configuration directory:")
    this.AddClick("Text", "XS+10 cBlue", iniDir, this.Vim.Ini.OpenIniDirObj)
    this.Obj.AddText("XS+10 Y+10", "Current configuration file:")
    this.AddClick("Text", "XS+10 cBlue", fileName, this.Vim.Ini.OpenIniObj)
    this.AddClick("Button", "XS+10 Y+10 W120", "Import", this.ImportObj, "Load settings from an INI file")
    this.AddClick("Button", "X+10 W120", "Export", this.ExportObj, "Save current settings to an INI file")

    ; End tabs; add help and buttons below the tab
    this.Tab.UseTab()

    ; Add contents below the tab
    this.Tab.GetPos(&tabX, &tabY, &tabW, &tabH)
    underTab := tabY + tabH + 10

    ;; Create help controls and measure
    this.Obj.AddText("X15 Y" underTab, "Check")
    this.Obj.SetFont("Underline")
    this.AddClick("Text", "X+5 cBlue", "HELP", this.Vim.about.OpenHomepageObj, this.Vim.About.Homepage)
    this.Obj.SetFont("Norm")
    this.Obj.AddText("X+5", "for further information.")

    this.AddClick("Button", "X15 W100 Y+10 Default", "OK", this.OKObj, "Apply changes and close")
    this.AddClick("Button", "X+10 W100", "Apply", this.ApplyObj, "Apply changes without closing")
    this.AddClick("Button", "X+10 W100", "Reset", this.ResetObj, "Reset to the default values")
    this.AddClick("Button", "X+10 W100", "Cancel", this.CancelObj, "Discard changes and close")
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
    this.Vim.Ini.WriteIni()
    this.Hide(Obj)
  }

  Apply(Obj, Info){
    this.Obj.Submit(false)
    this.VimV2Conf()
    this.Vim.Setup()
    this.Vim.Ini.WriteIni()
    this.Vim.VimToolTip.RemoveToolTip()
  }

  Cancel(Obj, Info){
    this.Hide(Obj)
  }

  Reset(Obj, Info){
    this.Vim.SetConfDefault()
    this.UpdateGuiValue()
  }

  ImportIni(Obj, Info){
    try {
      path := FileSelect("", "", "Import INI (staged; Apply to confirm)", "INI (*.ini)")
      if (path == "")
        return
      ; Read selected INI into a temporary conf map without touching runtime conf
      tmpConf := Map()
      for k, v in this.Vim.Conf {
        tmpConf[k] := Map("default", v["default"], "val", v["val"], "description", v["description"], "info", v["info"])
      }
      SplitPath(path, &fileName, &dir)
      tmpIni := VimIni(this.Vim, dir, fileName)
      tmpIni.ReadIni()

      ; Update GUI controls from tmpConf only
      ; Checkboxes
      for i, k in this.Vim.Checkboxes {
        if this.Obj.HasProp(k) && tmpConf.Has(k)
          this.Obj[k].Value := tmpConf[k]["val"]
      }
      ; Text/DDL fields with conversions
      if this.Obj.HasProp("VimTwoLetter")
        this.Obj["VimTwoLetter"].Value := StrReplace(tmpConf["VimTwoLetter"]["val"], this.Vim.GroupDel, "`n", 0, , -1)
      if this.Obj.HasProp("VimDisableUnused")
        this.Obj["VimDisableUnused"].Value := tmpConf["VimDisableUnused"]["val"]
      if this.Obj.HasProp("VimIconCheckInterval")
        this.Obj["VimIconCheckInterval"].Value := tmpConf["VimIconCheckInterval"]["val"]
      ; Title match mode
      if this.Obj.HasProp("VimSetTitleMatchMode") {
        matchmode := tmpConf["VimSetTitleMatchMode"]["val"]
        this.Obj["VimSetTitleMatchMode"].Value := (matchmode == "RegEx") ? 4 : matchmode
      }
      if this.Obj.HasProp("VimSetTitleMatchModeFS") {
        matchmodefs := tmpConf["VimSetTitleMatchModeFS"]["val"]
        this.Obj["VimSetTitleMatchModeFS"].Value := (matchmodefs == "Fast") ? 1 : 2
      }
      if this.Obj.HasProp("VimVerbose")
        this.Obj["VimVerbose"].Value := tmpConf["VimVerbose"]["val"]
      if this.Obj.HasProp("VimAppList") {
        ap := tmpConf["VimAppList"]["val"]
        this.Obj["VimAppList"].Value := (ap == "All") ? 1 : (ap == "Allow List") ? 2 : 3
      }
      if this.Obj.HasProp("VimGroup")
        this.Obj["VimGroup"].Value := StrReplace(tmpConf["VimGroup"]["val"], this.Vim.GroupDel, "`n", 0, , -1)

      ; Do not write to the main INI nor apply runtime yet — waits for Apply
      MsgBox("Imported settings staged from:`n" path "`nClick Apply to apply them.", "Vim Ahk")
    } catch as e {
      MsgBox("Failed to import: " e.Message, "Vim Ahk", "Iconx")
    }
  }

  ExportIni(Obj, Info){
    try {
      path := FileSelect("S", "", "Export INI", "INI (*.ini)")
      if (path == "")
        return
      ; Ensure current settings are saved before export
      this.Obj.Submit(false)
      this.VimV2Conf()
      this.Vim.Ini.WriteIni()
      FileCopy(this.Vim.Ini.Ini, path, true)
      MsgBox("Exported settings to: `n" path, "Vim Ahk")
    } catch as e {
      MsgBox("Failed to export: " e.Message, "Vim Ahk", "Iconx")
    }
  }
}
