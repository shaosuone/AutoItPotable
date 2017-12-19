#include<GDIPlus.au3>
#include"Resources.au3"
#include<Timers.au3>
#include<WinAPI.au3>
#include<GUIConstantsEx.au3>
#include<WindowsConstants.au3>
#include<Constants.au3>
#include<Memory.au3>
#include<MemoryConstants.au3>
#include<StaticConstants.au3>
#include<StructureConstants.au3>

Global Const $GIF_CTRL_ARRAY_ENTRYS = 12
Global $GIF_CTRL_ARRAY[1][$GIF_CTRL_ARRAY_ENTRYS]
Global Const $GIF_TIMER_INIT_VALUE = 1000
Global Const $tagPropertyItem = "long id; long length; int Type; ptr value"
Global Const $PropertyTagFrameDelay = 0x5100
Global Const $PropertyTagLoopCount = 0x5101
Global Const $PropertyTagTypeByte = 1
Global Const $PropertyTagTypeASCII = 2
Global Const $PropertyTagTypeShort = 3
Global Const $PropertyTagTypeLong = 4
Global Const $PropertyTagTypeRational = 5
Global Const $PropertyTagTypeUndefined = 7
Global Const $PropertyTagTypeSLong = 9
Global Const $PropertyTagTypeSRational = 10
Global Const $GIFopt_AUTOPLAY = 1
Global Const $GIFopt_PROPOPRTIONAL = 2
Global Const $GIFopt_DONTRESIZESMALLER = 4
Global $_Timers_aTimerIDs[1][3]
;===============================================================================
;
; Function Name:   _GuiCtrlGifAnimated_Create()
; Description::    Creates an animated GIF in you GUI
; Parameter(s):    $filename  -> Name of GIF, can be "" -> empty Control created
;                  $left      -> The left side of the control. If -1 is used then
;                                left will be computed according to GUICoordMode.
;                  $top       -> The top of the control. If -1 is used then top
;                                will be computed according to GUICoordMode.
;                  $width     -> [optional] The width of the control,
;                                if not given, The size of the image is used
;                  $height    -> [optional] The height of the control,
;                                if not given, The size of the image is used
;                          then, the other parameter is computed by the given one
;                  $Options   -> Options for the GIF:
;                                 1 - Start the GIF automatically
;                                 2 - Size it proportional to given sizes
;                                 4 - Don't resize GIF, if it is smaller than the given values
;                  $style     -> [optional] Defines the style of the control.
;                  $exStyle   -> [optional] Defines the extended style of the control.
; Requirement(s):  GDIplus, Timers
; Return Value(s): ID of the Control
; Author(s):       Prog@ndy, with Code from Zedna and smashly (both autoitscript.com)
;
; Remarks:         MUST BE DELETED WITH _GuiCtrlGifAnimated_Delete
;                  or _GuiCtrlGifAnimated_DeleteAll
;===============================================================================

Func _GuiCtrlGifAnimated_Create($filename, $left, $top, $width = Default, $height = Default, $Options = 1, $style = -1, $exStyle = -1)
    Local $iIndex = $GIF_CTRL_ARRAY[0][0] + 1
    ReDim $GIF_CTRL_ARRAY[$iIndex + 1][$GIF_CTRL_ARRAY_ENTRYS]
    $GIF_CTRL_ARRAY[0][0] = $iIndex
    Local $iCtrl = GUICtrlCreateLabel("", $left, $top, $width, $height, $style, $exStyle) 
    GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
    $GIF_CTRL_ARRAY[$iIndex][0] = $iCtrl 
    If $filename <> "" Then
        _GuiCtrlGifAnimated_SetImage($iCtrl, $filename, $Options, $width, $height)
        If @error Then
            Local $error = @error
            GUICtrlDelete($iCtrl)
            ReDim $GIF_CTRL_ARRAY[$iIndex][$GIF_CTRL_ARRAY_ENTRYS]
            $GIF_CTRL_ARRAY[0][0] -= 1
            Return SetError($error, 0, 0)
        EndIf
    EndIf

    Return $iCtrl
EndFunc ;==> _GuiCtrlGifAnimated_Create

;===============================================================================
;
; Function Name:   _GuiCtrlGifAnimated_GetProperty()
; Description::    Gets properties of a GIF-Control
; Parameter(s):    $iCtrl     -> ID of GIF-Control
;                  $Property  -> The Property to read. Possible Values:
;                         playing     - paused or animating
;                         totalframes - Amount of frames
;                         frame       - current frame
;                         totalloops  - how often should it be repeated? 0=infinite
;                         loops       - The amount of completed loops
;                         framedelays - The delays for all frames
;                         framedelay;0 - an extended property:
;                             framedelay -> the property name
;                             ; -> separator
;                             0 -> the number of the frame to get the delay for
; Requirement(s):  This UDf
; Return Value(s): ID of the Control
; Author(s):       Prog@ndy, with Code from Zedna and smashly (both autoitscript.com)
;
;===============================================================================

