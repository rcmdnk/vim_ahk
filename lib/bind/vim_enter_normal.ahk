#If WinActive("ahk_group " . Vim.GroupName)
Esc::VimHandleEsc()  ; Just send Esc at converting, long press for normal Esc.
^[::Vim.State.SetNormal()
VimHandleEsc(){
  KeyWait, Esc, T0.5
  LongPress := ErrorLevel
  global Vim, VimLongEscNormal
  SetNormal := VimLongEscNormal
  if (!LongPress){
    SetNormal := !SetNormal
  }
  if (SetNormal){
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
