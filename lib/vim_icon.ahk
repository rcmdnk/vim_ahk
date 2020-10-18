class VimIcon{
  __New(){
    global VimScriptPath
    this.icons := {Normal: VimScriptPath "\..\icons\normal.ico"
                 , Insert: VimScriptPath  "\..\icons\insert.ico"
                 , Visual: VimScriptPath "\..\icons\visual.ico"
                 , Command: VimScriptPath "\..\icons\command.ico"
                 , Disabled: VimScriptPath "\..\icons\disabled.ico"
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
