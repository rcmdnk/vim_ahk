class VimIni{
  static IniDir_Default := A_AppData "\AutoHotkey"
  static Ini_Default := "vim_ahk.ini"
  static Section_Default := "Vim Ahk Settings"

  __New(Vim, Dir:="", Ini:="", Section:=""){
    this.Vim := Vim
    if(Dir == ""){
      Dir := VimIni.IniDir_Default
    }
    if(Ini == ""){
      Ini := VimIni.Ini_Default
    }
    if(Section == ""){
      Section := VimIni.Section_Default
    }
    this.IniDir := Dir
    this.Ini := Dir "\" Ini
    this.section := Section
  }

  ReadIni(Conf:=""){
    if (Conf == ""){
        Conf := this.Vim.Conf
    }
    for k, v in Conf {
      Current := v["val"]
      if(Current != ""){
        val := IniRead(this.Ini, this.Section, k, Current)
      }else{
        val := IniRead(this.Ini, this.Section, k, A_Space)
      }
      v["val"] := val
    }
    this.ReadDeprecatedSettings()
  }

  ReadDeprecatedSettings(){
    ; Deprecate VimSD, VimJK, use VimTwoLetter
    this.DeprecatedTwoLetter("s", "d")
    this.DeprecatedTwoLetter("j", "k")
  }

  DeprecatedTwoLetter(L1, L2){
    ul1 := StrUpper(L1)
    ul2 := StrUpper(L2)
    twoLetter := "Vim" ul1 ul2
    val := IniRead(this.Ini, this.Section, twoLetter, 0)
    if (val == 1){
      if (this.Vim.Conf["VimTwoLetter"]["val"] == ""){
        this.Vim.Conf["VimTwoLetter"]["val"] := L1 L2
      }else{
        this.Vim.Conf["VimTwoLetter"]["val"] := this.Vim.Conf["VimTwoLetter"]["val"] this.Vim.GroupDel L1 L2
      }
    }
    try {
      IniDelete(this.Ini, this.Section, twoLetter)
    } catch OSError as e {
      ; pass
    }
  }

  WriteIni(){
    if not FileExist(this.IniDir)
      DirCreate(this.IniDir)

    for k, v in this.Vim.Conf {
      IniWrite(v["val"], this.Ini, this.Section, k)
    }
  }
}
