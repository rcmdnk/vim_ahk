#HotIf Vim.IsVimGroup()
Esc::Vim.State.HandleEsc()
^[::Vim.State.HandleCtrlBracket()

#HotIf Vim.IsVimGroup() and (Vim.State.IsCurrentVimMode("Insert")) and (Vim.Conf["VimJJ"]["val"] == 1)
~j up:: ; jj: go to Normal mode.
{
  jout := InputHook("I T0.1 V L1", "j")
  jout.Start()
  EndReason := jout.Wait()
  if(EndReason == "EndKey"){
    SendInput("{BackSpace 2}")
    Vim.State.SetNormal()
  }
}

#HotIf
