; Launch Settings
#If
^!+v::
  VimSetting.Menu()
Return

; Check Mode
#If WinActive("ahk_group " . Vim.GroupName)
^!+c::
  Vim.State.CheckMode(Vim.Verbose.Length(), Vim.State.Mode)
Return
