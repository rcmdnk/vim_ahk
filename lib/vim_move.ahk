class VimMove{
  __New(vim){
    this.Vim := vim
    this.shift := 0
  }

  MoveInitialize(key=""){
    this.shift := 0
    if(this.Vim.State.StrIsInCurrentVimMode("Visual") or this.Vim.State.StrIsInCurrentVimMode("ydc")){
      this.shift := 1
      Send, {Shift Down}
    }

    if(this.Vim.State.IsCurrentVimMode("Vim_VisualLineFirst")) and (key == "k" or key == "^u" or key == "^b" or key == "g"){
      Send, {Shift Up}{End}
      this.Zero()
      Send, {Shift Down}
      this.Up()
      this.vim.state.setmode("Vim_VisualLine")
    }

    if(this.Vim.State.IsCurrentVimMode("Vim_VisualLineFirst")) and (key == "j" or key == "^d" or key == "^f" or key == "+g"){
      this.vim.state.setmode("Vim_VisualLine")
    }

    if(this.Vim.State.StrIsInCurrentVimMode("Vim_ydc")) and (key == "k" or key == "^u" or key == "^b" or key == "g"){
      this.Vim.State.LineCopy := 1
      Send,{Shift Up}
      this.Zero()
      this.Down()
      Send, {Shift Down}
      this.Up()
    }
    if(this.Vim.State.StrIsInCurrentVimMode("Vim_ydc")) and (key == "j" or key == "^d" or key == "^f" or key == "+g"){
      this.Vim.State.LineCopy := 1
      Send,{Shift Up}
      this.Zero()
      Send, {Shift Down}
      this.Down()
    }
  }

  MoveFinalize(){
    Send,{Shift Up}
    ydc_y := false
    if(this.Vim.State.StrIsInCurrentVimMode("ydc_y")){
      Clipboard :=
      Send, ^c
      ClipWait, 1
      this.Vim.State.SetMode("Vim_Normal")
      ydc_y := true
    }else if(this.Vim.State.StrIsInCurrentVimMode("ydc_d")){
      Clipboard :=
      Send, ^x
      ClipWait, 1
      this.Vim.State.SetMode("Vim_Normal")
    }else if(this.Vim.State.StrIsInCurrentVimMode("ydc_c")){
      Clipboard :=
      Send, ^x
      ClipWait, 1
      this.Vim.State.SetMode("Insert")
    }
    this.Vim.State.SetMode("", 0, 0)
    if(ydc_y){
      Send, {Left}{Right}
    }
    ; Sometimes, when using `c`, the control key would be stuck down afterwards.
    ; This forces it to be up again afterwards.
    send {Ctrl Up}
  }

  Zero(){
    if WinActive("ahk_group VimDoubleHomeGroup"){
      Send, {Home}
    }
    Send, {Home}
  }

  Up(n=1){
    Loop, %n% {
      if WinActive("ahk_group VimCtrlUpDownGroup"){
        Send ^{Up}
      } else {
        Send,{Up}
      }
    }
  }

  Down(n=1){
    Loop, %n% {
      if WinActive("ahk_group VimCtrlUpDownGroup"){
        Send ^{Down}
      } else {
        Send,{Down}
      }
    }
  }

  Move(key="", repeat=false){
    if(!repeat){
      this.MoveInitialize(key)
    }

    ; Left/Right
    if(not this.Vim.State.StrIsInCurrentVimMode("Line")){
      ; For some cases, need '+' directly to continue to select
      ; especially for cases using shift as original keys
      ; For now, caret does not work even add + directly

      ; 1 character
      if(key == "h"){
        if WinActive("ahk_group VimQdir"){
          Send, {BackSpace down}{BackSpace up}
        }
        else {
          Send, {Left}
        }
      }else if(key == "l"){
        if WinActive("ahk_group VimQdir"){
          Send, {Enter}
        }
        else {
          Send, {Right}
        }
      ; Home/End
      }else if(key == "0"){
        this.Zero()
      }else if(key == "$"){
        if(this.shift == 1){
          Send, +{End}
        }else{
          Send, {End}
        }
      }else if(key == "^"){
        if(this.shift == 1){
          if WinActive("ahk_group VimCaretMove"){
            Send, +{Home}
            Send, +^{Right}
            Send, +^{Left}
          }else{
            Send, +{Home}
          }
        }else{
          if WinActive("ahk_group VimCaretMove"){
            Send, {Home}
            Send, ^{Right}
            Send, ^{Left}
          }else{
            Send, {Home}
          }
        }
      ; Words
      }else if(key == "w"){
        if(this.shift == 1){
          Send, +^{Right}
        }else{
          Send, ^{Right}
        }
      }else if(key == "e"){
        if(this.shift == 1){
          if(this.Vim.CheckChr(" ")){
            Send, +^{Right}
          }
          Send, +^{Right}+{Left}
        }else{
          if(this.Vim.CheckChr(" ")){
            Send, ^{Right}
          }
          Send, ^{Right}{Left}
        }
      }else if(key == "b"){
        if(this.shift == 1){
          Send, +^{Left}
        }else{
          Send, ^{Left}
        }
      }
    }
    ; Up/Down 1 character
    if(key == "j"){
      this.Down()
    }else if(key="k"){
      this.Up()
    ; Page Up/Down
    n := 10
    }else if(key == "^u"){
      this.Up(10)
    }else if(key == "^d"){
      this.Down(10)
    }else if(key == "^b"){
      Send, {PgUp}
    }else if(key == "^f"){
      Send, {PgDn}
    }else if(key == "g"){
      Send, ^{Home}
    }else if(key == "+g"){
      Send, ^{End}{Home}
    }

    if(!repeat){
      this.MoveFinalize()
    }
  }

  Repeat(key=""){
    this.MoveInitialize(key)
    if(this.Vim.State.n == 0){
      this.Vim.State.n := 1
    }
    Loop, % this.Vim.State.n {
      this.Move(key, true)
    }
    this.MoveFinalize()
  }

  YDCMove(){
    this.Vim.State.LineCopy := 1
    this.Zero()
    Send, {Shift Down}
    if(this.Vim.State.n == 0){
      this.Vim.State.n := 1
    }
    this.Down(this.Vim.State.n - 1)
    Send, {End}
    if not WinActive("ahk_group VimLBSelectGroup"){
      this.Move("l")
    }else{
      this.Move("")
    }
  }

  Inner(key=""){
    if(key == "w"){
      this.Move("b", true)
      this.Move("w", false)
    }
  }
}
