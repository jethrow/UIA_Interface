class UIA_Base {
	__New(p="") {
		ObjInsert(this, "__Type", "IUIAutomation" SubStr(this.__Class,5))
		ObjInsert(this, "__Value", p)
	}
	__Get(member) {
		if member not in base,__Class,__UIA ; base, __Class, & __UIA should act as normal
			if RegExMatch(this.base.get_properties, "i)\|" member ",(\d+),(\w+)", m) { ; if the member is in the properties. if not - give error message
				if (m2="RECT") ; return RECT struct - DllCall output param different
					return UIA_Hr(DllCall(this.Vt(m1), "ptr",this.__Value, "ptr",&(rect,VarSetCapacity(rect,16))))? UIA_RectToObject(rect):
				else if UIA_Hr(DllCall(this.Vt(m1), "ptr",this.__Value, "ptr*",out))
					return m2="BSTR"? StrGet(out):RegExMatch(m2,"i)IUIAutomation\K\w+",n)? new UIA_%n%(out):out ; Bool, int, DWORD, HWND, CONTROLTYPEID, OrientationType?
			} else {
				MsgBox, 262160, % this.__Class " Get Error", Property "%member%" is not supported.
				return
			}
	}
	__Set(member) {
		MsgBox, 262160, % this.__Class " Set Error", Property "%member%" cannot be assigned a value.
		return
	}
	__Call(member) {
		if !ObjHasKey(UIA_Base,member)&&!ObjHasKey(this,member)
			MsgBox, 262160, % this.__Class " Call Error", Method "%member%" is not supported.
	}
	__Delete() {
		ObjRelease(this.__Value)
	}
	Vt(n) {
		return NumGet(NumGet(this.__Value+0,"ptr")+n*A_PtrSize,"ptr")
	}
}	

class UIA_Interface extends UIA_Base {
	;~ http://msdn.microsoft.com/en-us/library/windows/desktop/ee671406(v=vs.85).aspx
	static IID := "{30cbe57d-d9d0-452a-ab13-7ac5ac4825ee}"
	static get_properties := "|ControlViewWalker,14,IUIAutomationTreeWalker|ContentViewWalker,15,IUIAutomationTreeWalker|RawViewWalker,16,IUIAutomationTreeWalker|RawViewCondition,17,IUIAutomationCondition|ControlViewCondition,18,IUIAutomationCondition|ContentViewCondition,19,IUIAutomationCondition|ProxyFactoryMapping,48,IUIAutomationProxyFactoryMapping|ReservedNotSupportedValue,54,IUnknown|ReservedMixedAttributeValue,55,IUnknown|"
	
