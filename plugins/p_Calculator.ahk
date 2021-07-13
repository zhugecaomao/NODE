ExitApp

P_Calculator_SearchAnalyze(SrchStrng)
{
	;this function basically tries to analyze the search string and understand it if it is valid input
	;for this plugin.
	Match = N
	If SrchStrng contains *,-,/,+,Abs,Ceil,Exp,Floor,Log,Ln,Round,Sqrt,Sin,Cos,Tan,ASin,ACos,ATan,SGN,Fib,fac
	If SrchStrng contains 1,2,3,4,5,6,7,8,9,0
	{
		EvalResult := Eval(SrchStrng)
		If EvalResult contains 1,2,3,4,5,6,7,8,9,0
			Match = Y
	}
	Return Match
}


;scan to create a database (if applicable for this plugin)
P_Calculator_Scan()
{
	RegExMatch(A_ThisFunc, "U)_(?<PlugName>.*)_", O)	;get the name of this plugin
	
	PluginDBPut(OPlugName,"REFRESH")		;this command resets the counter of DBs for this plugin
	;add a * at the beginning of Scan tag for analyzed object
	DBdata = <Object=%OPlugName%><Plugin=%OPlugName%><Scan1=*%OPlugName%>
	PluginDBPut(OPlugName,DBdata)
}


P_Calculator_Objects()
{
	;currently supports only one object for analyze plugins
	RegExMatch(A_ThisFunc, "U)_(?<PlugName>.*)_", O)	;get the name of this plugin
	
	Objects = %OPlugName%		;important: make object name same as plugin name
	Return Objects
}

;The result from database is provided to this function and this function returns
;how the results are to be shown in GUI as main and sub text and icon
P_Calculator_ToShow(SrchStrng, Result, ByRef LVLine, ByRef MainTxt, ByRef SubTxt, ByRef IconIdx, ByRef InfoBar)
{
	if !IconIdx
		IconIdx := GetIcon(A_ScriptDir "\res\icons\Objects\Calculator.ico")

	MainTxt := Eval(SrchStrng)
	SubTxt =
	InfoBar = Copy Result
	LVLine = *Calculator
}

P_Calculator_Actions(Line)
{
	RegExMatch(A_ThisFunc, "U)_(?<PlugName>.*)_", O)
	ActionList = <Action=%OPlugName%.Copy Result><Scan1=Copy Result>
	Return ActionList
}

P_Calculator_Execute(Line, Action, SrchStrng)
{
	Global Hist_DB,File_Conf
	RegExMatch(A_ThisFunc, "U)_(?<PlugName>.*)_", O)
	UpdateHistory = N		;don't update history (currently not supported for analyze plugins)


	IfEqual, Action, %OPlugName%.Copy Result
	{
		Clipboard := Eval(SrchStrng)
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

#Include %A_ScriptDir%\includes\f_eval.ahk
