; Launch Settings
#If
^!+v::
  Vim.Setting.ShowGui()
Return

; Check Mode
#If WinActive("ahk_group " . Vim.GroupName)
^!+c::
  Vim.State.CheckMode(4, Vim.State.Mode)
Return
