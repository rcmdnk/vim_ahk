#Include %A_LineFile%\..\vim_setting_schema.ahk


; Shared editor for VimGroup and schema-defined application behavior groups.
; The other settings tabs continue to use their original controls in VimSetting.
class VimSettingApplicationPanel {
  static MainGroupKey := "VimGroup"
  static AppListKey := "VimAppList"

  __New(GuiObj, Schema, Delimiter, AddToolTipFn) {
    this.Gui := GuiObj
    this.Schema := Schema
    this.Delimiter := Delimiter
    this.AddToolTipFn := AddToolTipFn
    this.Values := Map()
    this.GroupKeys := []
    this.CurrentGroupKey := ""
    this.Loading := False

    this.ApplicationGroupLabel := this.AddLabel(
      "XS+10 Y+15", "Application group")
    this.ApplicationGroup := this.Gui.Add(
      "DropDownList", "X+5 YP-4 W260")
    this.LoadApplicationGroups()

    AppListSetting := this.Schema[VimSettingApplicationPanel.AppListKey]
    this.AppListLabel := this.AddLabel(
      "XS+10 Y+12", AppListSetting["description"], AppListSetting["info"])
    this.AppList := this.Gui.Add("DropDownList", "X+5 YP-4 W120")
    this.AppList.Add(AppListSetting["choices"])
    this.AddToolTip(this.AppList, AppListSetting["info"])

    this.GroupEditor := this.Gui.Add(
      "Edit", "XS+10 Y+10 R8 W430 Multi VScroll WantTab")
    this.GroupInfo := this.AddLabel("XS+10 Y+8 W430 H48", "")
    this.ApplicationGroup.OnEvent(
      "Change", ObjBindMethod(this, "ApplicationGroupChanged"))

    this.LoadValues(VimSettingSchema.Values(this.Schema))
  }

  AddLabel(Options, Text, ToolTipText := "") {
    Control := this.Gui.Add("Text", Options, Text)
    ; Pseudo click event to show the tooltip, as used by the original settings GUI.
    Control.OnEvent("Click", DoNothing(Obj, Info) => "")
    if (ToolTipText != "") {
      this.AddToolTip(Control, ToolTipText)
    }
    return Control
  }

  AddToolTip(Control, Text) {
    this.AddToolTipFn.Call(Control.Hwnd, Text)
  }

  LoadApplicationGroups() {
    MainGroupKey := VimSettingApplicationPanel.MainGroupKey
    if !this.Schema.Has(MainGroupKey) {
      throw ValueError("Missing application group setting: " MainGroupKey)
    }

    this.GroupKeys.Push(MainGroupKey)
    Labels := [this.Schema[MainGroupKey]["description"]]
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

  ApplicationGroupChanged(Control, Info) {
    if this.Loading {
      return
    }
    this.SaveCurrentGroup()
    Index := Control.Value
    if (Index < 1 || Index > this.GroupKeys.Length) {
      throw ValueError("Invalid application group selection.")
    }
    this.ShowGroup(this.GroupKeys[Index])
  }

  SaveCurrentGroup() {
    if (this.CurrentGroupKey == "") {
      return
    }
    this.Values[this.CurrentGroupKey] := VimSettingSchema.NormalizeList(
      this.GroupEditor.Text, this.Delimiter)
  }

  ShowGroup(Key) {
    Setting := this.Schema[Key]
    this.CurrentGroupKey := Key
    this.GroupEditor.Text := StrReplace(
      this.Values[Key], this.Delimiter, "`r`n")
    this.GroupInfo.Text := Setting["info"]

    ShowAppList := Key == VimSettingApplicationPanel.MainGroupKey
    this.AppListLabel.Visible := ShowAppList
    this.AppList.Visible := ShowAppList

    for Control in [this.ApplicationGroupLabel, this.ApplicationGroup
        , this.GroupEditor, this.GroupInfo] {
      this.AddToolTip(Control, Setting["info"])
    }
  }

  LoadValues(Values) {
    this.Loading := True
    try {
      for Key in this.GroupKeys {
        this.Values[Key] := Values[Key]
      }

      AppListSetting := this.Schema[VimSettingApplicationPanel.AppListKey]
      this.AppList.Choose(this.ChoiceIndex(
        AppListSetting, Values[VimSettingApplicationPanel.AppListKey]))

      GroupKey := this.CurrentGroupKey
      if (GroupKey == "") {
        GroupKey := this.GroupKeys[1]
      }
      this.ApplicationGroup.Choose(this.GroupIndex(GroupKey))
      this.ShowGroup(GroupKey)
    } finally {
      this.Loading := False
    }
  }

  StoreValues(Values) {
    this.SaveCurrentGroup()
    for Key in this.GroupKeys {
      Values[Key] := this.Values[Key]
    }
    Values[VimSettingApplicationPanel.AppListKey] := this.AppList.Text
  }

  ChoiceIndex(Setting, Value) {
    for Index, Choice in Setting["choices"] {
      if (Choice == Value) {
        return Index
      }
    }
    throw ValueError(Setting["description"] " has an invalid value.")
  }

  GroupIndex(Key) {
    for Index, GroupKey in this.GroupKeys {
      if (GroupKey == Key) {
        return Index
      }
    }
    throw ValueError("Unknown application group: " Key)
  }
}
