Attribute VB_Name = "pluskun"

' Dim fu As New FileUtil
' fu.getFileListRecursive(path)

Sub aaa() '{{{

End Sub'}}}

Sub eee() '{{{
	' If fullpath <> "" Then
	' 	SmartOpenBook(fullpath)
	' End If
	' 'Header�̏C��

	'�{�̕����̏C��
	For Each partName in GetAllParts()
		InitializePart(partName)
		ModifyPart(partName)
		ModifyFileName(partName)
	Next partName

End Sub'}}}

'---------------------------------------------------------------
Sub InitializePart(partName As String)'{{{
	'�ǂ̕��i�ɂ����ʂ��������������
	Dim contents As Range: Set contents = GetContentsOfPart(partName)
	' contents.Offset(0,1).ClearContents '���l1
	contents.Offset(0,2).ClearContents '���l2

	'�ҏW�`��
	contents.Offset(0,4).Value = "���S���p" '��U�S�Ċ��S���p��
	On Error Resume Next
	contents.Offset(0,4).FormatConditions.Add(xlCellValue, xlEqual, "���S���p").Interior.ColorIndex = 16 '���S���p�Ȃ�Ԋ|�� M10�̓G���[
	On Error GoTo 0

	contents.Offset(0,5).ClearContents '���p��

	contents.Offset(0,7).NumberFormatLocal = "G/�W��"
	contents.Offset(0,7).Value = "=LOOKUP(L" & contents(0).row + 1 &",{""���S���p"",""�V�K"",""���p����"";""���p�w��"",""�l�C�e�B�u�{�Ԏ�����"",""PDF/X1-a""})" '���e�`��

	contents.Offset(0,8).NumberFormatLocal = "G/�W��"
	contents.Offset(0,8).Value = "=LOOKUP(O" & contents(0).row + 1 &",{""PDF/X1-a"",""�l�C�e�B�u+�Ԏ�����"",""���p�w��"";""WF1"",""WF2"",""WF1""})" '���e�`��
End Sub'}}}

Sub ModifyPart(partName As String)'{{{
	'�ǂ̕��i�ɂ����ʂ��������������
	If partName Like "*�Y��*" Then
		Set contents = GetContentsOfPart(partName)
		For Each c in contents.Offset(0,1)
			If c.Value like "�E��" Then
				c.Offset(0,3).Value = "���p����"
			Else
				c.Offset(0,3).Value = "�V�K"
			End If
		Next c

	ElseIf partName = "�{��" Then
		Set contents = GetContentsOfPart(partName)
		For Each c in contents
			Select Case c
				Case "�\�T","�\�W" '�V�K�ɕύX����s
					c.Offset(0,4).Value = "�V�K"
				Case "�\�U","�\�V","�ڎ�","���m","�Y��ۑ�g�r��","�Y��ۑ芈�p�@","�����̃q���g" '���p�����ɕύX����s
					c.Offset(0,4).Value = "���p����"
			End Select
		Next c

	ElseIf partName = "���Ԃ�" Then
		Set contents = GetContentsOfPart(partName)
		' contents(2).Offset(0, 5) = "�O�N�x����F�J�G"
		' contents(3).Offset(0, 5) = "�O�N�x����F�J�G"
		' contents(4).Offset(0, 4) = "���p����"
	End If

End Sub'}}}

Sub ModifyFileName(partName As String)'{{{
	Dim contents As Range: Set contents = GetContentsOfPart(partName)
	'�V�K����p�Ȃ�t�@�C������14��15�ɂ���
	For Each c in contents.Offset(0, 6)
		If c.Offset(0, -2).Value <> "���S���p" Then
			If Left(c.Value, 3) = "011" Then
				c.Value =  Left(c.Value, 3) & "15" & Mid(c.Value, 6)
			End If
		Else
			'TODO �O�N�x�̃f�[�^���玝���Ă���
		End If
	Next c
End Sub'}}}

'---------------------------------------------------------------
Function GetContentsOfPart(partName As String) As Range'{{{
'�����F���i��
'�Ԃ�l�F���e��ꗗ
On Error GoTo ErrorHandling
	Set searchRange = Range(Cells(12, 3), Cells(ActiveSheet.UsedRange.Rows.Count, 3))
	For Each c in searchRange
		If c.Value = partName Then
			Set partNameCell = c
			Exit For
		End If
	Next c

	Do Until i > 100
		Set startCell = partNameCell.Offset(i, 0)
		If startCell.Value = "��" Then
			Set startCell = startCell.Offset(1, 5) 'Offset�̏ꍇ�͌����Z�����͑����Ȃ�
			Exit Do
		End If
		i = i + 1
	Loop

	Set GetContentsOfPart = Range(startCell, startCell.End(xlDown))
	Exit Function
ErrorHandling:
	Set GetContentsOfPart = Nothing
End Function'}}}

Function GetColumnOfProperty(propertyName As String) As Long'{{{
'�����F������
'�Ԃ�l�F
On Error GoTo ErrorHandling
	Set searchRange = Range(Cells(12, 3), Cells(ActiveSheet.UsedRange.Rows.Count, 3))
	For Each c in searchRange
		If c.Value = "��" Then
			FieldRowNo = c.Row + 2
			Exit For
		End If
	Next c

	Set searchRange = Cells(FieldRowNo, 3).Resize(1, 23)
	For Each c in searchRange
		If c.MergeArea(1, 1).Value = propertyName Then
			GetColumnOfProperty = c.Column
			Exit Function
		End If
	Next c
	GetColumnOfProperty = 0 '������Ȃ��ꍇ
ErrorHandling:
	GetColumnOfProperty = 0 '�G���[�̏ꍇ
End Function'}}}

Function GetAllParts() As Collection 'parts�ꗗ�̎擾'{{{
'�����F
'�Ԃ�l�F���i����collecton
On Error GoTo ErrorHandling
	Dim result As New Collection
	Set searchRange = Range(Cells(12, 3), Cells(ActiveSheet.UsedRange.Rows.Count, 3))
	
	For Each c in searchRange
		If c.Value = "���{" Then
			result.Add c.Offset(-1, 0).Value
		End If
	Next c

	Set GetAllParts = result
	For Each a in result
		Debug.Print a
	Next a
ErrorHandling:

End Function'}}}

Function LastyearData() ''{{{

End Function'}}}

Function LastmonthData() ''{{{

End Function'}}}
