class VimMenu{
  SetMenu(NVerbose){
    MenuVimSetting := ObjBindMethod(VimSetting, "Menu")
    MenuVimCheck := ObjBindMethod(VimCheck, "Menu")
    MenuVimStatus := ObjBindMethod(VimMenu, "Status", NVerbose)
    MenuVimAbout := ObjBindMethod(VimAbout, "Menu")
    Menu, VimSubMenu, Add, Settings, % MenuVimSetting
    Menu, VimSubMenu, Add
    Menu, VimSubMenu, Add, Vim Check, % MenuVimCheck
    Menu, VimSubMenu, Add, Status, % MenuVimStatus
    Menu, VimSubMenu, Add, About vim_ahk, % MenuVimAbout

    Menu, Tray, Add
    Menu, Tray, Add, VimMenu, :VimSubMenu
  }
  Status(NVerbose){
    VimCheckMode(NVerbose, , , , 1)
  }
}
