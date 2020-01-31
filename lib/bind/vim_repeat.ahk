#If WinActive("ahk_group " . Vim.GroupName) and (Vim.State.StrIsInCurrentVimMode("Vim_"))
1::
2::
3::
4::
5::
6::
7::
8::
9::
  n_repeat := Vim.State.n*10 + A_ThisHotkey
  Vim.State.SetMode("", 0, n_repeat)
Return

#If WinActive("ahk_group " . Vim.GroupName) and (Vim.State.StrIsInCurrentVimMode("Vim_")) and (Vim.State.n > 0)
0:: ; 0 is used as {Home} for Vim.State.n=0
  n_repeat := Vim.State.n*10 + A_ThisHotkey
  Vim.State.SetMode("", 0, n_repeat)
Return
