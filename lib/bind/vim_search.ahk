#HotIf Vim.IsVimGroup() and (Vim.State.IsCurrentVimMode("Vim_Normal"))
/::
{
  SendInput("^f")
  Vim.State.SetMode("Insert")
}

*::
{
  ClipSaved := ClipboardAll()
  A_Clipboard := ""
  SendInput("^{Left}+^{Right}^c")
  ClipWait(1)
  SendInput("{Right}")
  SendInput("^f^v{Enter}")
  Sleep(150)
  A_Clipboard := ClipSaved
  Vim.State.SetMode("Insert")
}

n::SendInput("{F3}")
+n::SendInput("+{F3}")

#HotIf
