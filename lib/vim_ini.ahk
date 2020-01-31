class VimIni{
  static IniDir_Default := A_AppData "\AutoHotkey"
  static Ini_Default := "vim_ahk.ini"
  static Section_Default := "Vim Ahk Settings"

  __New(vim, dir="", ini="", sec=""){
    this.Vim := vim
    if(dir == ""){
      dir := VimIni.IniDir_Default
    }
    if(ini == ""){
      ini := VimIni.Ini_Default
    }
    if(section == ""){
      section := VimIni.Section_Default
    }
    this.IniDir := dir
    this.Ini := dir "\" . ini
    this.section := section
  }

  ReadIni(){
    for k, v in this.Vim.Conf {
      current := v["val"]
      IniRead, val, % this.Ini, % this.Section, % k, % current
      %k% := val
      v["val"] := val
    }
  }

  WriteIni(){
    IfNotExist, % this.IniDir
      FileCreateDir, this.IniDir

    for k, v in this.Vim.Conf {
      IniWrite, % v["val"], % this.Ini, % this.Section, % k
    }
  }
}
