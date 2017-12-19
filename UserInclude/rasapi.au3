#include <Array.au3>

; #### Phonebook default used ####
; ================================================================================================
Const $RAS_PHONEBOOK = @AppDataCommonDir & "\Microsoft\Network\Connections\Pbk\rasphone.pbk"
; ================================================================================================

; #### Handle to modules/heap ####
; ================================================================================================
Const $RAS_HEAPHANDLE = _RasProcessHeap()
Const $RAS_DllHandle = DllOpen("rasapi32.dll")
Const $RASDLG_DllHandle = DllOpen("rasdlg.dll")
; ================================================================================================

; #### Structures for RAS lib ####
; ================================================================================================
Const $tagRAS_DEVICE_INFO = "dword Size;char DeviceType[17];char DeviceName[129]"
Const $tagRAS_ENTRY_NAME = "dword Size;char EntryName[257];dword Flags;char Pnebook[261]"
Const $tagRAS_CTRY_INFO = "dword Size;dword CountryId;dword NextCountryId;dword CountryCode;dword CountryNameOffset"
Const $tagRAS_PPP_IP = "dword Size;dword Error;char IpAddress[17];char ServerIpAddress[17];dword Options;dword ServerOptions"

Const $tagRAS_CONNECTION = "dword Size;hWnd RasConnection;wchar EntryName[257];wchar DeviceType[17];wchar DeviceName[129];wchar Pnebook[260];dword SubEntry;byte GuidEntry[16];dword Flags;ptr Luid;ptr GuidCorrelationId"
Const $tagRAS_STATS = "dword Size;dword BytesXmited;dword BytesRecved;dword FramesXmited;dword FramesRecved;dword CrcError;dword TimeoutError;dword AlignmentError;dword HardwareOverrunError;dword FramingError;dword BufferOverrunError;dword CompressionRetioIn;dword CompressionRatioOut;dword Bps;dword Duration"

Const $tagRAS_DIAL_DLG = "dword Size;hWnd HWnd;dword Flags;long X;long Y;dword SubEntry;dword Error;ulong_ptr Reserved1;ulong_ptr Reserved2"
Const $tagRAS_MONITOR_DLG = "dword Size;hWnd HWnd;dword Flags;dword StartPage;long X;long Y;dword Error;ulong_ptr Reserved1;ulong_ptr Reserved2"
Const $tagRAS_ENTRY_DLG = "dword Size;hWnd HWnd;dword Flags;long X;long Y;char EntryName[257];dword Error;ulong_ptr Reserved1;ulong_ptr Reserved2"
Const $tagRAS_AUTODIAL_ENTRY = "dword Size;dword Flags;dword DialingLocation;wchar EntryName[257]"

Const $tagRAS_DIAL_PARAMS = "dword Size;wchar EntryName[21];wchar PhoneNumber[129];wchar CallbackNumber[49];wchar UserName[257];wchar Password[257];wchar Domain[16]"
Const $tagRAS_DIAL_PARAMS1 = $tagRAS_DIAL_PARAMS & ";dword SubEntry;ulong_ptr CallbackId;dword IfIndex"

Const $tagRAS_ENTRY = "dword Size;dword Options1;dword CountryId;dword CountryCode;wchar AreaCode[11];wchar LocalPhoneNumber[129];dword AlternateOffset;byte IpAddr[4];byte IpAddrDns[4];byte IpAddrDnsAlt[4];byte IpAddrWins[4];byte IpAddrWinsAlt[4];dword FrameSize;dword NetProtocols;dword FramingProtocol;wchar Script[260];wchar AutodialDll[260];wchar AutodialFunc[260];wchar DeviceType[17];wchar DeviceName[129];wchar X25PadType[33];wchar X25Address[201];wchar X25Facilities[201];wchar X25UserData[201];dword Channels;dword Reserved1;dword Reserved2;dword SubEntries;dword DialMode;dword DialExtraPercent;dword DialExtraSampleSeconds;dword HangUpExtraPercent;dword HangUpExtraSampleSeconds;dword IdleDisconnectSeconds;dword Type;dword EncryptionType;dword CustomAuthKey;byte GuidId[16];wchar CustomDialDll[260];dword VpnStrategy;dword Options2;dword Options3;wchar DnsSuffix[256];dword TcpWindowSize;wchar PrerequisitePbk[260];wchar PrerequisiteEntry[257];dword RedialCount;dword RedialPause;byte IPv6AddrDns[16];byte IPv6AddrDnsAlt[16];dword IPv4InterfaceMetric;dword IPv6InterfaceMetric;byte IPv6Addr[16];dword IPv6PrefixLength;dword NetworkOutageTime"

Const $tagRAS_AMB = "dword Size;dword Error;wchar NetBiosError[17];byte Lana"
Const $tagRAS_PPPNBF = "dword Size;dword Error;dword NetBiosError;wchar NetBiosErrorMsg[17];wchar Workstation[17];byte Lana"
Const $tagRAS_PPPIPX = "dword Size;dword Error;wchar IpxAddress[16]"
Const $tagRAS_PPPIP = "dword Size;dword Error;wchar IpAddress[16];wchar ServerIpAddress[16];dword Options;dword ServerOptions"
Const $tagRAS_PPPIPV6 = "dword Size;dword Error;byte LocalInterfaceIdentifier[8];byte PeerInterfaceIdentifier[8];byte LocalCompressionProtocol[2];byte PeerCompressionProtocol[2]"
Const $tagRAS_PPPCCP = "dword Size;dword Error;dword CompressionAlgorighm;dword Options;dword ServerCompressionAlgorithm;dword ServerOptions"
Const $tagRAS_PPPLCP = "dword Size;bool Bundled;dword Error;dword AuthenticationProtocol;dword AuthenticationData;dword EapTypeId;dword ServerAuthenticationProtocol;dword ServerAuthenticationData;dword ServerEapTypeId;bool Multilink;dword TerminateReason;dword ServerTerminateReason;wchar ReplyMsg[1024];dword Options;dword ServerOptions"
Const $tagRAS_SLIP = "dword Size;dword Error;wchar IpAddress[16]"

; ================================================================================================

Func _RasProcessHeap()
	Local $iResult = DllCall("Kernel32.dll", "handle", "GetProcessHeap")
	Return $iResult[0]
EndFunc	;==>_RasProcessHeap

Func _RasFreeHeap($pBuffer)
	Local $iResult
	$iResult = DllCall("Kernel32.dll", "int", "HeapFree", "handle", $RAS_HEAPHANDLE, _
			"dword", 0, "ptr", $pBuffer)
	Return $iResult[0]
EndFunc	;==>_RasFreeHeap

Func _RasAllocHeap($iBytesToAlloc)
	If ($iBytesToAlloc < 1) Then Return 0

	Local $iResult
	$iResult = DllCall("Kernel32.dll", "ptr", "HeapAlloc", "handle", $RAS_HEAPHANDLE, _
			"dword", 8, "dword", $iBytesToAlloc)
	Return $iResult[0]
EndFunc	;==>_RasAllocHeap

