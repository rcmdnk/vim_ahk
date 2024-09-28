#Include %A_LineFile%\..\vim_gui.ahk


class VimAbout Extends VimGui{
  __New(Vim){
    super.__New(Vim, "Vim Ahk")

    this.Vim := Vim

    this.Version := ""
    this.Date := ""
    this.Author := ""
    this.Description := ""
    this.Homepage := ""
    this.OpenHomepageObj := ObjBindMethod(this, "OpenHomepage")
  }

  MakeGui(){
    this.Hwnd.Opt("-MinimizeBox -Resize")
    this.Hwnd.AddText(, "Vim Ahk (vim_ahk):`n" this.Description)
    this.Hwnd.SetFont("Underline")
    this.Hwnd.AddText("Y+0 cBlue vVimHomepage", this.Homepage).OnEvent("Click", this.OpenHomepageObj)
    this.Hwnd.SetFont("Norm")
    this.Hwnd.AddText(, "Author: " this.Author)
    this.Hwnd.AddText(, "Version: " this.Version)
    this.Hwnd.AddText("Y+0", "Last update: " this.Date)
    this.Hwnd.AddText(, "Script path:`n%this.Vim.ScriptPath%")
    this.Hwnd.AddText(, "Setting file:`n" this.Vim.Ini.Ini)
    this.Hwnd.AddButton("X200 W100 Default vVimAboutOK", "OK").OnEvent("Click", this.OKObj)
    this.HwndAll.Push(this.Hwnd["VimAboutOK"])
  }

  OpenHomepage(Btn, Info){
    this.Vim.VimToolTip.RemoveToolTip()
    Run(this.Homepage)
  }
}
