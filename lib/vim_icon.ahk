class VimIcon{
  static Icons := {Normal: A_LineFile "\..\..\icons\normal.ico"
                 , Insert: A_LineFile  "\..\..\icons\insert.ico"
                 , Visual: A_LineFile "\..\..\icons\visual.ico"
                 , Command: A_LineFile "\..\..\icons\command.ico"
                 , Disabled: A_LineFile "\..\..\icons\disabled.ico"
                 , Default: A_AhkPath}
  SetIcon(Mode="", Interval=0){
    icon :=
    if (Interval == 0){
      icon := VimIcon.Icons["Default"]
    }else if InStr(Mode, "Normal"){
      icon := VimIcon.Icons["Normal"]
    }else if InStr(Mode, "Insert"){
      icon := VimIcon.Icons["Insert"]
    }else if InStr(Mode, "Visual"){
      icon := VimIcon.Icons["Visual"]
    }else if InStr(Mode, "Command"){
      icon := VimIcon.Icons["Command"]
    }else if InStr(Mode, "Disabled"){
      icon := VimIcon.Icons["Disabled"]
    }
    if FileExist(icon){
      Menu, Tray, Icon, % icon
      if(icon != VimIcon.Icons["Default"]){
        Menu, VimSubMenu, Icon, Status, % icon
      }
    }
  }
}
