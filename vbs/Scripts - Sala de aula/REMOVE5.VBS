wscript.echo "This script DELETES the OUs and Users for the labs in this module.", Chr(10), "Please wait until the script has finished executing.", Chr(10), "Please click OK to continue."
'**************************************************
'Script to create users in the Active Directory
'**************************************************


'**************************************************
' Determine the LDAP path for your domain
'**************************************************
Set jRoot = GetObject("LDAP://RootDSE")
DomainPath = jRoot.Get("DefaultNamingContext")
Set Domain = GetObject("LDAP://" & DomainPath)

Set WshShell = Wscript.CreateObject("Wscript.Shell")
Set WshSysEnv = WshShell.Environment("Process")
upnDomain = WshSysEnv("USERDOMAIN")

Set jac = Domain.GetObject("organizationalUnit", "OU=HR")
jac.DeleteObject(0)

Set jac = Domain.GetObject("organizationalUnit", "OU=Accounting")
jac.DeleteObject(0)

Set jac = GetObject("LDAP://CN=USERS, " & DomainPath)
Set usr = jac.GetObject("user","CN=AccountingAdminUser")
usr.DeleteObject(0)

Set usr = jac.GetObject("user","CN=HelpDeskUser")
usr.DeleteObject(0)

Set usr = jac.GetObject("user","CN=HRAdminUser")
usr.DeleteObject(0)

'Get handle to the Users Object
Set jac = GetObject("LDAP://CN=USERS, " & DomainPath)

'Delete groups
Set Grp = jac.GetObject("group","CN=Accounting Admins")
grp.DeleteObject(0)

Set Grp = jac.GetObject("group","CN=Help Desk")
grp.DeleteObject(0)

Set Grp = jac.GetObject("group","CN=HR Admins")
grp.DeleteObject(0)





wscript.echo "The Active Directory Structure has been deleted.", Chr(10), "Please click OK to finish.", Chr(10), ""
