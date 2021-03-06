' GLANIC2.VBS
'
' Configures the second network adapter for Glasgow

set wshshell = wscript.CreateObject("wscript.shell")

LACName = "Partner Network Connection"	'name of the Local Area Connection to modify
classroom = getclsrm


'set Ip Address and Subnet Mask
wshshell.Run "netsh interface ip set address name=" & chr(34) & LACName & chr(34) & " source=static addr=192.168.100.2 mask=255.255.255.0", 0, true

'set Preferred DNS Server
wshshell.Run "netsh interface ip set dns name=" & chr(34) & LACName & chr(34) & " source=static addr=192.168." & classroom & ".200 register=PRIMARY", 0, true



private function getclsrm
	set fso = createobject("scripting.filesystemobject")
	set fl = fso.OpenTextFile ("c:\moc\setup\mocset\mocset2.cmd")
	while left (x,13) <> "set classroom"
		x = fl.readline
	wend
	fl.close
	rtrim x
	lgn = len(x)
	getclsrm = left(right(x,lgn-14),1)
end function