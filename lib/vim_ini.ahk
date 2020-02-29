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
    this.Ini := dir "\" ini
    this.section := section
  }

  ReadIni(SettingsStore=""){
    if (SettingsStore = ""){
        SettingsStore := this.Vim.Conf
    }
    for k, v in SettingsStore {
      current := v["val"]
      if(current != ""){
        val := this.ReadIniValue(this.Ini, this.Section, k, current)
      }else{
        val := this.ReadIniValue(this.Ini, this.Section, k, A_Space)
      }
      %k% := val
      v["val"] := val
    }
  }

  ReadIniValue(file, iniSection, key, default_=""){
    IniRead, out, % file, % iniSection, % key, % default_
    return out
  }

  DeleteIniValue(key, file=this.Ini, section_=this.Section){
    IniDelete, file, section_, key
  }

  WriteIni(){
    IfNotExist, % this.IniDir
      FileCreateDir, this.IniDir

    for k, v in this.Vim.Conf {
      IniWrite, % v["val"], % this.Ini, % this.Section, % k
    }
  }
}
