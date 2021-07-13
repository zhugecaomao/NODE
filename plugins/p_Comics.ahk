ExitApp

;scan to create a database (if applicable for this plugin)
P_Comics_Scan()
{
	RegExMatch(A_ThisFunc, "U)_(?<PlugName>.*)_", O)	;get the name of this plugin
	
	PluginDBPut(OPlugName,"REFRESH")		;this command resets the counter of DBs for this plugin
	;add a / at the beginning of Scan tag for top level object - this places it higher up when searched with a /
	DBdata = <Object=%OPlugName%><Plugin=%OPlugName%><Scan1=/%OPlugName%>
	PluginDBPut(OPlugName,DBdata)
}


;The result from database is provided to this function and this function returns
;how the results are to be shown in GUI as main and sub text and icon
P_Comics_ToShow(SrchStrng, Result, ByRef LVLine, ByRef MainTxt, ByRef SubTxt, ByRef IconIdx, ByRef InfoBar)
{
	PtrP := A_IsUnicode ? "PtrP" : "UIntP"
	if !IconIdx
		IconIdx := GetIcon(A_ScriptDir "\res\icons\Objects\Comics.ico")
	
	MainTxt = /Comics
	SubTxt =
	InfoBar =
	LVLine = %MainTxt%
}


P_Comics_Objects()
{
	;this function simply returns the pipe separated list of Objects it supports 
	;Objects = File|MailID|URL
	;only in rare cases a plugin would support more than one object
	
	Objects = Comics
	Return Objects
}



P_Comics_Actions(Line)
{

	RegExMatch(A_ThisFunc, "U)_(?<PlugName>.*)_", O)
	
	ActionList =
	(LTrim Join`r`n
		<Action=%OPlugName%.Calvin and Hobbes><Scan1=Calvin and Hobbes>
		<Action=%OPlugName%.Off the Mark><Scan1=Off the Mark>
		<Action=%OPlugName%.Garfield><Scan1=Garfield>
		<Action=%OPlugName%.Bound and Gagged><Scan1=Bound and Gagged>
		<Action=%OPlugName%.Close to Home><Scan1=Close to Home>
		<Action=%OPlugName%.Foxtrot><Scan1=Foxtrot>
	)

	Return ActionList
}

