#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_Change2CUI=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

ConsoleWrite("HPMSG - 6/20/13" & @CRLF)

if $cmdline[0] = 2 Then

$strPrinterIP = $cmdline[1]
$strMessage = $cmdline[2]

if StringLen($strMessage) >= 25 Then
	ConsoleWrite("New message cannot exceed 24 characters. [" & StringLen($strMessage) & "] Counted" & @LF)
	Exit
EndIf

TCPStartUp()

$socPrinter = TCPConnect($strPrinterIP, 9100)
If $socPrinter = -1 Then
	ConsoleWrite("Unable to connect to printer: " & $strPrinterIP & @LF)
	Exit
EndIf

$strCommand = Chr(27) & Chr(27) & "%-12345X@PJL RDYMSG DISPLAY = " & Chr(34) & $strMessage & Chr(34) & @LF & Chr(27) & "%-12345X" & @LF
TCPSend($socPrinter, $strCommand)

ConsoleWrite("Sent " & _GetStringSize($strCommand, false) & " bytes." & @LF)
ConsoleWrite('Printer: ' & $strPrinterIP & ' should now be displaying "' & $strMessage & '"' & @LF)

Else
	ConsoleWrite("You must run HPMSG with two arguments." & @LF)
	ConsoleWrite('hpmsg <ip> <msg>' & @LF)
	sleep(1000)
	Exit
EndIf
Exit

Func _GetStringSize($sString, $fOutput = Default)
    Local Const $aOutput[9] = [' bytes', ' KB', ' MB', ' GB', ' TB', ' PB', ' EB', ' ZB', ' YB']
    Local Const $iUBound = UBound($aOutput)
    Local $iFileGetSize = StringLen($sString), $iCount = 0
    If $fOutput Then
        While $iFileGetSize > 1023
            $iCount += 1
            $iFileGetSize /= 1024
        WEnd
        $iFileGetSize = Round($iFileGetSize, 2) & $aOutput[$iCount]
    EndIf
    Return $iFileGetSize
EndFunc   ;==>_GetStringSize