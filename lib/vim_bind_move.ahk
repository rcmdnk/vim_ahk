#If WinActive("ahk_group " . VimConfObj.GroupName) and (VimState.StrIsInCurrentVimMode("Vim_")) and (not VimState.g)
g::VimState.SetMode("", 1)

#If WinActive("ahk_group " . VimConfObj.GroupName) and (VimState.StrIsInCurrentVimMode("Vim_"))
; 1 character
h::VimMove.Repeat("h")
j::VimMove.Repeat("j")
k::VimMove.Repeat("k")
l::VimMove.Repeat("l")
^h::VimMove.Repeat("h")
^j::VimMove.Repeat("j")
^k::VimMove.Repeat("k")
^l::VimMove.Repeat("l")
; Home/End
0::VimMove.Move("0")
$::VimMove.Move("$")
^a::VimMove.Move("0") ; Emacs like
^e::VimMove.Move("$") ; Emacs like
^::VimMove.Move("^")
; Words
w::VimMove.Repeat("w")
+w::VimMove.Repeat("w") ; +w/e/+e are same as w
e::VimMove.Repeat("w")
+e::VimMove.Repeat("w")
b::VimMove.Repeat("b")
+b::VimMove.Repeat("b") ; +b = b
; Page Up/Down
^u::VimMove.Repeat("^u")
^d::VimMove.Repeat("^d")
^b::VimMove.Repeat("^b")
^f::VimMove.Repeat("^f")
; G
+g::VimMove.Move("+g")
; gg
#If WinActive("ahk_group " . VimConfObj.GroupName) and (VimState.StrIsInCurrentVimMode( "Vim_")) and (VimState.g)
g::VimMove.Move("g")
; }}} Move
