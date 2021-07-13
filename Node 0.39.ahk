Ver 	= 0.39		;releases only (A simple floating point number enables easy comparison)
IntVer 	= 0.2		;internal versioning in-between releases

/*

--BEGIN Credits--
Laszlo for Calculator function
Drugwash for FileFilter function and lot other stuff
gwarble for the notify function
tidbit, Lexicos and JDN for Clipboard plugin
http://dryicons.com for various icons
--END Credits--
	

--BEGIN ToDo--
-	Scoring configurable
-	Fix Command prompt here for Explorer (sometimes doesn't work)

-	Filebrowsing. Support typing in paths in NODE (hoppfrosch)

-	Key shortcuts ctrl+0-9 for first few results
-	More theme support
-	Support for relative/portable paths (sharethewisdom)
--END ToDo--


--BEGIN History--
0.39
-	The loading time is almost instantaneous after first launch through caching large DBs between sessions
-	Greatly increased responsiveness to key presses while Node is busy searching
-	Greatly increased responsiveness while the Files database is being refreshed
-	Reverted back to file scanning as a separate process instead of a dll function
-	Added option to add Node to startup folder (On by default)
-	Node shows position while scrolling withing results (Thanks Drugwash)
-	User created Aliases are scored higher than other matches (Thanks Michael)
-	Made the DB files redundant, the DBs are now only stored in memory (unlike earlier being on disk plus in memory)
-	Made the Filebrowser configureable (Thanks hoppfrosch and Drugwash)
-	Made the windows moveable by clicking and dragging the logo on window (Thanks Drugwash)
-	Changed Control Panel items from objects to actions, with the Object being /Control Panel
-	(Plugins) In case all the actions are supposed to have the same icon, there's no need to put all them separately in res\icons\actions folder. Just put one there with the name PluginName.ico (eg. ControlP.ico)

0.38
-	Even if the search query is shorter, NODE doesn't skip larger databases
-	Search is MUCH faster than last version
-	Added the formerly missing command to Clipboard object : Remove Formatting
-	Replaced earlier Notify function with Gwarble's function
-	Node shows number of search results (Thanks hoppfrosch)
-	Fixed the annoying issue of Node window remaining active after launching an app (Thanks micjoh)
-	Added Win9x support (Thanks Drugwash)
-	Added AHK_B support (Thanks Drugwash)
-	Faster Files plugin folder scan function (Thanks Drugwash)
-	Use of system imagelist instead of icon handles to better use system resources (Thanks Drugwash)
-	Much better interface of Files plugin configuration (Thanks Drugwash)
-	Fixed bug in database refresh cycle (Thanks Drugwash)

0.37
-	Added object : Comics. Downloads and shows some daily comics from the web.
-	Added object : Window. Adds modifications to active window like Always on Top, Hide window, Kill application etc.
-	Added Toast Notifications (Thanks Rhys and Enguneer)
-	New notifications used in web update checker and a few plugins
-	Node now shows count of results (Thanks hoppfrosch)
-	(Plugins) Made the optional P_PlugName_OnExit function available to all plugins. This is automatically run when Node exits.
-	Updated About dialog

0.36
-	Added action : Create Alias. This allows you to call Mozilla Firefox by typing FF, or Microsoft Excel by typing XL etc (Thanks Michael)
-	Major improvement to search function. NODE is lot less likely to remain stuck at 'Working..' status while you have typed more search terms.
-	Fixed bug in plugin database refresh function (Thanks Drugwash)
-	Fixed bug in web update checker function (Thanks Drugwash)
-	Improved internal icon handle clearing.

0.35
-	The hotkey now toggles the Node window, instead of just showing it (Thanks Uberi)
-	Slight update to Command Prompt plugin to support Total Commander older versions (Thanks Drugwash)
-	The update checker now checks for new version little more frequently (downloads only 4 bytes for the check)
-	(Plugins) Plugins now generate the list of actions dynamically instead of when Node is started. This allows actions to be shown/hidden dynamically based on nature of Object or other variables.
-	Using the above change, the Clipboard plugin now shows the text manipulation commands only when there is text content on clipboard.
-	(Plugins) Changed name of P_PlugName_Analyze() to P_PlugName_SearchAnalyze().
-	(Plugins) Changed internal working of P_PlugName_Actions() to provide actions in Node's DB format instead of formatting it through a function in host

0.34
-	NODE does not clear the edit box when the window is escaped out. Instead, when you reopen it, it starts with previous text selected (Thanks Uberi)
-	Bug fixed where NODE received keystrokes while its window was not in focus
-	Bug fixed where NODE didn't clear the GUI properly when there were no search results

0.33
-	Updated Files plugin scanning routine for speed enhancement and to work the same on all systems (Many thanks Drugwash. Hope to see you back.)
-	Added support for Total Commander to the Command Prompt plugin
-	Bug from 0.32 fixed where the last item in history was not updated in Node window
-	Bug fixed causing Files plugin results not showing up on some systems (Thanks Uberi)
-	Bug fix causing duplicate results of items in history

0.32
-	Fixed too frequent database refresh bug (Thanks Drugwash)
-	Added a new plugin: Command Prompt. This adds a 'Command Prompt here' Action that opens command prompt at the currently open folder in Explorer and recognised explorer replacements (currently beta with support for XYPlorer and Windows Explorer only)
-	Some window activation fixes

0.31
-	Added another plugin: Screen. This adds a Screen object with 'Turn Off' and 'Run Screensaver' actions.
-	The Actions window is not anymore expanded by default, it expands once it receives search or down arrow (like Objects window)
-	After loading Node notifies the current hotkey using a traytip
-	Fixed bug of Files plugin not working where C: was unavailable (Thanks MsgBox)
-	Replaced the prefix of analyze plugins from / to *. As these are not supposed to be called by object name, rather the object is auto-identified, the differentiation was needed.
-	Added a basic web update checker

0.30
-	Did many changes to search algorithm to optimize search time
-	Faster search with lesser keystrokes
-	Directories were inadvertantly shown as selectable objects in Node, now fixed.

0.29
-	Added Control Panel plugin. Node can now search and open Control Panel items.
-	Fixed bug where Up/Down keys had undesired effect on Configuration window (Thanks nimda)
-	Extensions for Files plugin in Config can now be typed as 'ahk' instead of '*.ahk' (Thanks nimda and Drugwash)

0.28
-	Added a new plugin - 'Internal'. This currently adds these three new internal commands as sub-objects to NODE.
	/Configuration
	/Restart
	/Quit

0.27
-	Updated 'Files' plugin to support directory names search as well (Thanks Drugwash)
-	Pressing Ctrl+Delete in Objects window deletes currently selected History item
-	The tray tip while loading also displays the version number

0.26
-	Made some control colors darker in Light theme to improve readability (Thanks comvox)
-	Added PageUp and PageDown support to traverse in the results (Thanks comvox)
-	Added support for these functions to the Calculator plugin (Abs,Ceil,Exp,Floor,Log,Ln,Round,Sqrt,Sin,Cos,Tan,ASin,ACos,ATan,SGN,Fib,fac)
-	Replaced the 'More Objects availability' indicator from '...' to '<-->' to make it more prominent

0.25
-	Updated the window handling subroutine, this will have a noticieable positive effect on speed
-	Removed vertical scrollbar to improve appearance
-	Changed some more window attributes

0.24
-	Fix for crash due to blank hotkey (Thanks Sumon)

0.23
-	Fix to remove horizontal scrollbar (Thanks Sumon and Drugwash)
-	Much more stable window handling while moving between Object and Action windows (Thanks Sumon)

0.22
-	Auto updates all databases on restart
-	Fixed bug with saving list of folders to be scanned (thanks comvox)
-	Fixed Restart didn't save usage history

0.21
-	First public release

--END History--

*/
;-------- AUTOEXEC

