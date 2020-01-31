class VimMenu{
  __New(vim){
    this.Vim := vim
  }

  SetMenu(){
    MenuVimSetting := ObjBindMethod(this.Vim.Setting, "ShowGui")
    MenuVimCheck := ObjBindMethod(this.Vim.Check, "CheckMenu")
    MenuVimStatus := ObjBindMethod(this.Vim.State, "FullStatus")
    MenuVimAbout := ObjBindMethod(this.Vim.About, "ShowGui")
    Menu, VimSubMenu, Add, Settings, % MenuVimSetting
    Menu, VimSubMenu, Add
    Menu, VimSubMenu, Add, Vim Check, % MenuVimCheck
    Menu, VimSubMenu, Add, Status, % MenuVimStatus
    Menu, VimSubMenu, Add, About vim_ahk, % MenuVimAbout

    Menu, Tray, Add
    Menu, Tray, Add, VimMenu, :VimSubMenu
  }
}
