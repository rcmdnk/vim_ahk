@echo off
SET AHKPath=C:\Program Files\AutoHotkey
REM Takes a simple optional command parameter, /t, which starts testing before build.
SET Param1=%1

if "%Param1%"=="/t" (
  start /w "%AHKPath%\v2\Autohotkey.exe" tests/run_vimahk_tests.ahk -quiet
  REM Return code from above (0 if tests all pass) is stored in %errorlevel%
  if %errorlevel% neq 0 (
      echo Tests failed.
      exit /b %errorlevel%
  )
)
if exist vim_ahk rmdir /s /q vim_ahk
mkdir vim_ahk
"%AHKPath%\Compiler\Ahk2Exe.exe" /in vim.ahk /out vim_ahk\vim_ahk.exe /compress 0 /silent /base "%AHKPath%\v2\AutoHotkey.exe"
if %errorlevel% neq 0 (
  echo Build failed.
  exit /b %errorlevel%
)
xcopy /i /y vim_ahk_icons vim_ahk\vim_ahk_icons
