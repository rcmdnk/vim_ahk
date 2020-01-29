class VimState{
  static CheckModeValue := true
  static PossibleVimModes := ["Vim_Normal", "Insert", "Replace", "Vim_ydc_y"
  , "Vim_ydc_c", "Vim_ydc_d", "Vim_VisualLine", "Vim_VisualFirst"
  , "Vim_VisualChar", "Command", "Command_w", "Command_q", "Z", ""
  , "r_once", "r_repeat", "Vim_VisualLineFirst"]

  static Mode := "Insert"
  static g := 0
  static n := 0
  static LineCopy := 0
  static LastIME := 0
  static CurrControl := ""
  static PrevControl := ""

  CheckMode(verbose=1, Mode="", g=0, n=0, LineCopy=-1, force=0){
    if(force == 0) and ((verbose <= 1) or ((Mode == "") and (g == 0) and (n == 0) and (LineCopy == -1))){
      Return
    }else if(verbose == 2){
      VimState.Status(VimState.Mode, 1) ; 1 sec is minimum for TrayTip
    }else if(verbose == 3){
      VimState.Status(VimState.Mode "`r`ng=" VimState.g "`r`nn=" VimState.n "`r`nLineCopy=" VimState.LineCopy, 4)
    }
    if(verbose >= 4){
      Msgbox, , Vim Ahk, % "Mode: " . VimState.Mode . "`nVim_g: " . VimState.g . "`nVim_n: " . VimState.n . "`nVimLineCopy: " . VimState.LineCopy
    }
    Return
  }

  Status(Title, lines=1){
    WinGetPos, , , W, H, A
    ToolTip, %Title%, W - 110, H - 30 - (lines) * 20
    SetTimer, VimRemoveStatus, 1000
  }

  FullStatus(){
    VimState.CheckMode(4, , , , 1)
  }

  SetMode(Mode="", g=0, n=0, LineCopy=-1){
    global VimConfObj
    VimState.CheckValidMode(Mode)
    if(Mode != ""){
      VimState.Mode := Mode
      If(Mode == "Insert") and (VimConfObj.Conf["VimRestoreIME"]["val"] == 1){
        VIM_IME_SET(VimState.LastIME)
      }
      VimIcon.SetIcon(VimState.Mode, VimConfObj.Conf["VimIconCheckInterval"]["val"])
    }
    if(g != -1){
      VimState.g := g
    }
    if(n != -1){
      VimState.n := n
    }
    if(LineCopy!=-1){
      VimState.LineCopy := LineCopy
    }
    VimState.CheckMode(VimConfObj.Conf["VimVerbose"]["val"], Mode, g, n, LineCopy)
    Return
  }

  SetNormal(){
    VimState.LastIME := VIM_IME_Get()
    if(VimState.LastIME){
      if(VIM_IME_GetConverting(A)){
        Send,{Esc}
        Return
      }else{
        VIM_IME_SET()
      }
    }
    if(VimState.StrIsInCurrentVimMode( "Visual") or VimState.StrIsInCurrentVimMode( "ydc")){
      Send, {Right}
      if WinActive("ahk_group VimCursorSameAfterSelect"){
        Send, {Left}
      }
    }
    VimState.SetMode("Vim_Normal")
  }

  IsCurrentVimMode(mode){
    VimState.CheckValidMode(mode)
    return (mode == VimState.Mode)
  }

  StrIsInCurrentVimMode(mode){
    VimState.CheckValidMode(mode, false)
    return (inStr(VimState.Mode, mode))
  }

  CheckValidMode(Mode, FullMatch=true){
    if(VimState.CheckModeValue == false){
      Return
    }
    try{
      InOrBlank:= (not full_match) ? "in " : ""
      if not VimState.HasValue(VimState.PossibleVimModes, Mode, FullMatch){
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

  HasValue(haystack, needle, full_match = true){
    if(!isObject(haystack)){
      return false
    }else if(haystack.Length()==0){
      return false
    }
    for index,value in haystack{
      if full_match{
        if (value==needle){
          return true
        }
      }else{
        if (inStr(value, needle)){
          return true
        }
      }
    }
    return false
  }
}

VimRemoveStatus(){
  SetTimer, VimRemoveStatus, off
  ToolTip
}

VimStatusCheckTimer(){
  global VimConfObj
  if WinActive("ahk_group " . VimConfObj.GroupName){
    VimIcon.SetIcon(VimState.Mode, VimConfObj.Conf["VimIconCheckInterval"]["val"])
  }else{
    VimIcon.SetIcon("Disabled", VimConfObj.Conf["VimIconCheckInterval"]["val"])
  }
}
