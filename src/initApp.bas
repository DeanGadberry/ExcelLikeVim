Attribute VB_Name = "initApp"
'-----------------------------------------
Public myobject As New ApplicationEvent

'-------main----------
Public Sub InitializeApplication()'{{{
' On Error Goto MyError
On Error Resume Next
	Call AllKeyToAssesKeyFunc
	Call SpecialMapping
	Application.Cursor = xlNorthwestArrow
	' IsExistPython = True �Ӗ��Ȃ���O���[�o���ϐ��͏�����
	Call read_setting(Environ("homepath") & "/.vimxrc")
	' If visualmodefeature Then
	If True Then
		Call OpenRegisterBook()
		If Workbooks.Count = 1 Then
			Workbooks.Add
		End If
	End If
On Error Goto 0
MyError:
If Err.Description <> "" Then
	MsgBox "koji" & Err.Description
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
				Dim argument As String:argument = Mid(buf, Instr(buf, " ") + 1) '1�ڂ̃X�y�[�X�ȍ~���擾
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
	Set myobject.appEvent = Application
	Set myobject.pptEvent = New PowerPoint.Application
	Set myobject.wrdEvent = New Word.Application
	MsgBox "setiing AppEvent is done"
	' Debug.Print "setiing AppEvent is done"
End Sub'}}}

Sub wrap(arg As String)'{{{
	buf = Split(arg, ",")
	a = buf(0):b = buf(1)
	With ThisWorkbook.VBProject.VBComponents("wrapper").CodeModule
		.InsertLines 1, "Sub " & a & "()"
		.InsertLines 2, "End Sub"
		.InsertLines 2, "ExeStringPro(""" & b & """)"
	End With
End Sub'}}}

Sub clearWrapper(a As String, b As String)'{{{
	With ThisWorkbook.VBProject.VBComponents("wrapper").CodeModule
		.DeleteLines StartLine:=1, count:=.CountOfLines
	End With
End Sub'}}}
