#Include UIA_Interface.ahk
UIA_ControlTypePropertyId 			:= 30003 ;// 50000 = button
UIA_LegacyIAccessibleNamePropertyId 		:= 30092
UIA_LegacyIAccessibleDescriptionPropertyId 	:= 30094

F1::
	FFWait()
	Msgbox Loaded

FFWait() {
	static uia := UIA_Interface() ;// https://github.com/jethrow/UIA_Interface
	,	c := uia.CreateAndConditionFromArray([	uia.CreatePropertyCondition(30003, 50000, 3)
						,	uia.CreatePropertyCondition(30092, "Location", 8)
						,	uia.CreateOrCondition(	uia.CreatePropertyCondition(30094,"Reload current page",8)
									,	uia.CreatePropertyCondition(30094,"Stop loading this page",8))	])
	WinGet, hwnd, ID, ahk_class MozillaWindowClass
	ff := uia.ElementFromHandle(hwnd)
	while ff.FindFirst(c,0x4).GetCurrentPropertyValue(30094) != "Reload current page"
		sleep 10
}
