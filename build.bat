@echo off
SET AHKPath=C:\Program Files\AutoHotkey
REM Takes a sinple optional command parameter, /t, which starts testing before build.
SET Param1=%1

if "%Param1%"=="/t" (
    start /w "%AHKPath%\Autohotkey.exe" vim.ahk -quiet
)
REM Return code from above (0 if tests all pass) is stored in %errorlevel%
if errorlevel 1 (
    echo   .
    echo   .
    echo Tests failed. Exes not built. Log contents:
    echo   .
    echo   .
    type testLogs\*
    echo   .
    echo   .
    exit /b %errorlevel%
)
REM You need intall ahk2exe, this script assumes it is at \bin_drop\ahk2exe
"%AHKPath%\compiler\ahk2exe.exe" /in vim.ahk /out vim_ahk.exe
REM "%AHKPath%\compiler\ahk2exe.exe" /in IME.ahk /out vim_ime.exe
