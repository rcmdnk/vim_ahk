class VimState{
  __New(vim){
    this.Vim := vim

    this.CheckModeValue := true
    this.PossibleVimModes := ["Vim_Normal", "Insert", "Replace", "Vim_ydc_y"
    , "Vim_ydc_c", "Vim_ydc_d", "Vim_VisualLine", "Vim_VisualFirst"
    , "Vim_VisualChar", "Command", "Command_w", "Command_q", "Z", ""
    , "r_once", "r_repeat", "Vim_VisualLineFirst"]

    this.Mode := "Insert"
    this.g := 0
    this.n := 0
    this.LineCopy := 0
    this.LastIME := 0
    this.CurrControl := ""
    this.PrevControl := ""

    this.StatusCheckObj := ObjBindMethod(this, "StatusCheck")
  }

  CheckMode(verbose=1, Mode="", g=0, n=0, LineCopy=-1, force=0){
    if(force == 0) and ((verbose <= 1) or ((Mode == "") and (g == 0) and (n == 0) and (LineCopy == -1))){
      Return
    }else if(verbose == 2){
      this.Status(this.Mode, 1)
    }else if(verbose == 3){
      this.Status(this.Mode "`r`ng=" this.g "`r`nn=" this.n "`r`nLineCopy=" this.LineCopy, 4)
    }
    if(verbose >= 4){
      Msgbox, , Vim Ahk, % "Mode: " this.Mode "`nVim_g: " this.g "`nVim_n: " this.n "`nVimLineCopy: " this.LineCopy
    }
  }

  Status(Title, lines=1){
    WinGetPos, , , W, H, A
    ToolTip, %Title%, W - 110, H - 30 - (lines) * 20
    this.Vim.VimToolTip.SetRemoveToolTip(1000)
  }

  FullStatus(){
    this.CheckMode(4, , , , 1)
  }

  SetMode(Mode="", g=0, n=0, LineCopy=-1){
    this.CheckValidMode(Mode)
    if(Mode != ""){
      this.Mode := Mode
      If(Mode == "Insert") and (this.Vim.Conf["VimRestoreIME"]["val"] == 1){
        VIM_IME_SET(this.LastIME)
      }
      this.Vim.Icon.SetIcon(this.Mode, this.Vim.Conf["VimIconCheckInterval"]["val"])
    }
    if(g != -1){
      this.g := g
    }
    if(n != -1){
      this.n := n
    }
    if(LineCopy!=-1){
      this.LineCopy := LineCopy
    }
    this.CheckMode(this.Vim.Conf["VimVerbose"]["val"], Mode, g, n, LineCopy)
  }

  SetNormal(){
    this.LastIME := VIM_IME_Get()
    if(this.LastIME){
      if(VIM_IME_GetConverting(A)){
        Send, {Esc}
        Return
      }else{
        VIM_IME_SET()
      }
    }
    if(this.StrIsInCurrentVimMode("Visual") or this.StrIsInCurrentVimMode("ydc")){
      Send, {Right}
      if WinActive("ahk_group VimCursorSameAfterSelect"){
        Send, {Left}
      }
    }
    this.SetMode("Vim_Normal")
  }

  HandleEsc(){
    ; The keywait waits for esc to be released. If it doesn't detect a release
    ; within the time limit, sets errorlevel to 1.
    KeyWait, Esc, T0.5
    LongPress := ErrorLevel
    global Vim, VimLongEscNormal
    both := VimLongEscNormal && LongPress
    neither := !(VimLongEscNormal || LongPress)
    SetNormal :=  both or neither
    if (SetNormal) {
        Vim.State.SetNormal()
    } else {
        Send,{Esc}
    }
    if (LongPress){
      ; Have to ensure the key has been released, otherwise this will get
      ; triggered again.
      KeyWait, Esc
    }
  }

  IsCurrentVimMode(mode){
    this.CheckValidMode(mode)
    Return (mode == this.Mode)
  }

  StrIsInCurrentVimMode(mode){
    this.CheckValidMode(mode, false)
    Return (inStr(this.Mode, mode))
  }

  CheckValidMode(Mode, FullMatch=true){
    if(this.CheckModeValue == false){
      Return
    }
    try{
      InOrBlank:= (not FullMatch) ? "in " : ""
      if not this.HasValue(this.PossibleVimModes, Mode, FullMatch){
        throw Exception("Invalid mode specified",-2,
        (Join
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
    }else if(haystack.Length() == 0){
      return false
    }
    for index, value in haystack{
      if full_match{
        if (value == needle){
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

  StatusCheck(){
    if WinActive("ahk_group " this.Vim.GroupName){
      this.Vim.Icon.SetIcon(this.Mode, this.Vim.Conf["VimIconCheckInterval"]["val"])
    }else{
      this.Vim.Icon.SetIcon("Disabled", this.Vim.Conf["VimIconCheckInterval"]["val"])
    }
  }

  SetStatusCheck(){
    check := this.StatusCheckObj
    if(this.Vim.Conf["VimIconCheckInterval"]["val"] > 0){
      SetTimer, % check, % this.Vim.Conf["VimIconCheckInterval"]["val"]
    }else{
      this.Vim.Icon.SetIcon("", 0)
      SetTimer, % check, Off
    }
  }
}
