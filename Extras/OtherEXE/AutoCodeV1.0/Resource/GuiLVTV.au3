Global $_lv_ghLastWnd
Global $Debug_LV = False
Global $iLListViewSortInfoSize = 11
Global $aListViewSortInfo[1][$iLListViewSortInfoSize]
;**********************
Global Const $TVGN_FIRSTVISIBLE = 0x00000005
Global Const $TV_FIRST = 0x1100
Global Const $TVM_ENSUREVISIBLE = $TV_FIRST + 20
Global Const $TVI_ROOT = 0xFFFF0000
Global Const $TVE_EXPAND = 0x0002
Global Const $TVE_COLLAPSERESET = 0x8000
Global Const $TVGN_ROOT = 0x00000000
Global Const $TVGN_CHILD = 0x00000004
Global Const $TVGN_NEXTVISIBLE = 0x00000006
Global Const $TVGN_CARET = 0x00000009
Global Const $TVIF_STATE = 0x00000008
Global Const $TVIF_CHILDREN = 0x00000040
Global Const $TVIS_FOCUSED = 0x00000001
Global Const $TVIS_CHECKED = 8192
Global Const $TVM_EXPAND = $TV_FIRST + 2
Global Const $TVM_GETITEMRECT = $TV_FIRST + 4
Global Const $TVM_GETNEXTITEM = $TV_FIRST + 10
Global Const $TVM_SELECTITEM = $TV_FIRST + 11
Global Const $TVM_GETITEMA = $TV_FIRST + 12
Global Const $TVM_SETITEMA = $TV_FIRST + 13
Global Const $TVM_HITTEST = $TV_FIRST + 17
Global Const $TVM_GETITEMW = $TV_FIRST + 62
Global Const $TVM_SETITEMW = $TV_FIRST + 63
Global Const $TVM_GETUNICODEFORMAT = 0x2000 + 6
Global Const $TVE_COLLAPSE = 0x0001
Global Const $TVGN_NEXT = 0x00000001
Global Const $ERROR_NO_TOKEN = 1008
Global $__ghTVLastWnd
Global $Debug_TV = False
Global Const $__TREEVIEWCONSTANT_ClassName = "SysTreeView32"
Global Const $__TREEVIEWCONSTANT_WM_SETREDRAW = 0x000B
Global Const $__TREEVIEWCONSTANT_DEFAULT_GUI_FONT = 17
Global Const $tagTVITEM = "uint Mask;handle hItem;uint State;uint StateMask;ptr Text;int TextMax;int Image;int SelectedImage;" & _
		"int Children;lparam Param"
Global Const $tagTVITEMEX = $tagTVITEM & ";int Integral"
Global Const $tagPOINT = "long X;long Y"
Global Const $tagTVHITTESTINFO = $tagPOINT & ";uint Flags;handle Item"
Global Const $tagRECT = "long Left;long Top;long Right;long Bottom"		
Global Const $tagTVINSERTSTRUCT = "handle Parent;handle InsertAfter;" & $tagTVITEM
Global $__gaInProcess_WinAPI[64][2]	= [[0, 0]]
Global Const $__WINAPICONSTANT_FORMAT_MESSAGE_ALLOCATE_BUFFER = 0x100
Global Const $__WINAPICONSTANT_FORMAT_MESSAGE_FROM_SYSTEM = 0x1000
Global $__gaInProcess_WinAPI[64][2]	= [[0, 0]]
Global Const $PROCESS_VM_OPERATION		= 0x00000008
Global Const $PROCESS_VM_READ			= 0x00000010
Global Const $PROCESS_VM_WRITE			= 0x00000020
Global Const $MEM_RELEASE = 0x00008000
Global Const $MEM_RESERVE = 0x00002000
Global Const $MEM_COMMIT = 0x00001000
Global Const $PAGE_READWRITE = 0x00000004
Global Const $TOKEN_QUERY				= 0x00000008
Global Const $TOKEN_ADJUST_PRIVILEGES	= 0x00000020
Global Const $SE_PRIVILEGE_ENABLED_BY_DEFAULT	= 0x00000001
Global Const $SE_PRIVILEGE_ENABLED				= 0x00000002
Global Const $tagTOKEN_PRIVILEGES = "dword Count;int64 LUID;dword Attributes"
Global Const $tagLVITEM = "uint Mask;int Item;int SubItem;uint State;uint StateMask;ptr Text;int TextMax;int Image;lparam Param;" & _
		"int Indent;int GroupID;uint Columns;ptr pColumns"
Global Const $tagNMHDR = "hwnd hWndFrom;uint_ptr IDFrom;INT Code"
Global Const $tagNMITEMACTIVATE = $tagNMHDR & ";int Index;int SubItem;uint NewState;uint OldState;uint Changed;" & _
			$tagPOINT & ";lparam lParam;uint KeyFlags"
Global Const $LVM_FIRST = 0x1000
Global Const $LVIF_TEXT = 0x00000001
Global Const $LVIF_IMAGE = 0x00000002
Global Const $LVM_SETITEMW = ($LVM_FIRST + 76)
Global Const $LVM_SETITEMA = ($LVM_FIRST + 6)
Global Const $LVM_GETITEMCOUNT = ($LVM_FIRST + 4)
Global Const $LVM_GETITEMTEXTW = ($LVM_FIRST + 115)
Global Const $LVM_GETITEMTEXTA = ($LVM_FIRST + 45)
Global Const $LVM_GETUNICODEFORMAT = 0x2000 + 6
Global Const $LVIF_PARAM = 0x00000004
Global Const $LVM_INSERTITEMW = ($LVM_FIRST + 77)
Global Const $LVM_INSERTITEMA = ($LVM_FIRST + 7)
Global Const $LVCFMT_LEFT = 0x0000
Global Const $LVCFMT_RIGHT = 0x0001
Global Const $LVCFMT_CENTER = 0x0002
Global Const $LVCF_FMT = 0x0001
Global Const $LVM_SETCOLUMNW = ($LVM_FIRST + 96)
Global Const $LVM_SETCOLUMNA = ($LVM_FIRST + 26)
Global Const $LVM_SETBKCOLOR = ($LVM_FIRST + 1)
Global Const $LVM_SETCOLUMNWIDTH = ($LVM_FIRST + 30)
Global Const $LV_ERR = -1
Global Const $LVIF_STATE = 0x00000008
Global Const $LVIS_SELECTED = 0x0002
Global Const $LVIS_FOCUSED = 0x0001
Global Const $LVM_SETITEMSTATE = ($LVM_FIRST + 43)
Global Const $LVM_SETTEXTBKCOLOR = ($LVM_FIRST + 38)
Global Const $LVM_SETTEXTCOLOR = ($LVM_FIRST + 36)
Global Const $LVIS_STATEIMAGEMASK = 0xF000
Global Const $__LISTVIEWCONSTANT_ClassName = "SysListView32"
Global Const $__LISTVIEWCONSTANT_WS_MAXIMIZEBOX = 0x00010000
Global Const $__LISTVIEWCONSTANT_WS_MINIMIZEBOX = 0x00020000
Global Const $__LISTVIEWCONSTANT_GUI_RUNDEFMSG = 'GUI_RUNDEFMSG'
Global Const $__LISTVIEWCONSTANT_WM_SETREDRAW = 0x000B
Global Const $__LISTVIEWCONSTANT_WM_SETFONT = 0x0030
Global Const $__LISTVIEWCONSTANT_WM_NOTIFY = 0x004E
Global Const $__LISTVIEWCONSTANT_DEFAULT_GUI_FONT = 17
Global Const $__LISTVIEWCONSTANT_ILD_TRANSPARENT = 0x00000001
Global Const $__LISTVIEWCONSTANT_ILD_BLEND25 = 0x00000002
Global Const $__LISTVIEWCONSTANT_ILD_BLEND50 = 0x00000004
Global Const $__LISTVIEWCONSTANT_ILD_MASK = 0x00000010
Global Const $__LISTVIEWCONSTANT_VK_DOWN = 0x28
Global Const $__LISTVIEWCONSTANT_VK_END = 0x23
Global Const $__LISTVIEWCONSTANT_VK_HOME = 0x24
Global Const $__LISTVIEWCONSTANT_VK_LEFT = 0x25
Global Const $__LISTVIEWCONSTANT_VK_NEXT = 0x22
Global Const $__LISTVIEWCONSTANT_VK_PRIOR = 0x21
Global Const $__LISTVIEWCONSTANT_VK_RIGHT = 0x27
Global Const $__LISTVIEWCONSTANT_VK_UP = 0x26
Global Const $tagLVBKIMAGE = "ulong Flags;hwnd hBmp;ptr Image;uint ImageMax;int XOffPercent;int YOffPercent"
Global Const $tagLVCOLUMN = "uint Mask;int Fmt;int CX;ptr Text;int TextMax;int SubItem;int Image;int Order"
Global Const $tagLVGROUP = "uint Size;uint Mask;ptr Header;int HeaderMax;ptr Footer;int FooterMax;int GroupID;uint StateMask;uint State;uint Align"
Global Const $tagLVINSERTMARK = "uint Size;dword Flags;int Item;dword Reserved"
Global Const $tagLVSETINFOTIP = "uint Size;dword Flags;ptr Text;int Item;int SubItem"
Global Const $tagMEMMAP = "handle hProc;ulong_ptr Size;ptr Mem"

