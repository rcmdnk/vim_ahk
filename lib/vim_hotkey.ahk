class VimHotkey{
  __New(Vim){
    this.Vim := Vim

    ; Two-letter normal mode
    this.TwoLetterNormalIsSet := False
    this.TwoLetterNormalPending := False
    this.TwoLetterNormalArray := Array()
    this.TwoLetterNormalEnabledObj := ObjBindMethod(this, "TwoLetterNormalEnabled")
  }

  TwoLetterNormalEnabled(HotkeyName){
    Return this.Vim.IsVimGroup() && (this.Vim.State.StrIsInCurrentVimMode("Insert")) && this.TwoLetterNormalIsSet && !this.TwoLetterNormalPending && !GetKeyState("CapsLock", "T")
  }

  TwoLetterEnterNormal(FirstKey, EndKeys, HotkeyName){
    this.TwoLetterNormalPending := True
    try {
      TwoLetterInterval := this.Vim.Conf["VimJJInterval"]["val"] / 1000
      Out := InputHook("I T" TwoLetterInterval " V L1")
      ; Ignore auto-repeat until the first key has actually been released.
      Out.KeyOpt(FirstKey, "IN")
      Out.OnKeyUp := (Hook, *) => Hook.KeyOpt(FirstKey, "-I")
      Out.Start()
      if(!GetKeyState(FirstKey, "P")){
        Out.KeyOpt(FirstKey, "-I")
      }
      EndReason := Out.Wait()
      if(EndReason == "Max" && StrLen(Out.Input) == 1 && InStr(EndKeys, Out.Input, True)){
        if(!VIM_IME_GET()){
          SendInput("{BackSpace 2}")
        }
        this.Vim.State.SetNormal()
      }
    } finally {
      KeyWait(FirstKey)
      this.TwoLetterNormalPending := False
    }
  }

  SetTwoLetterMap(Key1, EndKeys){
    EnterNormal := ObjBindMethod(this, "TwoLetterEnterNormal", Key1, EndKeys)
    ; Start on key-down so rolled typing (j down, k down, j up) is captured.
    Key := "~" Key1
    HotKey(Key, EnterNormal, "On")
    this.TwoLetterNormalArray.Push(Key)
  }

  SetTwoLetterMaps() {
    HotIf(this.TwoLetterNormalEnabledObj)
    this.TwoLetterNormalIsSet := False
    for value in this.TwoLetterNormalArray {
      HotKey(value, "Off")
    }
    this.TwoLetterNormalArray := Array()

    Pairs := Map()
    if(this.Vim.Conf["VimJJ"]["val"] == 1){
      Pairs["j"] := "j"
    }
    Loop Parse, this.Vim.Conf["VimTwoLetter"]["val"], this.Vim.GroupDel {
      if(A_LoopField != ""){
        if(StrLen(A_LoopField) != 2){
          MsgBox("Two-letter should be exactly two letters: " A_LoopField)
          Continue
        }
        key1 := StrLower(SubStr(A_LoopField, 1, 1))
        key2 := StrLower(SubStr(A_LoopField, 2, 1))
        Pairs[key1] := (Pairs.Has(key1) ? Pairs[key1] : "") key2
      }
    }
    for Key1, EndKeys in Pairs {
      this.SetTwoLetterMap(Key1, EndKeys)
    }
    this.TwoLetterNormalIsSet := Pairs.Count > 0
    HotIf()
  }

  Set(){
    this.SetTwoLetterMaps()
  }
}
