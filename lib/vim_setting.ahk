#Include %A_LineFile%\..\vim_gui.ahk
#Include %A_LineFile%\..\vim_ini.ahk
#Include %A_LineFile%\..\vim_setting_panel.ahk


class VimSetting Extends VimGui {
  static NarrowWidth := 680

  __New(Vim) {
    super.__New(Vim, "Vim Ahk Settings")

    this.ResetObj := ObjBindMethod(this, "Reset")
    this.CancelObj := ObjBindMethod(this, "Cancel")
    this.ApplyObj := ObjBindMethod(this, "Apply")
    this.ImportObj := ObjBindMethod(this, "ImportIni")
    this.ExportObj := ObjBindMethod(this, "ExportIni")
    this.ResizeObj := ObjBindMethod(this, "ResizeGui")
  }

  MakeGui() {
    this.Obj.Opt("+Resize +MinSize520x380")
    this.Panel := VimSettingPanel(this.Obj, this.Vim.Conf, this.Vim.GroupDel)
    this.ConfigLabel := this.Obj.Add("Text", "x0 y0 w0 h0", "Configuration file:")
    this.ConfigPath := this.Obj.Add("Edit", "x0 y0 w0 h0 ReadOnly"
      , this.Vim.Ini.Ini)
    this.OpenFolderButton := this.AddClick("Button", "x0 y0 w0 h0", "Open folder"
      , this.Vim.Ini.OpenIniDirObj, "Open the current configuration directory")

    this.ImportButton := this.AddClick("Button", "x0 y0 w0 h0", "Import"
      , this.ImportObj, "Load settings from an INI file")
    this.ExportButton := this.AddClick("Button", "x0 y0 w0 h0", "Export"
      , this.ExportObj, "Save current settings to an INI file")
    this.OKButton := this.AddClick("Button", "x0 y0 w0 h0 Default", "OK"
      , this.OKObj, "Apply changes and close")
    this.ApplyButton := this.AddClick("Button", "x0 y0 w0 h0", "Apply"
      , this.ApplyObj, "Apply changes")
    this.ResetButton := this.AddClick("Button", "x0 y0 w0 h0", "Reset"
      , this.ResetObj, "Show default values")
    this.CancelButton := this.AddClick("Button", "x0 y0 w0 h0", "Cancel"
      , this.CancelObj, "Discard staged changes and close")

    this.Obj.OnEvent("Size", this.ResizeObj)
    this.ResizeGui(this.Obj, 0, 764, 544)
    this.Panel.RefreshList()
  }

  ResizeGui(GuiObj, MinMax, Width, Height) {
    if (MinMax == -1) {
      return
    }
    Narrow := Width < VimSetting.NarrowWidth
    FooterHeight := Narrow ? 108 : 92
    FooterTop := Height - FooterHeight
    this.Panel.Resize(Width, FooterTop, Narrow)
    OpenFolderX := Width - 96
    this.ConfigLabel.Move(12, FooterTop + 4, 100, 16)
    this.ConfigPath.Move(120, FooterTop, OpenFolderX - 128, 24)
    this.OpenFolderButton.Move(OpenFolderX, FooterTop, 84, 24)

    ActionY := Height - 36
    UtilityY := Narrow ? Height - 68 : ActionY
    this.ImportButton.Move(12, UtilityY, 80, 24)
    this.ExportButton.Move(100, UtilityY, 80, 24)
    RightX := Width - 356
    this.OKButton.Move(RightX, ActionY, 80, 24)
    this.ApplyButton.Move(RightX + 88, ActionY, 80, 24)
    this.ResetButton.Move(RightX + 176, ActionY, 80, 24)
    this.CancelButton.Move(RightX + 264, ActionY, 80, 24)
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
