; This script requires vim installed on the computer. It effectively diffs the results of sending the keys below to a new notepad page vs to a new vim document.
; This may also be true of e, w and b, due to the way notepad handles words (treating punctuation as a word)

; Results are outputed as the current time and date in %A_ScriptDir%\testlogs

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance Force
#warn
sendlevel, 1 ; So vim commands get triggered by this script
SetTitleMatchMode 2 ; window title functions will match by containing the match text.
; Only affects sendevent, used for sending the test one key at a time.
; Gives the vim script time to interpret it, also useful to increase when
; debugging failures.
SetKeyDelay, 80
; (gives vim script time to react).
DetectHiddenWindows, on

; Contains clipboard related functions, among others.
#include %A_ScriptDir%\utility_functions.ahk

; 1 optional commandline argument, -quiet, stops ouput at the end of the tests.
; Used for CI testing.
arg1 = %1%
if (arg1 == "-quiet"){
    QuietMode := True
}else{
    QuietMode := False
}
isQuiet(){
    Global QuietMode
    return QuietMode
}

TestsFailed := False
IfNotExist, testLogs
    FileCreateDir, testLogs
LogFileName = testLogs\%A_Now%.txt ;%A_Scriptdir%\testlogs\%A_Now%.txt

; Initialise the programs
SetWorkingDir %A_ScriptDir%\testLogs  ; Temp vim files are put out of the way.
run, cmd.exe /r gvim -u NONE,,,VimPID
sleep, 200
WaitForWindowToActivate("ahk_class Vim") ; Wait for vim to start
WinMaximize,ahk_class Vim
SetWorkingDir %A_ScriptDir%

send :imap jj <esc>{return} ; Prepare vim
; So newlines are handled correctly between both notepad and vim
send :imap ^q`r^q`n ^q{return 2}

Run, Notepad,,,NotepadPID
sleep, 200
WaitForWindowToActivate("ahk_class Notepad") ; Wait for notepad to start
WinMaximize, ahk_class Notepad

run, %A_ScriptDir%/vim.ahk --testing,,, AHKVimPID ; Run our vim emulator script.

; Set all our scripts and two testing programs to Above normal priority, for test reliability.
Process, Priority, ,A ; This script
Process, Priority, NotepadPID,A
Process, Priority, VimPID,A
Process, Priority, AHKVimPID,A
; They all get killed on script end anyway.

; This is the text that all of the tests are run on, fresh.
; Feel free to add extra lines to the end, if your test needs them.
; The test will be send from normal mode, with the cursor at the start of the sample text.
SampleText =
(JOIN`r`n
This is the first line of the test, and contains a comma and a period.
Second line here
3rd line. The second line is shorter than both 1st and 3rd line.
The fourth line contains     some additional whitespace.
What should I put on the 5th line?A missing space, perhaps
This line 6 should be longer than the line before it and after it to test kj
No line, including 7, can be longer than 80 characters.
This is because notepad wraps automatically, (line 8)
And treats a wrapped line as separate lines (line 9)
)

; Additional test cases should be added to testcases.txt
ArrayOfTests := [""] ; Base case, ensures the sample is entered the same between the two.
ReadFileWithComments(ArrayOfTests)

ReadFileWithComments(OutputArray){
    Loop, read, testcases.txt
    {
        Line := A_LoopReadLine
        output := StrSplit(Line, ";")
        if(Output.Length() > 0 AND strlen(Output[1]) > 0)
        {
            testString := output[1]
            ; escape special chars
            StringReplace, testString, testString, ^, {^}, A
            StringReplace, testString, testString, +, {+}, A
            StringReplace, testString, testString, #, {#}, A
            StringReplace, testString, testString, !, {!}, A
            OutputArray.push(testString)
        }
    }
}

RunTests() ; Lets get this show on the road


RunTests(){
    Global ArrayOfTests
    for index, test in ArrayOfTests
    {
        ; msgbox Current test: "%test%"
        TestAndCompareOutput(test)
    }
    EndTesting()
}

SwitchToVim(){
    WinActivate, ahk_class Vim
    WaitForWindowToActivate("ahk_class Vim")
}

SwitchToNotepad(){
    WinActivate, ahk_class Notepad
    WaitForWindowToActivate("ahk_class Notepad")
}

