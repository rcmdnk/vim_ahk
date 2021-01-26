class VimIcon{
  __New(vim){
    global VimScriptPath
    this.Vim := vim
    this.icons := {Normal: VimScriptPath "\..\vim_ahk_icons\normal.ico"
                 , Insert: VimScriptPath  "\..\vim_ahk_icons\insert.ico"
                 , Visual: VimScriptPath "\..\vim_ahk_icons\visual.ico"
                 , Command: VimScriptPath "\..\vim_ahk_icons\command.ico"
                 , Disabled: VimScriptPath "\..\vim_ahk_icons\disabled.ico"
                 , Default: A_AhkPath}
  }

  SetIcon(Mode="", Interval=0){
    icon :=
    if (Interval == 0){
      icon := this.icons["Default"]
    }else if InStr(Mode, "Normal"){
      icon := this.icons["Normal"]
    }else if InStr(Mode, "Insert"){
      icon := this.icons["Insert"]
    }else if InStr(Mode, "Visual"){
      icon := this.icons["Visual"]
    }else if InStr(Mode, "Command"){
      icon := this.icons["Command"]
    }else if InStr(Mode, "Disabled"){
      icon := this.icons["Disabled"]
    }
    if FileExist(icon){
      Menu, Tray, Icon, % icon
      if(icon != this.icons["Default"]){
        Menu, VimSubMenu, Icon, Status, % icon
      }
    }
  }
}
