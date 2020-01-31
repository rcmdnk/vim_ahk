#If WinActive("ahk_group " . Vim.GroupName) && (Vim.State.Mode == "Vim_Normal")
i::Vim.State.SetMode("Insert")

+i::
  Send, {Home}
  Vim.State.SetMode("Insert")
Return

a::
  Send, {Right}
  Vim.State.SetMode("Insert")
Return

+a::
  Send, {End}
  Vim.State.SetMode("Insert")
Return

o::
  Send,{End}{Enter}
  Vim.State.SetMode("Insert")
Return

+o::
  Send, {Up}{End}{Enter}
  Vim.State.SetMode("Insert")
Return
