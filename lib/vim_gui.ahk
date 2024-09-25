class VimGui{
  __New(vim, title){
    this.Vim := vim
    this.Hwnd := 0
    this.HwndAll := []
    this.Title := title
    this.OKObj := ObjBindMethod(this, "OK")
  }

  ShowGui(name, pos, mymenu){
    if(this.Hwnd == 0){
      this.Hwnd := Gui("", this.Title)
      this.HwndAll.Push(this.Hwnd)
      this.MakeGui()
      OnMessage(0x112, ObjBindMethod(this, "OnClose"))
      OnMessage(0x100, ObjBindMethod(this, "OnEscape"))
    }else{
      this.UpdateGui()
    }
    this.Hwnd.Show()
  }

  MakeGui(){
    this.Hwnd.AddButton("X200 W100 Default vGuiOK", "OK").OnEvent("Click", this.OKObj)
    this.HwndAll.Push(this.Hwnd["GuiOK"])
  }

  UpdateGui(){
  }

  Hide(){
    this.Vim.VimToolTip.RemoveToolTip()
    this.Hwnd.Hide()
  }

  OK(btn, info){
    this.Hide()
  }

  IsThisWindow(hwnd){
    for i, h in this.HwndAll {
      if(hwnd == h){
        Return True
      }
    }
    Return False
  }

  OnClose(wp, lp, msg, hwnd){
    if(wp == 0xF060 && hwnd == this.Hwnd){
      this.Hide()
    }
  }

  OnEscape(wp, lp, msg, hwnd){
    if(wp == 27 && this.IsThisWindow(hwnd)){
      this.Hide()
    }
  }
}
