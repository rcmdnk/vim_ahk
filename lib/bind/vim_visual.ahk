; Visual Char/Block/Line
#HotIf Vim.IsVimGroup() and (Vim.State.IsCurrentVimMode("Vim_Normal"))
v::Vim.State.SetMode("Vim_VisualChar")
^v::
{
  SendInput("^b")
  Vim.State.SetMode("Vim_VisualChar")
}

+v::
{
  Vim.State.SetMode("Vim_VisualLineFirst")
  SendInput("{Home}+{Down}")
}

#HotIf Vim.IsVimGroup() and (Vim.State.StrIsInCurrentVimMode("Visual"))
v::Vim.State.SetMode("Vim_Normal")

; ydc
y::
{
  A_Clipboard := ""
  SendInput("^c")
  SendInput("{Right}")
  if WinActive("ahk_group VimCursorSameAfterSelect"){
    SendInput("{Left}")
  }
  ClipWait(1)
  if(Vim.State.StrIsInCurrentVimMode("Line")){
    Vim.State.SetMode("Vim_Normal", 0, 0, 1)
  }else{
    Vim.State.SetMode("Vim_Normal", 0, 0, 0)
  }
}

d::
{
  A_Clipboard := ""
  SendInput("^x")
  ClipWait(1)
  if(Vim.State.StrIsInCurrentVimMode("Line")){
    Vim.State.SetMode("Vim_Normal", 0, 0, 1)
  }else{
    Vim.State.SetMode("Vim_Normal", 0, 0, 0)
  }
}

x::
{
  A_Clipboard := ""
  SendInput("^x")
  ClipWait(1)
  if(Vim.State.StrIsInCurrentVimMode("Line")){
    Vim.State.SetMode("Vim_Normal", 0, 0, 1)
  }else{
    Vim.State.SetMode("Vim_Normal", 0, 0, 0)
  }
}

c::
{
  A_Clipboard := ""
  SendInput("^x")
  ClipWait(1)
  if(Vim.State.StrIsInCurrentVimMode("Line")){
    Vim.State.SetMode("Insert", 0, 0, 1)
  }else{
    Vim.State.SetMode("Insert", 0, 0, 0)
  }
}

*::
{
  ClipSaved := ClipboardAll()
  A_Clipboard := ""
  SendInput("^c")
  ClipWait(1)
  SendInput("^f")
  SendInput("^v!f")
  A_Clipboard := ClipSaved
  Vim.State.SetMode("Vim_Normal")
}

#HotIf
