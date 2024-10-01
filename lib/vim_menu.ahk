class VimMenu{
  __New(Vim){
    this.Vim := Vim
  }

  SetMenu(){
    MenuVimSetting := ObjBindMethod(this.Vim.Setting, "ShowGui")
    MenuVimCheck := ObjBindMethod(this.Vim.Check, "CheckMenu")
    MenuVimStatus := ObjBindMethod(this.Vim.State, "FullStatus")
    MenuVimAbout := ObjBindMethod(this.Vim.About, "ShowGui")
    this.Vim.SubMenu := Menu()
    this.Vim.SubMenu.Add("Settings", MenuVimSetting)
    this.Vim.SubMenu.Add()
    this.Vim.SubMenu.Add("Vim Check", MenuVimCheck)
    this.Vim.SubMenu.Add("Status", MenuVimStatus)
    this.Vim.SubMenu.Add("About vim_ahk", MenuVimAbout)
    A_TrayMenu.Add()
    A_TrayMenu.Add("VimMenu", this.Vim.SubMenu)
  }
}
