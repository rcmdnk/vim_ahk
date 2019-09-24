IsLastHotkey(key)
{
    return (A_PriorHotkey == key and A_TimeSincePriorHotkey < 800)
}

IsLastkey(key)
{
    return (A_Priorkey == key and A_TimeSincePriorkey < 800)
}

SaveClipboard(){
    ; push clipboard to variable
    global ClipSaved := ClipboardAll
    ; Sleep to give time for saving
    sleep, 20
    ; Clear clipboard to avoid errors
    Clipboard :=
}

Copy(){
    SaveClipboard()
    send ^c
    ClipWait, 0.1
}

Cut(){
    SaveClipboard()
    send ^x
    ClipWait, 0.1
}

Paste(){
    Send %Clipboard%
    RestoreClipboard()
}

RestoreClipboard(){
    global ClipSaved
    if (ClipSaved = ""){
        return
    }
    ; empty clip so clipwait works
    Clipboard :=
    ;restore original clipboard
    Clipboard := ClipSaved
    ClipWait
    ClipSaved := ; free memory
}

GetSelectedText(){
    Copy()
    Output := Clipboard
    RestoreClipboard()
    return Output
}

; Alternate to WinWaitActive, designed to work with CI better.
; It doesn't.
;  regex f&r: s/WinWaitActive,([\w -]+)/WaitForWindowToActivate("$1")/g
WaitForWindowToActivate(WindowTitle){
    WinWaitActive %WindowTitle%
    return
    ; while not WinActive(WindowTitle){
    ;    sleep, 20
    ; }
    ; sleep, 100
    ; return True
}

HackWinActivate(WindowTitle){
    while not WinActive(WindowTitle){
       send {alt down}{shift down}{tab}{shift up}{alt up}
    }
    sleep, 100
    return True
}
