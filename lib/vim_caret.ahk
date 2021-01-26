class VimCaret{
  __New(){
    global VimScriptPath
    this.caretwidths := {"Normal": 10
                 , "Visual": 10
                 , "Insert": 1
                 , "Default": 1}
  }

  SetCaret(Mode="", Interval=0){
    width :=
    if (Interval == 0){
      width := this.caretwidths["Default"]
    }else if InStr(Mode, "Normal"){
      width := this.caretwidths["Normal"]
    }else if InStr(Mode, "Visual"){
      width := this.caretwidths["Visual"]
    }else {
      width := this.caretwidths["Insert"]
    }
    SetCaretWidth(width)
  }
}

; Expects argument "width" in hex
SetCaretWidth(width){
    CARETWIDTH := width
    ; SPI = SystemParametersInfo
    SPI_SETCARETWIDTH := 0x2007
    SPIF_UPDATEINIFILE := 0x01
    SPIF_SENDCHANGE := 0x02
    fWinIni := SPIF_UPDATEINIFILE | SPIF_SENDCHANGE
    DllCall("SystemParametersInfo", UInt,SPI_SETCARETWIDTH, UInt,0, UInt,CARETWIDTH, UInt,fWinIni)
}