DevMode = 1

#NoEnv
AutoTrim, Off
SetBatchLines, -1
SetWinDelay, 0
SetControlDelay, 0
#SingleInstance Ignore
DetectHiddenWindows, On
;#MaxHotkeysPerInterval 200		;not so many can be handled, but this gets rid of the msgbox
DetectHiddenText, On
SetTitleMatchMode, 3
SetKeyDelay, 0
StringCaseSense, Off

;Vars to add Win9x support
is9x := A_OSType="WIN32_NT" ? FALSE : TRUE
isL := A_AhkVersion > "1.0.48.05" ? TRUE : FALSE
Ptr := isL ? "Ptr" : "UInt"
PtrP := isL ? "PtrP" : "UIntP"
AStr := A_IsUnicode ? "AStr" : "Str"
SetWorkingDir, %A_ScriptDir%
TimedRun1 = %A_TickCount%

;declare global vars
	AName = NODE
	GUI_Conf = Configuration
	GUI_M1 = Objects
	GUI_M2 = Actions
	GUI_About = About
	
	;below to add AHK_B support
	guiNames=GUI_Conf|GUI_M1|GUI_M2|Gui_About
	NextGuiNmb = 1			; next available GUI number for use in plug-ins
	Loop, Parse, guiNames, |	; create GUI count aliases according to AHK version
		c%A_LoopField% := isL ? %A_LoopField% : NextGuiNmb++

	MaxHistorySize = 50
	WaitTime = 100
	MinimumLen = 2
	CompressWH = 80
	ExpandWH = 313
	SplChar = /
	AnlChar = *
	DefaultHotkey = ^/
	AWebsite = www.getnode.in


;to include plugins, add name here and include file at end of script
	Plugs_NameList = Clipboard|Calculator|Window|CommandP|Comics|Screen|Internal|ControlP|DateTime|Files


;configuration and database files
	File_conf = %A_ScriptDir%\Config.ini
	File_hist = %A_ScriptDir%\db\History.ndb

;forcing single instance
IfWinExist, %AName% %GUI_M1%
	ExitApp

TrayTip, %AName%, v%Ver% Loading,10, 1

IfEqual, A_IsCompiled, 1
{
	Menu, Tray, NoStandard
	DevMode = 0
	Menu, Tray, Icon, %A_ScriptFullPath%, 1, 1; without this there's no tray icon in 9x
}
else
	Menu, Tray, Icon, %A_ScriptDir%\res\icons\%AName%.ico

IfEqual, DevMode, 1
	Hotkey, +Esc, Quit, UseErrorLevel

Gosub, ReadConfig	;read own config
Gosub, ListPlugs	;read and make a list of plugins
Gosub, MakeTrayMenu
Gosub, MakeFolders

;create/remove startup icon
IfEqual, Main_C_Startup, 1
IfNotExist, %A_Startup%\Node.lnk
	FileCreateShortcut, %A_ScriptFullPath%, %A_Startup%\Node.lnk

IfEqual, Main_C_Startup, 0
IfExist, %A_Startup%\Node.lnk
	FileDelete, %A_Startup%\Node.lnk