Func _GUICtrlListView_AddItem($hWnd, $sText, $iImage = -1, $iParam = 0)
	Return _GUICtrlListView_InsertItem($hWnd, $sText, -1, $iImage, $iParam)
EndFunc   ;==>_GUICtrlListView_AddItem
Func _GUICtrlListView_AddSubItem($hWnd, $iIndex, $sText, $iSubItem, $iImage = -1)
	If $Debug_LV Then __UDF_ValidateClassName($hWnd, $__LISTVIEWCONSTANT_ClassName)
	Local $fUnicode = _GUICtrlListView_GetUnicodeFormat($hWnd)
	Local $iBuffer = StringLen($sText) + 1
	Local $tBuffer
	If $fUnicode Then
		$tBuffer = DllStructCreate("wchar Text[" & $iBuffer & "]")
		$iBuffer *= 2
	Else
		$tBuffer = DllStructCreate("char Text[" & $iBuffer & "]")
	EndIf
	Local $pBuffer = DllStructGetPtr($tBuffer)
	Local $tItem = DllStructCreate($tagLVITEM)
	Local $pItem = DllStructGetPtr($tItem)
	Local $iMask = $LVIF_TEXT
	If $iImage <> -1 Then $iMask = BitOR($iMask, $LVIF_IMAGE)
	DllStructSetData($tBuffer, "Text", $sText)
	DllStructSetData($tItem, "Mask", $iMask)
	DllStructSetData($tItem, "Item", $iIndex)
	DllStructSetData($tItem, "SubItem", $iSubItem)
	DllStructSetData($tItem, "Image", $iImage)
	Local $iRet
	If IsHWnd($hWnd) Then
		If _WinAPI_InProcess($hWnd, $_lv_ghLastWnd) Then
			DllStructSetData($tItem, "Text", $pBuffer)
			$iRet = _SendMessage($hWnd, $LVM_SETITEMW, 0, $pItem, 0, "wparam", "ptr")
		Else
			Local $iItem = DllStructGetSize($tItem)
			Local $tMemMap
			Local $pMemory = _MemInit($hWnd, $iItem + $iBuffer, $tMemMap)
			Local $pText = $pMemory + $iItem
			DllStructSetData($tItem, "Text", $pText)
			_MemWrite($tMemMap, $pItem, $pMemory, $iItem)
			_MemWrite($tMemMap, $pBuffer, $pText, $iBuffer)
			If $fUnicode Then
				$iRet = _SendMessage($hWnd, $LVM_SETITEMW, 0, $pMemory, 0, "wparam", "ptr")
			Else
				$iRet = _SendMessage($hWnd, $LVM_SETITEMA, 0, $pMemory, 0, "wparam", "ptr")
			EndIf
			_MemFree($tMemMap)
		EndIf
	Else
		DllStructSetData($tItem, "Text", $pBuffer)
		If $fUnicode Then
			$iRet = GUICtrlSendMsg($hWnd, $LVM_SETITEMW, 0, $pItem)
		Else
			$iRet = GUICtrlSendMsg($hWnd, $LVM_SETITEMA, 0, $pItem)
		EndIf
	EndIf
	Return $iRet <> 0
EndFunc   ;==>_GUICtrlListView_AddSubItem
Func _GUICtrlListView_GetItemCount($hWnd)
	If $Debug_LV Then __UDF_ValidateClassName($hWnd, $__LISTVIEWCONSTANT_ClassName)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LVM_GETITEMCOUNT)
	Else
		Return GUICtrlSendMsg($hWnd, $LVM_GETITEMCOUNT, 0, 0)
	EndIf
EndFunc   ;==>_GUICtrlListView_GetItemCount
Func _GUICtrlListView_GetItemText($hWnd, $iIndex, $iSubItem = 0)
	If $Debug_LV Then __UDF_ValidateClassName($hWnd, $__LISTVIEWCONSTANT_ClassName)
	Local $fUnicode = _GUICtrlListView_GetUnicodeFormat($hWnd)
	Local $tBuffer
	If $fUnicode Then
		$tBuffer = DllStructCreate("wchar Text[4096]")
	Else
		$tBuffer = DllStructCreate("char Text[4096]")
	EndIf
	Local $pBuffer = DllStructGetPtr($tBuffer)
	Local $tItem = DllStructCreate($tagLVITEM)
	Local $pItem = DllStructGetPtr($tItem)
	DllStructSetData($tItem, "SubItem", $iSubItem)
	DllStructSetData($tItem, "TextMax", 4096)
	If IsHWnd($hWnd) Then
		If _WinAPI_InProcess($hWnd, $_lv_ghLastWnd) Then
			DllStructSetData($tItem, "Text", $pBuffer)
			_SendMessage($hWnd, $LVM_GETITEMTEXTW, $iIndex, $pItem, 0, "wparam", "ptr")
		Else
			Local $iItem = DllStructGetSize($tItem)
			Local $tMemMap
			Local $pMemory = _MemInit($hWnd, $iItem + 4096, $tMemMap)
			Local $pText = $pMemory + $iItem
			DllStructSetData($tItem, "Text", $pText)
			_MemWrite($tMemMap, $pItem, $pMemory, $iItem)
			If $fUnicode Then
				_SendMessage($hWnd, $LVM_GETITEMTEXTW, $iIndex, $pMemory, 0, "wparam", "ptr")
			Else
				_SendMessage($hWnd, $LVM_GETITEMTEXTA, $iIndex, $pMemory, 0, "wparam", "ptr")
			EndIf
			_MemRead($tMemMap, $pText, $pBuffer, 4096)
			_MemFree($tMemMap)
		EndIf
	Else
		DllStructSetData($tItem, "Text", $pBuffer)
		If $fUnicode Then
			GUICtrlSendMsg($hWnd, $LVM_GETITEMTEXTW, $iIndex, $pItem)
		Else
			GUICtrlSendMsg($hWnd, $LVM_GETITEMTEXTA, $iIndex, $pItem)
		EndIf
	EndIf
	Return DllStructGetData($tBuffer, "Text")
EndFunc   ;==>_GUICtrlListView_GetItemText
Func _GUICtrlListView_GetUnicodeFormat($hWnd)
	If $Debug_LV Then __UDF_ValidateClassName($hWnd, $__LISTVIEWCONSTANT_ClassName)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LVM_GETUNICODEFORMAT) <> 0
	Else
		Return GUICtrlSendMsg($hWnd, $LVM_GETUNICODEFORMAT, 0, 0) <> 0
	EndIf
