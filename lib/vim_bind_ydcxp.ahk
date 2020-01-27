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
    VimMove.Move("l")
  }else{
    VimMove.Move("")
  }
  Send, {Left}{Home}
Return

+d::
  VimState.SetMode("Vim_ydc_d", 0, 0, 0)
  if not WinActive("ahk_group VimLBSelectGroup"){
    VimMove.Move("$")
  }else{
    Send, {Shift Down}{End}{Left}
    VimMove.Move("")
  }
Return

+c::
  VimState.SetMode("Vim_ydc_c",0,0,0)
  if not WinActive("ahk_group VimLBSelectGroup"){
    VimMove.Move("$")
  }else{
    Send, {Shift Down}{End}{Left}
    VimMove.Move("")
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
    VimMove.Move("l")
  }else{
    VimMove.Move("")
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
    VimMove.Move("l")
  }else{
    VimMove.Move("")
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
    VimMove.Move("l")
  }else{
    VimMove.Move("")
  }
Return

#If WinActive("ahk_group " . VimConfObj.GroupName) and (VimState.Mode == "Vim_Normal")
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
