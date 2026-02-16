# vim_ahk

AutoHotkey scripts and executable builds for Vim emulation on Windows.

`vim.ahk` is the main script for [AutoHotkey](https://www.autohotkey.com/).

`vim_ahk.exe` is a standalone executable built from `vim.ahk` (available on [Releases](https://github.com/rcmdnk/vim_ahk/releases)).

If you are looking for similar behavior on macOS, see [Karabiner-Elements complex_modifications rules by rcmdnk](https://rcmdnk.com/KE-complex_modifications/).

## AutoHotkey v1 or v2

This script is for AutoHotkey v2.

If you are using AutoHotkey v1, please use release [v0.13.2](https://github.com/rcmdnk/vim_ahk/tree/v0.13.2) (or [ahk_v1](https://github.com/rcmdnk/vim_ahk/tree/ahk_v1) branch).

## Installation

### Scripts

If AutoHotkey is already installed, open `vim.ahk` with AutoHotkey.

If you run AutoHotkey with another script, include `vim.ahk` from that script.
Copy `vim.ahk` and the `lib` directory under the same parent directory as your script, then add:

    #Include  %A_LineFile%\..\vim.ahk

to the end of the <a href="https://www.autohotkey.com/docs/v2/Scripts.htm#auto">auto-execute section</a>.

### Executable

You can also use **vim_ahk.exe**, which runs standalone without AutoHotkey.

Download the latest zip from [Releases](https://github.com/rcmdnk/vim_ahk/releases), extract it, and run **vim_ahk.exe**.

> [!NOTE]
> Place the **vim_ahk_icons** folder in the same directory as **vim_ahk.exe**.
> Otherwise, tray menu icons will not work.

### Build executable from the source

Clone this repository, move to the `vim_ahk` directory, and run **build.bat**.

* Double-click the file.
* Or run `.\build.bat` in PowerShell or Command Prompt.

This creates a **vim_ahk** folder containing **vim_ahk.exe** and **vim_ahk_icons**.

## Applications (VimGroup)
By default, vim mode is enabled for:

* Notepad (メモ帳)
* WordPad
* TeraPad
* Windows Explorer
* Thunderbird (only sending window)
* Microsoft PowerPoint
* Microsoft Word
* Evernote
* Visual Studio Code
* TeXworks
* TeXstudio
* Q-dir
* OneNote
* Apps running under `ahk_exe ApplicationFrameHost.exe`

You can change this list from the tray icon's right-click menu
(find `VimMenu`-`Settings` in the list),
or launch the setting window by `Ctrl-Alt-Shift-v`.

If you want to configure applications directly in script, set `VimGroup`
before `Vim := VimAhk(A_LineFile)` in `vim.ahk`,
or set it before `#Include` in your own script.
You can inspect title/class/process with AutoHotkey Window Spy.

Example line:

    VimGroup := "ahk_exe chrome.exe,ahk_exe firefox.exe"

Specify multiple applications as a comma-separated list.

> [!NOTE]
> Setting `VimGroup` this way replaces the default list.
> To **add** entries while keeping defaults, append the default entries after your own list:
> 
>     ahk_exe notepad.exe,ahk_exe explorer.exe,ahk_exe wordpad.exe,ahk_exe TeraPad.exe,作成,Write:,ahk_exe POWERPNT.exe,ahk_exe WINWORD.exe,ahk_exe Evernote.exe,ahk_exe Code.exe,ahk_exe onenote.exe,OneNote,ahk_exe texworks.exe,ahk_exe texstudio.exe
> 
> Or configure this from the GUI settings window described below.

By default, `VimSetTitleMatchMode` is `2` (`Contain`).

If you set `OneNote`, all windows with a title containing `OneNote`
(e.g. `XXX's OneNote`) will be included.
If you set `VimSetTitleMatchMode` as 3, only the exact title of `OneNote` will be included.

It may not work on OneNote. OneNote may have a window name like
**User's Notebook - OneNote**, instead of **OneNote**.

In that case, check the OneNote window title in Window Spy.

Window Spy shows Window Title, Class, and Process, for example:

    User's Notebook - OneNote
    ahk_class ApplicationFrameWindow
    ahk_exe ApplicationFrameHost.exe

If you add any of these lines to `VimGroup`, vim_ahk will work on OneNote.
If you set `ahk_class ApplicationFrameWindow` or `ahk_exe ApplicationFrameHost.exe`,
vim_ahk will also match other apps that use the same class/process
(many Microsoft Store apps).

Examples of applications:

* Chrome: `ahk_exe chrome.exe`
* Firefox: `ahk_exe firefox.exe`
* Excel: `ahk_exe EXCEL.EXE`
* LibreOffice: `ahk_exe soffice.bin` (for all LibreOffice applications)

## Options

In addition to `VimGroup`, you can set the following options in your script.
All of them can also be changed from the settings GUI.

|Option|Description|Default|
|:-----|:----------|:------|
|VimEscNormal|If 1, pressing ESC enters normal mode.|1|
|VimEscNormalDirect|If 1, ESC enters normal mode even while IME is converting. If 0, ESC behaves as normal ESC while IME is converting.|1|
|VimSendEscNormal|If 1, a short ESC press sends ESC in normal mode.|0|
|VimLongEscNormal|If 1, short and long press behavior of ESC is swapped.|0|
|VimCtrlBracketToEsc|If 1, Ctrl-[ behaves as ESC.<br>If VimCtrlBracketNormal is 0, Ctrl-[ always sends ESC.<br>If both are 1, long press Ctrl-[ sends ESC.|1|
|VimCtrlBracketNormal|If 1, pressing Ctrl-[ enters normal mode.|1|
|VimCtrlBracketNormalDirect|If 1, Ctrl-[ enters normal mode even while IME is converting. If 0, Ctrl-[ behaves as ESC while IME is converting.|1|
|VimSendCtrlBracketNormal|If 1, a short Ctrl-[ press sends Ctrl-[ in normal mode.|0|
|VimLongCtrlBracketNormal|If 1, short and long press behavior of Ctrl-[ is swapped.|0|
|VimChangeCaretWidth|If 1, caret width changes by mode (thick in normal/visual, thin in insert).|0|
|VimRestoreIME|If 1, IME status is saved in insert mode and restored when returning to insert mode.|1|
|VimJJ|If 1, `jj` enters normal mode from insert mode.|0|
|VimTwoLetter|Two-letter mappings to enter normal mode from insert mode.<br>Set one pair per line, exactly two different letters per pair.||
|VimDisableUnused|Disable level for unused keys outside insert mode:<br><ol><li>Do not disable unused keys</li><li>Disable alphabets (+Shift) and symbols</li><li>Disable all, including modified keys (e.g. Ctrl+Z)</li></ol>|1|
|VimSetTitleMatchMode|SetTitleMatchMode mode:<br><ol><li>Start with</li><li>Contain</li><li>Exact match</li><li>Regular expression (`RegEx`)</li></ol>|2|
|VimSetTitleMatchModeFS|SetTitleMatchMode speed:<br><ol><li>Fast: Text is not detected for some edit controls.</li><li>Slow: Works for all windows, but slower.</li></ol>|Fast|
|VimIconCheckInterval|Interval (ms) to check vim_ahk status and update tray icon.<br>If set to 0, the original AHK icon is used.|1000|
|VimVerbose|Verbose level:<br><ol><li>No output.</li><li>Minimum tooltip (mode only).</li><li>Tooltip (all information).</li><li>Debug message box (does not auto-close).</li></ol>|1|
|VimAppList|Application list mode:<br><ul><li>All: Enable vim_ahk on all applications (ignore the list).</li><li>Allow List: Use the list as an allow list.</li><li>Deny List: Use the list as a deny list.</li></ul>|Allow List|
|VimGroup|Applications where vim_ahk is enabled. Set one application per line (Window Title/Class/Process).|See **Applications** section|

Set options before including **vim.ahk** in your script
inside the auto-execute section, for example:

    VimVerbose := 2
    #Include \path\to\vim.ahk

If you want to change them directly in `vim.ahk`,
set these variables before `Vim := VimAhk(A_LineFile)`.

> [!NOTE]
> These variables overwrite default values.
> After checking these variables, the configuration file is read.
> If you have already run vim_ahk, the configuration file already exists and settings are loaded from it.
> To apply updated script defaults, use `Reset` in the settings GUI.

> [!NOTE]
> VimIconCheckInterval example
>
> If `VimIconCheckInterval` is non-zero, the tray icon changes
> when mode changes or focus moves between enabled/disabled apps.
>
> ![trayicon](https://raw.githubusercontent.com/rcmdnk/vim_ahk/master/pictures/trayicon.gif "trayicon")

> [!WARNING]
> VimChangeCaretWidth
>
> Caret width can be changed only in specific applications: WordPad, Word, and OneNote.
> On Notepad or Explorer, the caret width is kept but does not change.
>
> For most other applications, the caret width is kept as the original width.
>
> When this option is enabled, the current window briefly loses focus when the mode is changed.
>
> If you enable this option and switch to a thick caret in normal mode, then disable the option,
> the cursor may remain thick.
> To revert it, re-enable the option, enter insert mode in a supported app (for example WordPad), then disable it again.

## GUI Option Setting Window

You can change these options from the tray icon right-click menu
(find `VimMenu`-`Settings` in the list),
or launch the setting window by `Ctrl-Alt-Shift-v`.

![traymenu](https://raw.githubusercontent.com/rcmdnk/vim_ahk/master/pictures/traymenu.jpg "traymenu")

![settings_keys](https://raw.githubusercontent.com/rcmdnk/vim_ahk/master/pictures/settings_keys.png "settings_keys")
![settings_applications](https://raw.githubusercontent.com/rcmdnk/vim_ahk/master/pictures/settings_applications.png "settings_applications")
![settings_status](https://raw.githubusercontent.com/rcmdnk/vim_ahk/master/pictures/settings_status.png "settings_status")
![settings_configuration](https://raw.githubusercontent.com/rcmdnk/vim_ahk/master/pictures/settings_configuration.png "settings_configuration")

Here you can add applications, change mode-switch keys, adjust verbose level,
or import/export the configuration file.

If you import a configuration file, settings are staged and only applied
when you click `Apply` or `OK`.

If you click `Reset`, default settings are shown in the window.
They are applied only when you click `Apply` or `OK`.

These **default settings** are then overridden by
your script-level `VimXXX` options described above.
(`Reset` restores built-in defaults plus your script defaults.)

## Global shortcut keys

|Key|Function|
|:----------:|:-------|
|Ctrl-Alt-Shift-v|Open the GUI settings window.|
|Ctrl-Alt-Shift-s|Suspend/resume vim_ahk.|
|Ctrl-Alt-Shift-c|Show the status window (only in VimGroup apps).|

## Main Modes

The main modes are:

|Mode|Description|
|:---|:----------|
|Insert mode|Default Windows input state.|
|Normal mode|Vim-like movement and command mode (`hjkl`, `w`, and more).|
|Visual mode|Character-wise and line-wise selection mode.|
|Command mode|Command-line mode for save/quit style commands.|

The initial state is insert mode. Press `ESC` or `Ctrl-[` to enter normal mode.

In normal mode, press `i` to return to insert mode.

Press `v` for character-wise visual mode and `V` for line-wise visual mode.

Press `:` to enter command mode with save/quit commands.

## Available commands in the insert mode

|Key/Commands|Function|
|:----------:|:-------|
|ESC/Ctrl-[|Enter normal mode. Long press (0.5s) sends the original ESC/Ctrl-[ key.|
|jj|Enter the normal mode, if enabled.|
|Custom two letters|If two-letter mapping is set.|

ESC/Ctrl-[ turn off IME if IME is on.
ESC behaves as normal ESC while IME is in conversion.
Ctrl-[ switches off IME and enters the normal mode even if IME is on.

If `VimLongEscNormal` (`VimLongCtrlBracketNormal`) is disabled (`0`), long-press ESC (Ctrl-[) sends the original key.

If `VimLongEscNormal` (`VimLongCtrlBracketNormal`) is enabled,
a single press sends the original key
and a long press will change the mode to the normal mode.

If using a custom two-letter hotkey to enter the normal mode, the two letters must be different.

> [!WARNING]
> A character can be used in only one two-letter mapping. If you set `ab` and `bc`, `ba` (press `b` then `a`) does not work.


## Available commands in the normal mode

### Mode Change

|Key/Commands|Function|
|:----------:|:-------|
|i/I/a/A/o/O|Enter insert mode (cursor/start of line/next char/end of line/new line below/new line above).|
|v/V/Ctrl-v|Enter visual mode (character-wise/line-wise/block-like behavior).|
|:|Enter command-line mode.|

### Move

|Key/Commands|Function|
|:----------:|:-------|
|h/j/k/l|Left/Down/Up/Right.|
|0/$| Move to the start/end of the line.|
|Ctrl-a/Ctrl-e|Move to the start/end of the line (Emacs-like).|
|^| Move to the starting non-whitespace character of the line.|
|w/W| Move to the beginning of the next word.|
|e/E| Move to the end of the word. (Actually, move to the beginning of the next word and move one character left.)|
|b/B| Move to the beginning of the previous word.|
|Ctrl-u/Ctrl-d|Move up/down 10 lines.|
|Ctrl-b/Ctrl-f| PageUp/PageDown.|
|gg/G|Go to the top/bottom of the file.|
|Space| Right.|
|Enter| Move to the beginning of the next line.|

> [!NOTE]
> Enter movement works only in editor-like apps; in Explorer/Q-dir it behaves as normal Enter.

Repeat counts are available for many commands.

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

y/d/c + move command combinations are also available.
* e.g.) `yw` -> copy next one word.
* e.g.) `d3w` -> delete next 3 words.

### Others

|Key/Commands|Function|
|:----------:|:-------|
|u/Ctrl-r| Undo/Redo.|
|r/R| Replace one character/multiple characters.|
|J| Combine two lines.|
|.|Replace the following word with clipboard content (useful with search).|
|~| Change case.|
|/|Start search (opens find box).|
|n/N|Search next/previous (some apps support only next).|
|*| Search the word under the cursor.|
|ZZ/ZQ|Save and Quit/Quit.|

## Available commands in visual mode

|Key/Commands|Function|
|:----------:|:-------|
|ESC/Ctrl-[| Enter the normal mode.|
|Move command| Most move commands in the normal mode are available.|
|y/d/x/c|Copy/Cut/Cut/Cut+insert (`d` = `x`).|
|Y/D/X/C|Move to end of line, then Copy/Cut/Cut/Cut+insert (`D` = `X`).|
|iw| Select the current word.|
|*| Search the selected word.|

## Available commands in the command mode

|Key/Commands|Function|
|:----------:|:-------|
|ESC/Ctrl-[| Enter the normal mode.|
|w + RETURN|Save.|
|w + SPACE|Save as.|
|w + q|Save and quit.|
|q|Quit.|
|h|Open application help.|

## Application-specific settings

### Q-dir

Inspired by [ranger](https://github.com/ranger/ranger), a console file manager with VI key bindings.

#### Available commands in the normal mode

|Key/Commands|Function|
|:----------:|:-------|
|h/l|Go back/forward in directory history.|
|i/k|Select down/up.|
|Alt+u/i/j/k| Select left upper/right upper/left lower/right lower pane.|
|'|Open Quick-links menu.|

## Testing

Run tests with `tests/run_vimahk_tests.ahk`. It opens Notepad and a Vim window, then starts vim_ahk.

The test system uses `tests/testcases.txt`, which defines keystroke sequences sent to vim_ahk.
The resulting text in the opened windows is then compared.

These tests can be flaky, so use them as guidance and for path coverage/error checks.
Run tests with a default INI.

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