Func _RasFreeVar(ByRef $vVar, $vValue = 0, $vReturn = "", $iError = @error, $iExtended = @extended)
	$vVar = $vValue
	Return SetError($iError, $iExtended, $vReturn)
EndFunc	;==>_RasFreeVar

Func _RasEnumDevices()
	Local $pBuffer, $tBuffer, $iBufferSize, $iResult, $aResult[1][2] = [[0]]

	$iResult = DllCall($RAS_DllHandle, "dword", "RasEnumDevices", "ptr", 0, "dword*", 0, "long*", 0)
	If Not ($iResult[2] And $iResult[3]) Then Return SetError($iResult[0], 0, $aResult)

	$iBufferSize = $iResult[2] / $iResult[3]
	If Not IsInt($iBufferSize) Then Return SetError($iResult[0], 0, $aResult)

	$pBuffer = _RasAllocHeap($iResult[2])
	$tBuffer = DllStructCreate($tagRAS_DEVICE_INFO, $pBuffer)
	DllStructSetData($tBuffer, "Size", $iBufferSize)

	$iResult = DllCall($RAS_DllHandle, "dword", "RasEnumDevices", "ptr", $pBuffer, _
			"dword*", $iResult[2], "long*", 0)
	If ($iResult[0]) Then
		_RasFreeVar($tBuffer, 0, _RasFreeHeap($pBuffer))
		Return SetError($iResult[0], 0, $aResult)
	EndIf

	$aResult[0][0] = $iResult[3]
	Redim $aResult[$iResult[3] + 1][2]

	For $i = 1 To $iResult[3]
		$aResult[$i][0] = DllStructGetData($tBuffer, "DeviceName")
		$aResult[$i][1] = DllStructGetData($tBuffer, "DeviceType")

		$tBuffer = 0
		$tBuffer = DllStructCreate($tagRAS_DEVICE_INFO, $pBuffer + ($i * $iBufferSize))
	Next
	Return SetError(0, _RasFreeHeap($pBuffer), $aResult)
EndFunc	;==>_RasEnumDevices

Func _RasEnumEntries($sPnebk = $RAS_PHONEBOOK)
	Local $iResult, $pBuffer, $tBuffer, $iBufferSize, $aResult[1][3] = [[0]]

	$tBuffer = DllStructCreate($tagRAS_ENTRY_NAME)
	$pBuffer = DllStructGetPtr($tBuffer)
	$iBufferSize = DllStructGetSize($tBuffer)
	DllStructSetData($tBuffer, "Size", $iBufferSize)

	$iResult = DllCall($RAS_DllHandle, "dword", "RasEnumEntries", "ptr", 0, _
			"str", $sPnebk, "ptr", $pBuffer, "dword*", 0, "dword*", 0)
	If Not ($iResult[4] And $iResult[5]) Then
		Return SetError($iResult[0], _RasFreeVar($tBuffer), $aResult)
	EndIf

	$tBuffer = 0
	$pBuffer = _RasAllocHeap($iResult[4])
	$tBuffer = DllStructCreate($tagRAS_ENTRY_NAME, $pBuffer)
	DllStructSetData($tBuffer, "Size", $iBufferSize)

	$iResult = DllCall($RAS_DllHandle, "dword", "RasEnumEntries", "ptr", 0, _
			"str", $sPnebk, "ptr", $pBuffer, "dword*", $iResult[4], "dword*", 0)
	If ($iResult[0]) Then
		_RasFreeVar($tBuffer, 0, _RasFreeHeap($pBuffer))
		Return SetError($iResult[0], 0, $aResult)
	EndIf
	$aResult[0][0] = $iResult[5]
	Redim $aResult[$iResult[5] + 1][3]

	For $i = 1 To $iResult[5]
		$aResult[$i][0] = DllStructGetData($tBuffer, "EntryName")
		$aResult[$i][1] = DllStructGetData($tBuffer, "Flags")
		$aResult[$i][2] = DllStructGetData($tBuffer, "Pnebook")

		$tBuffer = 0
		$tBuffer = DllStructCreate($tagRAS_ENTRY_NAME, $pBuffer + ($i * $iBufferSize))
	Next
	Return SetError(0, _RasFreeHeap($pBuffer), $aResult)
EndFunc	;==>_RasEnumEntries

Func _RasEnumConnections()
	Local $aResult[1][7], $tBuffer, $pBuffer, $iBufferSize, $iResult

	$tBuffer = DllStructCreate($tagRAS_CONNECTION)
	$pBuffer = DllStructGetPtr($tBuffer)
	$iBufferSize = DllStructGetSize($tBuffer)
	DllStructSetData($tBuffer, "Size", $iBufferSize)

	$iResult = DllCall($RAS_DllHandle, "dword", "RasEnumConnectionsW", "ptr", $pBuffer, _
			"dword*", $iBufferSize, "dword*", 0)
	$tBuffer = 0
	$pBuffer = _RasAllocHeap($iResult[3] * $iBufferSize)
	$tBuffer = DllStructCreate($tagRAS_CONNECTION, $pBuffer)
	DllStructSetData($tBuffer, "Size", $iBufferSize)

	$iResult = DllCall($RAS_DllHandle, "dword", "RasEnumConnectionsW", "ptr", $pBuffer, _
			"dword*", $iBufferSize * $iResult[3], "dword*", 0)
	If ($iResult[0]) Then
		_RasFreeVar($tBuffer, 0, _RasFreeHeap($pBuffer))
		Return SetError($iResult[0], 0, $aResult)
	EndIf
	$aResult[0][0] = $iResult[3]
	Redim $aResult[$iResult[3] + 1][7]

	For $i = 1 To $iResult[3]
		$aResult[$i][0] = DllStructGetData($tBuffer, "RasConnection")
		$aResult[$i][1] = DllStructGetData($tBuffer, "EntryName")
		$aResult[$i][2] = DllStructGetData($tBuffer, "DeviceType")
		$aResult[$i][3] = DllStructGetData($tBuffer, "DeviceName")
		$aResult[$i][4] = DllStructGetData($tBuffer, "Pnebook")
		$aResult[$i][5] = DllStructGetData($tBuffer, "SubEntry")
		$aResult[$i][6] = DllStructGetData($tBuffer, "Flags")
		$tBuffer = 0
		$tBuffer = DllStructCreate($tagRAS_CONNECTION, $pBuffer + ($i * $iBufferSize))
	Next
	_RasFreeVar($tBuffer, 0, _RasFreeHeap($pBuffer))
	Return $aResult
EndFunc	;==>_RasEnumConnections

Func _RasGetErrorString($iError = @error)
	Local $iResult

	$iResult = DllCall($RAS_DllHandle, "dword", "RasGetErrorString", _
			"dword", $iError, "str", "", "dword", 256)
	Return SetError($iResult[0], 0, $iResult[2])
EndFunc	;==>_RasGetErrorString

Func _RasHangUp($hRasConn)
	Local $iResult
	$iResult = DllCall($RAS_DllHandle, "dword", "RasHangUp", "hWnd", $hRasConn)
	Return SetError($iResult[0], 0, $iResult[0] = 0)
