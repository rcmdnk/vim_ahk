#If WinActive("ahk_group " . Vim.GroupName) and (Vim.State.Mode == "Vim_Normal")
:::Vim.State.SetMode("Command") ;(:)
`;::Vim.State.SetMode("Command") ;(;)
#If WinActive("ahk_group " . Vim.GroupName) and (Vim.State.Mode == "Command")
w::Vim.State.SetMode("Command_w")
q::Vim.State.SetMode("Command_q")
h::
  Send, {F1}
  Vim.State.SetMode("Vim_Normal")
Return

#If WinActive("ahk_group " . Vim.GroupName) and (Vim.State.Mode == "Command_w")
Return::
  Send, ^s
  Vim.State.SetMode("Vim_Normal")
Return

q::
  Send, ^s
  Send, !{F4}
  Vim.State.SetMode("Insert")
Return

Space::
  Send, !fa
  Vim.State.SetMode("Insert")
Return

#If WinActive("ahk_group " . Vim.GroupName) and (Vim.State.Mode == "Command_q")
Return::
  Send, !{F4}
  Vim.State.SetMode("Insert")
Return
