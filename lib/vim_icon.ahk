class VimIcon{
  __New(Vim){
    this.Vim := Vim
    this.icons := Map("Normal", this.Vim.ScriptPath "\..\vim_ahk_icons\normal.ico"
      , "Insert", this.Vim.ScriptPath  "\..\vim_ahk_icons\insert.ico"
      , "Visual", this.Vim.ScriptPath "\..\vim_ahk_icons\visual.ico"
      , "Command", this.Vim.ScriptPath "\..\vim_ahk_icons\command.ico"
      , "Disabled", this.Vim.ScriptPath "\..\vim_ahk_icons\disabled.ico"
      , "Default", A_AhkPath)
  }

  SetIcon(Mode:="", Interval:=0){
    icon := ""
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
      TraySetIcon(icon)
      if(icon != this.icons["Default"]){
        this.Vim.SubMenu.SetIcon("Status", icon)
      }
    }
  }
}
