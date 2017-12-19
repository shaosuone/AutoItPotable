#cs

	 返回一个超全局变量
	
	_ProcResume($vProcess)  恢复 $vProcess 内的所有线程(PID 或名称)
	_ProcessGetWinList($vProcess, $sTitle = Default, $iOption = 0) 枚举进程窗口
	_CoProcReciver([$sFunction = ""]) 注册/注销  Reciver(接收)函数
	_ConsoleForward($iPid1, [$iPid2], [$iPid3], [$iPidn])
	_ProcessEmptyWorkingSet($vPid = @AutoItPID,[$hDll_psapi],[$hDll_kernel32]) 从工作组指定的进程删除尽可能多的页面.
	_DuplicateHandle($dwSourcePid, $hSourceHandle, $dwTargetPid = @AutoItPID, $fCloseSource = False) 返回一个重复的句柄
	_CloseHandle($hAny) 关闭句柄
	$gs_SuperGlobalRegistryBase
	$gi_CoProcParent
#ce
Global $gs_SuperGlobalRegistryBase = "HKEY_CURRENT_USER\Software\AutoIt v3\CoProc"
Global $gi_CoProcParent = 0
Global $gs_CoProcReciverFunction = ""
Global $gv_CoProcReviverParameter = 0
;===============================================================================
; 函数: _CoProc([$sFunction],[$vParameter])
; 描述: 启动另一个进程
; 参数: $sFunction  - 可选, 开始新进程的名称
; 		$vParameter - 可选, 传递的参数
; 需要: 3.2.4.9
; 返回: 成功 - 返回新进程的 PID
; 		失败 - @error 设置为 1
; 作者: Florian 'Piccaso' Fida
; 注释: 新进程内部 $gi_CoProcParent 保存了父进程的 PID.
; 		$vParameter 不能是二进制, 数组或 DllStruct(DLL结构).
; 		如果 $sFunction 只是函数名称, 例如 _CoProc("MyFunc","MyParameter") 则
; 		Call() 将调用函数,并传递可选参数 (只有一个).
; 		如果 $sFunction 是表达式, 例如 _CoProc("MyFunc('MyParameter')") 则
; 		Execute() 将被用来计算该表达式可能使用多个参数.
; 		输入'Execute()' 格式, 将忽略 $vParameter 参数.
; 		这两种情况下都有限制, 更多细节见 Execute() 与 Call() .
; 		如果 $sFunction 为空 ("" 或 Default) $vParameter 可以是 Reciver(接收)函数名.
;===============================================================================
Func _CoProc($sFunction = Default, $vParameter = Default)
	Local $iPid
	If IsKeyword($sFunction) Or $sFunction = "" Then $sFunction = "__CoProcDummy"
	EnvSet("CoProc", "0x" & Hex(StringToBinary($sFunction)))
	EnvSet("CoProcParent", @AutoItPID)
	If Not IsKeyword($vParameter) Then
		EnvSet("CoProcParameterPresent", "True")
		EnvSet("CoProcParameter", StringToBinary($vParameter))
	Else
		EnvSet("CoProcParameterPresent", "False")
	EndIf
	If @Compiled Then
		$iPid = Run(FileGetShortName(@AutoItExe), @WorkingDir, @SW_HIDE, 1 + 2 + 4)
	Else
		$iPid = Run(FileGetShortName(@AutoItExe) & ' "' & @ScriptFullPath & '"', @WorkingDir, @SW_HIDE, 1 + 2 + 4)
	EndIf
	If @error Then SetError(1)
	Return $iPid
