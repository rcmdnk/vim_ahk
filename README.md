vim_ahk
=======

Setting file/exe file of AutoHotkey for Vim emulation.

vim.ahk is setting file for [AutoHotkey](http://www.autohotkey.com/)(Autohotkey_L).

vim.exe is standalone application made from vim.ahk.

## Installation
If you've already installed Autohotkey, just open vim.ahk with AotoHotkey.

You can also use vim.exe, which can work standalone w/o Autohotkey.

If you are running Autohotkey with another script,
you can include it in your script, such AutoHotkey.
Please put vim.ahk in `\Users\%username%\Documents`
or where the script is in,
and add following line in AutoHotkey.ahk or your script:

    #Include  %A_ScriptDir%\vim.ahk

at the end of <a href="http://www.autohotkey.com/docs/Scripts.htm#auto">Auto-execute section</a>.

## Applications
The default setting enables vim mode for following applicaitons:

* Notepad (メモ帳)
* Wordpad
* TeraPad
* Exploler
* Thunderbird (only sending window)
* Power Point
* Word
* Evernote

If you want to change applications, add/remove `GroupAdd` lines on the top of vim.ahk.
(Window title/class can be seen by window spy in AutoHotkey.)

## Verbose level
vim.ahk can show information of vim mode in different level.

* 0 : Nothing
* 1 : Only mode in task tray tips.
* 2 : Mode and g-mode information, n (number of repeat) in task tray tips.
* 3 : Mode and g-mode information, n (number of repeat) in task tray tips and message box.

The default verbose level is 2.

## Main Modes
Here are main modes.

|Mode|Description|
|:---|:----------|
|Insert Mode|Normal Windows state|
|Normal Mode|As in vim, a cursor is moved by hjkl, w, etc... and some vim like commands are available.|
|Visual Mode|There are three visual mode: Character-wise, Line-wise, and Block-wise. Block-wise visual mode is valid only for applications which support block-wise selection (such TeraPad).|
|Command Mode|Can be used for saving file/quitting.|

An initial state is `Insert Mode`, then `Esc` or `Ctrl-[` brings you to the normal mode.

In the normal mode, `i` is the key to be back to the insert mode.

`v`, `V` and `Ctrl-v` are the key to the Character-wise, Line-wise, and Block-wise
visual mode, respectively.

After push `:`, a few commands to save/quit are available.


## Available commands at Insert mode
|Key/Commands|Function|
|:----------:|:-------|
|ESC/Ctrl-[| Enter Normal mode. Holding (0.5s) these keys emulate normal ESC.|

Both keys switch off IME if IME is on.
ESC acts as ESC when IME on and converting.
Ctrl-[ switch off IEM and enter Normal mode even if IME is on.

## Available commands at Normal mode
### Mode Change
|Key/Commands|Function|
|:----------:|:-------|
|i/I/a/A/o/O| Enter the insert mode at under the cursor/start of the line/next to the cursor/end of the line/next line/previous line.|
|v/V/Ctrl-v|Enter the visual mode of Character-wise/Line-wise/Block-wise.|
|:|Enter the command line mode|

### Move
|Key/Commands|Function|
|:----------:|:-------|
|h/j/k/l|Left/Down/Up/Right.|
|0/$| To the beginning/last of the line.|
|Ctrl-a/Ctrl-e| To the beginning/last of the line (emacs like).|
|^| To the character of the line.|
|w/W/e/E| Move a word forward (all work as same: go to the beginning of the word).|
|b/B| Move a word backward (b/B:  the beginning of the word).|
|Ctrl-u/Ctrl-d| Go Up/Down 10 line.|
|Ctrl-b/Ctrl-f| PageUp/PageDown.|
|gg/G| Go to the top/bottom of the file|

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
|cc| Change the line (enter Insert mode).|
|C| Cut from here to the end of the line and enter Insert mode.|
|x/X| Delete a character under/before the cursor (not registered in the clipboard).|
|p/P| Paste to the next/current place. If copy/cut was done with line-wise Visual mode, it pastes to the next/current line. Some commands (such yy/dd) also force to paste as line-wise.|

y/d/c+Move Command can be used, too.
* e.g.) `yw` -> copy next one word.
* e.g.) `d3w` -> delete next 3 words.

### Others
|Key/Commands|Function|
|:----------:|:-------|
|u/Ctrl-r| Undo/Redo.|
|r/R| Replace one character/multi characters.|
|J| Combine two lines.|
|.| It is fixed to do: `Replace a following word with a clipboard` (useful to use with a search).|
|~| Change case.|
|/| Start search (search box will be opened)|
|n/N| Search next/previous (Some applications support only next search)|
|*| Search the word under the cursor.|
|ZZ/ZQ|Save and Quit/Quit.|

## Available commands at Visual mode
|Key/Commands|Function|
|:----------:|:-------|
|ESC/Ctrl-[| Enter Normal mode.|
|Move command| Most of move commands in the normal mode are available.|
|y/d/x/c| Copy/Cut/Cut/Cut and insert (`d`=`x`)|
|Y/D/X/C| Move to the end of line, then Copy/Cut/Cut/Cut and insert (`D`=`X`)|
|*| Search the selected word.|

## Available commands at Command mode
|Key/Commands|Function|
|:----------:|:-------|
|ESC/Ctrl-[| Enter Normal mode.|
|w + RETURN| Save |
|w + SPACE | Save as |
|w + q| Save and Quit |
|q | Quit |
|h | Open help of the application|


# Bonus
vim_ime.exe is execute file which enable automatic IME off on Vim (at mode change of Insert->Normal Mode).
The setting file can be found in the [gist](https://gist.github.com/rcmdnk/6147672).