P_Comics_Execute(Line, Action, SrchStrng)
{
	Static
	Global cGUI_Comics, Hist_DB, NextGuiNmb, OwnIcon, File_conf, ComicsDiff, ComicsRetry, ComicsMaxRetries
	RegExMatch(A_ThisFunc, "U)_(?<PlugName>.*)_", O)
	if !cGUI_%OPlugName%
		cGUI_%OPlugName% := A_AhkVersion > "1.0.48.05" ? OPlugName : NextGuiNmb++
	UpdateHistory = Y		;by default history will be updated with this Action
	ComicsRetry = 0			; initialize retry counter
	ComicsTotalRetries = 0		; initialize total retries counter
	ComicsDiff = -24			; initialize date direction to backwards, to be on the safe side
	; max. retries for failed download. we'll have to make this an option
	IniRead, ComicsMaxRetries, %File_conf%, %OPlugName%, MaxRetries, 2
	; max. total retries in one direction for failed download. we'll have to make this an option
	IniRead, ComicsMaxTotalRetries, %File_conf%, %OPlugName%, MaxTotalRetries, 10
	IniRead, Now, %File_conf%, %OPlugName%, LastDate, %A_Now%
	FormatTime, Date, %Now%, yyMMdd
	FormatTime, Year, %Now%, yyyy
	StringReplace, Title, Action, %OPlugName%.,, A
	Loop
		{
		IniRead, i, %A_ScriptDir%\plugins\Comics.ini, List, %A_Index%, %A_Space%
		if !i
			break
		StringSplit, i, i, `,, %A_Space%%A_Tab%
		if (Title = i1)
			{
			Transform, URL, Deref, %i2%
			break
			}
		}
	if !URL
		return	; whatever the reason, if we don't have an URL we have no business here

	Notify("NODE","Downloading Comic", 2, "GC=303030 TC=FFFFFF TS=8 TF=Verdana MC=FFFFFF MF=Verdana SI=200 ST=200 SC=200 BK=White IW=16 IH=16 Image=" OwnIcon)

	Gui, %cGUI_Comics%:Default
	Gui, %cGUI_Comics%:+Labelp_Comics
	Gui, -Caption +Border
	Gui, Color, FFFFFF
	Gui, Margin, 5, 5
	Gui, Add, Picture, xm ym gmoveit AltSubmit hwndhComic,
	Gui, Add, Button, xm y+5 gPrevComic, <
	Gui, Add, Button, x+2 yp gNextComic, >
	Gui, Add, DateTime, x+2 yp w165 hp 1 Range-%A_Now% Choose%Now% vNow gCommonComic, LongDate
	Gui, Add, Text, x+2 yp w80 hp 0x200, Downloading...
	gosub CommonComic

	;update history
	IfEqual, UpdateHistory, Y
	{
		StringReplace, Hist_DB, Hist_DB, %Line%`r`n,, A		;clear history of last occurance of same line
		NewLine := RegExReplace(Line, "iU)\<Action=.*\>")		;remove earlier action
		
		NewLine = %NewLine%<Action=%Action%>
		Hist_DB = %NewLine%`r`n%Hist_DB%	;add latest item at beginning of history
	}
	return

	p_ComicsContextMenu:
	p_ComicsClose:
	p_ComicsEscape:
		Gui, %cGUI_Comics%:Destroy
	Return

	NextComic:
		ComicsDiff = 24					; this is 'positive advance' cache
		EnvAdd, Now, %ComicsDiff%, H		;going 24 hrs forth
		if (Now > A_Now)
			GuiControl, Disable, Button2		; can't go further than 'today'
		else goto CommonComic
	PrevComic:
		ComicsDiff = -24					; this is 'negative advance' cache
		if (Now < A_Now)
			GuiControl, Enable, Button2		; enable 'forward' button only if it wouldn't take us to 'tomorrow'
		EnvAdd, Now, %ComicsDiff%, H		;going 24 hrs back
	CommonComic:
		GuiControl,, SysDateTimePick321, %Now%	; update the date in DateTime picker
		ODate = %Date%
		OYear = %OYear%
		FormatTime, Date, %Now%, yyMMdd
		FormatTime, Year, %Now%, yyyy
		StringReplace, URL, URL, %ODate%, %Date%, A
		StringReplace, URL, URL, %OYear%, %Year%, A
		GuiControl,, Static2, Downloading...
	RetryComic:
		URLDownloadToFile, %URL%, %A_ScriptDir%\tmp\comic.gif
		FileRead, i, %A_ScriptDir%\tmp\comic.gif
		StringTrimLeft, ComicsTitle, i, InStr(i, "<title>") +6
		StringLeft, ComicsTitle, ComicsTitle, InStr(ComicsTitle, "</title>")-1
		if InStr(ComicsTitle, "404")	; check for error text ("404 - File not found" is full text)
			{
			if (ComicsTotalRetries = ComicsMaxTotalRetries)
				goto p_ComicsClose
			if (ComicsRetry < ComicsMaxRetries)	; make sure we don't overcome max retries
				{
				ComicsRetry++
				GuiControl,, Static2, Retry %ComicsRetry%...
				Sleep, 5000	; if we don't delay the requests, we may get banned from their server !
				goto RetryComic
				}
			else
				{
				ComicsRetry=0
				EnvAdd, Now, %ComicsDiff%, H		;going 24 hrs in last direction
				if (Now > A_Now)					; we can't get tomorrow's picture
					{
					ComicsTotalRetries=0			; reinitialize total retries when switching direction
					ComicsDiff = -24				; so we switch direction to backwards
					EnvAdd, Now, % ComicsDiff*2, H	; and subtract the 24h we just added plus another 24h
					}
				else if (Now < "20000101000000")		; we won't go further back than 01.01.2000 (debatable)
					{
					ComicsTotalRetries=0			; reinitialize total retries when switching direction
					ComicsDiff = 24				; so we switch direction to forwards
					EnvAdd, Now, % ComicsDiff*2, H	; and add the 24h we just subtracted plus another 24h
					}
				ComicsTotalRetries++
				Sleep, 5000	; if we don't delay the requests, we may get banned from their server !
				goto CommonComic
				}
			}
		GuiControl,, Static1, %A_ScriptDir%\tmp\comic.gif
		ControlGetPos,,,, h,, ahk_id %hComic%
		GuiControl, Move, Button1, % "y" h+10
		GuiControl, Move, Button2, % "y" h+10
		GuiControl, Move, SysDateTimePick321, % "y" h+10
		GuiControl, Move, Static2, % "y" h+10
		GuiControl,, Static2,
		Gui, Show, AutoSize, Comic : %Title%
		IniWrite, %Now%, %File_conf%, %OPlugName%, LastDate
	return
}