EndFunc   ;==>_GUICtrlListView_GetUnicodeFormat
Func _GUICtrlListView_InsertItem($hWnd, $sText, $iIndex = -1, $iImage = -1, $iParam = 0)
	If $Debug_LV Then __UDF_ValidateClassName($hWnd, $__LISTVIEWCONSTANT_ClassName)
	Local $fUnicode = _GUICtrlListView_GetUnicodeFormat($hWnd)
	Local $iBuffer, $pBuffer, $tBuffer, $iRet
	If $iIndex = -1 Then $iIndex = 999999999
	Local $tItem = DllStructCreate($tagLVITEM)
	Local $pItem = DllStructGetPtr($tItem)
	DllStructSetData($tItem, "Param", $iParam)
	If $sText <> -1 Then
		$iBuffer = StringLen($sText) + 1
		If $fUnicode Then
			$tBuffer = DllStructCreate("wchar Text[" & $iBuffer & "]")
			$iBuffer *= 2
		Else
			$tBuffer = DllStructCreate("char Text[" & $iBuffer & "]")
		EndIf
		$pBuffer = DllStructGetPtr($tBuffer)
		DllStructSetData($tBuffer, "Text", $sText)
		DllStructSetData($tItem, "Text", $pBuffer)
		DllStructSetData($tItem, "TextMax", $iBuffer)
	Else
		DllStructSetData($tItem, "Text", -1)
	EndIf
	Local $iMask = BitOR($LVIF_TEXT, $LVIF_PARAM)
	If $iImage >= 0 Then $iMask = BitOR($iMask, $LVIF_IMAGE)
	DllStructSetData($tItem, "Mask", $iMask)
	DllStructSetData($tItem, "Item", $iIndex)
	DllStructSetData($tItem, "Image", $iImage)
	If IsHWnd($hWnd) Then
		If _WinAPI_InProcess($hWnd, $_lv_ghLastWnd) Or ($sText = -1) Then
			$iRet = _SendMessage($hWnd, $LVM_INSERTITEMW, 0, $pItem, 0, "wparam", "ptr")
		Else
			Local $iItem = DllStructGetSize($tItem)
			Local $tMemMap
			Local $pMemory = _MemInit($hWnd, $iItem + $iBuffer, $tMemMap)
			Local $pText = $pMemory + $iItem
			DllStructSetData($tItem, "Text", $pText)
			_MemWrite($tMemMap, $pItem, $pMemory, $iItem)
			_MemWrite($tMemMap, $pBuffer, $pText, $iBuffer)
			If $fUnicode Then
				$iRet = _SendMessage($hWnd, $LVM_INSERTITEMW, 0, $pMemory, 0, "wparam", "ptr")
			Else
				$iRet = _SendMessage($hWnd, $LVM_INSERTITEMA, 0, $pMemory, 0, "wparam", "ptr")
			EndIf
			_MemFree($tMemMap)
		EndIf
	Else
		If $fUnicode Then
			$iRet = GUICtrlSendMsg($hWnd, $LVM_INSERTITEMW, 0, $pItem)
		Else
			$iRet = GUICtrlSendMsg($hWnd, $LVM_INSERTITEMA, 0, $pItem)
		EndIf
	EndIf
	Return $iRet
EndFunc   ;==>_GUICtrlListView_InsertItem
Func _GUICtrlListView_JustifyColumn($hWnd, $iIndex, $iAlign = -1)
	If $Debug_LV Then __UDF_ValidateClassName($hWnd, $__LISTVIEWCONSTANT_ClassName)
	Local $aAlign[3] = [$LVCFMT_LEFT, $LVCFMT_RIGHT, $LVCFMT_CENTER]
	Local $fUnicode = _GUICtrlListView_GetUnicodeFormat($hWnd)
	Local $tColumn = DllStructCreate($tagLVCOLUMN)
	Local $pColumn = DllStructGetPtr($tColumn)
	If $iAlign < 0 Or $iAlign > 2 Then $iAlign = 0
	Local $iMask = $LVCF_FMT
	Local $iFmt = $aAlign[$iAlign]
	DllStructSetData($tColumn, "Mask", $iMask)
	DllStructSetData($tColumn, "Fmt", $iFmt)
	Local $iRet
	If IsHWnd($hWnd) Then
		If _WinAPI_InProcess($hWnd, $_lv_ghLastWnd) Then
			$iRet = _SendMessage($hWnd, $LVM_SETCOLUMNW, $iIndex, $pColumn, 0, "wparam", "ptr")
		Else
			Local $iColumn = DllStructGetSize($tColumn)
			Local $tMemMap
			Local $pMemory = _MemInit($hWnd, $iColumn, $tMemMap)
			_MemWrite($tMemMap, $pColumn, $pMemory, $iColumn)
			If $fUnicode Then
				$iRet = _SendMessage($hWnd, $LVM_SETCOLUMNW, $iIndex, $pMemory, 0, "wparam", "ptr")
			Else
				$iRet = _SendMessage($hWnd, $LVM_SETCOLUMNA, $iIndex, $pMemory, 0, "wparam", "ptr")
			EndIf
			_MemFree($tMemMap)
		EndIf
	Else
		If $fUnicode Then
			$iRet = GUICtrlSendMsg($hWnd, $LVM_SETCOLUMNW, $iIndex, $pColumn)
		Else
			$iRet = GUICtrlSendMsg($hWnd, $LVM_SETCOLUMNA, $iIndex, $pColumn)
		EndIf
	EndIf
	Return $iRet <> 0
EndFunc   ;==>_GUICtrlListView_JustifyColumn
Func _GUICtrlListView_SetBkColor($hWnd, $iColor)
	If $Debug_LV Then __UDF_ValidateClassName($hWnd, $__LISTVIEWCONSTANT_ClassName)
	Local $iRet
	If IsHWnd($hWnd) Then
		$iRet = _SendMessage($hWnd, $LVM_SETBKCOLOR, 0, $iColor)
		_WinAPI_InvalidateRect($hWnd)
	Else
		$iRet = GUICtrlSendMsg($hWnd, $LVM_SETBKCOLOR, 0, $iColor)
		_WinAPI_InvalidateRect(GUICtrlGetHandle($hWnd))
	EndIf
	Return $iRet <> 0
EndFunc   ;==>_GUICtrlListView_SetBkColor
Func _GUICtrlListView_SetColumnWidth($hWnd, $iCol, $iWidth)
	If $Debug_LV Then __UDF_ValidateClassName($hWnd, $__LISTVIEWCONSTANT_ClassName)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LVM_SETCOLUMNWIDTH, $iCol, $iWidth)
	Else
		Return GUICtrlSendMsg($hWnd, $LVM_SETCOLUMNWIDTH, $iCol, $iWidth)
	EndIf
