#If WinActive("ahk_group " . VimConfObj.GroupName)
Esc:: ; Just send Esc at converting, long press for normal Esc.
^[:: ; Go to Normal mode (for vim) with IME off even at converting.
  KeyWait, Esc, T0.5
  if(ErrorLevel){ ; long press to Esc
    Send,{Esc}
    Return
  }
  VimState.SetNormal()
Return

#If WinActive("ahk_group " . VimConfObj.GroupName) and (VimState.StrIsInCurrentVimMode( "Insert")) and (VimConfObj.Conf["VimJJ"]["val"] == 1)
~j up:: ; jj: go to Normal mode.
  Input, jout, I T0.1 V L1, j
  if(ErrorLevel == "EndKey:J"){
    SendInput, {BackSpace 2}
    VimState.SetNormal()
  }
Return

#If WinActive("ahk_group " . VimConfObj.GroupName) and (VimState.StrIsInCurrentVimMode( "Insert")) and (VimConfObj.Conf["VimJK"]["val"] == 1)
j & k::
k & j::
  SendInput, {BackSpace 1}
  VimState.SetNormal()
Return

#If WinActive("ahk_group " . VimConfObj.GroupName) and (VimState.StrIsInCurrentVimMode( "Insert")) and (VimConfObj.Conf["VimSD"]["val"] == 1)
s & d::
d & s::
  SendInput, {BackSpace 1}
  VimState.SetNormal()
Return
