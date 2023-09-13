# vim_ahk

Setting file/exe file of AutoHotkey for Vim emulation.

vim.ahk is the setting file for [AutoHotkey](http://www.autohotkey.com/)(Autohotkey_L).

vim.exe is a standalone application made from vim.ahk (available in [the releases page](https://github.com/rcmdnk/vim_ahk/releases)).

This is vim emulation for Windows.
If you are interested in the same settings for Mac,
try Vim emulation for [Karabiner - Software for macOS](https://pqrs.org/osx/karabiner/): [Karabiner-Elements complex_modifications rules by rcmdnk](https://rcmdnk.com/KE-complex_modifications/).

## Installation

### Scripts

If you've already installed AutoHotKey, just open vim.ahk with AutoHotkey.

If you are running AutoHotKey with another script,
you can include it in your script using AutoHotKey...
Please copy vim.ahk and lib directory in `\Users\%username%\Documents`
or where the script is in,
and add the following line in AutoHotkey.ahk or your script:

    #Include  %A_LineFile%\..\vim.ahk

at the end of the <a href="http://www.autohotkey.com/docs/Scripts.htm#auto">Auto-execute section</a>.

### Executable

You can also use **vim_ahk.exe**, which can work standalone w/o AutoHotKey.

To get executable, go to [the releases page](https://github.com/rcmdnk/vim_ahk/releases)
and download the latest zip file.

Unzip the zip file, and place the extracted vim_ahk folder where you like,
then launch **vim_ahk.exe**.

:memo: place **vim_ahk_icons** folder in the same folder with **vim_ahk.exe**,
otherwise, the tray menu icon feature does not work.

### Build executable from the source

Clone vim_ahk and go vim_ahk folder, and run **build.bat**.

* Double click the file
* Or run `.\build.bat` on PowerShell or Command Prompt.

You will find **vim_ahk** folder which contains **vim_ahk.exe** and **vim_ahk_icons**.

## Applications (VimGroup)
The default setting enables vim-mode for the following applications:

* Notepad (メモ帳)
* Wordpad
* TeraPad
* Windows Explorer
* Thunderbird (only sending window)
* Microsoft PowerPoint
* Microsoft Word
* Evernote
* Visual Studio Code
* TexWork
* TexStudio
* Q-dir
* OneNote
* Applications using ahk_exe ApplicationFrameHost.exe

You can change them from the right-click menu of the task tray icon
(find `VimMenu`-`Settings` in the list),
or launch the setting window by `Ctrl-Alt-Shift-v`.

If you want to change applications directly in the script, add `VimGroup`
variable before `Vim := new VimAhk()` in vim.ahk
(Window title/class can be checked by Window spy of AutoHotkey),
or write before including vim.ahk

Example line:

    VimGroup := "ahk_exe chrome.exe,ahk_exe firefox.exe"

Multiple applications can be written by a comma-separated.

Note: This will overwrite the default applications. If you want to **add**
these applications to the default applications, add following applications
after your applications:

    ahk_exe notepad.exe,ahk_exe explorer.exe,ahk_exe wordpad.exe,ahk_exe TeraPad.exe,作成,Write:,ahk_exe POWERPNT.exe,ahk_exe WINWORD.exe,ahk_exe Evernote.exe,ahk_exe Code.exe,ahk_exe onenote.exe,OneNote,ahk_exe texworks.exe,ahk_exe texstudio.exe

Or you can use GUI option setting menu described below.

The default setting of `VimSetTitleMatchMode` is 2,
which makes matching methods as `Contain`.

If you set `OneNote`, all windows with a title containing `OneNote`
(e.g. `XXX's OneNote`) will be included.
If you set `VimSetTitleMatchMode` as 3, only the exact title of `OneNote` will be included.

Note: It may not work on OneNote. OneNote may have a window name like
**User's Notebook - OneNote**, instead of **OneNote**.

In that case, you need to check OneNote's window title with Window spy.

Window spy will give you about Window Title, Class and Process like:

    User's Notebook - OneNote
    ahk_class ApplicationFrameWindow
    ahk_exe ApplicationFrameHost.exe

If you add any of the above lines to VimGroup, vim_ahk works on OneNote.
But if you set `ahk_class ApplicationFrameWindow` or `ahk_exe ApplicationFrameHost.exe`,
vim_ahk also works on other applications which use these Class/Process names
(most of the applications installed from Microsoft Store).

Examples of applications:

* Chrome: `ahk_exe chrome.exe`
* Firefox: `ahk_exe firefox.exe`
* Excel: `ahk_exe EXCEL.EXE`
* LibreOffice: `ahk_exe soffice.bin` (for all LibreOffice applications)

## Options

In addition to `VimGroup`,
there are the following options that you can set in your script.
All of these can be changed from the setting menu, too.

|Option|Description|Default|
|:-----|:----------|:------|
|VimEscNormal|If 1, short press ESC sets the normal mode, while long press ESC sends ESC.|1|
|VimSendEscNormal|If 1, short press ESC send ESC in the normal mode.|0|
|VimLongEscNormal|If 1, short press and long press of ESC behaviors are swapped.|0|
|VimCtrlBracketToEsc|If 1, Ctrl-[ behaves as ESC.<br>If VimCtrlBracketNormal is 0, Ctrl-[ sends ESC.<br>If VimCtrlBracketNormal is 1, long press Ctrl-[ sends ESC.|0|
|VimCtrlBracketNormal|If 1, pushing Ctrl-[ sets the normal mode, while long press Ctrl-[ sends Ctrl-[.|1|
|VimSendCtrlBracketNormal|If 1, short press Ctrl-[ send Ctrl-[ in the normal mode.|0|
|VimLongCtrlBracketNormal|If 1, short press and long press of Ctrl-[ behaviors are swapped.|0|
|VimChangeCaretWidth|If 1, check the character under the cursor before an action. Currently this is used for: `a` in the normal mode (check if the cursor is located at the end of the line).|0|
|VimRestoreIME|If 1, IME status is restored at entering the insert mode.|1|
|VimJJ|If 1, `jj` changes the mode to the normal mode from the insert mode.|0|
|VimTwoLetterEsc|A list of character pairs to press together during the insert mode to get to the Normal mode.<br>For example, a value of `jf` means pressing `j` and `f` at the same time will enter the Normal mode.<br>Multiple combination can be set by separated by `,`. (e.g. `jf,jk,sd`)||
|VimDisableUnused|Disable level of unused keys in other than the insert mode:<br><ol><li>Do not disable unused keys</li><li>Disable alphabets (+shift) and symbols</li><li>Disable all including keys with modifiers (e.g. Ctrl+Z)</li></ol>|3|
|VimSetTitleMatchMode|SetTitleMatchMode:<br><ol><li>Start with</li><li>Contain</li><li>Exact match</li><li>Regular expression</li>|2|
|VimSetTitleMatchModeFS|SetTitleMatchMode:<br><ol><li>Fast: Text is not detected for such edit control.</li><li>Slow: Works for all windows, but slow.</li>|Fast|
|VimIconCheckInterval|Interval to check vim_ahk status (ms) and change tray icon (see below picture).<br>If it is set to 0, the original AHK icon is set and not changed.|1000|
|VimVerbose|Verbose level:<br><ol><li>Nothing.</li><li>Minimum tooltip (mode information only).</li><li>ToolTip (all information).</li><li>Debug mode with a message box, which doesn't disappear automatically.</li></ol>|1|
|VimAppList|Application list usage:<br><ul><li>All: Enable vim_ahk on all applications (the applicatoin list is ignored).</li><li>Allow List: Use the application list as an allow list.</li><li>Deny List: Use the application list as a deny list.</li></ul>|Allow List|
|VimGroup|Applications on witch vim_ahk is enabled.|See **Applications** section|

You can add your options before including **vim.ahk** in your script
in the auto execute section like:

    VimVerbose := 2
    #Include \path\to\vim.ahk

If you want to change them directly in the vim.ahk script,
add these variable before `Vim := new VimAhk()`.

* VimIconCheckInterval example

If you set VimIconCheckInterval as non-zero, the tray icon is changed
when you change the mode or change the applications to vim_ahk enabled or not enabled ones.

![trayicon](https://raw.githubusercontent.com/rcmdnk/vim_ahk/master/pictures/trayicon.gif "trayicon")

* Note for VimChangeCaretWidth

Caret width can be changed only on specific applications: Wordpad, Word, or OneNote.
On Notepad or Explorer, the caret width is kept but does not change.

For most other applications, the caret width is kept as the original width.

When this option is enabled, the current window briefly loses focus when the mode is changed.

## GUI Option Setting Window

You can change these options from the right-click menu of the task tray icon
(find `VimMenu`-`Settings` in the list),
or launch the setting window by `Ctrl-Alt-Shift-v`.

![traymenu](https://raw.githubusercontent.com/rcmdnk/vim_ahk/master/pictures/traymenu.jpg "traymenu")

![settings](https://raw.githubusercontent.com/rcmdnk/vim_ahk/master/pictures/settings.jpg "settings")

Here, you can add applications, change the mode change key,
or change the verbose level.

If you push `Reset`, default settings will be shown in the window.
These settings will be enabled only if you push the `OK` button.

These **default settings** are overwritten by
your `VimXXX` options in your script described above.
(i.e. `Reset` will restore your options in the script in addition to
the default settings of vim_ahk.)

## Global shortcut keys

|Key|Function|
|:----------:|:-------|
|Ctrl-Alt-Shift-v|Launch GUI Option Setting Window.|
|Ctrl-Alt-Shift-s|Suspend/restart vim_ahk.|
|Ctrl-Alt-Shift-c|Show status check window. (Only on the VimGroup applications.)|

## Main Modes

Here are the main modes.

|Mode|Description|
|:---|:----------|
|Insert mode|Original Windows state|
|Normal mode|As in vim, a cursor is moved by `hjkl`, `w`, etc... and some vim-like commands are available.|
|Visual mode|There are three visual modes: Character-wise, Line-wise, and Block-wise. Block-wise visual mode is valid only for applications that support block-wise selection (such TeraPad).|
|Command mode|Can be used for saving the file/quitting.|

The initial state is the insert mode, then `ESC` or `Ctrl-[` brings you to the normal mode.

In the normal mode, `i` is the key to being back to the insert mode.

`v`, `V` and `Ctrl-v` are the key to
the Character-wise, the Line-wise, and the Block-wise
visual mode, respectively.

After pressing `:`, a few commands to save/quit are available.

## Available commands in the insert mode

|Key/Commands|Function|
|:----------:|:-------|
|ESC/Ctrl-[| Enter the normal mode. Holding (0.5s) these keys emulate normal ESC/Ctrl-[.|
|jj|Enter the normal mode, if enabled.|
|Custom two letters|If two-letter mapping is set.|

ESC/Ctrl-[ switch off IME if IME is on.
ESC acts as ESC when IME is on and converting instructions.
Ctrl-[ switches off IME and enters the normal mode even if IME is on.

Long press ESC (Ctrl-[) will send these original keys, if `VimLongEscNormal` (`VimLongCtrlBracketNormal` is not enabled (0).

If `VimLongEscNormal` (`VimLongCtrlBracketNormal`) is enabled,
a single press will send original keys
and a long press will change the mode to the normal mode.

If using a custom two-letter hotkey to enter the normal mode, the two letters must be different.

## Available commands in the normal mode

### Mode Change

|Key/Commands|Function|
|:----------:|:-------|
|i/I/a/A/o/O| Enter the insert mode under the cursor/start of the line/next to the cursor/end of the line/next line/previous line.|
|v/V/Ctrl-v|Enter the visual mode of Character-wise/Line-wise/Block-wise.|
|:|Enter the command line mode|

### Move

|Key/Commands|Function|
|:----------:|:-------|
|h/j/k/l|Left/Down/Up/Right.|
|0/$| Move to the start/end of the line.|
|Ctrl-a/Ctrl-e| Move to the start/end of the line (emacs like).|
|^| Move to the starting non-whitespace character of the line.|
|w/W| Move to the beginning of the next word.|
|e/E| Move to the end of the word. (Actually, move to the beginning of the next word and move one character left.)|
|b/B| Move to the beginning of the previous word.|
|Ctrl-u/Ctrl-d| Go Up/Down 10 line.|
|Ctrl-b/Ctrl-f| PageUp/PageDown.|
|gg/G| Go to the top/bottom of the file|
|Space| Right.|
|Enter| Move to the beginning of the next line.|

Note: Enter works only for editor applications (for other than Explorer, Q-dir, it works as Enter even in the normal mode).

In addition, `Repeat` is also available for some commands.

|Example Commands|Action|
|:----------:|:-------|
|4j| Down 4 lines|
|3w| Move 3 words forward|
|100j| Down 100 lines|

### Yank/Cut(Delete)/Change/Paste

|Key/Commands|Function|
|:----------:|:-------|
|yy, Y| Copy the line.|
|dd| Cut the line.|
|D| Cut from here to the end of the line.|
|cc| Change the line (enter the insert mode).|
|C| Cut from here to the end of the line and enter the insert mode.|
|x/X| Delete a character under/before the cursor (not registered in the clipboard).|
|p/P| Paste to the next/current place. If copy/cut was done with the line-wise visual mode, it pastes to the next/current line. Some commands (such yy/dd) also force to paste as line-wise.|
|yiw/diw/ciw| Copy/cut/change current word.|

y/d/c+Move Command can be used, too.
* e.g.) `yw` -> copy next one word.
* e.g.) `d3w` -> delete next 3 words.

### Others

|Key/Commands|Function|
|:----------:|:-------|
|u/Ctrl-r| Undo/Redo.|
|r/R| Replace one character/multiple characters.|
|J| Combine two lines.|
|.| It is fixed to do: `Replace the following word with a clipboard` (useful to use with a search).|
|~| Change case.|
|/| Start search (search box will be opened)|
|n/N| Search next/previous (Some applications support only next search)|
|*| Search the word under the cursor.|
|ZZ/ZQ|Save and Quit/Quit.|

## Available commands in visual mode

|Key/Commands|Function|
|:----------:|:-------|
|ESC/Ctrl-[| Enter the normal mode.|
|Move command| Most move commands in the normal mode are available.|
|y/d/x/c| Copy/Cut/Cut/Cut and insert (`d`=`x`)|
|Y/D/X/C| Move to the end of the line, then Copy/Cut/Cut/Cut and the insert mode (`D`=`X`)|
|iw| Select the current word.|
|*| Search the selected word.|

## Available commands in the command mode

|Key/Commands|Function|
|:----------:|:-------|
|ESC/Ctrl-[| Enter the normal mode.|
|w + RETURN| Save |
|w + SPACE | Save as |
|w + q| Save and Quit |
|q | Quit |
|h | Open help of the application|

## Application-specific settings

### Q-dir

Refer [ranger](https://github.com/ranger/ranger) which is a console file manager with VI key bindings.

#### Available commands in the normal mode

|Key/Commands|Function|
|:----------:|:-------|
|h/j/k/l|Backspace(returns to the parent directory)/Down/Up/Enter(enters the selected directory or opens a file)|
|Alt+u/i/j/k| switch between Quad-Directories|
|'| menu Quick-links|

## Testing

Tests are run by executing `tests/run_vimahk_tests.ahk`. A notepad and vim window is opened, and vim_ahk is started.

The testing system used is a series of test cases in `tests/testcases.txt` representing keystrokes to send to vim_ahk. These are sent to the open vim and notepad windows, and the resulting text is compared.

The tests can be very flakey, so should be used as a guide and to execute code paths to check for errors. Tests should be run with a default ini.

## References (Japanese)

* [vim_ahkでウィンドウを定期的にチェックしてトレイアイコンを変えられる様にした](https://rcmdnk.com/blog/2017/11/22/computer-autohotkey-vim/)
* [vim_ahkで有効にするアプリの変更もメニューから出来る様にした](https://rcmdnk.com/blog/2017/11/14/computer-windows-autohotkey/)
* [vim_ahkでメニューから設定変更出来る様にした](https://rcmdnk.com/blog/2017/11/11/computer-windows-autohotkey/)
* [AutoHotkeyでToolTipを出す](https://rcmdnk.com/blog/2017/11/10/computer-windows-autohotkey/)
* [AutoHotkeyで設定ファイルの読み書きをする](https://rcmdnk.com/blog/2017/11/08/computer-windows-autohotkey/)
* [AutoHotkeyでのGUI操作](https://rcmdnk.com/blog/2017/11/07/computer-windows-autohotkey/)
* [AutoHotkeyでのメニューの追加](https://rcmdnk.com/blog/2017/11/06/computer-windows-autohotkey/)
* [AutoHotkeyで短い連続入力を認識させる方法](https://rcmdnk.com/blog/2017/11/05/computer-windows-autohotkey/)
* [AutoHotkeyで特定の条件下で設定したキー以外全てを無効にする簡単な方法](https://rcmdnk.com/blog/2017/09/03/computer-windows-autohotkey/)
* [Vim以外でVimする: Windows+AutoHotkey編](https://rcmdnk.com/blog/2013/08/03/computer-windows-autohotkey/)
