﻿#HotIf Vim.IsVimGroup() and (Vim.State.IsCurrentVimMode("Vim_Normal"))
; Undo/Redo
u::Send("^z")
^r::Send("^y")

; Combine lines
+j:: Send("{End}{Space}{Delete}")

; Change case
~::
{
  ClipSaved := ClipboardAll()
  A_Clipboard := ""
  Send("+{Right}^x")
  ClipWait(1)
  if(A_Clipboard is lower){
    StringUpper, A_Clipboard, A_Clipboard
  }else if(Clipboard is upper){
    StringLower, A_Clipboard, A_Clipboard
  }
  Send("^v")
  A_Clipboard := ClipSaved
}

; period
.::Send, +^{Right}{BS}^v

+z::Vim.State.SetMode("Z")
#HotIf Vim.IsVimGroup() and (Vim.State.IsCurrentVimMode("Z"))
+z::
{
  Send("^s")
  Send("!{F4}")
  Vim.State.SetMode("Vim_Normal")
}

+q::
{
  Send("!{F4}")
  Vim.State.SetMode("Vim_Normal")
}

; Q-dir
#HotIf Vim.IsVimGroup() and WinActive("ahk_group VimQdir") and (Vim.State.Mode == "Vim_Normal")
; For Q-dir, ^X mapping does not work, use !X instead.
; ^X does not work to be sent, too, use Down/Up
; switch to left top (1), right top (2), left bottom (3), right bottom (4)
!u::Send("{LControl Down}{1 Down}{1 Up}{LControl Up}")
!i::Send("{LControl Down}{2 Down}{2 Up}{LControl Up}")
!j::Send("{LControl Down}{3 Down}{3 Up}{LControl Up}")
!k::Send("{LControl Down}{4 Down}{4 Up}{LControl Up}")
; Ctrl+q, menu Quick-links
'::Send("{LControl Down}{q Down}{q Up}{LControl Up}")
; Keep the e key in Normal mode, use the right button and then press the refresh (e) function, do nothing, return to the e key directly
~e::
{}

#HotIf
