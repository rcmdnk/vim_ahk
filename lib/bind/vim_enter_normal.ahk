#If WinActive("ahk_group " . Vim.GroupName)
Esc::VimHandleEsc()
^[::Vim.State.SetNormal()
VimHandleEsc(){
  ; The keywait waits for esc to be released. If it doesn't detect a release
  ; within the time limit, sets errorlevel to 1.
  KeyWait, Esc, T0.5
  LongPress := ErrorLevel
  if (LongPress){
    ; Have to ensure the key has been released.
    KeyWait, Esc
  }
  global Vim, VimLongEscNormal
  SetNormal := VimLongEscNormal
  if (VimLongEscNormal) {
    if (LongPress){
      Vim.State.SetNormal()
    } else {
      Send,{Esc}
    }
  } else {
    if (LongPress){
      Send,{Esc}
    }else{
      Vim.State.SetNormal()
    }
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
