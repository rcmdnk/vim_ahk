
; Basic Functions {{{
VimSetGroup() {
  global
  VimGroupN++
  VimGroupName := "VimGroup" . VimGroupN
  Loop, Parse, VimGroup, % VimGroupDel
  {
    if(A_LoopField != ""){
      GroupAdd, %VimGroupName%, %A_LoopField%
    }
  }
}

VimCheckMode(verbose=1, Mode="", g=0, n=0, LineCopy=-1, force=0){
  global

  if(force == 0) and ((verbose <= 1) or ((Mode == "") and (g == 0) and (n == 0) and (LineCopy == -1))){
    Return
  }else if(verbose == 2){
    VimStatus(VimMode, 1) ; 1 sec is minimum for TrayTip
  }else if(verbose == 3){
    VimStatus(VimMode "`r`ng=" Vim_g "`r`nn=" Vim_n "`r`nLineCopy=" VimLineCopy, 4)
  }
  if(verbose >= 4){
    Msgbox, , Vim Ahk, VimMode: %VimMode%`nVim_g: %Vim_g%`nVim_n: %Vim_n%`nVimLineCopy: %VimLineCopy%
  }
  Return
}

VimSetMode(Mode="", g=0, n=0, LineCopy=-1){
  global
  if VimCheckModeValue {
    VimCheckValidMode(mode)
  }
  if(Mode != ""){
    VimMode := Mode
    If(Mode == "Insert") and (VimRestoreIME == 1){
      VIM_IME_SET(VimLastIME)
    }
    VimSetIcon(VimMode)
  }
  if(g != -1){
    Vim_g := g
  }
  if(n != -1){
    Vim_n := n
  }
  if(LineCopy!=-1){
    VimLineCopy := LineCopy
  }
  VimCheckMode(VimVerbose, Mode, g, n, LineCopy)
  Return
}

VimIsCurrentVimMode(mode){
  global VimMode
  global VimCheckModeValue
  if VimCheckModeValue {
    VimCheckValidMode(mode)
  }
  return (mode == VimMode)
}

VimStrIsInCurrentVimMode(str){
  global VimMode
  global VimCheckModeValue
  if VimCheckModeValue {
    VimCheckValidMode(str, false)
  }
  return (inStr(VimMode, str))
}

VimHasValue(haystack, needle, full_match = true) {
  if(!isObject(haystack)){
    return false
  }else if(haystack.Length()==0){
    return false
  }
  for index,value in haystack{
    if full_match{
      if (value==needle){
        return true
      }
    }else{
      if (inStr(value, needle)){
        return true
      }
    }
  }
  return false
}

VimCheckValidMode(mode, full_match := true){
  Global VimPossibleVimModes
  try {
    inOrBlank:= (not full_match) ? "in " : ""
    if not VimHasValue(VimPossibleVimModes, mode, full_match) {
      throw Exception("Invalid mode specified",-2,
      ( Join
"'" mode "' is not " inOrBlank "a valid mode as defined by the VimPossibleVimModes
 array at the top of vim.ahk. This may be a typo.
 Fix this error by using an existing mode,
 or adding your mode to the array.")
      )
    }
  } catch e {
    MsgBox % "Warning: " e.Message "`n" e.Extra "`n`n Called in " e.What " at line " e.Line
  }
}

; vim: foldmethod=marker
; vim: foldmarker={{{,}}}