Func _GuiCtrlGifAnimated_GetProperty($iCtrl, $Property = "playing")
    Local $iIndex = __GuiCtrlGifAnimated_GetIndexbyGUICtrl($iCtrl)
    If @error Then Return SetError(1, 0, 0)
    Switch StringLower($Property)
        Case "playing"
            Return $GIF_CTRL_ARRAY[$iIndex][9] > 0
        Case "totalframes"
            Return $GIF_CTRL_ARRAY[$iIndex][3]
        Case "frame"
            Return $GIF_CTRL_ARRAY[$iIndex][2]
        Case "totalloops"
            Return $GIF_CTRL_ARRAY[$iIndex][5]
        Case "loops"
            Return $GIF_CTRL_ARRAY[$iIndex][6]
        Case "framedelays"
            Return $GIF_CTRL_ARRAY[$iIndex][4]
        Case Else
            If StringLeft($Property, 11) = "framedelay;" Then
                Local $Frame = Number(StringTrimLeft($Property, 11)), $FrameDelays = $GIF_CTRL_ARRAY[$iIndex][4]
                If UBound($FrameDelays) < $Frame And $Frame > 0 Then Return $FrameDelays[$Frame]
                Return SetError(3, 0, -1)
            EndIf
    EndSwitch
    Return SetError(2, 0, "")
EndFunc ;==> _GuiCtrlGifAnimated_GetProperty

;===============================================================================
;
; Function Name:   _GuiCtrlGifAnimated_SetImage()
; Description::    Sets the image of a GIF-Control
; Parameter(s):    $iCtrl     -> ID of GIF-Control
;                  $filename  -> Name of GIF
;                  $Options   -> Options for the GIF:
;                                 1 - Start the GIF automatically
;                                 2 - Size it proportional to given sizes
;                                 4 - Don't resize GIF, if it is smaller than the given values
;                  $width     -> [optional] The width of the control,
;                                if not given, The size of the image is used
;                  $height    -> [optional] The height of the control,
;                                if not given, The size of the image is used
;                          then, the other parameter is computed by the given one
; Requirement(s):  GDIplus, Timers
; Return Value(s): ID of the Control
; Author(s):       Prog@ndy, with Code from Zedna and smashly (both autoitscript.com)
;
;===============================================================================

Func _GuiCtrlGifAnimated_SetImage($iCtrl, $filename, $Options = 1, $width = Default, $height = Default)
    Local $hImage = _GDIPlus_ImageLoadFromFile($filename)
    If @error Then Return SetError(2, 0, 0)
    _GuiCtrlGifAnimated_SetGDIpImage($iCtrl, $hImage, $Options, $width, $height)
    If @error Then
        _GDIPlus_ImageDispose($hImage)
        Return SetError(1, 0, 0)
    EndIf
    Return 1
EndFunc ;==> _GuiCtrlGifAnimated_SetImage

;===============================================================================
;
; Function Name:   _GuiCtrlGifAnimated_Delete()
; Description::    deletes a GIF-Control
; Parameter(s):    $iCtrl     -> ID of GIF-Control
; Requirement(s):  GDIPlus, Timers
; Return Value(s): Success: true, otherwise false
; Author(s):       Prog@ndy, with Code from Zedna and smashly (both autoitscript.com)
;
;===============================================================================

Func _GuiCtrlGifAnimated_Delete($iCtrl)
    Local $iIndex = __GuiCtrlGifAnimated_GetIndexbyGUICtrl($iCtrl)
    If @error Then Return SetError(1, 0, 0)
    If $GIF_CTRL_ARRAY[$iIndex][9] Then _Timer_KillTimer(_WinAPI_GetParent($GIF_CTRL_ARRAY[$iIndex][8]), $GIF_CTRL_ARRAY[$iIndex][7])
    _GDIPlus_ImageDispose($GIF_CTRL_ARRAY[$iIndex][1])
    GUICtrlDelete($iCtrl)
    For $i = $iIndex To UBound($GIF_CTRL_ARRAY) - 2
        For $j = 0 To $GIF_CTRL_ARRAY_ENTRYS - 1
            $GIF_CTRL_ARRAY[$i][$j] = $GIF_CTRL_ARRAY[$i + 1][$j]
        Next
    Next
    ReDim $GIF_CTRL_ARRAY[$GIF_CTRL_ARRAY[0][0]][$GIF_CTRL_ARRAY_ENTRYS]
    $GIF_CTRL_ARRAY[0][0] -= 1
EndFunc ;==> _GuiCtrlGifAnimated_Delete

;===============================================================================
;
; Function Name:   _GuiCtrlGifAnimated_Stop()
; Description::    Stops animation of a GIF-Control (sets loopcounter to 0)
; Parameter(s):    $iCtrl     -> ID of GIF-Control
; Requirement(s):  GDIPlus, Timers
; Return Value(s): Success: true, otherwise false
;                  if already stopped: True with @error = -1
; Author(s):       Prog@ndy
;
;===============================================================================