EndFunc   ;==>_GUICtrlListView_SetColumnWidth
Func _GUICtrlListView_SetItemChecked($hWnd, $iIndex, $fCheck = True)
	If $Debug_LV Then __UDF_ValidateClassName($hWnd, $__LISTVIEWCONSTANT_ClassName)
	Local $fUnicode = _GUICtrlListView_GetUnicodeFormat($hWnd)
	Local $pMemory, $tMemMap, $iRet
	Local $tItem = DllStructCreate($tagLVITEM)
	Local $pItem = DllStructGetPtr($tItem)
	Local $iItem = DllStructGetSize($tItem)
	If @error Then Return SetError($LV_ERR, $LV_ERR, $LV_ERR)
	If $iIndex <> -1 Then
		DllStructSetData($tItem, "Mask", $LVIF_STATE)
		DllStructSetData($tItem, "Item", $iIndex)
		If ($fCheck) Then
			DllStructSetData($tItem, "State", 0x2000)
		Else
			DllStructSetData($tItem, "State", 0x1000)
		EndIf
		DllStructSetData($tItem, "StateMask", 0xf000)
		If IsHWnd($hWnd) Then
			If _WinAPI_InProcess($hWnd, $_lv_ghLastWnd) Then
				Return _SendMessage($hWnd, $LVM_SETITEMW, 0, $pItem, 0, "wparam", "ptr") <> 0
			Else
				$pMemory = _MemInit($hWnd, $iItem, $tMemMap)
				_MemWrite($tMemMap, $pItem)
				If $fUnicode Then
					$iRet = _SendMessage($hWnd, $LVM_SETITEMW, 0, $pMemory, 0, "wparam", "ptr")
				Else
					$iRet = _SendMessage($hWnd, $LVM_SETITEMA, 0, $pMemory, 0, "wparam", "ptr")
				EndIf
				_MemFree($tMemMap)
				Return $iRet <> 0
			EndIf
		Else
			If $fUnicode Then
				Return GUICtrlSendMsg($hWnd, $LVM_SETITEMW, 0, $pItem) <> 0
			Else
				Return GUICtrlSendMsg($hWnd, $LVM_SETITEMA, 0, $pItem) <> 0
			EndIf
		EndIf
	Else
		For $x = 0 To _GUICtrlListView_GetItemCount($hWnd) - 1
			DllStructSetData($tItem, "Mask", $LVIF_STATE)
			DllStructSetData($tItem, "Item", $x)
			If ($fCheck) Then
				DllStructSetData($tItem, "State", 0x2000)
			Else
				DllStructSetData($tItem, "State", 0x1000)
			EndIf
			DllStructSetData($tItem, "StateMask", 0xf000)
			If IsHWnd($hWnd) Then
				If _WinAPI_InProcess($hWnd, $_lv_ghLastWnd) Then
					If Not _SendMessage($hWnd, $LVM_SETITEMW, 0, $pItem, 0, "wparam", "ptr") <> 0 Then Return SetError($LV_ERR, $LV_ERR, $LV_ERR)
				Else
					$pMemory = _MemInit($hWnd, $iItem, $tMemMap)
					_MemWrite($tMemMap, $pItem)
					If $fUnicode Then
						$iRet = _SendMessage($hWnd, $LVM_SETITEMW, 0, $pMemory, 0, "wparam", "ptr")
					Else
						$iRet = _SendMessage($hWnd, $LVM_SETITEMA, 0, $pMemory, 0, "wparam", "ptr")
					EndIf
					_MemFree($tMemMap)
					If Not $iRet <> 0 Then Return SetError($LV_ERR, $LV_ERR, $LV_ERR)
				EndIf
			Else
				If $fUnicode Then
					If Not GUICtrlSendMsg($hWnd, $LVM_SETITEMW, 0, $pItem) <> 0 Then Return SetError($LV_ERR, $LV_ERR, $LV_ERR)
				Else
					If Not GUICtrlSendMsg($hWnd, $LVM_SETITEMA, 0, $pItem) <> 0 Then Return SetError($LV_ERR, $LV_ERR, $LV_ERR)
				EndIf
			EndIf
		Next
		Return True
	EndIf
	Return False
EndFunc   ;==>_GUICtrlListView_SetItemChecked
Func _GUICtrlListView_SetItemSelected($hWnd, $iIndex, $fSelected = True, $fFocused = False)
	If $Debug_LV Then __UDF_ValidateClassName($hWnd, $__LISTVIEWCONSTANT_ClassName)
	Local $tstruct = DllStructCreate($tagLVITEM)
	Local $pItem = DllStructGetPtr($tstruct)
	Local $iRet, $iSelected = 0, $iFocused = 0, $iSize, $tMemMap, $pMemory
	If ($fSelected = True) Then $iSelected = $LVIS_SELECTED
	If ($fFocused = True And $iIndex <> -1) Then $iFocused = $LVIS_FOCUSED
	DllStructSetData($tstruct, "Mask", $LVIF_STATE)
	DllStructSetData($tstruct, "Item", $iIndex)
	DllStructSetData($tstruct, "State", BitOR($iSelected, $iFocused))
	DllStructSetData($tstruct, "StateMask", BitOR($LVIS_SELECTED, $iFocused))
	$iSize = DllStructGetSize($tstruct)
	If IsHWnd($hWnd) Then
		$pMemory = _MemInit($hWnd, $iSize, $tMemMap)
		_MemWrite($tMemMap, $pItem, $pMemory, $iSize)
		$iRet = _SendMessage($hWnd, $LVM_SETITEMSTATE, $iIndex, $pMemory)
		_MemFree($tMemMap)
	Else
		$iRet = GUICtrlSendMsg($hWnd, $LVM_SETITEMSTATE, $iIndex, $pItem)
	EndIf
	Return $iRet <> 0
EndFunc   ;==>_GUICtrlListView_SetItemSelected
Func _GUICtrlListView_SetTextBkColor($hWnd, $iColor)
	If $Debug_LV Then __UDF_ValidateClassName($hWnd, $__LISTVIEWCONSTANT_ClassName)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LVM_SETTEXTBKCOLOR, 0, $iColor) <> 0
	Else
		Return GUICtrlSendMsg($hWnd, $LVM_SETTEXTBKCOLOR, 0, $iColor) <> 0
	EndIf
EndFunc   ;==>_GUICtrlListView_SetTextBkColor
Func _GUICtrlListView_SetTextColor($hWnd, $iColor)
	If $Debug_LV Then __UDF_ValidateClassName($hWnd, $__LISTVIEWCONSTANT_ClassName)
	Local $iRet
	If IsHWnd($hWnd) Then
		$iRet = _SendMessage($hWnd, $LVM_SETTEXTCOLOR, 0, $iColor)
		_WinAPI_InvalidateRect($hWnd)
	Else
		$iRet = GUICtrlSendMsg($hWnd, $LVM_SETTEXTCOLOR, 0, $iColor)
		_WinAPI_InvalidateRect(GUICtrlGetHandle($hWnd))
	EndIf
	Return $iRet <> 0
EndFunc   ;==>_GUICtrlListView_SetTextColor
Func __GUICtrlListView_StateImageMaskToIndex($iMask)
	Return BitShift(BitAND($iMask, $LVIS_STATEIMAGEMASK), 12)
EndFunc   ;==>__GUICtrlListView_StateImageMaskToIndex
Func _MemWrite(ByRef $tMemMap, $pSrce, $pDest = 0, $iSize = 0, $sSrce = "ptr")
	If $pDest = 0 Then $pDest = DllStructGetData($tMemMap, "Mem")
	If $iSize = 0 Then $iSize = DllStructGetData($tMemMap, "Size")
	Local $aResult = DllCall("kernel32.dll", "bool", "WriteProcessMemory", "handle", DllStructGetData($tMemMap, "hProc"), _
			"ptr", $pDest, $sSrce, $pSrce, "ulong_ptr", $iSize, "ulong_ptr*", 0)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0]
EndFunc   ;==>_MemWrite
Func _MemFree(ByRef $tMemMap)
	Local $pMemory = DllStructGetData($tMemMap, "Mem")
	Local $hProcess = DllStructGetData($tMemMap, "hProc")
	Local $bResult = _MemVirtualFreeEx($hProcess, $pMemory, 0, $MEM_RELEASE)
	DllCall("kernel32.dll", "bool", "CloseHandle", "handle", $hProcess)
	If @error Then Return SetError(@error, @extended, False)
	Return $bResult
EndFunc   ;==>_MemFree
Func _MemInit($hWnd, $iSize, ByRef $tMemMap)
	Local $aResult = DllCall("User32.dll", "dword", "GetWindowThreadProcessId", "hwnd", $hWnd, "dword*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	Local $iProcessID = $aResult[2]
	Local $iAccess = BitOR($PROCESS_VM_OPERATION, $PROCESS_VM_READ, $PROCESS_VM_WRITE)
	Local $hProcess = __Mem_OpenProcess($iAccess, False, $iProcessID, True)
	Local $iAlloc = BitOR($MEM_RESERVE, $MEM_COMMIT)
	Local $pMemory = _MemVirtualAllocEx($hProcess, 0, $iSize, $iAlloc, $PAGE_READWRITE)
	$tMemMap = DllStructCreate($tagMEMMAP)
	DllStructSetData($tMemMap, "hProc", $hProcess)
	DllStructSetData($tMemMap, "Size", $iSize)
	DllStructSetData($tMemMap, "Mem", $pMemory)
	Return $pMemory
EndFunc   ;==>_MemInit
Func _MemRead(ByRef $tMemMap, $pSrce, $pDest, $iSize)
	Local $aResult = DllCall("kernel32.dll", "bool", "ReadProcessMemory", "handle", DllStructGetData($tMemMap, "hProc"), _
		"ptr", $pSrce, "ptr", $pDest, "ulong_ptr", $iSize, "ulong_ptr*", 0)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0]
