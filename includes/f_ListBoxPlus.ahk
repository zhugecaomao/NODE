; ListBox collection of functions © Drugwash 2012.05.28
;===========================================
LB_Select(pos, ctrl, wnd="A")
{
LB_IntFixPos(pos, ctrl, wnd)
; LB_SETSEL
SendMessage, 0x185, TRUE, %pos%, %ctrl%, %wnd%
}

LB_Deselect(pos, ctrl, wnd="A")
{
LB_IntFixPos(pos, ctrl, wnd)
; LB_SETSEL
SendMessage, 0x185, FALSE, %pos%, %ctrl%, %wnd%
}
;===========================================
LB_SelectAll(ctrl, wnd="A")
{
LB_IntFixParam(ctrl, wnd)
; LB_SETSEL
SendMessage, 0x185, TRUE, -1, %ctrl%, %wnd%
}

LB_DeselectAll(ctrl, wnd="A")
{
LB_IntFixParam(ctrl, wnd)
; LB_SETSEL
SendMessage, 0x185, FALSE, -1, %ctrl%, %wnd%
}
;===========================================
LB_SelectRange(range, ctrl, wnd="A")
{
return LB_IntSelectRange(TRUE, range, ctrl, wnd)
}

LB_DeselectRange(range, ctrl, wnd="A")
{
return LB_IntSelectRange(FALSE, range, ctrl, wnd)
}
;===========================================
LB_GetCount(ctrl, wnd="A")
{
LB_IntFixParam(ctrl, wnd)
; LB_GETCOUNT
SendMessage, 0x18B,,, %ctrl%, %wnd%
return ErrorLevel
}
;===========================================
LB_GetCaret(ctrl, wnd="A")
{
LB_IntFixParam(ctrl, wnd)
;LB_GETCARETINDEX
SendMessage, 0x19F,,, %ctrl%, %wnd%
return 1+ErrorLevel
}

LB_SetCaret(pos, ctrl, wnd="A")
{
LB_IntFixPos(pos, ctrl, wnd)
;LB_SETCARETINDEX
SendMessage, 0x19E, pos, FALSE, %ctrl%, %wnd%
}
;===========================================
LB_GetText(pos, ctrl, wnd="A")
{
LB_IntFixPos(pos, ctrl, wnd)
; LB_GETTEXTLEN
SendMessage, 0x18A, %pos%,, %ctrl%, %wnd%
VarSetCapacity(buf, (ErrorLevel+1)*(2**(A_IsUnicode=TRUE)), 0)
; LB_GETTEXT
SendMessage, 0x189, %pos%, &buf, %ctrl%, %wnd%
VarSetCapacity(buf, -1)
return buf
}
;===========================================
LB_GetCaretText(ctrl, wnd="A")
{
LB_IntFixParam(ctrl, wnd)
;LB_GETCARETINDEX
SendMessage, 0x19F,,, %ctrl%, %wnd%
pos := ErrorLevel
; LB_GETTEXTLEN
SendMessage, 0x18A, %pos%,, %ctrl%, %wnd%
VarSetCapacity(buf, (ErrorLevel+1)*(2**(A_IsUnicode=TRUE)), 0)
; LB_GETTEXT
SendMessage, 0x189, %pos%, &buf, %ctrl%, %wnd%
VarSetCapacity(buf, -1)
return buf
}
;===========================================
LB_MatchText(txt, ctrl, wnd="A")
{
LB_IntFixParam(ctrl, wnd)
; LB_FINDSTRINGEXACT
SendMessage, 0x1A2, -1, &txt, %ctrl%, %wnd%
return 1+( ErrorLevel > 0x7FFFFFFF ? -1 : ErrorLevel)
}
;===========================================
LB_Add(txt, ctrl, wnd="A")
{
LB_IntFixParam(ctrl, wnd)
; LB_ADDSTRING
SendMessage, 0x180,, &txt, %ctrl%, %wnd%
return 1+ErrorLevel
}

LB_Insert(txt, pos, ctrl, wnd="A")
{
LB_IntFixPos(pos, ctrl, wnd)
; LB_INSERTSTRING
SendMessage, 0x181, %pos%, &txt, %ctrl%, %wnd%
return 1+ErrorLevel
}

LB_Replace(txt, pos, ctrl, wnd="A")
{
LB_IntFixPos(pos, ctrl, wnd)
; LB_DELETESTRING
SendMessage, 0x182, %pos%,, %ctrl%, %wnd%
; LB_INSERTSTRING
SendMessage, 0x181, %pos%, &txt, %ctrl%, %wnd%
return 1+ErrorLevel
}

LB_Remove(pos, ctrl, wnd="A")
{
LB_IntFixPos(pos, ctrl, wnd)
; LB_DELETESTRING
SendMessage, 0x182, %pos%,, %ctrl%, %wnd%
return ErrorLevel
}
;===========================================
LB_IsSelected(pos, ctrl, wnd="A")
{
LB_IntFixPos(pos, ctrl, wnd)
; LB_GETSEL
SendMessage, 0x187, %pos%,, %ctrl%, %wnd%
return ErrorLevel
}
;###########################################
;	INTERNAL FUNCTIONS
;###########################################
LB_IntSelectRange(sw, range, ctrl, wnd)
{
LB_IntFixParam(ctrl, wnd)
StringSplit, r, range, -
r1--
r2--
if (r0 < 2 OR r1 < 0 OR r2 < 0)
	return -1
if (r2<r1)
	r := r2, r2 := r1, r1 := r
r := r1 + (r2 << 16)
; LB_SELITEMRANGE
SendMessage, 0x19B, (sw ? TRUE : FALSE), %r%, %ctrl%, %wnd%
return ErrorLevel > 0x7FFFFFFF ? -(~ErrorLevel) - 1 : ErrorLevel
}
;===========================================
LB_IntFixParam(ByRef ctrl, ByRef wnd)
{
if ctrl is integer
	{
	wnd := "ahk_id " ctrl
	ctrl := ""
	}
else if wnd is integer
	wnd := "ahk_id " wnd
}
;===========================================
LB_IntFixPos(ByRef pos, ByRef ctrl, ByRef wnd)
{
LB_IntFixParam(ctrl, wnd)	; do it here to avoid a subsequent call from the calling function
if pos is integer
	return --pos
; LB_FINDSTRINGEXACT
SendMessage, 0x1A2, -1, &pos, %ctrl%, %wnd%
pos := ErrorLevel > 0x7FFFFFFF ? -(~ErrorLevel) - 1 : ErrorLevel
}
