; Launch Settings
#If
^!+v::
  Vim.Setting.ShowGui()
Return

; Check Mode
#If WinActive("ahk_group " . Vim.GroupName)
^!+c::
  Vim.State.CheckMode(Vim.Conf["VimVerbose"]["val"], Vim.State.Mode)
Return
