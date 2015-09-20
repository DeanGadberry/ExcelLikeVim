Attribute VB_Name = "initApp"
'-----------------------------------------
Public myobject As New ApplicationEvent

'-------main----------
Public Sub InitializeApplication()'{{{
' On Error Goto MyError
On Error Resume Next
	Call SetReference
	Call AllKeyToAssesKeyFunc
	Call SpecialMapping
	Call SetAppEvent
	' IsExistPython = True �Ӗ��Ȃ���O���[�o���ϐ��͏�����
	Call read_setting(Environ("homepath") & "/.vimxrc")
	' If visualmodefeature Then
	If True Then
		Call OpenRegisterBook()
		If Workbooks.Count = 1 Then
			Workbooks.Add
		End If
	End If
	Application.Cursor = xlNorthwestArrow
On Error Goto 0
MyError:
If Err.Description <> "" Then
	MsgBox Err.Description
End If

End Sub'}}}

Public Sub read_setting(filePath As String)'{{{
	filePath = absPath(filePath) 
	Open FilePath For Input As #1
	Do Until EOF(1)
		Line Input #1, buf
		buf = Replace(buf,vbTab,"") 'ignore indent

		If Left(buf,1) = "'" Then 'ignore comment
			Goto NextLoop
		End If

		If buf <> "" Then
			instruction = Split(buf, " ")(0)
			' argument = Mid(buf, Instr(Instr(buf, " ") + 1, buf, " ") + 1) '2�ڂ̃X�y�[�X�ȍ~���擾
			argument_start = Instr(buf, " ")
			If argument_start <> 0 Then
				argument = Mid(buf, Instr(buf, " ") + 1) '1�ڂ̃X�y�[�X�ȍ~���擾
			End If
			If Instr(instruction, "map") = 0 And Instr(instruction, "for") = 0 Then 'map�n����Ȃ���΂��̂܂܎��s TODO map�n�����̂���
				Debug.Print "instruction:" & instruction & vbCrLf & "argument:" & argument
				If argument_start = 0 Then
					Application.Run instruction
				Else
					Application.Run instruction, argument
				End If
			End If
		End If

		NextLoop:
	Loop
	Close #1
End Sub'}}}

'------supplimental functions-------------
Public Sub SpecialMapping()'{{{
	'�����Ŏw�肵���֐���keystroke.bas���s��ł������mapping.txt���㏑��
	' Application.OnKey "{f11}", "'updateModules ""VimX"", 0'"
	Application.OnKey "{f11}", "'updateModulesOfBook """", False'"
End Sub'}}}

Private Sub OpenRegisterBook()'{{{
	Application.ScreenUpdating = False
	Workbooks.Open FileName:=ThisWorkbook.Path & "\data\register.xlsx", ReadOnly:=True
	Windows("register.xlsx").Visible = False
End Sub'}}}

Public Sub SetAppEvent()'{{{
	Debug.Print "Called SetAppEvent"
	Set myobject.appevent = Application
End Sub'}}}

Public Sub SetReference()'{{{
	'unite_command �p �{���̓v���O�C��������̌Ăяo�����o����悤�ɂ������
	Debug.Print AddToReference("C:\Program Files\Common Files\Microsoft Shared\VBA\VBA6\VBE6EXT.OLB")
End Sub'}}}

Function AddToReference(strFileName As String) As Boolean'{{{
	'�w�肳�ꂽ�^�C�v���C�u�����ւ̎Q�Ƃ��쐬���܂��
	On Error GoTo MyError
		Dim ref As Reference
		Set ref = ThisWorkbook.VBProject.References.AddFromFile(strFileName)
		AddToReference = True
		Set ref = Nothing
		Exit Function
	MyError:
		Select Case Err.Number
			Case 32813
				Debug.Print strFileName & "�͊��ɎQ�Ɛݒ肳��Ă��܂��B", , "�^�C�v���C�u�����ւ̎Q��"
			Case 29060
				MsgBox "�ݒ�t�@�C�����C���X�g�[������Ă��Ȃ����A" & vbNewLine & _
					"����̃t�H���_�[�ɑ��݂��Ȃ��ꍇ���l�����܂��B" & vbNewLine & _
					"����āA�Q�Ɛݒ肪�ł��܂���B", , "�^�C�v���C�u�����ւ̎Q��"
			Case Else
				MsgBox "�\�����ʃG���[���������܂����B" & vbNewLine & _
					Err.Number & vbNewLine & _
					Err.Description, 16, "�^�C�v���C�u�����ւ̎Q��"
		End Select
End Function'}}}