EndFunc	;==>_RasHangUp

Func _RasGetCountryInfo($iCountryId)
	Local $pBuffer, $tBuffer, $iResult, $aResult[2], $iNext, $iOffset, $tName

	$pBuffer = _RasAllocHeap(1024)
	$tBuffer = DllStructCreate($tagRAS_CTRY_INFO, $pBuffer)
	DllStructSetData($tBuffer, "Size", 20)
	DllStructSetData($tBuffer, "CountryId", $iCountryId)

	$iResult = DllCall($RAS_DllHandle, "dword", "RasGetCountryInfo", "ptr", $pBuffer, _
			"dword*", 1024)
	If ($iResult[0]) Then
		_RasFreeVar($tBuffer, 0, _RasFreeHeap($pBuffer))
		Return SetError($iResult[0], 0, $aResult)
	EndIf

	$iNext = DllStructGetData($tBuffer, "NextCountryId")
	$iOffset = DllStructGetData($tBuffer, "CountryNameOffset")

	$tName = DllStructCreate("char CountryName[256]", $pBuffer + $iOffset)
	$aResult[0] = DllStructGetData($tBuffer, "CountryCode")
	$aResult[1] = DllStructGetData($tName, "CountryName")

	_RasFreeVar($tBuffer, 0, _RasFreeVar($tName, 0, _RasFreeHeap($pBuffer)))
	Return SetError(0, $iNext, $aResult)
EndFunc	;==>_RasGetCountryInfo

Func _RasEnumCountryInfo()
	Local $aResult[1][2] = [[0]], $aInfo

	SetExtended(1)
	While @Extended
		$aInfo = _RasGetCountryInfo(@Extended)
		If (@error) Then ExitLoop
		SetExtended(@Extended)
		$aResult[0][0] += 1
		Redim $aResult[$aResult[0][0] + 1][2]
		$aResult[$aResult[0][0]][0] = $aInfo[0]
		$aResult[$aResult[0][0]][1] = $aInfo[1]
	WEnd
	Return SetError(@error, 0, $aResult)
EndFunc	;==>_RasEnumCountryInfo

Func _RasRenameEntry($sEntryName, $sNewName, $sPnebook = $RAS_PHONEBOOK)
	Local $iResult
	$iResult = DllCall($RAS_DllHandle, "dword", "RasRenameEntry", "str", $sPnebook, _
			"str", $sEntryName, "str", $sNewName)
	Return SetError($iResult[0], 0, $iResult[0] = 0)
EndFunc	;==>_RasRenameEntry

Func _RasGetConnectionStatistics($hRasConn)
	Local $tBuffer, $pBuffer, $iResult

	$tBuffer = DllStructCreate($tagRAS_STATS)
	$pBuffer = DllStructGetPtr($tBuffer)
	DllStructSetData($tBuffer, "Size", DllStructGetSize($tBuffer))

	$iResult = DllCall($RAS_DllHandle, "dword", "RasGetConnectionStatistics", _
			"hWnd", $hRasConn, "ptr", $pBuffer)
	If ($iResult[0]) Then $tBuffer = 0
	Return SetError($iResult[0], 0, $tBuffer)
EndFunc	;==>_RasGetConnectionStatistics

Func _RasClearConnectionStatistics($hRasConn)
	Local $iResult
	$iResult = DllCall($RAS_DllHandle, "dword", "RasClearConnectionStatistics", "hWnd", $hRasConn)
	Return SetError($iResult[0], 0, $iResult[0] = 0)
EndFunc	;==>_RasClearConnectionStatistics

Func _RasClearLinkStatistics($hRasConn, $iSubEntry)
	Local $iResult
	$iResult = DllCall($RAS_DllHandle, "dword", "RasClearLinkStatistics", _
			"hWnd", $hRasConn, "dword", $iSubEntry)
	Return SetError($iResult[0], 0, $iResult[0] = 0)
EndFunc	;==>_RasClearLinkStatistics

Func _RasGetLinkStatistics($hRasConn, $iSubEntry)
	Local $tBuffer, $pBuffer, $iResult

	$tBuffer = DllStructCreate($tagRAS_STATS)
	$pBuffer = DllStructGetPtr($tBuffer)
	DllStructSetData($tBuffer, "Size", DllStructGetSize($tBuffer))

	$iResult = DllCall($RAS_DllHandle, "dword", "RasGetLinkStatistics", _
			"hWnd", $hRasConn, "dword", $iSubEntry, "ptr", $pBuffer)
	If ($iResult[0]) Then $tBuffer = 0
	Return SetError($iResult[0], 0, $tBuffer)
EndFunc	;==>_RasGetLinkStatistics

Func _RasDeleteEntry($sEntryName, $sPnebook = $RAS_PHONEBOOK)
	Local $iResult

	$iResult = DllCall($RAS_DllHandle, "dword", "RasDeleteEntry", _
			"str", $sPnebook, "str", $sEntryName)
	Return SetError($iResult[0], 0, $iResult[0] = 0)
EndFunc	;==>_RasDeleteEntry


Func _RasDialDlg($sEntryName, $sPneNumber = "", $iSubEntry = 0, $hWnd = 0, $sPnebook = $RAS_PHONEBOOK)
	Local $iResult, $tBuffer, $pBuffer, $iError

	If ($sPnebook = "") Or ($sPnebook = Default) Then $sPnebook = $RAS_PHONEBOOK
	$tBuffer = DllStructCreate($tagRAS_DIAL_DLG)
	$pBuffer = DllStructGetPtr($tBuffer)
	DllStructSetData($tBuffer, "Size", DllStructGetSize($tBuffer))
	DllStructSetData($tBuffer, "SubEntry", $iSubEntry)
	DllStructSetData($tBuffer, "HWnd", $hWnd)

	$iResult = DllCall($RASDLG_DllHandle, "bool", "RasDialDlg", "str", $sPnebook, _
			"str", $sEntryName, "str", $sPnebook, "ptr", $pBuffer)
	$iError = DllStructGetData($tBuffer, "Error")
	Return SetError($iError, _RasFreeVar($tBuffer), $iResult[0])
EndFunc	;==>_RasDialDlg

Func _RasMonitorDlg($sDeviceName, $iStartPage = 0, $hWnd = 0)
	Local $iResult, $tBuffer, $pBuffer, $iError

	$tBuffer = DllStructCreate($tagRAS_MONITOR_DLG)
	$pBuffer = DllStructGetPtr($tBuffer)
	DllStructSetData($tBuffer, "HWnd", $hWnd)
	DllStructSetData($tBuffer, "StartPage", $iStartPage)
	DllStructSetData($tBuffer, "Size", DllStructGetSize($tBuffer))

	$iResult = DllCall($RASDLG_DllHandle, "bool", "RasMonitorDlg", _
			"str", $sDeviceName, "ptr", $pBuffer)
	$iError = DllStructGetData($tBuffer, "Error")
	Return SetError($iError, _RasFreeVar($tBuffer), $iResult[0])
