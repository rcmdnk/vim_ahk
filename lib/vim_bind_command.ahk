#If WinActive("ahk_group " . VimConfObj.GroupName) and (VimState.Mode == "Vim_Normal")
:::VimState.SetMode("Command") ;(:)
`;::VimState.SetMode("Command") ;(;)
#If WinActive("ahk_group " . VimConfObj.GroupName) and (VimState.Mode == "Command")
w::VimState.SetMode("Command_w")
q::VimState.SetMode("Command_q")
h::
  Send, {F1}
  VimState.SetMode("Vim_Normal")
Return

#If WinActive("ahk_group " . VimConfObj.GroupName) and (VimState.Mode == "Command_w")
Return::
  Send, ^s
  VimState.SetMode("Vim_Normal")
Return

q::
  Send, ^s
  Send, !{F4}
  VimState.SetMode("Insert")
Return

Space::
  Send, !fa
  VimState.SetMode("Insert")
Return

#If WinActive("ahk_group " . VimConfObj.GroupName) and (VimState.Mode == "Command_q")
Return::
  Send, !{F4}
  VimState.SetMode("Insert")
Return
