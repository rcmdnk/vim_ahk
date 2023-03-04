#If Vim.IsVimGroup()
Esc::Vim.State.HandleEsc()
^[::Vim.State.HandleCtrlBracket()
LShift & RShift::Capslock

; Send Capslock to Right control. 
; see https://www.autohotkey.com/boards/viewtopic.php?t=87992
*Capslock::
    Send {RCtrl DownR}
    KeyWait, Capslock
    Send {RCtrl Up}
    if (A_PriorKey = "Capslock") {
        Send {Esc}
    }
return

~Capslock & j::Vim.State.SetNormal()
^j::Vim.State.SetNormal()

#If Vim.IsVimGroup() and (Vim.State.IsCurrentVimMode("Insert")) and (Vim.Conf["VimJJ"]["val"] == 1)
~j up:: ; jj: go to Normal mode.
  Input, jout, I T0.1 V L1, j
  if(ErrorLevel == "EndKey:J"){
    SendInput, {BackSpace 2}
    Vim.State.SetNormal()
  }
Return

#If
