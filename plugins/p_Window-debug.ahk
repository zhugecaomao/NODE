ExitApp

;scan to create a database (if applicable for this plugin)
P_Window_Scan()
{
	RegExMatch(A_ThisFunc, "U)_(?<PlugName>.*)_", O)	;get the name of this plugin
	
	PluginDBPut(OPlugName,"REFRESH")		;this command resets the counter of DBs for this plugin
	;add a / at the beginning of Scan tag for top level object - this places it higher up when searched with a /
	DBdata = <Object=%OPlugName%><Plugin=%OPlugName%><Scan1=/%OPlugName%>
	PluginDBPut(OPlugName,DBdata)
}


P_Window_Objects()
{
	;currently supports only one object for analyze plugins
	RegExMatch(A_ThisFunc, "U)_(?<PlugName>.*)_", O)	;get the name of this plugin
	
	Objects = %OPlugName%		;important: make object name same as plugin name
	Return Objects
}

;The result from database is provided to this function and this function returns
;how the results are to be shown in GUI as main and sub text and icon
P_Window_ToShow(SrchStrng, Result, ByRef LVLine, ByRef MainTxt, ByRef SubTxt, ByRef IconIdx, ByRef InfoBar)
{
	Global LastActiveWinH,OwnIconIdx
	cmnd := "ProcessName"
	if (A_AhkVersion > "1.0.48.05")
	{
		cmnd := "ProcessPath"
		WinGet, IconFile, %cmnd%, ahk_id %LastActiveWinH%
	}
	else
		IconFile := P_Window_GetProcessPath(LastActiveWinH)

	if !IconIdx := GetIcon(IconFile)
		IconIdx := OwnIconIdx

	WinGetTitle, MainTxt, ahk_id %LastActiveWinH%
	SubTxt =
	InfoBar = 
	LVLine = /Window
FileAppend, %A_ThisFunc%() -> Active window: h=%LastActiveWinH% IconIdx=%IconIdx% %MainTxt%`n, debug_idx.txt
}

P_Window_GetProcessPath(wh)
{
	PID=0
	DllCall("GetWindowThreadProcessId", "UInt", wh, "UIntP", PID)
	if (A_OSType="WIN32_WINDOWS")
	{
		hps := DllCall("CreateToolhelp32Snapshot", "UInt", 0x2, "UInt", 0, "UInt")	; TH32CS_SNAPPROCESS
		if hps = -1	; INVALID_HANDLE_VALUE=-1
			return FALSE
		VarSetCapacity(PE, 296, 0)	; PROCESSENTRY32 struct
		NumPut(296, PE, 0, "UInt")	; dwSize
		if DllCall("Process32First", "UInt", hps, "UInt", &PE)
		{
			While (NumGet(PE, 8, "UInt") != PID)
			{
				if !DllCall("Process32Next", "UInt", hps, "UInt", &PE)
				{
					DllCall("CloseHandle", "UInt", hps)
					return FALSE
				}
			}
			DllCall("CloseHandle", "UInt", hps)
			return DllCall("MulDiv", "UInt", &PE+36, "Int", 1, "Int", 1, "Str")
		}
		DllCall("CloseHandle", "UInt", hps)
		return FALSE
	}
	else
	{
		hps := DllCall("CreateToolhelp32Snapshot", "UInt", 0x8, "UInt", PID, "UInt")	; TH32CS_SNAPMODULE
		if hps = -1	; INVALID_HANDLE_VALUE=-1
			return FALSE
		VarSetCapacity(ME, 548, 0)	; MODULEENTRY32 struct
		NumPut(548, ME, 0, "UInt")	; dwSize
		DllCall("Module32First", "UInt", hps, "UInt", &ME)
		DllCall("CloseHandle", "UInt", hps)
		return DllCall("MulDiv", "UInt", &ME+288, "Int", 1, "Int", 1, "Str")
	}
}

P_Window_Actions(Line)
{
	RegExMatch(A_ThisFunc, "U)_(?<PlugName>.*)_", O)
	ActionList =
	(LTrim Join`r`n
		<Action=%OPlugName%.Always on Top><Scan1=Always on Top>
		<Action=%OPlugName%.Hide Window><Scan1=Hide Window>
		<Action=%OPlugName%.Unhide All><Scan1=Unhide All>
		<Action=%OPlugName%.Kill Application><Scan1=Kill Application>
	)
	
	Return ActionList
}

P_Window_Execute(Line, Action, SrchStrng)
{
	Global Hist_DB,File_Conf,LastActiveWinH,P_Window_Int_HWnds
	
	RegExMatch(A_ThisFunc, "U)_(?<PlugName>.*)_", O)
	UpdateHistory = N		;don't update history (currently not supported for analyze plugins)
	
	WinGet, PID, PID, ahk_id %LastActiveWinH%

	
	IfEqual, Action, %OPlugName%.Always on Top
		WinSet, AlwaysOnTop, Toggle, ahk_id %LastActiveWinH%

	IfEqual, Action, %OPlugName%.Hide Window
	{
		WinHide, ahk_id %LastActiveWinH%
		P_Window_Int_HWnds .= "`n" LastActiveWinH
	}
	
	IfEqual, Action, %OPlugName%.Unhide All
	{
		Loop, Parse, P_Window_Int_HWnds, `n
			WinShow, ahk_id %A_LoopField%
		P_Window_Int_HWnds =
	}
	
	IfEqual, Action, %OPlugName%.Kill Application
		Process, Close, %PID%
	
	;update history
	IfEqual, UpdateHistory, Y
	{
		StringReplace, Hist_DB, Hist_DB, %Line%`r`n,, A		;clear history of last occurance of same line
		NewLine := RegExReplace(Line, "iU)\<Action=.*\>")		;remove earlier action
		
		NewLine = %NewLine%<Action=%Action%>
		Hist_DB = %NewLine%`r`n%Hist_DB%	;add latest item at beginning of history
	}
}


P_Window_OnExit()
{
	Global P_Window_Int_HWnds

	Loop, Parse, P_Window_Int_HWnds, `n		;to unhide all windows hidden by Node before exiting app
		WinShow, ahk_id %A_LoopField%
	P_Window_Int_HWnds =
}