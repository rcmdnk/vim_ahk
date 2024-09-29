class VimHotkey{
  __New(Vim){
    this.Vim := Vim

    ; Two-letter normal mode
    this.TwoLetterNormalIsSet := False
    this.TwoLetterNormalArray := Array()
    this.TwoLetterNormalEnabledObj := ObjBindMethod(this, "TwoLetterNormalEnabled")
  }

  TwoLetterNormalEnabled(HotkeyName){
    Return this.Vim.IsVimGroup() && (this.Vim.State.StrIsInCurrentVimMode("Insert")) && this.TwoLetterNormalIsSet
  }

  TwoLetterEnterNormal(EndKey, HotkeyName){
    Out := InputHook("I T0.1 V L1", EndKey)
    Out.Start()
    EndReason := Out.Wait()
    if(EndReason == "EndKey"){
      SendInput("{BackSpace 2}")
      Vim.State.SetNormal()
    }
  }

  SetTwoLetterMap(Key1, Key2){
    SendSame := ObjBindMethod(this, "SendSame")
    EnterNormal := ObjBindMethod(this, "TwoLetterEnterNormal")
    EnterNormal1 := EnterNormal.Bind(Key2)
    EnterNormal2 := EnterNormal.Bind(Key1)
    HotKey("~" Key1, EnterNormal1)
    HotKey("~" Key2, EnterNormal2)
    this.TwoLetterNormalArray.Push(key1)
    this.TwoLetterNormalArray.Push(key2)
  }

  SetTwoLetterMaps() {
    HotIf(this.TwoLetterNormalEnabledObj)
    this.TwoLetterNormalIsSet := False
    for value in this.TwoLetterNormalArray {
      HotKey(value, "Off")
    }
    this.TwoLetterNormalArray := Array()

    Loop Parse, this.Vim.Conf["VimTwoLetter"]["val"], this.Vim.GroupDel {
      if(A_LoopField != ""){
        if(StrLen(A_LoopField) != 2){
          MsgBox("Two-letter should be exactly two letters: " A_LoopField)
          Continue
        }
        this.TwoLetterNormalIsSet := True
        key1 := SubStr(A_LoopField, 1, 1)
        key2 := SubStr(A_LoopField, 2, 1)
        this.SetTwoLetterMap(key1, key2)
      }
    }
    HotIf()
  }

  Set(){
    this.SetTwoLetterMaps()
  }
}