EndFunc   ;==>_CoProc
;===============================================================================
; 函数:  _SuperGlobalSet($sName,[$vValue],[$sRegistryBase])
; 描述: 设置一个超全局变量
; 参数: $sName - 超全局变量标识符
; 		$vValue - 被存储的值 (可选)
; 		$sRegistryBase - 注册表基本键 (可选)
; 需要: 3.2.4.9
; 返回: 成功 - 返回 True
; 		失败 - 返回 返回 False 设置:
; 				@error 为:	1 - 错误的值类型
; 							2 - 注册表问题
; 作者: Florian 'Piccaso' Fida
; 注释: $vValue 绝不能是一个数组或结构.
; 		如果省略 $vValue 超全局变量将被删除.
;		超全局变量存储在注册表中.
; 		$gs_SuperGlobalRegistryBase 占用默认基本键
;===============================================================================
Func _SuperGlobalSet($sName, $vValue = Default, $sRegistryBase = Default)
	Local $vTmp
	If $sRegistryBase = Default Then $sRegistryBase = $gs_SuperGlobalRegistryBase
	If $vValue = "" Or $vValue = Default Then
		RegDelete($sRegistryBase, $sName)
		If @error Then Return SetError(2, 0, False) ; Registry Problem
	Else
		RegWrite($sRegistryBase, $sName, "REG_BINARY", StringToBinary($vValue))
		If @error Then Return SetError(2, 0, False) ; Registry Problem
	EndIf
	Return True
EndFunc   ;==>_SuperGlobalSet
;===============================================================================
; 函数: _SuperGlobalGet($sName,[$fOption],[$sRegistryBase])
; 描述: 获取超全局变量
; 参数: $sName - 超全局变量标识符
; 		$fOption - 可选, 如果设为 True, 完全成功后读出后,超全局变量将被删除，
; 		$sRegistryBase - 注册表基键 (可选)
; 需要: 3.2.4.9
; 返回: 成功 - 返回超全局变量值
; 		失败 - 设置 @error : 1 - 没有找到/注册表问题
; 							 2 - 错误删除
; 作者: Florian 'Piccaso' Fida
; 注释: $vValue 不能是一个数组或结构.
; 		超全局变量存储在注册表中.
; 		$gs_SuperGlobalRegistryBase 占用默认基本键
;===============================================================================
Func _SuperGlobalGet($sName, $fOption = Default, $sRegistryBase = Default)
	Local $vTmp
	If $fOption = "" Or $fOption = Default Then $fOption = False

	If $sRegistryBase = Default Then $sRegistryBase = $gs_SuperGlobalRegistryBase
	$vTmp = RegRead($sRegistryBase, $sName)
	If @error Then Return SetError(1, 0, "") ; Registry Problem
	If $fOption Then
		_SuperGlobalSet($sName)
		If @error Then SetError(2)
	EndIf
	Return BinaryToString("0x" & $vTmp)
