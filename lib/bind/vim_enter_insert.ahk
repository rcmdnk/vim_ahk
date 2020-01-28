#If WinActive("ahk_group " . VimConfObj.GroupName) && (VimState.Mode == "Vim_Normal")
i::VimState.SetMode("Insert")

+i::
  Send, {Home}
  VimState.SetMode("Insert")
Return

a::
  Send, {Right}
  VimState.SetMode("Insert")
Return

+a::
  Send, {End}
  VimState.SetMode("Insert")
Return

o::
  Send,{End}{Enter}
  VimState.SetMode("Insert")
Return

+o::
  Send, {Up}{End}{Enter}
  VimState.SetMode("Insert")
Return
