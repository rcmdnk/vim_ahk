; Launch Settings
#If
^!+v::
  Vim.Setting.ShowGui()
Return

; Check Mode
#If Vim.IsVimGroup()
^!+c::
  Vim.State.CheckMode(4, Vim.State.Mode)
Return
