; Auto-execute section
VimConfObj := new VimConf()
Return

; Classes, Functions
#Include %A_LineFile%\..\lib\vim_ahk_setting.ahk
#Include %A_LineFile%\..\lib\vim_ime.ahk

#Include %A_LineFile%\..\lib\vim_about.ahk
#Include %A_LineFile%\..\lib\vim_check.ahk
#Include %A_LineFile%\..\lib\vim_conf.ahk
#Include %A_LineFile%\..\lib\vim_icon_mng.ahk
#Include %A_LineFile%\..\lib\vim_ini.ahk
#Include %A_LineFile%\..\lib\vim_menu.ahk
#Include %A_LineFile%\..\lib\vim_move.ahk
#Include %A_LineFile%\..\lib\vim_setting.ahk
#Include %A_LineFile%\..\lib\vim_state.ahk

; Bindings
#Include %A_LineFile%\..\lib\vim_bind_shortcut.ahk
#Include %A_LineFile%\..\lib\vim_bind_enter_normal.ahk
#Include %A_LineFile%\..\lib\vim_bind_enter_insert.ahk
#Include %A_LineFile%\..\lib\vim_bind_repeat.ahk
#Include %A_LineFile%\..\lib\vim_bind_normal.ahk
#Include %A_LineFile%\..\lib\vim_bind_move.ahk
#Include %A_LineFile%\..\lib\vim_bind_ydcxp.ahk
#Include %A_LineFile%\..\lib\vim_bind_visual.ahk
#Include %A_LineFile%\..\lib\vim_bind_search.ahk
#Include %A_LineFile%\..\lib\vim_bind_disable.ahk

; Reset the condition
#If
