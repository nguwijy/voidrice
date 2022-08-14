; redirect nav keys to home row
; alt+arrows to jikl and some more

; !r::Reload

; redirect alt+keys saving other mods
Redirect(key) {
	if GetKeyState("Shift", "D")
		if GetKeyState("Ctrl", "D")
			Send +^{%key%}
		else
			Send +{%key%}
	else if GetKeyState("Ctrl", "D")
		Send ^{%key%}
	else
		Send {%key%}
	return
}

; arrows
Alt & h::Redirect("Left")
Alt & j::Redirect("Down")
Alt & k::Redirect("Up")
Alt & l::Redirect("Right")

; home / end / pgup / pgdwn
Alt & i::Redirect("Home")
Alt & o::Redirect("End")
Alt & u::Redirect("PgUp")
Alt & d::Redirect("PgDn")

; del / backspace
Alt & m::Redirect("Delete")
Alt & n::Redirect("Backspace")

; remap caps lock to escape
Capslock::Esc