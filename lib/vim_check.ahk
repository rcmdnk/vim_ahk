class VimCheck{
  __New(Vim){
    this.Vim := Vim
  }

  CheckMenu(ItemName, ItemPos, MyMenu) {
    ; Additional message is necessary before checking current window.
    ; Otherwise process name cannot be retrieved...?
    MsgBox("Checking current window...", "Vim Ahk")
    process := WinGetPID("A")
    name := WinGetProcessName("ahk_pid " process)
    win_class := WinGetClass("ahk_pid " process)
    title := WinGetTitle("ahk_pid " process)
    if(this.Vim.IsVimGroup()){
      MsgBox("Supported`nProcess name: " name "`nClass       : " win_class "`nTitle       : " title, "Vim Ahk", "Iconi")
    }else{
      MsgBox("Not supported`nProcess name: " name "`nClass       : " win_class "`nTitle       : " title, "Vim Ahk", "Iconx")
    }
  }
}

