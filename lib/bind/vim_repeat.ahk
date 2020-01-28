#If WinActive("ahk_group " . VimConfObj.GroupName) and (VimState.StrIsInCurrentVimMode("Vim_"))
1::
2::
3::
4::
5::
6::
7::
8::
9::
  n_repeat := VimState.n*10 + A_ThisHotkey
  VimState.SetMode("", 0, n_repeat)
Return

#If WinActive("ahk_group " . VimConfObj.GroupName) and (VimState.StrIsInCurrentVimMode("Vim_")) and (VimState.n > 0)
0:: ; 0 is used as {Home} for VimState.n=0
  n_repeat := VimState.n*10 + A_ThisHotkey
  VimState.SetMode("", 0, n_repeat)
Return
