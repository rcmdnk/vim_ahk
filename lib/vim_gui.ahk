class VimGui{
  __New(Vim, Title){
    this.Vim := Vim
    this.Obj := 0
    this.Title := Title
    this.HideObj := ObjBindMethod(this, "Hide")
    this.OKObj := ObjBindMethod(this, "OK")
  }

  Hide(Obj){
    this.Vim.VimToolTip.RemoveToolTip()
    this.Obj.Hide()
  }

  OK(Obj, Info){
    this.Hide(Obj)
  }

  AddClick(ControlType, Option, Text, Callback, ToolTipText:=""){
    Obj := this.Obj.Add(ControlType, Option, Text)
    Obj.OnEvent("Click", Callback)
    if(ToolTipText != ""){
      this.Vim.AddToolTip(Obj.Hwnd, ToolTipText)
    }
  }

  MakeGui(){
    this.AddClick("Button", "X200 W100 Default", "OK", this.OKObj)
  }

  UpdateGui(){
  }

  ShowGui(ItemName, ItemPos, MyMenu){
    if(this.Obj == 0){
      this.Obj := Gui("", this.Title)
      this.MakeGui()
      this.Obj.OnEvent("Close", this.HideObj)
      this.Obj.OnEvent("Escape", this.HideObj)
    }else{
      this.UpdateGui()
    }
    this.Obj.Show()
  }

}
