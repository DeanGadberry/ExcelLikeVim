Attribute VB_Name = "initApp"
'-----------------------------------------
Public myobject As New ApplicationEvent

'-------main----------
Public Sub InitializeApplication()'{{{
	Debug.Print "InitializeApplication"
	Call SetReference
	Call AllKeyToAssesKeyFunc
	Call SpecialMapping
	Call SetAppEvent
	' IsExistPython = True �Ӗ��Ȃ���O���[�o���ϐ��͏�����
	'Call read_setting(~/.vimxrc)
	If visualmodefeature Then
		Call OpenRegisterBook()
		If Workbooks.Count = 1 Then
			Workbooks.Add
		End If
	End If
	Application.Cursor = xlNorthwestArrow
End Sub'}}}

Public Sub read_setting(filePath As String)'{{{
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
