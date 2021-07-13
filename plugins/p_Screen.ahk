ExitApp

;scan to create a database (if applicable for this plugin)
P_Screen_Scan()
{
	RegExMatch(A_ThisFunc, "U)_(?<PlugName>.*)_", O)	;get the name of this plugin
	
	PluginDBPut(OPlugName,"REFRESH")		;this command resets the counter of DBs for this plugin
	;add a / at the beginning of Scan tag for top level object - this places it higher up when searched with a /
	DBdata = <Object=%OPlugName%><Plugin=%OPlugName%><Scan1=/%OPlugName%>
	PluginDBPut(OPlugName,DBdata)
}


P_Screen_Objects()
{
	;currently supports only one object for analyze plugins
	RegExMatch(A_ThisFunc, "U)_(?<PlugName>.*)_", O)	;get the name of this plugin

	Objects = %OPlugName%		;important: make object name same as plugin name
	Return Objects
}

;The result from database is provided to this function and this function returns
;how the results are to be shown in GUI as main and sub text and icon
P_Screen_ToShow(SrchStrng, Result, ByRef LVLine, ByRef MainTxt, ByRef SubTxt, ByRef IconIdx, ByRef InfoBar)
{
	if !IconIdx
		IconIdx := GetIcon(A_ScriptDir "\res\icons\Objects\Screen.ico")

	MainTxt = /Screen
	SubTxt =
	InfoBar = 
	LVLine = /Screen
}

P_Screen_Actions(Line)
{
	RegExMatch(A_ThisFunc, "U)_(?<PlugName>.*)_", O)
	ActionList =
	(LTrim Join`r`n
		<Action=%OPlugName%.Turn Off><Scan1=Turn Off>
		<Action=%OPlugName%.Run Screensaver><Scan1=Run Screensaver>
	)

	Return ActionList
}

P_Screen_Execute(Line, Action, SrchStrng)
{
	Global Hist_DB,File_Conf
	RegExMatch(A_ThisFunc, "U)_(?<PlugName>.*)_", O)
	UpdateHistory = Y


	IfEqual, Action, %OPlugName%.Turn Off
	{
		Sleep, 500
		WinGet, hwnd, ID, Program Manager
		SendMessage, 0x112, 0xF170, 2,, ahk_id %hwnd%
	}

	IfEqual, Action, %OPlugName%.Run Screensaver
	{
		Sleep, 500
		WinGet, hwnd, ID, Program Manager
		SendMessage, 0x112, 0xF140, 2,, ahk_id %hwnd%
	}

	;update history
	IfEqual, UpdateHistory, Y
	{
		StringReplace, Hist_DB, Hist_DB, %Line%`r`n,, A		;clear history of last occurance of same line
		NewLine := RegExReplace(Line, "iU)\<Action=.*\>")		;remove earlier action

		NewLine = %NewLine%<Action=%Action%>
		Hist_DB = %NewLine%`r`n%Hist_DB%	;add latest item at beginning of history
	}
}
