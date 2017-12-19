;coded by UEZ
#AutoIt3Wrapper_UseX64=n
#include <apiconstants.au3>

$binWave = Wave()
$tWave = DllStructCreate('byte[' & BinaryLen($binWave) & ']')
$pWave = DllStructGetPtr($tWave)
DllStructSetData($tWave, 1, $binWave)
_WinAPI_PlaySound($pWave, BitOR($SND_ASYNC, $SND_MEMORY, $SND_NOWAIT))

$tWave = 0

Sleep(2000)

; #FUNCTION# ====================================================================================================================
; Name...........: _WinAPI_PlaySound
; Description....: Plays a sound specified by the given file name, resource, or system event.
; Syntax.........: _WinAPI_PlaySound ( $sSound [, $iFlags [, $hInstance]] )
; Parameters.....: $sSound - The string that specifies the sound to play. The maximum length is 255 characters. If $sSound is
; empty, any currently playing waveform sound is stopped.
; $iFlags - The flags for sound playing. This parameter can be one or more of the following values.
;
; $SND_APPLICATION
; $SND_ALIAS
; $SND_ALIAS_ID
; $SND_ASYNC
; $SND_FILENAME
; $SND_LOOP
; $SND_MEMORY
; $SND_NODEFAULT
; $SND_NOSTOP
; $SND_NOWAIT
; $SND_PURGE
; $SND_RESOURCE
; $SND_SYNC
;
; Windows Vista or later
;
; $SND_SENTRY
; $SND_SYSTEM
;
; Three flags ($SND_ALIAS, $SND_FILENAME, and $SND_RESOURCE) determine whether the name is interpreted
; as an alias for a system event, a file name, or a resource identifier. If none of these flags are
; specified, _WinAPI_PlaySound() searches the registry or the WIN.INI file for an association with
; the specified sound name. If an association is found, the sound event is played. If no association
; is found in the registry, the name is interpreted as a file name.
;
; If the $SND_ALIAS_ID flag is specified in $iFlags, the $sSound parameter must be one of the
; $SND_ALIAS_* values.
;
; (See MSDN for more information)
;
; $hInstance - Handle to the executable file that contains the resource to be loaded. If $iFlags does not
; contain the $SND_RESOURCE, this parameter will be ignored.
; Return values..: Success - 1.
; Failure - 0 and sets the @error flag to non-zero.
; Author.........: Yashied
; Modified.......:
; Remarks........: None
; Related........:
; Link...........: @@MsdnLink@@ PlaySound
; Example........: Yes
; ===============================================================================================================================
Func _WinAPI_PlaySound($sSound, $iFlags = 0x00020010, $hInstance = 0)
    Local $TypeOfSound = 'ptr'
    If $sSound Then
        If IsString($sSound) Then $TypeOfSound = 'wstr'
    Else
        $sSound = 0
        $iFlags = 0
    EndIf
    Local $Ret = DllCall('winmm.dll', 'int', 'PlaySoundW', $TypeOfSound, $sSound, 'ptr', $hInstance, 'dword', $iFlags)
    If (@error) Or (Not $Ret[0]) Then Return SetError(1, 0, 0)
    Return 1
EndFunc   ;==>_WinAPI_PlaySound

