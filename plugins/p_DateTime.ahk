/*
Plugin: DateTime 
Expansion to application: Node <http://getnode.in>

Shows date and time in user defined format within Node. Up to 5 different formats could be defined.

Provided Scanstrings (depends on settings):
 /datetime1 ... /datetime5

Author: hoppfrosch <hoppfrosch@ahk4.net>

--BEGIN Credits--
just me for TimeZone functionality (http://www.autohotkey.com/community/viewtopic.php?t=73951)
guest for SortArray function (http://www.autohotkey.com/community/viewtopic.php?t=75620)
--END Credits--

--BEGIN History--
Version 1.0.4 - 20120919 -(Node 0.39) 
  [+] TimeZone-functionality (http://www.autohotkey.com/community/viewtopic.php?t=73951)
  [*] redesigned configuration page (continued)
  [+] Credits
  [+] P_DateTime_SortArray() - sorting one dimensional arrays (http://www.autohotkey.com/community/viewtopic.php?t=75620)
  [+] P_DateTime_Timestamp() - storage for timestamps (http://getnode.in/forum/viewtopic.php?f=4&t=26)
  [+] P_DateTime_Timezones()  - Reads the Timezones from Registry into an array and map
  [+] P_DateTime_TimezoneString() - Maps the TZ from setting into correct input string for function ConvertTime() from f_TimeZones.ahk
Version 1.0.3 - 20120911 -(Node 0.39) 
  [*] redesigned configuration page (continued)
Version 1.0.2 - 20120910 - (Node 0.39) 
  [*] redesigned configuration page
  [-] Bugfix: "enabled" state on configuration page 
  [+] P_DateTime_Version() to get version number of plugin
Version 1.0.1 - 20120910 - (Node 0.39) 
  [+] new Action: "Copy to Clipboard"
Version 1.0.0 - 20120907 - (Node 0.39)
--END History--
----------------------------------------------------------------
*/
ExitApp

; returns current version of this plugin
P_DateTime_Version()
{
	return "1.0.4"
}

