#Include %A_LineFile%\..\vim_gui.ahk


class VimAbout Extends VimGui{
  __New(Vim){
    super.__New(Vim, "Vim Ahk")

    this.Version := ""
    this.Date := ""
    this.Author := ""
    this.Description := ""
    this.Homepage := ""
    this.OpenHomepageObj := ObjBindMethod(this, "OpenHomepage")
  }

  MakeGui(){
    this.Obj.Opt("-MinimizeBox -Resize")
    this.Obj.AddText(, "Vim Ahk (vim_ahk):`n" this.Description)
    this.Obj.SetFont("Underline")
    this.AddClick("Text", "Y+0 cBlue", this.Homepage, this.Vim.about.OpenHomepageObj, this.Homepage)
    this.Obj.SetFont("Norm")
    this.Obj.AddText(, "Author: " this.Author)
    this.Obj.AddText(, "Version: " this.Version)
    this.Obj.AddText("Y+0", "Last update: " this.Date)
    this.Obj.AddText(, "Script path:`n%this.Vim.ScriptPath%")
    this.Obj.AddText(, "Setting file:`n" this.Vim.Ini.Ini)
    this.AddClick("Button", "X200 W100 Default", "OK", this.OKObj)
  }

  OpenHomepage(Obj, Info){
    this.Vim.VimToolTip.RemoveToolTip()
    Run(this.Homepage)
  }
}