Func Wave()
    Local $Wave
    $Wave &= 'UklGRg4qAABXQVZFZm10IBAAAAABAAEAQB8AAIA+AAACABAAZGF0YeopAACv/rTxoAOxDSX6RfPpB20LO/Yr9lkL+Qdd8xX6lg2yA9Pxm/5iDg7/xfFBA64Nhfo384wHiQuV9gD2CAsxCKTz0vlYDQAEA/JG/kAOaf/Y8eMCqg3k+izzLwekC+z21/W2CmcI7vOQ+RoNTAQ18vH9HQ7C/+7xhAKlDUL7I/PSBrwLRvew9WQKmwg39FD52wyVBGjyoP32DRkAB/IpApwNn/sc83cG0Que94z1EgrMCIH0E/mbDN0EnPJP/c8NcAAg8s8BkQ38+xjzGgbmC/b3a/W+CfwIzPTX+FoMIwXS8gH9pg3EADzydQGFDVf8FvPABfYLTvhM9WsJKAkY9Z74FwxmBQrztfx7DRcBWvIdAXYNsfwV82UFBQyn+C/1GAlSCWX1Z/jUC6gFQ/Np/E4NagF48sYAZQ0L/RnzCwURDP74FPXFCHoJsfU0+I8L6AV88yH8IA26AZnycQBSDWP9HfOzBBoMVvn89HIInwn/9QH4SgsmBrfz2vvxDAkCvPIcADwNvP0j81oEIwys+eb0HgjECUz20fcEC2AG9POV+8AMVQLg8sz/JA0R/izzAgQnDAT60/TLB+QJmvaj974KmgYw9FP7jQygAgfzev8LDWf+N/OsAysMWvrB9HcHAwrp9nj3dgrRBm/0EPtbDOoCLvMq//AMu/5E81UDLAyw+rL0JAcgCjb3T/cwCgUHrvTR+iYMMQNX893+1AwN/1PzAQMrDAT7pvTRBjoKhvcn9+cJOAfu9JT67wt4A4Lzj/62DF//ZPOsAigMWfub9H4GUgrV9wL3nwlpBy71Wvq5C7sDrvNF/pYMr/9381kCIwyt+5L0LAZoCiP44PZVCZcHcPUh+oEL/QPb8/r9dQz//4vzBgIcDAH8jPTZBXwKcvi/9gwJxAey9en5SAs+BAn0s/1SDEoAo/O2ARMMU/yI9IgFjQrB+KH2wgjuB/X1tPkOC3wEOfRt/S4MlQC882YBCAyk/IX0NwWdCg/5hfZ3CBcIOPaB+dIKuQRr9Cj9BwzhANXzFwH7C/X8hvTlBKsKXfls9i4IPAh89lD5lgr0BJ305vzgCykB8fPJAOwLRf2I9JYEtQqs+VP25AdgCL/2IvlZCiwF1fSl/K4LcgEa9HsAywua/Z/0OwSpCgr6VPaDB2wIIvcI+foJUgUt9XL8YAuxAV/0LwCUC+79yPThA44Kafpf9iMHcAiB9/X4ngl1BYP1QvwQC+4BpPTr/1cLP/719IoDbwrF+m/2xQZvCN/35vhDCZIF2vUV/MIKJwLp9Kb/HguL/iL1NgNQCh37gPZqBm4IOvjZ+OkIrgUu9uv7dQpeAi31Y//lCtj+TvXjAjEKdvuP9g4GbgiX+Mn4jwjNBYP2v/snCpYCcvUh/6sKI/989ZACEgrN+6H2tQVqCPD4v/g4COUF1vaa+9oJyAK39eT+cApp/6z1QgLvCSD8tvZgBWMIRPm5+OQH+QUm93n7jwn0Avv1rf41Cqr/3PX6AcoJbvzP9g0FVwia+bb4kQcJBnn3W/tDCR4DP/Z4/vkJ6f8N9rMBpgm7/Ob2vAROCO35sfg+BxwGxvc8+/oISgOB9kH+wQkmAD32bQGCCQf9/fZrBEUIPvqv+O0GKwYU+CD7sQhyA8P2D/6HCWIAbfYpAV0JUf0X9x8ENQiN+rH4ngY2BmL4CftnCJUDCPfg/UsJmgCg9ukANAmX/TX30wMlCNv6tPhQBkAGrfjz+h4ItwNL97P9DgnSANP2qgAMCdz9UveJAxUIJ/u4+AMGSQb4+N761wfXA4z3if3VCAQBBPdwAOQIHv5t90UDBAhu+7z4vAVPBj/5zfqUB/IDzPdj/ZsIMwE39zcAughd/o73AAPuB7f7xvhyBVEGifm++kwHDQQO+D/9XghiAWv3AQCQCJn+r/e9AtgH/vvS+CkFUgbR+bL6BgckBFH4'
    $Wave &= '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'
    $Wave &= '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'
    $Wave &= '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'
    $Wave &= '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'
    $Wave &= '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'
    $Wave &= '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'
    $Wave &= 'CwCyAHX/w/+xAMX/T/8JAar/MP9SAU7/fP83AS3/y//YAHn/tv+hAOf/TP/PAAAAA/8pAbb/Iv9DAWz/ff/5AIv/nf+cAPv/V/+UAEIA+f7kABwA5/4oAcX/Lv8IAbH/d/+hAAQAaP9kAGgADv+SAHMA0P7rACcA8f77AO3/SP+mABEAb/9GAHcANP9DALAA3P6WAIYA0P7OADgAHP+fACoAa/83AHUAYP8EAMsACv82ANIA0f6EAIsA/f6FAFIAXf8vAHAAg//d/8kAR//h//4A9f4pANYA9/5TAIUAT/8kAHAAm//I/7UAif+d/wgBN//M/wcBEP8NALsASP8OAHwApf/C/5kAwv91//IAiP95/w=='
    Return Binary(_Base64Decode($Wave))
EndFunc   ;==>Wave

Func _Base64Decode($input_string)
    Local $struct = DllStructCreate("int")
    Local $a_Call = DllCall("Crypt32.dll", "int", "CryptStringToBinary", "str", $input_string, "int", 0, "int", 1, "ptr", 0, "ptr", DllStructGetPtr($struct, 1), "ptr", 0, "ptr", 0)
    If @error Or Not $a_Call[0] Then Return SetError(1, 0, "")
    Local $a = DllStructCreate("byte[" & DllStructGetData($struct, 1) & "]")
    $a_Call = DllCall("Crypt32.dll", "int", "CryptStringToBinary", "str", $input_string, "int", 0, "int", 1, "ptr", DllStructGetPtr($a), "ptr", DllStructGetPtr($struct, 1), "ptr", 0, "ptr", 0)
    If @error Or Not $a_Call[0] Then Return SetError(2, 0, "")
    Return DllStructGetData($a, 1)
EndFunc   ;==>_Base64Decode