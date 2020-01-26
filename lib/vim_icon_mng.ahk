class VimIconMng{
  static Icons := {Normal: A_LineFile . "\..\..\icons\normal.ico"
                 , Insert: A_LineFile .  "\..\..\icons\insert.ico"
                 , Visual: A_LineFile . "\..\..\icons\visual.ico"
                 , Command: A_LineFile . "\..\..\icons\command.ico"
                 , Disabled: A_LineFile . "\..\..\icons\disabled.ico"
                 , Default: A_AhkPath}
  SetIcon(Mode="", TryIcon=1){
    icon :=
    if (TryIcon == 0){
      icon := VimIconMng.Icons["Default"]
    }else if InStr(Mode, "Normal"){
      icon := VimIconMng.Icons["Normal"]
    }else if InStr(Mode, "Insert"){
      icon := VimIconMng.Icons["Insert"]
    }else if InStr(Mode, "Visual"){
      icon := VimIconMng.Icons["Visual"]
    }else if InStr(Mode, "Command"){
      icon := VimIconMng.Icons["Command"]
    }else if InStr(Mode, "Disabled"){
      icon := VimIconMng.Icons["Disabled"]
    }
    if FileExist(icon){
      Menu, Tray, Icon, %icon%
      if (TryIcon == 1){
        Menu, VimSubMenu, Icon, Status, %icon%
      }
    }
  }
}
