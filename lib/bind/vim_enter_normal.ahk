#If Vim.IsVimGroup()
Esc::Vim.State.HandleEsc()
^[::Vim.State.HandleCtrlBracket()
^j::Vim.State.HandleRightControl()
LShift & RShift::Capslock

SetCapsLockState Off

WaitingForCtrlInput := false
SentCtrlDownWithKey := false

*CapsLock::
	key := 
	WaitingForCtrlInput := true
	Input, key, B C L1 T1, {Esc}
	WaitingForCtrlInput := false
	if (ErrorLevel = "Max") {
		SentCtrlDownWithKey := true
		Send {Ctrl Down}%key%
	}
	KeyWait, CapsLock
	Return

*CapsLock up::
	If (SentCtrlDownWithKey) {
		Send {Ctrl Up}
		SentCtrlDownWithKey := false
	} else {
		if (A_TimeSincePriorHotkey < 1000) {
			if (WaitingForCtrlInput) {
				Send, {Esc 2}
			} else {
				Send, {Esc}
			}
		}
	}
	Return


#If Vim.IsVimGroup() and (Vim.State.IsCurrentVimMode("Insert")) and (Vim.Conf["VimJJ"]["val"] == 1)
~j up:: ; jj: go to Normal mode.
  Input, jout, I T0.1 V L1, j
  if(ErrorLevel == "EndKey:J"){
    SendInput, {BackSpace 2}
    Vim.State.SetNormal()
  }
Return

#If