;getting handle to own icon (we need these here since later on we attach ImageList to ListView)
OwnIcon := A_IsCompiled ? A_ScriptFullPath : A_ScriptDir "\res\icons\node.ico"
hSysIL := GetIcon(OwnIcon)			; get handle to System ImageList on very first call to the function
OwnIconIdx := GetIcon(OwnIcon)		; get own icon index
hOwnIcon := GetIcon(OwnIcon, "2")	; get own icon handle (we'll lose this someday, maybe)

Gosub, ReadDB

;create GUIs
Gosub, MakeGUI_Conf


SetTimer, RefreshDB, 60000	;check every minute to refresh DBs

;Basic theme support
IfEqual, Main_C_Theme, Dark
{
	Block_Col_1 = 303030
	Block_Col_2 = FFFFFF
	Block_Col_3 = AAAAAA
}
Else
{
	Block_Col_1 = E8EADC
	Block_Col_2 = 504030
	Block_Col_3 = 707070
}

;MakeBlock( ID, Title, EditSection, RunSection, SelSection, ByRef IL_ID, BColor, C1Color, C2Color, PosXY, ShowLV = "Y", LogoVis = "", GuiVis = "", CtrlBorders = "")
MakeBlock( cGUI_M1, AName " " GUI_M1, "M1B1", "ChangeSel", hSysIL, Block_Col_1, Block_Col_2, Block_Col_3, "y200", "", "", "Hide", "")
MakeBlock( cGUI_M2, AName " " GUI_M2, "M2B1", "ChangeSel", hSysIL, Block_Col_1, Block_Col_2, Block_Col_3, "y285", "", "", "Hide", "")
PostMessage, 0x172, 1, %hOwnIcon%, %BCtrl_Icon%, %AName% %GUI_M1%   ;0x172 is STM_SETIMAGE

GroupAdd, M, %AName% %GUI_M1%
GroupAdd, M, %AName% %GUI_M2%
GroupAdd, C, %AName% %GUI_Conf%

SetTimer, Search1, %WaitTime%
SetTimer, Search2, %WaitTime%
SetTimer, WinWatch, 200


;preloading history to even reduce first time loading time
IfNotEqual, Hist_DB,
	AlreadyAddedObjects := LoadMatches( Hist_DB, Search1, cGUI_M1, hSysIL, BCtrl_Edit, AlreadyAddedObjects, 10, "")

OnExit, Quit


Hotkey, IfWinNotActive, ahk_group C
Hotkey, %Main_C_Hotkey%, ShowHK, UseErrorLevel
IfNotEqual, ErrorLevel, 0
{
	Main_C_Hotkey = %DefaultHotkey%
	Hotkey, %Main_C_Hotkey%, ShowHK, UseErrorLevel
}
Hotkey, IfWinNotActive
TrayTip		;done loading

chk := FormatHK(Main_C_Hotkey)
Notify("NODE","Press  " chk "  to call", 3, "GC=303030 TC=FFFFFF TS=8 TF=Verdana MC=FFFFFF MF=Verdana SI=200 ST=200 SC=200 BK=White IW=16 IH=16 Image=" OwnIcon)

;check for new version after a while
SetTimer, UpdateCheck, 30000

return

;-------- AUTOEXEC.

ChangeSel:
	LVEvent = %A_GuiEvent%
	Gui, %A_Gui%:Default
	SelRow := LV_GetNext(0, "Focused")
	;IfEqual, %A_Gui%LastSelRow, %SelRow%
	;	Return
	;%A_Gui%LastSelRow = %SelRow%
	IfEqual, SelRow, 0
		Return
	
	
	GetObjData(ObjLine, ObjPlug, ObjObject, ObjAction, ObjSearch, ObjIcon)
	IfEqual, A_Gui, %cGUI_M1%
	{
		If IsFunc("P_" ObjPlug "_ToShow")
			P_%ObjPlug%_ToShow( Search1, ObjLine, LVLine, ObjMainTxt, ObjSubTxt, ObjIcon, ObjInfo)
		GuiControl,, %BCtrl_MText%, %ObjMainTxt%
		GuiControl,, %BCtrl_SText%, %ObjSubTxt%
		GuiControl,, %BCtrl_IBar1%, %ObjInfo%
		Act2Show = %ObjAction%
		IfNotEqual, Act2Show,
		{
			StringGetPos, chk, ObjAction, .
			chk++
			StringTrimLeft, Act2Show, ObjAction, %chk%
		}
		GuiControl,, %BCtrl_SBar1%, %Act2Show%
		hObjIcon := DllCall("ImageList_GetIcon", Ptr, hSysIL, "UInt", ObjIcon-1, "UInt", 0x1)	; 0x10=ILD_MASK 0x1=ILD_TRANSPARENT
		SendMessage, 0x172, 1, %hObjIcon%, %BCtrl_Icon%, %AName% %GUI_M1%   ;0x172 is STM_SETIMAGE
		DllCall("DeleteIcon", Ptr, ErrorLevel)	; trick: delete control's previously set icon, returned as handle in ErrorLevel
	}	; we NEED to use SendMessage above (and below) because we want the ErrorLevel returned (see above)
	IfEqual, A_Gui, %cGUI_M2%
	{
		GetActData(ActLine, ActAction, ActPlug, ActName, ActSearch, ActIcon)
		GuiControl,, %BCtrl_MText%, %ActName%
		GuiControl,, %BCtrl_SText%,
		hActIcon := DllCall("ImageList_GetIcon", Ptr, hSysIL, "UInt", ActIcon-1, "UInt", 0x1)	; 0x10=ILD_MASK 0x1=ILD_TRANSPARENT
		SendMessage, 0x172, 1, %hActIcon%, %BCtrl_Icon%, %AName% %GUI_M2%   ;0x172 is STM_SETIMAGE
		DllCall("DeleteIcon", Ptr, ErrorLevel)	; trick: delete control's previously set icon, returned as handle in ErrorLevel
	}
	IfEqual, LVEvent, DoubleClick
		Gosub, M1B1

return


CleanupGUI(GUI)
{
	Global

	Gui, %GUI%:Default
	GuiControl,, %BCtrl_MText%,
	GuiControl,, %BCtrl_SText%,
	GuiControl,, %BCtrl_IBar1%, 
	GuiControl,, %BCtrl_SBar1%,
	GuiControl,, %BCtrl_SBar2%,
	GuiControl,, %BCtrl_SBar3%,
	PostMessage, 0x172, 1, %hOwnIcon%, %BCtrl_Icon%, %AName% %GUI%   ;0x172 is STM_SETIMAGE
}


Search1:
	Gui, %cGUI_M1%:Default
	GuiControlGet, Search1,, %BCtrl_Edit%
	
	Search1 := StripPadding(Search1)
	LSearch1 := StripPadding(LSearch1)
	IfEqual, Search1, %LSearch1%
		Return

	LV_Delete()
	LSearch1 = %Search1%
	SkippedDBs = 0
	AlreadyAddedObjects =
	StringLen, Search1Len, Search1
	
	;if search is blank, look in History
	IfEqual, Search1,
		LoadMatches( Hist_DB, "", cGUI_M1, hSysIL, BCtrl_Edit, AlreadyAddedObjects, 0, "")
	
	IfNotEqual, Search1,
	{
		;the below searches are done only if minimum length is exceeded
		;exception is top level objects
		IfLess, Search1Len, %MinimumLen%
		{
			StringLeft, 1Char, Search1, 1
			IfNotEqual, 1Char, %SplChar%
			{
				CleanupGUI(cGUI_M1)
				return
			}
		}

		;Going through Analyze plugins to see if they can smartly catch and determine the type of search
		;before transferring control to search plugins
		Loop, Parse, Plugs_SearchAnalyzeList, |
		{
			ThisPlug = %A_LoopField%
			IfEqual, ThisPlug,
				continue

			If IsFunc("P_" ThisPlug "_SearchAnalyze")
				chk := P_%ThisPlug%_SearchAnalyze(Search1)
			IfEqual, chk, Y
			If IsFunc("P_" ThisPlug "_ToShow")
			{
				ThisDBName = P_%ThisPlug%1_DB		;analyze plugins would only have single DB, so loop not needed
				ThisPlugDB := %ThisDBName%
				;analyze plugins are prefixed by *
				MatchList := LoadMatches( ThisPlugDB, AnlChar ThisPlug, cGUI_M1, hSysIL, BCtrl_Edit, AlreadyAddedObjects, 5, "")	;these resuls are given a priority by adding score
			}
		}
			
	
		;AlreadyAddedObjects =
		ATime1 = %A_TickCount%
		WinMove, %AName% %GUI_M1%,,,,, %ExpandWH%
		
		IfExist, %File_hist%
		{
			MatchList := LoadMatches( Hist_DB, Search1, cGUI_M1, hSysIL, BCtrl_Edit, AlreadyAddedObjects, 10, "")
			IfNotEqual, MatchList,
				AlreadyAddedObjects = %AlreadyAddedObjects%`n%MatchList%
		}
		Loop, Parse, Plugs_ScanList, |		;looping one plugin at a time
		{
			ThisPlug = %A_LoopField%
			IfEqual, ThisPlug,
				continue
			
			ThisPlug_TotalDBs := %ThisPlug%_TotalDBs
			Loop, %ThisPlug_TotalDBs%		;looping this plugin's 1 db at a time
			{
				ThisDBName = P_%ThisPlug%%A_Index%_DB
				ThisPlugDB := %ThisDBName%

				MatchList := LoadMatches( ThisPlugDB, Search1, cGUI_M1, hSysIL, BCtrl_Edit, AlreadyAddedObjects, 0, "")
				IfEqual, MatchList, NO NEED
				{
					CleanupGUI(cGUI_M1)
					AlreadyAddedObjects =
					Return
				}
				IfNotEqual, MatchList,
					AlreadyAddedObjects = %AlreadyAddedObjects%`n%MatchList%
				
				;check for search field change removed because its already being checked very frequently in LoadMatches()
			}
		}
	}

	chk := LV_GetCount()
	GuiControl,, %BCtrl_SBar3%, %chk%
	IfEqual, chk, 0
		CleanupGUI(cGUI_M1)

	;--------
	;debug stuff
	IfEqual, DevMode, 1
	{
		BTime := A_TickCount - ATime1
		TrayTip,, Time Taken : %BTime%ms
	}
return


