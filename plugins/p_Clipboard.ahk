ExitApp

;scan to create a database (if applicable for this plugin)
P_Clipboard_Scan()
{
	RegExMatch(A_ThisFunc, "U)_(?<PlugName>.*)_", O)	;get the name of this plugin

	PluginDBPut(OPlugName,"REFRESH")		;this command resets the counter of DBs for this plugin
	DBdata = <Object=%OPlugName%><Plugin=%OPlugName%><Scan1=/%OPlugName%>
	PluginDBPut(OPlugName,DBdata)
}


;The result from database is provided to this function and this function returns
;how the results are to be shown in GUI as main and sub text and icon
P_Clipboard_ToShow(SrchStrng, Result, ByRef LVLine, ByRef MainTxt, ByRef SubTxt, ByRef IconIdx, ByRef InfoBar)
{
	if !IconIdx
		IconIdx := GetIcon(A_ScriptDir "\res\icons\Objects\Clipboard.ico")

	MainTxt = /Clipboard
	SubTxt =
	InfoBar =
	LVLine = %MainTxt%
}


P_Clipboard_Objects()
{
	;this function simply returns the pipe separated list of Objects it supports 
	;Objects = File|MailID|URL
	;only in rare cases a plugin would support more than one object
	
	Objects = Clipboard
	Return Objects
}



P_Clipboard_Actions(Line)
{

	RegExMatch(A_ThisFunc, "U)_(?<PlugName>.*)_", O)

	IfNotEqual, Clipboard,		;shows these actions only when the clipboard contains text data
	{
		ActionList =
		(LTrim Join`r`n
			<Action=%OPlugName%.Remove Formatting><Scan1=Remove Formatting>
			<Action=%OPlugName%.lowercase><Scan1=lowercase>
			<Action=%OPlugName%.UPPERcase><Scan1=UPPERcase>
			<Action=%OPlugName%.Sentence case><Scan1=Sentence case>
			<Action=%OPlugName%.Title Case><Scan1=Title Case>
			<Action=%OPlugName%.iNVERSE cASE><Scan1=iNVERSE cASE>
			<Action=%OPlugName%.Sort A-Z><Scan1=Sort A-Z>
			<Action=%OPlugName%.Sort Z-A><Scan1=Sort Z-A>
			<Action=%OPlugName%.Sort random><Scan1=Sort random>
			<Action=%OPlugName%.Flip--pilF><Scan1=Flip--pilF>
			<Action=%OPlugName%.Spaces to Tabs><Scan1=Spaces to Tabs>
			<Action=%OPlugName%.Tabs to Spaces><Scan1=Tabs to Spaces>
			<Action=%OPlugName%.Remove whitespace padding><Scan1=Remove whitespace padding>
			<Action=%OPlugName%.Remove blank lines><Scan1=Remove blank lines>
			<Action=%OPlugName%.Remove duplicates><Scan1=Remove duplicates>
		)
	}
	else
		ActionList = <Action=%OPlugName%.No text on clipboard><Scan1=No text on clipboard>


	Return ActionList
}

P_Clipboard_Execute(Line, Action, SrchStrng)
{
	Global Hist_DB,File_Conf,OwnIcon
	RegExMatch(A_ThisFunc, "U)_(?<PlugName>.*)_", O)
	UpdateHistory = Y		;by default history will be updated with this Action


	IfEqual, Action, %OPlugName%.Remove Formatting
	{
		TmpFile = %A_ScriptDir%\tmp\tmp.txt
		FileDelete, %TmpFile%
		FileAppend, %Clipboard%, %TmpFile%
		FileRead, Clipboard, %A_ScriptDir%\tmp\tmp.txt
		FileDelete, %TmpFile%		;in case you don't want to keep records of what you were up to
	}
	IfEqual, Action, %OPlugName%.Lowercase
		StringLower, Clipboard, Clipboard

	IfEqual, Action, %OPlugName%.Uppercase
		StringUpper, Clipboard, Clipboard

	IfEqual, Action, %OPlugName%.Sentence case
		Clipboard := RegExReplace(Clipboard, "([.?\s!]\s\w)|^(\.\s\b\w)|^(.)", "$U0")

	IfEqual, Action, %OPlugName%.Title Case
		StringUpper, Clipboard, Clipboard, T

	IfEqual, Action, %OPlugName%.iNVERSE cASE
	{
		; Thanks JDN
		Lab_Invert_Char_Out:= ""
		Loop % Strlen(Clipboard) { ;%
			Lab_Invert_Char:= Substr(Clipboard, A_Index, 1)
			If Lab_Invert_Char is Upper
				Lab_Invert_Char_Out:= Lab_Invert_Char_Out Chr(Asc(Lab_Invert_Char) + 32)
			Else If Lab_Invert_Char is Lower
				Lab_Invert_Char_Out:= Lab_Invert_Char_Out Chr(Asc(Lab_Invert_Char) - 32)
			Else
				Lab_Invert_Char_Out:= Lab_Invert_Char_Out Lab_Invert_Char
		}
		Clipboard:=Lab_Invert_Char_Out
	}

	IfEqual, Action, %OPlugName%.Sort A-Z
		Sort, Clipboard,

	IfEqual, Action, %OPlugName%.Sort Z-A
		Sort, Clipboard, R

	IfEqual, Action, %OPlugName%.Sort random
		Sort, Clipboard,  Random

	IfEqual, Action, %OPlugName%.Remove duplicates
		Sort, Clipboard, U

	IfEqual, Action, %OPlugName%.Flip--pilF
		Clipboard:=P_Clipboard_Int_Flip(Clipboard)

	IfEqual, Action, %OPlugName%.Spaces to Tabs
		StringReplace, Clipboard, Clipboard, %A_Space%, %A_Tab%, All

	IfEqual, Action, %OPlugName%.Tabs to Spaces
		StringReplace, Clipboard, Clipboard, %A_Tab%, %A_Space%, All

	IfEqual, Action, %OPlugName%.Remove whitespace padding
	{
		Clipboard := RegExReplace(Clipboard, "m)(^[ \t]+)", "")
		Clipboard := RegExReplace(Clipboard, "m)([ \t]+$)","")
	}

	IfEqual, Action, %OPlugName%.Remove blank lines
	{
		Loop
		{
			StringReplace, Clipboard, Clipboard, `r`n`r`n, `r`n, UseErrorLevel
			If ErrorLevel = 0  ; No more replacements needed.
				break
		}
	}
	
	Notify("NODE","Clipboard updated", 2, "GC=303030 TC=FFFFFF TS=8 TF=Verdana MC=FFFFFF MF=Verdana SI=200 ST=200 SC=200 BK=White IW=16 IH=16 Image=" OwnIcon)


	;update history
	IfEqual, UpdateHistory, Y
	{
		StringReplace, Hist_DB, Hist_DB, %Line%`r`n,, A		;clear history of last occurance of same line
		NewLine := RegExReplace(Line, "iU)\<Action=.*\>")		;remove earlier action
		
		NewLine = %NewLine%<Action=%Action%>
		Hist_DB = %NewLine%`r`n%Hist_DB%	;add latest item at beginning of history
	}
}


P_Clipboard_Int_Flip(in) {  ; Thanks Drugwash :-D
	if A_IsUnicode
		return DllCall("MulDiv", "Ptr", DllCall("msvcrt\_wcsrev", Str, in), "Int", 1, "Int", 1, "Str")
	return DllCall("MulDiv", "UInt", DllCall("msvcrt\_mbsrev", Str, in), "Int", 1, "Int", 1, "Str")
}