; Scan to create a database
; Up to 5 entries are created (/datetime1...5) - dependent on Setting
P_DateTime_Scan()
{
	Static
	Global File_conf
	RegExMatch(A_ThisFunc, "U)_(?<PlugName>.*)_", O)	;get the name of this plugin
	
	; Initial population of Settings (Create default INI and/or populate from INI)
	P_DateTime_ConfInit()
		
	; Use only activated items as keyword
	Loop, 5
	{
		if p_DateTime_C_Enable%A_Index%
		{
			;add a / at the beginning of Scan tag for top level object - this places it higher up when searched with a /
			DBdataStr =  %DBdataStr%<Object=%OPlugName%><Plugin=%OPlugName%><Scan1=/%OPlugName%%a_index%>`n
		}
	}

	PluginDBPut(OPlugName,"REFRESH")		;this command resets the counter of DBs for this plugin
	DBdata = %DBdataStr%
	PluginDBPut(OPlugName,DBdata)
}

P_DateTime_ConfInfo(ByRef Author, ByRef Info)
{
	Author = hoppfrosch <hoppfrosch@ahk4.net>
	Info = Custom Date and Time entries plugin.
}


; Returns the pipe separated list of Objects it supports
P_DateTime_Objects()
{
	RegExMatch(A_ThisFunc, "U)_(?<PlugName>.*)_", O)
	Objects = %OPlugName%
	Return Objects
}

; The result from database is provided to this function and this function returns
; how the results are to be shown in GUI as main and sub text and icon
P_DateTime_ToShow(SrchStrng, Result, ByRef LVLine, ByRef MainTxt, ByRef SubTxt, ByRef IconIdx, ByRef InfoBar)
{
	Static
	Global File_conf
	RegExMatch(A_ThisFunc, "U)_(?<PlugName>.*)_", O)
		
	if !IconIdx
		IconIdx := GetIcon(A_ScriptDir "\res\icons\Objects\" OPlugName ".ico")
	
	index := 1
	IfInString, Result, <Scan1=/%OPlugName%1> 
		index := 1
	IfInString, Result, <Scan1=/%OPlugName%2> 
		index := 2		
	IfInString, Result, <Scan1=/%OPlugName%3> 
		index := 3
	IfInString, Result, <Scan1=/%OPlugName%4>
		index := 4
	IfInString, Result, <Scan1=/%OPlugName%5> 
		index := 5
	
	; Use configured icon 
	IniRead Val_icon, %File_conf%, %OPlugName%, %OPlugName%%index%Icon
	IfExist, %A_ScriptDir%\res\icons\Objects\%Val_Icon%.ico
		IconIdx := GetIcon(A_ScriptDir "\res\icons\Objects\" Val_icon ".ico")
	; Get configured Timezone
	IniRead Val_timezone, %File_conf%, %OPlugName%, %OPlugName%%index%Timezone
	; Use configured format
	IniRead Val_format, %File_conf%, %OPlugName%, %OPlugName%%index%Format
	; Convert timestamp to desired timezone
	;.................... Timestamp to convert............Src-Timezone......Dest-Timezone............................Object with all Timezones
	TS_TZ := ConvertTime(P_DateTime_Timestamp(index, 1),  "(*) Local Time", P_DateTime_TimezoneString(Val_timezone), P_DateTime_Timezones(1))
	; reformat the timezoned Timestamp with desired format
	FormatTime, OutputVar, %TS_TZ%/, %Val_format%
	
	MainTxt = %OutputVar%
	; Additional Information
	SubTxt =
	InfoBar = %Val_format% / %Val_timezone%
	LVLine = /%OPlugName%%index% (%OutputVar%)
}

; Add plugin specific settings to own tab in settings
P_DateTime_ConfGUI(GUI_ID)
{
	Static
	Global File_conf
		, p_DateTime_C_Enable1,   p_DateTime_C_Enable2,   p_DateTime_C_Enable3,   p_DateTime_C_Enable4,   p_DateTime_C_Enable5
		, p_DateTime_C_Format1,   p_DateTime_C_Format2,   p_DateTime_C_Format3,   p_DateTime_C_Format4,   p_DateTime_C_Format5
		, p_DateTime_C_Icon1,     p_DateTime_C_Icon2,     p_DateTime_C_Icon3,     p_DateTime_C_Icon4,     p_DateTime_C_Icon5
		, p_DateTime_C_Timezone1, p_DateTime_C_Timezone2, p_DateTime_C_Timezone3, p_DateTime_C_Timezone4, p_DateTime_C_Timezone5
	RegExMatch(A_ThisFunc, "U)_(?<PlugName>.*)_", O)

	Gui, %GUI_ID%:Default
	Gui, Tab, %OPlugName%,, Exact
	Gui, +LastFound

    ; Configuration-GUI is designed to take full area of provided Tab
	; It consist of two group boxes: "Configuration" and "Misc" - just specify height of "Configuration" and "Misc" will automatically take the remaining space
	
	X0Tab := 10 
	Y0Tab = 30
	WTab := 740
	HTab := 415

	SpacingHorizontal := 8
	SpacingVertical := SpacingHorizontal
	HeightLine := 13
	SpacingLine := HeightLine + SpacingVertical
	
	XGroupboxConfiguration := X0Tab
	YGroupboxConfiguration := Y0Tab
	HGroupboxConfiguration := 300
	WGroupboxConfiguration := WTab
	
	; -------------------------------------------------
	; Groupbox: Configuration
	Gui, Add, GroupBox, x%XGroupboxConfiguration% y%YGroupboxConfiguration% w%WGroupboxConfiguration% h%HGroupboxConfiguration% +Center, Configuration
	
	; Add the contents (Application specific!)
	Y0 := YGroupboxConfiguration + SpacingVertical 
	XTitle := XGroupboxConfiguration + SpacingHorizontal
	WTitle := 55
	XFormat := XTitle + WTitle + SpacingHorizontal
	WFormat := 180
	XIcon := XFormat + WFormat + SpacingHorizontal
	WIcon := 60
	XTimeZone := XIcon + WIcon + SpacingHorizontal
	WTimeZone := 300
	XEnable := XTimeZone + WTimeZone + SpacingHorizontal
	WEnable := 35
	
	Y0 := YGroupboxConfiguration + SpacingLine
	
	Gui,Add,Text,x%XTitle% y%Y0% w%WFormat% h%HeightLine% ,Scanstring
	Gui,Add,Text,x%XFormat% y%Y0% w%WFormat% h%HeightLine% ,Format
	Gui,Add,Text,x%XIcon% y%Y0% w%WIcon% h%HeightLine% ,Icon
	Gui,Add,Text,x%XTimezone% y%Y0% w%WTimezone% h%HeightLine% ,Timezone
	Gui,Add,Text,x%XEnable% y%Y0% w%WEnable% h%HeightLine% ,Enable
	
	RegTimeZones := GetTimeZones()	
	TZChoices := P_DateTime_Timezones()

	Loop, 5
	{
		Y0 :=  Y0 + SpacingLine

		Gui,Add,Text,x%XTitle% y%Y0% w%WTitle% ,%OPlugName%%A_Index%
		
		Val_Format:= p_DateTime_C_Format%A_Index%
		Gui,Add,Edit,x%XFormat% y%Y0% w%WFormat% vp_DateTime_C_Format%A_Index% ,%Val_Format%
		
		p_DateTime_C_Icon%A_Index% := LTrim(RTrim(p_DateTime_C_Icon%A_Index%))
		Choices := "Default|"
		if ((p_DateTime_C_Icon%A_Index% = "") || (p_DateTime_C_Icon%A_Index% = "Default"))
			Choices := Choices "|"
		Choices := Choices "Date|"
		if (p_DateTime_C_Icon%A_Index% = "Date")
			Choices := Choices "|"
		Choices := Choices "Time|"
		if (p_DateTime_C_Icon%A_Index% = "Time")
			Choices := Choices "|"z
		
		Gui,Add,DropDownList,x%XIcon% y%Y0% w%WIcon% vp_DateTime_C_Icon%A_Index%, %Choices%

		; Preselect the Timezone from setting
		Choices := TZChoices
		strSrch := p_DateTime_C_Timezone%A_Index% "|("
		strRplc := p_DateTime_C_Timezone%A_Index% "||("
		StringReplace, Choices , Choices, %strSrch%, %strRplc%
		Gui,Add,DropDownList,x%XTimeZone% y%Y0% w%WTimeZone% vp_DateTime_C_Timezone%A_Index%, %Choices%
		
		Val_use := p_DateTime_C_Enable%A_Index%
		if (Val_use = 1)
			Gui,Add,Checkbox,Checked x%XEnable% y%Y0% w%WEnable% h%HeightLine% vp_DateTime_C_Enable%A_Index%,
		else
			Gui,Add,Checkbox,x%XEnable% y%Y0% w%WEnable% h%HeightLine% vp_DateTime_C_Enable%A_Index%,
	}
	
	;--------------------------------------
	; Groupbox: Miscellaneous
	XGroupboxMisc := SpacingHorizontal
	YGroupboxMisc := YGroupboxConfiguration + HGroupboxConfiguration
	HGroupboxMisc := HTab - HGroupboxConfiguration
	WGroupboxMisc := WTab
	
	txtHelp := "Plugin to provide up to 5 Scanstrings (/DateTime1 ... 5)`n"
	txtHelp := txtHelp "- Enable scanstrings to be used in Node`n"
	txtHelp := txtHelp "- For Format see AHK-Dokumentation->FormatTime`n"
	txtHelp := txtHelp "- Use Action 'Copy to Clipboard' ... (Default action)`n"

	txtAbout := "Plugin " OPlugName " - Version " P_DateTime_Version()
	txtAbout := txtAbout "`n"
	txtAbout := txtAbout "Designed for Node 0.39"
	txtAbout := txtAbout "`n"
	txtAbout := txtAbout "by Hoppfrosch (at ahk4 dot me)"
	
	Gui, Add, GroupBox, x%XGroupboxMisc% y%YGroupboxMisc% w%WGroupboxMisc% h%HGroupboxMisc% +Center, Miscellaneous
	YInnerGroupBox :=  YGroupboxMisc + SpacingVertical
	XGroupBoxHelp := XGroupboxMisc + SpacingHorizontal
	WInnerGroupBox := Floor((WGroupboxMisc - 3 * SpacingHorizontal)/2)
	HInnerGroupBox := HGroupboxMisc - 2 * SpacingVertical
	Gui, Add, GroupBox, x%XGroupBoxHelp% y%YInnerGroupBox% w%WInnerGroupBox% h%HInnerGroupBox% +Center, Help
	XGroupBoxAbout := XGroupBoxHelp + WInnerGroupBox + SpacingHorizontal
	Gui, Add, GroupBox, x%XGroupBoxAbout% y%YInnerGroupBox% w%WInnerGroupBox% h%HInnerGroupBox% +Center, About
	
	; Help-Groupbox  - Positioning relative to outer Misc-Groupbox
	XTxtHelp := XGroupBoxHelp + SpacingHorizontal
	YTxtHelp := YInnerGroupBox + 2 * SpacingVertical
	; Width of the inner groupboxes (About, Help)
	WTxtInnerGroupBox := WInnerGroupBox - 2*SpacingHorizontal
	Gui,Add,Text,x%XTxtHelp% y%YTxtHelp% w%WTxtInnerGroupBox%,%txtHelp%
	
	; About-Groupbox  - Positioning relative to Help-Groupbox
	XTxtAbout := XGroupBoxAbout + SpacingHorizontal
	YTxtAbout := YInnerGroupBox + 2 * SpacingVertical
	Gui,Add,Text,x%XTxtAbout% y%YTxtAbout% w%WTxtInnerGroupBox%,%txtAbout%
	
	Return
}

;this function will autorun when the configuration Save button is pressed
P_DateTime_ConfSave()
{
	Global File_Conf
		, p_DateTime_C_Enable1,   p_DateTime_C_Enable2,   p_DateTime_C_Enable3,   p_DateTime_C_Enable4,   p_DateTime_C_Enable5
		, p_DateTime_C_Format1,   p_DateTime_C_Format2,   p_DateTime_C_Format3,   p_DateTime_C_Format4,   p_DateTime_C_Format5
		, p_DateTime_C_Icon1,     p_DateTime_C_Icon2,     p_DateTime_C_Icon3,     p_DateTime_C_Icon4,     p_DateTime_C_Icon5
		, p_DateTime_C_Timezone1, p_DateTime_C_Timezone2, p_DateTime_C_Timezone3, p_DateTime_C_Timezone4, p_DateTime_C_Timezone5
	RegExMatch(A_ThisFunc, "U)_(?<PlugName>.*)_", O)
	
	Gui, Submit, NoHide
	Loop, 5
	{
		Val_use := p_DateTime_C_Enable%A_Index%
		Val_format := p_DateTime_C_Format%A_Index%
		Val_icon := p_DateTime_C_Icon%A_Index%
		Val_Timezone := p_DateTime_C_Timezone%A_Index%
		
		IniWrite %Val_use%, %File_conf%, %OPlugName%, %OPlugName%%A_Index%Use
		IniWrite %Val_format%, %File_conf%, %OPlugName%, %OPlugName%%A_Index%Format
		IniWrite %Val_icon%, %File_conf%, %OPlugName%, %OPlugName%%A_Index%Icon
		IniWrite %Val_Timezone%, %File_conf%, %OPlugName%, %OPlugName%%A_Index%Timezone
	}
	;P_DateTime_ConfDisplay(A_ThisFunc)
}

; Initialization of settings (either default values (if nor exist) or read from INI-File)
P_DateTime_ConfInit()
{
	Static
	Global File_Conf
		, p_DateTime_C_Enable1,   p_DateTime_C_Enable2,   p_DateTime_C_Enable3,   p_DateTime_C_Enable4,   p_DateTime_C_Enable5
		, p_DateTime_C_Format1,   p_DateTime_C_Format2,   p_DateTime_C_Format3,   p_DateTime_C_Format4,   p_DateTime_C_Format5
		, p_DateTime_C_Icon1,     p_DateTime_C_Icon2,     p_DateTime_C_Icon3,     p_DateTime_C_Icon4,     p_DateTime_C_Icon5
		, p_DateTime_C_Timezone1, p_DateTime_C_Timezone2, p_DateTime_C_Timezone3, p_DateTime_C_Timezone4, p_DateTime_C_Timezone5
	RegExMatch(A_ThisFunc, "U)_(?<PlugName>.*)_", O)
	
    ; Generate default setting
	Loop 5 {
		p_DateTime_C_Enable%A_Index% = 0
		p_DateTime_C_Format%A_Index% = "ddd,dd.MMM.yyyy HH:mm:ss"
		p_DateTime_C_Icon%A_Index%   = "Default"
		p_DateTime_C_Timezone%A_Index% = "(*) Local Time"
	}
	; Enable the first entry ...
	p_DateTime_C_Enable1 = 1
	p_DateTime_C_Icon1 = "Date"
	
	; If there are no setting entries in INI-File, generate default entries - else read settings from INI-File
	Loop, 5
	{
		IniRead Use, %File_conf%, %OPlugName%, %OPlugName%%A_Index%Use
		if (Use="ERROR") {
			Val := p_DateTime_C_Enable%A_Index%
			IniWrite %Val%, %File_conf%, %OPlugName%, %OPlugName%%A_Index%Use
		} 
		else 
			p_DateTime_C_Enable%A_Index% := Use
		
		IniRead Format, %File_conf%, %OPlugName%, %OPlugName%%A_Index%Format
		if (Format="ERROR") {
			Val := p_DateTime_C_Format%A_Index%
			IniWrite %Val%, %File_conf%, %OPlugName%, %OPlugName%%A_Index%Format
		}
		else 
			p_DateTime_C_Format%A_Index% := Format
		
		IniRead Icon, %File_conf%, %OPlugName%, %OPlugName%%A_Index%Icon
		if (Icon="ERROR") {			
			Val := p_DateTime_C_Icon%A_Index%
			IniWrite %Val%, %File_conf%, %OPlugName%, %OPlugName%%A_Index%Icon
		}
		else 
			p_DateTime_C_Icon%A_Index% := Icon
		
		IniRead Timezone, %File_conf%, %OPlugName%, %OPlugName%%A_Index%Timezone
		if (Timezone="ERROR") {			
			Val := p_DateTime_C_Timezone%A_Index%
			IniWrite %Val%, %File_conf%, %OPlugName%, %OPlugName%%A_Index%Timezone
		}
		else 
			p_DateTime_C_Timezone%A_Index% := Timezone
	}
	
	;P_DateTime_ConfDisplay(A_ThisFunc)
	
	return
}

; List of available actions
P_DateTime_Actions(Line) 
{ 
   RegExMatch(A_ThisFunc, "U)_(?<PlugName>.*)_", O) 
   
   ActionList = 
   (LTrim Join`r`n 
       <Action=%OPlugName%.Copy to Clipboard><Scan1=Copy to Clipboard> 
   ) 
 
   Return ActionList 
}

; Callback on launch of Object+Action combination
P_DateTime_Execute(Line, Action, SrchStrng)
{
	RegExMatch(A_ThisFunc, "U)_(?<PlugName>.*)_", O)
	
	; Determine the command index of chosen command - to select the appropriate Format-Setting
	RegExMatch(Line, "U)\<Scan1=\/DateTime(?<CommandIndex>\d+)\>", O)
	Val_format := p_DateTime_C_Format%OCommandIndex%
	Val_timezone := p_DateTime_C_Timezone%OCommandIndex%
	; Convert time to desired timezone
	;....................Timestamp to convert....................Src-Timezone......Dest-Timezone............................Object with all Timezones
	TS_TZ := ConvertTime(P_DateTime_Timestamp(OCommandIndex, 0), "(*) Local Time", P_DateTime_TimezoneString(Val_timezone), P_DateTime_Timezones(1))
	; format the timezoned Timestamp with desired format
	FormatTime, OutputVar, %TS_TZ%, %Val_format%	

	IfEqual, Action, %OPlugName%.Copy to Clipboard
	{
		Clipboard := OutputVar
		Notify("NODE","Copied <" OutputVar "> to clipboard", 2, "GC=303030 TC=FFFFFF TS=8 TF=Verdana MC=FFFFFF MF=Verdana SI=200 ST=200 SC=200 BK=White IW=16 IH=16 Image=" 261)
	}
}

; Display the current settings (for debuging purposes)
P_DateTime_ConfDisplay(Title="")
{
	Static
	Global File_Conf
		, p_DateTime_C_Enable1,   p_DateTime_C_Enable2,   p_DateTime_C_Enable3,   p_DateTime_C_Enable4,   p_DateTime_C_Enable5
		, p_DateTime_C_Format1,   p_DateTime_C_Format2,   p_DateTime_C_Format3,   p_DateTime_C_Format4,   p_DateTime_C_Format5
		, p_DateTime_C_Icon1,     p_DateTime_C_Icon2,     p_DateTime_C_Icon3,     p_DateTime_C_Icon4,     p_DateTime_C_Icon5
		, p_DateTime_C_Timezone1, p_DateTime_C_Timezone2, p_DateTime_C_Timezone3, p_DateTime_C_Timezone4, p_DateTime_C_Timezone5
		
	RegExMatch(A_ThisFunc, "U)_(?<PlugName>.*)_", O)

	Output := ""
	Loop, 5
	{
		Output := Output OPlugName A_Index " - "
		Output := Output " * Use:" p_DateTime_C_Enable%A_Index%
		Output := Output " * Format:" p_DateTime_C_Format%A_Index%
		Output := Output " * Icon:" p_DateTime_C_Icon%A_Index%
		Output := Output " * Timezone:" p_DateTime_C_Timezone%A_Index%
		Output := Output "`n"
	}
	MsgBox ,,%Title%, %Output%
}

; Sorting of one dimensional array (Taken from : http://www.autohotkey.com/community/viewtopic.php?t=75620)
P_DateTime_SortArray(ByRef Array, Order="A") {
	; Taken from : http://www.autohotkey.com/community/viewtopic.php?t=75620
	;Order A: Ascending D: Descending R:Reverse
	MaxIndex := Array.MaxIndex(), count := 0
	If (Order = "R") {
		Loop, % MaxIndex {
			Array.Insert(Array.Remove(MaxIndex - count)) 
			count++
		}
	} else {
		Loop, % MaxIndex {
			Loop, % MaxIndex - count + ((Order = "D") ? 1 : 0) {
				if !(A_Index = 1) && ((Order = "A") ? (Array[prevIndex] > Array[A_Index]) : (Array[prevIndex] < Array[A_Index]))  {
					_tmp := Array[A_Index]   
					Array[A_index] := Array[prevIndex]
					Array[prevIndex] := _tmp   
				}         
				prevIndex := A_Index
			}     
			count++
		}
	}
}

; Provide a static storage for timestamps ...
P_DateTime_Timestamp(index, Update = 0) {

	static Timestamp := []
	
	if !(TimeStamp[index]) || (update =1) {
		FormatTime, OutputVar,, yyyyMMddhhmmss
		TimeStamp[index] := OutputVar
	}
	return TimeStamp[index]	
}

; Reads the Timezones from Registry into an array and map
; Parameter type = 0 - Returns "|"  concatenated string of all timezones - to be used within settings-dropdownbox
; Parameter type = 1 - Returns map of registered timezones - This map is required as input for function ConvertTime() from f_TimeZones.ahk
; Parameter type = 2 - Returns inverted map of registered timezones - This map is required by function P_DateTime_TimezoneString()
P_DateTime_Timezones(type = 0) {
	static TimeZonesInvMap
	static TimeZonesMap
	static TimeZonesChoiceStr
	TimeZonesArr := []

	For Key, Value in TimeZonesMap
		count :=   A_Index
	
	; if map is not initialized, initialize it! This is the case ion first call of this function ...
	if (!count) {
		TimeZonesMap := GetTimeZones()
		TimeZonesMap["(*) Local Time"] := ["(*) Local Time", ""]
		TimeZonesInvMap := {}
		For Key, Value In TimeZonesMap {
			TimeZonesArr.Insert(Value[1])
			TimeZonesInvMap.Insert(Value[1],Key)
		}		
		P_DateTime_SortArray(TimeZonesArr )
		
		TimeZonesChoiceStr := ""
		For Key, Value  in TimeZonesArr {
			TimeZonesChoiceStr :=  TimeZonesChoiceStr Value "|"
		}
	}
	
	If (type = 1)
		return TimeZonesMap
	else If (type = 2)
		return TimeZonesInvMap
	
	return TimeZonesChoiceStr
}

; Map the TZ from setting into correct input string for function ConvertTime() from f_TimeZones.ahk
P_DateTime_TimezoneString(strIn) {
	TimeZonesMap := P_DateTime_Timezones(2)	
	return TimeZonesMap[strIn]
}

#Include %A_ScriptDir%\includes\f_TimeZones.ahk