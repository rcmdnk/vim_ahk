#If WinActive("ahk_group " . Vim.GroupName) and (Vim.State.Mode == "Vim_Normal")
/::
  Send, ^f
  Vim.State.SetMode("Insert")
Return

*::
  bak := ClipboardAll
  Clipboard=
  Send, ^{Left}+^{Right}^c
  ClipWait, 1
  Send, ^f
  Send, ^v!f
  clipboard := bak
  Vim.State.SetMode("Insert")
Return

n::Send, {F3}
+n::Send, +{F3}
