Option Explicit
On Error Resume Next

Dim response
response = msgbox("This script will disable your keyboard, log you off the network, then restart your computer." & vbCrLf & vbCrLf & "Do you want to continue?", 1, "2261 Module 2 Break")

If response = vbYes Then
	dim wshshell
	set wshshell = wscript.CreateObject("wscript.shell")
	wshshell.regwrite "HKLM\SYSTEM\CurrentControlSet\Services\Kbdclass\ErrorControl","0", "REG_DWORD"
	wshshell.regwrite "HKLM\SYSTEM\CurrentControlSet\Services\Kbdclass\Start","4", "REG_DWORD"
	wshshell.run "shutdown.exe -r"
End If