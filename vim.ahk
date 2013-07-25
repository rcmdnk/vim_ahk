; Auto-execute section {{{
GroupAdd VimGroup, ahk_class Notepad
GroupAdd VimGroup, ahk_class WordPadClass
GroupAdd VimGroup, ahk_class TTeraPadMainForm
GroupAdd VimGroup, ahk_class CabinetWClas
GroupAdd VimGroup, 作成 ;Thunderbird, 日本語
GroupAdd VimGroup, Write: ;Thuderbird, English
GroupAdd VimGroup, ahk_class PP12FrameClass ; PowerPoint
GroupAdd VimGroup, ahk_class OpusApp ; Word

VimMode=Insert
Vim_g=0
Vim_n=0
VimLineCopy=0

Return
; }}}

; Basic Settings, HotKeys, Functions {{{
; Settings

#UseHook On ; Make it a bit slow, but can avoid infinitude loop
            ; Same as "$" for each hotkey
#InstallKeybdHook ; For checking key history
                  ; Use ~500kB memory?

#HotkeyInterval 2000 ; Hotkey inteval (default 2000 milliseconds).
#MaxHotkeysPerInterval 70 ; Max hotkeys perinterval (default 50).

; Ref for IME: http://www6.atwiki.jp/eamat/pages/17.html
; Get IME Status. 0: Off, 1: On
IME_GET(WinTitle="A")  {
  ControlGet,hwnd,HWND,,,%WinTitle%
  if (WinActive(WinTitle)) {
    ptrSize := !A_PtrSize ? 4 : A_PtrSize
    VarSetCapacity(stGTI, cbSize:=4+4+(PtrSize*6)+16, 0)
    NumPut(cbSize, stGTI,  0, "UInt")   ;   DWORD   cbSize;
    hwnd := DllCall("GetGUIThreadInfo", Uint,0, Uint,&stGTI)
        ? NumGet(stGTI,8+PtrSize,"UInt") : hwnd
  }

  Return DllCall("SendMessage"
      , UInt, DllCall("imm32\ImmGetDefaultIMEWnd", Uint,hwnd)
      , UInt, 0x0283  ;Message : WM_IME_CONTROL
      ,  Int, 0x0005  ;wParam  : IMC_GETOPENSTATUS
      ,  Int, 0)      ;lParam  : 0
}
; Get input status. 1: Converting, 2: Have converting window, 0: Others
IME_GetConverting(WinTitle="A",ConvCls="",CandCls="") {
  ; Input windows, candidate windows (Add new IME with "|")
  ConvCls .= (ConvCls ? "|" : "")                 ;--- Input Window ---
    .  "ATOK\d+CompStr"                           ; ATOK
    .  "|imejpstcnv\d+"                           ; MS-IME
    .  "|WXGIMEConv"                              ; WXG
    .  "|SKKIME\d+\.*\d+UCompStr"                 ; SKKIME Unicode
    .  "|MSCTFIME Composition"                    ; Google IME
  CandCls .= (CandCls ? "|" : "")                 ;--- Candidate Window ---
    .  "ATOK\d+Cand"                              ; ATOK
    .  "|imejpstCandList\d+|imejpstcand\d+"       ; MS-IME 2002(8.1)XP
    .  "|mscandui\d+\.candidate"                  ; MS Office IME-2007
    .  "|WXGIMECand"                              ; WXG
    .  "|SKKIME\d+\.*\d+UCand"                    ; SKKIME Unicode
 CandGCls := "GoogleJapaneseInputCandidateWindow" ; Google IME

  ControlGet,hwnd,HWND,,,%WinTitle%
  if (WinActive(WinTitle)) {
    ptrSize := !A_PtrSize ? 4 : A_PtrSize
    VarSetCapacity(stGTI, cbSize:=4+4+(PtrSize*6)+16, 0)
    NumPut(cbSize, stGTI,  0, "UInt")   ;   DWORD   cbSize;
    hwnd := DllCall("GetGUIThreadInfo", Uint,0, Uint,&stGTI)
      ? NumGet(stGTI,8+PtrSize,"UInt") : hwnd
  }

  WinGet, pid, PID,% "ahk_id " hwnd
  tmm:=A_TitleMatchMode
  SetTitleMatchMode, RegEx
  ret := WinExist("ahk_class " . CandCls . " ahk_pid " pid) ? 2
      :  WinExist("ahk_class " . CandGCls                 ) ? 2
      :  WinExist("ahk_class " . ConvCls . " ahk_pid " pid) ? 1
      :  0
  SetTitleMatchMode, %tmm%
  Return ret
}
; Set IME, SetSts=0: Off, 1: On, return 0 for success, others for non-success
IME_SET(SetSts=0, WinTitle="A")    {
  ControlGet,hwnd,HWND,,,%WinTitle%
  if(WinActive(WinTitle)){
    ptrSize := !A_PtrSize ? 4 : A_PtrSize
    VarSetCapacity(stGTI, cbSize:=4+4+(PtrSize*6)+16, 0)
    NumPut(cbSize, stGTI,  0, "UInt")   ;   DWORD   cbSize;
    hwnd := DllCall("GetGUIThreadInfo", Uint,0, Uint,&stGTI)
        ? NumGet(stGTI,8+PtrSize,"UInt") : hwnd
  }

  Return DllCall("SendMessage"
    , UInt, DllCall("imm32\ImmGetDefaultIMEWnd", Uint,hwnd)
    , UInt, 0x0283  ;Message : WM_IME_CONTROL
    ,  Int, 0x006   ;wParam  : IMC_SETOPENSTATUS
    ,  Int, SetSts) ;lParam  : 0 or 1
}

; }}}

