' conf.vbs
'
' Verifica o nome da Maquina

set wshshell = wscript.CreateObject("wscript.shell")


set onet   = CreateObject("wscript.network")
cname      = ucase(onet.ComputerName)

' now make it lowercase
lcname  = LCase(cname)

'set Ip Address and Subnet Mask
Select  Case lcname
	Case "alan"
		wscript.Echo "Bem Vindo!!!"
	Case "london"
		WshShell.Run "%systemdrive%\cursos\moc\default.bat"
	Case "vancouver"
		WshShell.Run "%systemdrive%\cursos\moc\default.bat"
	Case "denver"
		WshShell.Run "%systemdrive%\cursos\moc\default.bat"
	Case "perth"
		WshShell.Run "%systemdrive%\cursos\moc\default.bat"
	Case "brisbane"
		WshShell.Run "%systemdrive%\cursos\moc\default.bat"
	Case "lisbon"
		WshShell.Run "%systemdrive%\cursos\moc\default.bat"
	Case "bonn"
		WshShell.Run "%systemdrive%\cursos\moc\default.bat"
	Case "lima"
		WshShell.Run "%systemdrive%\cursos\moc\default.bat"
	Case "santiago"
		WshShell.Run "%systemdrive%\cursos\moc\default.bat"
	Case "bangalore"
		WshShell.Run "%systemdrive%\cursos\moc\default.bat"
	Case "singapore"
		WshShell.Run "%systemdrive%\cursos\moc\default.bat"
	Case "casablanca"
		WshShell.Run "%systemdrive%\cursos\moc\default.bat"
	Case "tunis"
		WshShell.Run "%systemdrive%\cursos\moc\default.bat"
	Case "acapulco"
		WshShell.Run "%systemdrive%\cursos\moc\default.bat"
	Case "miami"
		WshShell.Run "%systemdrive%\cursos\moc\default.bat"
	Case "auckland"
		WshShell.Run "%systemdrive%\cursos\moc\default.bat"
	Case "suva"
		WshShell.Run "%systemdrive%\cursos\moc\default.bat"
	Case "stockholm"
		WshShell.Run "%systemdrive%\cursos\moc\default.bat"
	Case "moscow"
		WshShell.Run "%systemdrive%\cursos\moc\default.bat"
	Case "caracas"
		WshShell.Run "%systemdrive%\cursos\moc\default.bat"
	Case "montevideo"
		WshShell.Run "%systemdrive%\cursos\moc\default.bat"
	Case "manila"
		WshShell.Run "%systemdrive%\cursos\moc\default.bat"
	Case "tokyo"
		WshShell.Run "%systemdrive%\cursos\moc\default.bat"
	Case "khartoum"
		WshShell.Run "%systemdrive%\cursos\moc\default.bat"
	Case "nairobi"
		WshShell.Run "%systemdrive%\cursos\moc\default.bat"
	Case Else
		wscript.Echo "ERRO!!! no conf.vbs...; O nome da Maquina nao consta na rela��o de nomes de sala de Aula, o vbs n�o ira prosseguir, altere o nome e reinicie a Maquina."
end select

