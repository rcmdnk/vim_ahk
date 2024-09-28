class VimCaret{
  __New(Vim){
    this.Vim := Vim
    this.caretwidths := Map("Normal", 10
      , "Visual", 10
      , "Insert", 1
      , "Default", 1)
  }

  SetCaret(Mode:=""){
    if (this.Vim.Conf["VimChangeCaretWidth"]["val"] == 0){
      return
    }
    Width := ""
    if this.Vim.State.IsCurrentVimMode("Vim_Normal"){
      Width := this.caretwidths["Normal"]
    }else if this.Vim.State.StrIsInCurrentVimMode("Visual"){
      Width := this.caretwidths["Visual"]
    }else if this.Vim.State.IsCurrentVimMode("Insert"){
      Width := this.caretwidths["Insert"]
    }else{
      Width := this.caretwidths["Default"]
    }
    this.SetCaretWidth(Width)
  }

  ; Expects argument "Width" in hex
  SetCaretWidth(Width){
    CARETWIDTH := Width
    ; SPI := SystemParametersInfo
    SPI_SETCARETWIDTH := 0x2007
    SPIF_UPDATEINIFILE := 0x01
    SPIF_SENDCHANGE := 0x02
    fWinIni := SPIF_UPDATEINIFILE | SPIF_SENDCHANGE
    DllCall("SystemParametersInfo", "UInt", SPI_SETCARETWIDTH, "UInt", 0, "UInt", CARETWIDTH, "UInt", fWinIni)
    ; Switch focus to another window and back to update caret Width
    this.Refocus()
  }

  Refocus(){
    ; Get ID of current active window
    hwnd := WinGetID("A")

    ; Activate desktop
    try {
      WinActivate("ahk_class Progman")
    } catch Error {
      try {
        WinActivate("ahk_class WorkerW")
      } catch Error {
      }
    }

;   ; Re-activate current window
    WinActivate("ahk_id " hwnd)
  }
}