Search2:
	Gui, %cGUI_M2%:Default
	GuiControlGet, Search2,, %BCtrl_Edit%
	
	Search2 := StripPadding(Search2)
	LSearch2 := StripPadding(LSearch2)
	IfEqual, Search2, %LSearch2%
		Return

	LSearch2 = %Search2%
	
	AlreadyAddedActions =
	LV_Delete()
	GetObjData(ObjLine, ObjPlug, ObjObject, ObjAction, ObjSearch, ObjIcon)
	ActionList := P_%ObjPlug%_Actions(ObjLine)
	MatchList := LoadMatches( ActionList, Search2, cGUI_M2, hSysIL, BCtrl_Edit, AlreadyAddedActions, 0, "Action")
	AlreadyAddedActions = %AlreadyAddedActions%`n%MatchList%
	WinMove, %AName% %GUI_M2%,,,,, %ExpandWH%

	chk := LV_GetCount()
	GuiControl,, %BCtrl_SBar3%, %chk%
	IfEqual, chk, 0
		CleanupGUI(cGUI_M2)
Return

WinWatch:
	IfWinActive, ahk_group M
	{
		WinGetActiveTitle, AWin
		IfEqual, AWin, %LastActWin%
			Return
		LastActWin = %AWin%
		IfWinActive, %AName% %GUI_M1%
			WinMove, %AName% %GUI_M2%,,,,, %CompressWH%
		IfWinActive, %AName% %GUI_M2%
		{
			WinMove, %AName% %GUI_M1%,,,,, %CompressWH%
			WinMove, %AName% %GUI_M2%,,,,, %ExpandWH%
		}
	}
Return


GetObjData(ByRef ObjLine, ByRef ObjPlug, ByRef ObjObject, ByRef ObjAction, ByRef ObjSearch, ByRef ObjIcon)
{
	Global cGUI_M1

	Gui, %cGUI_M1%:Default
	GuiControlGet, ObjSearch,, %BCtrl_Edit%
	SelRow := LV_GetNext(0, "Focused")
	LV_GetText(ObjLine, SelRow, 2)		;extract current result line
	LV_GetText(ObjIcon, SelRow, 4)		;extract current icon

	ObjPlug := ReadTag(ObjLine,"Plugin")		;extract current plugin
	ObjObject := ReadTag(ObjLine,"Object")		;extract current object
	ObjAction := ReadTag(ObjLine,"Action")		;extract current action
}

GetActData(ByRef ActLine, ByRef ActAction, ByRef ActPlug, ByRef ActName, ByRef ActSearch, ByRef ActIcon)
{
	Global cGUI_M2

	Gui, %cGUI_M2%:Default
	GuiControlGet, ActSearch,, M2E1
	SelRow := LV_GetNext(0, "Focused")
	LV_GetText(ActLine, SelRow, 2)		;extract current result line
	LV_GetText(ActIcon, SelRow, 4)		;extract current icon
	ActAction := ReadTag(ActLine,"Action")
	RegExMatch(ActAction,"(?<Plug>.*)\.(?<Name>.*)",Act)		;extract current Action data
}

PluginDBGet(ThisPlug,DBNum="")
{
	;If DBNum = {blank}, the function returns the total number of DBs of this plugin
	;Else if DBNum is a number, the function returns the contents of that DB
	Global
	Local Count

	Count := %ThisPlug%_TotalDBs
	
	If Count =
		Count = 0

	If DBNum =
		Return Count		;return the total number of DBs

	Return P_%ThisPlug%%DBNum%_DB
}

PluginDBPut(ThisPlug,Content="",DBNum="")
{
	;If content = REFRESH, the function clears all DBs and returns 0
	;If content is anything else, it gets put in next P_%ThisPlug%%A_Index%_DB var, and returns total number of DBs of this plugin
	
	;DBNum tells which particular DB to put the content in
	
	Global
	Local Count

	Count := %ThisPlug%_TotalDBs
	
	If Content = REFRESH
	{
		Loop, %Count%
			P_%ThisPlug%%A_Index%_DB =		;blanking each DB

		%ThisPlug%_TotalDBs = 0
	}
	Else
	{
		If DBNum =
		{
			%ThisPlug%_TotalDBs ++
			Count ++
			P_%ThisPlug%%Count%_DB = %Content%		;put the DB in P_%PlugName%%A_Index%_DB
		}
		Else
		{
			P_%ThisPlug%%DBNum%_DB = %Content%
		}
	}
	
	Return %ThisPlug%_TotalDBs		;return the total number of DBs
}

SetAction(ActionList,ObjAction="")
{
	Global cGUI_M2
	IfNotEqual, ObjAction,
	Loop, Parse, ActionList, `n, `r
	{
		IfEqual, A_LoopField,
			continue
		;if history has no action specified, set to first action
		Count ++
		IfEqual, ObjAction,
		IfEqual, Count, 1
		{
			LV_Modify(A_Index, "Focus Select")
		}

		;else set to action used last time
		IfNotEqual, ObjAction,
		IfInString, A_LoopField, %ObjAction%
		{
			LV_Modify(A_Index, "Focus Select")
		}
	}
}


UpdateCheck:
	SetTimer, UpdateCheck, 10800000		;set the checker to check every 3 hours
	FileDelete, %A_ScriptDir%\tmp\webver.txt
	URLDownloadToFile, http://www.getnode.in/files/ver.txt, %A_ScriptDir%\tmp\webver.txt
	FileRead, LatestVer, %A_ScriptDir%\tmp\webver.txt
	If LatestVer is Number
	If LatestVer > %Ver%
		Notify("NODE","Updated version available at`n" AWebsite, 0, "GC=303030 TC=FFFFFF TS=8 TF=Verdana MC=FFFFFF MF=Verdana SI=200 ST=200 SC=200 BK=White IW=16 IH=16 Image=" OwnIcon)
return


ReadDB:
	IfEqual, Hist_DB,
	IfExist, %File_hist%
		FileRead, Hist_DB, %File_hist%

	Loop, Parse, Plugs_ScanList, |
	{
		ThisPlug = %A_LoopField%
		If IsFunc("P_" ThisPlug "_Scan")
			P_%ThisPlug%_Scan()
		If IsFunc("P_" ThisPlug "_RefreshTime")
			P_%ThisPlug%_RefreshTime := P_%ThisPlug%_RefreshTime()
	}
return


ReadConfig:
	;read host settings
	IniRead, Main_C_Theme, %File_conf%, Main, Theme, Light
	IniRead, Main_C_Hotkey, %File_conf%, Main, Hotkey, ^/
	IniRead, Main_C_Startup, %File_conf%, Main, Startup, 1
Return

RefreshDB:
	MinutesRunning ++
	Loop, Parse, Plugs_ScanList, |
	{
		ThisPlug = %A_LoopField%
		If IsFunc("P_" ThisPlug "_RefreshTime")
		{
			ThisRefreshTime := P_%ThisPlug%_RefreshTime()
			chk := Round( MinutesRunning / ThisRefreshTime, 2)
			
			If chk <> 0
			If (chk = Round( MinutesRunning / ThisRefreshTime))
			If IsFunc("P_" ThisPlug "_Scan")
				P_%ThisPlug%_Scan()
		}
	}
return


ShowConf:
	Gui, %cGUI_Conf%:Default
	Gui, Show
return

ListPlugs:
	;checking if any plugins are disabled
	Loop, Parse, Plugs_NameList, |
	{
		ThisPlugName = %A_LoopField%
		IniRead, chk, %File_conf%, Main, Plugin_%ThisPlugName%_Disabled, N
		IfEqual, chk, Y
		{
			StringReplace, Plugs_NameList, Plugs_NameList, %ThisPlugName%,, A
			StringReplace, Plugs_NameList, Plugs_NameList, ||,|, A
		}
	}

	Loop, Parse, Plugs_NameList, |
	{
		ThisPlugName = %A_LoopField%
		
		If IsFunc("P_" ThisPlugName "_ConfSave")
			Plugs_ConfSaveList = %Plugs_ConfSaveList%|%ThisPlugName%
		
		If IsFunc("P_" ThisPlugName "_Scan")
			Plugs_ScanList = %Plugs_ScanList%|%ThisPlugName%
		
		If IsFunc("P_" ThisPlugName "_Actions")
			Plugs_ActionList = %Plugs_ActionList%|%ThisPlugName%

		If IsFunc("P_" ThisPlugName "_ConfGUI")
			Plugs_ConfGUIList = %Plugs_ConfGUIList%|%ThisPlugName%

		If IsFunc("P_" ThisPlugName "_Tags2Search")
			Plugs_TagsList = %Plugs_TagsList%|%ThisPlugName%

		If IsFunc("P_" ThisPlugName "_SearchAnalyze")
			Plugs_SearchAnalyzeList = %Plugs_SearchAnalyzeList%|%ThisPlugName%
		
		If IsFunc("P_" ThisPlugName "_OnExit")
			Plugs_OnExitList = %Plugs_OnExitList%|%ThisPlugName%
	}
	
	StringTrimLeft, Plugs_ConfSaveList, Plugs_ConfSaveList, 1
	StringTrimLeft, Plugs_ScanList, Plugs_ScanList, 1
	StringTrimLeft, Plugs_ActionList, Plugs_ActionList, 1
	StringTrimLeft, Plugs_ConfGUIList, Plugs_ConfGUIList, 1
	StringTrimLeft, Plugs_TagsList, Plugs_TagsList, 1
	StringTrimLeft, Plugs_SearchAnalyzeList, Plugs_SearchAnalyzeList, 1
	StringTrimLeft, Plugs_OnExitList, Plugs_OnExitList, 1
Return


