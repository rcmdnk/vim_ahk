@echo off
SET AHKPath=C:\Program Files\AutoHotkey
REM Takes a simple optional command parameter, /t, which starts testing before build.
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
if exist vim_ahk rmdir /s /q vim_ahk
mkdir vim_ahk
"%AHKPath%\compiler\ahk2exe.exe" /in vim.ahk /out vim_ahk\vim_ahk.exe /compress 0
xcopy /i /y vim_ahk_icons vim_ahk\vim_ahk_icons
