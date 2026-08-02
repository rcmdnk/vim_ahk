#HotIf Vim.IsVimGroup() && (Vim.State.IsCurrentVimMode("Vim_Normal"))
i::Vim.State.SetMode("Insert")

+i::
{
  SendInput("{Home}")
  Vim.State.SetMode("Insert")
}

a::
{
  if(! Vim.CheckChr("`n")){
    SendInput("{Right}")
  }
  Vim.State.SetMode("Insert")
}

+a::
{
  SendInput("{End}")
  Vim.State.SetMode("Insert")
}

o::
{
  if Vim.IsConfiguredGroup("VimShiftEnter"){
    SendInput("{End}+{Enter}")
  } else if Vim.IsConfiguredGroup("VimCtrlEnter"){
    SendInput("{End}^{Enter}")
  } else {
    SendInput("{End}{Enter}")
  }
  Vim.State.SetMode("Insert")
}

+o::
{
  if Vim.IsConfiguredGroup("VimShiftEnter"){
    SendInput("{Home}+{Enter}{Left}")
  } else if Vim.IsConfiguredGroup("VimCtrlEnter"){
    SendInput("{Home}^{Enter}{Left}")
  } else {
    SendInput("{Home}{Enter}{Left}")
  }
  Vim.State.SetMode("Insert")
}

; Q-dir
#HotIf Vim.IsVimGroup() and Vim.IsConfiguredGroup("VimQdir") and (Vim.State.Mode == "Vim_Normal")
; Enter insert mode to quickly locate the file/folder by using the first letter
/::Vim.State.SetMode("Insert")
; Enter insert mode at rename
~F2::Vim.State.SetMode("Insert")

#HotIf