EndFunc   ;==>_MemRead
Func _MemVirtualFreeEx($hProcess, $pAddress, $iSize, $iFreeType)
	Local $aResult = DllCall("kernel32.dll", "bool", "VirtualFreeEx", "handle", $hProcess, "ptr", $pAddress, "ulong_ptr", $iSize, "dword", $iFreeType)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0]
EndFunc   ;==>_MemVirtualFreeEx
Func __Mem_OpenProcess($iAccess, $fInherit, $iProcessID, $fDebugPriv=False)
	Local $aResult = DllCall("kernel32.dll", "handle", "OpenProcess", "dword", $iAccess, "bool", $fInherit, "dword", $iProcessID)
	If @error Then Return SetError(@error, @extended, 0)
	If $aResult[0] Then Return $aResult[0]
	If Not $fDebugPriv Then Return 0
	Local $hToken = _Security__OpenThreadTokenEx(BitOR($TOKEN_ADJUST_PRIVILEGES, $TOKEN_QUERY))
	If @error Then Return SetError(@error, @extended, 0)
	_Security__SetPrivilege($hToken, "SeDebugPrivilege", True)
	Local $iError = @error
	Local $iLastError = @extended
	Local $iRet = 0
	If Not @error Then
		$aResult = DllCall("kernel32.dll", "handle", "OpenProcess", "dword", $iAccess, "bool", $fInherit, "dword", $iProcessID)
		$iError = @error
		$iLastError = @extended
		If $aResult[0] Then $iRet = $aResult[0]
		_Security__SetPrivilege($hToken, "SeDebugPrivilege", False)
		If @error Then
			$iError = @error
			$iLastError = @extended
		EndIf
	EndIf
	DllCall("kernel32.dll", "bool", "CloseHandle", "handle", $hToken)
	Return SetError($iError,  $iLastError, $iRet)
EndFunc   ;==>__Mem_OpenProcess
Func _MemVirtualAllocEx($hProcess, $pAddress, $iSize, $iAllocation, $iProtect)
	Local $aResult = DllCall("kernel32.dll", "ptr", "VirtualAllocEx", "handle", $hProcess, "ptr", $pAddress, "ulong_ptr", $iSize, "dword", $iAllocation, "dword", $iProtect)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aResult[0]
EndFunc   ;==>_MemVirtualAllocEx
Func _MemVirtualAlloc($pAddress, $iSize, $iAllocation, $iProtect)
	Local $aResult = DllCall("kernel32.dll", "ptr", "VirtualAlloc", "ptr", $pAddress, "ulong_ptr", $iSize, "dword", $iAllocation, "dword", $iProtect)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aResult[0]
EndFunc   ;==>_MemVirtualAlloc
Func __UDF_ValidateClassName($hWnd, $sClassNames)
	__UDF_DebugPrint("This is for debugging only, set the debug variable to false before submitting")
	If _WinAPI_IsClassName($hWnd, $sClassNames) Then Return True
	Local $sSeparator = Opt("GUIDataSeparatorChar")
	$sClassNames = StringReplace($sClassNames, $sSeparator, ",")

	__UDF_DebugPrint("Invalid Class Type(s):" & @LF & @TAB & "Expecting Type(s): " & $sClassNames & @LF & @TAB & "Received Type : " & _WinAPI_GetClassName($hWnd))
	Exit
EndFunc   ;==>__UDF_ValidateClassName
Func _Security__OpenThreadTokenEx($iAccess, $hThread = 0, $fOpenAsSelf = False)
	Local $hToken = _Security__OpenThreadToken($iAccess, $hThread, $fOpenAsSelf)
	If $hToken = 0 Then
		If _WinAPI_GetLastError() <> $ERROR_NO_TOKEN Then Return SetError(-3, _WinAPI_GetLastError(), 0)
		If Not _Security__ImpersonateSelf() Then Return SetError(-1, _WinAPI_GetLastError(), 0)
		$hToken = _Security__OpenThreadToken($iAccess, $hThread, $fOpenAsSelf)
		If $hToken = 0 Then Return SetError(-2, _WinAPI_GetLastError(), 0)
	EndIf
	Return $hToken
EndFunc   ;==>_Security__OpenThreadTokenEx
Func _Security__SetPrivilege($hToken, $sPrivilege, $fEnable)
	Local $iLUID = _Security__LookupPrivilegeValue("", $sPrivilege)
	If $iLUID = 0 Then Return SetError(-1, 0, False)

	Local $tCurrState = DllStructCreate($tagTOKEN_PRIVILEGES)
	Local $pCurrState = DllStructGetPtr($tCurrState)
	Local $iCurrState = DllStructGetSize($tCurrState)
	Local $tPrevState = DllStructCreate($tagTOKEN_PRIVILEGES)
	Local $pPrevState = DllStructGetPtr($tPrevState)
	Local $iPrevState = DllStructGetSize($tPrevState)
	Local $tRequired = DllStructCreate("int Data")
	Local $pRequired = DllStructGetPtr($tRequired)
	; Get current privilege setting
	DllStructSetData($tCurrState, "Count", 1)
	DllStructSetData($tCurrState, "LUID", $iLUID)
	If Not _Security__AdjustTokenPrivileges($hToken, False, $pCurrState, $iCurrState, $pPrevState, $pRequired) Then  _
							Return SetError(-2, @error, False)
	; Set privilege based on prior setting
	DllStructSetData($tPrevState, "Count", 1)
	DllStructSetData($tPrevState, "LUID", $iLUID)
	Local $iAttributes = DllStructGetData($tPrevState, "Attributes")
	If $fEnable Then
		$iAttributes = BitOR($iAttributes, $SE_PRIVILEGE_ENABLED)
	Else
		$iAttributes = BitAND($iAttributes, BitNOT($SE_PRIVILEGE_ENABLED))
	EndIf
	DllStructSetData($tPrevState, "Attributes", $iAttributes)
	If Not _Security__AdjustTokenPrivileges($hToken, False, $pPrevState, $iPrevState, $pCurrState, $pRequired) Then _
							Return SetError(-3, @error, False)
	Return True
EndFunc   ;==>_Security__SetPrivilege
Func _WinAPI_InProcess($hWnd, ByRef $hLastWnd)
	If $hWnd = $hLastWnd Then Return True
	For $iI = $__gaInProcess_WinAPI[0][0] To 1 Step -1
		If $hWnd = $__gaInProcess_WinAPI[$iI][0] Then
			If $__gaInProcess_WinAPI[$iI][1] Then
				$hLastWnd = $hWnd
				Return True
			Else
				Return False
			EndIf
		EndIf
	Next
	Local $iProcessID
	_WinAPI_GetWindowThreadProcessId($hWnd, $iProcessID)
	Local $iCount = $__gaInProcess_WinAPI[0][0] + 1
	If $iCount >= 64 Then $iCount = 1
	$__gaInProcess_WinAPI[0][0] = $iCount
	$__gaInProcess_WinAPI[$iCount][0] = $hWnd
	$__gaInProcess_WinAPI[$iCount][1] = ($iProcessID = @AutoItPID)
	Return $__gaInProcess_WinAPI[$iCount][1]
EndFunc   ;==>_WinAPI_InProcess
Func _WinAPI_InvalidateRect($hWnd, $tRect = 0, $fErase = True)
	Local $pRect = 0
	If IsDllStruct($tRect) Then $pRect = DllStructGetPtr($tRect)
	Local $aResult = DllCall("user32.dll", "bool", "InvalidateRect", "hwnd", $hWnd, "ptr", $pRect, "bool", $fErase)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0]
EndFunc   ;==>_WinAPI_InvalidateRect
Func _WinAPI_IsClassName($hWnd, $sClassName)
	Local $sSeparator = Opt("GUIDataSeparatorChar")
	Local $aClassName = StringSplit($sClassName, $sSeparator)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)
	Local $sClassCheck = _WinAPI_GetClassName($hWnd) ; ClassName from Handle
	; check array of ClassNames against ClassName Returned
	For $x = 1 To UBound($aClassName) - 1
		If StringUpper(StringMid($sClassCheck, 1, StringLen($aClassName[$x]))) = StringUpper($aClassName[$x]) Then Return True
	Next
	Return False
