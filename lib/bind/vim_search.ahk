#HotIf Vim.IsVimGroup() and (Vim.State.IsCurrentVimMode("Vim_Normal"))
/::
{
  Send("^f")
  Vim.State.SetMode("Insert")
}

*::
{
  ClipSaved := ClipboardAll()
  A_Clipboard := ""
  Send("^{Left}+^{Right}^c")
  ClipWait(1)
  Send("^f")
  Send("^v!f")
  A_Clipboard := ClipSaved
  Vim.State.SetMode("Insert")
}

n::Send("{F3}")
+n::Send("+{F3}")

#HotIf
