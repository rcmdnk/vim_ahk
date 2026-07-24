#HotIf Vim.IsVimGroup() and (Vim.State.IsCurrentVimMode("Vim_Normal"))
/::
{
  SendInput("^f")
  Vim.State.SearchActive := true
  Vim.State.SearchHwnd := WinGetID("A")
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
  Vim.State.SearchActive := true
  Vim.State.SearchHwnd := WinGetID("A")
  Vim.State.SetMode("Insert")
}

n::
{
  if Vim.State.HasSearchReady()
    SendInput("{F3}")
}

+n::
{
  if Vim.State.HasSearchReady()
    SendInput("+{F3}")
}

#HotIf
