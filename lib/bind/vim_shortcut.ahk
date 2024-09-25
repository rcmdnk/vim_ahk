; Launch Settings
#HotIf
^!+v::
  Vim.Setting.ShowGui()
Return

; Check Mode
#HotIf Vim.IsVimGroup()
^!+c::
  Vim.State.CheckMode(4, Vim.State.Mode)
Return

; Suspend/restart
#HotIf
^!+s::
  Vim.State.ToggleEnabled()
Return

#HotIf
