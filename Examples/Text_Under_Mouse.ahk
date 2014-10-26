#Include UIA_Interface.ahk
uia := UIA_Interface()

~^c::
	if GetKeyState("LButton") {
		Element := uia.ElementFromPoint()

		for each, value in [30093,30092,30045] ; lvalue,lname,value
			r := Element.GetCurrentPropertyValue(value)
		until r != ""

		if (r = "")
			r := Element.CurrentName

		Tooltip % r=""? "<No Text Found>" : "Copied: " clipboard:=r
		SetTimer, ToolTipOff, -1500
	}
	else
		Send ^c
	return

ToolTipOff:
	ToolTip
	return

	
; http://www.autohotkey.com/board/topic/94619-ahk-l-screen-reader-a-tool-to-get-text-anywhere/#entry596215
