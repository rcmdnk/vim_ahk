#If WinActive("ahk_group " . Vim.GroupName)
Esc::Vim.State.HandleEsc()
^[::Vim.State.SetNormal()

#If WinActive("ahk_group " . Vim.GroupName) and (Vim.State.StrIsInCurrentVimMode( "Insert")) and (Vim.Conf["VimJJ"]["val"] == 1)
~j up:: ; jj: go to Normal mode.
  Input, jout, I T0.1 V L1, j
  if(ErrorLevel == "EndKey:J"){
    SendInput, {BackSpace 2}
    Vim.State.SetNormal()
  }
Return
