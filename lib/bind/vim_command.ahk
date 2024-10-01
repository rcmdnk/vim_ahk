#HotIf Vim.IsVimGroup() and (Vim.State.IsCurrentVimMode("Vim_Normal"))
:::Vim.State.SetMode("Command") ;(:)
`;::Vim.State.SetMode("Command") ;(;)
#HotIf Vim.IsVimGroup() and (Vim.State.IsCurrentVimMode("Command"))
w::Vim.State.SetMode("Command_w")
q::Vim.State.SetMode("Command_q")
h::
{
  SendInput("{F1}")
  Vim.State.SetMode("Vim_Normal")
}

#HotIf Vim.IsVimGroup() and (Vim.State.IsCurrentVimMode("Command_w"))
Enter::
{
  SendInput("^s")
  Vim.State.SetMode("Vim_Normal")
}

q::
{
  SendInput("^s")
  SendInput("!{F4}")
  Vim.State.SetMode("Insert")
}

Space::
{
  SendInput("!fa")
  Vim.State.SetMode("Insert")
}

#HotIf Vim.IsVimGroup() and (Vim.State.IsCurrentVimMode("Command_q"))
Enter::
{
  SendInput("!{F4}")
  Vim.State.SetMode("Insert")
}

#HotIf
