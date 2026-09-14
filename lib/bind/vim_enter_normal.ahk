#HotIf Vim.IsVimGroup()
Esc::Vim.State.HandleEsc()
^[::Vim.State.HandleCtrlBracket()

#HotIf Vim.IsVimGroup() and (Vim.State.IsCurrentVimMode("Insert")) and (Vim.Conf["VimJJ"]["val"] == 1)
~j up:: ; jj: go to Normal mode.
{
  JjInterval := Vim.Conf["VimJJInterval"]["val"] / 1000
  jout := InputHook("I T" JjInterval " V L1", "j")
  jout.Start()
  EndReason := jout.Wait()
  if(EndReason == "EndKey"){
    if(!VIM_IME_GET()){
      SendInput("{BackSpace 2}")
    }
    Vim.State.SetNormal()
  }
}

#HotIf
