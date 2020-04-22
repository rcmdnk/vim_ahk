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