EndFunc   ;==>_WinAPI_IsClassName
Func _WinAPI_GetClassName($hWnd)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)
	Local $aResult = DllCall("user32.dll", "int", "GetClassNameW", "hwnd", $hWnd, "wstr", "", "int", 4096)
	If @error Then Return SetError(@error, @extended, False)
	Return SetExtended($aResult[0], $aResult[2])
EndFunc   ;==>_WinAPI_GetClassName
Func _WinAPI_GetLastError($curErr=@error, $curExt=@extended)
	Local $aResult = DllCall("kernel32.dll", "dword", "GetLastError")
	Return SetError($curErr, $curExt, $aResult[0])
EndFunc   ;==>_WinAPI_GetLastError
Func _SendMessage($hWnd, $iMsg, $wParam = 0, $lParam = 0, $iReturn = 0, $wParamType = "wparam", $lParamType = "lparam", $sReturnType = "lresult")
	Local $aResult = DllCall("user32.dll", $sReturnType, "SendMessageW", "hwnd", $hWnd, "uint", $iMsg, $wParamType, $wParam, $lParamType, $lParam)
	If @error Then Return SetError(@error, @extended, "")
	If $iReturn >= 0 And $iReturn <= 4 Then Return $aResult[$iReturn]
	Return $aResult
EndFunc   ;==>_SendMessage
Func __UDF_DebugPrint($sText, $iLine = @ScriptLineNumber, $err=@error, $ext=@extended)
	ConsoleWrite( _
			"!===========================================================" & @CRLF & _
			"+======================================================" & @CRLF & _
			"-->Line(" & StringFormat("%04d", $iLine) & "):" & @TAB & $sText & @CRLF & _
			"+======================================================" & @CRLF)
	Return SetError($err, $ext, 1)
EndFunc   ;==>__UDF_DebugPrint
Func _Security__OpenThreadToken($iAccess, $hThread = 0, $fOpenAsSelf = False)
	If $hThread = 0 Then $hThread = DllCall("kernel32.dll", "handle", "GetCurrentThread")
	If @error Then Return SetError(@error, @extended, 0)
	Local $aResult = DllCall("advapi32.dll", "bool", "OpenThreadToken", "handle", $hThread[0], "dword", $iAccess, "int", $fOpenAsSelf, "ptr*", 0)
	If @error Then Return SetError(@error, @extended, 0)
EndFunc   ;==>_Security__OpenThreadToken
Func _Security__ImpersonateSelf($iLevel = 2)
	Local $aResult = DllCall("advapi32.dll", "bool", "ImpersonateSelf", "int", $iLevel)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0]
EndFunc   ;==>_Security__ImpersonateSelf
Func _Security__LookupPrivilegeValue($sSystem, $sName)
	Local $aResult = DllCall("advapi32.dll", "int", "LookupPrivilegeValueW", "wstr", $sSystem, "wstr", $sName, "int64*", 0)
	If @error Then Return SetError(@error, @extended, 0)
EndFunc   ;==>_Security__LookupPrivilegeValue
Func _Security__AdjustTokenPrivileges($hToken, $fDisableAll, $pNewState, $iBufferLen, $pPrevState = 0, $pRequired = 0)
	Local $aResult = DllCall("advapi32.dll", "bool", "AdjustTokenPrivileges", "handle", $hToken, "bool", $fDisableAll, "ptr", $pNewState, _
			"dword", $iBufferLen, "ptr", $pPrevState, "ptr", $pRequired)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0]
