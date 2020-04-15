#If WinActive("ahk_group " . Vim.GroupName)
Esc::VimHandleEsc()
^[::Vim.State.SetNormal()
VimHandleEsc(){
  ; The keywait waits for esc to be released. If it doesn't detect a release
  ; within the time limit, sets errorlevel to 1.
  KeyWait, Esc, T0.5
  LongPress := ErrorLevel
  global Vim, VimLongEscNormal
  ; Both or neither option
  SetNormal := (VimLongEscNormal && LongPress) || !(VimLongEscNormal || LongPress)
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

#If WinActive("ahk_group " . Vim.GroupName) and (Vim.State.StrIsInCurrentVimMode( "Insert")) and (Vim.Conf["VimJJ"]["val"] == 1)
~j up:: ; jj: go to Normal mode.
  Input, jout, I T0.1 V L1, j
  if(ErrorLevel == "EndKey:J"){
    SendInput, {BackSpace 2}
    Vim.State.SetNormal()
  }
Return
