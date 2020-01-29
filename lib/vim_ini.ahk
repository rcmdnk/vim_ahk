class VimIni{
  static IniDir := A_AppData . "\AutoHotkey"
  static Ini := A_AppData . "\AutoHotkey"  . "\vim_ahk.ini"
  static Section := "Vim Ahk Settings"

  ReadIni(conf){
    for k, v in conf.Conf {
      current := v["val"]
      IniRead, val, % VimIni.Ini, % VimIni.Section, %k%, %current%
      %k% := val
      v["val"] := val
    }
  }

  WriteIni(conf){
    IfNotExist, VimIni.IniDir
      FileCreateDir, VimIni.IniDir

    for k, v in conf.Conf {
      IniWrite, % v["val"], % VimIni.Ini, % VimIni.Section, %k%
    }
  }
}