EndFunc   ;==>_Security__AdjustTokenPrivileges
Func _WinAPI_GetWindowThreadProcessId($hWnd, ByRef $iPID)
	Local $aResult = DllCall("user32.dll", "dword", "GetWindowThreadProcessId", "hwnd", $hWnd, "dword*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	$iPID = $aResult[2]
	Return $aResult[0]
EndFunc   ;==>_WinAPI_GetWindowThreadProcessId
Func _GUICtrlTreeView_ClickItem($hWnd, $hItem, $sButton = "left", $fMove = False, $iClicks = 1, $iSpeed = 0)
	If $Debug_TV Then __UDF_ValidateClassName($hWnd, $__TREEVIEWCONSTANT_ClassName)

	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Local $tRect = _GUICtrlTreeView_DisplayRectEx($hWnd, $hItem, True)
	If @error Then Return SetError(@error, @error, 0)
	Local $tPoint = _WinAPI_PointFromRect($tRect, False)
	_WinAPI_ClientToScreen($hWnd, $tPoint)
	Local $iX, $iY
	_WinAPI_GetXYFromPoint($tPoint, $iX, $iY)
	Local $iMode = Opt("MouseCoordMode", 1)
	If Not $fMove Then
		Local $aPos = MouseGetPos()
		_WinAPI_ShowCursor(False)
		MouseClick($sButton, $iX, $iY, $iClicks, $iSpeed)
		MouseMove($aPos[0], $aPos[1], 0)
		_WinAPI_ShowCursor(True)
	Else
		MouseClick($sButton, $iX, $iY, $iClicks, $iSpeed)
	EndIf
	Opt("MouseCoordMode", $iMode)
	Return 1
EndFunc   ;==>_GUICtrlTreeView_ClickItem
Func _GUICtrlTreeView_EnsureVisible($hWnd, $hItem)
	If $Debug_TV Then __UDF_ValidateClassName($hWnd, $__TREEVIEWCONSTANT_ClassName)

	If Not IsHWnd($hItem) Then $hItem = _GUICtrlTreeView_GetItemHandle($hWnd, $hItem)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Return _SendMessage($hWnd, $TVM_ENSUREVISIBLE, 0, $hItem, 0, "wparam", "handle") <> 0
EndFunc   ;==>_GUICtrlTreeView_EnsureVisible
Func _GUICtrlTreeView_Expand($hWnd, $hItem = 0, $fExpand = True)
	If $Debug_TV Then __UDF_ValidateClassName($hWnd, $__TREEVIEWCONSTANT_ClassName)

	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	If $hItem = 0 Then $hItem = 0x00000000

	If $hItem = 0x00000000 Then
		$hItem = $TVI_ROOT
	Else
		If Not IsHWnd($hItem) Then
			Local $hItem_tmp = GUICtrlGetHandle($hItem)
			If $hItem_tmp <> 0x00000000 Then $hItem = $hItem_tmp
		EndIf
	EndIf

	If $fExpand Then
		__GUICtrlTreeView_ExpandItem($hWnd, $TVE_EXPAND, $hItem)
	Else
		__GUICtrlTreeView_ExpandItem($hWnd, $TVE_COLLAPSE, $hItem)
	EndIf
EndFunc   ;==>_GUICtrlTreeView_Expand
Func _GUICtrlTreeView_GetChecked($hWnd, $hItem)
	If $Debug_TV Then __UDF_ValidateClassName($hWnd, $__TREEVIEWCONSTANT_ClassName)

	If Not IsHWnd($hItem) Then $hItem = _GUICtrlTreeView_GetItemHandle($hWnd, $hItem)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Local $tItem = DllStructCreate($tagTVITEMEX)
	DllStructSetData($tItem, "Mask", $TVIF_STATE)
	DllStructSetData($tItem, "hItem", $hItem)
	__GUICtrlTreeView_GetItem($hWnd, $tItem)
	Return BitAND(DllStructGetData($tItem, "State"), $TVIS_CHECKED) = $TVIS_CHECKED
EndFunc   ;==>_GUICtrlTreeView_GetChecked
Func _GUICtrlTreeView_GetChildren($hWnd, $hItem)
	If $Debug_TV Then __UDF_ValidateClassName($hWnd, $__TREEVIEWCONSTANT_ClassName)

	If Not IsHWnd($hItem) Then $hItem = _GUICtrlTreeView_GetItemHandle($hWnd, $hItem)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Local $tItem = DllStructCreate($tagTVITEMEX)
	DllStructSetData($tItem, "Mask", $TVIF_CHILDREN)
	DllStructSetData($tItem, "hItem", $hItem)
	__GUICtrlTreeView_GetItem($hWnd, $tItem)
	Return DllStructGetData($tItem, "Children") <> 0
EndFunc   ;==>_GUICtrlTreeView_GetChildren
Func _GUICtrlTreeView_GetFirstItem($hWnd)
	If $Debug_TV Then __UDF_ValidateClassName($hWnd, $__TREEVIEWCONSTANT_ClassName)

	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Return _SendMessage($hWnd, $TVM_GETNEXTITEM, $TVGN_ROOT, 0, 0, "wparam", "lparam", "handle")
EndFunc   ;==>_GUICtrlTreeView_GetFirstItem
Func _GUICtrlTreeView_HitTestItem($hWnd, $iX, $iY)
	Local $tHitTest = _GUICtrlTreeView_HitTestEx($hWnd, $iX, $iY)
	Return DllStructGetData($tHitTest, "Item")
EndFunc   ;==>_GUICtrlTreeView_HitTestItem
Func _GUICtrlTreeView_SelectItem($hWnd, $hItem, $iFlag = 0)
	If $Debug_TV Then __UDF_ValidateClassName($hWnd, $__TREEVIEWCONSTANT_ClassName)

	If Not IsHWnd($hItem) Then $hItem = _GUICtrlTreeView_GetItemHandle($hWnd, $hItem)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	If $iFlag = 0 Then $iFlag = $TVGN_CARET
	Return _SendMessage($hWnd, $TVM_SELECTITEM, $iFlag, $hItem, 0, "wparam", "handle") <> 0
EndFunc   ;==>_GUICtrlTreeView_SelectItem
Func _GUICtrlTreeView_SetChecked($hWnd, $hItem, $fCheck = True)
	If $Debug_TV Then __UDF_ValidateClassName($hWnd, $__TREEVIEWCONSTANT_ClassName)

	If Not IsHWnd($hItem) Then $hItem = _GUICtrlTreeView_GetItemHandle($hWnd, $hItem)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Local $tItem = DllStructCreate($tagTVITEMEX)
	DllStructSetData($tItem, "Mask", $TVIF_STATE)
	DllStructSetData($tItem, "hItem", $hItem)
	If ($fCheck) Then
		DllStructSetData($tItem, "State", 0x2000)
	Else
		DllStructSetData($tItem, "State", 0x1000)
	EndIf
	DllStructSetData($tItem, "StateMask", 0xf000)
	Return __GUICtrlTreeView_SetItem($hWnd, $tItem)
EndFunc   ;==>_GUICtrlTreeView_SetChecked
Func _GUICtrlTreeView_SetFocused($hWnd, $hItem, $fFlag = True)
	Return _GUICtrlTreeView_SetState($hWnd, $hItem, $TVIS_FOCUSED, $fFlag)
EndFunc   ;==>_GUICtrlTreeView_SetFocused
Func _GUICtrlTreeView_DisplayRectEx($hWnd, $hItem, $fTextOnly = False)
	If $Debug_TV Then __UDF_ValidateClassName($hWnd, $__TREEVIEWCONSTANT_ClassName)
	Local $tRect = DllStructCreate($tagRECT)
	Local $pRect = DllStructGetPtr($tRect)
	Local $iRet
	If IsHWnd($hWnd) Then
		DllStructSetData($tRect, "Left", $hItem)
		If _WinAPI_InProcess($hWnd, $__ghTVLastWnd) Then
			$iRet = _SendMessage($hWnd, $TVM_GETITEMRECT, $fTextOnly, $pRect, 0, "wparam", "ptr")
		Else
			Local $iRect = DllStructGetSize($tRect)
			Local $tMemMap
			Local $pMemory = _MemInit($hWnd, $iRect, $tMemMap)
			_MemWrite($tMemMap, $pRect)
			$iRet = _SendMessage($hWnd, $TVM_GETITEMRECT, $fTextOnly, $pMemory, 0, "wparam", "ptr")
			_MemRead($tMemMap, $pMemory, $pRect, $iRect)
			_MemFree($tMemMap)
		EndIf
	Else
		If Not IsHWnd($hItem) Then $hItem = _GUICtrlTreeView_GetItemHandle($hWnd, $hItem)
		DllStructSetData($tRect, "Left", $hItem)
		$iRet = GUICtrlSendMsg($hWnd, $TVM_GETITEMRECT, $fTextOnly, $pRect)
	EndIf

	If Not $iRet Then DllStructSetData($tRect, "Left", 0)
	Return SetError($iRet = 0, $iRet, $tRect)
EndFunc   ;==>_GUICtrlTreeView_DisplayRectEx
Func _GUICtrlTreeView_GetItemHandle($hWnd, $hItem = 0)
	If $Debug_TV Then __UDF_ValidateClassName($hWnd, $__TREEVIEWCONSTANT_ClassName)

	If $hItem = 0 Then $hItem = 0x00000000
	If IsHWnd($hWnd) Then
		If $hItem = 0x00000000 Then $hItem = _SendMessage($hWnd, $TVM_GETNEXTITEM, $TVGN_ROOT, 0, 0, "wparam", "lparam", "handle")
	Else
		If $hItem = 0x00000000 Then
			$hItem = GUICtrlSendMsg($hWnd, $TVM_GETNEXTITEM, $TVGN_ROOT, 0)
		Else
			Local $hTempItem = GUICtrlGetHandle($hItem)
			If $hTempItem <> 0x00000000 Then $hItem = $hTempItem
		EndIf
	EndIf

	Return $hItem
EndFunc   ;==>_GUICtrlTreeView_GetItemHandle
Func _GUICtrlTreeView_SetState($hWnd, $hItem, $iState = 0, $iSetState = True)
	If $Debug_TV Then __UDF_ValidateClassName($hWnd, $__TREEVIEWCONSTANT_ClassName)

	If Not IsHWnd($hItem) Then $hItem = _GUICtrlTreeView_GetItemHandle($hWnd, $hItem)
	If $hItem = 0x00000000 Or ($iState = 0 And $iSetState = False) Then Return False

	Local $tTVITEM = DllStructCreate($tagTVITEMEX)
	If @error Then Return SetError(1, 1, 0)
	DllStructSetData($tTVITEM, "Mask", $TVIF_STATE)
	DllStructSetData($tTVITEM, "hItem", $hItem)
	If $iSetState Then
		DllStructSetData($tTVITEM, "State", $iState)
	Else
		DllStructSetData($tTVITEM, "State", BitAND($iSetState, $iState))
	EndIf
	DllStructSetData($tTVITEM, "StateMask", $iState)
	If $iSetState Then DllStructSetData($tTVITEM, "StateMask", BitOR($iSetState, $iState))
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)
	Return __GUICtrlTreeView_SetItem($hWnd, $tTVITEM)
EndFunc   ;==>_GUICtrlTreeView_SetState
Func __GUICtrlTreeView_ExpandItem($hWnd, $iExpand, $hItem)
	If Not IsHWnd($hWnd) Then

		If $hItem = 0x00000000 Then
			$hItem = $TVI_ROOT
		Else
			$hItem = GUICtrlGetHandle($hItem)
			If $hItem = 0 Then Return
		EndIf
		$hWnd = GUICtrlGetHandle($hWnd)
	EndIf

	_SendMessage($hWnd, $TVM_EXPAND, $iExpand, $hItem, 0, "wparam", "handle")

	If $iExpand = $TVE_EXPAND And $hItem > 0 Then _SendMessage($hWnd, $TVM_ENSUREVISIBLE, 0, $hItem, 0, "wparam", "handle")

	$hItem = _SendMessage($hWnd, $TVM_GETNEXTITEM, $TVGN_CHILD, $hItem, 0, "wparam", "handle")

	While $hItem <> 0x00000000
		Local $h_child = _SendMessage($hWnd, $TVM_GETNEXTITEM, $TVGN_CHILD, $hItem, 0, "wparam", "handle")
		If $h_child <> 0x00000000 Then __GUICtrlTreeView_ExpandItem($hWnd, $iExpand, $hItem)
		$hItem = _SendMessage($hWnd, $TVM_GETNEXTITEM, $TVGN_NEXT, $hItem, 0, "wparam", "handle")
	WEnd