	CompareElements(e1,e2) {
		return UIA_Hr(DllCall(this.Vt(3), "ptr",this.__Value, "ptr",e1.__Value, "ptr",e2.__Value, "int*",out))? out:
	}
	CompareRuntimeIds(r1,r2) {
		return UIA_Hr(DllCall(this.Vt(4), "ptr",this.__Value, "ptr",ComObjValue(r1), "ptr",ComObjValue(r2), "int*",out))? out:
	}
	GetRootElement() {
		return UIA_Hr(DllCall(this.Vt(5), "ptr",this.__Value, "ptr*",out))? new UIA_Element(out):
	}
	ElementFromHandle(hwnd) {
		return UIA_Hr(DllCall(this.Vt(6), "ptr",this.__Value, "ptr",hwnd, "ptr*",out))? new UIA_Element(out):
	}
	ElementFromPoint(x="", y="") {
		return UIA_Hr(DllCall(this.Vt(7), "ptr",this.__Value, "int64",x==""||y==""?0*DllCall("GetCursorPos","Int64*",pt)+pt:x&0xFFFFFFFF|y<<32, "ptr*",out))? new UIA_Element(out):
	}	
	GetFocusedElement() {
		return UIA_Hr(DllCall(this.Vt(8), "ptr",this.__Value, "ptr*",out))? new UIA_Element(out):
	}
	;~ GetRootElementBuildCache 	9
	;~ ElementFromHandleBuildCache 	10
	;~ ElementFromPointBuildCache 	11
	;~ GetFocusedElementBuildCache 	12
	CreateTreeWalker() {
		return UIA_Hr(DllCall(this.Vt(13), "ptr",this.__Value, "ptr",pCondition, "ptr*",out))? new UIA_TreeWalker(out):
	}
	;~ CreateCacheRequest 	20
	CreateTrueCondition() {
		return UIA_Hr(DllCall(this.Vt(21), "ptr",this.__Value, "ptr*",out))? new UIA_Condition(out):
	}
	CreateFalseCondition() {
		return UIA_Hr(DllCall(this.Vt(22), "ptr",this.__Value, "ptr*",out))? new UIA_Condition(out):
	}
	;~ CreatePropertyCondition 	23
	;~ CreatePropertyConditionEx 	24
	;~ CreateAndCondition 	25
	;~ CreateAndConditionFromArray 	26
	;~ CreateAndConditionFromNativeArray 	27
	;~ CreateOrCondition 	28
	;~ CreateOrConditionFromArray 	29
	;~ CreateOrConditionFromNativeArray 	30
	;~ CreateNotCondition 	31
	;~ AddAutomationEventHandler 	32
	;~ RemoveAutomationEventHandler 	33
	;~ AddPropertyChangedEventHandlerNativeArray 	34
	;~ AddPropertyChangedEventHandler 	35
	;~ RemovePropertyChangedEventHandler 	36
	;~ AddStructureChangedEventHandler 	37
	;~ RemoveStructureChangedEventHandler 	38
	;~ AddFocusChangedEventHandler 	39
	;~ RemoveFocusChangedEventHandler 	40
	;~ RemoveAllEventHandlers 	41
	IntNativeArrayToSafeArray(ByRef nArr, n="") {
		return UIA_Hr(DllCall(this.Vt(42), "ptr",this.__Value, "ptr",&nArr, "int",n?n:VarSetCapacity(nArr)/4, "ptr*",out))? ComObj(0x2003,out,1):
	}
	;~ IntSafeArrayToNativeArray(sArr, Byref nArr="", Byref arrayCount="") { ; NOT WORKING
		;~ VarSetCapacity(nArr,(sArr.MaxIndex()+1)*4)
		;~ return UIA_Hr(DllCall(this.Vt(43), "ptr",this.__Value, "ptr",ComObjValue(sArr), "ptr*",nArr, "int*",arrayCount))? arrayCount:
	;~ }
	RectToVariant(ByRef rect, ByRef out="") {	; in:{left,top,right,bottom} ; out:(left,top,width,height)
		; in:	RECT Struct
		; out:	AHK Wrapped SafeArray & ByRef Variant
		return UIA_Hr(DllCall(this.Vt(44), "ptr",this.__Value, "ptr",&rect, "ptr",UIA_Variant(out)))? UIA_VariantData(out):
	}
	;~ VariantToRect(ByRef var, ByRef out="") { ; NOT WORKING
		;~ ; in:	VT_VARIANT (SafeArray)
		;~ ; out:	AHK Wrapped RECT Struct & ByRef Struct
		;~ return UIA_Hr(DllCall(this.Vt(45), "ptr",this.__Value, "ptr",var, "ptr",&(out,VarSetCapacity(out,16))))? UIA_RectToObject(out):
	;~ }
	;~ SafeArrayToRectNativeArray 	46
	;~ CreateProxyFactoryEntry 	47
	GetPropertyProgrammaticName(Id) {
		return UIA_Hr(DllCall(this.Vt(49), "ptr",this.__Value, "int",Id, "ptr*",out))? StrGet(out):
	}
	GetPatternProgrammaticName(Id) {
		return UIA_Hr(DllCall(this.Vt(50), "ptr",this.__Value, "int",Id, "ptr*",out))? StrGet(out):
	}
	PollForPotentialSupportedPatterns(e, Byref Ids="", Byref Names="") {
		return UIA_Hr(DllCall(this.Vt(51), "ptr",this.__Value, "ptr",e.__Value, "ptr*",Ids, "ptr*",Names))? UIA_SafeArraysToObject(Names:=ComObj(0x2008,Names,1),Ids:=ComObj(0x2003,Ids,1)):
	}
	PollForPotentialSupportedProperties(e, Byref Ids="", Byref Names="") {
		return UIA_Hr(DllCall(this.Vt(52), "ptr",this.__Value, "ptr",e.__Value, "ptr*",Ids, "ptr*",Names))? UIA_SafeArraysToObject(Names:=ComObj(0x2008,Names,1),Ids:=ComObj(0x2003,Ids,1)):
	}
	CheckNotSupported(value) { ; Useless in this Framework???
	/*	Checks a provided VARIANT to see if it contains the Not Supported identifier.
		After retrieving a property for a UI Automation element, call this method to determine whether the element supports the 
		retrieved property. CheckNotSupported is typically called after calling a property retrieving method such as GetCurrentPropertyValue.
	*/
		return UIA_Hr(DllCall(this.Vt(53), "ptr",this.__Value, "ptr",value, "int*",out))? out:
	}
	ElementFromIAccessible(IAcc, childId=0) {
	/* The method returns E_INVALIDARG - "One or more arguments are not valid" - if the underlying implementation of the
	Microsoft UI Automation element is not a native Microsoft Active Accessibility server; that is, if a client attempts to retrieve
	the IAccessible interface for an element originally supported by a proxy object from Oleacc.dll, or by the UIA-to-MSAA Bridge.
	*/
		return UIA_Hr(DllCall(this.Vt(56), "ptr",this.__Value, "ptr",ComObjValue(IAcc), "int",childId, "ptr*",out))? new UIA_Element(out):
	}
	;~ ElementFromIAccessibleBuildCache 	57
}

