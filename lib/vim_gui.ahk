class VimGui{
  __New(Vim, Title){
    this.Vim := Vim
    this.Hwnd := 0
    this.HwndAll := []
    this.Title := Title
    this.OKObj := ObjBindMethod(this, "OK")
  }

  ShowGui(*){
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

  OK(*){
    this.Hide()
  }

  IsThisWindow(Hwnd){
    for i, h in this.HwndAll {
      if(Hwnd == h){
        Return True
      }
    }
    Return False
  }

  OnClose(Wp, Lp, Msg, Hwnd){
    if(Wp == 0xF060 && Hwnd == this.Hwnd){
      this.Hide()
    }
  }

  OnEscape(Wp, Lp, Msg, Hwnd){
    if(Wp == 27 && this.IsThisWindow(Hwnd)){
      this.Hide()
    }
  }
}