EndFunc	;==>_RasMonitorDlg

Func _RasEntryDlg($sEntryName, $iFlags = 1, $iSubEntry = 0, $hWnd = 0, $sPnebook = $RAS_PHONEBOOK)
	Local $iResult, $tBuffer, $pBuffer, $iError, $sEntry

	$tBuffer = DllStructCreate($tagRAS_ENTRY_DLG)
	$pBuffer = DllStructGetPtr($tBuffer)
	DllStructSetData($tBuffer, "HWnd", $hWnd)
	DllStructSetData($tBuffer, "Flags", $iFlags)
	DllStructSetData($tBuffer, "Size", DllStructGetSize($tBuffer))

	$iResult = DllCall($RASDLG_DllHandle, "bool", "RasEntryDlg", "str", $sPnebook, _
			"str", $sEntryName, "ptr", $pBuffer)
	$iError = DllStructGetData($tBuffer, "Error")
	$sEntry = DllStructGetData($tBuffer, "EntryName")
	Return SetError($iError, _RasFreeVar($tBuffer, 0, $iResult[0]), $sEntry)
EndFunc	;==>_RasEntryDlg

Func _RasSetCustomAuthData($sEntryName, $vCustomAuthData, $sPnebook = $RAS_PHONEBOOK)
	Local $iResult, $tBuffer, $pBuffer, $iLength

	If IsString($vCustomAuthData) Then
		$tBuffer = DllStructCreate("wchar Data[" & StringLen($vCustomAuthData) + 1 & "]")
	Else
		$tBuffer = DllStructCreate("ubyte Data[" & BinaryLen($vCustomAuthData) & "]")
	EndIf
	$pBuffer = DllStructGetPtr($tBuffer)
	$iLength = DllStructGetSize($tBuffer)
	DllStructSetData($tBuffer, "Data", $vCustomAuthData)

	$iResult = DllCall($RAS_DllHandle, "dword", "RasSetCustomAuthData", "str", $sPnebook, _
			"str", $sEntryName, "ptr", $pBuffer, "dword", $iLength)
	Return SetError($iResult[0], _RasFreeVar($tBuffer), $iResult[0] = 0)
EndFunc	;==>_RasSetCustomAuthData

Func _RasGetCustomAuthData($sEntryName, $sPnebook = $RAS_PHONEBOOK)
	Local $tBuffer, $pBuffer, $iResult, $bReturn

	$iResult = DllCall($RAS_DllHandle, "dword", "RasGetCustomAuthData", "str", $sPnebook, _
			"str", $sEntryName, "ptr", 0, "dword*", 0)
	If ($iResult[4] = 0) Then
		If ($iResult[0] = 603) Then
			Return SetError(0, 0, Binary(""))
		Else
			Return SetError($iResult[0], 0, Binary(""))
		EndIf
	EndIf

	$tBuffer = DllStructCreate("ubyte Binary[" & $iResult[4] & "]")
	$pBuffer = DllStructGetPtr($tBuffer)
	$iResult = DllCall($RAS_DllHandle, "dword", "RasGetCustomAuthData", "str", $sPnebook, _
			"str", $sEntryName, "ptr", $pBuffer, "dword*", $iResult[4])
	$bReturn = DllStructGetData($tBuffer, "Binary")
	Return SetError($iResult[0], _RasFreeVar($tBuffer), $bReturn)
EndFunc	;==>_RasGetCustomAuthData

Const $tagRAS_CREDENTIALS = "dword Size;dword Mask;char UserName[257];char Password[257];char Domain[16]"

Const $RASCM_UserName = 1
Const $RASCM_Password = 2
Const $RASCM_Domain = 4
Const $RASCM_Default = BitOR($RASCM_UserName, $RASCM_Domain)


Func _RasGetCredentials($sEntryName, $iMask = $RASCM_Default, $sPnebook = $RAS_PHONEBOOK)
	Local $iResult, $tBuffer, $pBuffer

	$tBuffer = DllStructCreate($tagRAS_CREDENTIALS)
	$pBuffer = DllStructGetPtr($tBuffer)
	DllStructSetData($tBuffer, "Mask", $iMask)
	DllStructSetData($tBuffer, "Size", DllStructGetSize($tBuffer))

	$iResult = DllCall($RAS_DllHandle, "dword", "RasGetCredentials", _
			"str", $sPnebook, "str", $sEntryName, "ptr", $pBuffer)
	If ($iResult[0]) Then $tBuffer = 0
	Return SetError($iResult[0], 0, $tBuffer)
EndFunc	;==>_RasGetCredentials

Func _RasSetCredentials($sEntryName, $sUserName = Default, $sPassword = Default, _
		$sDomain = Default, $fClearCred = 0, $sPnebook = $RAS_PHONEBOOK)

	Local $iFlags, $iResult, $tBuffer, $pBuffer

	If ($sUserName <> Default) Then $iFlags = BitOR($iFlags, $RASCM_UserName)
	If ($sPassword <> Default) Then $iFlags = BitOR($iFlags, $RASCM_Password)
	If ($sDomain <> Default) Then $iFlags = BitOR($iFlags, $RASCM_Domain)

	$tBuffer = DllStructCreate($tagRAS_CREDENTIALS)
	$pBuffer = DllStructGetPtr($tBuffer)
	DllStructSetData($tBuffer, "Size", DllStructGetSize($tBuffer))
	DllStructSetData($tBuffer, "Mask", $iFlags)

	If ($sUserName <> Default) Then DllStructSetData($tBuffer, "UserName", $sUserName)
	If ($sPassword <> Default) Then DllStructSetData($tBuffer, "Password", $sPassword)
	If ($sDomain <> Default) Then DllStructSetData($tBuffer, "Domain", $sDomain)

	$iResult = DllCall($RAS_DllHandle, "dword", "RasSetCredentials", "str", $sPnebook, _
			"str", $sEntryName, "ptr", $pBuffer, "bool", $fClearCred)
	Return SetError($iResult[0], _RasFreeVar($tBuffer), $iResult[0] = 0)
EndFunc	;==>_RasSetCredentials

Func _RasEnumAutodialAddresses()
	Local $iResult, $aResult[1] = [0], $tBuffer, $pBuffer, $tAddress

	$iResult = DllCall($RAS_DllHandle, "dword", "RasEnumAutodialAddressesW", "ptr", 0, _
			"dword*", 0, "dword*", 0)
	If ($iResult[2] = 0) Then Return SetError($iResult[0], 0, $aResult)

	$pBuffer = _RasAllocHeap($iResult[2])
	$iResult = DllCall($RAS_DllHandle, "dword", "RasEnumAutodialAddressesW", _
			"ptr", $pBuffer, "dword*", $iResult[2], "dword*", $iResult[3])
	If ($iResult[0]) Then Return SetError($iResult[0], _RasFreeHeap($pBuffer), $aResult)

	$tBuffer = DllStructCreate("ptr Addresses[" & $iResult[3] & "]", $pBuffer)
	$aResult[0] = $iResult[3]
	Redim $aResult[$aResult[0] + 1]

	For $i = 1 To $iResult[3]
		$tAddress = DllStructCreate("wchar Address[256]", DllStructGetData($tBuffer, 1, $i))
		$aResult[$i] = DllStructGetData($tAddress, "Address")
		$tAddress = 0
	Next
	_RasFreeVar($tBuffer, 0, _RasFreeHeap($pBuffer))
	Return $aResult
