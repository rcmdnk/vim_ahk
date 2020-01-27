class VimMove{
  Move(key=""){
    shift = 0
    if(VimState.StrIsInCurrentVimMode( "Visual") or VimState.StrIsInCurrentVimMode( "ydc")){
      shift := 1
    }
    if(shift == 1){
      Send, {Shift Down}
    }
    ; Left/Right
    if(not VimState.StrIsInCurrentVimMode( "Line")){
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
    if(VimState.Mode == "Vim_VisualLineFirst") and (key == "k" or key == "^u" or key == "^b" or key == "g"){
      Send, {Shift Up}{End}{Home}{Shift Down}{Up}
      VimState.SetMode("Vim_VisualLine")
    }
    if(VimState.StrIsInCurrentVimMode( "Vim_ydc")) and (key == "k" or key == "^u" or key == "^b" or key == "g"){
      VimState.LineCopy := 1
      Send,{Shift Up}{Home}{Down}{Shift Down}{Up}
    }
    if(VimState.StrIsInCurrentVimMode("Vim_ydc")) and (key == "j" or key == "^d" or key == "^f" or key == "+g"){
      VimState.LineCopy := 1
      Send,{Shift Up}{Home}{Shift Down}{Down}
    }

    ; 1 character
    if(key == "j"){
      ; Only for OneNote of less than windows 10?
      if WinActive("ahk_group VimOneNoteGroup"){
        Send ^{Down}
      } else {
        Send,{Down}
      }
    }else if(key="k"){
      if WinActive("ahk_group VimOneNoteGroup"){
        Send ^{Up}
      }else{
        Send,{Up}
      }
    ; Page Up/Down
    }else if(key == "^u"){
      Send, {Up 10}
    }else if(key == "^d"){
      Send, {Down 10}
    }else if(key == "^b"){
      Send, {PgUp}
    }else if(key == "^f"){
      Send, {PgDn}
    }else if(key == "g"){
      Send, ^{Home}
    }else if(key == "+g"){
      ;Send, ^{End}{Home}
      Send, ^{End}
    }
    Send,{Shift Up}

    if(VimState.Mode == "Vim_ydc_y"){
      Clipboard :=
      Send, ^c
      ClipWait, 1
      VimState.SetMode("Vim_Normal")
    }else if(VimState.Mode == "Vim_ydc_d"){
      Clipboard :=
      Send, ^x
      ClipWait, 1
      VimState.SetMode("Vim_Normal")
    }else if(VimState.Mode == "Vim_ydc_c"){
      Clipboard :=
      Send, ^x
      ClipWait, 1
      VimState.SetMode("Insert")
    }
    VimState.SetMode("", 0, 0)
  }
  Repeat(key=""){
    if(VimState.n == 0){
      VimState.n := 1
    }
    Loop, % VimState.n {
      VimMove.Move(key)
    }
  }
}
