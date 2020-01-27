class VimState{
  static Mode := "Insert"
  static g := 0
  static n := 0
  static LineCopy := 0
  static LastIME := 0
  static CurrControl := ""
  static PrevControl := ""

  CheckMode(verbose=1, Mode="", g=0, n=0, LineCopy=-1, force=0){
    if(force == 0) and ((verbose <= 1) or ((Mode == "") and (g == 0) and (n == 0) and (LineCopy == -1))){
      Return
    }else if(verbose == 2){
      VimState.Status(VimState.Mode, 1) ; 1 sec is minimum for TrayTip
    }else if(verbose == 3){
      VimState.Status(VimState.Mode "`r`ng=" VimState.g "`r`nn=" VimState.n "`r`nLineCopy=" VimState.LineCopy, 4)
    }
    if(verbose >= 4){
      Msgbox, , Vim Ahk, % "Mode: " . VimState.Mode . "`nVim_g: " . VimState.g . "`nVim_n: " . VimState.n . "`nVimLineCopy: " . VimState.LineCopy
    }
    Return
  }

  Status(Title, lines=1){
    WinGetPos, , , W, H, A
    ToolTip, %Title%, W - 110, H - 30 - (lines) * 20
    SetTimer, VimRemoveStatus, 1000
  }

  FullStatus(){
    VimState.CheckMode(4, , , , 1)
  }
}

VimRemoveStatus(){
  SetTimer, VimRemoveStatus, off
  ToolTip
}

VimStatusCheckTimer(){
  global VimConfObj
  if WinActive("ahk_group " . VimConfObj.GroupName)
  {
    VimIconMng.SetIcon(VimState.Mode, VimConfObj.Conf["VimIcon"]["val"])
  }else{
    VimIconMng.SetIcon("Disabled", VimConfObj.Conf["VimIcon"]["val"])
  }
}

