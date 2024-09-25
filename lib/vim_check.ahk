class VimCheck{
  __New(vim){
    this.Vim := vim
  }

  CheckMenu() {
    ; Additional message is necessary before checking current window.
    ; Otherwise process name cannot be retrieved...?
    MsgBox("Checking current window...", "Vim Ahk")
    WinGet, process, PID, A
    WinGet, name, ProcessName, ahk_pid %process%
    WinGetClass, class, ahk_pid %process%
    WinGetTitle, title, ahk_pid %process%
    if(this.Vim.IsVimGroup()){
      MsgBox("(
        Supported
        Process name: %name%
        Class       : %class%
        Title       : %title%
      )", "Vim Ahk", "Iconi")
    }else{
      MsgBox("(
        Not supported
        Process name: %name%
        Class       : %class%
        Title       : %title%
      )", "Vim Ahk", "Iconx")
    }
  }
}

