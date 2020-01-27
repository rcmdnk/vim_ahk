; Launch Settings
#If
^!+v::
  VimSetting.Menu()
Return

; Check Mode
#If WinActive("ahk_group " . VimConfObj.GroupName)
^!+c::
  VimState.CheckMode(VimConfObj.Verbose.Length(), VimState.Mode)
Return