Func _GuiCtrlGifAnimated_Stop($iCtrl)
    Local $iIndex = __GuiCtrlGifAnimated_GetIndexbyGUICtrl($iCtrl)
    If @error Then Return SetError(1, 0, 0)
    Local $iOK = _GuiCtrlGifAnimated_Pause($iCtrl)
    Local $error = @error
    _GIFAni_SetFrameToCtrl($GIF_CTRL_ARRAY[$iIndex][8], $GIF_CTRL_ARRAY[$iIndex][1], $GIF_CTRL_ARRAY[$iIndex][11], 0)
    $GIF_CTRL_ARRAY[$iIndex][2] = 0
    $GIF_CTRL_ARRAY[$iIndex][6] = 0
    Return SetError($error, 0, $iOK)
EndFunc ;==> _GuiCtrlGifAnimated_Stop

;===============================================================================
;
; Function Name:   _GuiCtrlGifAnimated_Next()
; Description::    Steps to the next frame
; Parameter(s):    $iCtrl     -> ID of GIF-Control
;                  $JumpToStart -> [optional] If the Animation is at the end,
;                                  go to start again ( default: false )
; Requirement(s):  GDIPlus, Timers
; Return Value(s): Success: true, otherwise false
;                  if jumped to start: True with @error = -1
; Author(s):       Prog@ndy
;
;===============================================================================

Func _GuiCtrlGifAnimated_Next($iCtrl, $JumpToStart = False)
    Local $iIndex = __GuiCtrlGifAnimated_GetIndexbyGUICtrl($iCtrl)
    If @error Then Return SetError(1, 0, 0)
    If $GIF_CTRL_ARRAY[$iIndex][2] + 1 < $GIF_CTRL_ARRAY[$iIndex][3] Then
        $GIF_CTRL_ARRAY[$iIndex][2] += 1
        _GIFAni_SetFrameToCtrl($GIF_CTRL_ARRAY[$iIndex][8], $GIF_CTRL_ARRAY[$iIndex][1], $GIF_CTRL_ARRAY[$iIndex][11], $GIF_CTRL_ARRAY[$iIndex][2])
        Return 1
    ElseIf $JumpToStart Then
        $GIF_CTRL_ARRAY[$iIndex][2] = 0
        _GIFAni_SetFrameToCtrl($GIF_CTRL_ARRAY[$iIndex][8], $GIF_CTRL_ARRAY[$iIndex][1], $GIF_CTRL_ARRAY[$iIndex][11], $GIF_CTRL_ARRAY[$iIndex][2])
        Return SetError(-1, 0, 1)
    EndIf
    Return SetError(2, 0, 0)
EndFunc ;==> _GuiCtrlGifAnimated_Next

;===============================================================================
;
; Function Name:   _GuiCtrlGifAnimated_Prev()
; Description::    Steps to the previous frame
; Parameter(s):    $iCtrl     -> ID of GIF-Control
;                  $JumpToStart -> [optional] If the Animation is at the beginning,
;                                  go to end ( default: false )
; Requirement(s):  GDIPlus, Timers
; Return Value(s): Success: true, otherwise false
;                  if jumped to end: True with @error = -1
; Author(s):       Prog@ndy
;
;===============================================================================

Func _GuiCtrlGifAnimated_Prev($iCtrl, $JumpToEnd = False)
    Local $iIndex = __GuiCtrlGifAnimated_GetIndexbyGUICtrl($iCtrl)
    If @error Then Return SetError(1, 0, 0)
    If $GIF_CTRL_ARRAY[$iIndex][2] - 1 >= 0 Then
        $GIF_CTRL_ARRAY[$iIndex][2] -= 1
        _GIFAni_SetFrameToCtrl($GIF_CTRL_ARRAY[$iIndex][8], $GIF_CTRL_ARRAY[$iIndex][1], $GIF_CTRL_ARRAY[$iIndex][11], $GIF_CTRL_ARRAY[$iIndex][2])
        Return 1
    ElseIf $JumpToEnd Then
        $GIF_CTRL_ARRAY[$iIndex][2] = $GIF_CTRL_ARRAY[$iIndex][3] - 1
        _GIFAni_SetFrameToCtrl($GIF_CTRL_ARRAY[$iIndex][8], $GIF_CTRL_ARRAY[$iIndex][1], $GIF_CTRL_ARRAY[$iIndex][11], $GIF_CTRL_ARRAY[$iIndex][2])
        Return SetError(-1, 0, 1)
    EndIf
    Return SetError(2, 0, 0)
EndFunc ;==> _GuiCtrlGifAnimated_Prev

;===============================================================================
;
; Function Name:   _GuiCtrlGifAnimated_pause()
; Description::    Pauses the animation ( saves frame + loopcount)
; Parameter(s):    $iCtrl     -> ID of GIF-Control
; Requirement(s):  GDIPlus, Timers
; Return Value(s): Success: true, otherwise false
; Author(s):       Prog@ndy
;
;===============================================================================

Func _GuiCtrlGifAnimated_Pause($iCtrl)
    Local $iIndex = __GuiCtrlGifAnimated_GetIndexbyGUICtrl($iCtrl)
    If @error Then Return SetError(1, 0, 0)
    If $GIF_CTRL_ARRAY[$iIndex][9] = 0 Then Return SetError(-1, 0, 1)
    Local $iOK = _Timer_KillTimer(_WinAPI_GetParent($GIF_CTRL_ARRAY[$iIndex][8]), $GIF_CTRL_ARRAY[$iIndex][7])
    If $iOK Then $GIF_CTRL_ARRAY[$iIndex][9] = 0
    Return SetError($iOK = 0, 0, $iOK)