EndFunc	;==>_RasEnumAutodialAddresses

Func _RasGetAutodialAddress($sAddress)
	Local $iResult, $pBuffer, $tBuffer, $iBufferSize, $aResult[1][2] = [[0]]

	$iResult = DllCall($RAS_DllHandle, "dword", "RasGetAutodialAddressW", "wstr", $sAddress, _
			"ptr", 0, "ptr", 0, "dword*", 0, "dword*", 0)
	If ($iResult[4] = 0) Then Return SetError($iResult[0], 0, $aResult)

	$pBuffer = _RasAllocHeap($iResult[4])
	$tBuffer = DllStructCreate($tagRAS_AUTODIAL_ENTRY, $pBuffer)
	$iBufferSize = DllStructGetSize($tBuffer)
	DllStructSetData($tBuffer, "Size", $iBufferSize)

	$iResult = DllCall($RAS_DllHandle, "dword", "RasGetAutodialAddressW", "wstr", $sAddress, _
			"ptr", 0, "ptr", $pBuffer, "dword*", $iResult[4], "dword*", 0)
	If ($iResult[0]) Then
		_RasFreeVar($tBuffer, 0, _RasFreeHeap($pBuffer))
		Return SetError($iResult[0], 0, $aResult)
	EndIf

	$aResult[0][0] = $iResult[5]
	Redim $aResult[$iResult[5] + 1][2]
	For $i = 1 To $aResult[0][0]
		$aResult[$i][0] = DllStructGetData($tBuffer, "DialingLocation")
		$aResult[$i][1] = DllStructGetData($tBuffer, "EntryName")
		$tBuffer = 0
		$tBuffer = DllStructCreate($tagRAS_AUTODIAL_ENTRY, $pBuffer + ($i - 1) * $iBufferSize)
	Next
	_RasFreeVar($tBuffer, 0, _RasFreeHeap($pBuffer))
	Return $aResult
EndFunc	;==>_RasGetAutodialAddress

Func _RasSetAutodialAddress($sAddress, $sEntryName, $iDialingLocation = 1)
	Local $tBuffer, $pBuffer, $iBufferSize, $iNumberAddr, $iResult

	If ($sEntryName) Then
		$iNumberAddr = 1
		$tBuffer = DllStructCreate($tagRAS_AUTODIAL_ENTRY)
		$pBuffer = DllStructGetPtr($tBuffer)
		$iBufferSize = DllStructGetSize($tBuffer)
		DllStructSetData($tBuffer, "Size", $iBufferSize)
		DllStructSetData($tBuffer, "EntryName", $sEntryName)
		DllStructSetData($tBuffer, "DialingLocation", $iDialingLocation)
	EndIf

	$iResult = DllCall($RAS_DllHandle, "dword", "RasSetAutodialAddressW", "wstr", $sAddress, _
			"dword", 0, "ptr", $pBuffer, "dword", $iBufferSize, "dword", $iNumberAddr)
	Return SetError($iResult[0], _RasFreeVar($tBuffer), $iResult[0] = 0)
EndFunc	;==>_RasSetAutodialAddress

Func _RasSetAutodialEnable($fEnable = 1, $iDialingLocation = 1)
	Local $iResult
	$iResult = DllCall($RAS_DllHandle, "dword", "RasSetAutodialEnable", _
			"dword", $iDialingLocation, "bool", $fEnable)
	Return SetError($iResult[0], 0, $iResult[0] = 0)
EndFunc	;==>_RasSetAutodialEnable

Func _RasGetAutodialEnable($iDialingLocation = 1)
	Local $iResult
	$iResult = DllCall($RAS_DllHandle, "dword", "RasGetAutodialEnable", _
			"dword", $iDialingLocation, "bool*", 0)
	Return SetError($iResult[0], 0, $iResult[2])
EndFunc	;==>_RasGetAutodialEnable

Const $RASADP_DisableConnectionQuery = 0 
Const $RASADP_LoginSessionDisable = 1 
Const $RASADP_SavedAddressesLimit = 2 
Const $RASADP_FailedConnectionTimeout = 3 
Const $RASADP_ConnectionQueryTimeout = 4 

Func _RasGetAutodialParam($iAutodialParam)
	Local $iResult
	$iResult = DllCall($RAS_DllHandle, "dword", "RasGetAutodialParam", _
			"dword", $iAutodialParam, "dword*", 0, "dword*", 4)
	Return SetError($iResult[0], 0, $iResult[2])
EndFunc	;==>_RasGetAutodialParam


Func _RasSetAutodialParam($iAutodialParam, $iValue)
	Local $iResult
	$iResult = DllCall($RAS_DllHandle, "dword", "RasSetAutodialParam", _
			"dword", $iAutodialParam, "dword*", $iValue, "dword", 4)
	Return SetError($iResult[0], 0, $iResult[0] = 0)
EndFunc	;==>_RasSetAutodialParam



Func _RasGetEntryDialParams($sEntryName, $sPnebook = $RAS_PHONEBOOK)
	Local $tBuffer, $pBuffer, $iResult

	$tBuffer = DllStructCreate($tagRAS_DIAL_PARAMS)
	$pBuffer = DllStructGetPtr($tBuffer)
	DllStructSetData($tBuffer, "Size", DllStructGetSize($tBuffer))
	DllStructSetData($tBuffer, "EntryName", $sEntryName)

	$iResult = DllCall($RAS_DllHandle, "dword", "RasGetEntryDialParamsW", _
			"wstr", $sPnebook, "ptr", $pBuffer, "bool*", 0)
	If ($iResult[0]) Then $tBuffer = 0
	Return SetError($iResult[0], $iResult[3], $tBuffer)
EndFunc	;==>_RasGetEntryDialParams

Func _RasSetEntryDialParams($sEntryName, ByRef $tDialParams, $fReservePswd = 1, $sPnebook = $RAS_PHONEBOOK)
	Local $iResult, $pBuffer

	$pBuffer = DllStructGetPtr($tDialParams)
	If Not IsPtr($pBuffer) Then Return SetError(87, 0, False)

	$iResult = DllCall($RAS_DllHandle, "dword", "RasSetEntryDialParamsW", _
			"wstr", $sPnebook, "ptr", $pBuffer, "bool", Not $fReservePswd)
	Return SetError($iResult[0], 0, $iResult[0] = 0)
EndFunc	;==>_RasSetEntryDialParams


