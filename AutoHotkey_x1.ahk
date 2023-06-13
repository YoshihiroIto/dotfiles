; IMPORTANT INFO ABOUT GETTING STARTED: Lines that start with a
; semicolon, such as this one, are comments.  They are not executed.

; This script has a special filename and path because it is automatically
; launched when you run the program directly.  Also, any text file whose
; name ends in .ahk is associated with the program, which means that it
; can be launched simply by double-clicking it.  You can have as many .ahk
; files as you want, located in any folder.  You can also run more than
; one .ahk file simultaneously and each will get its own tray icon.

; SAMPLE HOTKEYS: Below are two sample hotkeys.  The first is Win+Z and it
; launches a web site in the default browser.  The second is Control+Alt+N
; and it launches a new Notepad window (or activates an existing one).  To
; try out these hotkeys, run AutoHotkey again, which will load this file.

SetTitleMatchMode, Regex


; vkF2:: MouseClick, Middle,  , , 1

; ^#h:: Send,^#{Left}
; ^#l:: Send,^#{Right}

; Insert:: Send,{PrintScreen}
; !Insert:: Send,!{PrintScreen}
;
; ^Space::Send,{vkF3sc029}
;
; ; 変換キー
; vk1C::Send, {vkF3sc029}
;
; ; 無変換キー
; ; vk1D::Send, ^+{Space}
; vk1D::Send, {Pause}
;
; vk1D & 1::Send,{Blind}{F1}
; vk1D & 2::Send,{Blind}{F2}
; vk1D & 3::Send,{Blind}{F3}
; vk1D & 4::Send,{Blind}{F4}
; vk1D & 5::Send,{Blind}{F5}
; vk1D & 6::Send,{Blind}{F6}
; vk1D & 7::Send,{Blind}{F7}
; vk1D & 8::Send,{Blind}{F8}
; vk1D & 9::Send,{Blind}{F9}
; vk1D & 0::Send,{Blind}{F10}
; vk1D & -::Send,{Blind}{F11}
; vk1D & ^::Send,{Blind}{F12}
;
; vk1D & h::Send,{Blind}{Left}
; vk1D & j::Send,{Blind}{Down}
; vk1D & k::Send,{Bliwd}{Up}
; vk1D & l::Send,{Blind}{Right}
; ; vk1D & n::Send,{Blind}{PgDn}
; ; vk1D & p::Send,{Blind}{PgUp}
;
; vk1D & Esc::Send,{Blind}{Enter}
; vk1D & o::Send,{Blind}{PrintScreen}
; vk1D & p::Send,{Blind}!{PrintScreen}

; GVim 以外
; #IfWinNotActive ahk_class Vim
;     ^j:: Send,{Esc}
; #IfWinNotActive

; Google Chrome
#IfWinActive ahk_class Chrome_WidgetWin_1
    !l:: Send,^l
    ^d:: Send,^+i
#IfWinActive

; ; GVim, Window Terminal, Rider 以外
; #IfWinNotActive ahk_class Vim|CASCADIA_HOSTING_WINDOW_CLASS|SunAwt*
; ;    ^h:: Send,{BackSpace}
; ;    ^w:: Send,^{BackSpace}
;     ^m:: Send,{Enter}
;     ^n:: Send,{Down}
;     ^p:: Send,{Up}
; #IfWinNotActive

; Note: From now on whenever you run AutoHotkey directly, this script
; will be loaded.  So feel free to customize it to suit your needs.

; Please read the QUICK-START TUTORIAL near the top of the help file.
; It explains how to perform common automation tasks such as sending
; keystrokes and mouse clicks.  It also explains more about hotkeys.
