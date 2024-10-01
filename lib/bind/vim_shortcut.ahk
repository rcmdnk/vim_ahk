; Launch Settings
#HotIf
^!+v::Vim.Setting.ShowGui()

; Check Mode
#HotIf Vim.IsVimGroup()
^!+c::Vim.State.CheckMode(4, Vim.State.Mode)

; Suspend/restart
#HotIf
^!+s::Vim.State.ToggleEnabled()

#HotIf
