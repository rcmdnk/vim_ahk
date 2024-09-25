; Visual Char/Block/Line
#HotIf Vim.IsVimGroup() and (Vim.State.IsCurrentVimMode("Vim_Normal"))
v::Vim.State.SetMode("Vim_VisualChar")
^v::
{
  Send("^b")
  Vim.State.SetMode("Vim_VisualChar")
}

+v::
{
  Vim.State.SetMode("Vim_VisualLineFirst")
  Send("{Home}+{Down}")
}

#HotIf Vim.IsVimGroup() and (Vim.State.StrIsInCurrentVimMode("Visual"))
v::Vim.State.SetMode("Vim_Normal")

; ydc
y::
{
  Clipboard :=
  Send("^c")
  Send("{Right}")
  if WinActive("ahk_group VimCursorSameAfterSelect"){
    Send("{Left}")
  }
  ClipWait, 1
  if(Vim.State.StrIsInCurrentVimMode("Line")){
    Vim.State.SetMode("Vim_Normal", 0, 0, 1)
  }else{
    Vim.State.SetMode("Vim_Normal", 0, 0, 0)
  }
}

d::
{
  Clipboard :=
  Send("^x")
  ClipWait, 1
  if(Vim.State.StrIsInCurrentVimMode("Line")){
    Vim.State.SetMode("Vim_Normal", 0, 0, 1)
  }else{
    Vim.State.SetMode("Vim_Normal", 0, 0, 0)
  }
}

x::
{
  Clipboard :=
  Send("^x")
  ClipWait, 1
  if(Vim.State.StrIsInCurrentVimMode("Line")){
    Vim.State.SetMode("Vim_Normal", 0, 0, 1)
  }else{
    Vim.State.SetMode("Vim_Normal", 0, 0, 0)
  }
}

c::
{
  Clipboard :=
  Send("^x")
  ClipWait, 1
  if(Vim.State.StrIsInCurrentVimMode("Line")){
    Vim.State.SetMode("Insert", 0, 0, 1)
  }else{
    Vim.State.SetMode("Insert", 0, 0, 0)
  }
}

*::
{
  bak := ClipboardAll
  Clipboard :=
  Send("^c")
  ClipWait, 1
  Send("^f")
  Send("^v!f")
  clipboard := bak
  Vim.State.SetMode("Vim_Normal")
}

#HotIf
