ExitApp

;scan to create a database (if applicable for this plugin)
P_CommandP_Scan()
{
	RegExMatch(A_ThisFunc, "U)_(?<PlugName>.*)_", O)	;get the name of this plugin
	
	PluginDBPut(OPlugName,"REFRESH")		;this command resets the counter of DBs for this plugin

	DBdata = <Object=%OPlugName%><Plugin=%OPlugName%><Scan1=/%OPlugName%>
	PluginDBPut(OPlugName,DBdata)
}


P_CommandP_Objects()
{
	;currently supports only one object for analyze plugins
	RegExMatch(A_ThisFunc, "U)_(?<PlugName>.*)_", O)	;get the name of this plugin
	
	Objects = %OPlugName%		;important: make object name same as plugin name
	Return Objects
}

;The result from database is provided to this function and this function returns
;how the results are to be shown in GUI as main and sub text and icon
P_CommandP_ToShow(SrchStrng, Result, ByRef LVLine, ByRef MainTxt, ByRef SubTxt, ByRef IconIdx, ByRef InfoBar)
{
	if !IconIdx
		IconIdx := GetIcon(A_ScriptDir "\res\icons\Objects\CommandP.ico")
	
	MainTxt = /Command Prompt here
	SubTxt =
	InfoBar = Open
	LVLine = /Command Prompt here
}

P_CommandP_Actions(Line)
{
	RegExMatch(A_ThisFunc, "U)_(?<PlugName>.*)_", O)
	ActionList = <Action=%OPlugName%.Open><Scan1=Open>
	Return ActionList
}

P_CommandP_Execute(Line, Action, SrchStrng)
{
	Global Hist_DB,File_Conf,LastActiveWinH
	RegExMatch(A_ThisFunc, "U)_(?<PlugName>.*)_", O)
	UpdateHistory = N		;don't update history (currently not supported for analyze plugins)

	WinGetClass, WinClass, ahk_ID %LastActiveWinH%

	
	IfEqual, Action, %OPlugName%.Open
	{
		If WinClass in CabinetWClass,ExplorerWClass		;windows explorer
		{
			If A_OSVersion in WIN_XP,WIN_2000,WIN_NT4,WIN_95,WIN_98,WIN_ME
				ControlGetText, ThisPath, Edit1, ahk_ID %LastActiveWinH%
			else
			{
				ControlGetText, ThisPath, ShellTabWindowClass1, ahk_ID %LastActiveWinH%
				IfEqual, ThisPath,
					ControlGetText, ThisPath, ComboBoxEx321, ahk_ID %LastActiveWinH%
			}
		}
		
		IfEqual, WinClass, ThunderRT6FormDC		;XYplorer
			ControlGetText, ThisPath, Edit13, ahk_ID %LastActiveWinH%

		IfEqual, WinClass, TTOTAL_CMD      ;Total Commander
		{
			ControlGetText, i, TPathPanel1, ahk_ID %LastActiveWinH%
			ControlGetText, ThisPath, % "TMyPanel" (i ? 3 : 2), ahk_ID %LastActiveWinH%
			StringTrimRight, ThisPath, ThisPath, 1
		}
		Run, %ComSpec%, %ThisPath%
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

