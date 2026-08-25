#Include %A_LineFile%\..\vim_gui.ahk
#Include %A_LineFile%\..\vim_setting_application_panel.ahk
#Include %A_LineFile%\..\vim_setting_schema.ahk


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
      ; Pseudo click event to show tooltip
      Obj.OnEvent("Click", DoNothing(Obj, Info) => "")
    }
    this.Vim.AddToolTip(Obj.Hwnd, this.Vim.GetInfo(Key))
  }

  MakeGui(){
    this.Obj.Opt("-Resize -MinimizeBox -MaximizeBox")
    this.Tab := this.Obj.Add("Tab3", "X+0 Y+0 W480 H400", ["Keys", "Applications", "Status", "Configuration file"])

    ; Tab 1: Keys
    this.Tab.UseTab(1)
    this.Obj.AddText("X+0 Y+0 Section", "")
    for i, k in this.Vim.CheckBoxes {
      x := (InStr(k, "Direct") or InStr(k, "Long") or InStr(k, "Send")) ? "30" : "10"
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
    this.ApplicationPanel := VimSettingApplicationPanel(
      this.Obj, this.Vim.Conf, this.Vim.GroupDel
      , ObjBindMethod(this.Vim, "AddToolTip"))

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

  UpdateGuiValue(Values := 0){
    if !(Values is Map) {
      Values := VimSettingSchema.Values(this.Vim.Conf)
    }
    for i, k in this.Vim.CheckBoxes {
      this.Obj[k].Value := Values[k]
    }
    this.Obj["VimTwoLetter"].Value := StrReplace(Values["VimTwoLetter"], this.Vim.GroupDel, "`n", 0, , -1)
    this.Obj["VimDisableUnused"].Value := Values["VimDisableUnused"]
    this.Obj["VimIconCheckInterval"].Value := Values["VimIconCheckInterval"]
    if(Values["VimSetTitleMatchMode"] == "RegEx"){
      matchmode := 4
    }else{
      matchmode := Values["VimSetTitleMatchMode"]
    }
    this.Obj["VimSetTitleMatchMode"].Value := matchmode
    if(Values["VimSetTitleMatchModeFS"] == "Fast"){
      matchmodefs := 1
    }else{
      matchmodefs := 2
    }
    this.Obj["VimSetTitleMatchModeFS"].Value := matchmodefs
    this.Obj["VimVerbose"].Value := Values["VimVerbose"]
    this.ApplicationPanel.LoadValues(Values)
  }

  VimV2Conf(){
    Values := VimSettingSchema.Values(this.Vim.Conf)
    for i, k in this.Vim.CheckBoxes {
      Values[k] := this.Obj[k].Value
    }
    Values["VimTwoLetter"] := this.Obj["VimTwoLetter"].Value
    Values["VimDisableUnused"] := this.Obj["VimDisableUnused"].Text
    Values["VimIconCheckInterval"] := this.Obj["VimIconCheckInterval"].Value
    Values["VimSetTitleMatchMode"] := this.Obj["VimSetTitleMatchMode"].Text
    Values["VimSetTitleMatchModeFS"] := this.Obj["VimSetTitleMatchModeFS"].Text
    Values["VimVerbose"] := this.Obj["VimVerbose"].Text
    this.ApplicationPanel.StoreValues(Values)
    Values := VimSettingSchema.NormalizeValues(
      this.Vim.Conf, Values, this.Vim.GroupDel)
    this.Vim.SetValues(Values)
  }

  OK(Obj, Info){
    try {
      this.Obj.Submit(false)
      this.VimV2Conf()
      this.Vim.Setup()
      this.Vim.Ini.WriteIni()
      this.Hide(Obj)
    } catch as e {
      MsgBox(e.Message, "Vim Ahk", "Iconx")
    }
  }

  Apply(Obj, Info){
    try {
      this.Obj.Submit(false)
      this.VimV2Conf()
      this.Vim.Setup()
      this.Vim.Ini.WriteIni()
      this.Vim.VimToolTip.RemoveToolTip()
    } catch as e {
      MsgBox(e.Message, "Vim Ahk", "Iconx")
    }
  }

  Cancel(Obj, Info){
    this.Hide(Obj)
  }

  Reset(Obj, Info){
    this.UpdateGuiValue(VimSettingSchema.Values(this.Vim.Conf, True))
  }

  ImportIni(Obj, Info){
    try {
      path := FileSelect("", "", "Import INI (staged; Apply to confirm)", "INI (*.ini)")
      if (path == "")
        return
      ; Read selected INI into a temporary conf map without touching runtime conf.
      ; Values are seeded with the defaults because the INI keeps only
      ; non-default values: a missing key means the default value.
      tmpConf := Map()
      for k, v in this.Vim.Conf {
        tmpConf[k] := Map("default", v["default"], "val", v["default"], "description", v["description"], "info", v["info"])
      }
      SplitPath(path, &fileName, &dir)
      tmpVim := {Conf: tmpConf, GroupDel: this.Vim.GroupDel}
      tmpIni := VimIni(tmpVim, dir, fileName)
      tmpIni.ReadIni()

      ; Update GUI controls from tmpConf only
      Values := VimSettingSchema.Values(tmpConf)
      Values := VimSettingSchema.NormalizeValues(
        this.Vim.Conf, Values, this.Vim.GroupDel)
      this.UpdateGuiValue(Values)

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
      this.Vim.Setup()
      this.Vim.Ini.WriteIni()
      FileCopy(this.Vim.Ini.Ini, path, true)
      MsgBox("Exported settings to: `n" path, "Vim Ahk")
    } catch as e {
      MsgBox("Failed to export: " e.Message, "Vim Ahk", "Iconx")
    }
  }
}