EndFunc ;==> _GuiCtrlGifAnimated_Pause

;===============================================================================
;
; Function Name:   _GuiCtrlGifAnimated_Resume()
; Description::    Same as _GuiCtrlGifAnimated_Play
; Author(s):       Prog@ndy
;
;===============================================================================

Func _GuiCtrlGifAnimated_Resume($iCtrl)
    Local $iOK = _GuiCtrlGifAnimated_Play($iCtrl)
    Return SetError(@error, 0, $iOK)
EndFunc ;==> _GuiCtrlGifAnimated_Resume

;===============================================================================
;
; Function Name:   _GuiCtrlGifAnimated_Play()
; Description::    Continues animation after Pause or Stop
; Parameter(s):    $iCtrl     -> ID of GIF-Control
; Requirement(s):  GDIPlus, Timers
; Return Value(s): Success: true, otherwise false
;                   @error = 1 if Control does not exist
; Author(s):       Prog@ndy
;
;===============================================================================

Func _GuiCtrlGifAnimated_Play($iCtrl)
    Local $iIndex = __GuiCtrlGifAnimated_GetIndexbyGUICtrl($iCtrl)
    If @error Then Return SetError(1, 0, 0)
    If $GIF_CTRL_ARRAY[$iIndex][9] > 0 Then Return SetError(-1, 0, 1)
    $GIF_CTRL_ARRAY[$iIndex][9] = _Timer_SetTimerEx(_WinAPI_GetParent($GIF_CTRL_ARRAY[$iIndex][8]), 100, "_GIFAni_Draw_TimerFunc", $GIF_CTRL_ARRAY[$iIndex][7]); Start Animation
    Return $GIF_CTRL_ARRAY[$iIndex][9] > 0
EndFunc ;==> _GuiCtrlGifAnimated_Play

;===============================================================================
;
; Function Name:   _GuiCtrlGifAnimated_DeleteAll()
; Description::    Deletes all GIF-Controls, use e.g. when termainating Script.
; Parameter(s):    none
; Requirement(s):  GDIPlus, Timers
; Return Value(s): Success: true, otherwise false
; Author(s):       Prog@ndy
;
;===============================================================================

Func _GuiCtrlGifAnimated_DeleteAll()
    Local $iIndex
    For $iIndex = 1 To $GIF_CTRL_ARRAY[0][0]
        If $GIF_CTRL_ARRAY[$iIndex][9] Then _Timer_KillTimer(_WinAPI_GetParent($GIF_CTRL_ARRAY[$iIndex][8]), $GIF_CTRL_ARRAY[$iIndex][7])
        _GDIPlus_ImageDispose($GIF_CTRL_ARRAY[$iIndex][1])
        GUICtrlDelete($GIF_CTRL_ARRAY[$iIndex][0])
    Next
    Global $GIF_CTRL_ARRAY[1][$GIF_CTRL_ARRAY_ENTRYS] = [[0]]
EndFunc ;==> _GuiCtrlGifAnimated_DeleteAll

;===============================================================================
;
; Function Name:  _GuiCtrlGifAnimated_SetGDIpImage()
; Description::    Sets the image of a GIF-Control
; Parameter(s):    $iCtrl     -> ID of GIF-Control
;                  $$hImage   -> handle of GDIplus_Image
;                  $Options   -> Options for the GIF:
;                                 1 - Start the GIF automatically
;                                 2 - Size it proportional to given sizes
;                                 4 - Don't resize GIF, if it is smaller than the given values
;                  $width     -> [optional] The width of the control,
;                                if not given, The size of the image is used
;                  $height    -> [optional] The height of the control,
;                                if not given, The size of the image is used
;                          then, the other parameter is computed by the given one
; Requirement(s):  GDIplus, Timers
; Return Value(s): ID of the Control
; Author(s):       Prog@ndy, with Code from Zedna and smashly (both autoitscript.com)
;
; INTERNAL USE ONLY
;
;===============================================================================

