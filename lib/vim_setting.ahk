class VimSetting{
  Menu(){
    global
    local created, i, k, y, disableUnused, matchmode, matchmodefs, verbose, ok, reset, cancel
    Gui, New, % "+HwndVimGuiSetting +Label" . VimSetting.__Class . ".Menu"
    VimSetting.VimGuiSetting := VimGuiSetting
    Gui, %VimGuiSetting%:-MinimizeBox
    Gui, %VimGuiSetting%:-Resize
    created := 0
    for i, k in VimConfObj.Checkboxes {
      if(created == 0){
        y := "YM"
      }else{
        y := "Y+10"
      }
      Gui, %VimGuiSetting%:Add, Checkbox, XM+10 %y% v%k%, % VimConfObj.Conf[k]["description"]
      created  := 1
      if(VimConfObj.Conf[k]["val"] == 1){
        GuiControl, %VimGuiSetting%:, %k%, 1
      }
    }
    Gui, %VimGuiSetting%:Add, Text, % "XM+10 Y+15 g" . VimSetting.__Class . ".DisableUnusedText vVimDisableUnusedText", % VimConfObj.Conf["VimDisableUnused"]["description"]
    disableUnused := VimConfObj.DisableUnused
    Gui, %VimGuiSetting%:Add, DropDownList, % "W320 vVimDisableUnusedValue Choose"VimConfObj.Conf["VimDisableUnused"]["val"], % disableUnused[1]"|"disableUnused[2]"|"disableUnused[3]
    Gui, %VimGuiSetting%:Add, Text, % "XM+10 Y+15 g" . VimSetting.__Class . ".SetTitleMatchModeText vVimSetTitleMatchModeText", % VimConfObj.Conf["VimSetTitleMatchMode"]["description"]
    if(VimConfObj.Conf["VimSetTitleMatchMode"]["val"] == "RegEx"){
      matchmode := 4
    }else{
      matchmode := VimConfObj.Conf["VimSetTitleMatchMode"]["val"]
    }
    Gui, %VimGuiSetting%:Add, DropDownList, % "X+5 Y+-16 W70 vVimSetTitleMatchMode Choose"matchmode, 1|2|3|RegEx
    if(VimConfObj.Conf["VimSetTitleMatchModeFS"]["val"] == "Fast"){
      matchmodefs := 1
    }else{
      matchmodefs := 2
    }
    Gui, %VimGuiSetting%:Add, DropDownList, % "X+5 Y+-20 W70 vVimSetTitleMatchModeFS Choose"matchmodefs, Fast|Slow 
    Gui, %VimGuiSetting%:Add, Text, % "XM+10 Y+10 g" . VimSetting.__Class . ".IconCheckIntervalText vVimIconCheckIntervalText", % VimConfObj.Conf["VimIconCheckInterval"]["description"]
    Gui, %VimGuiSetting%:Add, Edit, X+5 Y+-16 W70 vVimIconCheckIntervalEdit
    Gui, %VimGuiSetting%:Add, UpDown, vVimIconCheckInterval Range100-1000000, % VimConfObj.Conf["VimIconCheckInterval"]["val"]
    Gui, %VimGuiSetting%:Add, Text, % "XM+10 Y+10 g" . VimSetting.__Class . ".VerboseText vVimVerboseText", % VimConfObj.Conf["VimVerbose"]["description"]
    verbose := VimConfObj.Verbose
    Gui, %VimGuiSetting%:Add, DropDownList, % "X+5 Y+-16 vVimVerboseValue Choose"VimConfObj.Conf["VimVerbose"]["val"], % verbose[1]"|"verbose[2]"|"verbose[3]"|"verbose[4]
    Gui, %VimGuiSetting%:Add, Text, % "XM+10 Y+5 g" . VimSetting.__Class . ".GroupText vVimGroupText", % VimConfObj.Conf["VimGroup"]["description"]
    StringReplace, VimGroupList, % VimConfObj.Conf["VimGroup"]["val"], % VimConfObj.GroupDel, `n, All
    Gui, %VimGuiSetting%:Add, Edit, XM+10 Y+5 R10 W300 Multi vVimGroupList, %VimGroupList%
    Gui, %VimGuiSetting%:Add, Text, XM+10 Y+10, Check
    Gui, %VimGuiSetting%:Font, Underline
    Gui, %VimGuiSetting%:Add, Text, % "X+5 cBlue g" . VimAbout.__Class . ".OpenHomepage vVimHomepage", HELP
    Gui, %VimGuiSetting%:Font, Norm
    Gui, %VimGuiSetting%:Add, Text, X+5, for further information.
    Gui, %VimGuiSetting%:Add, Button, +HwndVimGuiSettingOKId xm W100 X45 Y+10 Default, &OK
    ok := ObjBindMethod(VimSetting, "MenuOK")
    GuiControl, +G, % VimGuiSettingOKId, % ok
    Gui, %VimGuiSetting%:Add, Button, +HwndVimGuiSettingResetId W100 X+10, &Reset
    reset := ObjBindMethod(VimSetting, "MenuReset")
    GuiControl, +G, % VimGuiSettingResetId, % reset
    Gui, %VimGuiSetting%:Add, Button, +HwndVimGuiSettingCancelId W100 X+10, &Cancel
    cancel := ObjBindMethod(VimSetting, "MenuCancel")
    GuiControl, +G, % VimGuiSettingCancelId, % cancel
    Gui, %VimGuiSetting%:Show, W410, Vim Ahk Settings
    OnMessage(0x200, ObjBindMethod(VimSetting, "MouseMove"))
  }

  ; Dummy Labels, to enable popup over the text
  DisableUnusedText(){
  }
  SetTitleMatchModeText(){
  }
  IconCheckIntervalText(){
  }
  VerboseText(){
  }
  GroupText(){
  }

  MouseMove(){
    VimState.CurrControl := A_GuiControl
    if(VimState.CurrControl != VimState.PrevControl){
      VimState.PrevControl := VimState.CurrControl
      VimRemoveToolTip()
      if(VimState.CurrControl != "" && InStr(VimState.CurrControl, " ") == 0){
        ;f := ObjBindMethod(VimSetting, "VimDisplayToolTip")
        ;SetTimer,  % f, 1000
        SetTimer, VimDisplayToolTip, 1000
      }
    }
    Return
  }

  ;VimDisplayToolTip(){
  ;  global VimConfObj
  ;  f := ObjBindMethod(VimSetting, "VimDisplayToolTip")
  ;  SetTimer, %f%, Off
  ;  if(VimConfObj.Popup.HasKey(VimState.CurrControl)){
  ;    ToolTip % VimConfObj.Popup[VimState.CurrControl]
  ;    f := ObjBindMethod(VimSetting, "VimRemoveToolTip")
  ;    SetTimer, %f%, 60000
  ;  }
  ;}

  ;VimRemoveToolTip(){
  ;  f := ObjBindMethod(VimSetting, "VimRemoveToolTip")
  ;  SetTimer, %f%, Off
  ;  ToolTip
  ;}

  VimV2Conf(){
    global VimConfObj, VimDisableUnused, VimSetTitleMatchMode, VimDisableUnusedValue, VimVerbose, VimVerboseValue, VimGroup, VimGroupList
    Loop, % VimConfObj.DisableUnused.Length() {
      if(VimDisableUnusedValue == VimConfObj.DisableUnused[A_Index]){
        VimDisableUnused := A_Index
        Break
      }
    }
    Loop, % VimConfObj.Verbose.Length() {
      if(VimVerboseValue == VimConfObj.Verbose[A_Index]){
        VimVerbose := A_Index
        Break
      }
    }
    VimGroup := ""
    Loop, Parse, VimGroupList, `n
    {
      if(! InStr(VimGroup, A_LoopField)){
        if(VimGroup == ""){
          VimGroup := A_LoopField
        }else{
          VimGroup := VimGroup . VimConfObj.GroupDel . A_LoopField
        }
      }
    }
    for k, v in VimConfObj.Conf {
      v["val"] := %k%
    }
    VimSetting.VimSet(VimConfObj)
  }

  VimSet(conf){
    SetTitleMatchMode, % conf.Conf["VimSetTitleMatchMode"]["val"]
    SetTitleMatchMode, % conf.Conf["VimSetTitleMatchModeFS"]["val"]
    VimIconMng.SetIcon(VimState.Mode, conf.Conf["VimIcon"]["val"])
    if(conf.Conf["VimIconCheck"]["val"] == 1){
      SetTimer, VimStatusCheckTimer, % conf.Conf["VimIconCheckInterval"]["val"]
    }else{
      SetTimer, VimStatusCheckTimer, Off
    }
    conf.SetGroup(conf.Conf["VimGroup"]["val"])
  }

  Destroy(){
    VimRemoveToolTip()
    Gui, % VimSetting.VimGuiSetting . ":Destroy"
    VimSetting.VimGuiSetting := ""
  }
  MenuOK(){
    global VimConfObj
    Gui, % VimSetting.VimGuiSetting . ":Submit"
    VimSetting.VimV2Conf()
    VimIni.WriteIni()
    VimSetting.Destroy(VimConfObj)
  }
  MenuCancel(){
    VimSetting.Destroy()
  }
  MenuClose(){
    VimSetting.Destroy()
  }
  MenuEscape(){
    VimSetting.Destroy()
  }

  MenuReset(){
    global VimConfObj
    IfExist, VimIni.Ini
      FileDelete, VimIni.Ini

    for k, v in VimConfObj.Conf {
      VimConfObj.Conf[k]["val"] := v["default"]
    }
    VimSetting.Destroy()
    VimSetting.Menu()
  }
}

; These ToolTip (SetTimer) does not work well as Class Method
VimDisplayToolTip(){
  global VimConfObj
  SetTimer, VimDisplayToolTip, Off
  if(VimConfObj.Popup.HasKey(VimState.CurrControl)){
    ToolTip % VimConfObj.Popup[VimState.CurrControl]
    SetTimer, VimRemovetoolTip, 60000
  }
}

VimRemoveToolTip(){
  SetTimer, VimDisplayToolTip, Off
  SetTimer, VimRemoveToolTip, Off
  ToolTip
}

