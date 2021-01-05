#If WinActive("ahk_group " . Vim.GroupName) and (Vim.State.Mode == "Vim_Normal")
; Undo/Redo
u::Send,^z
^r::Send,^y

; Combine lines
+j:: Send, {End}{Space}{Delete}

; Change case
~::
  bak := ClipboardAll
  Clipboard =
  Send, +{Right}^x
  ClipWait, 1
  if(Clipboard is lower){
    StringUpper, Clipboard, Clipboard
  }else if(Clipboard is upper){
    StringLower, Clipboard, Clipboard
  }
  Send, ^v
  Clipboard := bak
Return

+z::Vim.State.SetMode("Z")
#If WinActive("ahk_group " . Vim.GroupName) and (Vim.State.Mode == "Z")
+z::
  Send, ^s
  Send, !{F4}
  Vim.State.SetMode("Vim_Normal")
Return

+q::
  Send, !{F4}
  Vim.State.SetMode("Vim_Normal")
Return

#If WinActive("ahk_group " . Vim.GroupName) and (Vim.State.Mode == "Vim_Normal")
Space::Send, {Right}

; period
.::Send, +^{Right}{BS}^v

; Q-dir
#If WinActive("ahk_group VimQdir") and (Vim.State.Mode == "Vim_Normal")
; switch to left up panel
; 使用ctrl无法正常工作, 改用alt更加顺手
!u::
    Send, {LControl Down}
    Send, {1 Down}
    Send, {1 Up}
    Send, {LControl Up}
Return

; switch to right up panel
!i::
    Send, {LControl Down}
    Send, {2 Down}
    Send, {2 Up}
    Send, {LControl Up}
Return

; switch to left down panel
!j::
    Send, {LControl Down}
    Send, {3 Down}
    Send, {3 Up}
    Send, {LControl Up}
Return

; switch to right down panel
!k::
    Send, {LControl Down}
    Send, {4 Down}
    Send, {4 Up}
    Send, {LControl Up}
Return

; Ctrl+q, menu Quick-links
'::
    Send, {LControl Down}
    Send, {q Down}
    Send, {q Up}
    Send, {LControl Up}
Return