Func _GuiCtrlGifAnimated_SetGDIpImage($iCtrl, ByRef $hImage, $Options = 1, $width = Default, $height = Default)
    Local $iIndex = __GuiCtrlGifAnimated_GetIndexbyGUICtrl($iCtrl)
    If @error Then Return SetError(1, 0, 0)
    Local $ApW = _GDIPlus_ImageGetWidth($hImage) * 1
    Local $ApH = _GDIPlus_ImageGetHeight($hImage) * 1
    If BitAND($Options, $GIFopt_DONTRESIZESMALLER) = $GIFopt_DONTRESIZESMALLER And _
            $width > $ApW And $height > $ApH Then
        $width = Default
        $height = Default
    EndIf
    If $width = Default Or $width < 1 Then $width = $ApW
    If $height = Default Or $height < 1 Then $height = $ApH
    If BitAND($Options, $GIFopt_PROPOPRTIONAL) = $GIFopt_PROPOPRTIONAL Then
        Local $PROPwidth = Int($ApW * $height / $ApH)
        Local $PROPheight = Int($ApH * $width / $ApW)
        Switch ($PROPwidth > $width)
            Case True
                $height = $PROPheight
            Case False
                $width = $PROPwidth
        EndSwitch
    EndIf
    Local $GFDC = DllCall($__g_hGDIPDll, "int", "GdipImageGetFrameDimensionsCount", "ptr", $hImage, "int*", 0)
    If $GFDC[2] = 0 Then Return SetError(2, 0, 0)
    Local $tagGUIDArr
    For $i = 1 To $GFDC[2]
        $tagGUIDArr &= $tagGUID & ";"
    Next
    Local $tDL = DllStructCreate($tagGUIDArr)
    Local $pDimensionIDs = DllStructGetPtr($tDL)
    DllCall($__g_hGDIPDll, "int", "GdipImageGetFrameDimensionsList", "ptr", $hImage, "ptr", $pDimensionIDs, "int", $GFDC[2])
    Local $GFC = DllCall($__g_hGDIPDll, "int", "GdipImageGetFrameCount", "int", $hImage, "ptr", $pDimensionIDs, "int*", 0)
    $GFC = $GFC[3]
    If $GFC = 0 Then Return SetError(3, 0, 0)
    Local $FrameDelays = _GDIplus_GetFrameDelays($hImage, $GFC)
    Local $LoopCount = _GDIplus_GetGifLoopCount($hImage)
    GUICtrlSetPos($iCtrl, Default, Default, $width, $height) 
    If $GIF_CTRL_ARRAY[$iIndex][9] Then _Timer_KillTimer(_WinAPI_GetParent($GIF_CTRL_ARRAY[$iIndex][8]), $GIF_CTRL_ARRAY[$iIndex][7])
    If $GIF_CTRL_ARRAY[$iIndex][1] > 0 Then _GDIPlus_ImageDispose($GIF_CTRL_ARRAY[$iIndex][1])
    Local $hBitmap = _GDIPlus_BitmapCreateHBITMAPFromBitmap($hImage)
    _GIFAni_SetBitmapToCtrl($iCtrl, $hBitmap, 1, 1)
    _WinAPI_DeleteObject($hBitmap)
    $GIF_CTRL_ARRAY[$iIndex][0] = $iCtrl 
    $GIF_CTRL_ARRAY[$iIndex][1] = $hImage
    $GIF_CTRL_ARRAY[$iIndex][2] = 0 
    $GIF_CTRL_ARRAY[$iIndex][3] = $GFC 
    $GIF_CTRL_ARRAY[$iIndex][4] = $FrameDelays
    $GIF_CTRL_ARRAY[$iIndex][5] = $LoopCount
    $GIF_CTRL_ARRAY[$iIndex][6] = 0 
    $GIF_CTRL_ARRAY[$iIndex][7] = $GIF_TIMER_INIT_VALUE + $iCtrl 
    $GIF_CTRL_ARRAY[$iIndex][8] = GUICtrlGetHandle($iCtrl) 
    $GIF_CTRL_ARRAY[$iIndex][10] = $tDL
    $GIF_CTRL_ARRAY[$iIndex][11] = $pDimensionIDs
    If BitAND($Options, 1) = 1 Then $GIF_CTRL_ARRAY[$iIndex][9] = _Timer_SetTimerEx(_WinAPI_GetParent($GIF_CTRL_ARRAY[$iIndex][8]), 100, "_GIFAni_Draw_TimerFunc", $GIF_CTRL_ARRAY[$iIndex][7]); Start Animation
    Return 1
EndFunc ;==> _GuiCtrlGifAnimated_SetGDIpImage

;===============================================================================
;
; Function Name:   _GIFAni_Draw_TimerFunc
; Author(s):       Prog@ndy, with Code from Zedna and smashly (both autoitscript.com)
;
; INTERNAL USE ONLY
;
;===============================================================================

Func _GIFAni_Draw_TimerFunc($hWnd, $Msg, $iIDTimer, $dwTime)
    Local $iIndex, $LoopCount, $MadeLoops, $FrameCount, $Frame, $FrameDelays
    Local $iCtrl
    For $i = 1 To $GIF_CTRL_ARRAY[0][0]
        If $GIF_CTRL_ARRAY[$i][9] = $iIDTimer Then
            $iCtrl = $GIF_CTRL_ARRAY[$i][0]
            $iIndex = $i
            ExitLoop
        EndIf
    Next
    If $iIndex = 0 Then Return
    $LoopCount = $GIF_CTRL_ARRAY[$iIndex][5]
    $MadeLoops = $GIF_CTRL_ARRAY[$iIndex][6]
    $FrameCount = $GIF_CTRL_ARRAY[$iIndex][3]
    $FrameDelays = $GIF_CTRL_ARRAY[$iIndex][4]
    If $LoopCount = 0 Or ($LoopCount > $MadeLoops) Then
        $Frame = $GIF_CTRL_ARRAY[$iIndex][2] + 1
        If $Frame = $FrameCount Then $Frame = 0
        $GIF_CTRL_ARRAY[$iIndex][2] = $Frame
        If UBound($FrameDelays) > $Frame And $FrameDelays[$Frame] > 0 Then
            _Timer_SetTimerEx($hWnd, $FrameDelays[$i], "_GIFAni_Draw_TimerFunc", $iIDTimer)
        Else
            _Timer_SetTimerEx($hWnd, 100, "_GIFAni_Draw_TimerFunc", $iIDTimer)
        EndIf
        _GIFAni_SetFrameToCtrl($GIF_CTRL_ARRAY[$iIndex][8], $GIF_CTRL_ARRAY[$iIndex][1], $GIF_CTRL_ARRAY[$iIndex][11], $Frame)
        If $Frame = ($FrameCount - 1) Then $GIF_CTRL_ARRAY[$iIndex][6] += 1
    Else
        _Timer_KillTimer($hWnd, $iIDTimer)
    EndIf
