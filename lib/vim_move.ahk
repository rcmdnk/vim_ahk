class VimMove{
  __New(Vim){
    this.Vim := Vim
    this.shift := 0
  }

  MoveInitialize(Key:=""){
    this.shift := 0
    if(this.Vim.State.StrIsInCurrentVimMode("Visual") or this.Vim.State.StrIsInCurrentVimMode("ydc")){
      this.shift := 1
      Send("{Shift Down}")
    }

    if(this.Vim.State.IsCurrentVimMode("Vim_VisualLineFirst")) and (Key == "k" or Key == "^u" or Key == "^b" or Key == "g"){
      Send("{Shift Up}{End}")
      this.Zero()
      Send("{Shift Down}")
      this.Up()
      this.vim.state.setmode("Vim_VisualLine")
    }

    if(this.Vim.State.IsCurrentVimMode("Vim_VisualLineFirst")) and (Key == "j" or Key == "^d" or Key == "^f" or Key == "+g"){
      this.vim.state.setmode("Vim_VisualLine")
    }

    if(this.Vim.State.StrIsInCurrentVimMode("Vim_ydc")) and (Key == "k" or Key == "^u" or Key == "^b" or Key == "g"){
      this.Vim.State.LineCopy := 1
      Send("{Shift Up}")
      this.Zero()
      this.Down()
      Send("{Shift Down}")
      this.Up()
    }
    if(this.Vim.State.StrIsInCurrentVimMode("Vim_ydc")) and (Key == "j" or Key == "^d" or Key == "^f" or Key == "+g"){
      this.Vim.State.LineCopy := 1
      Send("{Shift Up}")
      this.Zero()
      Send("{Shift Down}")
      this.Down()
    }
  }

  MoveFinalize(){
    Send("{Shift Up}")
    ydc_y := false
    if(this.Vim.State.StrIsInCurrentVimMode("ydc_y")){
      A_Clipboard := ""
      Send("^c")
      ClipWait(1)
      this.Vim.State.SetMode("Vim_Normal")
      ydc_y := true
    }else if(this.Vim.State.StrIsInCurrentVimMode("ydc_d")){
      A_Clipboard := ""
      Send("^x")
      ClipWait(1)
      this.Vim.State.SetMode("Vim_Normal")
    }else if(this.Vim.State.StrIsInCurrentVimMode("ydc_c")){
      A_Clipboard := ""
      Send("^x")
      ClipWait(1)
      this.Vim.State.SetMode("Insert")
    }
    this.Vim.State.SetMode("", 0, 0)
    if(ydc_y){
      Send("{Left}{Right}")
    }
    ; Sometimes, when using `c`, the control key would be stuck down afterwards.
    ; This forces it to be up again afterwards.
    send("{Ctrl Up}")
  }

  Zero(){
    if WinActive("ahk_group VimDoubleHomeGroup"){
      Send("{Home}")
    }
    Send("{Home}")
  }

  Up(n:=1){
    Loop n {
      if WinActive("ahk_group VimCtrlUpDownGroup"){
        Send("^{Up}")
      } else {
        Send("{Up}")
      }
    }
  }

  Down(n:=1){
    Loop n {
      if WinActive("ahk_group VimCtrlUpDownGroup"){
        Send("^{Down}")
      } else {
        Send("{Down}")
      }
    }
  }

  Move(Key:="", Repeat:=false){
    if(!Repeat){
      this.MoveInitialize(key)
    }

    ; Left/Right
    if(not this.Vim.State.StrIsInCurrentVimMode("Line")){
      ; For some cases, need '+' directly to continue to select
      ; especially for cases using shift as original keys
      ; For now, caret does not work even add + directly

      ; 1 character
      if(Key == "h"){
        if WinActive("ahk_group VimQdir"){
          Send("{BackSpace down}{BackSpace up}")
        }
        else {
          Send("{Left}")
        }
      }else if(Key == "l"){
        if WinActive("ahk_group VimQdir"){
          Send("{Enter}")
        }
        else {
          Send("{Right}")
        }
      ; Home/End
      }else if(Key == "0"){
        this.Zero()
      }else if(Key == "$"){
        if(this.shift == 1){
          Send("+{End}")
        }else{
          Send("{End}")
        }
      }else if(Key == "^"){
        if(this.shift == 1){
          if WinActive("ahk_group VimCaretMove"){
            Send("+{Home}")
            Send("+^{Right}")
            Send("+^{Left}")
          }else{
            Send("+{Home}")
          }
        }else{
          if WinActive("ahk_group VimCaretMove"){
            Send("{Home}")
            Send("^{Right}")
            Send("^{Left}")
          }else{
            Send("{Home}")
          }
        }
      ; Words
      }else if(Key == "w"){
        if(this.shift == 1){
          Send("+^{Right}")
        }else{
          Send("^{Right}")
        }
      }else if(Key == "e"){
        if(this.shift == 1){
          if(this.Vim.CheckChr(" ")){
            Send("+^{Right}")
          }
          Send("+^{Right}+{Left}")
        }else{
          if(this.Vim.CheckChr(" ")){
            Send("^{Right}")
          }
          Send("^{Right}{Left}")
        }
      }else if(Key == "b"){
        if(this.shift == 1){
          Send("+^{Left}")
        }else{
          Send("^{Left}")
        }
      }
    }
    ; Up/Down 1 character
    if(Key == "j"){
      this.Down()
    }else if(Key="k"){
      this.Up()
    ; Page Up/Down
    n := 10
    }else if(Key == "^u"){
      this.Up(10)
    }else if(Key == "^d"){
      this.Down(10)
    }else if(Key == "^b"){
      Send("{PgUp}")
    }else if(Key == "^f"){
      Send("{PgDn}")
    }else if(Key == "g"){
      Send("^{Home}")
    }else if(Key == "+g"){
      Send("^{End}{Home}")
    }

    if(!Repeat){
      this.MoveFinalize()
    }
  }

  Repeat(Key:=""){
    this.MoveInitialize(Key)
    if(this.Vim.State.n == 0){
      this.Vim.State.n := 1
    }
    Loop this.Vim.State.n {
      this.Move(Key, true)
    }
    this.MoveFinalize()
  }

  YDCMove(){
    this.Vim.State.LineCopy := 1
    this.Zero()
    Send("{Shift Down}")
    if(this.Vim.State.n == 0){
      this.Vim.State.n := 1
    }
    this.Down(this.Vim.State.n - 1)
    Send("{End}")
    if not WinActive("ahk_group VimLBSelectGroup"){
      this.Move("l")
    }else{
      this.Move("")
    }
  }

  Inner(Key:=""){
    if(Key == "w"){
      this.Move("b", true)
      this.Move("w", false)
    }
  }
}