EndFunc   ;==>__GUICtrlTreeView_ExpandItem
Func __GUICtrlTreeView_GetItem($hWnd, ByRef $tItem)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Local $fUnicode = _GUICtrlTreeView_GetUnicodeFormat($hWnd)

	Local $pItem = DllStructGetPtr($tItem)
	Local $iRet
	If IsHWnd($hWnd) Then
		If _WinAPI_InProcess($hWnd, $__ghTVLastWnd) Then
			$iRet = _SendMessage($hWnd, $TVM_GETITEMW, 0, $pItem, 0, "wparam", "ptr")
		Else
			Local $iItem = DllStructGetSize($tItem)
			Local $tMemMap
			Local $pMemory = _MemInit($hWnd, $iItem, $tMemMap)
			_MemWrite($tMemMap, $pItem)
			If $fUnicode Then
				$iRet = _SendMessage($hWnd, $TVM_GETITEMW, 0, $pMemory, 0, "wparam", "ptr")
			Else
				$iRet = _SendMessage($hWnd, $TVM_GETITEMA, 0, $pMemory, 0, "wparam", "ptr")
			EndIf
			_MemRead($tMemMap, $pMemory, $pItem, $iItem)
			_MemFree($tMemMap)
		EndIf
	Else
		If $fUnicode Then
			$iRet = GUICtrlSendMsg($hWnd, $TVM_GETITEMW, 0, $pItem)
		Else
			$iRet = GUICtrlSendMsg($hWnd, $TVM_GETITEMA, 0, $pItem)
		EndIf
	EndIf
	Return $iRet <> 0
EndFunc   ;==>__GUICtrlTreeView_GetItem
Func _GUICtrlTreeView_HitTestEx($hWnd, $iX, $iY)
	If $Debug_TV Then __UDF_ValidateClassName($hWnd, $__TREEVIEWCONSTANT_ClassName)

	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Local $tHitTest = DllStructCreate($tagTVHITTESTINFO)
	Local $pHitTest = DllStructGetPtr($tHitTest)
	DllStructSetData($tHitTest, "X", $iX)
	DllStructSetData($tHitTest, "Y", $iY)
	If _WinAPI_InProcess($hWnd, $__ghTVLastWnd) Then
		_SendMessage($hWnd, $TVM_HITTEST, 0, $pHitTest, 0, "wparam", "ptr")
	Else
		Local $iHitTest = DllStructGetSize($tHitTest)
		Local $tMemMap
		Local $pMemory = _MemInit($hWnd, $iHitTest, $tMemMap)
		_MemWrite($tMemMap, $pHitTest)
		_SendMessage($hWnd, $TVM_HITTEST, 0, $pMemory, 0, "wparam", "ptr")
		_MemRead($tMemMap, $pMemory, $pHitTest, $iHitTest)
		_MemFree($tMemMap)
	EndIf
	Return $tHitTest
EndFunc   ;==>_GUICtrlTreeView_HitTestEx
Func __GUICtrlTreeView_SetItem($hWnd, ByRef $tItem)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Local $fUnicode = _GUICtrlTreeView_GetUnicodeFormat($hWnd)

	Local $pItem = DllStructGetPtr($tItem)
	Local $iRet
	If _WinAPI_InProcess($hWnd, $__ghTVLastWnd) Then
		$iRet = _SendMessage($hWnd, $TVM_SETITEMW, 0, $pItem, 0, "wparam", "ptr")
	Else
		Local $iItem = DllStructGetSize($tItem)
		Local $tMemMap
		Local $pMemory = _MemInit($hWnd, $iItem, $tMemMap)
		_MemWrite($tMemMap, $pItem)
		If $fUnicode Then
			$iRet = _SendMessage($hWnd, $TVM_SETITEMW, 0, $pMemory, 0, "wparam", "ptr")
		Else
			$iRet = _SendMessage($hWnd, $TVM_SETITEMA, 0, $pMemory, 0, "wparam", "ptr")
		EndIf
		_MemFree($tMemMap)
	EndIf
	Return $iRet <> 0
EndFunc   ;==>__GUICtrlTreeView_SetItem
Func _GUICtrlTreeView_GetUnicodeFormat($hWnd)
	If $Debug_TV Then __UDF_ValidateClassName($hWnd, $__TREEVIEWCONSTANT_ClassName)

	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Return _SendMessage($hWnd, $TVM_GETUNICODEFORMAT) <> 0
EndFunc   ;==>_GUICtrlTreeView_GetUnicodeFormat
Func _WinAPI_ClientToScreen($hWnd, ByRef $tPoint)
	Local $pPoint = DllStructGetPtr($tPoint)
	DllCall("user32.dll", "bool", "ClientToScreen", "hwnd", $hWnd, "ptr", $pPoint)
	Return SetError(@error, @extended, $tPoint)
EndFunc   ;==>_WinAPI_ClientToScreen
Func _WinAPI_GetXYFromPoint(ByRef $tPoint, ByRef $iX, ByRef $iY)
	$iX = DllStructGetData($tPoint, "X")
	$iY = DllStructGetData($tPoint, "Y")
EndFunc   ;==>_WinAPI_GetXYFromPoint
Func _WinAPI_PointFromRect(ByRef $tRect, $fCenter = True)
	Local $iX1 = DllStructGetData($tRect, "Left")
	Local $iY1 = DllStructGetData($tRect, "Top")
	Local $iX2 = DllStructGetData($tRect, "Right")
	Local $iY2 = DllStructGetData($tRect, "Bottom")
	If $fCenter Then
		$iX1 = $iX1 + (($iX2 - $iX1) / 2)
		$iY1 = $iY1 + (($iY2 - $iY1) / 2)
	EndIf
	Local $tPoint = DllStructCreate($tagPOINT)
	DllStructSetData($tPoint, "X", $iX1)
	DllStructSetData($tPoint, "Y", $iY1)
	Return $tPoint
EndFunc   ;==>_WinAPI_PointFromRect
Func _WinAPI_ShowCursor($fShow)
	Local $aResult = DllCall("user32.dll", "int", "ShowCursor", "bool", $fShow)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aResult[0]
EndFunc   ;==>_WinAPI_ShowCursor
Func _WinAPI_GetLastErrorMessage()
    Local $tBufferPtr = DllStructCreate("ptr")
	Local $pBufferPtr = DllStructGetPtr($tBufferPtr)

	Local $nCount = _WinAPI_FormatMessage(BitOR($__WINAPICONSTANT_FORMAT_MESSAGE_ALLOCATE_BUFFER, $__WINAPICONSTANT_FORMAT_MESSAGE_FROM_SYSTEM), _
		0, _WinAPI_GetLastError(), 0, $pBufferPtr, 0, 0)
    If @error Then Return SetError(@error, 0, "")

     Local $sText = ""
    Local $pBuffer = DllStructGetData($tBufferPtr, 1)
    If $pBuffer Then
        If $nCount > 0 Then
            Local $tBuffer = DllStructCreate("wchar[" & ($nCount+1) & "]", $pBuffer)
            $sText = DllStructGetData($tBuffer, 1)
        EndIf
        _WinAPI_LocalFree($pBuffer)
    EndIf

    Return $sText
EndFunc   ;==>_WinAPI_GetLastErrorMessage
Func _WinAPI_FormatMessage($iFlags, $pSource, $iMessageID, $iLanguageID, ByRef $pBuffer, $iSize, $vArguments)
	Local $sBufferType = "ptr"
	If IsString($pBuffer) Then $sBufferType = "wstr"
	Local $aResult = DllCall("Kernel32.dll", "dword", "FormatMessageW", "dword", $iFlags, "ptr", $pSource, "dword", $iMessageID, "dword", $iLanguageID, _
			$sBufferType, $pBuffer, "dword", $iSize, "ptr", $vArguments)
	If @error Then Return SetError(@error, @extended, 0)
	If $sBufferType = "wstr" Then $pBuffer = $aResult[5]
	Return $aResult[0]
EndFunc   ;==>_WinAPI_FormatMessage
Func _WinAPI_LocalFree($hMem)
	Local $aResult = DllCall("kernel32.dll", "handle", "LocalFree", "handle", $hMem)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0]
EndFunc   ;==>_WinAPI_LocalFree