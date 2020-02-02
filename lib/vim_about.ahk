class VimAbout Extends VimGui{
  __New(vim){
    this.Vim := vim

    this.Version := ""
    this.Date := ""
    this.Author := ""
    this.Description := ""
    this.Homepage := ""

    base.__New(vim, "Vim Ahk")
  }

  MakeGui(){
    Gui, % this.Hwnd ":-MinimizeBox"
    Gui, % this.Hwnd ":-Resize"
    Gui, % this.Hwnd ":Add", Text, , % "Vim Ahk (vim_ahk):`n" this.Description
    Gui, % this.Hwnd ":Font", Underline
    Gui, % this.Hwnd ":Add", Text, +HwndVimGuiAboutHomepageId Y+0 cBlue vVimHomepage, Homepage
    VimGuiAboutOpenHomepage := ObjBindMethod(this, "OpenHomepage")
    GuiControl, +G, % VimGuiAboutHomepageId, % VimGuiAboutOpenHomepage
    Gui, % this.Hwnd ":Font", Norm
    Gui, % this.Hwnd ":Add", Text, , % "Author: " this.Author
    Gui, % this.Hwnd ":Add", Text, , % "Version: " this.Version
    Gui, % this.Hwnd ":Add", Text, Y+0, % "Last update: " this.Date
    Gui, % this.Hwnd ":Add", Text, , Script path:`n%A_LineFile%
    Gui, % this.Hwnd ":Add", Text, , % "Setting file:`n" this.Vim.Ini.IniDir "\" this.Vim.Ini.Ini
    Gui, % this.Hwnd ":Add", Button, +HwndOKHwnd X200 W100 Default, &OK
    this.OKHwnd := OKHwnd
    ok := ObjBindMethod(this, "OK")
    GuiControl, +G, % OKHwnd, % ok
  }

  OpenHomepage(){
    this.Vim.VimToolTip.RemoveToolTip()
    Run % this.Homepage
  }
}
