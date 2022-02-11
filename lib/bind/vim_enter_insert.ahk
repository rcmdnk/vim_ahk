#If Vim.IsVimGroup() && (Vim.State.IsCurrentVimMode("Vim_Normal"))
i::Vim.State.SetMode("Insert")

+i::
  Send, {Home}
  Vim.State.SetMode("Insert")
Return

a::
  if(! Vim.CheckChr("`n")){
    Send, {Right}
  }
  Vim.State.SetMode("Insert")
Return

+a::
  Send, {End}
  Vim.State.SetMode("Insert")
Return

o::
  Send,{End}{Enter}
  Vim.State.SetMode("Insert")
Return

+o::
  Send, {Home}{Enter}{Left}
  Vim.State.SetMode("Insert")
Return

; Q-dir
#If Vim.IsVimGroup() and WinActive("ahk_group VimQdir") and (Vim.State.Mode == "Vim_Normal")
; Enter insert mode to quickly locate the file/folder by using the first letter
/::Vim.State.SetMode("Insert")
; Enter insert mode at rename
~F2::Vim.State.SetMode("Insert")

#If
