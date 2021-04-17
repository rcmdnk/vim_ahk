#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#UseHook On ; Make it a bit slow, but can avoid infinitude loop
            ; Same as "$" for each hotkey
#InstallKeybdHook ; For checking key history
                  ; Use ~500kB memory?
#HotkeyInterval 2000 ; Hotkey interval (default 2000 milliseconds).
#MaxHotkeysPerInterval 70 ; Max hotkeys per interval (default 50).

; #Warn  ; Enable warnings to assist with detecting common errors.

SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