M1B1:
M2B1:
	Critical
	WinGetActiveTitle, AWin
	
	GetObjData(ObjLine, ObjPlug, ObjObject, ObjAction, ObjSearch, ObjIcon)
	IfEqual, ObjObject,
		Return
	IfEqual, AWin, %AName% %GUI_M1%
	{
		AbandonSearch = Y
		Gui, %cGUI_M2%:Default
		LV_Delete()
		ActionList := P_%ObjPlug%_Actions(ObjLine)
		LoadMatches( ActionList, Search2, cGUI_M2, hSysIL, BCtrl_Edit, AlreadyAddedActions, 0, "Action")
		SetAction(ActionList, ObjAction)
	}
	GetActData(ActLine, ActAction, ActPlug, ActName, ActSearch, ActIcon)

	;clear and hide guis only after gathering needed data
	tObjPlug = %ObjPlug%
	tObjLine = %ObjLine%
	tActAction = %ActAction%
	tSearch1 = %Search1%

	Gui, %cGUI_M2%:Default
	GuiControl,, %BCtrl_Edit%,

	Gui, Submit
	Gui, %cGUI_M1%:Default
	GuiControl,, %BCtrl_Edit%,
	Gui, Submit
	WinActivate, ahk_id %LastActiveWinH%

	If IsFunc("P_" tObjPlug "_Execute")
		P_%tObjPlug%_Execute(tObjLine, tActAction, tSearch1)

	LSearch1 = SAFsadfasdfAFS		;this is to be kept after launch to include the last addition of history when next time Node is called
return


