Attribute VB_Name = "migemo"

Function migemize(query As String)
    Dim commandString As String
    commandString = "cmigemo -d ""C:\Users\bc0074854\Program\dict\migemo-dict"" -w " & query
    migemize = Replace(ExecCommand2(commandString), vbCrLf, "")
End Function

Public Function ExecCommand2(sCommand As String) As String
    ' �萔/�ϐ��錾��
    Const TemporaryFolder = 2
    Dim oShell As Object, fso As Object, fdr As Object, ts As Object
    Dim sFileName As String
  
    ' �I�u�W�F�N�g�ϐ��ɎQ�Ƃ��Z�b�g���܂��B
    Set oShell = CreateObject("WScript.Shell")
    Set fso = CreateObject("Scripting.FileSystemObject")
    Set fdr = fso.GetSpecialFolder(TemporaryFolder)
      
    ' ���_�C���N�g��̃t�@�C�����𐶐����܂��B
    Do: sFileName = fso.BuildPath(fdr.Path, fso.GetTempName)
    Loop While fso.FileExists(sFileName)
  
    ' �R�}���h�����s���܂��B
    oShell.Run "%ComSpec% /c " & sCommand & ">" & sFileName & " 2<&1" _
               , 0, True
  
    ' �߂�l���Z�b�g���܂��B
    If fso.FileExists(sFileName) Then
        Set ts = fso.OpenTextFile(sFileName)
        ExecCommand2 = ts.ReadAll
        ts.Close
        Kill sFileName
    End If
  
    ' �I�u�W�F�N�g�ϐ��̎Q�Ƃ�������܂��B
    Set ts = Nothing: Set fdr = Nothing
    Set fso = Nothing: Set oShell = Nothing
End Function

