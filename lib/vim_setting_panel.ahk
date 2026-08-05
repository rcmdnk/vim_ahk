#Include %A_LineFile%\..\vim_setting_schema.ahk


class VimSettingPanel {
  __New(GuiObj, Schema, Delimiter) {
    this.Gui := GuiObj
    this.Schema := Schema
    this.Delimiter := Delimiter
    this.Values := VimSettingSchema.Values(Schema)
    this.RowKeys := Map()
    this.Categories := []
    this.CurrentKey := ""

    this.SearchLabel := this.Gui.Add("Text", "x0 y0 w0 h0", "Search:")
    this.Search := this.Gui.Add("Edit", "x0 y0 w0 h0")
    this.Category := this.Gui.Add("ListBox", "x0 y0 w0 h0")
    this.List := this.Gui.Add("ListView", "x0 y0 w0 h0 -Multi", ["Setting", "Value"])
    this.Details := this.Gui.Add("Edit", "x0 y0 w0 h0 ReadOnly Multi VScroll")
    this.Boolean := this.Gui.Add("CheckBox", "x0 y0 w0 h0", "Enabled")
    this.Choice := this.Gui.Add("DropDownList", "x0 y0 w0 h0")
    this.Text := this.Gui.Add("Edit", "x0 y0 w0 h0")
    this.ListText := this.Gui.Add("Edit", "x0 y0 w0 h0 Multi VScroll WantTab")

    this.Search.OnEvent("Change", ObjBindMethod(this, "FilterChanged"))
    this.Category.OnEvent("Change", ObjBindMethod(this, "FilterChanged"))
    this.List.OnEvent("ItemSelect", ObjBindMethod(this, "ItemSelected"))
    this.Boolean.OnEvent("Click", ObjBindMethod(this, "EditorChanged"))
    this.Choice.OnEvent("Change", ObjBindMethod(this, "EditorChanged"))
    this.Text.OnEvent("Change", ObjBindMethod(this, "EditorChanged"))
    this.ListText.OnEvent("Change", ObjBindMethod(this, "EditorChanged"))

    this.LoadCategories()
    this.HideEditors()
  }

  LoadCategories() {
    Seen := Map()
    this.Categories := ["All"]
    for , Setting in this.Schema {
      Category := Setting["category"]
      if !Seen.Has(Category) {
        Seen[Category] := True
        this.Categories.Push(Category)
      }
    }
    this.Category.Delete()
    this.Category.Add(this.Categories)
    this.Category.Choose(1)
  }

  FilterChanged(Control, Info) {
    this.RefreshList()
  }

  RefreshList() {
    PreferredKey := this.CurrentKey
    CategoryIndex := this.Category.Value
    Category := CategoryIndex ? this.Categories[CategoryIndex] : "All"
    Query := StrLower(Trim(this.Search.Text))
    this.List.Delete()
    this.RowKeys := Map()
    SelectedRow := 0
    for Key, Setting in this.Schema {
      if (Category != "All" && Setting["category"] != Category) {
        continue
      }
      SearchText := StrLower(Key " " Setting["description"] " " Setting["info"])
      if (Query != "" && !InStr(SearchText, Query)) {
        continue
      }
      Row := this.List.Add("", Setting["description"]
        , VimSettingSchema.Summary(Setting, this.Values[Key], this.Delimiter))
      this.RowKeys[Row] := Key
      if (Key == PreferredKey) {
        SelectedRow := Row
      }
    }
    this.ResizeColumns()
    if (!SelectedRow && this.RowKeys.Count) {
      SelectedRow := 1
    }
    if SelectedRow {
      this.List.Modify(SelectedRow, "Select Focus Vis")
      this.ShowEditor(this.RowKeys[SelectedRow])
    } else {
      this.CurrentKey := ""
      this.Details.Text := ""
      this.HideEditors()
    }
  }

  ItemSelected(Control, Row, Selected) {
    if (Selected && this.RowKeys.Has(Row)) {
      this.ShowEditor(this.RowKeys[Row])
    }
  }