class UIA_Element extends UIA_Base {
	;~ http://msdn.microsoft.com/en-us/library/windows/desktop/ee671425(v=vs.85).aspx
	static IID := "{d22108aa-8ac5-49a5-837b-37bbb3d7591e}"
	static get_properties := "|CurrentProcessId,20,int|CurrentControlType,21,CONTROLTYPEID|CurrentLocalizedControlType,22,BSTR|CurrentName,23,BSTR|CurrentAcceleratorKey,24,BSTR|CurrentAccessKey,25,BSTR|CurrentHasKeyboardFocus,26,BOOL|CurrentIsKeyboardFocusable,27,BOOL|CurrentIsEnabled,28,BOOL|CurrentAutomationId,29,BSTR|CurrentClassName,30,BSTR|CurrentHelpText,31,BSTR|CurrentCulture,32,int|CurrentIsControlElement,33,BOOL|CurrentIsContentElement,34,BOOL|CurrentIsPassword,35,BOOL|CurrentNativeWindowHandle,36,UIA_HWND|CurrentItemType,37,BSTR|CurrentIsOffscreen,38,BOOL|CurrentOrientation,39,OrientationType|CurrentFrameworkId,40,BSTR|CurrentIsRequiredForForm,41,BOOL|CurrentItemStatus,42,BSTR|CurrentBoundingRectangle,43,RECT|CurrentLabeledBy,44,IUIAutomationElement|CurrentAriaRole,45,BSTR|CurrentAriaProperties,46,BSTR|CurrentIsDataValidForForm,47,BOOL|CurrentControllerFor,48,IUIAutomationElementArray|CurrentDescribedBy,49,IUIAutomationElementArray|CurrentFlowsTo,50,IUIAutomationElementArray|CurrentProviderDescription,51,BSTR|CachedProcessId,52,int|CachedControlType,53,CONTROLTYPEID|CachedLocalizedControlType,54,BSTR|CachedName,55,BSTR|CachedAcceleratorKey,56,BSTR|CachedAccessKey,57,BSTR|CachedHasKeyboardFocus,58,BOOL|CachedIsKeyboardFocusable,59,BOOL|CachedIsEnabled,60,BOOL|CachedAutomationId,61,BSTR|CachedClassName,62,BSTR|CachedHelpText,63,BSTR|CachedCulture,64,int|CachedIsControlElement,65,BOOL|CachedIsContentElement,66,BOOL|CachedIsPassword,67,BOOL|CachedNativeWindowHandle,68,UIA_HWND|CachedItemType,69,BSTR|CachedIsOffscreen,70,BOOL|CachedOrientation,71,OrientationType|CachedFrameworkId,72,BSTR|CachedIsRequiredForForm,73,BOOL|CachedItemStatus,74,BSTR|CachedBoundingRectangle,75,RECT|CachedLabeledBy,76,IUIAutomationElement|CachedAriaRole,77,BSTR|CachedAriaProperties,78,BSTR|CachedIsDataValidForForm,79,BOOL|CachedControllerFor,80,IUIAutomationElementArray|CachedDescribedBy,81,IUIAutomationElementArray|CachedFlowsTo,82,IUIAutomationElementArray|CachedProviderDescription,83,BSTR|"
	
