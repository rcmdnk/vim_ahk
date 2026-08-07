#Include %A_LineFile%\..\vim_setting_schema.ahk


class VimSettingPanel {
  static KeysCategory := "Mode keys"
  static StatusCategory := "Status"
  static MainGroupKey := "VimGroup"
  static AppListKey := "VimAppList"
  static UpDownNoThousandsOption := "0x80"

  __New(GuiObj, TabObj, Schema, Delimiter) {
    this.Gui := GuiObj
    this.Tab := TabObj
    this.Schema := Schema
    this.Delimiter := Delimiter
    this.Values := VimSettingSchema.Values(Schema)
    this.Controls := Map()
    this.GroupKeys := []
    this.CurrentGroupKey := ""
    this.Loading := False

    this.BuildKeysTab()
    this.BuildApplicationsTab()
    this.BuildStatusTab()
    this.Tab.UseTab()
    this.ValidateCoverage()
    this.LoadValues(this.Values)
  }

  BuildKeysTab() {
    this.Tab.UseTab(1)
    this.Gui.Add("Text", "X+0 Y+0 Section", "")
    for Key, Setting in this.Schema {
      if (Setting["category"] != VimSettingPanel.KeysCategory) {
        continue
      }
      Kind := Setting["kind"]
      if (Kind == "boolean") {
        Control := this.Gui.Add("CheckBox", "XS+10 Y+6", Setting["description"])
      } else if (Kind == "list") {
        this.Gui.Add("Text", "XS+10 Y+12", Setting["description"])
        Control := this.Gui.Add("Edit", "XS+10 Y+5 R4 W150 Multi VScroll WantTab")
      } else if (Kind == "choice") {
        this.Gui.Add("Text", "XS+10 Y+12", Setting["description"])
        Control := this.Gui.Add("DropDownList", "X+5 YP-4 W80")
        Control.Add(Setting["choices"])
      } else {
        throw ValueError("Unsupported setting kind in Keys tab: " Kind)
      }
      this.RegisterControl(Key, Control)
    }
  }

  BuildApplicationsTab() {
    this.Tab.UseTab(2)
    this.Gui.Add("Text", "X+0 Y+0 Section", "")
    this.AddApplicationChoice("VimSetTitleMatchMode", "XS+10 Y+10", "X+5 YP-4 W90")
    this.AddApplicationChoice("VimSetTitleMatchModeFS", "XS+10 Y+12", "X+5 YP-4 W90")

    this.ApplicationGroupLabel := this.Gui.Add("Text", "XS+10 Y+15", "Application group")
    this.ApplicationGroup := this.Gui.Add("DropDownList", "X+5 YP-4 W260")
    this.LoadApplicationGroups()

    AppListSetting := this.Schema[VimSettingPanel.AppListKey]
    this.AppListLabel := this.Gui.Add("Text", "XS+10 Y+12", AppListSetting["description"])
    this.AppList := this.Gui.Add("DropDownList", "X+5 YP-4 W120")
    this.AppList.Add(AppListSetting["choices"])
    this.RegisterControl(VimSettingPanel.AppListKey, this.AppList)

    this.GroupEditor := this.Gui.Add("Edit", "XS+10 Y+10 R8 W430 Multi VScroll WantTab")
    this.GroupInfo := this.Gui.Add("Text", "XS+10 Y+8 W430 H48", "")
    this.ApplicationGroup.OnEvent("Change", ObjBindMethod(this, "ApplicationGroupChanged"))
  }

  AddApplicationChoice(Key, LabelOptions, ControlOptions) {
    Setting := this.Schema[Key]
    this.Gui.Add("Text", LabelOptions, Setting["description"])
    Control := this.Gui.Add("DropDownList", ControlOptions)
    Control.Add(Setting["choices"])
    this.RegisterControl(Key, Control)
  }

  LoadApplicationGroups() {
    if !this.Schema.Has(VimSettingPanel.MainGroupKey) {
      throw ValueError("Missing application group setting: " VimSettingPanel.MainGroupKey)
    }
    this.GroupKeys.Push(VimSettingPanel.MainGroupKey)
    Labels := [this.Schema[VimSettingPanel.MainGroupKey]["description"]]
    for Key, Setting in this.Schema {
      if (Setting["group"] == "") {
        continue
      }
      Label := Setting["label"]
      if (Label == "") {
        throw ValueError("Missing application group label: " Key)
      }
      this.GroupKeys.Push(Key)
      Labels.Push(Label)
    }
    this.ApplicationGroup.Add(Labels)
  }

  BuildStatusTab() {
    this.Tab.UseTab(3)
    this.Gui.Add("Text", "X+0 Y+0 Section", "")
    for Key, Setting in this.Schema {
      if (Setting["category"] != VimSettingPanel.StatusCategory) {
        continue
      }
      Kind := Setting["kind"]
      this.Gui.Add("Text", "XS+10 Y+10", Setting["description"])
      if (Kind == "integer") {
        Control := this.Gui.Add("Edit", "X+5 YP-4 W80")
        UpDownOptions := VimSettingPanel.UpDownNoThousandsOption
        if (Setting["min"] != "" && Setting["max"] != "") {
          UpDownOptions .= " Range" Setting["min"] "-" Setting["max"]
        }
        this.Gui.Add("UpDown", UpDownOptions)
      } else if (Kind == "choice") {
        Control := this.Gui.Add("DropDownList", "X+5 YP-4 W80")
        Control.Add(Setting["choices"])
      } else {
        throw ValueError("Unsupported setting kind in Status tab: " Kind)
      }
      this.RegisterControl(Key, Control)
    }
  }