  ShowEditor(Key) {
    this.CurrentKey := Key
    Setting := this.Schema[Key]
    this.Details.Text := Setting["description"] "`r`n`r`n" Setting["info"]
    this.HideEditors()
    Kind := Setting["kind"]
    if (Kind == "boolean") {
      this.Boolean.Value := this.Values[Key]
      this.Boolean.Visible := True
    } else if (Kind == "choice") {
      this.Choice.Delete()
      this.Choice.Add(Setting["choices"])
      ChoiceIndex := 0
      for Index, Choice in Setting["choices"] {
        if (Choice == this.Values[Key]) {
          ChoiceIndex := Index
          break
        }
      }
      this.Choice.Choose(ChoiceIndex)
      this.Choice.Visible := True
    } else if (Kind == "list") {
      this.ListText.Text := VimSettingSchema.ToEditor(Setting, this.Values[Key], this.Delimiter)
      this.ListText.Visible := True
    } else {
      this.Text.Text := this.Values[Key]
      this.Text.Visible := True
    }
    this.ResizeDetails()
  }

  HideEditors() {
    this.Boolean.Visible := False
    this.Choice.Visible := False
    this.Text.Visible := False
    this.ListText.Visible := False
  }

  EditorChanged(Control, Info) {
    if (this.CurrentKey == "") {
      return
    }
    Setting := this.Schema[this.CurrentKey]
    Kind := Setting["kind"]
    if (Kind == "boolean") {
      Value := this.Boolean.Value
    } else if (Kind == "choice") {
      Value := this.Choice.Text
    } else if (Kind == "list") {
      Value := VimSettingSchema.NormalizeList(this.ListText.Text, this.Delimiter)
    } else {
      Value := this.Text.Text
    }
    this.Values[this.CurrentKey] := Value
    this.UpdateSummary(this.CurrentKey)
  }

  UpdateSummary(SettingKey) {
    for Row, RowKey in this.RowKeys {
      if (RowKey == SettingKey) {
        this.List.Modify(Row, "Col2"
          , VimSettingSchema.Summary(this.Schema[SettingKey]
            , this.Values[SettingKey], this.Delimiter))
        break
      }
    }
  }

  LoadValues(Values) {
    for Key in this.Schema {
      if Values.Has(Key) {
        this.Values[Key] := Values[Key]
      }
    }
    this.RefreshList()
  }

  LoadDefaults() {
    this.LoadValues(VimSettingSchema.Values(this.Schema, True))
  }

  NormalizedValues() {
    return VimSettingSchema.NormalizeValues(this.Schema, this.Values, this.Delimiter)
  }

  ResizeColumns() {
    ValueWidth := Min(140, Floor(this.ListWidth * 0.30))
    this.List.ModifyCol(1, this.ListWidth - ValueWidth - 20)
    this.List.ModifyCol(2, ValueWidth)
  }

  ResizeDetails() {
    Gap := 8
    AvailableHeight := this.DetailsBottom - this.DetailsTop
    Kind := this.CurrentKey == "" ? "text" : this.Schema[this.CurrentKey]["kind"]
    if (Kind == "list") {
      DetailsHeight := Floor((AvailableHeight - Gap) * 0.45)
      EditorY := this.DetailsTop + DetailsHeight + Gap
      EditorHeight := this.DetailsBottom - EditorY
    } else {
      EditorHeight := 24
      EditorY := this.DetailsBottom - EditorHeight
      DetailsHeight := EditorY - this.DetailsTop - Gap
    }

    this.Details.Move(this.RightX, this.DetailsTop, this.RightWidth, DetailsHeight)
    this.Boolean.Move(this.RightX, EditorY, this.RightWidth, 24)
    this.Choice.Move(this.RightX, EditorY, Min(320, this.RightWidth), 24)
    this.Text.Move(this.RightX, EditorY, this.RightWidth, 24)
    this.ListText.Move(this.RightX, EditorY, this.RightWidth, EditorHeight)
  }

  Resize(Width, FooterTop, Narrow) {
    Margin := 12
    Gap := Narrow ? 8 : 12
    LeftWidth := Min(170, Floor(Width * 0.28))
    RightX := Margin + LeftWidth + Gap
    RightWidth := Width - RightX - Margin
    ContentTop := 46
    ContentHeight := FooterTop - ContentTop - Gap
    ListHeight := Floor(ContentHeight * 0.43)
    DetailsTop := ContentTop + ListHeight + Gap

    this.SearchLabel.Move(Margin, Margin + 3, 48, 20)
    this.Search.Move(Margin + 52, Margin, Width - Margin * 2 - 52)
    this.Category.Move(Margin, ContentTop, LeftWidth, ContentHeight)
    this.List.Move(RightX, ContentTop, RightWidth, ListHeight)
    this.ListWidth := RightWidth
    this.RightX := RightX
    this.RightWidth := RightWidth
    this.DetailsTop := DetailsTop
    this.DetailsBottom := FooterTop - Gap
    this.ResizeDetails()
    this.ResizeColumns()
  }
}
