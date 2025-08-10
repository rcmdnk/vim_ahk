﻿; Inner mode
#HotIf Vim.IsVimGroup() and ((Vim.State.StrIsInCurrentVimMode("Vim_ydc")) or (Vim.State.IsCurrentVimMode("Vim_VisualChar")))
i::Vim.State.SetInner()

#HotIf Vim.IsVimGroup() and (Vim.State.StrIsInCurrentVimMode("Inner"))
w::Vim.Move.Inner("w")
+w::Vim.Move.Inner("w")

; gg
#HotIf Vim.IsVimGroup() and (Vim.State.StrIsInCurrentVimMode("Vim_")) and (not Vim.State.g)
g::Vim.State.SetMode("", 1)
#HotIf Vim.IsVimGroup() and (Vim.State.StrIsInCurrentVimMode("Vim_")) and (Vim.State.g)
g::Vim.Move.Move("g")

#HotIf Vim.IsVimGroup() and (Vim.State.StrIsInCurrentVimMode("Vim_"))
; 1 character
a::Vim.Move.Repeat("h")
s::Vim.Move.Repeat("j")
w::Vim.Move.Repeat("k")
d::Vim.Move.Repeat("l")
^a::Vim.Move.Repeat("h")
^s::Vim.Move.Repeat("j")
^w::Vim.Move.Repeat("k")
^d::Vim.Move.Repeat("l")
; Home/End
0::Vim.Move.Move("0")
$::Vim.Move.Move("$")
;^a::Vim.Move.Move("0") ; Emacs like
^e::Vim.Move.Move("$") ; Emacs like
^::Vim.Move.Move("^")
; Words
;w::Vim.Move.Repeat("w")
;+w::Vim.Move.Repeat("w") ; +w = w
e::Vim.Move.Repeat("e")
+e::Vim.Move.Repeat("e") ; +e = e
b::Vim.Move.Repeat("b")
+b::Vim.Move.Repeat("b") ; +b = b
; Page Up/Down
^u::Vim.Move.Repeat("^u")
;^d::Vim.Move.Repeat("^d")
^b::Vim.Move.Repeat("^b")
^f::Vim.Move.Repeat("^f")
; G
+g::Vim.Move.Move("+g")
; Space
Space::Vim.Move.Repeat("l")
#HotIf Vim.IsVimGroup() and (Vim.State.StrIsInCurrentVimMode("Vim_")) and not WinActive("ahk_group VimNonEditor")
; Enter
Enter::
{
  Vim.Move.Repeat("j")
  Vim.Move.Move("^")
}
#HotIf
