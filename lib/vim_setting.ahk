#Include %A_LineFile%\..\vim_gui.ahk
#Include %A_LineFile%\..\vim_ini.ahk
#Include %A_LineFile%\..\vim_setting_panel.ahk


class VimSetting Extends VimGui {
  __New(Vim) {
    super.__New(Vim, "Vim Ahk Settings")

    this.ResetObj := ObjBindMethod(this, "Reset")
    this.CancelObj := ObjBindMethod(this, "Cancel")
    this.ApplyObj := ObjBindMethod(this, "Apply")
    this.ImportObj := ObjBindMethod(this, "ImportIni")
    this.ExportObj := ObjBindMethod(this, "ExportIni")
  }

  MakeGui() {
    this.Obj.Opt("-Resize -MinimizeBox -MaximizeBox")
    this.Tab := this.Obj.Add("Tab3", "X+0 Y+0 W480 H400"
      , ["Keys", "Applications", "Status", "Configuration file"])
    this.Panel := VimSettingPanel(
      this.Obj, this.Tab, this.Vim.Conf, this.Vim.GroupDel)
    this.MakeConfigurationTab()
    this.MakeFooter()
  }

  MakeConfigurationTab() {
    this.Tab.UseTab(4)
    this.Obj.Add("Text", "X+0 Y+0 Section", "")
    this.ConfigLabel := this.Obj.Add(
      "Text", "XS+10 Y+10", "Current configuration file:")
    this.ConfigPath := this.Obj.Add(
      "Edit", "XS+10 Y+5 W430 ReadOnly", this.Vim.Ini.Ini)
    this.OpenFolderButton := this.AddClick(
      "Button", "XS+10 Y+12 W100", "Open folder"
      , this.Vim.Ini.OpenIniDirObj, "Open the current configuration directory")
    this.ImportButton := this.AddClick(
      "Button", "X+10 W100", "Import", this.ImportObj
      , "Load settings from an INI file")
    this.ExportButton := this.AddClick(
      "Button", "X+10 W100", "Export", this.ExportObj
      , "Save current settings to an INI file")
    this.Tab.UseTab()
  }

  MakeFooter() {
    this.Tab.GetPos(&TabX, &TabY, &TabWidth, &TabHeight)
    FooterY := TabY + TabHeight + 10
    ButtonWidth := 100
    ButtonGap := 10
    this.OKButton := this.AddClick(
      "Button", "X" TabX " Y" FooterY " W" ButtonWidth " Default"
      , "OK", this.OKObj, "Apply changes and close")
    this.ApplyButton := this.AddClick(
      "Button", "X+" ButtonGap " W" ButtonWidth
      , "Apply", this.ApplyObj, "Apply changes")
    this.ResetButton := this.AddClick(
      "Button", "X+" ButtonGap " W" ButtonWidth
      , "Reset", this.ResetObj, "Show default values")
    this.CancelButton := this.AddClick(
      "Button", "X+" ButtonGap " W" ButtonWidth
      , "Cancel", this.CancelObj, "Discard staged changes and close")
  }

  UpdateGui() {
    this.Panel.LoadValues(VimSettingSchema.Values(this.Vim.Conf))
    this.ConfigPath.Text := this.Vim.Ini.Ini
  }

  StoreValues() {
    Values := this.Panel.NormalizedValues()
    this.Vim.SetValues(Values)
    this.Vim.Ini.WriteIni()
  }

  ActivateValues(CloseWindow) {
    if CloseWindow {
      this.Hide()
    }
    this.Vim.Setup()
    this.Vim.VimToolTip.RemoveToolTip()
  }

  OK(Obj, Info) {
    try {
      this.StoreValues()
      this.ActivateValues(True)
    } catch as ErrorInfo {
      MsgBox(ErrorInfo.Message, "Vim Ahk", "Iconx")
    }
  }

  Apply(Obj, Info) {
    try {
      this.StoreValues()
      this.ActivateValues(False)
    } catch as ErrorInfo {
      MsgBox(ErrorInfo.Message, "Vim Ahk", "Iconx")
    }
  }

  Cancel(Obj, Info) {
    this.Hide(Obj)
  }

  Reset(Obj, Info) {
    this.Panel.LoadDefaults()
  }

  ImportIni(Obj, Info) {
    try {
      Path := FileSelect("", "", "Import INI (staged; Apply to confirm)", "INI (*.ini)")
      if (Path == "") {
        return
      }
      TempConf := VimSettingSchema.Copy(this.Vim.Conf)
      SplitPath(Path, &FileName, &Directory)
      TempVim := {Conf: TempConf, GroupDel: this.Vim.GroupDel}
      VimIni(TempVim, Directory, FileName).ReadIni()
      this.Panel.LoadValues(VimSettingSchema.Values(TempConf))
      MsgBox("Imported settings staged from:`n" Path "`nClick Apply to apply them.", "Vim Ahk")
    } catch as ErrorInfo {
      MsgBox("Failed to import: " ErrorInfo.Message, "Vim Ahk", "Iconx")
    }
  }

  ExportIni(Obj, Info) {
    try {
      Path := FileSelect("S", "", "Export INI", "INI (*.ini)")
      if (Path == "") {
        return
      }
      this.StoreValues()
      FileCopy(this.Vim.Ini.Ini, Path, True)
      MsgBox("Exported settings to:`n" Path, "Vim Ahk")
      this.ActivateValues(False)
    } catch as ErrorInfo {
      MsgBox("Failed to export: " ErrorInfo.Message, "Vim Ahk", "Iconx")
    }
  }
}
