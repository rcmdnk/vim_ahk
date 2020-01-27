; Auto-execute section {{{
VimConfObj := new VimConf()

Return
; }}} Auto-execute section

; Include {{{
#Include %A_LineFile%\..\lib\vim_ahk_setting.ahk
#Include %A_LineFile%\..\lib\vim_ime.ahk

#Include %A_LineFile%\..\lib\vim_about.ahk
#Include %A_LineFile%\..\lib\vim_check.ahk
#Include %A_LineFile%\..\lib\vim_conf.ahk
#Include %A_LineFile%\..\lib\vim_icon_mng.ahk
#Include %A_LineFile%\..\lib\vim_ini.ahk
#Include %A_LineFile%\..\lib\vim_menu.ahk
#Include %A_LineFile%\..\lib\vim_setting.ahk
#Include %A_LineFile%\..\lib\vim_state.ahk
; Include }}}

; Vim mode {{{

; Launch Settings {{{
#If
^!+v::
  VimSetting.Menu()
Return
; }}} Launch Settings

; Check Mode {{{
#If WinActive("ahk_group " . VimConfObj.GroupName)
^!+c::
  VimState.CheckMode(VimConfObj.Verbose.Length(), VimState.Mode)
Return
; }}} Check Mode

; Enter vim normal mode {{{
#If WinActive("ahk_group " . VimConfObj.GroupName)
Esc:: ; Just send Esc at converting, long press for normal Esc.
^[:: ; Go to Normal mode (for vim) with IME off even at converting.
  KeyWait, Esc, T0.5
  if(ErrorLevel){ ; long press to Esc
    Send,{Esc}
    Return
  }
  VimState.SetNormal()
Return

#If WinActive("ahk_group " . VimConfObj.GroupName) and (VimState.StrIsInCurrentVimMode( "Insert")) and (VimConfObj.Conf["VimJJ"]["val"] == 1)
~j up:: ; jj: go to Normal mode.
  Input, jout, I T0.1 V L1, j
  if(ErrorLevel == "EndKey:J"){
    SendInput, {BackSpace 2}
    VimState.SetNormal()
  }
Return

#If WinActive("ahk_group " . VimConfObj.GroupName) and (VimState.StrIsInCurrentVimMode( "Insert")) and (VimConfObj.Conf["VimJK"]["val"] == 1)
j & k::
k & j::
  SendInput, {BackSpace 1}
  VimState.SetNormal()
Return

#If WinActive("ahk_group " . VimConfObj.GroupName) and (VimState.StrIsInCurrentVimMode( "Insert")) and (VimConfObj.Conf["VimSD"]["val"] == 1)
s & d::
d & s::
  SendInput, {BackSpace 1}
  VimState.SetNormal()
Return
; }}} Enter vim normal mode

; Enter vim insert mode (Exit vim normal mode) {{{
#If WinActive("ahk_group " . VimConfObj.GroupName) && (VimState.Mode == "Vim_Normal")
i::VimState.SetMode("Insert")

+i::
  Send, {Home}
  VimState.SetMode("Insert")
Return

a::
  Send, {Right}
  VimState.SetMode("Insert")
Return

+a::
  Send, {End}
  VimState.SetMode("Insert")
Return

o::
  Send,{End}{Enter}
  VimState.SetMode("Insert")
Return

+o::
  Send, {Up}{End}{Enter}
  VimState.SetMode("Insert")
Return
; }}} Enter vim insert mode (Exit vim normal mode)

; Repeat {{{
#If WinActive("ahk_group " . VimConfObj.GroupName) and (VimState.StrIsInCurrentVimMode("Vim_"))
1::
2::
3::
4::
5::
6::
7::
8::
9::
  n_repeat := VimState.n*10 + A_ThisHotkey
  VimState.SetMode("", 0, n_repeat)
Return

#If WinActive("ahk_group " . VimConfObj.GroupName) and (VimState.StrIsInCurrentVimMode("Vim_")) and (VimState.n > 0)
0:: ; 0 is used as {Home} for VimState.n=0
  n_repeat := VimState.n*10 + A_ThisHotkey
  VimState.SetMode("", 0, n_repeat)
Return
; }}} Repeat

; Normal Mode Basic {{{
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
; }}} Normal Mode Basic

; Replace {{{
#If WinActive("ahk_group " . VimConfObj.GroupName) and (VimState.Mode == "Vim_Normal")
r::VimState.SetMode("r_once")
+r::VimState.SetMode("r_repeat")

#If WinActive("ahk_group " . VimConfObj.GroupName) and (VimState.Mode == "r_once")
~a::
~+a::
~b::
~+b::
~c::
~+c::
~d::
~+d::
~e::
~+e::
~f::
~+f::
~g::
~+g::
~h::
~+h::
~i::
~+i::
~j::
~+j::
~k::
~+k::
~l::
~+l::
~m::
~+m::
~n::
~+n::
~o::
~+o::
~p::
~+p::
~q::
~+q::
~r::
~+r::
~s::
~+s::
~t::
~+t::
~u::
~+u::
~v::
~+v::
~w::
~+w::
~x::
~+x::
~y::
~+y::
~z::
~+z::
~0::
~1::
~2::
~3::
~4::
~5::
~6::
~7::
~8::
~9::
~`::
~~::
~!::
~@::
~#::
~$::
~%::
~^::
~&::
~*::
~(::
~)::
~-::
~_::
~=::
~+::
~[::
~{::
~]::
~}::
~\::
~|::
~;::
~'::
~"::
~,::
~<::
~.::
~>::
~Space::
  Send, {Del}
  VimState.SetMode("Vim_Normal")
Return

::: ; ":" can't be used with "~"?
  Send, {:}{Del}
  VimState.SetMode("Vim_Normal")
Return

#If WinActive("ahk_group " . VimConfObj.GroupName) and (VimState.Mode == "r_repeat")
~a::
~+a::
~b::
~+b::
~c::
~+c::
~d::
~+d::
~e::
~+e::
~f::
~+f::
~g::
~+g::
~h::
~+h::
~i::
~+i::
~j::
~+j::
~k::
~+k::
~l::
~+l::
~m::
~+m::
~n::
~+n::
~o::
~+o::
~p::
~+p::
~q::
~+q::
~r::
~+r::
~s::
~+s::
~t::
~+t::
~u::
~+u::
~v::
~+v::
~w::
~+w::
~x::
~+x::
~y::
~+y::
~z::
~+z::
~0::
~1::
~2::
~3::
~4::
~5::
~6::
~7::
~8::
~9::
~`::
~~::
~!::
~@::
~#::
~$::
~%::
~^::
~&::
~*::
~(::
~)::
~-::
~_::
~=::
~+::
~[::
~{::
~]::
~}::
~\::
~|::
~;::
~'::
~"::
~,::
~<::
~.::
~>::
~Space::
  Send, {Del}
Return

:::
  Send, {:}{Del}
Return
; }}} Replace

; Move {{{
; g {{{
#If WinActive("ahk_group " . VimConfObj.GroupName) and (VimState.StrIsInCurrentVimMode("Vim_")) and (not VimState.g)
g::VimState.SetMode("", 1)
; }}} g

VimMove(key=""){
  shift = 0
  if(VimState.StrIsInCurrentVimMode( "Visual") or VimState.StrIsInCurrentVimMode( "ydc")){
    shift := 1
  }
  if(shift == 1){
    Send, {Shift Down}
  }
  ; Left/Right
  if(not VimState.StrIsInCurrentVimMode( "Line")){
    ; For some cases, need '+' directly to continue to select
    ; especially for cases using shift as original keys
    ; For now, caret does not work even add + directly

    ; 1 character
    if(key == "h"){
      Send, {Left}
    }else if(key == "l"){
      Send, {Right}
    ; Home/End
    }else if(key == "0"){
      Send, {Home}
    }else if(key == "$"){
      if(shift == 1){
        Send, +{End}
      }else{
        Send, {End}
      }
    }else if(key == "^"){
      if(shift == 1){
        if WinActive("ahk_group VimCaretMove"){
          Send, {Home}
          Send, ^{Right}
          Send, ^{Left}
        }else{
          Send, {Home}
        }
      }else{
        if WinActive("ahk_group VimCaretMove"){
          Send, +{Home}
          Send, +^{Right}
          Send, +^{Left}
        }else{
          Send, +{Home}
        }
      }
    ; Words
    }else if(key == "w"){
      if(shift == 1){
        Send, +^{Right}
      }else{
        Send, ^{Right}
      }
    }else if(key == "b"){
      if(shift == 1){
        Send, +^{Left}
      }else{
        Send, ^{Left}
      }
    }
  }
  ; Up/Down
  if(VimState.Mode == "Vim_VisualLineFirst") and (key == "k" or key == "^u" or key == "^b" or key == "g"){
    Send, {Shift Up}{End}{Home}{Shift Down}{Up}
    VimState.SetMode("Vim_VisualLine")
  }
  if(VimState.StrIsInCurrentVimMode( "Vim_ydc")) and (key == "k" or key == "^u" or key == "^b" or key == "g"){
    VimState.LineCopy := 1
    Send,{Shift Up}{Home}{Down}{Shift Down}{Up}
  }
  if(VimState.StrIsInCurrentVimMode("Vim_ydc")) and (key == "j" or key == "^d" or key == "^f" or key == "+g"){
    VimState.LineCopy := 1
    Send,{Shift Up}{Home}{Shift Down}{Down}
  }

  ; 1 character
  if(key == "j"){
    ; Only for OneNote of less than windows 10?
    if WinActive("ahk_group VimOneNoteGroup"){
      Send ^{Down}
    } else {
      Send,{Down}
    }
  }else if(key="k"){
    if WinActive("ahk_group VimOneNoteGroup"){
      Send ^{Up}
    }else{
      Send,{Up}
    }
  ; Page Up/Down
  }else if(key == "^u"){
    Send, {Up 10}
  }else if(key == "^d"){
    Send, {Down 10}
  }else if(key == "^b"){
    Send, {PgUp}
  }else if(key == "^f"){
    Send, {PgDn}
  }else if(key == "g"){
    Send, ^{Home}
  }else if(key == "+g"){
    ;Send, ^{End}{Home}
    Send, ^{End}
  }
  Send,{Shift Up}

  if(VimState.Mode == "Vim_ydc_y"){
    Clipboard :=
    Send, ^c
    ClipWait, 1
    VimState.SetMode("Vim_Normal")
  }else if(VimState.Mode == "Vim_ydc_d"){
    Clipboard :=
    Send, ^x
    ClipWait, 1
    VimState.SetMode("Vim_Normal")
  }else if(VimState.Mode == "Vim_ydc_c"){
    Clipboard :=
    Send, ^x
    ClipWait, 1
    VimState.SetMode("Insert")
  }
  VimState.SetMode("", 0, 0)
}
VimMoveLoop(key=""){
  if(VimState.n == 0){
    VimState.n := 1
  }
  Loop, % VimState.n {
    VimMove(key)
  }
}
#If WinActive("ahk_group " . VimConfObj.GroupName) and (VimState.StrIsInCurrentVimMode("Vim_"))
; 1 character
h::VimMoveLoop("h")
j::VimMoveLoop("j")
k::VimMoveLoop("k")
l::VimMoveLoop("l")
^h::VimMoveLoop("h")
^j::VimMoveLoop("j")
^k::VimMoveLoop("k")
^l::VimMoveLoop("l")
; Home/End
0::VimMove("0")
$::VimMove("$")
^a::VimMove("0") ; Emacs like
^e::VimMove("$") ; Emacs like
^::VimMove("^")
; Words
w::VimMoveLoop("w")
+w::VimMoveLoop("w") ; +w/e/+e are same as w
e::VimMoveLoop("w")
+e::VimMoveLoop("w")
b::VimMoveLoop("b")
+b::VimMoveLoop("b") ; +b = b
; Page Up/Down
^u::VimMoveLoop("^u")
^d::VimMoveLoop("^d")
^b::VimMoveLoop("^b")
^f::VimMoveLoop("^f")
; G
+g::VimMove("+g")
; gg
#If WinActive("ahk_group " . VimConfObj.GroupName) and (VimState.StrIsInCurrentVimMode( "Vim_")) and (VimState.g)
g::VimMove("g")
; }}} Move

; Copy/Cut/Paste (ydcxp){{{
; YDC
#If WinActive("ahk_group " . VimConfObj.GroupName) and (VimState.Mode == "Vim_Normal")
y::VimState.SetMode("Vim_ydc_y", 0, -1, 0)
d::VimState.SetMode("Vim_ydc_d", 0, -1, 0)
c::VimState.SetMode("Vim_ydc_c", 0, -1, 0)
+y::
  VimState.SetMode("Vim_ydc_y", 0, 0, 1)
  Sleep, 150 ; Need to wait (For variable change?)
  if WinActive("ahk_group VimDoubleHomeGroup"){
    Send, {Home}
  }
  Send, {Home}+{End}
  if not WinActive("ahk_group VimLBSelectGroup"){
    VimMove("l")
  }else{
    VimMove("")
  }
  Send, {Left}{Home}
Return

+d::
  VimState.SetMode("Vim_ydc_d", 0, 0, 0)
  if not WinActive("ahk_group VimLBSelectGroup"){
    VimMove("$")
  }else{
    Send, {Shift Down}{End}{Left}
    VimMove("")
  }
Return

+c::
  VimState.SetMode("Vim_ydc_c",0,0,0)
  if not WinActive("ahk_group VimLBSelectGroup"){
    VimMove("$")
  }else{
    Send, {Shift Down}{End}{Left}
    VimMove("")
  }
Return

#If WinActive("ahk_group " . VimConfObj.GroupName) and (VimState.Mode == "Vim_ydc_y")
y::
  VimState.LineCopy := 1
  if WinActive("ahk_group VimDoubleHomeGroup"){
    Send, {Home}
  }
  Send, {Home}+{End}
  if not WinActive("ahk_group VimLBSelectGroup"){
    VimMove("l")
  }else{
    VimMove("")
  }
  Send, {Left}{Home}
Return

#If WinActive("ahk_group " . VimConfObj.GroupName) and (VimState.Mode == "Vim_ydc_d")
d::
  VimState.LineCopy := 1
  if WinActive("ahk_group DoubleHome"){
    Send, {Home}
  }
  Send, {Home}+{End}
  if not WinActive("ahk_group VimLBSelectGroup"){
    VimMove("l")
  }else{
    VimMove("")
  }
Return

#If WinActive("ahk_group " . VimConfObj.GroupName) and (VimState.Mode == "Vim_ydc_c")
c::
  VimState.LineCopy := 1
  if WinActive("ahk_group DoubleHome"){
    Send, {Home}
  }
  Send, {Home}+{End}
  if not WinActive("ahk_group VimLBSelectGroup"){
    VimMove("l")
  }else{
    VimMove("")
  }
Return

#If WinActive("ahk_group " . VimConfObj.GroupName) and (VimState.Mode == "Vim_Normal")
; X
x::Send, {Delete}
+x::Send, {BS}

; Paste
#If WinActive("ahk_group " . VimConfObj.GroupName) and (VimState.Mode == "Vim_Normal")
p::
  ;i:=0
  ;;Send, {p Up}
  ;Loop {
  ;  if !GetKeyState("p", "P"){
  ;    break
  ;  }
  ;  if(VimState.LineCopy == 1){
  ;    Send, {End}{Enter}^v{BS}{Home}
  ;  }else{
  ;    Send, {Right}
  ;    Send, ^v
  ;    ;Sleep, 1000
  ;    Send, ^{Left}
  ;  }
  ;  ;TrayTip,i,%i%,
  ;  if(i == 0){
  ;    Sleep, 500
  ;  }else if(i > 100){
  ;    Msgbox, , Vim Ahk, Stop at 100!!!
  ;    break
  ;  }else{
  ;    Sleep, 0
  ;  }
  ;  i+=1
  ;  break
  ;}
  if(VimState.LineCopy == 1){
    Send, {End}{Enter}^v{BS}{Home}
  }else{
    Send, {Right}
    Send, ^v
    ;Sleep, 1000
    Send, {Left}
    ;;Send, ^{Left}
  }
  KeyWait, p ; To avoid repeat, somehow it calls <C-p>, print...
Return

+p::
  if(VimState.LineCopy == 1){
    Send, {Up}{End}{Enter}^v{BS}{Home}
  }else{
    Send, ^v
    ;Send,^{Left}
  }
  KeyWait, p
Return
; }}} Copy/Cut/Paste (ydcxp)

; Vim visual mode {{{

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

; Search {{{
#If WinActive("ahk_group " . VimConfObj.GroupName) and (VimState.Mode == "Vim_Normal")
/::
  Send, ^f
  VimState.SetMode("Insert")
Return

*::
  bak := ClipboardAll
  Clipboard=
  Send, ^{Left}+^{Right}^c
  ClipWait, 1
  Send, ^f
  Send, ^v!f
  clipboard := bak
  VimState.SetMode("Insert")
Return

n::Send, {F3}
+n::Send, +{F3}
; }}} Search

; Vim comamnd mode {{{
#If WinActive("ahk_group " . VimConfObj.GroupName) and (VimState.Mode == "Vim_Normal")
:::VimState.SetMode("Command") ;(:)
`;::VimState.SetMode("Command") ;(;)
#If WinActive("ahk_group " . VimConfObj.GroupName) and (VimState.Mode == "Command")
w::VimState.SetMode("Command_w")
q::VimState.SetMode("Command_q")
h::
  Send, {F1}
  VimState.SetMode("Vim_Normal")
Return

#If WinActive("ahk_group " . VimConfObj.GroupName) and (VimState.Mode == "Command_w")
Return::
  Send, ^s
  VimState.SetMode("Vim_Normal")
Return

q::
  Send, ^s
  Send, !{F4}
  VimState.SetMode("Insert")
Return

Space::
  Send, !fa
  VimState.SetMode("Insert")
Return

#If WinActive("ahk_group " . VimConfObj.GroupName) and (VimState.Mode == "Command_q")
Return::
  Send, !{F4}
  VimState.SetMode("Insert")
Return
; }}} Vim command mode

; Disable other keys {{{
#If WinActive("ahk_group " . VimConfObj.GroupName) and (VimState.StrIsInCurrentVimMode( "ydc") or VimState.StrIsInCurrentVimMode( "Command") or (VimState.Mode == "Z"))
*a::
*b::
*c::
*d::
*e::
*f::
*g::
*h::
*i::
*j::
*k::
*l::
*m::
*n::
*o::
*p::
*q::
*r::
*s::
*t::
*u::
*v::
*w::
*x::
*y::
*z::
0::
1::
2::
3::
4::
5::
6::
7::
8::
9::
`::
~::
!::
@::
#::
$::
%::
^::
&::
*::
(::
)::
-::
_::
=::
+::
[::
{::
]::
}::
\::
|::
:::
`;::
'::
"::
,::
<::
.::
>::
Space::
  VimState.SetMode("Vim_Normal")
Return

#If WinActive("ahk_group " . VimConfObj.GroupName) and VimState.StrIsInCurrentVimMode("Vim_") and (VimConfObj.Conf["VimDisableUnused"]["val"] == 2)
a::
b::
c::
d::
e::
f::
g::
h::
i::
j::
k::
l::
m::
n::
o::
p::
q::
r::
s::
t::
u::
v::
w::
x::
y::
z::
+a::
+b::
+c::
+d::
+e::
+f::
+g::
+h::
+i::
+j::
+k::
+l::
+m::
+n::
+o::
+p::
+q::
+r::
+s::
+t::
+u::
+v::
+w::
+x::
+y::
+z::
0::
1::
2::
3::
4::
5::
6::
7::
8::
9::
`::
~::
!::
@::
#::
$::
%::
^::
&::
*::
(::
)::
-::
_::
=::
+::
[::
{::
]::
}::
\::
|::
:::
`;::
'::
"::
,::
<::
.::
>::
Space::
Return

#If WinActive("ahk_group " . VimConfObj.GroupName) and VimState.StrIsInCurrentVimMode("Vim_") and (VimConfObj.Conf["VimDisableUnused"]["val"] == 3)
*a::
*b::
*c::
*d::
*e::
*f::
*g::
*h::
*i::
*j::
*k::
*l::
*m::
*n::
*o::
*p::
*q::
*r::
*s::
*t::
*u::
*v::
*w::
*x::
*y::
*z::
0::
1::
2::
3::
4::
5::
6::
7::
8::
9::
`::
~::
!::
@::
#::
$::
%::
^::
&::
*::
(::
)::
-::
_::
=::
+::
[::
{::
]::
}::
\::
|::
:::
`;::
'::
"::
,::
<::
.::
>::
Space::
Return
; }}} Disable other keys
; }}} Vim mode

; Reset the condition
#If

; vim: foldmethod=marker
; vim: foldmarker={{{,}}}