LoadMatches( DB, SrchStrng, GUID, ILID, EditField, ByRef AlreadyAddedList, BaseScore = 0, IconsFrom="")
{
	Global AName,AnlChar,DevMode,BCtrl_LV,BCtrl_SBar3,BCtrl_IBar1,hOwnIcon,Ptr
	
	;quick check to see if this DB should be searched into
	IfNotEqual, SrchStrng,
	IfNotInString, SrchStrng, %A_Space%
	IfNotInString, SrchStrng, %AnlChar%
	IfNotInString, DB, %SrchStrng%
		Return	

	;another quick check
	IfNotEqual, SrchStrng,
	IfInString, SrchStrng, %A_Space%
	IfNotInString, SrchStrng, %AnlChar%
	{
		ValidDB = N
		Loop, Parse, SrchStrng, %A_Space%
		{
			IfInString, DB, %A_LoopField%
			{
				ValidDB = Y
				Break
			}
		}
		IfEqual, ValidDB, N
			Return
	}

	Gui, %GUID%:Default
	GuiControl,, %BCtrl_SBar3%, Working..
	Gui, ListView, %BCtrl_LV%
	
	;go through the DB one line at a time
	Loop, Parse, DB, `n, `r
	{
		IfEqual, A_LoopField,
			continue						;skip blanks
		ThisDBLine = %A_LoopField%
		IfInString, ThisDBLine, <Scan1=>		;skip blanks
			continue

		IfEqual, ScanTags,		;extract the tag names that have to be searched (only once)
		{
			Loop
			{
				IfNotInString, ThisDBLine, <Scan%A_Index%=
					Break
				Else
					ScanTags = %ScanTags%|Scan%A_Index%
			}
			StringTrimLeft, ScanTags, ScanTags, 1
		}

		;do proper search only if SrchStrng aren't blank
		;its blank when adding history
		IfNotEqual, SrchStrng,
		{
			LineScore = %BaseScore%
			
			;quick check to rule out non-matches
			IfNotInString, SrchStrng, %A_Space%
			IfNotInString, ThisDBLine, %SrchStrng%
				Continue
			
			;stripping last time's SrchStrng, and check for duplicates
			ThisDBLineChk := RegExReplace(ThisDBLine, "iU)\<SrchStrng=.*\>")
			ThisDBLineChk := RegExReplace(ThisDBLineChk, "iU)\<Action=.*\>")
			IfInString, AlreadyAddedList, %ThisDBLineChk%
				continue
			IfInString, MatchList_All, %ThisDBLineChk%
				continue

			;extract the tags that have to be searched
			;Scan1 will contain the items from Scan1 tag that will be searched extensively and scored
			;For remaining Scan tags, only the existence of search fields is checked
			ScanOthers =
			Scan1 =
			Loop, Parse, ScanTags, |, %A_Space%
			{
				IfEqual, A_Index, 1
				{
					Scan1 := ReadTag(ThisDBLine,A_LoopField)
				}
				Else
				{
					OScan := ReadTag(ThisDBLine,A_LoopField)
					IfNotEqual, OScan,
						ScanOthers = %ScanOthers%`n%OScan%
				}
			}

			;look for the searched keywords in first and remaining Scan tags, if found add to matchlist
			chk_Scan1 = Y
			chk_match = N
			Loop, Parse, SrchStrng, %A_Space%
			{
				IfNotInString, Scan1, %A_LoopField%
				{
					chk_Scan1 = N
					break
				}				
			}
			
			IfEqual, chk_Scan1, N		;if found in Scan1, no need to check others
			IfNotEqual, ScanOthers,
			{
				chk_ScanOthers = Y
				Loop, Parse, SrchStrng, %A_Space%
				{
					IfNotInString, ScanOthers, %A_LoopField%
					{
						chk_ScanOthers = N
						break
					}				
				}
			}
			
			;whether a match is found in Scan1 or other Scan tags, add this line
			IfEqual, chk_Scan1, Y
				chk_Match = Y
			IfEqual, chk_ScanOthers, Y
				chk_Match = Y
			IfEqual, chk_match, Y
			{
				OSrchStrng := ReadTag(ThisDBLine,"SrchStrng")	;extracting searchstring from history item
				OPlug := ReadTag(ThisDBLine, "Plugin")	;extracting plugin to ask keywords for scoring
				PlusWords =
				MinusWords =
				If IsFunc("P_" OPlug "_KeyWords")
					P_%OPlug%_KeyWords(PlusWords, MinusWords, ThisDBLine, LineScore)
				IfEqual, chk_Scan1, Y
					ThisScore := Score(Scan1, SrchStrng, OSrchStrng, LineScore, PlusWords, MinusWords)
				else
					ThisScore = 0
			}
		}

		;add this line if either SearchString is blank, or a match has occurred
		AddLine = N
		IfEqual, SrchStrng,
			AddLine = Y
		IfNotEqual, SrchStrng,
		IfEqual, chk_match, Y
			AddLine = Y

		IfEqual, AddLine, Y
		{
			;getting icon and other details from object plugin
			IfEqual, IconsFrom,
			{
				OPlug := ReadTag(ThisDBLine,"Plugin")
				IconIdx=
				P_%OPlug%_ToShow(Search1, ThisDBLine, LVLine, MainTxt, SubTxt, IconIdx, InfoBar)
				LV_Add("Icon" IconIdx, LVLine, ThisDBLine, ThisScore, IconIdx)
			}
			;getting icon and other details from Action details
			IfEqual, IconsFrom, Action
			{
				OAction := ReadTag(ThisDBLine,"Action")
				RegExMatch(OAction,"\.(?<ActionName>.*)",O)
				IconFile := ReadTag(ThisDBLine,"Icon")
				IfEqual, IconFile,
				{
					IfExist, %A_ScriptDir%\Res\Icons\Actions\%OAction%.ico
						IconFile = %A_ScriptDir%\Res\Icons\Actions\%OAction%.ico
					else
					{
						RegExMatch(OAction,"isU)^(?<Name>.*)\.",P)
						IconFile = %A_ScriptDir%\Res\Icons\Actions\%PName%.ico
					}
				}
				IconIdx := GetIcon(IconFile)
				LV_Add("Icon" IconIdx, OActionName, ThisDBLine, ThisScore, IconIdx)
			}
			MatchList_All = %MatchList_All%`n%ThisDBLine%
		}
		
		Sleep, -1		;clear any pending interruptions
		GuiControlGet, chk, , %EditField%
		chk := StripPadding(chk)
		IfNotEqual, chk, %SrchStrng%
		{
			GuiControl,, %BCtrl_SBar3%,
			MatchList_All =
			return "NO NEED"	;search string changed
		}
	}
	StringTrimLeft, MatchList_All, MatchList_All, 1
	
	IfNotEqual, SrchStrng,
		LV_ModifyCol(3, "SortDesc")		;don't sort when adding items from history
	
	IfWinActive, ahk_group M		;to ensure GUI doesn't become active when not in front
		LV_Modify(1, "Focus Select")
	else
		LV_Modify(1, "Select")

	GuiControl,, %BCtrl_SBar3%,
	return MatchList_All
}


Score(Match, SrchStrng, PrevSrchStrng, BaseScore = 0, PlusWords="", MinusWords="")
{
	Global SplChar,File_conf
	Static RunOnce,ForTopObject,ForFirstWord,ForSecondWord,ForThirdWord,ForMinusWords,ForPlusWords,ForSameSrchStrng,ForSimilarSrchStrng,ForMatchPhrase
	ThisScore = %BaseScore%
	
	IfEqual, RunOnce,
	{
		RunOnce = 1
		ForTopObject = 10
		ForFirstWord = 5
		ForSecondWord = 4
		ForThirdWord = 3
		ForMinusWords = -5
		ForPlusWords = 5
		ForSameSrchStrng = 6
		ForSimilarSrchStrng = 5
		ForMatchPhrase = 5		;the whole phrase matches

		;reading/writing scoring parameters
		IniRead, ForTopObject, %File_conf%, Main, ForTopObject, %ForTopObject%
		IniWrite, %ForTopObject%, %File_conf%, Main, ForTopObject

		IniRead, ForFirstWord, %File_conf%, Main, ForFirstWord, %ForFirstWord%
		IniWrite, %ForFirstWord%, %File_conf%, Main, ForFirstWord
		
		IniRead, ForSecondWord, %File_conf%, Main, ForSecondWord, %ForSecondWord%
		IniWrite, %ForSecondWord%, %File_conf%, Main, ForSecondWord
		
		IniRead, ForThirdWord, %File_conf%, Main, ForThirdWord, %ForThirdWord%
		IniWrite, %ForThirdWord%, %File_conf%, Main, ForThirdWord

		IniRead, ForMinusWords, %File_conf%, Main, ForMinusWords, %ForMinusWords%
		IniWrite, %ForMinusWords%, %File_conf%, Main, ForMinusWords

		IniRead, ForPlusWords, %File_conf%, Main, ForPlusWords, %ForPlusWords%
		IniWrite, %ForPlusWords%, %File_conf%, Main, ForPlusWords

		IniRead, ForSameSrchStrng, %File_conf%, Main, ForSameSrchStrng, %ForSameSrchStrng%
		IniWrite, %ForSameSrchStrng%, %File_conf%, Main, ForSameSrchStrng

		IniRead, ForSimilarSrchStrng, %File_conf%, Main, ForSimilarSrchStrng, %ForSimilarSrchStrng%
		IniWrite, %ForSimilarSrchStrng%, %File_conf%, Main, ForSimilarSrchStrng

		IniRead, ForMatchPhrase, %File_conf%, Main, ForMatchPhrase, %ForMatchPhrase%
		IniWrite, %ForMatchPhrase%, %File_conf%, Main, ForMatchPhrase
	}

	;adding score if the match is a top level object
	StringLen, SrchLen, SrchStrng
	StringLeft, chk, SrchStrng, 1
	If chk in %SplChar%
	{
		StringReplace, chk2, match, `n,, A
		StringReplace, chk2, chk2, `r,, A
		StringLeft, chk2, chk2, %SrchLen%
		IfEqual, SrchStrng, %chk2%
			ThisScore += %ForTopObject%
	}

	;add score for same searchstring as last time
	IfNotEqual, PrevSrchStrng,
	{
		IfEqual, PrevSrchStrng, %SrchStrng%
			ThisScore += %ForSameSrchStrng%	;extra marks for full match
		else
		{
			StringLeft, chk2, PrevSrchStrng, %SrchLen%
			IfEqual, chk2, %SrchStrng%
				ThisScore += %ForSimilarSrchStrng%		;partial match of last time's keywords
		}
	}


	StringLeft, chk, ThisField, %SrchLen%
	IfEqual, chk, %SrchStrng%
		ThisScore += %ForMatchPhrase%
	
	;this would in effect double the added score if matchphrase contains a space and still searchstring matches exactly
	IfInString, chk, %A_Space%
		ThisScore += %ForMatchPhrase%
	
	Loop, Parse, Match, %A_Space%.
	{
		ThisWord = %A_LoopField%
		ThisCount = %A_Index%
	
		If ThisWord In %PlusWords%
			ThisScore += %ForPlusWords%
		
		If ThisWord In %MinusWords%
		If SrchStrng not In %MinusWords%
			ThisScore += %ForMinusWords%

		Loop, Parse, SrchStrng, %A_Space%
		{
			ThisSrchWord = %A_LoopField%
			
			StringLen, chk, ThisSrchWord
			StringLeft, chk2, ThisWord, %chk%
			
			IfEqual, chk2, %ThisSrchWord%
			{
				If ThisCount = 1
					ThisScore += %ForFirstWord%
				else if ThisCount = 2
					ThisScore += %ForSecondWord%
				else if ThisCount = 3
				{
					ThisScore += %ForThirdWord%
					break
				}
			}
		}
	}
	Return ThisScore
}


MakeBlock( ID, Title, RunSection, SelSection, ByRef IL_ID, BColor, C1Color, C2Color, PosXY, ShowLV = "Y", LogoVis = "", GuiVis = "", CtrlBorders = "")
{
	Global CompressWH,ExpandWH,BCtrl_Logo,BCtrl_Icon,BCtrl_Edit,BCtrl_MText,BCtrl_SText,BCtrl_LV,BCtrl_IBar1,BCtrl_SBar1,BCtrl_SBar2,BCtrl_SBar3,isL
	
	BCtrl_Logo = Static1
	BCtrl_Icon = Static2
	BCtrl_Edit = Edit1
	BCtrl_MText = Static3
	BCtrl_SText = Static4
	BCtrl_LV = SysListView321
	BCtrl_IBar1 = Static5
	BCtrl_SBar1 = Static6
	BCtrl_SBar2 = Static7
	BCtrl_SBar3 = Static8
	
	SysGet, sbw, 2 ; SM_CXVSCROLL
	GW = 325
	LVW := GW + sbw + 10
	
	new := isL ? "New" : "Destroy"
	Gui, %ID%:%new%
	Gui, %ID%:Default
	Gui, -Caption +ToolWindow +Border +AlwaysOnTop
	IfEqual, CtrlBorders, Y
		AddlOptns = %AddlOptns% +Border
	FileInstall, Res\icons\node.ico, %A_ScriptDir%\Res\icons\node.ico
	FileInstall, Res\images\node_applogo.png, %A_ScriptDir%\Res\images\node_applogo.png
	Gui, Add, Picture, x265 y30 +0x4000000 %LogoVis% %AddlOptns% gMoveIt, %A_ScriptDir%\Res\images\node_applogo.png		;static1 = Logo (0x4000000 is WS_CLIPSIBLINGS - to use as background for other controls)
	Gui, Add, Picture, x15 y25 w32 h32 +0x3 %AddlOptns% gMoveIt, 	;static2 = icon
	Gui, Add, Button, Hidden Default g%RunSection%, Run		;hidden button
	Gui, Add, ListView, x-2 y80 h205 w%LVW% -Hdr AltSubmit -Multi -0x200000 +0x40 g%SelSection%, Name|Line|Score|Icon		;SysListView321
	GuiControl, +BackgroundFFFFFF, SysListView321	; they say a ListView that has a custom background color set, refreshes more often
	LV_ModifyCol(3, "Integer")	; For sorting purposes, indicate that column 3 is an integer.
	; Attach the System ImageList to the ListView so that it can later display the icons
	LV_SetImageList(IL_ID, 1)	;1 for large icons, 0 for small
	LV_ModifyCol(1, GW-sbw*(LV_GetCount()>6))
	LV_ModifyCol(2, "0")
	LV_ModifyCol(3, "0")
	LV_ModifyCol(4, "0")

	Gui, Color, %BColor%, %C1Color%
	Gui, Font, C%C1Color% S9, Verdana
	Gui, Add, Text, x60 y10 w205 h50 +Center BackgroundTrans %AddlOptns%,		;static name 1
	Gui, Font, C%C2Color% S7, Verdana
	Gui, Add, Text, x265 y10 w60 h20 +Center BackgroundTrans %AddlOptns%,	;static name 2
	
	Gui, Font, C%C2Color% S7, Verdana
	Gui, Add, Text, x0 y285 h12 w%GW% BackgroundTrans %AddlOptns%,		;static infobar
	Gui, Font, C%C1Color% S7, Verdana
	Gui, Add, Text, x0 y+2 h12 w125 BackgroundTrans %AddlOptns%,		;static statusbar 1
	Gui, Font, C%C2Color% S7, Verdana
	Gui, Add, Text, x+0 h12 w100 BackgroundTrans %AddlOptns%,		;static statusbar 2
	Gui, Add, Text, x+0 h12 w100 +Right BackgroundTrans %AddlOptns%,		;static statusbar 3
	Gui, Font, C%C1Color% S8 Underline, Verdana
	Gui, Color, , %BColor%
	Gui, Add, Edit, x60 y60 w205 h20 +Center -E0x200 -0x200000 g%EditSection% %AddlOptns%,	;edit field

	IfEqual, ShowLV, Y
		WinH = %ExpandWH%
	else
		WinH = %CompressWH%
	Gui, Show, w%GW% h%WinH% %PosXY% %GuiVis%, %Title%
}

GetIcon(File="", h="0")
{
	Static
	if !init	; one-time switch to initialize COM and locally-defined types for AHK Basic
		{
		AW := A_IsUnicode ? "W" : "A"
		Ptr := A_IsUnicode ? "Ptr" : "UInt"
		init := !DllCall("ole32\CoInitialize", "UInt", 0)	; SHGetFileInfo() requires prior COM init in AHK Basic
		SHGFI_SYSICONINDEX := 0x4000
		SHGFI_ICON := 0x100
		SHGFI_USEFILEATTRIBUTES := 0x10
		_SHFILEINFOsz := VarSetCapacity(_SHFILEINFO, 352+340*(A_IsUnicode=TRUE)+4*(A_PtrSize=8), 0)
		addr := (A_PtrSize ? A_PtrSize : "4")
		}
	if !File && init
		return DllCall("ole32\CoUninitialize")
	if !hIconList
		return hIconList := DllCall("Shell32\SHGetFileInfo" AW
				 , "Str", File
				 , "UInt", 0x80
				 , Ptr, &_SHFILEINFO
				 , "UInt", _SHFILEINFOsz
				 , "UInt", 0x4010+h, Ptr)

	DllCall("shell32\SHGetFileInfo" AW
			 , "Str", File
			 , "UInt", 0x80
			 , Ptr, &_SHFILEINFO
			 , "UInt", _SHFILEINFOsz
			 , "UInt", (h>"1" ? 0x100+h-2 : 0x4000+h))	; h=0 large icon, h=1 small icon, h=2=large handle, h=3 small handle
if h > 1
	return NumGet(_SHFILEINFO, 0, Ptr)			; return handle to icon (has overlay)
else
	return 1+NumGet(_SHFILEINFO, addr, "UInt")	; ImageList index is zero-based so we need to bump it up one notch
}

MakeGUI_Conf:
	new := isL ? "New" : "Destroy"
	Gui, %cGUI_Conf%:%new%
	Gui, %cGUI_Conf%:Default
	Gui, Add, Button, x640 y470 w100 h30 gConfSave, Save
	Gui, Add, Button, x530 y470 w100 h30 gConfCancel, Cancel
	Gui, Add, Tab2, x5 y5 w750 h450 , Main|%Plugs_ConfGUIList%

	Gui, Add, GroupBox, x10 y35 w740 h260 , 
	Gui, Add, Text, x30 y65 w50 h20 , Theme
	Gui, Add, DropDownList, x80 y60 w100 vMain_C_Theme, Light|Dark
	Gui, Add, Text, x30 y110 w50 h20 , Hotkey
	Gui, Add, Hotkey, x80 y105 w100 h20 vMain_C_Hotkey, %Main_C_Hotkey%
	Gui, Add, Text, x30 y155 w120 h20 , Start Automatically
	Gui, Add, Checkbox, x165 y155 w20 h20 Checked%Main_C_Startup% vMain_C_Startup,

	GuiControl, ChooseString, Main_C_Theme, %Main_C_Theme%
	;host's settings loaded, now to add plugins' settings below
	
	Gui, Show, w760 h510 Hide, %AName% %GUI_Conf%
	;load configuration sections
	Loop, Parse, Plugs_NameList, |
	{
		If IsFunc("P_" A_LoopField "_ConfGUI")
			P_%A_LoopField%_ConfGUI(cGUI_Conf)
	}
Return

MoveIt:
	PostMessage, 0xA1,2,,, A
return

MakeTrayMenu:
	Menu, Tray, Tip, %AName%
	Menu, Tray, Add, %AName%, ShowHK
	Menu, Tray, Default, %AName%
	Menu, Tray, Add, Configuration, ShowConf
	Menu, Tray, Add, Restart, ReloadApp
	Menu, Tray, Add, About, ShowAbout
	Menu, Tray, Add,
	Menu, Tray, Add, Quit
Return

ReloadApp:
	Reload
Return

MakeFolders:
	IfNotExist, %A_ScriptDir%\tmp
		FileCreateDir, %A_ScriptDir%\tmp
	IfNotExist, %A_ScriptDir%\db
		FileCreateDir, %A_ScriptDir%\db
	IfNotExist, %A_ScriptDir%\res
		FileCreateDir, %A_ScriptDir%\res
Return


ConfCancel:
	Gui, %cGUI_Conf%:+LastFound
	Gui, Hide
return


ConfSave:
	Gui, %cGUI_Conf%:+LastFound
	Gui, Submit, NoHide
	;save host settings
	IfEqual, Main_C_Theme,
		Main_C_Theme = Light
	IfEqual, Main_C_Hotkey,
		Main_C_Hotkey = %DefaultHotkey%
	IniWrite, %Main_C_Theme%, %File_conf%, Main, Theme
	IniWrite, %Main_C_Hotkey%, %File_conf%, Main, Hotkey
	IniWrite, %Main_C_Startup%, %File_conf%, Main, Startup
	IniWrite, %Ver%, %File_conf%, Main, Version
	Loop, Parse, Plugs_ConfGUIList, |
	{
		If IsFunc("P_" A_LoopField "_ConfSave")
			P_%A_LoopField%_ConfSave(cGUI_Conf)
	}
	
	Msgbox, 36, %AName% - Restart?, New configuration will take effect after restart.`nRestart now?
	IfMsgBox, Yes
		Reload
return


Quit:
	Loop, Parse, Plugs_OnExitList, |
	{
		If IsFunc("P_" A_LoopField "_OnExit")
			P_%A_LoopField%_OnExit()
	}
	FileDelete, %File_hist%
	Gosub, SaveHistory
	DllCall("DeleteIcon", Ptr, hOwnIcon)	; We need to clean this up
	DllCall("DeleteIcon", Ptr, hActIcon)		; One of these handles was already deleted
	DllCall("DeleteIcon", Ptr, hObjIcon)	; but we don't know which one so better safe than sorry
ExitApp


SaveHistory:
	Loop, Parse, Hist_DB, `n, `r
	{
		FileAppend, %A_LoopField%`r`n, %File_hist%
		IfEqual, A_Index, %MaxHistorySize%
			break
	}
Return

StripPadding(Text)
{
	AutoTrim, On
	Text = %Text%
	Return Text
}

ReadTag(Data, Tag)
{
	Regex = iU)\<%Tag%=(?<Value>.*)\>
	RegExMatch(Data,Regex,O)
	Return OValue
}


ShowAbout:
	Gui, %cGUI_About%:Default
	Gui, Destroy
	Gui,  -Caption +Border

	IfExist, Res\images\node_logo 250x83.png
		FileInstall, Res\images\node_logo 250x83.png, %A_ScriptDir%\Res\images\node_logo 250x83.png, 1
	Gui, Add, Picture, x0 y100, %A_ScriptDir%\Res\images\node_logo 250x83.png
	
	Gui, color, FFFFFF

	Gui, Font, S8 CDefault, Verdana
	Gui, Add, Text, BackgroundTrans x0 y255 w250 h100 +Center gLaunchHomepage, Version : %Ver%`n`n%AWebsite%`n%AWebsite%/forum
	Gui, Add, Button, BackgroundTrans x75 y355 w100 h30 gAboutOK, OK
	Gui, Show, h400 w250, About %AName%
Return

LaunchHomepage:
	Run, %A_Website%,, UseErrorLevel
Return

AboutOK:
	Gui, Submit
Return

FormatHK(HK)
{
	HK2 = %HK%
	StringReplace, HK2, HK2, +, Shift +%A_Space%
	StringReplace, HK2, HK2, ^, Ctrl +%A_Space%
	StringReplace, HK2, HK2, #, Win+%A_Space%
	StringReplace, HK2, HK2, !, Alt+%A_Space%

	Return HK2
}


ShowHK:
	Critical
	IfWinActive, ahk_group M
	{
		Gosub, Esc
		return
	}
	WinGet, LastActiveWinH, ID, A
	Gui, %cGUI_M1%:Default
	i = P_Window_ToShow         ; put the function name in a generic variable
	if IsFunc(i)               ; check for function existance
	{
		%i%("", "",  i, i, i, IconIdx, i)   ; call the function dynamically and grab the refreshed icon index
		Loop, % LV_GetCount()      ; search for the /Window line through the list
		{
			LV_GetText(i, A_Index)
			if i = /Window         ; when we find it, refresh the icon in the list
			{
				LV_Modify(A_Index, "Icon" IconIdx)
				break
			}
		}
	}
	WinMove, %AName% %GUI_M1%,,,,, %CompressWH%
	GuiControl, Focus, %BCtrl_Edit%
	PostMessage, 0xB1, 0, -1, %BCtrl_Edit%, %AName% %GUI_M1% ;EM_SETSEL to select all text from last time
	;GuiControl,, %BCtrl_Edit%, ;removing this is necessary to preserve un-launched text from last time
	GuiControl, -Hidden, %BCtrl_Logo%

	LV_Modify(1, "Focus Select")
	Gui, Show
	GuiControl, Focus, %BCtrl_Edit%
return

#IfWinActive, ahk_group M
Tab::
+Tab::
	IfWinActive, %AName% %GUI_M1%
	{
		Gui, %cGUI_M1%:Default
		GuiControl, +Hidden, %BCtrl_Logo%

		Gui, %cGUI_M2%:Default
		LV_Delete()
		GetObjData(ObjLine, ObjPlug, ObjObject, ObjAction, ObjSearch, ObjIcon)
		
		ActionList := P_%ObjPlug%_Actions(ObjLine)
		LoadMatches( ActionList, Search2, cGUI_M2, hSysIL, BCtrl_Edit, AlreadyAddedActions, 0, "Action")
		SetAction(ActionList, ObjAction)
		
		Loop, Parse, Plugs_ObjectAnalyzeList, |		;loading object analyze actions
		{
			ThisPlug = %A_LoopField%
			IfEqual, ThisPlug,
				continue

			If IsFunc("P_" ThisPlug "_ObjectAnalyze")
				ResActionList := P_%ThisPlug%_ObjectAnalyze(ObjLine)
			IfNotEqual, ResActionList,
				LoadMatches( ResActionList, Search2, cGUI_M2, hSysIL, BCtrl_Edit, AlreadyAddedActions, 0, "Action")
		}
		
		GuiControl, -Hidden, %BCtrl_Logo%
		GuiControl, Focus, %BCtrl_Edit%
		Gui, Show
	}
	Else
	{
		Gui, %cGUI_M2%:Default
		GuiControl, +Hidden, %BCtrl_Logo%

		Gui, %cGUI_M1%:Default
		GuiControl, -Hidden, %BCtrl_Logo%
		GuiControl, Focus, %BCtrl_Edit%
		Gui, Show
	}
Return

^Del::
	IfWinActive, %AName% %GUI_M1%
	{
		Gui, %cGUI_M1%:Default
		GuiControlGet, chk, , %BCtrl_Edit%
		IfEqual, chk,
		{
			SelRow := LV_GetNext(0, "Focused")
			LV_GetText(ThisLine, SelRow, 2)		;extract current result line
			StringReplace, Hist_DB, Hist_DB, %ThisLine%`r`n,, A
			LSearch1 = sfdasdfaFSAD
		}			
	}
return

Down::
Up::
PgUp::
PgDn::
	Critical
	IfEqual, LastHKTime,
		LastHKTime = 0

	HKInterval := A_TickCount - LastHKTime
	IfLess, HKInterval, 100
		Return
	LastHKTime = %A_TickCount%	
	
	WinGetActiveTitle, AWin
	WinMove, %AWin%,,,,, %ExpandWH%
	ThisHotkey = %A_ThisHotkey%
	ControlSend, %BCtrl_LV%, {%ThisHotkey%}, %AWin%
return

Esc::
	Gui, %cGUI_M1%:Default
	;GuiControl,, %BCtrl_Edit%,
	Gui, Submit
	Gui, %cGUI_M2%:Default
	GuiControl,, %BCtrl_Edit%,
	Gui, Submit
	;WinActivate, ahk_id %LastActiveWinH%
Return

~F12::
	IfEqual, DevMode, 1
	{
		WinGetActiveTitle, AWin
		StringReplace, AWin, AWin, %AName%%A_Space%,
		Loop, Parse, guiNames, |
			if (%A_LoopField%=AWin)
				g := c%A_LoopField%
		Gui, %g%:Default
		GuiControl, +Report +Hdr, %BCtrl_LV%
		LV_ModifyCol()
	}
Return


#F12::
	ListVars
Return

#IfWinActive

#Include %A_ScriptDir%\plugins\p_Files.ahk
#Include %A_ScriptDir%\plugins\p_Clipboard.ahk
#Include %A_ScriptDir%\plugins\p_Calculator.ahk
#Include %A_ScriptDir%\plugins\p_Internal.ahk
#Include %A_ScriptDir%\plugins\p_ControlP.ahk
#Include %A_ScriptDir%\plugins\p_Comics.ahk
#Include %A_ScriptDir%\plugins\p_CommandP.ahk
#Include %A_ScriptDir%\plugins\p_Screen.ahk
#Include %A_ScriptDir%\plugins\p_Window.ahk
#Include %A_ScriptDir%\plugins\p_DateTime.ahk
#Include %A_ScriptDir%\includes\f_Notify.ahk
