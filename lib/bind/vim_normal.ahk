#If WinActive("ahk_group " . VimConfObj.GroupName) and (VimState.Mode == "Vim_Normal")
; Undo/Redo
u::Send,^z
^r::Send,^y

; Combine lines
+j::Send, {Down}{Home}{BS}{Space}{Left}

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

+z::VimState.SetMode("Z")
#If WinActive("ahk_group " . VimConfObj.GroupName) and (VimState.Mode == "Z")
+z::
  Send, ^s
  Send, !{F4}
  VimState.SetMode("Vim_Normal")
Return

+q::
  Send, !{F4}
  VimState.SetMode("Vim_Normal")
Return

#If WinActive("ahk_group " . VimConfObj.GroupName) and (VimState.Mode == "Vim_Normal")
Space::Send, {Right}

; period
.::Send, +^{Right}{BS}^v