EndFunc   ;==>_SuperGlobalGet
;===============================================================================
; 函数 _ProcSuspend($vProcess) 暂停 $vProcess 内的所有线程(PID 或名称)
; 描述: 挂起进程的所有线程
; 参数: $vProcess - 进程名或 PID
; 需要: 3.1.1.130, Win ME/2k/XP
; 返回: 成功 - 返回 Nr. 进程挂起,并设置 @extended 为挂起进程的 Nr. 
; 		失败 - 返回 False 并设置
; 			   @error to: 1 - 未发现进程
;						  2 - 错误调用 'CreateToolhelp32Snapshot'
;						  3 - 错误调用 'Thread32First'
;						  4 - 错误调用 'Thread32Next'
;						  5 - 并非所有的线程处理
; 作者: Florian 'Piccaso' Fida
; 注释: 移植自: http://www.codeproject.com/threads/pausep.asp
; 如果你想使用它,更好的阅读 (和警告!) 见 (IMG:http://www.autoitscript.com/forum/style_emoticons/autoit/smile.gif)
;===============================================================================
Func _ProcSuspend($vProcess, $iReserved = 0)
	Local $iPid, $vTmp, $hThreadSnap, $ThreadEntry32, $iThreadID, $hThread, $iThreadCnt, $iThreadCntSuccess, $sFunction
	Local $TH32CS_SNAPTHREAD = 0x00000004
	Local $INVALID_HANDLE_VALUE = 0xFFFFFFFF
	Local $THREAD_SUSPEND_RESUME = 0x0002
	Local $THREADENTRY32_StructDef = "int;" _; 1 -> dwSize
			 & "int;" _; 2 -> cntUsage
			 & "int;" _; 3 -> th32ThreadID
			 & "int;" _; 4 -> th32OwnerProcessID
			 & "int;" _; 5 -> tpBasePri
			 & "int;" _; 6 -> tpDeltaPri
			 & "int" ; 7 -> dwFlags

	$iPid = ProcessExists($vProcess)
	If Not $iPid Then Return SetError(1, 0, False) ; Process not found.
	$vTmp = DllCall("kernel32.dll", "ptr", "CreateToolhelp32Snapshot", "int", $TH32CS_SNAPTHREAD, "int", 0)
	If @error Then Return SetError(2, 0, False) ; CreateToolhelp32Snapshot Failed
	If $vTmp[0] = $INVALID_HANDLE_VALUE Then Return SetError(2, 0, False) ; CreateToolhelp32Snapshot Failed
	$hThreadSnap = $vTmp[0]
	$ThreadEntry32 = DllStructCreate($THREADENTRY32_StructDef)
	DllStructSetData($ThreadEntry32, 1, DllStructGetSize($ThreadEntry32))
	$vTmp = DllCall("kernel32.dll", "int", "Thread32First", "ptr", $hThreadSnap, "long", DllStructGetPtr($ThreadEntry32))
	If @error Then Return SetError(3, 0, False) ; Thread32First Failed
	If Not $vTmp[0] Then
		DllCall("kernel32.dll", "int", "CloseHandle", "ptr", $hThreadSnap)
		Return SetError(3, 0, False) ; Thread32First Failed
	EndIf

	While 1
		If DllStructGetData($ThreadEntry32, 4) = $iPid Then
			$iThreadID = DllStructGetData($ThreadEntry32, 3)
			$vTmp = DllCall("kernel32.dll", "ptr", "OpenThread", "int", $THREAD_SUSPEND_RESUME, "int", False, "int", $iThreadID)
			If Not @error Then
				$hThread = $vTmp[0]
				If $hThread Then
					If $iReserved Then
						$sFunction = "ResumeThread"
					Else
						$sFunction = "SuspendThread"
					EndIf
					$vTmp = DllCall("kernel32.dll", "int", $sFunction, "ptr", $hThread)
					If $vTmp[0] <> -1 Then $iThreadCntSuccess += 1
					DllCall("kernel32.dll", "int", "CloseHandle", "ptr", $hThread)
				EndIf
			EndIf
			$iThreadCnt += 1
		EndIf
		$vTmp = DllCall("kernel32", "int", "Thread32Next", "ptr", $hThreadSnap, "long", DllStructGetPtr($ThreadEntry32))
		If @error Then Return SetError(4, 0, False) ; Thread32Next Failed
		If Not $vTmp[0] Then ExitLoop

	WEnd

	DllCall("kernel32.dll", "int", "CloseToolhelp32Snapshot", "ptr", $hThreadSnap) ; CloseHandle
	If Not $iThreadCntSuccess Or $iThreadCnt > $iThreadCntSuccess Then Return SetError(5, $iThreadCnt, $iThreadCntSuccess)
	Return SetError(0, $iThreadCnt, $iThreadCntSuccess)
EndFunc   ;==>_ProcSuspend
;===============================================================================
;
; 描述: Resume all Threads in a Process
; 参数: $vProcess - Name or PID of Process
; 需要: 3.1.1.130, Win ME/2k/XP
; 返回: 成功 - 返回Returns Nr. of Threads Resumed and Set @extended to Nr. of Threads Processed
; 		失败 - 返回 Returns False and Set
; @error to: 1 - 未发现进程
; 2 - 错误调用 'CreateToolhelp32Snapshot'
; 3 - 错误调用 'Thread32First'
; 4 - 错误调用 'Thread32Next'
; 5 - 并非所有的线程处理
; 作者: Florian 'Piccaso' Fida
; 注释: Ported from: http://www.codeproject.com/threads/pausep.asp
; Better read the article (and the warnings!) if you want to use it (IMG:http://www.autoitscript.com/forum/style_emoticons/autoit/smile.gif)
;===============================================================================
Func _ProcResume($vProcess)
	Local $fRval = _ProcSuspend($vProcess, True)
	Return SetError(@error, @extended, $fRval)
EndFunc   ;==>_ProcResume
;===============================================================================
;
; 描述: 枚举进程窗口
; 参数: $vProcess - Name or PID of Process
; $sTitle - Optional Title of window to Find
; $iOption - 可选, Can be added together
; 0 - Matches any Window (Default)
; 2 - Matches any Window Created by GuiCreate() (ClassName: AutoIt v3 GUI)
; 4 - Matches AutoIt Main Window (ClassName: AutoIt v3)
; 6 - Matches Any AutoIt Window
; 16 - Return the first Window Handle found (No Array)
; 需要: 3.1.1.130
; 返回: 成功 - 返回Retuns an Array/Handle of Windows found
; 		失败 - 返回 Set @ERROR to: 1 - 未发现进程
; 2 - Window(s) not Found
; 3 - GetClassName Failed
; 作者: Florian 'Piccaso' Fida
; 注释:
;
;===============================================================================
Func _ProcessGetWinList($vProcess, $sTitle = Default, $iOption = 0)
	Local $aWinList, $iCnt, $aTmp, $iPid
	Local $aResult[1]
	Local $fMatch, $sClassname, $hWnd

	$iPid = ProcessExists($vProcess)
	If Not $iPid Then Return SetError(1) ; 未发现进程
	If $sTitle = "" Or IsKeyword($sTitle) Then
		$aWinList = WinList()
	Else
		$aWinList = WinList($sTitle)
	EndIf

	For $iCnt = 1 To $aWinList[0][0]
		$hWnd = $aWinList[$iCnt][1]
		Global $iProcessId = WinGetProcess($hWnd)
		If $iProcessId = $iPid Then
			If $iOption = 0 Or IsKeyword($iOption) Or $iOption = 16 Then
				$fMatch = True
			Else
				$fMatch = False
				$sClassname = DllCall("user32.dll", "int", "GetClassName", "hwnd", $hWnd, "str", "", "int", 1024)
				If @error Then Return SetError(3) ; GetClassName
				If $sClassname[0] = 0 Then Return SetError(3) ; GetClassName
				$sClassname = $sClassname[2]
				If BitAND($iOption, 2) Then
					If $sClassname = "AutoIt v3 GUI" Then $fMatch = True
				EndIf
				If BitAND($iOption, 4) Then
					If $sClassname = "AutoIt v3" Then $fMatch = True
				EndIf
			EndIf
			If $fMatch Then
				If BitAND($iOption, 16) Then Return $hWnd
				ReDim $aResult[UBound($aResult) + 1]
				$aResult[UBound($aResult) - 1] = $hWnd
			EndIf
		EndIf
	Next

	$aResult[0] = UBound($aResult) - 1
	If $aResult[0] < 1 Then Return SetError(2, 0, 0) ; No Window(s) Found
	Return $aResult
EndFunc   ;==>_ProcessGetWinList

;===============================================================================
;
; 描述: Register Reciver Function
; 参数: $sFunction - 可选, Function name to Register.
; Omit to Disable/Unregister
; 需要: 3.2.4.9
; 返回: 成功 - 返回Returns True
; 		失败 - 返回 Returns False and Set
; @error to: 1 - Unable to create Reciver Window
; 2 - Unable to (Un)Register WM_COPYDATA or WM_USER+0x64
; 作者: Florian 'Piccaso' Fida
; 注释: If the process doesent have a Window it will be created
; The Reciver Function must accept 1 Parameter
;
;===============================================================================
Func _CoProcReciver($sFunction = Default)
	Local $sHandlerFuction = "__CoProcReciverHandler", $hWnd, $aTmp
	If IsKeyword($sFunction) Then $sFunction = ""
	$hWnd = _ProcessGetWinList(@AutoItPID, "", 16 + 2)
	If Not IsHWnd($hWnd) Then
		$hWnd = GUICreate("CoProcEventReciver")
		If @error Then Return SetError(1, 0, False)
	EndIf
	If $sFunction = "" Or IsKeyword($sFunction) Then $sHandlerFuction = ""
	If Not GUIRegisterMsg(0x4A, $sHandlerFuction) Then Return SetError(2, 0, False) ; WM_COPYDATA
	If Not GUIRegisterMsg(0x400 + 0x64, $sHandlerFuction) Then Return SetError(2, 0, False) ; WM_USER+0x64
	$gs_CoProcReciverFunction = $sFunction
	Return True
EndFunc   ;==>_CoProcReciver
Func __CoProcReciverHandler($hWnd, $iMsg, $WParam, $LParam)
	If $iMsg = 0x4A Then ; WM_COPYDATA
		Local $COPYDATA, $MyData
		$COPYDATA = DllStructCreate("ptr;dword;ptr", $LParam)
		$MyData = DllStructCreate("char[" & DllStructGetData($COPYDATA, 2) & "]", DllStructGetData($COPYDATA, 3))
		$gv_CoProcReviverParameter = DllStructGetData($MyData, 1)
		Return 256
	ElseIf $iMsg = 0x400 + 0x64 Then ; WM_USER+0x64
		If $gv_CoProcReviverParameter Then
			Call($gs_CoProcReciverFunction, $gv_CoProcReviverParameter)
			If @error And @Compiled = 0 Then MsgBox(16, "CoProc Error", "Unable to Call: " & $gs_CoProcReciverFunction)
			$gv_CoProcReviverParameter = 0
			Return 0
		EndIf
	EndIf
EndFunc   ;==>__CoProcReciverHandler

;===============================================================================
; 描述: 发送消息到进程
; 参数: $vProcess     - 进程名或 PID
; 		$vParameter   - 传递的参数
; 		$iTimeout 	  - 可选, 默认 500 (毫秒)
; 		$fAbortIfHung - 可选, 默认 True
; 需要: 3.2.4.9
; 返回: 成功 - 返回 True
; 		失败 - 返回 False 设置
; 				@error 为: 1 - 未发现进程
;						   2 - 未发现窗口
;						   3 - 超时/忙/挂起
;						   4 - 发布消息失败
;==========================================================================
Func _CoProcSend($vProcess, $vParameter, $iTimeout = 500, $fAbortIfHung = True)
	Local $iPid, $hWndTarget, $MyData, $aTmp, $COPYDATA, $iFuFlags
	$iPid = ProcessExists($vProcess)
	If Not $iPid Then Return SetError(1, 0, False) ; 未发现进程
	$hWndTarget = _ProcessGetWinList($vProcess, "", 16 + 2)
	If @error Or (Not $hWndTarget) Then Return SetError(2, 0, False) ; Window not found
	$MyData = DllStructCreate("char[" & StringLen($vParameter) + 1 & "]")
	$COPYDATA = DllStructCreate("ptr;dword;ptr")
	DllStructSetData($MyData, 1, $vParameter)
	DllStructSetData($COPYDATA, 1, 1)
	DllStructSetData($COPYDATA, 2, DllStructGetSize($MyData))
	DllStructSetData($COPYDATA, 3, DllStructGetPtr($MyData))
	If $fAbortIfHung Then
		$iFuFlags = 0x2 ; SMTO_ABORTIFHUNG
	Else
		$iFuFlags = 0x0 ; SMTO_NORMAL
	EndIf
	$aTmp = DllCall("user32.dll", "int", "SendMessageTimeout", "hwnd", $hWndTarget, "int", 0x4A _; WM_COPYDATA
			, "int", 0, "ptr", DllStructGetPtr($COPYDATA), "int", $iFuFlags, "int", $iTimeout, "long*", 0)
	If @error Then Return SetError(3, 0, False) ; SendMessageTimeout Failed
	If Not $aTmp[0] Then Return SetError(3, 0, False) ; SendMessageTimeout Failed
	If $aTmp[7] <> 256 Then Return SetError(3, 0, False)
	$aTmp = DllCall("user32.dll", "int", "PostMessage", "hwnd", $hWndTarget, "int", 0x400 + 0x64, "int", 0, "int", 0)
	If @error Then Return SetError(4, 0, False)
	If Not $aTmp[0] Then Return SetError(4, 0, False)
	Return True
EndFunc   ;==>_CoProcSend

;===============================================================================
;
; 描述: Forwards StdOut and StdErr from specified Processes to Calling process
; 参数: $iPid1 - Pid of Procces
; $iPidn - 可选, Up to 16 Processes
; 需要: 3.1.1.131
; 返回: None
; 作者: Florian 'Piccaso' Fida
; 注释: Processes must provide StdErr and StdOut Streams (See Run())
;
;==========================================================================
Func _ConsoleForward($iPid1, $iPid2 = Default, $iPid3 = Default, $iPid4 = Default, $iPid5 = Default, $iPid6 = Default, $iPid7 = Default, $iPid8 = Default, $iPid9 = Default, $iPid10 = Default, $iPid11 = Default, $iPid12 = Default, $iPid13 = Default, $iPid14 = Default, $iPid15 = Default, $iPid16 = Default)
	Local $iPid, $i, $iPeek
	For $i = 1 To 16
		$iPid = Eval("iPid" & $i)
		If $iPid = Default Or Not $iPid Then ContinueLoop
		If ProcessExists($iPid) Then
			$iPeek = StdoutRead($iPid, True, True)
			If Not @error And $iPeek > 0 Then
				ConsoleWrite(StdoutRead($iPid))
			EndIf
			$iPeek = StderrRead($iPid, True, True)
			If Not @error And $iPeek > 0 Then
				ConsoleWriteError(StderrRead($iPid))
			EndIf
		EndIf
	Next
EndFunc   ;==>_ConsoleForward
;===============================================================================
;
; 描述: 从工作组指定的进程删除尽可能多的页面.
; 参数: $vPid - 可选, Pid or Process Name
; $hDll_psapi - 可选, Handle to psapi.dll
; $hDll_kernel32 - 可选, Handle to kernel32.dll
; 需要: 3.2.1.12
; 返回: 成功 - 返回nonzero
; 		失败 - 返回 0 and sets error to
; @error to: 1 - Process Doesent exist
; 2 - OpenProcess Failed
; 3 - EmptyWorkingSet Failed
; 作者: Florian 'Piccaso' Fida
; 注释: $vPid can be the -1 Pseudo Handle
;
;===============================================================================
Func _ProcessEmptyWorkingSet($vPid = @AutoItPID, $hDll_psapi = "psapi.dll", $hDll_kernel32 = "kernel32.dll")
	Local $av_EWS, $av_OP, $iRval
	If $vPid = -1 Then ; Pseudo Handle
		$av_EWS = DllCall($hDll_psapi, "int", "EmptyWorkingSet", "ptr", -1)
	Else
		$vPid = ProcessExists($vPid)
		If Not $vPid Then Return SetError(1, 0, 0) ; Process Doesent exist
		$av_OP = DllCall($hDll_kernel32, "int", "OpenProcess", "dword", 0x1F0FFF, "int", 0, "dword", $vPid)
		If $av_OP[0] = 0 Then Return SetError(2, 0, 0) ; OpenProcess Failed
		$av_EWS = DllCall($hDll_psapi, "int", "EmptyWorkingSet", "ptr", $av_OP[0])
		DllCall($hDll_kernel32, "int", "CloseHandle", "int", $av_OP[0])
	EndIf
	If $av_EWS[0] Then
		Return $av_EWS[0]
	Else
		Return SetError(3, 0, 0) ; EmptyWorkingSet Failed
	EndIf
EndFunc   ;==>_ProcessEmptyWorkingSet


;===============================================================================
;
; 描述: Duplicates a Handle from or for another process
; 参数: $dwSourcePid - Pid from Source Process
; $hSourceHandle - The Handle to duplicate
; $dwTargetPid - 可选, Pid from Target Procces - Defaults to current process
; $fCloseSource - 可选, Close the source handle - Defaults to False
; 需要: 3.2.4.9
; 返回: 成功 - 返回Duplicated Handle
; 		失败 - 返回 0 and sets error to
; @error to: 1 - Api OpenProcess Failed
; 2 - Api DuplicateHandle Falied
; 作者: Florian 'Piccaso' Fida
; 注释:
;
;===============================================================================
Func _DuplicateHandle($dwSourcePid, $hSourceHandle, $dwTargetPid = @AutoItPID, $fCloseSource = False)
	Local $hTargetHandle, $hPrSource, $hPrTarget, $dwOptions
	$hPrSource = __dh_OpenProcess($dwSourcePid)
	$hPrTarget = __dh_OpenProcess($dwTargetPid)
	If $hPrSource = 0 Or $hPrTarget = 0 Then
		_CloseHandle($hPrSource)
		_CloseHandle($hPrTarget)
		Return SetError(1, 0, 0)
	EndIf
	; DUPLICATE_CLOSE_SOURCE = 0x00000001
	; DUPLICATE_SAME_ACCESS = 0x00000002
	If $fCloseSource <> False Then
		$dwOptions = 0x01 + 0x02
	Else
		$dwOptions = 0x02
	EndIf
	$hTargetHandle = DllCall("kernel32.dll", "int", "DuplicateHandle", "ptr", $hPrSource, "ptr", $hSourceHandle, "ptr", $hPrTarget, "long*", 0, "dword", 0, "int", 1, "dword", $dwOptions)
	If @error Then Return SetError(2, 0, 0)
	If $hTargetHandle[0] = 0 Or $hTargetHandle[4] = 0 Then
		_CloseHandle($hPrSource)
		_CloseHandle($hPrTarget)
		Return SetError(2, 0, 0)
	EndIf
	Return $hTargetHandle[4]
EndFunc   ;==>_DuplicateHandle
Func __dh_OpenProcess($dwProcessId)
	; PROCESS_DUP_HANDLE = 0x40
	Local $hPr = DllCall("kernel32.dll", "ptr", "OpenProcess", "dword", 0x40, "int", 0, "dword", $dwProcessId)
	If @error Then Return SetError(1, 0, 0)
	Return $hPr[0]
EndFunc   ;==>__dh_OpenProcess
Func _CloseHandle($hAny)
	If $hAny = 0 Then Return SetError(1, 0, 0)
	Local $fch = DllCall("kernel32.dll", "int", "CloseHandle", "ptr", $hAny)
	If @error Then Return SetError(1, 0, 0)
	Return $fch[0]
EndFunc   ;==>_CloseHandle



#Region Internal Functions
Func __CoProcStartup()
	Local $sCmd = EnvGet("CoProc")
	If StringLeft($sCmd, 2) = "0x" Then
		$sCmd = BinaryToString($sCmd)
		$gi_CoProcParent = Number(EnvGet("CoProcParent"))
		If StringInStr($sCmd, "(") And StringInStr($sCmd, ")") Then
			Execute($sCmd)
			If @error And Not @Compiled Then MsgBox(16, "CoProc Error", "Unable to Execute: " & $sCmd)
			Exit
		EndIf
		If EnvGet("CoProcParameterPresent") = "True" Then
			Call($sCmd, BinaryToString(EnvGet("CoProcParameter")))
			If @error And Not @Compiled Then MsgBox(16, "CoProc Error", "Unable to Call: " & $sCmd & @LF & "Parameter: " & BinaryToString(EnvGet("CoProcParameter")))
		Else
			Call($sCmd)
			If @error And Not @Compiled Then MsgBox(16, "CoProc Error", "Unable to Call: " & $sCmd)
		EndIf
		Exit
	EndIf
EndFunc   ;==>__CoProcStartup
Func __CoProcDummy($vPar = Default)
	If Not IsKeyword($vPar) Then _CoProcReciver($vPar)
	While ProcessExists($gi_CoProcParent)
		Sleep(500)
	WEnd
EndFunc   ;==>__CoProcDummy
__CoProcStartup()
#EndRegion Internal Functions