SendTestToNotepadAndReturnResult(test){
    Global SampleText
    SwitchToNotepad()
    ; Make sure at start of body of notepad, and it's empty.
    send {esc}
    sleep, 50
    send i^a^a{delete}
    ; Ensure insert mode for the sample text.
    send i{backspace}
    sleep, 20
    ; Paste sample text. Faster, more reliable.
    SaveClipboard()
    Clipboard :=""
    Clipboard := SampleText
    Clipwait
    send ^v ; Paste
    RestoreClipboard()
    sleep,50
    ; Make sure we are in normal mode to start with, at start of text.
    send {esc}
    sleep, 50
    send ^{home}
    sendevent %test%
    sleep, 50
    ; Ensure we select all of the inserted text.
    send {esc}
    sleep, 50
    send i^a
    output := GetSelectedText()
    ; Delete text ready for next test
    send {backspace}
    return output
}

SendTestToVimAndReturnResult(test){
    Global SampleText
    SwitchToVim()
    ; Ensure insert mode for the sample text.
    ; send i{backspace}
    ; send %SampleText%
    ; Paste sample text. Faster, more reliable.
    SaveClipboard()
    Clipboard :=""
    Clipboard := SampleText
    Clipwait
    send "*p ; Paste
    RestoreClipboard()
    sleep, 50
    ; Make sure we are in normal mode to start with, at start of text.
    send {esc}^{home}
    send %test%
    sleep, 50
    SaveClipboard()
    clipboard= ; Empty the clipboard for clipwait to work
    send {esc}:`%d{numpadAdd} ; select all text, cut to system clipboard
    send {return}
    ClipWait
    output := Clipboard
    RestoreClipboard()
    return output
}

TestAndCompareOutput(test){
    global Log
    NotepadOutput := SendTestToNotepadAndReturnResult(test)
    VimOutput := SendTestToVimAndReturnResult(test)
    CompareStrings(NotepadOutput, VimOutput, test)
}

; Use a diff, then log the result in temp files
CompareStrings(NotepadOutput, VIMOutput, CurrentTest){
    Global LogFileName
    Global TestsFailed
    ; Store files in separate dir.
    SetWorkingDir %A_ScriptDir%\TestingLogs
    file1 := FileOpen("NotepadOutput", "w")
    file2 := FileOpen("VIMOutput", "w")
    file1.write(NotepadOutput)
    file2.write(VIMOutput)
    file1.close()
    file2.close()

    ; This line runs the DOS fc (file compare) program and enters the reults in a file.
    ; Could also consider using comp.exe /AL instead, to compare individual characters. Possibly more useful.
    ; Comp sucks. Wow. Using fc, but only shows two lines: the different one and the one after. Hard to see, but it'll do for now.
    DiffResult := ComObjCreate("WScript.Shell").Exec("cmd.exe /q /c fc.exe /LB2 /N NotepadOutput VIMOutput").StdOut.ReadAll()
    IfNotInString,DiffResult, FC: no differences encountered
    {
        TestsFailed := True
        LogFile := FileOpen(LogFileName, "a")
        LogEntry := "Test = """
        LogEntry = Test = "%CurrentTest%"`n%DiffResult%`n`n
        LogFile.Write(LogEntry) ; "Test = ""%CurrentTest%""`n%DiffResult%`n`n")
        LogFile.Close()
    }
    FileDelete, NotepadOutput
    FileDelete, VIMOutput
    FileDelete, _.sw*
}

; Tidy up, close programs.
EndTesting(){
    Global TestsFailed
    Global LogFileName
    SwitchToNotepad()
    send !{f4}
    send n
    SwitchToVim()
    send :q{!}
    send {return} ; Exit vim.
   
    if (TestsFailed == True)
    {
        if not isQuiet() {
            msgbox,4,,At least one test has failed!`nResults are in %LogFileName%`nOpen log?
            IfMsgBox Yes
            {
                run %LogFileName%
            }
        }
        EndScript(1)
    }else{
        if not isQuiet() {
            msgbox, All tests pass!
        }
        EndScript(0)
    }
}




EndScript(exitCode){
    Global NotepadPID
    Global AHKVimPID
    Global VimPID
    process, Close, %NotepadPID%
    process, Close, %AHKVimPID%
    process, Close, %VimPID%
    if exitCode = 1
        ExitApp, 1 ; Failed exit
    else
        ExitApp, 0 ; Success.
}

EndScript(1)

+ & esc::EndScript(1) ; Abort
