class VimState{
  __New(Vim){
    this.Vim := Vim

    this.CheckModeValue := false
    ; CheckModeValue set to true only for script mode
    ;@Ahk2Exe-IgnoreBegin
    this.CheckModeValue := true
    ;@Ahk2Exe-IgnoreEnd
    this.PossibleVimModes := ["", "Vim_Normal", "Insert", "Replace"
    , "Vim_ydc_y" , "Vim_ydc_yInner", "Vim_ydc_c", "Vim_ydc_cInner"
    , "Vim_ydc_d" , "Vim_ydc_dInner" , "Vim_VisualLine", "Vim_VisualFirst"
    , "Vim_VisualChar", "Vim_VisualLineFirst", "Vim_VisualCharInner"
    , "Command" , "Command_w", "Command_q", "Z", "r_once", "r_repeat"]

    this.Mode := "Insert"
    this.g := 0
    this.n := 0
    this.LineCopy := 0
    this.LastIME := 0
    this.CurrControl := ""
    this.PrevControl := ""

    this.StatusCheckObj := ObjBindMethod(this, "StatusCheck")
  }

  CheckMode(Verbose:=1, Mode:="", g:=0, n:=0, LineCopy:=-1, Force:=0){
    if(Force == 0) and ((Verbose <= 1) or ((Mode == "") and (g == 0) and (n == 0) and (LineCopy == -1))){
      Return
    }else if(Verbose == 2){
      this.SetTooltip(this.Mode, 1)
    }else if(Verbose == 3){
      this.SetTooltip(this.Mode "`r`ng=" this.g "`r`nn=" this.n "`r`nLineCopy=" this.LineCopy, 4)
    }
    if(Verbose >= 4){
      MsgBox("Mode        : " this.Mode "`nVim_g       : " this.g "`nVim_n       : " this.n "`nVimLineCopy : " this.LineCopy, "Vim Ahk")
    }
  }

  SetTooltip(Title, Lines:=1){
    WinGetPos(, , &W, &H, "A")
    ToolTip(Title, W - 110, H - 30 - (Lines) * 20)
    this.Vim.VimToolTip.SetRemoveToolTip(1000)
  }

  FullStatus(ItemName, ItemPos, MyMenu){
    this.CheckMode(4, , , , 1)
  }

  SetMode(Mode:="", g:=0, n:=0, LineCopy:=-1){
    this.CheckValidMode(Mode)
    if(Mode != ""){
      this.Mode := Mode
      If(this.IsCurrentVimMode("Insert")) and (this.Vim.Conf["VimRestoreIME"]["val"] == 1){
        VIM_IME_SET(this.LastIME)
      }
      this.Vim.Icon.SetIcon(this.Mode, this.Vim.Conf["VimIconCheckInterval"]["val"])
      this.Vim.Caret.SetCaret(this.Mode)
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
      if(VIM_IME_GetConverting("A")){
        SendInput("{Esc}")
        Return
      }else{
        VIM_IME_SET()
      }
    }
    if(this.StrIsInCurrentVimMode("Visual") or this.StrIsInCurrentVimMode("ydc")){
      SendInput("{Right}")
      if WinActive("ahk_group VimCursorSameAfterSelect"){
        SendInput("{Left}")
      }
    }
    this.SetMode("Vim_Normal")
  }

  SetInner(){
    this.SetMode(this.Mode "Inner")
  }

  HandleEsc(){
    if (!this.Vim.Conf["VimEscNormal"]["val"]) {
      SendInput("{Esc}")
      Return
    }
    ; The keywait waits for esc to be released. If it doesn't detect a release
    ; within the time limit, return 0, otherwise return 1.
    ShortPress := KeyWait("Esc", "T0.5")
    SetNormal := this.Vim.Conf["VimLongEscNormal"]["val"] != ShortPress
    if (!SetNormal or (this.Vim.Conf["VimSendEscNormal"]["val"] && this.IsCurrentVimMode("Vim_Normal"))) {
      SendInput("{Esc}")
    }
    if (SetNormal) {
      this.SetNormal()
    }
    if (!ShortPress){
      ; Have to ensure the key has been released, otherwise this will get
      ; triggered again.
      KeyWait("Esc")
    }
  }

  HandleCtrlBracket(){
    if (!this.Vim.Conf["VimCtrlBracketNormal"]["val"]) {
      SendInput("^[")
      Return
    }
    ShortPress := KeyWait("[", "T0.5")
    SetNormal := this.Vim.Conf["VimLongCtrlBracketNormal"]["val"] != ShortPress
    if (!SetNormal or (this.Vim.Conf["VimSendCtrlBracketNormal"]["val"] && this.IsCurrentVimMode("Vim_Normal"))) {
      SendInput("^[")
    }
    if (SetNormal) {
      this.SetNormal()
    }
    if (!ShortPress){
      KeyWait("[")
    }
  }

  IsCurrentVimMode(Mode){
    this.CheckValidMode(Mode)
    Return (mode == this.Mode)
  }

  StrIsInCurrentVimMode(Mode){
    this.CheckValidMode(Mode, false)
    Return (inStr(this.Mode, Mode))
  }

  CheckValidMode(Mode, FullMatch:=true){
    if(this.CheckModeValue == false){
      Return
    }
    try{
      InOrBlank := (not FullMatch) ? "in " : ""
      if not this.HasValue(this.PossibleVimModes, Mode, FullMatch){
        Throw ValueError("Invalid mode specified", -2, "
        (
          '%Mode%' is not %InOrBlank%a valid mode as defined by the VimPossibleVimModes
          array at the top of vim_state.ahk. This may be a typo.
          Fix this error by using an existing mode,
          or adding your mode to the array.
        )")
      }
    }catch ValueError as e{
      MsgBox("
      (
        Warning: %e.Message%
        %e.Extra%

        Called in %e.What% at line %e.Line%
      )", "Vim Ahk")
    }
  }

  HasValue(Haystack, Needle, FullMatch:=true){
    if(!isObject(Haystack)){
      return false
    }else if(Haystack.Length == 0){
      return false
    }
    for index, value in Haystack{
      if fullMatch{
        if (value == Needle){
          return true
        }
      }else{
        if (inStr(value, Needle)){
          return true
        }
      }
    }
    return false
  }

  ; Update icon/mode indicator
  StatusCheck(){
    if(this.Vim.IsVimGroup()){
      this.Vim.Icon.SetIcon(this.Mode, this.Vim.Conf["VimIconCheckInterval"]["val"])
    }else{
      this.Vim.Icon.SetIcon("Disabled", this.Vim.Conf["VimIconCheckInterval"]["val"])
    }
  }

  SetStatusCheck(){
    check := this.StatusCheckObj
    if(this.Vim.Conf["VimIconCheckInterval"]["val"] > 0){
      SetTimer(check, this.Vim.Conf["VimIconCheckInterval"]["val"])
    }else{
      this.Vim.Icon.SetIcon("", 0)
      SetTimer(check, 0)
    }
  }

  ToggleEnabled(){
    if(this.Vim.Enabled){
      this.Vim.Enabled := False
    }else{
      this.Vim.Enabled := True
    }
  }
}
