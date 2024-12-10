if exist vim_ahk rmdi /s /q vim_ahk
mkdir vim_ahk
"%AHKPath%\Compiler\Ahk2Exe.exe" /in vim.ahk /out vim_ahk\vim_ahk.exe /compress 0 /silent /base "%AHKPath%\AutoHotkey.exe"
if %errorlevel% neq 0 (
  echo Build failed.
  exit /b %errorlevel%
)
xcopy /i /y vim_ahk_icons vim_ahk\vim_ahk_icons
