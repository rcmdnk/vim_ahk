class VimMove{
  __New(vim){
    this.Vim := vim
  }

  MoveFinalize(){
    if(this.Vim.State.Mode == "Vim_ydc_y"){
      Clipboard :=
      Send, ^c
      ClipWait, 1
      this.Vim.State.SetMode("Vim_Normal")
    }else if(this.Vim.State.Mode == "Vim_ydc_d"){
      Clipboard :=
      Send, ^x
      ClipWait, 1
      this.Vim.State.SetMode("Vim_Normal")
    }else if(this.Vim.State.Mode == "Vim_ydc_c"){
      Clipboard :=
      Send, ^x
      ClipWait, 1
      this.Vim.State.SetMode("Insert")
    }
    this.Vim.State.SetMode("", 0, 0)
    Send,{Shift Up}
    ; Sometimes, when using `c`, the control key would be stuck down afterwards.
    ; This forces it to be up again afterwards.
    send {Ctrl Up}
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
    shift = 0
    if(this.Vim.State.StrIsInCurrentVimMode("Visual") or this.Vim.State.StrIsInCurrentVimMode("ydc")){
      shift := 1

      Send, {Shift Down}
    }
    ; Left/Right
    if(not this.Vim.State.StrIsInCurrentVimMode("Line")){
      ; For some cases, need '+' directly to continue to select
      ; especially for cases using shift as original keys
      ; For now, caret does not work even add + directly

      ; 1 character
      if(key == "h"){
        Send, {Left}
      }else if(key == "l"){
        Send, {Right}
      ; Home/End
      }else if(key == "0"){
        Send, {Home}
      }else if(key == "$"){
        if(shift == 1){
          Send, +{End}
        }else{
          Send, {End}
        }
      }else if(key == "^"){
        if(shift == 1){
          if WinActive("ahk_group VimCaretMove"){
            Send, {Home}
            Send, ^{Right}
            Send, ^{Left}
          }else{
            Send, {Home}
          }
        }else{
          if WinActive("ahk_group VimCaretMove"){
            Send, +{Home}
            Send, +^{Right}
            Send, +^{Left}
          }else{
            Send, +{Home}
          }
        }
      ; Words
      }else if(key == "w"){
        if(shift == 1){
          Send, +^{Right}
        }else{
          Send, ^{Right}
        }
      }else if(key == "b"){
        if(shift == 1){
          Send, +^{Left}
        }else{
          Send, ^{Left}
        }
      }
    }
    ; Up/Down
    if(this.Vim.State.Mode == "Vim_VisualLineFirst") and (key == "k" or key == "^u" or key == "^b" or key == "g"){
      Send, {Shift Up}{End}{Home}{Shift Down}{Up}
      this.vim.state.setmode("vim_visualline")
    }
    if(this.Vim.State.StrIsInCurrentVimMode("Vim_ydc")) and (key == "k" or key == "^u" or key == "^b" or key == "g"){
      this.Vim.State.LineCopy := 1
      Send,{Shift Up}{Home}{Down}{Shift Down}{Up}
    }
    if(this.Vim.State.StrIsInCurrentVimMode("Vim_ydc")) and (key == "j" or key == "^d" or key == "^f" or key == "+g"){
      this.Vim.State.LineCopy := 1
      Send,{Shift Up}{Home}{Shift Down}{Down}
    }

    ; 1 character
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
      Send, ^{End}
    }

    if(!repeat){
      this.MoveFinalize()
    }
  }

  Repeat(key=""){
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
    if WinActive("ahk_group VimDoubleHomeGroup"){
      Send, {Home}
    }
    Send, {Home}+{End}
    if not WinActive("ahk_group VimLBSelectGroup"){
      this.Move("l")
    }else{
      this.Move("")
    }
  }
}
