ExitApp

;scan to create a database (if applicable for this plugin)
P_Files_Scan()
{
	Static	; declare everything as Static to avoid loading the library everytime, plus other string redefinitions
	Global File_conf,M,OwnIcon
	RegExMatch(A_ThisFunc, "U)_(?<PlugName>.*)_", O)	;get the name of this plugin
	
	if !hFFF_Callback
	{
		AW := A_IsUnicode ? "W" : "A"									; short switch for use in DllCall() ANSI/Unicode function names
		Ptr := A_IsUnicode ? "Ptr" : "UInt"									; declare Ptr type for older AHK versions
		AStr := A_IsUnicode ? "AStr" : "Str"								; declare ANSI String type for older AHK versions
		DefaultFolders = %A_ScriptDir%\alias|%A_Desktop%|%A_StartMenu%
		|%A_MyDocuments%|%A_DesktopCommon%|%A_StartMenuCommon%	; this is a static list, we only need to declare it once
		;it is important to keep the alias folder at the beginning to ensure the aliases work correctly
		DefaultAliasFolders = Aliases|Desktop|Start menu|My Documents|Common Desktop|Common Start menu	; also a static list
		DefaultTypes = exe|lnk|xls|doc|ppt|pdf|docx|xlsx|pptx|mp3|wma|ogg	; another static list
		P_Files_Int_Storage("1", DefaultFolders, "|", TRUE)					; store a split pseudo-array in a static function
		P_Files_Int_Storage("2", DefaultTypes, "|", TRUE)					; same as above, although we only need the count
		P_Files_Int_Storage("DefFold", DefaultFolders, "*", TRUE)				; store the full paths string in a static function
		P_Files_Int_Storage("DefAlias", DefaultAliasFolders, "*", TRUE)			; store the full aliases string in a static function
		P_Files_Int_Storage("DefType", DefaultTypes, "*", TRUE)				; store the full extensions string in a static function
		P_Files_Int_Storage("FFFl", hFFF_Lib, "|", TRUE)						; store library address pointer
		P_Files_Int_Storage("FFFh", hFFF, "|", TRUE)						; store search procedure address pointer
		P_Files_Int_Storage("FFFc", hFFF_Callback, "|", TRUE)				; store callback address pointer
	}
	
	TotalDBs := PluginDBGet(OPlugName)
	IfEqual, TotalDBs, 0		;0 means this is the first call to the function, and NODE is loading
	IfExist, %A_ScriptDir%\db\%OPlugName%*.ndb
	{
		PluginDBPut(OPlugName,"REFRESH")		;this command resets the counter of DBs for this plugin
		Loop
		{
			IfNotExist, %A_ScriptDir%\db\%OPlugName%%A_Index%.ndb
				Break
			FileRead, ThisDBData, %A_ScriptDir%\db\%OPlugName%%A_Index%.ndb
			PluginDBPut(OPlugName,ThisDBData)
		}
		
		SetTimer, NextRun, -60000		;do the next scan after a while
		Return
	}
	else
		Notify("NODE","The first scan can take`na few extra seconds.", 4, "GC=303030 TC=FFFFFF TS=8 TF=Verdana MC=FFFFFF MF=Verdana SI=200 ST=200 SC=200 BK=White IW=16 IH=16 Image=" OwnIcon)
	
	NextRun:
	
	AutoTrim, On

	IfNotExist, %A_ScriptDir%\alias
		FileCreateDir, %A_ScriptDir%\alias
	
	IniRead, FolderList, %File_conf%, %OPlugName%, FolderList, %A_Space%		;crude check to see if config file has values
	IfEqual, FolderList,
	{
		FolderList = %DefaultAliasFolders%
		IniWrite, %DefaultAliasFolders%, %File_conf%, %OPlugName%, FolderList
		IniWrite, %DefaultTypes%, %File_conf%, %OPlugName%, TypeList
		IniWrite, totalcmd.exe||/O /T /L=, %File_conf%, %OPlugName%, FMSyntax2
		IniWrite, explorer.exe||/select`, , %File_conf%, %OPlugName%, FMSyntax1
	}

	StringRight, i, FolderList, 1
	if (i="|")
		FolderList := DefaultAliasFolders "|" FolderList
	FolderList := RegExReplace(FolderList, "sU)(^\||\|$)")	; trim pipe from either end of the string
	StringReplace, FolderList, FolderList, `",, A
	StringReplace, FolderList, FolderList, `,, |, A
	StringReplace, FolderList, FolderList, ||,|, A
	FolderList = %FolderList%				; trimming spaces
	FolderList = |%FolderList%|				; adding extra |, will be removed later
	Loop, Parse, DefaultAliasFolders, |			; here we parse the alias names and replace the FolderList matches with the real paths 
		if InStr(FolderList, "|" A_LoopField "|")	; retrieved from the static array 1 that we just created above
			StringReplace, FolderList, FolderList, |%A_LoopField%|, % "|" P_Files_Int_Storage("1", A_Index) "|"
	StringTrimLeft, FolderList, FolderList, 1		;removing extra |
	StringTrimRight, FolderList, FolderList, 1		;removing extra |

	IniRead, TypeList, %File_conf%, %OPlugName%, TypeList, %A_Space%
	StringRight, i, TypeList, 1
	if (i="|")
		TypeList := DefaultTypes "|" TypeList
	TypeList := RegExReplace(TypeList, "sU)(^\||\|$)")	; trim pipe from either end of the string
	StringReplace, TypeList, TypeList, %A_Space%,, A
	StringReplace, TypeList, TypeList, *,, A
	StringReplace, TypeList, TypeList, .,, A
	StringReplace, TypeList, TypeList, ||,|, A
	TypeList = %TypeList%					; trimming spaces (why not use a single RegEx to trim all unwanted whitespace?!)

	if !A_IsCompiled
	{
		tick := A_TickCount
		Tooltip, NODE Database refresh initiated	; for testing purposes we show a tooltip to see how long it takes creating the DBs
	}

	PluginDBPut(OPlugName,"REFRESH")		;this command resets the counter of DBs for this plugin
	IfExist, %A_ScriptDir%\res\bin\FileFilter.exe
	{
		FileDelete, %A_ScriptDir%\db\Files*.ndb
		RunWait, %A_ScriptDir%\res\bin\FileFilter.exe "%FolderList%" "%TypeList%" "%A_ScriptDir%\db"
	}
	else
		MsgBox, 48, NODE Error, Resource file not found.`n(%A_ScriptDir%\res\bin\FileFilter.exe)

	Loop, %A_ScriptDir%\db\Files*.ndb
	{
		FileRead, NewFileData, %A_LoopFileFullPath%
		PluginDBPut(OPlugName,NewFileData)		;add a new DB for this plugin
	}
	if !A_IsCompiled
	{
		off := A_FormatFloat							; get original float format
		SetFormat, FloatFast, 0.2
		t := (A_TickCount-tick)/1000						; calculate the time taken for DB update
		SetFormat, FloatFast, %off%					; restore original float format
		Tooltip, NODE Database refresh finished in %t% sec.	; display DB update time
		SetTimer, P_Files_ttoff, -3500					; dismiss tooltip after 3.5 seconds
	}
	return

	P_Files_ttoff:
		Tooltip		; dismiss tooltip
	return
}

;this function provides the time in minutes after which the DB will automatically refresh
P_Files_RefreshTime()
{
	Global File_conf
	RegExMatch(A_ThisFunc, "U)_(?<PlugName>.*)_", O)
	IniRead, P_Files_C_RefreshTime, %File_conf%, %OPlugName%, RefreshTime, 30
	Return P_Files_C_RefreshTime
}

;add plugin specific settings to own tab in settings
P_Files_ConfGUI(GUI_ID)
{
	Static
	Global File_conf,P_Files_C_FolderList,P_Files_C_TypeList,P_Files_C_RefreshTime,P_Files_C_Editor,P_Files_C_FileManager
	,P_Files_C_LastPath,P_Files_C_LastExt,P_Files_C_Add1,P_Files_C_Edit1,P_Files_C_Remove1,P_Files_C_Add2
	,P_Files_C_Edit2,P_Files_C_Remove2,P_Files_C_Filter1,P_Files_C_Filter2
	RegExMatch(A_ThisFunc, "U)_(?<PlugName>.*)_", O)
	
	Gui, %GUI_ID%:Default
	Gui, Tab, %OPlugName%,, Exact
	Loop
	{
		IniRead, i, %File_conf%, %OPlugName%, FMSyntax%A_Index%, %A_Space%	; read file manager-specific syntax from config
		if !i
			break
		StringSplit, i, i, |				; structure: filename.extension|version|additional syntax
		P_Files_Int_FMSyntax(i1, i2, i3)	; add file manager-specific syntax to static database for later use
		i1 := i2 := i3 := ""				; blank all vars to avoid inheritance
	}
	if !P_Files_Int_FMSyntax("explorer.exe")				; if config misses the syntax, 
	{
		P_Files_Int_FMSyntax("explorer.exe", "", "/select, ")	; we add it here to the static database and write it to config
	}
	if !P_Files_Int_FMSyntax("totalcmd.exe")				; same for all other file managers we know
	{
		P_Files_Int_FMSyntax("totalcmd.exe", "", "/O /T /L=")	; /O-open existing session /T-open new tab /L=-in left panel (/R= for right panel)
	}
	IniRead, P_Files_C_RefreshTime, %File_conf%, %OPlugName%, RefreshTime, 30				; read database refresh time
	IniRead, SelectedFolders, %File_conf%, %OPlugName%, FolderList, %A_Space%				; read the selected paths list
	IniRead, P_Files_C_UserFolderList, %File_conf%, %OPlugName%, UserFolderList, %A_Space%	; read complete user paths list
	IniRead, SelectedTypes, %File_conf%, %OPlugName%, TypeList, %A_Space%				; read the selected extensions list
	IniRead, P_Files_C_UserTypeList, %File_conf%, %OPlugName%, UserTypeList, %A_Space%		; read complete user extensions list
	IniRead, P_Files_C_Editor, %File_conf%, %OPlugName%, Editor, %A_Windir%\Notepad.exe				; read text editor path
	IniRead, P_Files_C_FileManager, %File_conf%, %OPlugName%, FileManager, %A_Windir%\explorer.exe	; read file manager path
	P_Files_Int_Storage("Editor", P_Files_C_Editor, "|", TRUE)						; store current text editor path to static database
	P_Files_Int_Storage("FileManager", P_Files_C_FileManager, "|", TRUE)			; store current file manager to static database
	DefaultFolders := P_Files_Int_Storage("DefFold", 1)
	DefaultAliasFolders := P_Files_Int_Storage("DefAlias", 1)
	DefaultTypes := P_Files_Int_Storage("DefType", 1)
	P_Files_C_DefFolderCount := P_Files_Int_Storage("1")	; get count of default folders from the static database
	P_Files_C_DefTypeCount := P_Files_Int_Storage("2")		; get count of default extensions from the static database
	P_Files_C_Cue1 := "<type or browse for a path to add to the list>"	; cue text for the path Edit
	P_Files_C_Cue2 := "<extension>"								; cue text for the extension Edit
	Menu, P_Files_SelectionMenu, Add, Select :, P_Files_ContextMenu
	Menu, P_Files_SelectionMenu, Disable, Select :
	Menu, P_Files_SelectionMenu, Add, All, P_Files_All
	Menu, P_Files_SelectionMenu, Add, None, P_Files_None
	Menu, P_Files_SelectionMenu, Add, Default, P_Files_Default
	Menu, P_Files_SelectionMenu, Add, User, P_Files_User
	Gui, +LabelP_Files_
	Gui, +LastFound
	Gui, Add, Text, x16 y45 w322 h375 0x8 BackgroundTrans, 
	Gui, Add, Text, x350 yp w137 h375 0x8 BackgroundTrans, 
	Gui, Add, GroupBox, x12 y28 w330 h418 +Center, Folder paths
	Gui, Add, ListBox, x17 y46 w320 h373 +0x109 -E0x200 gP_Files_ShowPath vP_Files_C_FolderList, %DefaultAliasFolders%|%P_Files_C_UserFolderList%
	Gui, Add, Edit, x16 y423 w232 h20 -Multi gP_Files_Buttons vP_Files_C_LastPath hwndhEF1,
	SendMessage, 0x1501, 0, &P_Files_C_Cue1,, ahk_id %hEF1%	; you can't argue this is not elegant ;-)
	Gui, Add, Button, x+2 yp w25 h20 gP_Files_BrowsePath, ...
	Gui, Add, Button, x+1 yp w20 hp gP_Files_Add vP_Files_C_Add1, +
	Gui, Add, Button, x+1 yp wp hp Disabled gP_Files_Edit vP_Files_C_Edit1, *
	Gui, Add, Button, x+1 yp wp hp Disabled gP_Files_Remove vP_Files_C_Remove1, -
	Gui, Add, GroupBox, x346 y28 w145 h418 +Center, File extensions
	Gui, Add, ListBox, x351 y46 w135 h373 +0x109 -E0x200 gP_Files_ShowExt vP_Files_C_TypeList, %DefaultTypes%|%P_Files_C_UserTypeList%
	Gui, Add, Edit, x350 y423 w73 h20 -Multi gP_Files_Buttons vP_Files_C_LastExt hwndhEF2,
	SendMessage, 0x1501, 0, &P_Files_C_Cue2,, ahk_id %hEF2%	; EM_SETCUEBANNER (requires ComCtl v6)
	Gui, Add, Button, x+2 yp w20 h20 gP_Files_Add vP_Files_C_Add2, +
	Gui, Add, Button, x+1 yp wp hp Disabled gP_Files_Edit vP_Files_C_Edit2, *
	Gui, Add, Button, x+1 yp wp hp Disabled gP_Files_Remove vP_Files_C_Remove2, -
	Gui, Add, GroupBox, x495 y28 w250 h118 +Center, Miscellaneous
	Gui, Add, Text, x500 y45 w75 h20 +0x200 +Right, Refresh every
	Gui, Add, Edit, x+1 yp w45 h20 -Multi, %P_Files_C_RefreshTime%
	Gui, Add, UpDown, x+0 yp w13 h20 Range1-360 vP_Files_C_RefreshTime, %P_Files_C_RefreshTime%
	Gui, Add, Text, x+1 yp w68 h20 +0x200, minutes
	Gui, Add, Text, x500 y67 w240 h16 +0x200 +Center, Preferred text editor:
	Gui, Add, Edit, xp y+0 w214 h20 -Multi vP_Files_C_Editor, %P_Files_C_Editor%
	Gui, Add, Button, x+1 yp w25 hp gP_Files_BrowseEditor, ...
	Gui, Add, Text, x500 y+2 w240 h16 +0x200 +Center, Preferred file manager:
	Gui, Add, Edit, xp y+0 w214 h20 -Multi +0x80 vP_Files_C_FileManager, %P_Files_C_FileManager%
	Gui, Add, Button, x+1 yp w25 hp gP_Files_BrowseFileManager, ...
	Gui, Add, GroupBox, x495 y+5 w250 h152 +Center, Help
	Gui, Add, Text, x500 yp+18 w240 h104, 
	( LTrim
	- The upper part of each list contains paths and extensions that may be scanned by default.
	They can be enabled or disabled but not deleted.
	- Only selected items will be scanned for.

	- Do not add relative path ( ..\path or .\path )
	- Do not append backslash to path ( C:\path\ )
	- Do not prepend period to extension ( .txt )
	- Do not use wildcards ( * or ? )
	)
	;Gui, Add, Picture, x495 y308 w250 h-1, resources\node_logo 250x83.jpg
	;Gui, Add, Text, x495 y308 w250 h83 0x200 Center Border, YOUR LOGO HERE
	Gui, Font, s7 w400, Tahoma
	Gui, Add, Text, xp y+5 wp h50 Disabled Center, %OPlugName% plug-in`n(c) Rajat 2012`n`ndesign by Drugwash
	; Generated using SmartGuiXP Creator mod 4.3.29.1
	hwndP_Files := WinExist()									; get the window handle, we'll need it for the ListBox operations
	if !SelectedFolders											; if we have a fresh config, select all items in the path list
		Loop, % LB_GetCount("ListBox1", hwndP_Files)
			LB_Select(A_Index, "ListBox1", hwndP_Files)
	else Loop, Parse, SelectedFolders, |							; otherwise only select the items read from the config
		LB_Select(A_LoopField, "ListBox1", hwndP_Files)
	if !SelectedTypes											; if we have a fresh config, select all items in the extension list
		Loop, % LB_GetCount("ListBox2", hwndP_Files)
			LB_Select(A_Index, "ListBox2", hwndP_Files)
	else Loop, Parse, SelectedTypes, |								; otherwise only select the items read from the config
		LB_Select(A_LoopField, "ListBox2", hwndP_Files)
	if !P_Files_C_Filter1
		P_Files_C_Filter1 := "[/*?""""<>|,`t]*"						; initialize path string filter for use in RegExReplace()
	if !P_Files_C_Filter2
		P_Files_C_Filter2 := "[/:*?""""<>\|.,`t]*"					; initialize extension string filter for use in RegExReplace()
	Return

	P_Files_ContextMenu:
		if A_GuiControl in P_Files_C_FolderList,P_Files_C_TypeList		; if user right-clicked in a ListBox,
			{
			i := InStr(A_GuiControl, "FolderList") ? 1 : 2				; get that ListBox' index (1=path list, 2=extension list)
			Menu, P_Files_SelectionMenu,  % (LB_GetCount("ListBox" i, hwndP_Files) > (i=1
			? P_Files_C_DefFolderCount : P_Files_C_DefTypeCount) ? "Enable" : "Disable"), User
			Menu, P_Files_SelectionMenu, Show	; enable/disable user menu when there's no user path/extension defined, then show menu
			}
	return

	P_Files_All:
		LB_SelectAll("ListBox" i, hwndP_Files)	; select all items in ListBox corresponding to index i
	return

	P_Files_None:
		LB_DeselectAll("ListBox" i, hwndP_Files)	; deselect all items in corresponding ListBox
	return

	P_Files_Default:
		LB_DeselectAll("ListBox" i, hwndP_Files)	; deselect all, then select only the default range of paths/extensions
		LB_SelectRange("1-" (i=1 ? P_Files_C_DefFolderCount : P_Files_C_DefTypeCount), "ListBox" i, hwndP_Files)
	return

	P_Files_User:
		LB_DeselectAll("ListBox" i, hwndP_Files)	; deselect all, then select only the user-added range of paths/extensions
		LB_SelectRange((i=1 ? P_Files_C_DefFolderCount
		: P_Files_C_DefTypeCount)+1 "-" LB_GetCount("ListBox" i, hwndP_Files), "ListBox" i, hwndP_Files)
	return

	P_Files_BrowsePath:
		FileSelectFolder, i, *%P_Files_C_LastPath%, 6, Select the path...
		if (!i OR ErrorLevel)
			return
		GuiControl,, P_Files_C_LastPath, %i%	; select folder path to be added to searchable list (need to push the '+' button too)
	return

	P_Files_BrowseEditor:
		FileSelectFile, i, 3, %P_Files_C_Editor%, Select the preferred editor:, executable (*.exe)
		if (!i OR ErrorLevel)
			return
		GuiControl,, P_Files_C_Editor, %i%								; select path to a custom text editor
		Gui, Submit, NoHide
		P_Files_Int_Storage("Editor", P_Files_C_Editor, "|", TRUE)				; store selected text editor path to static database
	return

	P_Files_BrowseFileManager:
		FileSelectFile, i, 3, %P_Files_C_FileManager%, Select the preferred file manager:, executable (*.exe)
		if (!i OR ErrorLevel)
			return
		GuiControl,, P_Files_C_FileManager, %i%							; select path to a custom file manager
		Gui, Submit, NoHide
		P_Files_Int_Storage("FileManager", P_Files_C_FileManager, "|", TRUE)	; store selected file manager path to static database
	; here we should select FileManagerSyntax from a internal database according to selected File Manager
	; if we're planning ahead to avoid problems, we should also read version info and pass it to the DB,
	; since it IS possible that syntax changes from one version to another (although unlikely, but still possible)
	; FMver := GetVersionInfo(FileManager)
	FileManagerSyntax := P_Files_Int_FMSyntax(FileManager, FMver)			; Retrieve additional syntax for selected file manager
	return

	P_Files_ShowPath:
		i := LB_GetCaret("ListBox1", hwndP_Files)				; Get currently focused row in the path ListBox
		P_Files_C_LastPath := i > P_Files_C_DefFolderCount ? LB_GetText(i, "ListBox1", hwndP_Files) : P_Files_Int_Storage(1, i)
		GuiControl,, P_Files_C_LastPath, %P_Files_C_LastPath%	; If user path focused, copy it, otherwise retrieve real path for alias,
	return												; then send the string for display in the path Edit field

	P_Files_ShowExt:
		P_Files_C_LastExt := LB_GetCaretText("ListBox2", hwndP_Files)	; Here we directly get the focused row text as we have no aliases
		GuiControl,, P_Files_C_LastExt, %P_Files_C_LastExt%		; then send the string for display in the extension Edit field
	return

	P_Files_Buttons:
		k := A_GuiControl	; K will represent the variable name of the Edit field that's being worked with and indirectly, its contents
		i := InStr(k, "Path") ? 1 : 2						; Get the ListBox index the Edit corresponds to
		Gui, Submit, NoHide
		j := RegExReplace(%k%, P_Files_C_Filter%i%, "")	; Filter the contents of the Edit field (P_Files_C_LastPath or P_Files_C_LastExt)
		if (j <> %k%)					; If filtered contents differs from original, update the Edit field's contents
			{
			GuiControl,, %k%, %j%	; (if we don't do the above check, it'd update indefinitely due to the g-label)
			SendMessage, 0xB1, 0, -1, Edit%i%, A		; either I am too stupid, or Microsoft are!
			SendMessage, 0xB1, -1, 0, Edit%i%, A		; is it really possible there's no Msg to set caret position in a Edit control ?!?
			}
	P_Files_Buttons2:
		Gui, Submit, NoHide
		if !j
			return
		if LB_MatchText(RegExReplace(%k%, "\\$", ""), "ListBox" i, hwndP_Files) OR InStr(DefaultFolders "|", RegExReplace(%k%, "\\$", "") "|")										; If filtered path exists in list (user-path) or is identical to one of the default paths,
			{
			GuiControl, Disable, P_Files_C_Add%i%		; disable the 'add' button (we don't need duplicates)
			if (LB_GetCaret("ListBox" i, hwndP_Files) > (i=1 ? P_Files_C_DefFolderCount : P_Files_C_DefTypeCount))
				{									; If one of the user-added paths/extensions is focused,
				GuiControl, Disable, P_Files_C_Edit%i%	; disable the 'edit' button (nothing to edit, paths are identical)
				GuiControl, Enable, P_Files_C_Remove%i%	; enable the 'remove' button (user-added items can be removed at will)
				}
			else GuiControl, Disable, P_Files_C_Remove%i%	; Otherwise disable the 'remove' button (can't remove default items)
			}
		else											; If filtered path does not exist in the list,
			{
			GuiControl, Enable, P_Files_C_Add%i%			; enable the 'add' button (we can safely add the item)
			if (LB_GetCaret("ListBox" i, hwndP_Files) > (i=1 ? P_Files_C_DefFolderCount : P_Files_C_DefTypeCount))
				GuiControl, Enable, P_Files_C_Edit%i%		; enable the 'edit' button (or we can update the currently focused one if edited)
			GuiControl, Disable, P_Files_C_Remove%i%		; disable the 'remove' button (can't remove what we haven't yet added)
			}
	return

	P_Files_Add:
		if !%k%
			return
		StringRight, i, A_GuiControl, 1			; Get the working ListBox index from button var (P_Files_C_Add1 or P_Files_C_Add2)
		%k% := RegExReplace(%k%, "\\$", "")	; Strip any trailing backslash from the Edit field's string
		j := LB_Add((i="1" ? P_Files_C_LastPath : P_Files_C_LastExt), "ListBox" i, hwndP_Files)	; add string to ListBox, get row nmb in 'j'
		LB_Select(j, "ListBox" i, hwndP_Files)		; select newly added row automatically
		LB_SetCaret(j, "ListBox" i, hwndP_Files)		; set focus to newly added row
		k := (i="1" ? "P_Files_C_LastPath" : "P_Files_C_LastExt")	; get Edit's var name in 'k' (and indirectly its contents for subsequent check in P_Files_Buttons2)
		ControlFocus, ListBox%i%, ahk_id %hwndP_Files%	; focus corresponding ListBox for easier further navigation
	goto P_Files_Buttons2						; update the state of corresponding 'add' 'edit' 'remove' buttons

	P_Files_Edit:
		StringRight, i, A_GuiControl, 1			; Get the working ListBox index from button var (P_Files_C_Edit1 or P_Files_C_Edit2)
		txt := RegExReplace(%k%, "\\$", "")		; Strip any trailing backslash from the Edit field's string
		j := LB_GetCaret("ListBox" i, hwndP_Files)	; Get focused row
		s := LB_IsSelected(j, "ListBox" i, hwndP_Files)	; Get selection state of the focused row
		LB_Replace(txt, j, "ListBox" i, hwndP_Files)	; Replace text in focused row with the string in the Edit field
		if s
			LB_Select(j, "ListBox" i, hwndP_Files)	; Restore selected status of the edited row
		LB_SetCaret(j, "ListBox" i, hwndP_Files)		; Restore focus to the edited row
		k := (i="1" ? "P_Files_C_LastPath" : "P_Files_C_LastExt")	; get Edit's var name in 'k' (for subsequent check in P_Files_Buttons2)
		ControlFocus, ListBox%i%, ahk_id %hwndP_Files%	; focus corresponding ListBox for easier further navigation
	goto P_Files_Buttons2						; update the state of corresponding 'add' 'edit' 'remove' buttons

	P_Files_Remove:
		StringRight, i, A_GuiControl, 1	; Get the working ListBox index from button var (P_Files_C_Remove1 or P_Files_C_Remove2)
		%k% := RegExReplace(%k%, "\\$", "")	; Strip any trailing backslash from the Edit field's string
		j := LB_Remove((i="1" ? P_Files_C_LastPath : P_Files_C_LastExt), "ListBox" i, hwndP_Files)	; remove row from ListBox
		LB_SetCaret(j, "ListBox" i, hwndP_Files)		; Set focus to previous row (returned above in 'j')
		k := (i="1" ? "P_Files_C_LastPath" : "P_Files_C_LastExt")	; get Edit's var name in 'k' (for subsequent check in P_Files_Buttons2)
		%k% := LB_GetCaretText("ListBox" i, hwndP_Files)	; Get the text from currently focused row
		GuiControl,, %k%, % %k%						; and send it to the Edit field
		ControlFocus, ListBox%i%, ahk_id %hwndP_Files%	; focus corresponding ListBox for easier further navigation
	goto P_Files_Buttons2						; update the state of corresponding 'add' 'edit' 'remove' buttons
}

P_Files_ConfInfo(ByRef Author, ByRef Info)
{
	Author = Drugwash
	Info = Original basic plugin by Rajat, hugely developed and improved further by Drugwash.
}



;this function will autorun when the configuration Save button is pressed
P_Files_ConfSave()
{
	Global File_Conf,P_Files_C_FolderList,P_Files_C_TypeList,P_Files_C_RefreshTime ,hwndP_Files
	RegExMatch(A_ThisFunc, "U)_(?<PlugName>.*)_", O)

	Gui, Submit, NoHide
	StringReplace, P_Files_C_FolderList, P_Files_C_FolderList, `n, |, A
	StringReplace, P_Files_C_FolderList, P_Files_C_FolderList, ||,|, A
	StringReplace, P_Files_C_FolderList, P_Files_C_FolderList, `",, A
	StringReplace, P_Files_C_TypeList, P_Files_C_TypeList, `n, |, A
	StringReplace, P_Files_C_TypeList, P_Files_C_TypeList, ||, |, A

	P_Files_C_UserFolderList := ""										; blank the var as we don't want accumulated paths
	P_Files_C_UserTypeList := ""											; blank the var as we don't want accumulated extensions
	i := P_Files_Int_Storage(1)											; get default path count from static storage
	Loop, % LB_GetCount("ListBox1", hwndP_Files) - i						; Loop through user-added paths only
		P_Files_C_UserFolderList .= LB_GetText(i+A_Index, "ListBox1", hwndP_Files) "|"	; build FULL user path list
	i := P_Files_Int_Storage(2)											; get default extension count from static storage
	Loop, % LB_GetCount("ListBox2", hwndP_Files) - i						; Loop through user-added types only
		P_Files_C_UserTypeList .= LB_GetText(i+A_Index, "ListBox2", hwndP_Files) "|"		; build FULL user extension list
	StringTrimRight, P_Files_C_UserFolderList, P_Files_C_UserFolderList, 1		; see, I'm stripping trailing pipe !
	StringTrimRight, P_Files_C_UserTypeList, P_Files_C_UserTypeList, 1			; see, I'm stripping trailing pipe here too !
	IniWrite, %P_Files_C_FolderList%, %File_conf%, %OPlugName%, FolderList	; this should contain only SELECTED paths (both default and user-added)
	IniWrite, %P_Files_C_UserFolderList%, %File_conf%, %OPlugName%, UserFolderList	; this contains ALL user-added paths
	IniWrite, %P_Files_C_TypeList%, %File_conf%, %OPlugName%, TypeList	; this should contain only SELECTED ext. (both default and user-added)
	IniWrite, %P_Files_C_UserTypeList%, %File_conf%, %OPlugName%, UserTypeList	; this contains ALL user-added extensions
	IniWrite, %P_Files_C_RefreshTime%, %File_conf%, %OPlugName%, RefreshTime
	IniWrite, % P_Files_Int_Storage("Editor", 1), %File_conf%, %OPlugName%, Editor
	IniWrite, % P_Files_Int_Storage("FileManager", 1), %File_conf%, %OPlugName%, FileManager
}


P_Files_KeyWords(ByRef PlusWords, ByRef MinusWords, ByRef ThisDBLine, ByRef LineScore)
{
	;This function is so that the plugin can directly affect the internal algorithm of scoring the results
	;if the match contains a Plus Word, it is scored up and down for Minus Word.
	MinusWords = uninstall,help,readme,read me,setup
	PlusWords = google,bing,wikipedia,firefox,chrome,internet explorer,opera,word,excel,exe,lnk,thunderbird
	
	IfInString, ThisDBLine, %A_ScriptDir%\Alias\
		LineScore += 5
}

;The result from database is provided to this function and this function returns
;how the results are to be shown in GUI as main and sub text and icon
P_Files_ToShow(SrchStrng, Result, ByRef LVLine, ByRef MainTxt, ByRef SubTxt, ByRef IconIdx, ByRef InfoBar)
{
	RegExMatch(Result,"iU)\<Path=(?<File>.*)\>",O)

	SplitPath, OFile,, InfoBar, SubTxt, MainTxt	;simply providing the name and ext
	IconIdx := GetIcon(OFile)
	;hide ext of .exe and .lnk just to make it look better
	If SubTxt in exe,lnk
		SubTxt =

	LVLine = %MainTxt%
}


P_Files_Objects()
{
	;this function simply returns the pipe separated list of Objects it supports 
	;only in rare cases a plugin would support more than one object
	Objects = File
	Return Objects
}

P_Files_Actions(Line)
{
	RegExMatch(A_ThisFunc, "U)_(?<PlugName>.*)_", O)

	ActionList =
	(LTrim Join`r`n
		<Action=%OPlugName%.Open><Scan1=Open>
		<Action=%OPlugName%.Explore><Scan1=Explore>
		<Action=%OPlugName%.Edit Text><Scan1=Edit Text>
		<Action=%OPlugName%.Delete><Scan1=Delete>
		<Action=%OPlugName%.Create Alias><Scan1=Create Alias>
	)

	Return ActionList
}

P_Files_Execute(Line, Action, SrchStrng)
{
	Global Hist_DB,File_Conf,P_Files_Int_Callback,OwnIcon
	Ptr := A_IsUnicode ? "Ptr" : "UInt"
	RegExMatch(A_ThisFunc, "U)_(?<PlugName>.*)_", O)
	UpdateHistory = Y		;by default history will be updated with this Action


	RegExMatch(Line,"iU)\<Path=(?<File>.*)\>",O)
	IfEqual, Action, %OPlugName%.Open
	{
		Run, %OFile%,, UseErrorLevel
	}

	IfEqual, Action, %OPlugName%.Explore
	{
		SplitPath, OFile,,, FExt
		IfEqual, FExt, lnk
			FileGetShortcut, %OFile%, OFile
		
		FileManager := P_Files_Int_Storage("FileManager", 1)
		; FMver := GetVersionInfo(FileManager)
		FMSyntax := P_Files_Int_FMSyntax(FileManager, FMver)
		IfEqual, FileManager,
		{
			FileManager = %A_Windir%\explorer.exe
			FMSyntax = /select`,%A_Space%
			P_Files_Int_Storage("FileManager", FileManager "|" FMSyntax, "|", TRUE)
			IniWrite, %FileManager%, %File_conf%, %OPlugName%, FileManager
		}
		Run, %FileManager% %FMSyntax%"%OFile%",, UseErrorLevel
	}

	IfEqual, Action, %OPlugName%.Edit Text
	{
		SplitPath, OFile,,, FExt
		IfEqual, FExt, lnk
			FileGetShortcut, %OFile%, OFile
		
;		IniRead, Editor, %File_conf%, %OPlugName%, Editor, %A_Space%	; redundant since we read the 'Editor' value from storage right below
		Editor := P_Files_Int_Storage("Editor", 1)
;		EditorSyntax := P_Files_Int_Storage("Editor", 2)	; we may add this one day so let it be a reminder
		IfEqual, Editor,
		{
			Editor = %A_Windir%\Notepad.exe
			P_Files_Int_Storage("Editor", Editor, "|", TRUE)
			IniWrite, %Editor%, %File_conf%, %OPlugName%, Editor
		}
		Run, %Editor% %EditorSyntax% "%OFile%",, UseErrorLevel
	}

	IfEqual, Action, %OPlugName%.Delete
	{
		SplitPath, OFile,,, FExt
		IfEqual, FExt, lnk
			FileGetShortcut, %OFile%, OFile
		
		MsgBox, 20, CONFIRM DELETION, This action will send "%OFile%" to Recycle Bin.`n`nPlease confirm.
		IfMsgBox, Yes
			FileRecycle, %OFile%
		
		UpdateHistory = N		;there's no point updating history with delete command (if file deleted, the command can't be repeated)
	}

	IfEqual, Action, %OPlugName%.Create Alias
	{
		InputBox, AliasName, Enter Alias, Enter a custom name for this shortcut`neg. 'Ffx' for Mozilla Firefox, , 220, 150,,,, Verdana
		IfEqual, Errorlevel, 1
			Return
		IfEqual, AliasName,
			Return
		
		FileCreateShortcut, %OFile%, %A_ScriptDir%\alias\%AliasName%.lnk
		IfEqual, Errorlevel, 0
		{
			RunWait, %A_ScriptDir%\res\bin\FileFilter.exe "%A_ScriptDir%\alias" "lnk" "%A_ScriptDir%\db"
			FileRead, DBContent, %A_ScriptDir%\db\Files1.ndb
			StringTrimRight, DBContent, DBContent, 1		; remove trailing NewLine
			PluginDBPut(OPlugName,DBContent,1)
			
			Notify("NODE","Alias created", 2, "GC=303030 TC=FFFFFF TS=8 TF=Verdana MC=FFFFFF MF=Verdana SI=200 ST=200 SC=200 BK=White IW=16 IH=16 Image=" OwnIcon)
		}

		UpdateHistory = N		;this is a one time action
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

P_Files_Int_Callback(p, n, e, s, a)
{
	Static
	;Critical
	if !hPMD
		{
		Ptr := A_IsUnicode ? "Ptr" : "UInt"	; NOTE: Don't put Ptr or AStr in quotes below, or it'll break AHK Basic !
		AStr := A_IsUnicode ? "AStr" : "Str"
		hPMD := DllCall("GetProcAddress", Ptr, DllCall("GetModuleHandle" AW, "Str", "kernel32"), AStr, "MulDiv")
		RegExMatch(A_ThisFunc, "U)_(?<PlugName>.*)_", O)	;get the name of this plugin
		}
	if (!p && n)	; command switch (FALSE TRUE) to return the stored data
		return data
	else if (!p && !n)	; command switch (FALSE FALSE) to clear the static data buffer
		return (data := "")
	;ODir := DllCall(hPMD, Ptr, p, "Int", 1, "Int", 1, "Str")
	;OName := DllCall(hPMD, Ptr, n, "Int", 1, "Int", 1, "Str")
	;sName := DllCall(hPMD, Ptr, s, "Int", 1, "Int", 1, "Str")	; this is file short name (8.3), currently not used
	;fExt := DllCall(hPMD, Ptr, e, "Int", 1, "Int", 1, "Str")	; this is file extension, currently not used
	;fAttr := DllCall(hPMD, Ptr, a, "Int", 1, "Int", 1, "Str")	; this is file attributes, currently not used
	data .= "<Object=File><Plugin=" OPlugName "><Scan1=" OName "><Scan2=" ODir "><Path=" ODir "\" OName ">`n"
}

P_Files_Int_Storage(idx, strg=0, sep="", sw="")
{
	Static
	if sw
	{
		StringSplit, a%idx%_, strg, %sep%
		return a%idx%_0
	}
	return a%idx%_%strg%
}

P_Files_Int_FMSyntax(fpath, fver="", sw="")
{	; we currently don't fully process version string but we'll have to strip/replace periods and other offending chars before using it
	Static
	StringReplace, fver, fver, `., _, All
	SplitPath, fpath,,,, fname			; get filename without extension to avoid var name error when building internal variables
	if sw
		d_%fname%_%fver% := sw		; if anything was passed to 'sw', store as syntax string
	else return d_%fname%_%fver%		; otherwise return stored data (the syntax string previously stored)
}

P_Files_OnExit()
{
	Global
	;DllCall("FreeLibrary", Ptr, P_Files_Int_Storage("FFFl"))	; get search library handle from storage and free the library
	GetIcon()	; uninitialize COM

	;~ RegExMatch(A_ThisFunc, "U)_(?<PlugName>.*)_", O)

	;~ ;saving the current cache as DB files
	;~ TotalDBs := PluginDBGet(OPlugName)
	;~ FileDelete, %A_ScriptDir%\db\%OPlugName%*.ndb
	;~ Loop, %TotalDBs%
	;~ {
		;~ ThisDBData := PluginDBGet(OPlugName,A_Index)
		;~ FileAppend, %ThisDBData%, %A_ScriptDir%\db\%OPlugName%%A_Index%.ndb
	;~ }
}

#include %A_ScriptDir%\includes\f_ListBoxPlus.ahk
