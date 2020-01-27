class VimDebug{
  static CheckModeValue := true
  static PossibleVimModes := ["Vim_Normal", "Insert", "Replace", "Vim_ydc_y"
  , "Vim_ydc_c", "Vim_ydc_d", "Vim_VisualLine", "Vim_VisualFirst"
  , "Vim_VisualChar", "Command", "Command_w", "Command_q", "Z", ""
  , "r_once", "r_repeat", "Vim_VisualLineFirst"]

  CheckValidMode(Mode, FullMatch=true){
    if (VimDebug.CheckModeValue == false){
      Return
    }
    try {
      InOrBlank:= (not full_match) ? "in " : ""
      if not VimHasValue(VimDebug.PossibleVimModes, Mode, FullMatch){
        throw Exception("Invalid mode specified",-2,
        ( Join
  "'" Mode "' is not " InOrBlank " a valid mode as defined by the VimPossibleVimModes
   array at the top of vim.ahk. This may be a typo.
   Fix this error by using an existing mode,
   or adding your mode to the array.")
        )
      }
    }catch e{
      MsgBox % "Warning: " e.Message "`n" e.Extra "`n`n Called in " e.What " at line " e.Line
    }
  }
}
