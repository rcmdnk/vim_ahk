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

  ReadIni(conf=""){
    if (conf == ""){
        conf := this.Vim.Conf
    }
    for k, v in conf {
      current := v["val"]
      if(current != ""){
        IniRead, val, % this.Ini, % this.Section, % k, % current
      }else{
        IniRead, val, % this.Ini, % this.Section, % k, % A_Space
      }
      %k% := val
      v["val"] := val
    }
    this.ReadDeprecatedSettings()
  }

  ReadDeprecatedSettings(){
    ; Deprecate VimSD, VimJK, use VimTwoLetter
    this.DeprecatedTwoLetter("s", "d")
    this.DeprecatedTwoLetter("j", "k")
  }

  DeprecatedTwoLetter(l1, l2){
    StringUpper, ul1, l1
    StringUpper, ul2, l2
    twoLetter := "Vim" ul1 ul2
    IniRead, val, % this.Ini, % this.Section, % twoLetter, 0
    if (val == 1){
      if (this.Vim.Conf["VimTwoLetter"]["val"] == ""){
        this.Vim.Conf["VimTwoLetter"]["val"] := l1 l2
      }else{
        this.Vim.Conf["VimTwoLetter"]["val"] := this.Vim.Conf["VimTwoLetter"]["val"] this.Vim.GroupDel l1 l2
      }
    }
    IniDelete, % this.Ini, % this.Section, % twoLetter
  }

  WriteIni(){
    IfNotExist, % this.IniDir
      FileCreateDir, this.IniDir

    for k, v in this.Vim.Conf {
      IniWrite, % v["val"], % this.Ini, % this.Section, % k
    }
  }
}
