ExitApp

;scan to create a database (if applicable for this plugin)
P_Internal_Scan()
{
	RegExMatch(A_ThisFunc, "U)_(?<PlugName>.*)_", O)	;get the name of this plugin

	PluginDBPut(OPlugName,"REFRESH")		;this command resets the counter of DBs for this plugin
	;add a / at the beginning of Scan tag for top level object - this places it higher up when searched with a /
	DBdata =
	(LTrim
	<Object=%OPlugName%><Plugin=%OPlugName%><Scan1=/Configuration>
	<Object=%OPlugName%><Plugin=%OPlugName%><Scan1=/Quit>
	<Object=%OPlugName%><Plugin=%OPlugName%><Scan1=/Restart>
	)
	PluginDBPut(OPlugName,DBdata)
}


;The result from database is provided to this function and this function returns
;how the results are to be shown in GUI as main and sub text and icon
P_Internal_ToShow(SrchStrng, Result, ByRef LVLine, ByRef MainTxt, ByRef SubTxt, ByRef IconIdx, ByRef InfoBar)
{
	if !IconIdx
		IconIdx := GetIcon(A_ScriptDir "\res\icons\Objects\Internal.ico")

	IfInString, Result, <Scan1=/Configuration>
		MainTxt = /Configuration
	IfInString, Result, <Scan1=/Quit>
		MainTxt = /Quit
	IfInString, Result, <Scan1=/Restart>
		MainTxt = /Restart
	SubTxt =
	InfoBar =
	LVLine = %MainTxt%
}


P_Internal_Objects()
{
	;this function simply returns the pipe separated list of Objects it supports 
	;Objects = File|MailID|URL
	;only in rare cases a plugin would support more than one object

	Objects = Internal
	Return Objects
}

P_Internal_Actions(Line)
{
	RegExMatch(A_ThisFunc, "U)_(?<PlugName>.*)_", O)
	ActionList = <Action=%OPlugName%.Execute><Scan1=Execute>
	Return ActionList
}

P_Internal_Execute(Line, Action, SrchStrng)
{
	Global
	RegExMatch(A_ThisFunc, "U)_(?<PlugName>.*)_", O)
	UpdateHistory = N		;by default history will be updated with this Action

	IfInString, Line, <Scan1=/Configuration>
		Gosub, ShowConf		;this is the section in host that shows the config window

	IfInString, Line, <Scan1=/Quit>
		ExitApp

	IfInString, Line, <Scan1=/Restart>
		Reload
}