EndFunc ;==> _GIFAni_Draw_TimerFunc

;===============================================================================
;
; Function Name:   _GDIplus_GetFrameDelays
; Author(s):       Prog@ndy (converted from VB smile.gif )
; VB-Source: http://www.activevb.de/tipps/vb6tipps/tipp0675.html
; INTERNAL USE ONLY
;
;===============================================================================

Func _GDIplus_GetFrameDelays(ByRef $hImage, $FrameCount)
    If $FrameCount = 0 Then Return SetError(1, 0, 0)
    Local $lOutFrameDelay[$FrameCount]
    Local $lSize 
    Local $PropID = $PropertyTagFrameDelay
    If Not _GDIplus_CheckForProperty($hImage, $PropID) Then Return SetError(1, 0, 0)
    Local $PropertySize = DllCall($__g_hGDIPDll, "int", "GdipGetPropertyItemSize", "ptr", $hImage, "dword", $PropID, "uint*", 0)
    If $PropertySize[0] = 0 Then
       Local $tPropItem = DllStructCreate($tagPropertyItem & ";byte[" & $PropertySize[3] & "]")
        Local $PropertyItem = DllCall($__g_hGDIPDll, "int", "GdipGetPropertyItem", "ptr", $hImage, "dword", $PropID, "dword", $PropertySize[3], "ptr", DllStructGetPtr($tPropItem))
        If $PropertyItem[0] <> 0 Then Return SetError(1, 0, 0)
        $lSize = DllStructGetData($tPropItem, "length")
        Switch DllStructGetData($tPropItem, "Type")
            Case $PropertyTagTypeByte
                 Local $lProp = DllStructCreate("byte[" & $lSize & "]", DllStructGetData($tPropItem, "value"))
            Case $PropertyTagTypeShort
                 Local $lProp = DllStructCreate("short[" & Ceiling($lSize / 2) & "]", DllStructGetData($tPropItem, "value"))
            Case $PropertyTagTypeLong
                Local $lProp = DllStructCreate("long[" & Ceiling($lSize / 4) & "]", DllStructGetData($tPropItem, "value"))
        EndSwitch
        For $lPropCount = 0 To $FrameCount - 1
            $lOutFrameDelay[$lPropCount] = DllStructGetData($lProp, 1, $lPropCount + 1) * 10
        Next
    EndIf
    Return $lOutFrameDelay
EndFunc ;==> _GDIplus_GetFrameDelays

;===============================================================================
;
; Function Name:   _GDIplus_GetGifLoopCount
; Author(s):       Prog@ndy (converted from VB smile.gif )
; VB-Source: http://www.activevb.de/tipps/vb6tipps/tipp0675.html
; INTERNAL USE ONLY
;
; '------------------------------------------------------
; ' Funktion     : GetGifLoopCount
; ' Beschreibung : Auslesen der Wiederholungen
; ' Übergabewert : lInBitmap = GDI+ Bitmapobjekt
; '                lOutLoopCount = Anzahl der Wiederholungen
; '------------------------------------------------------
;===============================================================================

Func _GDIplus_GetGifLoopCount(ByRef $hImage)
    Local $tPropItem
    Local $lProp
    Local $lSize
    If _GDIplus_CheckForProperty($hImage, _
            $PropertyTagLoopCount) = True Then
        Local $PropertySize = DllCall($__g_hGDIPDll, "int", "GdipGetPropertyItemSize", "ptr", $hImage, "dword", $PropertyTagLoopCount, "uint*", 0)
        If $PropertySize[0] = 0 Then
            $tPropItem = DllStructCreate($tagPropertyItem & ";byte[" & $PropertySize[3] & "]")
            Local $PropertyItem = DllCall($__g_hGDIPDll, "int", "GdipGetPropertyItem", "ptr", $hImage, "dword", $PropertyTagLoopCount, "dword", $PropertySize[3], "ptr", DllStructGetPtr($tPropItem))
            If $PropertyItem[0] <> 0 Then Return SetError(1, 0, 0)
            $lSize = DllStructGetData($tPropItem, "length")
            Switch DllStructGetData($tPropItem, "Type")
                Case $PropertyTagTypeByte
                    $lProp = DllStructCreate("byte[" & $lSize & "]", DllStructGetData($tPropItem, "value"))
                Case $PropertyTagTypeShort
                    $lProp = DllStructCreate("short[" & Ceiling($lSize / 2) & "]", DllStructGetData($tPropItem, "value"))
                Case $PropertyTagTypeLong
                    $lProp = DllStructCreate("long[" & Ceiling($lSize / 4) & "]", DllStructGetData($tPropItem, "value"))
            EndSwitch
            Return DllStructGetData($lProp, 1, 1)
        EndIf
    Else
        Return 0
    EndIf