  RegisterControl(Key, Control) {
    if !this.Schema.Has(Key) {
      throw ValueError("Unknown setting control: " Key)
    }
    if this.Controls.Has(Key) {
      throw ValueError("Duplicate setting control: " Key)
    }
    this.Controls[Key] := Control
  }

  ValidateCoverage() {
    Covered := Map()
    for Key in this.Controls {
      Covered[Key] := True
    }
    for Key in this.GroupKeys {
      if Covered.Has(Key) {
        throw ValueError("Duplicate setting editor: " Key)
      }
      Covered[Key] := True
    }
    for Key in this.Schema {
      if !Covered.Has(Key) {
        throw ValueError("Missing setting editor: " Key)
      }
    }
  }

  ApplicationGroupChanged(Control, Info) {
    if this.Loading {
      return
    }
    this.CommitCurrentApplicationGroup()
    Index := Control.Value
    if (Index < 1 || Index > this.GroupKeys.Length) {
      throw ValueError("Invalid application group selection.")
    }
    this.ShowApplicationGroup(this.GroupKeys[Index])
  }

  CommitCurrentApplicationGroup() {
    if (this.CurrentGroupKey == "") {
      return
    }
    this.Values[this.CurrentGroupKey] := VimSettingSchema.NormalizeList(
      this.GroupEditor.Text, this.Delimiter)
  }

  ShowApplicationGroup(Key) {
    if !this.Schema.Has(Key) {
      throw ValueError("Unknown application group: " Key)
    }
    Setting := this.Schema[Key]
    if (Setting["kind"] != "list") {
      throw ValueError("Application group requires a list setting: " Key)
    }
    this.CurrentGroupKey := Key
    this.GroupEditor.Text := VimSettingSchema.ToEditor(
      Setting, this.Values[Key], this.Delimiter)
    this.GroupInfo.Text := Setting["info"]
    ShowAppList := Key == VimSettingPanel.MainGroupKey
    this.AppListLabel.Visible := ShowAppList
    this.AppList.Visible := ShowAppList
  }

  LoadValues(Values) {
    this.Loading := True
    try {
      for Key in this.Schema {
        if !Values.Has(Key) {
          throw ValueError("Missing setting value: " Key)
        }
        this.Values[Key] := Values[Key]
      }
      for Key, Control in this.Controls {
        this.SetControlValue(Key, Control, this.Values[Key])
      }
      GroupKey := this.CurrentGroupKey
      if (GroupKey == "") {
        GroupKey := this.GroupKeys[1]
      }
      this.ApplicationGroup.Choose(this.ApplicationGroupIndex(GroupKey))
      this.ShowApplicationGroup(GroupKey)
    } finally {
      this.Loading := False
    }
  }

  LoadDefaults() {
    this.LoadValues(VimSettingSchema.Values(this.Schema, True))
  }

  NormalizedValues() {
    this.CommitCurrentApplicationGroup()
    for Key, Control in this.Controls {
      this.Values[Key] := this.ControlValue(Key, Control)
    }
    return VimSettingSchema.NormalizeValues(
      this.Schema, this.Values, this.Delimiter)
  }

  SetControlValue(Key, Control, Value) {
    Setting := this.Schema[Key]
    Kind := Setting["kind"]
    if (Kind == "boolean") {
      Control.Value := Value ? 1 : 0
    } else if (Kind == "choice") {
      Control.Choose(this.ChoiceIndex(Setting, Value))
    } else if (Kind == "list") {
      Control.Text := VimSettingSchema.ToEditor(Setting, Value, this.Delimiter)
    } else if (Kind == "integer") {
      Control.Text := Value
    } else {
      throw ValueError("Unsupported setting kind: " Kind)
    }
  }

  ControlValue(Key, Control) {
    Kind := this.Schema[Key]["kind"]
    if (Kind == "boolean") {
      return Control.Value
    }
    if (Kind == "choice") {
      return Control.Text
    }
    if (Kind == "list") {
      return VimSettingSchema.NormalizeList(Control.Text, this.Delimiter)
    }
    if (Kind == "integer") {
      return Control.Text
    }
    throw ValueError("Unsupported setting kind: " Kind)
  }

  ChoiceIndex(Setting, Value) {
    for Index, Choice in Setting["choices"] {
      if (Choice == Value) {
        return Index
      }
    }
    throw ValueError(Setting["description"] " has an invalid value.")
  }

  ApplicationGroupIndex(Key) {
    for Index, GroupKey in this.GroupKeys {
      if (GroupKey == Key) {
        return Index
      }
    }
    throw ValueError("Unknown application group: " Key)
  }
}