Func _RasGetEntryProperties($sEntryName, $sPnebook = $RAS_PHONEBOOK)
	Local $iResult, $pBuffer, $tBuffer

	$iResult = DllCall($RAS_DllHandle, "dword", "RasGetEntryPropertiesW", _
			"wstr", $sPnebook, "wstr", $sEntryName, "ptr", 0, _
			"dword*", 0, "ptr", 0, "ptr", 0)
	If ($iResult[4] = 0) Then Return SetError($iResult[0], 0, 0)

	$pBuffer = _RasAllocHeap($iResult[4])
	$tBuffer = DllStructCreate($tagRAS_ENTRY, $pBuffer)
	DllStructSetData($tBuffer, "Size", $iResult[4])

	$iResult = DllCall($RAS_DllHandle, "dword", "RasGetEntryPropertiesW", _
			"wstr", $sPnebook, "wstr", $sEntryName, "ptr", $pBuffer, _
			"dword*", $iResult[4], "ptr", 0, "ptr", 0)
	If ($iResult[0]) Then _RasFreeVar($tBuffer, 0, _RasFreeHeap($pBuffer))
	Return SetError($iResult[0], $iResult[4], $tBuffer)
EndFunc	;==>_RasGetEntriesProperties

Func _RasSetEntryProperties($sEntryName, ByRef $tEntryProperty, $iBufferSize, $sPnebook = $RAS_PHONEBOOK)
	Local $pBuffer, $iResult

	$pBuffer = DllStructGetPtr($tEntryProperty)
	If Not IsPtr($pBuffer) Then Return SetError(87, 0, False)

	$iResult = DllCall($RAS_DllHandle, "dword", "RasSetEntryPropertiesW", "wstr", $sPnebook, _
			"wstr", $sEntryName, "ptr", $pBuffer, "dword", $iBufferSize, _
			"ptr", 0, "dword", 0)
	Return SetError($iResult[0], 0, $iResult[0] = 0)
EndFunc	;==>_RasSetEntryProperties

; #### Flags for RAS_ENTRY.Options1 ####
; ================================================================================================
Const $RASEO_UseCountryAndAreaCodes = 0x00000001
Const $RASEO_SpecificIpAddr = 0x00000002
Const $RASEO_SpecificNameServers = 0x00000004
Const $RASEO_IpHeaderCompression = 0x00000008
Const $RASEO_RemoteDefaultGateway = 0x00000010
Const $RASEO_DisableLcpExtensions = 0x00000020
Const $RASEO_TerminalBeforeDial = 0x00000040
Const $RASEO_TerminalAfterDial = 0x00000080
Const $RASEO_ModemLights = 0x00000100
Const $RASEO_SwCompression = 0x00000200
Const $RASEO_RequireEncryptedPw = 0x00000400
Const $RASEO_RequireMsEncryptedPw = 0x00000800
Const $RASEO_RequireDataEncryption = 0x00001000
Const $RASEO_NetworkLogon = 0x00002000
Const $RASEO_UseLogonCredentials = 0x00004000
Const $RASEO_PromoteAlternates = 0x00008000
Const $RASEO_SecureLocalFiles = 0x00010000
Const $RASEO_DialAsLocalCall = 0x00020000

Const $RASEO_ProhibitPAP = 0x00040000
Const $RASEO_ProhibitCHAP = 0x00080000
Const $RASEO_ProhibitMsCHAP = 0x00100000
Const $RASEO_ProhibitMsCHAP2 = 0x00200000
Const $RASEO_ProhibitEAP = 0x00400000
Const $RASEO_SharedPhoneNumbers = 0x00800000

Const $RASEO_PreviewUserPw = 0x01000000
Const $RASEO_PreviewDomain = 0x02000000
Const $RASEO_ShowDialingProgress = 0x04000000
Const $RASEO_RequireCHAP = 0x08000000

Const $RASEO_RequireMsCHAP = 0x10000000
Const $RASEO_RequireMsCHAP2 = 0x20000000
Const $RASEO_RequireW95MSCHAP = 0x40000000
Const $RASEO_CustomScript = 0x80000000
; ================================================================================================

; #### Flags for _RasGetEntryDialOptions ####
; ================================================================================================
Const $RASDO_Invalid = -1
Const $RASDO_ShowProgress = 1
Const $RASDO_PromptUserPw = 2
Const $RASDO_IncludeLogonDomain = 4
Const $RASDO_Default = BitOR($RASDO_ShowProgress, $RASDO_PromptUserPw)
; ================================================================================================

Func _RasGetEntryDialOptions($sEntryName, $sPnebook = $RAS_PHONEBOOK)
	Local $iFlags, $tBuffer, $iOptions = 0

	$tBuffer = _RasGetEntryProperties($sEntryName, $sPnebook)
	If (@error) Then Return SetError(@error, 0, $RASDO_Invalid)

	$iFlags = DllStructGetData($tBuffer, "Options1")
	_RasFreeVar($tBuffer, 0, _RasFreeHeap(DllStructGetPtr($tBuffer)))

	If BitAnd($iFlags, $RASEO_ShowDialingProgress) Then $iOptions = BitOR($iOptions, $RASDO_ShowProgress)
	If BitAnd($iFlags, $RASEO_PreviewUserPw) Then $iOptions = BitOR($iOptions, $RASDO_PromptUserPw)
	If BitAnd($iFlags, $RASEO_PreviewDomain) Then $iOptions = BitOR($iOptions, $RASDO_IncludeLogonDomain)

	Return $iOptions
EndFunc	;==>_RasGetEntryDialOptions

Func _RasSetEntryDialOptions($sEntryName, $iOptions = $RASDO_Default, $sPnebook = $RAS_PHONEBOOK)
	Local $tBuffer, $iFlags, $iBufferSize, $fResult

	$tBuffer = _RasGetEntryProperties($sEntryName, $sPnebook)
	If (@error) Then Return SetError(@error, 0, False)
	$iBufferSize = @Extended

	$iFlags = DllStructGetData($tBuffer, "Options1")

	If BitAnd($iOptions, $RASDO_ShowProgress) Then
		$iFlags = BitOR($iFlags, $RASEO_ShowDialingProgress)
	ElseIf BitAnd($iFlags, $RASEO_ShowDialingProgress) Then
		$iFlags = BitXOR($iFlags, $RASEO_ShowDialingProgress)
	EndIf
	If BitAnd($iOptions, $RASDO_PromptUserPw) Then
		$iFlags = BitOR($iFlags, $RASEO_PreviewUserPw)
	ElseIf BitAnd($iFlags, $RASEO_PreviewUserPw) Then
		$iFlags = BitXOR($iFlags, $RASEO_PreviewUserPw)
	EndIf
	If BitAnd($iOptions, $RASDO_IncludeLogonDomain) Then
		$iFlags = BitOR($iFlags, $RASEO_PreviewDomain)
	ElseIf BitAnd($iFlags, $RASEO_PreviewDomain) Then
		$iFlags = BitXOR($iFlags, $RASEO_PreviewDomain)
	EndIf

	DllStructSetData($tBuffer, "Options1", $iFlags)
	$fResult = _RasSetEntryProperties($sEntryName, $tBuffer, $iBufferSize, $sPnebook)
	_RasFreeVar($tBuffer, 0, 0, @error, _RasFreeHeap(DllStructGetPtr($tBuffer)))
	Return SetError(@error, 0, $fResult)
