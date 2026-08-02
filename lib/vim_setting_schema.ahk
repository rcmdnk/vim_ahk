class VimSettingSchema {
  static Add(Schema, Key, Default, Category, Kind, Description, Info
      , Choices := 0, Min := "", Max := "", Group := "", Reload := False) {
    if !(Choices is Array) {
      Choices := []
    }
    Schema[Key] := Map(
      "default", Default,
      "val", Default,
      "category", Category,
      "kind", Kind,
      "description", Description,
      "info", Info,
      "choices", Choices,
      "min", Min,
      "max", Max,
      "group", Group,
      "reload", Reload)
  }

  static Copy(Schema) {
    Copy := Map()
    for Key, Setting in Schema {
      Item := Map()
      for Name, Value in Setting {
        Item[Name] := Value
      }
      Copy[Key] := Item
    }
    return Copy
  }

  static Values(Schema, Defaults := False) {
    Values := Map()
    Field := Defaults ? "default" : "val"
    for Key, Setting in Schema {
      Values[Key] := Setting[Field]
    }
    return Values
  }

  static Normalize(Setting, Value, Delimiter) {
    Kind := Setting["kind"]
    if (Kind == "boolean") {
      return Value ? 1 : 0
    }
    if (Kind == "integer") {
      if !IsInteger(Value) {
        throw ValueError(Setting["description"] " requires an integer.")
      }
      Value := Integer(Value)
      if (Setting["min"] != "" && Value < Setting["min"]) {
        throw ValueError(Setting["description"] " must be at least " Setting["min"] ".")
      }
      if (Setting["max"] != "" && Value > Setting["max"]) {
        throw ValueError(Setting["description"] " must be at most " Setting["max"] ".")
      }
      return Value
    }
    if (Kind == "choice") {
      for Choice in Setting["choices"] {
        if (Value == Choice) {
          return Choice
        }
      }
      throw ValueError(Setting["description"] " has an invalid value.")
    }
    if (Kind == "list") {
      return this.NormalizeList(Value, Delimiter)
    }
    return Value
  }

  static NormalizeList(Value, Delimiter) {
    Value := StrReplace(Value, "`r`n", "`n")
    Value := StrReplace(Value, "`r", "`n")
    Value := StrReplace(Value, Delimiter, "`n")
    Seen := Map()
    Items := []
    Loop Parse, Value, "`n" {
      Item := Trim(A_LoopField)
      if (Item != "" && !Seen.Has(Item)) {
        Seen[Item] := True
        Items.Push(Item)
      }
    }
    Result := ""
    for Item in Items {
      Result .= (Result == "" ? "" : Delimiter) Item
    }
    return Result
  }

  static ToEditor(Setting, Value, Delimiter) {
    if (Setting["kind"] == "list") {
      return StrReplace(Value, Delimiter, "`r`n")
    }
    return Value
  }

  static Summary(Setting, Value, Delimiter) {
    Kind := Setting["kind"]
    if (Kind == "boolean") {
      return Value ? "On" : "Off"
    }
    if (Kind == "list") {
      if (Value == "") {
        return "0 entries"
      }
      Count := 0
      Loop Parse, Value, Delimiter {
        if (A_LoopField != "") {
          Count++
        }
      }
      return Count " entries"
    }
    return Value
  }
}
