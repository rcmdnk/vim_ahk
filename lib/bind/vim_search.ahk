#HotIf Vim.IsVimGroup() and (Vim.State.IsCurrentVimMode("Vim_Normal"))
/::
{
  Send("^f")
  Vim.State.SetMode("Insert")
}

*::
{
  bak := ClipboardAll
  Clipboard=
  Send("^{Left}+^{Right}^c")
  ClipWait(1)
  Send("^f")
  Send("^v!f")
  clipboard := bak
  Vim.State.SetMode("Insert")
}

n::Send("{F3}")
+n::Send("+{F3}")

#HotIf
