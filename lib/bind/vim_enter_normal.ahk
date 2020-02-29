#If WinActive("ahk_group " . Vim.GroupName)
Esc::VimHandleEsc()  ; Just send Esc at converting, long press for normal Esc.
^[::VimHandleEsc()  ; Go to Normal mode (for vim) with IME off even at converting.
VimHandleEsc(){
  KeyWait, Esc, T0.5
  LongPress := ErrorLevel
  if(LongPress){
    VimEscLongPress()
  }else{
    VimEsc()
  }
}
VimEscLongPress(){
  global Vim, VimLongEscNormal
  if (VimLongEscNormal){
    Vim.State.SetNormal()
  }else{
    Send,{Esc}
  }
}
VimEsc(){
  global Vim, VimLongEscNormal
  if (!VimLongEscNormal){
    Vim.State.SetNormal()
  }else{
    Send,{Esc}
  }
}

#If WinActive("ahk_group " . Vim.GroupName) and (Vim.State.StrIsInCurrentVimMode( "Insert")) and (Vim.Conf["VimJJ"]["val"] == 1)
~j up:: ; jj: go to Normal mode.
  Input, jout, I T0.1 V L1, j
  if(ErrorLevel == "EndKey:J"){
    SendInput, {BackSpace 2}
    Vim.State.SetNormal()
  }
Return
