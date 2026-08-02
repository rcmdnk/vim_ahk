class VimSettingSchema {
  static Build(DefaultGroup, Delimiter := ",") {
    Schema := Map()

    this.Add(Schema, "VimEscNormal", 1, "Mode keys", "boolean"
      , "ESC to enter the normal mode"
      , "If checked, pressing ESC enters normal mode.")
    this.Add(Schema, "VimEscNormalDirect", 1, "Mode keys", "boolean"
      , "ESC to enter the normal mode directly even if converting in IME"
      , "If checked, ESC enters normal mode even while IME is converting.`nIf not checked, ESC behaves as normal ESC while IME is converting.")
    this.Add(Schema, "VimSendEscNormal", 0, "Mode keys", "boolean"
      , "Send ESC by ESC at the normal mode"
      , "If checked, a short ESC press sends ESC in normal mode.`nEnable ESC to enter normal mode first.")
    this.Add(Schema, "VimLongEscNormal", 0, "Mode keys", "boolean"
      , "Long press ESC to enter the normal mode"
      , "If checked, short and long press behavior of ESC is swapped.`nEnable ESC to enter normal mode first.")
    this.Add(Schema, "VimCtrlBracketToEsc", 1, "Mode keys", "boolean"
      , "Ctrl-[ to ESC"
      , "If checked, Ctrl-[ behaves as ESC.`nIf Ctrl-[ to normal mode is disabled, Ctrl-[ always sends ESC.`nIf both are checked, long press Ctrl-[ sends ESC.")
    this.Add(Schema, "VimCtrlBracketNormal", 1, "Mode keys", "boolean"
      , "Ctrl-[ to enter the normal mode"
      , "If checked, pressing Ctrl-[ enters normal mode.")
    this.Add(Schema, "VimCtrlBracketNormalDirect", 1, "Mode keys", "boolean"
      , "Ctrl-[ to enter the normal mode directly even if converting in IME"
      , "If checked, Ctrl-[ enters normal mode even while IME is converting.`nIf not checked, Ctrl-[ behaves as ESC while IME is converting.")
    this.Add(Schema, "VimSendCtrlBracketNormal", 0, "Mode keys", "boolean"
      , "Send Ctrl-[ by Ctrl-[ at the normal mode"
      , "If checked, a short Ctrl-[ press sends Ctrl-[ in normal mode.`nEnable Ctrl-[ to enter normal mode first.")
    this.Add(Schema, "VimLongCtrlBracketNormal", 0, "Mode keys", "boolean"
      , "Long press Ctrl-[ to enter the normal mode"
      , "If checked, short and long press behavior of Ctrl-[ is swapped.`nEnable Ctrl-[ to enter normal mode first.")
    this.Add(Schema, "VimChangeCaretWidth", 0, "Mode keys", "boolean"
      , "Change to thick text caret when in normal mode"
      , "If checked, caret width changes by mode (thick in normal/visual, thin in insert).`nIt may not work in all applications and can briefly change window focus.")
    this.Add(Schema, "VimRestoreIME", 1, "Mode keys", "boolean"
      , "Restore IME status at entering the insert mode"
      , "If checked, IME status is saved in insert mode and restored when returning to insert mode.")
    this.Add(Schema, "VimJJ", 0, "Mode keys", "boolean"
      , "JJ to enter the normal mode"
      , "If checked, `jj` enters normal mode from insert mode.")
    this.Add(Schema, "VimTwoLetter", "", "Mode keys", "list"
      , "Two-letter to enter the normal mode"
      , "Two-letter mappings to enter normal mode from insert mode.`nSet one pair per line.`nEach pair must be exactly two different letters.")
    this.Add(Schema, "VimDisableUnused", 1, "Mode keys", "choice"
      , "Disable unused keys in the normal mode"
      , "Disable level for unused keys outside insert mode:`n1: Do not disable unused keys`n2: Disable alphabets (+Shift) and symbols`n3: Disable all, including modified keys (e.g. Ctrl+Z)"
      , [1, 2, 3])

    this.Add(Schema, "VimSetTitleMatchMode", "2", "Applications", "choice"
      , "Window title match mode"
      , "SetTitleMatchMode mode:`n1: Start with`n2: Contain`n3: Exact match`nRegEx: Regular expression"
      , ["1", "2", "3", "RegEx"])
    this.Add(Schema, "VimSetTitleMatchModeFS", "Fast", "Applications", "choice"
      , "Window title matching speed"
      , "SetTitleMatchMode speed:`nFast: Text is not detected for some edit controls`nSlow: Works for all windows, but slower"
      , ["Fast", "Slow"])
    this.Add(Schema, "VimAppList", "Allow List", "Applications", "choice"
      , "Application list usage"
      , "Application list mode:`nAll: Enable vim_ahk on all applications (ignore the list)`nAllow List: Use list as allow list`nDeny List: Use list as deny list"
      , ["All", "Allow List", "Deny List"])
    this.Add(Schema, "VimGroup", DefaultGroup, "Applications", "list"
      , "Application list"
      , "Applications where vim_ahk is enabled.`nSet one application per line.`nEach line can be Window Title, Class, or Process.")

    this.AddApplicationGroup(Schema, "VimNonEditor"
      , ["ahk_exe explorer.exe", "ahk_exe q-dir_x64.exe", "ahk_exe q-dir.exe"
        , "ahk_exe chrome.exe", "ahk_exe msedge.exe", "ahk_exe firefox.exe"
        , "ahk_exe waterfox.exe", "ahk_exe brave.exe", "ahk_exe vivaldi.exe"
        , "ahk_exe opera.exe"]
      , "Non-editor applications"
      , "Enter keeps its native behavior in normal mode, and G sends End in these applications."
      , Delimiter)
    this.AddApplicationGroup(Schema, "VimLBSelectGroup"
      , ["ahk_exe powerpnt.exe", "ahk_exe winword.exe", "ahk_exe wordpad.exe", "ahk_exe notepad.exe"]
      , "Applications that select line breaks"
      , "Shift+End includes the line break in these applications."
      , Delimiter)
    this.AddApplicationGroup(Schema, "VimNoLBCopyGroup"
      , ["ahk_exe evernote.exe"]
      , "Applications that omit copied line breaks"
      , "Line-wise copy omits the line break in these applications."
      , Delimiter)
    this.AddApplicationGroup(Schema, "VimCtrlUpDownGroup"
      , ["ahk_exe onenote.exe"]
      , "Applications requiring Ctrl+Up and Ctrl+Down"
      , "Vertical paragraph movement uses Ctrl+Up and Ctrl+Down in these applications."
      , Delimiter)
    this.AddApplicationGroup(Schema, "VimDoubleHomeGroup"
      , ["ahk_exe code.exe"]
      , "Applications requiring Home twice"
      , "Line-start movement sends Home twice in these applications."
      , Delimiter)
    this.AddApplicationGroup(Schema, "VimCaretMove", []
      , "Applications supporting caret movement"
      , "The ^ command moves to the first non-whitespace character in these applications."
      , Delimiter)
    this.AddApplicationGroup(Schema, "VimCursorSameAfterSelect"
      , ["ahk_exe notepad.exe", "ahk_exe explorer.exe"]
      , "Applications preserving the cursor after selection"
      , "The cursor starts from the same position after selection in these applications."
      , Delimiter)
    this.AddApplicationGroup(Schema, "VimQdir"
      , ["ahk_exe q-dir_x64.exe", "ahk_exe q-dir.exe"]
      , "Q-Dir applications"
      , "Q-Dir-specific normal-mode bindings are active in these applications."
      , Delimiter)
    this.AddApplicationGroup(Schema, "VimShiftEnter"
      , ["ahk_exe ChatGPT.exe", "ahk_exe Claude.exe", "ahk_exe Cursor.exe"
        , "ahk_exe slack.exe", "ahk_exe ms-teams.exe", "ahk_exe Teams.exe"
        , "ahk_exe Discord.exe", "ahk_exe WhatsApp.exe", "ahk_exe Zoom.exe"
        , "ahk_exe PhoneExperienceHost.exe", "ahk_exe LINE.exe"]
      , "Applications using Shift+Enter for line breaks"
      , "The o and O commands send Shift+Enter in these applications."
      , Delimiter, ["lineBreakMethod"])
    this.AddApplicationGroup(Schema, "VimCtrlEnter", []
      , "Applications using Ctrl+Enter for line breaks"
      , "The o and O commands send Ctrl+Enter in these applications."
      , Delimiter, ["lineBreakMethod"])

    this.Add(Schema, "VimIconCheckInterval", 1000, "Status", "integer"
      , "Icon check interval (ms)"
      , "Interval (ms) to check vim_ahk status and update tray icon.`nIf set to 0, the original AHK icon is used."
      , 0, 0, 1000000)
    this.Add(Schema, "VimVerbose", 1, "Status", "choice"
      , "Verbose level"
      , "Verbose level:`n1: No output`n2: Minimum tooltip (mode only)`n3: Tooltip (all information)`n4: Debug message box (does not auto-close)"
      , [1, 2, 3, 4])

    return Schema
  }

  static AddApplicationGroup(Schema, Key, Items, Description, Info, Delimiter
      , ExclusiveGroups := 0) {
    this.Add(Schema, Key, this.Join(Items, Delimiter), "Application behavior", "list"
      , Description, Info, 0, "", "", Key, ExclusiveGroups)
  }

  static Join(Items, Delimiter) {
    Result := ""
    for Item in Items {
      Result .= (Result == "" ? "" : Delimiter) Item
    }
    return Result
  }

  static Add(Schema, Key, Default, Category, Kind, Description, Info
      , Choices := 0, Min := "", Max := "", Group := "", ExclusiveGroups := 0) {
    if !(Choices is Array) {
      Choices := []
    }
    if !(ExclusiveGroups is Array) {
      ExclusiveGroups := []
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
      "exclusiveGroups", ExclusiveGroups)
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

  static ValidateExclusiveGroups(Schema, Values, Delimiter) {
    Index := Map()
    for Key, Setting in Schema {
      for Group in Setting["exclusiveGroups"] {
        if !Index.Has(Group) {
          Index[Group] := Map()
        }
        Items := Index[Group]
        Loop Parse, Values[Key], Delimiter {
          if (A_LoopField == "") {
            continue
          }
          ItemKey := StrLower(A_LoopField)
          if !Items.Has(ItemKey) {
            Items[ItemKey] := Map("value", A_LoopField, "owners", [])
          }
          Items[ItemKey]["owners"].Push(Key)
        }
      }
    }

    Conflicts := ""
    for Group, Items in Index {
      for , Item in Items {
        if (Item["owners"].Length < 2) {
          continue
        }
        Owners := ""
        for Key in Item["owners"] {
          Owners .= (Owners == "" ? "" : ", ") Schema[Key]["description"]
        }
        Conflicts .= (Conflicts == "" ? "" : "`n`n")
          . Group ":`n" Item["value"] "`n" Owners
      }
    }

    if (Conflicts != "") {
      throw ValueError("Each item can belong to one setting in an exclusive group.`n`n"
        . Conflicts)
    }
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
    Result := ""
    Loop Parse, Value, "`n" {
      Item := Trim(A_LoopField)
      if (Item != "" && !Seen.Has(Item)) {
        Seen[Item] := True
        Result .= (Result == "" ? "" : Delimiter) Item
      }
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
