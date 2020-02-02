class VimToolTip{
  __New(vim){
    this.Vim := vim

    this.DisplayToolTipObj := ObjBindMethod(this, "DisplayToolTip")
    this.RemoveToolTipObj := ObjBindMethod(this, "RemoveToolTip")
    OnMessage(0x200, ObjBindMethod(this, "OnMouseMove"))
  }

  OnMouseMove(wp, lp, msg, hwnd){
    this.Vim.State.CurrControl := A_GuiControl
    if(this.Vim.State.CurrControl != this.Vim.State.PrevControl){
      this.Vim.State.PrevControl := this.Vim.State.CurrControl
      this.RemoveToolTip()
      if(this.Vim.Info.HasKey(this.Vim.State.CurrControl)){
        display := this.DisplayToolTipObj
        SetTimer, % display, -1000
      }
    }
    Return
  }

  DisplayToolTip(){
    display := this.DisplayToolTipObj
    SetTimer, % display, Off
    ToolTip % this.Vim.Info[this.Vim.State.CurrControl]
    this.SetRemoveToolTip(60000)
  }

  RemoveToolTip(){
    display := this.DisplayToolTipObj
    SetTimer, % display, Off
    remove := this.RemoveToolTipObj
    SetTimer, % remove, off
    ToolTip
  }

  SetRemoveToolTip(time){
    remove := this.RemoveToolTipObj
    SetTimer, % remove, % "-" time
  }
}