EndFunc ;==> _GDIplus_GetGifLoopCount

;===============================================================================
;
; Function Name:   _GDIplus_CheckForProperty
; Author(s):       Prog@ndy (converted from VB smile.gif )
; VB-Source: http://www.activevb.de/tipps/vb6tipps/tipp0675.html
; INTERNAL USE ONLY
;
; '------------------------------------------------------
; ' Funktion     : CheckLoopCount
; ' Beschreibung : Überprüft, ob der EXIF-Tag LoopCount
; '                vorhanden sind
; ' Übergabewert : lInBitmap = GDI+ Bitmapobjekt
; ' Rückgabewert : True = LoopCount vorhanden
; '                False = LoopCount nicht vorhanden
; '------------------------------------------------------
;===============================================================================

Func _GDIplus_CheckForProperty ( ByRef $hImage, $PropertyID )
    Local $lPropItem
    Local $lPropList
    Local $bRet = False
    Local $PropertyCount = DllCall($__g_hGDIPDll, "int", "GdipGetPropertyCount", "ptr", $hImage, "long*", 0)
    If $PropertyCount[0] = 0 Then
        If ($PropertyCount[2] > 0) Then
            Local $lPropList = DllStructCreate("dword[" & $PropertyCount[2] & "]")
            Local $PropertyList = DllCall($__g_hGDIPDll, "int", "GdipGetPropertyIdList", "ptr", $hImage, "long", $PropertyCount[2], "ptr", DllStructGetPtr($lPropList))
            If $PropertyList[0] = 0 Then
                For $lPropItem = 1 To $PropertyCount[2]
                    If DllStructGetData($lPropList, $lPropItem) = $PropertyID Then
                        $bRet = True
                        ExitLoop
                    EndIf
                Next
            EndIf
        EndIf
    EndIf
    Return $bRet
EndFunc ;==> _GDIplus_CheckForProperty

;===============================================================================
;
; Function Name:   _GIFAni_SetFrameToCtrl
; Author(s):       Prog@ndy, with Code from Zedna and smashly (both autoitscript.com)
;
; INTERNAL USE ONLY
;
;===============================================================================

Func _GIFAni_SetFrameToCtrl(ByRef $iCtrl, ByRef $hImage, ByRef $pDimensionIDs, $i)
    DllCall($__g_hGDIPDll, "int", "GdipImageSelectActiveFrame", "ptr", $hImage, "ptr", $pDimensionIDs, "int", $i)
    Local $hBitmap = _GDIPlus_BitmapCreateHBITMAPFromBitmap($hImage)
    _GIFAni_SetBitmapToCtrl($iCtrl, $hBitmap, 0)
    _WinAPI_DeleteObject($hBitmap)
EndFunc ;==> _GIFAni_SetFrameToCtrl