EndFunc	;==>_RasSetEntryDialOptions

; #### Flags for RAS_Entry.Options2 ####
; ================================================================================================
Const $RASEO2_SecureFileAndPrint = 0x00000001
Const $RASEO2_SecureClientForMSNet = 0x00000002
Const $RASEO2_DontNegotiateMultilink = 0x00000004
Const $RASEO2_DontUseRasCredentials = 0x00000008
Const $RASEO2_UsePreSharedKey = 0x00000010
Const $RASEO2_Internet = 0x00000020
Const $RASEO2_DisableNbtOverIP = 0x00000040
Const $RASEO2_UseGlobalDeviceSettings = 0x00000080
Const $RASEO2_ReconnectIfDropped = 0x00000100
Const $RASEO2_SharePhoneNumbers = 0x00000200
; ================================================================================================

Func _RasSetEntryRedialOptions($sEntryName, $iRedialCount = Default, $iRedialPause = Default, _
		$iDisconnect = Default, $fRedialIfDropped = Default, $sPnebook = $RAS_PHONEBOOK)

	Local $tBuffer, $fResult, $iFlags, $iBufferSize

	$tBuffer = _RasGetEntryProperties($sEntryName, $sPnebook)
	If (@error) Then Return SetError(@error, 0, False)
	$iBufferSize = @Extended

	If ($iRedialCount <> Default) Then DllStructSetData($tBuffer, "RedialCount", $iRedialCount)
	If ($iRedialPause <> Default) Then DllStructSetData($tBuffer, "RedialPause", $iRedialPause)
	If ($iDisconnect <> Default) Then DllStructSetData($tBuffer, "IdleDisconnectSeconds", $iDisconnect)
	If ($fRedialIfDropped <> Default) Then
		$iFlags = DllStructGetData($tBuffer, "Options2")
		If ($fRedialIfDropped) Then
			$iFlags = BitOR($iFlags, $RASEO2_ReconnectIfDropped)
		ElseIf BitAnd($iFlags, $RASEO2_ReconnectIfDropped) Then
			$iFlags = BitXOR($iFlags, $RASEO2_ReconnectIfDropped)
		EndIf
		DllStructSetData($tBuffer, "Options2", $iFlags)
	EndIf

	$fResult = _RasSetEntryProperties($sEntryName, $tBuffer, $iBufferSize, $sPnebook)
	_RasFreeVar($tBuffer, 0, 0, @error, _RasFreeHeap(DllStructGetPtr($tBuffer)))
	Return SetError(@error, 0, $fResult)
EndFunc	;==>_RasSetEntryRedialOptions

Func _RasGetEntryRedialOptions($sEntryName, $sPnebook = $RAS_PHONEBOOK)
	Local $aResult[4], $tBuffer

	$tBuffer = _RasGetEntryProperties($sEntryName, $sPnebook)
	If (@error) Then Return SetError(@error, 0, $aResult)

	$aResult[0] = DllStructGetData($tBuffer, "RedialCount")
	$aResult[1] = DllStructGetData($tBuffer, "RedialPause")
	$aResult[2] = DllStructGetData($tBuffer, "IdleDisconnectSeconds")
	$aResult[3] = BitAnd(DllStructGetData($tBuffer, "Options2"), 0x100) = 0x100

	_RasFreeVar($tBuffer, 0, _RasFreeHeap(DllStructGetPtr($tBuffer)))
	Return $aResult
EndFunc	;==>_RasGetEntryRedialOptions

; #### Flags for _RasGetEntryEncryption ####
; ================================================================================================
Const $ET_Invalid = -1	; The call is failed.
Const $ET_None = 0	; No encryption allowed.
Const $ET_Require = 1	; Require encryption.
Const $ET_RequireMax = 2	; Maximum strength encryption
Const $ET_Optional = 3	; Optional encryption (Do encryption if possible, no encryption is okay).
; ================================================================================================

Func _RasGetEntryEncryption($sEntryName, $sPnebook = $RAS_PHONEBOOK)
	Local $iFlags, $tBuffer

	$tBuffer = _RasGetEntryProperties($sEntryName, $sPnebook)
	If (@error) Then Return SetError(@error, 0, $ET_INVALID)

	$iFlags = DllStructGetData($tBuffer, "EncryptionType")
	_RasFreeVar($tBuffer, 0, _RasFreeHeap(DllStructGetPtr($tBuffer)))
	Return $iFlags
EndFunc	;==>_RasGetEntryEncryption

Func _RasSetEntryEncryption($sEntryName, $iEncryptionType, $sPnebook = $RAS_PHONEBOOK)
	Local $fResult, $tBuffer, $iBufferSize

	$tBuffer = _RasGetEntryProperties($sEntryName, $sPnebook)
	If (@error) Then Return SetError(@error, 0, False)
	$iBufferSize = @Extended

	DllStructSetData($tBuffer, "EncryptionType", $iEncryptionType)
	$fResult = _RasSetEntryProperties($sEntryName, $tBuffer, $iBufferSize, $sPnebook)
	_RasFreeVar($tBuffer, 0, 0, @error, _RasFreeHeap(DllStructGetPtr($tBuffer)))
	Return SetError(@error, 0, $fResult)
EndFunc	;==>_RasSetEntryEncryption	


; #### Vars for _RasDial function ####
; ================================================================================================
Global $s_RasDialCallBackRouter
Global $i_RasDialCallBackState
Global $f_RasDialCallBackFlags
; ================================================================================================
Func _RasDial($sEntryName, $sUserName, $sPassword, $sCallBack = "", $sPnebook = $RAS_PHONEBOOK)
	Local $iResult, $tBuffer, $pBuffer, $hCallBack, $pCallBack

	$tBuffer = DllStructCreate($tagRAS_DIAL_PARAMS)
	$pBuffer = DllStructGetPtr($tBuffer)
	DllStructSetData($tBuffer, "Size", DllStructGetSize($tBuffer))
	DllStructSetData($tBuffer, "EntryName", $sEntryName)
	DllStructSetData($tBuffer, "UserName", $sUserName)
	DllStructSetData($tBuffer, "Password", $sPassword)

	$hCallBack = DllCallBackRegister("___RasDialCallBack", "int", "hWnd;uint;dword;dword;dword")
	$pCallBack = DllCallBackGetPtr($hCallBack)

	$f_RasDialCallBackFlags = 0
	$s_RasDialCallBackRouter = $sCallBack

	$iResult = DllCall($RAS_DllHandle, "dword", "RasDialW", "ptr", 0, _
			"wstr", $sPnebook, "ptr", $pBuffer, "dword", 1, _
			"ptr", $pCallBack, "hWnd*", 0)
	If ($iResult[0]) Then
		DllCallBackFree($hCallBack)
		Return SetError($iResult[0], _RasFreeVar($tBuffer), 0)
	EndIf

	While (Not $f_RasDialCallBackFlags)
		Sleep(1)
	WEnd
	DllCallBackFree($hCallBack)
	Return SetError($iResult[0], _RasFreeVar($tBuffer), $iResult[6])
