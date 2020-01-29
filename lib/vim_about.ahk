class VimAbout{
  static Version := "v0.5.0"
  static Date := "24/Sep/2019"
  static Author := "rcmdnk"
  static Description := "Vim emulation with AutoHotkey, everywhere in Windows."
  static Homepage := "https://github.com/rcmdnk/vim_ahk"

  Menu(){
    Gui, New, % "+HwndVimGuiAbout +Label" . VimAbout.__Class . ".Menu"
    VimAbout.Destroy()
    VimAbout.VimGuiAbout := VimGuiAbout
    Gui, %VimGuiAbout%:-MinimizeBox
    Gui, %VimGuiAbout%:-Resize
    Gui, %VimGuiAbout%:Add, Text, , % "Vim Ahk (vim_ahk):`n" VimAbout.Description
    Gui, %VimGuiAbout%:Font, Underline
    Gui, %VimGuiAbout%:Add, Text, % "Y+0 cBlue g" . VimAbout.__Class . ".OpenHomepage", Homepage
    Gui, %VimGuiAbout%:Font, Norm
    Gui, %VimGuiAbout%:Add, Text, , % "Author: " VimAbout.Author
    Gui, %VimGuiAbout%:Add, Text, , % "Version: " VimAbout.Version
    Gui, %VimGuiAbout%:Add, Text, Y+0, % "Last update: " VimAbout.Date
    Gui, %VimGuiAbout%:Add, Text, , Script path:`n%A_LineFile%
    Gui, %VimGuiAbout%:Add, Text, , % "Setting file:`n" VimIni.Ini
    Gui, %VimGuiAbout%:Add, Button, +HwndVimGuiAboutOKId X200 W100 Default, &OK
    VimGuiAboutOK := ObjBindMethod(VimAbout, "MenuOK")
    GuiControl, +G, % VimGuiAboutOKId, % VimGuiAboutOK
    Gui, %VimGuiAbout%:Show, W500, Vim Ahk
  }

  Destroy(){
    if(VimAbout.VimGuiAbout != ""){
      Gui, % VimAbout.VimGuiAbout . ":Destroy"
    }
    VimAbout.VimGuiAbout := ""
  }
  MenuOK(){
    VimAbout.Destroy()
  }
  MenuClose(){
    VimAbout.Destroy()
  }
  MenuEscape(){
    VimAbout.Destroy()
  }

  OpenHomepage(){
    Run % VimAbout.Homepage
  }
}
