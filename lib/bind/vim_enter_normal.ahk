#HotIf Vim.IsVimGroup()
Esc::Vim.State.HandleEsc()
^[::Vim.State.HandleCtrlBracket()

#HotIf Vim.IsVimGroup() and (Vim.State.IsCurrentVimMode("Insert")) and (Vim.Conf["VimJJ"]["val"] == 1)
~j up:: ; jj: go to Normal mode.
{
  jout := InputHook("jout, I T0.1 V L1", "j")
  jout.Start()
  jout.Wait()
  if(jout.Input == "EndKey:J"){
    SendInput("{BackSpace 2}")
    Vim.State.SetNormal()
  }
}

#HotIf
