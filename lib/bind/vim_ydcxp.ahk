#If WinActive("ahk_group " . Vim.GroupName) and (Vim.State.Mode == "Vim_Normal")
y::Vim.State.SetMode("Vim_ydc_y", 0, -1, 0)
d::Vim.State.SetMode("Vim_ydc_d", 0, -1, 0)
c::Vim.State.SetMode("Vim_ydc_c", 0, -1, 0)
+y::
  Vim.State.SetMode("Vim_ydc_y", 0, 0, 1)
  Sleep, 150 ; Need to wait (For variable change?)
  if WinActive("ahk_group VimDoubleHomeGroup"){
    Send, {Home}
  }
  Send, {Home}+{End}
  if not WinActive("ahk_group VimLBSelectGroup"){
    Vim.Move.Move("l")
  }else{
    Vim.Move.Move("")
  }
  Send, {Left}{Home}
Return

+d::
  Vim.State.SetMode("Vim_ydc_d", 0, 0, 0)
  if not WinActive("ahk_group VimLBSelectGroup"){
    Vim.Move.Move("$")
  }else{
    Send, {Shift Down}{End}{Left}
    Vim.Move.Move("")
  }
Return

+c::
  Vim.State.SetMode("Vim_ydc_c",0,0,0)
  if not WinActive("ahk_group VimLBSelectGroup"){
    Vim.Move.Move("$")
  }else{
    Send, {Shift Down}{End}{Left}
    Vim.Move.Move("")
  }
Return

#If WinActive("ahk_group " . Vim.GroupName) and (Vim.State.Mode == "Vim_ydc_y")
y::
  Vim.State.LineCopy := 1
  if WinActive("ahk_group VimDoubleHomeGroup"){
    Send, {Home}
  }
  Send, {Home}+{End}
  if not WinActive("ahk_group VimLBSelectGroup"){
    Vim.Move.Move("l")
  }else{
    Vim.Move.Move("")
  }
  Send, {Left}{Home}
Return

#If WinActive("ahk_group " . Vim.GroupName) and (Vim.State.Mode == "Vim_ydc_d")
d::
  Vim.State.LineCopy := 1
  if WinActive("ahk_group DoubleHome"){
    Send, {Home}
  }
  Send, {Home}+{End}
  if not WinActive("ahk_group VimLBSelectGroup"){
    Vim.Move.Move("l")
  }else{
    Vim.Move.Move("")
  }
Return

#If WinActive("ahk_group " . Vim.GroupName) and (Vim.State.Mode == "Vim_ydc_c")
c::
  Vim.State.LineCopy := 1
  if WinActive("ahk_group DoubleHome"){
    Send, {Home}
  }
  Send, {Home}+{End}
  if not WinActive("ahk_group VimLBSelectGroup"){
    Vim.Move.Move("l")
  }else{
    Vim.Move.Move("")
  }
Return

#If WinActive("ahk_group " . Vim.GroupName) and (Vim.State.Mode == "Vim_Normal")
x::Send, {Delete}
+x::Send, {BS}

; Paste
#If WinActive("ahk_group " . Vim.GroupName) and (Vim.State.Mode == "Vim_Normal")
p::
  ;i:=0
  ;;Send, {p Up}
  ;Loop {
  ;  if !GetKeyState("p", "P"){
  ;    break
  ;  }
  ;  if(Vim.State.LineCopy == 1){
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
  if(Vim.State.LineCopy == 1){
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
  if(Vim.State.LineCopy == 1){
    Send, {Up}{End}{Enter}^v{BS}{Home}
  }else{
    Send, ^v
    ;Send,^{Left}
  }
  KeyWait, p
Return
