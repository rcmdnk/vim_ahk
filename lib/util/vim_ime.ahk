; Ref for IME: http://www6.atwiki.jp/eamat/pages/17.html

; Get IME Status. 0: Off, 1: On
VIM_IME_GET(WinTitle:="A"){
  hwnd := WinGetID(WinTitle)
  if(WinActive(WinTitle)){
    ptrSize := !A_PtrSize ? 4 : A_PtrSize
    cbSize := 4 + 4 + (PtrSize * 6) + 16
    stGTI := Buffer(cbSize, 0)
    NumPut("UInt", cbSize, stGTI, 0)   ;	DWORD   cbSize;
    hwnd := DllCall("GetGUIThreadInfo", "UInt", 0, "UInt", stGTI.Ptr)
        ? NumGet(stGTI, 8 + PtrSize, "UInt") : hwnd
  }

  Return DllCall("SendMessage"
      , "UInt", DllCall("imm32\ImmGetDefaultIMEWnd", "UInt", hwnd)
      , "UInt", 0x0283  ;Message : WM_IME_CONTROL
      ,  "Int", 0x0005  ;wParam  : IMC_GETOPENSTATUS
      ,  "Int", 0)      ;lParam  : 0
}
; Get input status. 1: Converting, 2: Have converting window, 0: Others
VIM_IME_GetConverting(WinTitle:="A", ConvCls:="", CandCls:=""){
  ; Input windows, candidate windows (Add new IME with "|")
  ConvCls .= (ConvCls ? "|" : "")                 ;--- Input Window ---
    .  "ATOK\d+CompStr"                           ; ATOK
    .  "|imejpstcnv\d+"                           ; MS-IME
    .  "|WXGIMEConv"                              ; WXG
    .  "|SKKIME\d+\.*\d+UCompStr"                 ; SKKIME Unicode
    .  "|MSCTFIME Composition"                    ; Google IME
  CandCls .= (CandCls ? "|" : "")                 ;--- Candidate Window ---
    .  "ATOK\d+Cand"                              ; ATOK
    .  "|imejpstCandList\d+|imejpstcand\d+"       ; MS-IME 2002(8.1)XP
    .  "|mscandui\d+\.candidate"                  ; MS Office IME-2007
    .  "|WXGIMECand"                              ; WXG
    .  "|SKKIME\d+\.*\d+UCand"                    ; SKKIME Unicode
  CandGCls := "GoogleJapaneseInputCandidateWindow" ; Google IME

  hwnd := WinGetID(WinTitle)
  if(WinActive(WinTitle)){
    ptrSize := !A_PtrSize ? 4 : A_PtrSize
    cbSize := 4 + 4 + (PtrSize * 6) + 16
    stGTI := Buffer(cbSize, 0)
    NumPut("UInt", cbSize, stGTI, 0)   ;   DWORD   cbSize;
    hwnd := DllCall("GetGUIThreadInfo", "UInt", 0, "Ptr", stGTI.Ptr)
      ? NumGet(stGTI, 8 + PtrSize, "UInt") : hwnd
  }

  pid := WinGetPID("ahk_id " hwnd)
  tmm := A_TitleMatchMode
  SetTitleMatchMode("RegEx")
  ret := WinExist("ahk_class " . CandCls . " ahk_pid " pid) ? 2
      :  WinExist("ahk_class " . CandGCls                 ) ? 2
      :  WinExist("ahk_class " . ConvCls . " ahk_pid " pid) ? 1
      :  0
  SetTitleMatchMode(tmm)
  Return ret
}

; Set IME, SetSts=0: Off, 1: On, return 0 for success, others for non-success
VIM_IME_SET(SetSts:=0, WinTitle:="A"){
  hwnd := WinGetID(WinTitle)
  if(WinActive(WinTitle)){
    ptrSize := !A_PtrSize ? 4 : A_PtrSize
    cbSize := 4 + 4 + (PtrSize * 6) + 16
    stGTI := Buffer(cbSize, 0)
    NumPut("UInt", cbSize, stGTI, 0)   ;   DWORD   cbSize;
    hwnd := DllCall("GetGUIThreadInfo", "UInt", 0, "UInt", stGTI.Ptr)
      ? NumGet(stGTI, 8 + PtrSize, "Uint") : hwnd
  }
  Return DllCall("SendMessage"
    , "UInt", DllCall("imm32\ImmGetDefaultIMEWnd", "UInt", hwnd)
    , "UInt", 0x0283  ;Message : WM_IME_CONTROL
    ,  "Int", 0x006   ;wParam  : IMC_SETOPENSTATUS
    ,  "Int", SetSts) ;lParam  : 0 or 1
}
