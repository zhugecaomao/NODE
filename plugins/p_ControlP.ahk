ExitApp

;scan to create a database (if applicable for this plugin)
P_ControlP_Scan()
{
	RegExMatch(A_ThisFunc, "U)_(?<PlugName>.*)_", O)	;get the name of this plugin
	FileDelete,  %A_SCriptDir%\db\%OPlugName%.ndb
	;add a / at the beginning of Scan tag for top level object - this places it higher up when searched with a /

	DBdata = <Object=%OPlugName%><Plugin=%OPlugName%><Scan1=/Control Panel>
	PluginDBPut(OPlugName,DBdata)
}


;The result from database is provided to this function and this function returns
;how the results are to be shown in GUI as main and sub text and icon
P_ControlP_ToShow(SrchStrng, Result, ByRef LVLine, ByRef MainTxt, ByRef SubTxt, ByRef IconIdx, ByRef InfoBar)
{
	Global P_ControlP_Int_List
	if !IconIdx
		IconIdx := GetIcon(A_ScriptDir "\res\icons\Objects\ControlP.ico")
	
	MainTxt = /Control Panel
	SubTxt =
	InfoBar =
	LVLine = /Control Panel
}


P_ControlP_Objects()
{
	;this function simply returns the pipe separated list of Objects it supports 
	;Objects = File|MailID|URL
	;only in rare cases a plugin would support more than one object

	Objects = ControlP
	Return Objects
}

P_ControlP_Actions(Line)
{
	Global is9x,P_ControlP_Int_List
	sysfld := is9x ? "System" : "System32"
	RegExMatch(A_ThisFunc, "U)_(?<PlugName>.*)_", O)
	
	P_ControlP_Int_List =
	(LTrim
	Access.cpl	Accessibility properties
	Appwiz.cpl	Add-Remove Programs properties
	Desk.cpl	Display properties
	Hdwwiz.cpl	Add Hardware properties
	Inetcpl.cpl	Internet properties
	Intl.cpl 	Regional Settings properties
	Irprops.cpl	Infrared Port properties
	Joy.cpl	Joystick properties
	Main.cpl	Mouse properties
	Mmsys.cpl	Multimedia properties
	Ncpa.cpl	Network Connections properties
	Nusrmgr.cpl	User Accounts properties
	Nwc.cpl	Gateway Services for NetWare properties
	Odbccp32.cpl	Open Database Connectivity (ODBC) properties
	Powercfg.cpl 	Power Options properties
	Sysdm.cpl 	System properties
	Telephon.cpl	Phone and Modem Options properties
	Timedate.cpl 	Time and Date properties
	)
	
	Loop, Parse, P_ControlP_Int_List, `n, `r
	{
		IfEqual, A_LoopField,
			continue
		StringSplit, Item, A_LoopField, %A_Tab%
		IfExist, %A_WinDir%\%sysfld%\%Item1%
			ActionList = %ActionList%`n<Action=%OPlugName%.%Item2%><Scan1=%Item2%>
	}
	StringTrimLeft, ActionList, ActionList, 1

	Return ActionList
}

P_ControlP_Execute(Line, Action, SrchStrng)
{
	Global Hist_DB,File_Conf,is9x,P_ControlP_Int_List
	sysfld := is9x ? "System" : "System32"
	RegExMatch(A_ThisFunc, "U)_(?<PlugName>.*)_", O)
	UpdateHistory = Y		;by default history will be updated with this Action

	Loop, Parse, P_ControlP_Int_List, `n, `r
	{
		IfEqual, A_LoopField,
			continue
		StringSplit, Item, A_LoopField, %A_Tab%
		IfEqual, Action, %OPlugName%.%Item2%
		{
			Run, %A_WinDir%\%sysfld%\%Item1%,, UseErrorLevel
			break
		}
	}

	;update history
	IfEqual, UpdateHistory, Y
	{
		StringReplace, Hist_DB, Hist_DB, %Line%`r`n,, A		;clear history of last occurance of same line
		NewLine := RegExReplace(Line, "iU)\<Action=.*\>")		;remove earlier action

		IfNotEqual, SrchStrng,
		{
			;As there was no search string this time (item probably launched from history)
			;keep the record of previous time's search string intact
			;else update the searchstring of this item with new one			
			NewLine := RegExReplace(NewLine, "iU)\<SrchStrng=.*\>")	;remove earlier search string
			NewLine = %NewLine%<SrchStrng=%SrchStrng%>
		}

		NewLine = %NewLine%<Action=%Action%>
		Hist_DB = %NewLine%`r`n%Hist_DB%	;add latest item at beginning of history
	}
}
