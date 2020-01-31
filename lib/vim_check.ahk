class VimCheck{
  __New(vim){
    this.Vim := vim
  }

  CheckMenu() {
    ; Additional message is necessary before checking current window.
    ; Otherwise process name cannot be retrieved...?
    Msgbox, , Vim Ahk, Checking current window...
    WinGet, process, PID, A
    WinGet, name, ProcessName, ahk_pid %process%
    WinGetClass, class, ahk_pid %process%
    WinGetTitle, title, ahk_pid %process%
    if WinActive("ahk_group " this.Vim.GroupName){
      Msgbox, 0x40, Vim Ahk,
      (
        Supported
        Process name: %name%
        Class       : %class%
        Title       : %title%
      )
    }else{
      Msgbox, 0x10, Vim Ahk,
      (
        Not supported
        Process name: %name%
        Class       : %class%
        Title       : %title%
      )
    }
  }
}

