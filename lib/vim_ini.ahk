class VimIni{
  static IniDir := A_AppData . "\AutoHotkey"
  static Ini := A_AppData . "\AutoHotkey"  . "\vim_ahk.ini"
  static Section := "Vim Ahk Settings"

  ReadIni(){
    global VimConfObj
    for k, v in VimConfObj.Conf {
      current := v["val"]
      IniRead, val, % VimIni.Ini, % VimIni.Section, %k%, %current%
      %k% := val
      v["val"] := val
    }
  }

  WriteIni(){
    global VimConfObj
    IfNotExist, VimIni.IniDir
      FileCreateDir, VimIni.IniDir

    for k, v in VimConfObj.Conf {
      IniWrite, % v["val"], % VimIni.Ini, % VimIni.Section, %k%
    }
  }
}
