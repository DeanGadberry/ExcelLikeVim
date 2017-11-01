Attribute VB_Name = "ExecuteProcedure"

Function ExeStringPro(commandString As String, Optional bookName As String = "") '{{{
  'bookName��module��D��ŒT���Ď��s�B������Ȃ���΂��̃u�b�N�̃R�}���h��T���Ď��s�B

  'Debug.Print "Start ExeStringPro"
  Dim commandArray() As String
  Dim AWBcommandArray() As String
  commandArray = Split(commandString, " ")

  If commandArray(0) = "-a" Then
    commandString = Mid(commandString, Instr(commandString, " ") + 1) '2�ڂ̃X�y�[�X�ȍ~���擾
    ExecuteAsIs commandString
    Exit Function
  End If

  If bookName = "" Then
    On Error Resume Next 'for when there is no book 
    bookName = ActiveWorkbook.Name
    On Error Goto 0
  End If
  AWBcommandArray = commandArray
  AWBcommandArray(0) = bookName & "!" & commandArray(0)

  Set buf = ExeStringPro_core(AWBcommandArray)
  If buf(1) = 0 Then 'Search command within ActiveWorkbook code
    Call SetVariant(ExeStringPro, buf(2))
  Else
    Set buf = ExeStringPro_core(commandArray)
    If buf(1) = 0 Then
      Call SetVariant(ExeStringPro, buf(2))
    Else
      MsgBox "�w�肳�ꂽ�֐�" & commandString & "�̎��s�Ɏ��s���܂���� �֐������݂��Ă��邩��������s���łȂ����m�F���ĉ������"
    End If
  End If
End Function '}}}

Function ExeStringPro_core(commandArray) As Variant '{{{
  'return (Err.Number, result)
  Dim buf As New Collection

  'Debug.Print "Start ExeStringPro_core"
  'TODO:������3�ȏ゠��֐��̏ꍇ�̏���
  On Error GoTo MyError
  If UBound(commandArray) = 0 Then
    Call SetVariant(result, Application.run(commandArray(0)))
  ElseIf UBound(commandArray) = 1 Then
    Call SetVariant(result, Application.run(commandArray(0), commandArray(1)))
  ElseIf UBound(commandArray) = 2 Then
    Call SetVariant(result, Application.run(commandArray(0), commandArray(1), commandArray(2)))
  End If

MyError:
  buf.Add Err.Number 'error���Ȃ����0���Ԃ�B
  buf.Add result
  Set ExeStringPro_core = buf
  Set buf = Nothing
End Function '}}}

Sub SetVariant(a As Variant, b As Variant)'{{{
  If IsObject(b) Then
    Set a = b
  Else
    Let a = b
  End If
End Sub'}}}

Function ExecuteAsIs(code As String)'{{{
  'Todo return value but that seems to be a little bit dangerous

  With ThisWorkbook.VBProject.VBComponents("oneliner").CodeModule
    .DeleteLines StartLine:=1, count:=.CountOfLines
    .InsertLines 1, "Sub temp_for_ExecuteAsIs()"
    .InsertLines 2, "End Sub"
    .InsertLines 2, code
  End With
  DoEvents
  Application.Run("temp_for_ExecuteAsIs")
End Function'}}}

Public Function ExecCommand(sCommand As String, sResult As String) As Boolean  '{{{
  ' �ځ@�I�FDOS �R�}���h�̎��s���ʂ��擾���܂��B  
  ' �߂�l�F�G���[�̗L���� Boolean �^�ŕԂ��܂��B  
  ' �@�@�@�@�G���[�������� True�A����I������ False �ł��B  
  ' ���@���FsCommand-> �K�{/���͗p�ł��B���s�R�}���h�𕶎���^�œn���܂��B  
  ' �@�@�@�@sResult -> �K�{/�o�͗p�ł��B���s���ʂ𕶎���^�Ŏ󂯎��܂��B  
  '�@�@�@�@�@�@�@�@�@�@���s�����ꍇ�̓G���[���e�������܂��B  
  ' ���@�ӁF���s���̓R�}���h�v�����v�g �E�B���h�E���J���܂��B�܂����s��͎����I�ɃE�B���h�E�����܂��B  
  'http://www.f3.dion.ne.jp/~element/msaccess/AcTipsGetDosResult.html

  Dim oShell As Object, oExec As Object  
  Set oShell = CreateObject("WScript.Shell")  
  Set oExec = oShell.Exec("%ComSpec% /c " & sCommand)  

  ' ����������ҋ@���܂��B  
  Do Until oExec.status: DoEvents: Loop  

    ' �߂�l���Z�b�g���܂��B  
    If Not oExec.StdErr.AtEndOfStream Then  
      ExecCommand = True  
      sResult = oExec.StdErr.ReadAll  
    ElseIf Not oExec.StdOut.AtEndOfStream Then  
      sResult = oExec.StdOut.ReadAll  
    End If  

    ' �I�u�W�F�N�g�ϐ��̎Q�Ƃ�������܂��B  
    Set oExec = Nothing: Set oShell = Nothing  
  End Function  '}}}