	SetFocus() {
		return UIA_Hr(DllCall(this.Vt(3), "ptr",this.__Value))
	}
	GetRuntimeId(ByRef stringId="") {
		return UIA_Hr(DllCall(this.Vt(4), "ptr",this.__Value, "ptr*",sa))? ComObj(0x2003,sa,1):
	}
	FindFirst(scope=0x2, cond="") {
		return UIA_Hr(DllCall(this.Vt(5), "ptr",this.__Value, "uint",scope, "ptr",(cond=""?tc:=this.__uia.CreateTrueCondition():cond).__Value, "ptr*",out))? new UIA_Element(out):
	}
	FindAll(scope=0x2, cond="") {
		return UIA_Hr(DllCall(this.Vt(6), "ptr",this.__Value, "uint",scope, "ptr",(cond=""?tc:=this.__uia.CreateTrueCondition():cond).__Value, "ptr*",out))? UIA_ElementArray(out):
	}
	;~ FindFirstBuildCache 	7	IUIAutomationElement
	;~ FindAllBuildCache 	8	IUIAutomationElementArray
	;~ BuildUpdatedCache 	9	IUIAutomationElement
	GetCurrentPropertyValue(propertyid, ByRef out="") {
		return UIA_Hr(DllCall(this.Vt(10), "ptr",this.__Value, "uint",propertyid, "ptr",UIA_Variant(out)))? UIA_VariantData(out):
	}
	;~ GetCurrentPropertyValueEx 	11	VARIANT
	;~ GetCachedPropertyValue 	12	VARIANT
	;~ GetCachedPropertyValueEx 	13	VARIANT
	GetCurrentPatternAs(patternid=10018) { ; Only LegacyIAccessible so far
		return UIA_Hr(DllCall(this.Vt(14), "ptr",this.__Value, "int",patternid, "ptr",UIA_GUID(iid,UIA_LegacyIAccessiblePattern.iid), "ptr*",out))? new UIA_LegacyIAccessiblePattern(out):
	}
	;~ GetCachedPatternAs 	15	void **ppv
	;~ GetCurrentPattern 	16	Iunknown **patternObject
	;~ GetCachedPattern 	17	Iunknown **patternObject
	;~ GetCachedParent 	18	IUIAutomationElement
	;~ GetCachedChildren 	19	IUIAutomationElementArray
	;~ GetClickablePoint 	84	POINT, BOOL
}

class UIA_ElementArray extends UIA_Base {
	;~ http://msdn.microsoft.com/en-us/library/windows/desktop/ee671426(v=vs.85).aspx
	static IID := "{14314595-b4bc-4055-95f2-58f2e42c9855}"
	static get_properties := "|Length,3,int|"
	
	GetElement(i) {
		return UIA_Hr(DllCall(this.Vt(4), "ptr",this.__Value, "int",i, "ptr*",out))? new UIA_Element(out):
	}
}

class UIA_LegacyIAccessiblePattern extends UIA_Base {
	;~ http://msdn.microsoft.com/en-us/library/windows/desktop/ee696074(v=vs.85).aspx
	static IID := "{828055ad-355b-4435-86d5-3b51c14a9b1b}"
	static get_properties := "|CurrentChildId,6,int|CurrentName,7,BSTR|CurrentValue,8,BSTR|CurrentDescription,9,BSTR|CurrentRole,10,DWORD|CurrentState,11,DWORD|CurrentHelp,12,BSTR|CurrentKeyboardShortcut,13,BSTR|CurrentDefaultAction,15,BSTR|CachedChildId,16,int|CachedName,17,BSTR|CachedValue,18,BSTR|CachedDescription,19,BSTR|CachedRole,20,DWORD|CachedState,21,DWORD|CachedHelp,22,BSTR|CachedKeyboardShortcut,23,BSTR|CachedDefaultAction,25,BSTR|"

