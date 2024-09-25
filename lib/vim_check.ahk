class VimCheck{
  __New(vim){
    this.Vim := vim
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
      MsgBox("
      (
        Supported
        Process name: %name%
        Class       : %win_class%
        Title       : %title%
      )", "Vim Ahk", "Iconi")
    }else{
      MsgBox("
      (
        Not supported
        Process name: %name%
        Class       : %win_class%
        Title       : %title%
      )", "Vim Ahk", "Iconx")
    }
  }
}

