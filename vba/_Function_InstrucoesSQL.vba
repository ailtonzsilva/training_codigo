Public Function InstrucoesSQL(strAquivo As String)
Dim strSQL As String

strSQL = Application.CurrentProject.Path & "\" & strAquivo

If Len(Dir(strSQL)) > 0 Then
    
    'Alterar a base de dados atravez de um script
    Application.Screen.MousePointer = 11
    ScriptManutencao strSQL
    Application.Screen.MousePointer = 0
    MsgBox "Instru��es SQL realizada(s) com sucesso!", vbInformation, "Instru��es SQL"
    
End If

End Function