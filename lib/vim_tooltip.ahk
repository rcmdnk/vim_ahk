class VimToolTip{
  DisplayToolTip(){
  }

  RemoveToolTip(){
    remove := ObjBindMethod(this, "RemoveToolTip")
    SetTimer, % remove, off
    ToolTip
  }
}
