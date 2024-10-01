class VimToolTip{
  __New(Vim){
    this.Vim := Vim
    this.Info := Map()

    this.DisplayToolTipObj := ObjBindMethod(this, "DisplayToolTip")
    this.RemoveToolTipObj := ObjBindMethod(this, "RemoveToolTip")
    OnMessage(0x200, ObjBindMethod(this, "OnMouseMove"))
  }

  OnMouseMove(Wp, Lp, Msg, Hwnd){
    this.Vim.State.CurrControl := Hwnd
    if(this.Vim.State.CurrControl != this.Vim.State.PrevControl){
      this.Vim.State.PrevControl := this.Vim.State.CurrControl
      this.RemoveToolTip()
      if(this.Info.Has(this.Vim.State.CurrControl)){
        display := this.DisplayToolTipObj
        SetTimer(display, -1000)
      }
    }
  }

  DisplayToolTip(){
    display := this.DisplayToolTipObj
    SetTimer(display, 0)
    ToolTip(this.Info[this.Vim.State.CurrControl])
    this.SetRemoveToolTip(60000)
  }

  RemoveToolTip(){
    display := this.DisplayToolTipObj
    SetTimer(display, 0)
    remove := this.RemoveToolTipObj
    SetTimer(remove, 0)
    ToolTip
  }

  SetRemoveToolTip(Time){
    remove := this.RemoveToolTipObj
    SetTimer(remove, "-" Time)
  }
}