EndFunc	;==>_RasDial

Func ___RasDialCallBack($hRasConn, $iMsg, $iState, $iError, $iExtended)
	If ($s_RasDialCallBackRouter) Then
		Call($s_RasDialCallBackRouter, $hRasConn, $iState, $iError)
	EndIf

	If ($iError) OR ($iState = 0x1000) OR ($iState = 0x2000) Then
		$f_RasDialCallBackFlags = 1
	EndIf
EndFunc	;==>___RasDialCallBack

Func _RasGetEapUserData($sEntryName, $hToken = 0, $sPnebook = $RAS_PHONEBOOK)
	Local $iResult, $tBuffer, $pBuffer, $bBinary

	$iResult = DllCall($RAS_DllHandle, "dword", "RasGetEapUserData", "handle", $hToken, _
			"str", $sPnebook, "str", $sEntryName, "ptr", 0, "dword*", 0)
	If ($iResult[5] = 0) Then Return SetError($iResult[0], 0, Binary(""))

	$tBuffer = DllStructCreate("ubyte Binary[" & $iResult[5] & "]")
	$pBuffer = DllStructGetPtr($tBuffer)

	$iResult = DllCall($RAS_DllHandle, "dword", "RasGetEapUserData", "handle", $hToken, _
			"str", $sPnebook, "str", $sEntryName, "ptr", $pBuffer, "dword*", $iResult[5])
	$bBinary = DllStructGetData($tBuffer, "Binary")
	Return SetError($iResult[0], _RasFreeVar($tBuffer), $bBinary)
EndFunc	;==>_RasGetEapUserData

Func _RasSetEapUserData($sEntryName, $bUserData, $hToken = 0, $sPnebook = $RAS_PHONEBOOK)
	Local $iResult, $tBuffer, $pBuffer, $iBufferSize

	If IsString($bUserData) Then
		$tBuffer = DllStructCreate("wchar Data[" & StringLen($bUserData) + 1 & "]")
	Else
		$tBuffer = DllStructCreate("ubyte Data[" & BinaryLen($bUserData) + 1 & "]")
	EndIf
	$pBuffer = DllStructGetPtr($tBuffer)
	$iBufferSize = DllStructGetSize($tBuffer)
	DllStructSetData($tBuffer, "Data", $bUserData)

	$iResult = DllCall($RAS_DllHandle, "dword", "RasSetEapUserData", "handle", $hToken, _
			"str", $sPnebook, "str", $sEntryName, _
			"ptr", $pBuffer, "dword", $iBufferSize)
	Return SetError($iResult[0], _RasFreeVar($tBuffer), $iResult[0] = 0)
EndFunc	;==>_RasSetEapUserData

Func _RasValidateEntryName($sEntryName, $sPnebook = $RAS_PHONEBOOK)
	Local $iResult

	If (StringRegExp($sEntryName, "[\|<>\?\*\\\/\:]")) Then
		Return SetError(123, 0, False)
	EndIf

	$iResult = DllCall($RAS_DllHandle, "dword", "RasValidateEntryName", _
			"str", $sPnebook, "str", $sEntryName)
	Return SetError($iResult[0], 0, $iResult[0] = 0)
EndFunc	;==>_RasValidateEntryName

Const $RASP_Amb = 0x10000
Const $RASP_PppNbf = 0x803F
Const $RASP_PppIpx = 0x802B
Const $RASP_PppIp = 0x8021
Const $RASP_PppIPv6 = 0x8057
Const $RASP_PppCcp = 0x80FD
Const $RASP_PppLcp = 0xC021
Const $RASP_Slip = 0x20000


Func _RasGetProjectionInfo($hRasConn, $iProject)
	Local $tBuffer, $pBuffer, $iBufferSize, $iResult

	Switch $iProject
	Case $RASP_Amb
		$tBuffer = DllStructCreate($tagRAS_AMB)
	Case $RASP_PppNbf
		$tBuffer = DllStructCreate($tagRAS_PPPNBF)
	Case $RASP_PppIpx
		$tBuffer = DllStructCreate($tagRAS_PPPIPX)
	Case $RASP_PppIp
		$tBuffer = DllStructCreate($tagRAS_PPPIP)
	Case $RASP_PppIPv6
		$tBuffer = DllStructCreate($tagRAS_PPPIPV6)
	Case $RASP_PppLcp
		$tBuffer = DllStructCreate($tagRAS_PPPLCP)
	Case $RASP_PppCcp
		$tBuffer = DllStructCreate($tagRAS_PPPCCP)
	Case $RASP_Slip
		$tBuffer = DllStructCreate($tagRAS_SLIP)
	Case Else
		Return SetError(87, 0, 0)
	EndSwitch

	$pBuffer = DllStructGetPtr($tBuffer)
	$iBufferSize = DllStructGetSize($tBuffer)
	DllStructSetData($tBuffer, "Size", $iBufferSize)

	$iResult = DllCall($RAS_DllHandle, "dword", "RasGetProjectionInfoW", "hWnd", $hRasConn, _
			"dword", $iProject, "ptr", $pBuffer, "dword*", $iBufferSize)
	If ($iResult[0]) Then $tBuffer = 0
	Return SetError($iResult[0], 0, $tBuffer)
EndFunc	;==>_RasGetProjectionInfo

Func _RasGetConnectionIpAddresses($hRasConn)
	Local $tBuffer, $aResult[2]

	$tBuffer = _RasGetProjectionInfo($hRasConn, $RASP_PPPIP)
	If (@error) Then Return SetError(@error, 0, $aResult)

	$aResult[0] = DllStructGetData($tBuffer, "IpAddress")
	$aResult[1] = DllStructGetData($tBuffer, "ServerIpAddress")
	Return _RasFreeVar($tBuffer, 0, $aResult)
EndFunc	;==>_RasGetConnectionIpAddresses

Func _RasGetConnectResponse($hRasConn)
	Local $iResult

	$iResult = DllCall($RAS_DllHandle, "dword", "RasGetConnectResponse", _
			"hWnd", $hRasConn, "dword*", 0)
	Return SetError($iResult[0], 0, $iResult[2])
EndFunc	;==>_RasGetConnectResponse

Func _RasGetConnectionProperties($hRasConn)
	Local $aRasConn, $tBuffer = 0, $iFlags

	$aRasConn = _RasEnumConnections()
	If (@error) Then Return SetError(@error, 0, 0)
	If ($aRasConn[0][0] < 1) Then Return SetError(668, 0, 0)

	For $i = 1 To $aRasConn[0][0]
		If ($aRasConn[$i][0] = $hRasConn) Then
			$tBuffer = _RasGetEntryProperties($aRasConn[$i][1], $aRasConn[$i][4])
			ExitLoop _RasFreeVar($iFlags, 1, 1, @error)
		EndIf
	Next
	$aRasConn = 0
	If ($iFlags) Then
		Return SetError(@error, 0, $tBuffer)
	Else
		Return SetError(668, 0, 0)
	EndIf
EndFunc	;==>_RasGetConnectionProperties


