	Select(flags=3) {
		return UIA_Hr(DllCall(this.Vt(3), "ptr",this.__Value, "int",flags))
	}
	DoDefaultAction() {
		return UIA_Hr(DllCall(this.Vt(4), "ptr",this.__Value))
	}
	SetValue(value) {
		return UIA_Hr(DllCall(this.Vt(5), "ptr",this.__Value, "ptr",&value))
	}
	GetCurrentSelection() { ; Not correct
		;~ if (hr:=DllCall(this.Vt(14), "ptr",this.__Value, "ptr*",array))=0
			;~ return new UIA_ElementArray(array)
		;~ else
			;~ MsgBox,, Error, %hr%
	}
	;~ GetCachedSelection	24	IUIAutomationElementArray
	GetIAccessible() {
	/*	This method returns NULL if the underlying implementation of the UI Automation element is not a native 
	Microsoft Active Accessibility server; that is, if a client attempts to retrieve the IAccessible interface 
	for an element originally supported by a proxy object from OLEACC.dll, or by the UIA-to-MSAA Bridge.
	*/
		return UIA_Hr(DllCall(this.Vt(26), "ptr",this.__Value, "ptr*",pacc)) and pacc? ComObj(9,pacc,1):
	}
}

class UIA_TreeWalker extends UIA_Base {
	;~ http://msdn.microsoft.com/en-us/library/windows/desktop/ee671470(v=vs.85).aspx
	static IID := "{4042c624-389c-4afc-a630-9df854a541fc}"
	static get_properties := "|Condition,15,IUIAutomationCondition|"
	
		GetParentElement(e) {
			return UIA_Hr(DllCall(this.Vt(3), "ptr",this.__Value, "ptr",e.__Value, "ptr*",out))? new UIA_Element(out):
		}
	GetFirstChildElement(e) {
		return UIA_Hr(DllCall(this.Vt(4), "ptr",this.__Value, "ptr",e.__Value, "ptr*",out))&&out? new UIA_Element(out):
	}
	GetLastChildElement(e) {
		return UIA_Hr(DllCall(this.Vt(5), "ptr",this.__Value, "ptr",e.__Value, "ptr*",out))&&out? new UIA_Element(out):
	}
	GetNextSiblingElement(e) {
		return UIA_Hr(DllCall(this.Vt(6), "ptr",this.__Value, "ptr",e.__Value, "ptr*",out))&&out? new UIA_Element(out):
	}
	GetPreviousSiblingElement(e) {
		return UIA_Hr(DllCall(this.Vt(7), "ptr",this.__Value, "ptr",e.__Value, "ptr*",out))&&out? new UIA_Element(out):
	}
		NormalizeElement(e) {
			return UIA_Hr(DllCall(this.Vt(8), "ptr",this.__Value, "ptr",e.__Value, "ptr*",out))? new UIA_Element(out):
		}
		GetParentElementBuildCache(e, cacheRequest) {
			return UIA_Hr(DllCall(this.Vt(9), "ptr",this.__Value, "ptr",e.__Value, "ptr",cacheRequest.__Value.__Value, "ptr*",out))? new UIA_Element(out):
		}
		GetFirstChildElementBuildCache(e, cacheRequest) {
			return UIA_Hr(DllCall(this.Vt(10), "ptr",this.__Value, "ptr",e.__Value, "ptr",cacheRequest.__Value, "ptr*",out))? new UIA_Element(out):
		}
		GetLastChildElementBuildCache(e, cacheRequest) {
			return UIA_Hr(DllCall(this.Vt(11), "ptr",this.__Value, "ptr",e.__Value, "ptr",cacheRequest.__Value, "ptr*",out))? new UIA_Element(out):
		}
		GetNextSiblingElementBuildCache(e, cacheRequest) {
			return UIA_Hr(DllCall(this.Vt(12), "ptr",this.__Value, "ptr",e.__Value, "ptr",cacheRequest.__Value, "ptr*",out))? new UIA_Element(out):
		}
		GetPreviousSiblingElementBuildCache(e, cacheRequest) {
			return UIA_Hr(DllCall(this.Vt(13), "ptr",this.__Value, "ptr",e.__Value, "ptr",cacheRequest.__Value, "ptr*",out))? new UIA_Element(out):
		}
		NormalizeElementBuildCache(e, cacheRequest) {
			return UIA_Hr(DllCall(this.Vt(14), "ptr",this.__Value, "ptr",e.__Value, "ptr",cacheRequest.__Value, "ptr*",out))? new UIA_Element(out):
		}
}