;===============================================================================
;
; Function Name:   _GIFAni_SetBitmapToCtrl(
; Author(s):       Prog@ndy, most Code from Zedna (autoitscript.com)
;
; INTERNAL USE ONLY
;
;===============================================================================

Func _GIFAni_SetBitmapToCtrl($CtrlId, $hBitmap, $SetStyle = 1, $Size2Ctrl = 0)
    Local Const $STM_SETIMAGE = 0x0172
    Local Const $IMAGE_BITMAP = 0
    Local Const $SS_BITMAP = 0xE
    Local Const $GWL_STYLE = -16
    Local Const $SS_REALSIZEIMAGE = 0x800
    Local Const $SS_REALSIZECONTROL = 0x40
    Local $hWnd = $CtrlId
    If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($CtrlId)
    If $hWnd = 0 Then Return SetError(1, 0, 0)
    If $SetStyle Then
        Local $oldStyle = DllCall("user32.dll", "long", "GetWindowLong", "hwnd", $hWnd, "int", $GWL_STYLE)
        If @error Then Return SetError(2, 0, 0)
        $oldStyle[0] = BitAND($oldStyle[0], BitNOT(BitOR($SS_REALSIZECONTROL, $SS_REALSIZEIMAGE)))
        If $Size2Ctrl Then
            $oldStyle[0] = BitOR($oldStyle[0], $SS_BITMAP, $SS_REALSIZECONTROL)
        Else
            $oldStyle[0] = BitOR($oldStyle[0], $SS_BITMAP, $SS_REALSIZEIMAGE)
        EndIf
        DllCall("user32.dll", "long", "SetWindowLong", "hwnd", $hWnd, "int", $GWL_STYLE, "long", $oldStyle[0])
        If @error Then Return SetError(3, 0, 0)
    EndIf
    Local $oldBmp = DllCall("user32.dll", "hwnd", "SendMessage", "hwnd", $hWnd, "int", $STM_SETIMAGE, "int", $IMAGE_BITMAP, "int", $hBitmap)
    If @error Then Return SetError(4, 0, 0)
    If $oldBmp[0] <> 0 Then _WinAPI_DeleteObject($oldBmp[0])
    Return 1
EndFunc ;==> _GIFAni_SetBitmapToCtrl

;===============================================================================
;
; Function Name:   __GuiCtrlGifAnimated_GetIndexbyGUICtrl
; Author(s):       Prog@ndy
;
; INTERNAL USE ONLY
;
;===============================================================================

Func __GuiCtrlGifAnimated_GetIndexbyGUICtrl(ByRef $iCtrl)
    Local $iIndex = 0
    For $i = 1 To $GIF_CTRL_ARRAY[0][0]
        If $GIF_CTRL_ARRAY[$i][0] = $iCtrl Then
            $iIndex = $i
            ExitLoop
        EndIf
    Next
    Return SetError($iIndex = 0, 0, $iIndex)
EndFunc ;==> __GuiCtrlGifAnimated_GetIndexbyGUICtrl

; #FUNCTION# ====================================================================================================================
; Name...........: _Timer_SetTimerEx
; Description ...: Creates a timer with the specified time-out value
; Syntax.........: _Timer_SetTimer($hWnd[, $iElapse = 250[, $sTimerFunc = ""[, $iTimerID = -1]]])
; Parameters ....: $hWnd        - Handle to the window to be associated with the timer.
;                  |This window must be owned by the calling thread
;                  $iElapse     - Specifies the time-out value, in milliseconds
;                  $sTimerFunc  - Function name to be notified when the time-out value elapses
;                  $iTimerID    - Specifies a timer identifier.
;                  |If $iTimerID = -1 then a new timer is created
;                  |If $iTimerID matches an existing timer then the timer is replaced
;                  |If $iTimerID matches no existing timer, a new timer is created smile.gif
;                  |If $iTimerID = -1 and $sTimerFunc = "" then timer will use WM_TIMER events
; Return values .: Success - Integer identifying the new timer
;                  Failure - 0
; Author ........: Gary Frost
;                  -Modifications: Prog@ndy
; Modified.......:
; Remarks .......:
; Related .......: _Timer_KillTimer, _Timer_KillAllTimers, _Timer_GetTimerID
; Link ..........; @@MsdnLink@@ SetTimer
; Example .......; Yes
; ===============================================================================================================================

Func _Timer_SetTimerEx($hWnd, $iElapse = 250, $sTimerFunc = "", $iTimerID = -1)
    Local $iResult[1], $pTimerFunc = 0, $hCallBack = 0, $iIndex = $_Timers_aTimerIDs[0][0] + 1, $Timer_Exists
    If $iTimerID > -1 Then
        For $x = 1 To $iIndex - 1
            If $_Timers_aTimerIDs[$x][0] = $iTimerID Then $Timer_Exists = 1
        Next
    EndIf
    If $iTimerID = -1 Or Not $Timer_Exists Then 
        ReDim $_Timers_aTimerIDs[$iIndex + 1][3]
        $_Timers_aTimerIDs[0][0] = $iIndex
        If $iTimerID = -1 Then
            $iTimerID = $iIndex + 1000
            For $x = 1 To $iIndex
                If $_Timers_aTimerIDs[$x][0] = $iTimerID Then
                    $iTimerID = $iTimerID + 1
                    $x = 0
                EndIf
            Next
        EndIf
        If $sTimerFunc <> "" Then 
            $hCallBack = DllCallbackRegister($sTimerFunc, "none", "hwnd;int;int;dword")
            If $hCallBack = 0 Then Return SetError(-1, -1, 0)
            $pTimerFunc = DllCallbackGetPtr($hCallBack)
            If $pTimerFunc = 0 Then Return SetError(-1, -1, 0)
        EndIf
        $iResult = DllCall("user32.dll", "int", "SetTimer", "hwnd", $hWnd, "int", $iTimerID, "int", $iElapse, "ptr", $pTimerFunc)
        If @error Then Return SetError(-1, -1, 0)
        $_Timers_aTimerIDs[$iIndex][0] = $iResult[0] 
        $_Timers_aTimerIDs[$iIndex][1] = $iTimerID 
        $_Timers_aTimerIDs[$iIndex][2] = $hCallBack 
    Else 
        For $x = 1 To $iIndex - 1
            If $_Timers_aTimerIDs[$x][0] = $iTimerID Then
                $iTimerID = $_Timers_aTimerIDs[$x][1]
                $hCallBack = $_Timers_aTimerIDs[$x][2]
                If $hCallBack <> 0 Then 
                    $pTimerFunc = DllCallbackGetPtr($hCallBack)
                    If $pTimerFunc = 0 Then Return SetError(-1, -1, 0)
                EndIf
                $iResult = DllCall("user32.dll", "int", "SetTimer", "hwnd", $hWnd, "int", $iTimerID, "int", $iElapse, "ptr", $pTimerFunc)
                If @error Then Return SetError(-1, -1, 0)
                ExitLoop
            EndIf
        Next
    EndIf
    Return $iResult[0]
EndFunc ;==> _Timer_SetTimerEx