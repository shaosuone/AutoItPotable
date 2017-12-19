#include <GuiMenu.au3>

_Main()

Func _Main()
	Local $hWnd, $hMain, $hFile

	; �򿪼��±�
	Run("notepad.exe")
	WinWaitActive("[CLASS:Notepad]")
	$hWnd = WinGetHandle("[CLASS:Notepad]")
	$hMain = _GUICtrlMenu_GetMenu($hWnd)
	$hFile = _GUICtrlMenu_GetItemSubMenu($hMain, 0)

	; Check Open menu item
	Writeln("Open is checked: " & _GUICtrlMenu_GetItemChecked($hFile, 1))
	_GUICtrlMenu_SetItemChecked($hFile, 1)
	Writeln("Open is checked: " & _GUICtrlMenu_GetItemChecked($hFile, 1))

EndFunc   ;==>_Main

; д��һ���ı������±�
Func Writeln($sText)
	ControlSend("[CLASS:Notepad]", "", "Edit1", $sText & @CR)
EndFunc   ;==>Writeln