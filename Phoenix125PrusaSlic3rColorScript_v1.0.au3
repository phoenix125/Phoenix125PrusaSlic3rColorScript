#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=Resources\phoenix.ico
#AutoIt3Wrapper_Outfile=Builds\Phoenix125PrusaSlic3rColorScript.exe
#AutoIt3Wrapper_Outfile_x64=Builds\Phoenix125PrusaSlic3rColorScript_64-bit(x64).exe
#AutoIt3Wrapper_Compile_Both=n
#AutoIt3Wrapper_UseX64=n
#AutoIt3Wrapper_Res_Comment=http://www.Phoenix125.com
#AutoIt3Wrapper_Res_Description=Phoenix125PrusaSlic3rColorScript
#AutoIt3Wrapper_Res_Fileversion=v1.0
#AutoIt3Wrapper_Res_ProductName=Phoenix125PrusaSlic3rColorScript
#AutoIt3Wrapper_Res_ProductVersion=v1.0
#AutoIt3Wrapper_Res_CompanyName=http://www.Phoenix125.com
#AutoIt3Wrapper_Res_LegalCopyright=http://www.Phoenix125.com
#AutoIt3Wrapper_Run_AU3Check=n
#AutoIt3Wrapper_AU3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_Run_Au3Stripper=y
#Au3Stripper_Parameters=/mo
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include <File.au3>
#include <Date.au3>
Global $aUtilName = "Phoenix125PrusaSlic3rColorScript"
Global $aLogFile = @ScriptDir & "\" & $aUtilName & "_Log.txt"
_LogWrite('----------========== ' & $aUtilName & ' Started ==========----------')
If $CmdLine[0] = 0 Then
	$tFile = FileOpenDialog($aUtilName, @ScriptDir, "gcode (*.gcode)", 1)
	If @error Then Exit
	If $tFile = "" Then Exit
Else
	$tFile = $CmdLine[1]
EndIf
$tSplash = _Splash("Reading file . . .")
Local $tArray
_FileReadToArray($tFile, $tArray, 0)
ControlSetText($tSplash, "", "Static1", "Backing up file . . .")
Local $tFileBak = StringReplace($tFile, ".gcode", "_bak.gcode")
If @extended = 0 Then $tFileBak = $tFile & ".bak"
FileMove($tFile, $tFileBak)
_LogWrite('Backup created [' & $tFileBak & ']')
ControlSetText($tSplash, "", "Static1", "Processing file . . .")
Local $tCount = 0
Local $tStep
_LogWrite('Processing file [' & $tFile & ']')
For $i = 0 To UBound($tArray) - 1
	$tStep += 1
	If $tStep = 100 Then
		ControlSetText($tSplash, "", "Static1", "Processing file . . ." & @CRLF & @CRLF & "Processing Line " & $i + 1 & " of " & UBound($tArray) & @CRLF & "Number of changes made:" & $tCount)
		$tStep = 0
	EndIf
	If StringLeft($tArray[$i], 1) = "T" Then
		For $t = 0 To 99
			If $tArray[$i] = "T" & $t Then
				$tArray[$i] = "; " & $tArray[$i]
				$tCount += 1
				_LogWrite('Changed line #' & $i & ' to [' & $tArray[$i] & ']')
				ExitLoop
			ElseIf $tArray[$i] = "T" & $t & " ; change extruder" Then
				$tArray[$i] = "; " & $tArray[$i]
				$tCount += 1
				_LogWrite('Changed line #' & $i & ' to [' & $tArray[$i] & ']')
				ExitLoop
			EndIf
		Next
	EndIf
Next
ControlSetText($tSplash, "", "Static1", "Saving file . . .")
_FileWriteFromArray($tFile, $tArray)
ControlSetText($tSplash, "", "Static1", "Processing complete.  Number of changes made:" & $tCount)
_LogWrite("Processing complete.  Number of changes made:" & $tCount)
Sleep(2500)
Func _Splash($tTxt, $tTime = 0, $tWidth = 400, $tHeight = 125)
	Local $tPID = SplashTextOn($aUtilName, $tTxt, $tWidth, $tHeight, -1, -1, $DLG_MOVEABLE, "")
	If $tTime > 0 Then
		Sleep($tTime)
		SplashOff()
	EndIf
	Return $tPID
EndFunc   ;==>_Splash
Func _LogWrite($Msg)
	FileWriteLine($aLogFile, _NowCalc() & " " & $Msg)
EndFunc   ;==>_LogWrite