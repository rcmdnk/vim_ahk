#HotIf Vim.IsVimGroup() and (Vim.State.IsCurrentVimMode("Vim_Normal"))
y::Vim.State.SetMode("Vim_ydc_y", 0, -1, 0)
d::Vim.State.SetMode("Vim_ydc_d", 0, -1, 0)
c::Vim.State.SetMode("Vim_ydc_c", 0, -1, 0)
+y::
{
  Vim.State.SetMode("Vim_ydc_y", 0, 0, 1)
  Sleep(150) ; Need to wait (For variable change?)
  if WinActive("ahk_group VimDoubleHomeGroup"){
    SendInput("{Home}")
  }
  SendInput("{Home}+{End}")
  if not WinActive("ahk_group VimLBSelectGroup"){
    Vim.Move.Move("l")
  }else{
    Vim.Move.Move("")
  }
  SendInput("{Left}{Home}")
}

+d::
{
  Vim.State.SetMode("Vim_ydc_d", 0, 0, 0)
  if not WinActive("ahk_group VimLBSelectGroup"){
    Vim.Move.Move("$")
  }else{
    SendInput("{Shift Down}{End}{Left}")
    Vim.Move.Move("")
  }
}

+c::
{
  Vim.State.SetMode("Vim_ydc_c",0,0,0)
  if not WinActive("ahk_group VimLBSelectGroup"){
    Vim.Move.Move("$")
  }else{
    SendInput("{Shift Down}{End}{Left}")
    Vim.Move.Move("")
  }
}

#HotIf Vim.IsVimGroup() and (Vim.State.IsCurrentVimMode("Vim_ydc_y"))
y::
{
  Vim.Move.YDCMove()
  SendInput("{Left}{Home}")
}

#HotIf Vim.IsVimGroup() and (Vim.State.IsCurrentVimMode("Vim_ydc_d"))
d::Vim.Move.YDCMove()

#HotIf Vim.IsVimGroup() and (Vim.State.IsCurrentVimMode("Vim_ydc_c"))
c::Vim.Move.YDCMove()

#HotIf Vim.IsVimGroup() and (Vim.State.IsCurrentVimMode("Vim_Normal"))
x::SendInput("{Delete}")
+x::SendInput("{BS}")

; Paste
#HotIf Vim.IsVimGroup() and (Vim.State.IsCurrentVimMode("Vim_Normal"))
p::
{
  ;i:=0
  ;;SendInput("{p Up}")
  ;Loop {
  ;  if !GetKeyState("p", "P"){
  ;    break
  ;  }
  ;  if(Vim.State.LineCopy == 1){
  ;    SendInput("{End}{Enter}^v{BS}{Home}")
  ;  }else{
  ;    SendInput("{Right}")
  ;    SendInput("^v")
  ;    ;Sleep(1000)
  ;    SendInput("^{Left}")
  ;  }
  ;  ;TrayTip,i,%i%,
  ;  if(i == 0){
  ;    Sleep(500)
  ;  }else if(i > 100){
  ;    MsgBox("Vim Ahk, Stop at 100!!!", "Vim Ahk")
  ;    break
  ;  }else{
  ;    Sleep(0)
  ;  }
  ;  i+=1
  ;  break
  ;}
  if(Vim.State.LineCopy == 1){
    if WinActive("ahk_group VimNoLBCopyGroup"){
      SendInput("{End}{Enter}^v{Home}")
    }else{
      SendInput("{End}{Enter}^v{BS}{Home}")
    }
  }else{
    SendInput("{Right}")
    SendInput("^v")
    ;Sleep(1000)
    SendInput("{Left}")
    ;;SendInput("^{Left}")
  }
  KeyWait("p") ; To avoid repeat, somehow it calls <C-p>, print...
}

+p::
{
  if(Vim.State.LineCopy == 1){
    SendInput("{Up}{End}{Enter}^v{BS}{Home}")
  }else{
    SendInput("^v")
    ;SendInput("^{Left}")
  }
  KeyWait("p")
}

#HotIf
