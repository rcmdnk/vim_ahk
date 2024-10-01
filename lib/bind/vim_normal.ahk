#HotIf Vim.IsVimGroup() and (Vim.State.IsCurrentVimMode("Vim_Normal"))
; Undo/Redo
u::SendInput("^z")
^r::SendInput("^y")

; Combine lines
+j:: SendInput("{End}{Space}{Delete}")

; Change case
~::
{
  ClipSaved := ClipboardAll()
  A_Clipboard := ""
  SendInput("+{Right}^x")
  ClipWait(1)
  if(isLower(A_Clipboard)){
    A_Clipboard := StrUpper(A_Clipboard)
  }else if(isUpper(A_Clipboard)){
    A_Clipboard := StrLower(A_Clipboard)
  }
  SendInput("^v")
  A_Clipboard := ClipSaved
}

; period
.::SendInput("+^{Right}{BS}^v")

; Z mode
+z::Vim.State.SetMode("Z")
#HotIf Vim.IsVimGroup() and (Vim.State.IsCurrentVimMode("Z"))

; ZZ
+z::
{
  SendInput("^s")
  SendInput("!{F4}")
  Vim.State.SetMode("Vim_Normal")
}

; ZQ
+q::
{
  SendInput("!{F4}")
  Vim.State.SetMode("Vim_Normal")
}

; Q-dir
#HotIf Vim.IsVimGroup() and WinActive("ahk_group VimQdir") and (Vim.State.Mode == "Vim_Normal")
; For Q-dir, ^X mapping does not work, use !X instead.
; ^X does not work to be sent, too, use Down/Up
; switch to left top (1), right top (2), left bottom (3), right bottom (4)
!u::SendInput("{LControl Down}{1 Down}{1 Up}{LControl Up}")
!i::SendInput("{LControl Down}{2 Down}{2 Up}{LControl Up}")
!j::SendInput("{LControl Down}{3 Down}{3 Up}{LControl Up}")
!k::SendInput("{LControl Down}{4 Down}{4 Up}{LControl Up}")
; Ctrl+q, menu Quick-links
'::SendInput("{LControl Down}{q Down}{q Up}{LControl Up}")
; Keep the e key in Normal mode, use the right button and then press the refresh (e) function, do nothing, return to the e key directly
~e::
{}

#HotIf
