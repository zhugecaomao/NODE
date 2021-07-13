ExitApp

;scan to create a database (if applicable for this plugin)
P_ControlP_Scan()
{
	Global is9x
	RegExMatch(A_ThisFunc, "U)_(?<PlugName>.*)_", O)	;get the name of this plugin
	sysfld := is9x ? "System" : "System32"
	FileDelete,  %A_SCriptDir%\db\%OPlugName%.ndb
	;add a / at the beginning of Scan tag for top level object - this places it higher up when searched with a /
	;create DB with plugin's name + numbers starting with 1, else it won't be read

	CPItems =
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

	Loop, Parse, CPItems, `n, `r
	{
		IfEqual, A_LoopField,
			continue
		StringSplit, Item, A_LoopField, %A_Tab%
		IfExist, %A_WinDir%\%sysfld%\%Item1%
			FileAppend, <Object=%OPlugName%><Plugin=%OPlugName%><Scan1=%Item2%><File=%Item1%>`n, %A_SCriptDir%\db\%OPlugName%1.ndb
	}
}


;The result from database is provided to this function and this function returns
;how the results are to be shown in GUI as main and sub text and icon
P_ControlP_ToShow(SrchStrng, Result, ByRef LVLine, ByRef MainTxt, ByRef SubTxt, ByRef IconIdx, ByRef InfoBar)
{
	if !IconIdx
		IconIdx := GetIcon(A_ScriptDir "\res\icons\Objects\ControlP.ico")
	
	MainTxt := ReadTag(Result, "Scan1")		;this is an internal function that gets the tag values
	SubTxt =
	InfoBar =
	LVLine = %MainTxt%
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
	RegExMatch(A_ThisFunc, "U)_(?<PlugName>.*)_", O)
	ActionList = <Action=%OPlugName%.Open><Scan1=Open>

	Return ActionList
}

P_ControlP_Execute(Line, Action, SrchStrng)
{
	Global Hist_DB,File_Conf,is9x
	sysfld := is9x ? "System" : "System32"
	RegExMatch(A_ThisFunc, "U)_(?<PlugName>.*)_", O)
	UpdateHistory = Y		;by default history will be updated with this Action

	File := ReadTag(Line, "File")
	Run, %A_WinDir%\%sysfld%\%File%,, UseErrorLevel

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