; Vim mode {{{
#IfWInActive, ahk_group VimGroup

; Reset Modes {{{
VimSetMode(Mode="", g=0, n=0, LineCopy=-1) {
  global
  if(Mode!=""){
    VimMode=%Mode%
  }
  if (g != -1){
    Vim_g=%g%
  }
  if (n != -1){
    Vim_n=%n%
  }
  if (LineCopy!=-1) {
    VimLineCopy=%LineCopy%
  }
  VimCheckMode(2)
  Return
}
VimCheckMode(verbose=0) {
  global
  if(verbose=1){
    TrayTip,VimMode,%VimMode%,10,, ; 10 sec is minimum for TrayTip
  }else if(verbose=2){
    TrayTip,VimMode,%VimMode%`r`ng=%Vim_g%`r`nn=%Vim_n%,10,,
  }
  if(verbose=3){
    Msgbox,
    (
    VimMode: %VimMode%
    Vim_g: %Vim_g%
    Vim_n: %Vim_n%
    VimLineCopy: %VimLineCopy%
    )
  }
  Return
}
^!+c::
  VimCheckMode(3)
  Return
; }}}

; Enter vim normal mode {{{
#IfWInActive, ahk_group VimGroup
Esc:: ; Just send Esc at converting.
  if (IME_GET(A)) {
    if (IME_GetConverting(A)) {
      Send,{Esc}
    } else {
      IME_SET()
      VimSetMode("Vim_Normal")
    }
  } else {
    VimSetMode("Vim_Normal")
  }
  Return

^[:: ; Go to Normal mode (for vim) with IME off even at converting.
  if (IME_GET(A)) {
    Send,{Esc}
    Sleep 1
    IME_SET()
  }
  VimSetMode("Vim_Normal")
  Return
; }}}

; Enter vim insert mode (Exit vim normal mode) {{{
#If WInActive("ahk_group VimGroup") && (VimMode == "Vim_Normal")
i::VimSetMode("Insert")
+i::
  Send,{Home}
  VimSetMode("Insert")
  Return
a::
  Send,{Right}
  VimSetMode("Insert")
  Return
+a::
  Send,{End}
  VimSetMode("Insert")
  Return
o::
  Send,{End}{Enter}
  VimSetMode("Insert")
  Return
+o::
  Send,{Up}{End}{Enter}
  VimSetMode("Insert")
  Return
; }}}

; Repeat {{{
#If WInActive("ahk_group VimGroup") and (InStr(VimMode,"Vim_"))
1::
2::
3::
4::
5::
6::
7::
8::
9::
  n_repeat:= Vim_n*10 + A_ThisHotkey
  VimSetMode("",0,n_repeat)
  Return
#If WInActive("ahk_group VimGroup") and (InStr(VimMode,"Vim_")) and (Vim__n>0)
0:: ; 0 is used as {Home} for Vim_n=0
  n_repeat:= Vim_n*10 + A_ThisHotkey
  VimSetMode("",0,n_repeat)
  Return
; }}}

; Normal Mode Basic {{{
#If WInActive("ahk_group VimGroup") and (VimMode == "Vim_Normal")
; Undo/Redo
u::Send,^z
^r::Send,^y

; Combine lines
+j::Send,{Down}{Home}{BS}{Space}{Left}

; Change case
#If WInActive("ahk_group VimGroup") and (VimMode="Vim_Normal")
~::
  bak:=ClipboardAll
  Clipboard=
  Send,+{Right}^x
  ClipWait,1
  if Clipboard is lower
  {
    ;Msgbox, %Clipboard% is lower
    StringUpper, Clipboard, Clipboard
  }
  else if Clipboard is upper
  {
    ;Msgbox, %Clipboard% is upper
    StringLower, Clipboard, Clipboard
  }
  else
  {
    ;Msgbox, %Clipboard% is others
  }
  Send,^v
  clipboard:=bak
  return

+z::VimSetMode("Z")
#If WInActive("ahk_group VimGroup") and (VimMode="Z")
+z::
  Send,^s
  Send,!{F4}
  VimSetMode("Vim_Normal")
  Return
+q::
  Send,!{F4}
  VimSetMode("Vim_Normal")
  Return

#If WInActive("ahk_group VimGroup") and (VimMode="Vim_Normal")
Space::Send,{Right}
; }}}

; Replace {{{
#If WInActive("ahk_group VimGroup") and (VimMode="Vim_Normal")
r::VimSetMode("r_once")
+r::VimSetMode("r_repeat")
#If WInActive("ahk_group VimGroup") and (VimMode="r_once")
~*a::
~*b::
~*c::
~*d::
~*e::
~*f::
~*g::
~*h::
~*i::
~*j::
~*k::
~*l::
~*m::
~*n::
~*o::
~*p::
~*q::
~*r::
~*s::
~*t::
~*u::
~*v::
~*w::
~*x::
~*y::
~*z::
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
  VimSetMode("Vim_Normal")
  Return
::: ; ":" can't be used with "~"?
  Send,{:}{Del}
  VimSetMode("Vim_Normal")
  Return
#If WInActive("ahk_group VimGroup") and (VimMode="r_repeat")
~*a::
~*b::
~*c::
~*d::
~*e::
~*f::
~*g::
~*h::
~*i::
~*j::
~*k::
~*l::
~*m::
~*n::
~*o::
~*p::
~*q::
~*r::
~*s::
~*t::
~*u::
~*v::
~*w::
~*x::
~*y::
~*z::
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
  Send,{Del}
  Return
:::
  Send,{:}{Del}
  Return
; }}}

; Move {{{
; g {{{
#If WInActive("ahk_group VimGroup") and (InStr(VimMode,"Vim_")) and (not Vim_g)
g::VimSetMode("",1)
; }}}

VimMove(key="", shift=0){
  global
  ;msgbox, %shift%
  if (InStr(VimMode,"Visual") or InStr(VimMode,"ydc") or shift=1){
    Send,{Shift Down}
  }
  ; Left/Right
  if (not InStr(VimMode,"Line")){
    ; 1 character
    if (key="h"){
      Send,{Left}
    }else if (key="l"){
      Send,{Right}
    ; Home/End
    }else if (key="0"){
      Send,{Home}
    }else if (key="$"){
      Send,{End}
    }else if (key="^"){
      Send,{End}^{Right}
    ; Words
    }else if (key="w"){
      Send,^{Right}
    }else if (key="b"){
      Send,^{Left}
    }
  }
  ; Up/Down
  if (VimMode="Vim_VisualLineFirst") and (key="k" or key="^u" or key="^b" or key="g"){
    Send,{Shift Up}{End}{Home}{Shift Down}{Up}
    VimSetMode("Vim_VisualLine")
  }
  if (InStr(VimMode,"Vim_ydc")) and (key="k" or key="^u" or key="^b" or key="g"){
    VimLineCopy=1
    Send,{Shift Up}{Home}{Down}{Shift Down}{Up}
  }
  if (InStr(VimMode,"Vim_ydc")) and (key="k" or key="^u" or key="^b" or key="g"){
    VimLineCopy=1
    Send,{Shift Up}{Home}{Shift Down}{Down}
  }

  ; 1 character
  if (key="j"){
    Send,{Down}
  }else if (key="k"){
    Send,{Up}
  ; Page Up/Down
  }else if (key="^u"){
    Send,{Up 10}
  }else if (key="^d"){
    Send,{Down 10}
  }else if (key="^b"){
    Send,{PgUp}
  }else if (key="^f"){
    Send,{PgDn}
  }else if (key="g"){
    Send,^{Home}
  }else if (key="+g"){
    ;Send,^{End}{Home}
    Send,^{End}
  }
  Send,{Shift Up}

  if (VimMode="Vim_ydc_y"){
    Clipboard=
    Send,^c
    ClipWait,1
    VimSetMode("Vim_Normal")
  }else if (VimMode="Vim_ydc_d"){
    Clipboard=
    Send,^x
    ClipWait,1
    VimSetMode("Vim_Normal")
  }else if (VimMode="Vim_ydc_c"){
    Clipboard=
    Send,^x
    ClipWait,1
    VimSetMode("Insert")
  }
  VimSetMode("",0,0)
}
VimMoveLoop(key="", shift=0){
  global
  if (Vim_n = 0) {
    Vim_n=1
  }
  Loop, %Vim_n% {
    VimMove(key,shift)
  }
}

#If WInActive("ahk_group VimGroup") and (InStr(VimMode,"Vim_"))
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
0::VimMoveLoop("0")
$::VimMoveLoop("$")
^a::VimMoveLoop("0") ; Emacs like
^e::VimMoveLoop("$") ; Emacs like
^::VimMoveLoop("^")
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
+g::VimMoveLoop("+g")
; gg
#If WInActive("ahk_group VimGroup") and (InStr(VimMode,"Vim_")) and (Vim_g)
g::VimMoveLoop("g")
; }}} Move

; Copy/Cut/Paste (ydcxp){{{
; YDC
#If WInActive("ahk_group VimGroup") and (VimMode="Vim_Normal")
y::VimSetMode("Vim_ydc_y",0,-1,0)
d::VimSetMode("Vim_ydc_d",0,-1,0)
c::VimSetMode("Vim_ydc_c",0,-1,0)
+y::
  VimSetMode("Vim_ydc_y",0,0,1)
  Sleep,150 ; Need to wait (For variable change?)
  Send,{Home}+{End}
  VimMoveLoop("l")
  Return
+d::
  VimSetMode("Vim_ydc_d",0,0,0)
  VimMoveLoop("$")
  Return
+c::
  VimSetMode("Vim_ydc_c",0,0,0)
  VimMoveLoop("$")
  Return
#If WInActive("ahk_group VimGroup") and (VimMode="Vim_ydc_y")
y::
  VimLineCopy=1
  Send,{Home}+{End}
  VimMoveLoop("l")
  Return
#If WInActive("ahk_group VimGroup") and (VimMode="Vim_ydc_d")
d::
  VimLineCopy=1
  Send,{Home}+{End}
  VimMoveLoop("l")
  Return
#If WInActive("ahk_group VimGroup") and (VimMode="Vim_ydc_c")
c::
  VimLineCopy=1
  Send,{Home}+{End}
  VimMoveLoop("l")
  Return

#If WInActive("ahk_group VimGroup") and (VimMode="Vim_Normal")
; X
x::Send, {Delete}
+x::Send, {BS}

; Paste
#If WInActive("ahk_group VimGroup") and (VimMode="Vim_Normal")
p::
  ;i:=0
  ;;Send, {p Up}
  ;Loop {
  ;  if !GetKeyState("p", "P"){
  ;    break
  ;  }
  ;  if VimLineCopy {
  ;    Send,{End}{Enter}^v{BS}{Home}
  ;  } else {
  ;    Send,{Right}
  ;    Send,^v
  ;    ;Sleep,1000
  ;    Send,^{Left}
  ;  }
  ;  ;TrayTip,i,%i%,
  ;  if(i=0){
  ;    Sleep, 500
  ;  }else if(i>100){
  ;    Msgbox Stop at 100!!!
  ;    break
  ;  }else{
  ;    Sleep, 0
  ;  }
  ;  i+=1
  ;  break
  ;}
  if VimLineCopy {
    Send,{End}{Enter}^v{BS}{Home}
  } else {
    Send,{Right}
    Send,^v
    ;Sleep,1000
    Send,{Left}
    ;;Send,^{Left}
  }
  KeyWait, p ; To avoid repeat, somehow it calls <C-p>, print...
  Return
+p::
  if VimLineCopy {
    Send,{Up}{End}{Enter}^v{BS}{Home}
  } else {
    Send,^v
    ;Send,^{Left}
  }
  KeyWait, p
  Return
; }}} Copy/Cut/Paste (ydcxp)

; Vim visual mode {{{

; Visual Char/Block/Line
#If WInActive("ahk_group VimGroup") and (VimMode="Vim_Normal")
v::VimSetMode("Vim_VisualChar")
^v::
  Send,^b
  VimSetMode("Vim_VisualChar")
  Return
+v::
  VimSetMode("Vim_VisualLineFirst")
  Send,{Home}+{Down}
  Return
; ydc
#If WInActive("ahk_group VimGroup") and (InStr(VimMode,"Visual"))
y::
  Clipboard=
  Send,^c
  ClipWait,1
  if (InStr(VimMode,"Line")){
    VimSetMode("Vim_Normal",0,0,1)
  }else{
    VimSetMode("Vim_Normal",0,0,0)
  }
  Return
d::
  Clipboard=
  Send,^x
  ClipWait,1
  if (InStr(VimMode,"Line")){
    VimSetMode("Vim_Normal",0,0,1)
  }else{
    VimSetMode("Vim_Normal",0,0,0)
  }
  Return
x::
  Clipboard=
  Send,^x
  ClipWait,1
  if (InStr(VimMode,"Line")){
    VimSetMode("Vim_Normal",0,0,1)
  }else{
    VimSetMode("Vim_Normal",0,0,0)
  }
  Return
c::
  Clipboard=
  Send,^x
  ClipWait,1
  if (InStr(VimMode,"Line")){
    VimSetMode("Insert",0,0,1)
  }else{
    VimSetMode("Insert",0,0,0)
  }
  Return
; }}} Vim visual mode

; Search {{{
#If WInActive("ahk_group VimGroup") and (VimMode="Vim_Normal")
/::Send,^f
n::Send,{F3}
+n::Send,+{F3}
; }}} Search

; Vim comamnd mode {{{
#If WInActive("ahk_group VimGroup") and (VimMode="Vim_Normal")
:::VimSetMode("Command") ;(:)
#If WInActive("ahk_group VimGroup") and (VimMode="Command")
w::VimSetMode("Command_w")
q::VimSetMode("Command_q")
h::
  Send,{F1}
  VimSetMode("Normal")
  Return
#If WInActive("ahk_group VimGroup") and (VimMode="Command_w")
Return::
  Send,^s
  VimSetMode("Normal")
  Return
q::
  Send,^s
  Send,!{F4}
  VimSetMode("Normal")
  Return
Space::
  Send,!fa
  VimSetMode("Normal")
  Return
#If WInActive("ahk_group VimGroup") and (VimMode="Command_q")
Return::
  Send,!{F4}
  VimSetMode("Normal")
  Return
; }}} Vim command mode

; }}} Vim Mode
