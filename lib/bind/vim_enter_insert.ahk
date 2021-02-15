#If WinActive("ahk_group " . Vim.GroupName) && (Vim.State.Mode == "Vim_Normal")
i::Vim.State.SetMode("Insert")

+i::
  Send, {Home}
  Vim.State.SetMode("Insert")
Return

a::
  Send, {Right}
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
#If WinActive("ahk_group VimQdir") and (Vim.State.Mode == "Vim_Normal")
; 进入无autohotkey模式，可以通过首字母来快速定位文件/文件夹
/::Vim.State.SetMode("Insert")
; 重命名，自动进入insert模式
~F2::Vim.State.SetMode("Insert")
