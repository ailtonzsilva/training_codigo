'============================================================
'
'Consulte na documenta��o do WMI SDK DOCUMENTATION sobre win32_process
'para ver a listagem das propriedades dos processos
'
'============================================================

set con = getobject("wmimgmts:")
set objmsi = con.get("win32_product")

instalar = objmsi.install("\\bfins23\soft\ppt.msi")