class UIA_Condition extends UIA_Base {
	;~ http://msdn.microsoft.com/en-us/library/windows/desktop/ee671420(v=vs.85).aspx
	static IID := "{352ffba8-0973-437c-a61f-f64cafd81df9}"
}

class UIA_IUnknown extends UIA_Base {
	;~ http://msdn.microsoft.com/en-us/library/windows/desktop/ms680509(v=vs.85).aspx
	static IID := "{00000000-0000-0000-C000-000000000046}"
}

class UIA_CacheRequest  extends UIA_Base {
	;~ http://msdn.microsoft.com/en-us/library/windows/desktop/ee671413(v=vs.85).aspx
	static IID := "{b32a92b5-bc25-4078-9c08-d7ee95c48e03}"
}


{  ;~ UIA Functions
	UIA_Interface() {
		try {
			if uia:=ComObjCreate("{ff48dba4-60ef-4201-aa87-54103eef594e}","{30cbe57d-d9d0-452a-ab13-7ac5ac4825ee}")
				return uia:=new UIA_Interface(uia), UIA_Base.__UIA:=uia
			throw "UIAutomation Interface failed to initialize."
		} catch e
			MsgBox, 262160, UIA Startup Error, % IsObject(e)?"IUIAutomation Interface is not registered.":e.Message
	}
	UIA_Hr(hr) {
		;~ http://blogs.msdn.com/b/eldar/archive/2007/04/03/a-lot-of-hresult-codes.aspx
		static err:={0x8000FFFF:"Catastrophic failure.",0x80004001:"Not implemented.",0x8007000E:"Out of memory.",0x80070057:"One or more arguments are not valid.",0x80004002:"Interface not supported.",0x80004003:"Pointer not valid.",0x80070006:"Handle not valid.",0x80004004:"Operation aborted.",0x80004005:"Unspecified error.",0x80070005:"General access denied.",0x800401E5:"The object identified by this moniker could not be found.",0x80040201:"UIA_E_ELEMENTNOTAVAILABLE",0x80040200:"UIA_E_ELEMENTNOTENABLED",0x80131509:"UIA_E_INVALIDOPERATION",0x80040202:"UIA_E_NOCLICKABLEPOINT",0x80040204:"UIA_E_NOTSUPPORTED",0x80040203:"UIA_E_PROXYASSEMBLYNOTLOADED"} ; //not completed
		if hr&&(hr&=0xFFFFFFFF) {
			RegExMatch(Exception("",-2).what,"(\w+).(\w+)",i)
			throw Exception(UIA_Hex(hr) " - " err[hr], -2, i2 "  (" i1 ")")
		}
		return !hr
	}
	UIA_ElementArray(p, uia="") {
		a:=new UIA_ElementArray(p),out:=[]
		Loop % a.Length
			out[A_Index-1]:=a.GetElement(A_Index-1)
		return out, out.base:={UIA_ElementArray:a}
	}
	UIA_RectToObject(ByRef r) { ; rect.__Value work with DllCalls?
		static b:={__Class:"object",__Type:"RECT",Struct:Func("UIA_RectStructure")}
		return {l:NumGet(r,0,"Int"),t:NumGet(r,4,"Int"),r:NumGet(r,8,"Int"),b:NumGet(r,12,"Int"),base:b}
	}
	UIA_RectStructure(this, ByRef r) {
		static sides:="ltrb"
		VarSetCapacity(r,16)
		Loop Parse, sides
			NumPut(this[A_LoopField],r,(A_Index-1)*4,"Int")
	}
	UIA_SafeArraysToObject(keys,values) {
	;~	1 dim safearrays w/ same # of elements
		out:={}
		for key in keys
			out[key]:=values[A_Index-1]
		return out
	}
	UIA_Hex(p) {
		setting:=A_FormatInteger
		SetFormat,IntegerFast,H
		out:=p+0 ""
		SetFormat,IntegerFast,%setting%
		return out
	}
	UIA_GUID(ByRef GUID, sGUID) { ;~ Converts a string to a binary GUID and returns its address.
		VarSetCapacity(GUID,16,0)
		return DllCall("ole32\CLSIDFromString", "wstr",sGUID, "ptr",&GUID)>=0?&GUID:""
	}
	UIA_Variant(ByRef var,type=0,val=0) {
		return (VarSetCapacity(var,8+2*A_PtrSize)+NumPut(type,var,0,"short")+NumPut(val,var,8,"ptr"))*0+&var
	}
	UIA_VariantData(ByRef p, flag=1) {
		if !Vt:=NumGet(p,"Ushort")
			return "Invalid Variant"
		else
			return Vt=2? NumGet(p,8,"short")		; VT_I2
				: Vt=3? NumGet(p,8,"Int")			; VT_I4
				: Vt=4? NumGet(p,8,"Float")			; VT_R4
				: Vt=5? NumGet(p,8,"Double")		; VT_R8
				: Vt=8? StrGet(NumGet(p,8,"ptr"))	; VT_BSTR
				: Vt=0xB? NumGet(p,8,"short")		; VT_Bool
				: Vt&0x2000? ComObj(Vt,NumGet(p,8,"int"),flag)	; VT_Array
				: "Type Not Supported"
	/*
		VT_EMPTY     =      0  ; No value
		VT_NULL      =      1  ; SQL-style Null
		VT_I2        =      2  ; 16-bit signed int
		VT_I4        =      3  ; 32-bit signed int
		VT_R4        =      4  ; 32-bit floating-point number
		VT_R8        =      5  ; 64-bit floating-point number
		VT_CY        =      6  ; Currency
		VT_DATE      =      7  ; Date
		VT_BSTR      =      8  ; COM string (Unicode string with length prefix)
		VT_DISPATCH  =      9  ; COM object 
		VT_ERROR     =    0xA  ; Error code (32-bit integer)
		VT_BOOL      =    0xB  ; Boolean True (-1) or False (0)
		VT_VARIANT   =    0xC  ; VARIANT (must be combined with VT_ARRAY or VT_BYREF)
		VT_UNKNOWN   =    0xD  ; IUnknown interface pointer
		VT_DECIMAL   =    0xE  ; (not supported)
		VT_I1        =   0x10  ; 8-bit signed int
		VT_UI1       =   0x11  ; 8-bit unsigned int
		VT_UI2       =   0x12  ; 16-bit unsigned int
		VT_UI4       =   0x13  ; 32-bit unsigned int
		VT_I8        =   0x14  ; 64-bit signed int
		VT_UI8       =   0x15  ; 64-bit unsigned int
		VT_INT       =   0x16  ; Signed machine int
		VT_UINT      =   0x17  ; Unsigned machine int
		VT_RECORD    =   0x24  ; User-defined type
		VT_ARRAY     = 0x2000  ; SAFEARRAY
		VT_BYREF     = 0x4000  ; Pointer to another type of value
	*/
	}
}
MsgBox(msg) {
	MsgBox %msg%
}

/*
TreeScope_Element	= 0x1,
TreeScope_Children	= 0x2,
TreeScope_Descendants	= 0x4,
TreeScope_Parent	= 0x8,
TreeScope_Ancestors	= 0x10,
TreeScope_Subtree	= ( ( TreeScope_Element | TreeScope_Children )  | TreeScope_Descendants ) 


