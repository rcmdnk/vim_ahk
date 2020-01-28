; Visual Char/Block/Line
#If WinActive("ahk_group " . VimConfObj.GroupName) and (VimState.Mode == "Vim_Normal")
v::VimState.SetMode("Vim_VisualChar")
^v::
  Send, ^b
  VimState.SetMode("Vim_VisualChar")
Return

+v::
  VimState.SetMode("Vim_VisualLineFirst")
  Send, {Home}+{Down}
Return

; ydc
#If WinActive("ahk_group " . VimConfObj.GroupName) and (VimState.StrIsInCurrentVimMode( "Visual"))
y::
  Clipboard :=
  Send, ^c
  Send, {Right}
  if WinActive("ahk_group VimCursorSameAfterSelect"){
    Send, {Left}
  }
  ClipWait, 1
  if(VimState.StrIsInCurrentVimMode( "Line")){
    VimState.SetMode("Vim_Normal", 0, 0, 1)
  }else{
    VimState.SetMode("Vim_Normal", 0, 0, 0)
  }
Return

d::
  Clipboard :=
  Send, ^x
  ClipWait, 1
  if(VimState.StrIsInCurrentVimMode("Line")){
    VimState.SetMode("Vim_Normal", 0, 0, 1)
  }else{
    VimState.SetMode("Vim_Normal", 0, 0, 0)
  }
Return

x::
  Clipboard :=
  Send, ^x
  ClipWait, 1
  if(VimState.StrIsInCurrentVimMode( "Line")){
    VimState.SetMode("Vim_Normal", 0, 0, 1)
  }else{
    VimState.SetMode("Vim_Normal", 0, 0, 0)
  }
Return

c::
  Clipboard :=
  Send, ^x
  ClipWait, 1
  if(VimState.StrIsInCurrentVimMode( "Line")){
    VimState.SetMode("Insert", 0, 0, 1)
  }else{
    VimState.SetMode("Insert", 0, 0, 0)
  }
Return

*::
  bak := ClipboardAll
  Clipboard :=
  Send, ^c
  ClipWait, 1
  Send, ^f
  Send, ^v!f
  clipboard := bak
  VimState.SetMode("Vim_Normal")
Return
; }}} Vim visual mode
