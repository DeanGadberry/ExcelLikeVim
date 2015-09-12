Attribute VB_Name = "vbundle"

'----------------------------- declare variables ----------
Enum Module'{{{
  Standard = 1
  Class = 2
  Forms = 3
  ActiveX = 11
  Document = 100
End Enum'}}}

'----------------------------- main -----------------------
Public Sub read_vimxrc()'{{{
	settingFilePath = Environ("homepath") & "\.vimxrc"

	Open settingFilePath For Input As #1
	Do Until EOF(1)
		Line Input #1, buf
		buf = Replace(buf,vbTab,"") 'tab(�C���f���g)�𖳎�

		If Left(buf,1) = "'" Then
			Goto NextLoop
		End If

		If buf <> "" Then
			instruction = Split(buf, " ")(0)
			argument = Mid(buf, Instr(Instr(buf, " ") + 1, buf, " ") + 1) '2�ڂ̃X�y�[�X�ȍ~���擾
			' Application.Run instruction, argument
			Debug.Print "instruction:" & instruction & vbCrLf & "argument:" & argument
		End If

		NextLoop:
	Loop
	Close #1
End Sub'}}}

'----------------------------- updatemodules --------------
Public Function bundle()
End Function

Public Function UpdateModulesOfBook(Optional bookPath As String = "", Optional isCalledFromThisWorkbookModule = False) '{{{
	Const moduleListFile As String = "libdef.txt" '���C�u�������X�g�̃t�@�C����
	Dim msgError As String: msgError = "Error Message"
	Dim updatedModuleNameList As New Collection

	'Get module list to update from libdef.'{{{
	'Set targetBook, targetBookModuleDirectory, libDefPath 
	Dim targetBook As Workbook
	if bookPath = "" Then
		Set targetBook = ThisWorkbook
		targetBookModuleDirectory = ThisWorkbook.Path
		libDefPath = targetBookModuleDirectory & "\" & moduleListFile
	Else
		Set targetBook = Application.Workbooks(bookPath)
		targetBookModuleDirectory = ThisWorkbook.Path & "\src\forbook\" &targetBook.Name
		libDefPath = targetBookModuleDirectory & "\" & moduleListFile
	End if

	Dim targetModuleList As Variant 'list of module path

	If Not checkExistFile(libDefPath) Then
		Msgbox "Error: ���C�u�������X�g" & libDefPath & "�����݂��܂���B"
		Exit Function
	End If
	targetModuleList = list2array(libDefPath)
	If UBound(targetModuleList) = 0 Then
		Msgbox "Error: ���C�u�������X�g�ɗL���ȃ��W���[���̋L�q�����݂��܂���B"
		Exit Function
	End If'}}}

	'Update modules'{{{
	Set myFSO = CreateObject("Scripting.FileSystemObject")
	For i = 0 To UBound(targetModuleList) - 1
		Dim modulePath As String: modulePath = targetModuleList(i)
		If isCalledFromThisWorkbookModule And myFSO.GetBaseName(absPath(targetModuleList(i))) = "ThisWorkbook" Then
			Debug.Print "Not update ThisWorkbook because it's dangerous updating it when it is called from ThisWorkbook moudule."
		Else
			Call updateSingleModule(targetBook, modulePath, msgError)
		End If
	Next i
	Set myFSO = Nothing '}}}

	If msgError = "Error Message" Then
		Msgbox "All Modules were successfully updated!"
	Else
		Msgbox msgError
	End If
End Function'}}}

Private Function updateSingleModule(targetBook As Workbook, modulePath As String, msgError As String)'{{{
	Set myFSO = CreateObject("Scripting.FileSystemObject")
	On Error GoTo except
		pathModule = absPath(modulePath)
		moduleName = myFSO.GetBaseName(pathModule)
		If Not isMemberOfVBEComponets(targetBook, moduleName) Then '���݂��Ȃ��ꍇ�͐V�K�o�^�
			targetBook.VBProject.VBComponents.Import pathModule
		ElseIf moduleName <> "vbundle" And checkExistFile(pathModule) Then 'CodeManager�̏��������͍s��Ȃ��B
			With targetBook.VBProject.VBComponents(moduleName).CodeModule
				Debug.Print "Started deleting " & moduleName
				'workbook,worksheet���W���[���̏ꍇ http://futurismo.biz/archives/2386
				.DeleteLines StartLine:=1, count:=.CountOfLines
				Debug.Print moduleName & "Deleted " & moduleName
				.AddFromFile pathModule
				Debug.Print moduleName & "�ǂݍ��܂ꂽ"

				Select Case targetBook.VBProject.VBComponents(moduleName).type
					Case Module.Standard 'for .bas
						'�������Ȃ��
					Case Module.Class
						.DeleteLines StartLine:=1, count:=4
					Case Module.Forms
						.DeleteLines StartLine:=1, count:=10
					Case Module.Document
						.DeleteLines StartLine:=1, count:=4
					Case Else
						Debug.Print targetBook.VBProject.VBComponents(moduleName).type
					End Select
			End With
		End If
	except:
		If Err.Description <> "" Then
			msgError = msgError & vbCrLf & Err.Description & ": when updating " & moduleName
		End If
		Set myFSO = Nothing
End Function'}}}

Public Sub UpdateLibList(Optional targetBookModuleDirectory As String = "", Optional registerPattern As String = ".*\.cls$|.*\.bas$|.*\.frm$")'{{{
	'----------------This Function Update Libdef file  inaccordance with current directory structure.-------------------------------
	'TODO �����vba����łȂ��Ƃ�vim��Ŏ��s�������
	If targetBookModuleDirectory = "" Then targetBookModuleDirectory = ThisWorkbook.path & "\src\forbook\" & ActiveWorkbook.Name
	Dim fu As New FileUtil
	Dim file As Variant
	' ���ʊi�[�p�ϐ�
	Dim result As Collection
	' your_path�z����search_pattern�ɍ��v���������擾
	Set result = fu.getFileListRecursive(targetBookModuleDirectory, registerPattern).Files ' ���������ȗ������ꍇ�͑S�擾
	' �t�@�C���ꗗ���t���p�X�ŕ\�������

	Open targetBookModuleDirectory & "\" & "libdef.txt" For output As #1
	Print #1, "' vim: filetype=vb"
	For Each file In result
		'TODO ���΃p�X�֕ϊ�
		Print #1, Replace(file,"\","/")
	Next
	Close #1
End Sub'}}}'}}}
'----------------------------- export modules --------------
Public Sub EM(Optional bookPath As String = "")'{{{
	'''targetbook�̃R�[�h���O���֕ۑ�����B'''

	'targetbook,targetbookdirectory�̐ݒ�
	If bookPath = "vimx" Then
		Set targetBook = ThisWorkbook
		targetBookModuleDirectory = ThisWorkbook.path
	ElseIf bookPath = "" Then
		Set targetBook = ActiveWorkbook
		targetBookModuleDirectory = ThisWorkbook.path & "\src\forbook\" & targetBook.Name
	Else
		Set targetBook = Application.Workbooks(Dir(bookPath))
		targetBookModuleDirectory = ThisWorkbook.path & "\src\forbook\" & targetBook.Name
	End If

	'targetBookModuleDirectory�����݂��Ȃ���΍��
	isNewRegistration = False
	If Dir(targetBookModuleDirectory, vbDirectory) = "" Then
		'�ۑ���f�B���N�g���̍쐬
		MkDir targetBookModuleDirectory
		isNewRegistration = True
	End If

	'module�̃G�N�X�|�[�g
	For Each vb_component In targetBook.VBProject.VBComponents
		pathToExport = "" '������
		If Not vb_component.Name = "CodeManager" Then 'CodeManager�͎��g�Ȃ̂�export���s��Ȃ��import�łȂ���Α��v�H
			'libdef���Q�Ƃ��Ēu���ꏊ��pathToExport�ɐݒ�B
			If isNewRegistration = True Then
				pathToExport = targetBookModuleDirectory & "\" & vb_component.Name & getExtention(vb_component)
			Else
				Open targetBookModuleDirectory & "\" & "libdef.txt" For Input As #1
				Do Until EOF(1)
					Line Input #1, buf
					buf = Replace(buf,vbTab,"") 'tab(�C���f���g)�𖳎�
					If Left(buf, 1) = "'" Then '�R�����g�s�𖳎�
						Exit Do
					End If
					buf = Split(buf, " ")(1)
					If InStr(buf,vb_component.Name) Then 'TODO ���K�\���ɂ���
						pathToExport = buf
						Exit Do
					End If
				Loop
				Close #1
			End If

			If pathToExport <> "" Then
				vb_component.Export pathToExport
			End IF
		End If
	Next

	'libdef�̍X�V
	If isNewRegistration Then
		Call UpdateLibList(targetBookModuleDirectory)
	End If
End Sub'}}}

'----------------------------- common Functions / Subs --------------
Private Function isExcelObject(fileName As String) As Boolean'{{{
	Set RE = CreateObject("VBScript.RegExp")
	RE.IgnoreCase = True
	RE.pattern = ".cls$|.frm|ThisWorkbook|Sheet"
	If RE.test(fileName) Then
		isExcelObject = True
	Else
		isExcelObject = False
	End If
End Function'}}}

	Private Function checkRemainigComponents() As Boolean'{{{
	  '�W�����W���[��/�N���X���W���[���̍��v����0�ł����OK
	  Dim cntBAS As Long
	  cntBAS = countBAS()
	
	  Dim cntClass As Long
	  cntClass = countClasses()
	
	  'CodeManager�݂̂��c���Ă���B
	  If cntBAS <= 1 And cntClass = 0 Then
		  checkRemainigComponents = True
	  Else
		  checkRemainigComponents = False
	  End If
	End Function'}}}

Private Function countBAS() As Long'{{{
  Dim count As Long
  count = countComponents(1) 'Type 1: bas
  countBAS = count
End Function'}}}

Private Function countClasses() As Long'{{{
  Dim count As Long
  count = countComponents(2) 'Type 2: class
  countClasses = count
End Function'}}}

Private Function countComponents(ByVal numType As Integer) As Long'{{{
  '���݂���W�����W���[��/�N���X���W���[���̐��𐔂���
  
  Dim i As Long
  Dim count As Long
  count = 0
  
  With targetBook.VBProject
    For i = 1 To .VBComponents.count
      If .VBComponents(i).Type = numType Then
        count = count + 1
      End If
    Next i
  End With

  countComponents = count
End Function'}}}

Private Function checkExistFile(ByVal pathFile As String) As Boolean'{{{
  On Error GoTo Err_dir
  If Dir(pathFile) = "" Then
    checkExistFile = False
  Else
    checkExistFile = True
  End If

  Exit Function

Err_dir:
  checkExistFile = False
End Function'}}}

Private Function list2array(ByVal pathFile As String) As Variant'{{{
	'���X�g�t�@�C����z��ŕԂ�(�s����'(�R�����g)�̍s & ��s�͖�������)
	Dim nameOS As String
	nameOS = Application.OperatingSystem

	'1. ���X�g�t�@�C���̓ǂݎ��
	Dim fp As Integer
	fp = FreeFile
	Open pathFile For Input As #fp

	'2. ���X�g�̔z��
	Dim arrayOutput() As String
	Dim countLine As Integer
	countLine = 0
	ReDim Preserve arrayOutput(countLine) ' �z��0�ŕԂ��ꍇ�����邽��
	Do Until EOF(fp)
		'���C�u�������X�g��1�s������
		Dim strLine As String
		Line Input #fp, strLine
		isLf = InStr(strLine, vbLf)
		If nameOS Like "Windows *" And Not isLf = 0 Then
			'OS��Windows ���� ���X�g�� LF���܂܂��ꍇ (�t�@�C����UNIX�`��)
			'�t�@�C���S�̂�1�s�Ɍ����Ă��܂��B
			Dim arrayLineLF As Variant
			strLine = Replace(strLine,vbTab,"") 'tab(�C���f���g)�𖳎�
			arrayLineLF = Split(strLine, vbLf)
			For i = 0 To UBound(arrayLineLF) - 1
				'�s���� '(�R�����g) �ł͂Ȃ� & ��s�ł͂Ȃ��ꍇ
				' If Not left(arrayLineLF(i), 1) = "'" And Len(arrayLineLF(i)) > 0 Then
				If arrayLineLF(i) <> "" Then
					arrayLineLFS = Split(arrayLineLF(i), " ")
					If arrayLineLFS(0) = "bundle" Then
						'�z��ւ̒ǉ�
						countLine = countLine + 1
						ReDim Preserve arrayOutput(countLine)
						arrayOutput(countLine - 1) = arrayLineLFS(1)
					End If
				End If
			Next i
		Else
			'OS��Windows and �t�@�C����Windows�`�� (�ϊ��s�v)
			'OS��MacOS X and �t�@�C����UNIX�`�� (�ϊ��s�v)
			'OS��MacOS X and �t�@�C����Windows�`��
			strLine = Replace(strLine, vbCr, "") ' vbCr�����W���[���t�@�C�����𔭌��ł��Ȃ��Ȃ�B
			arraystrLine = Split(strLine, " ")
			'�s���� '(�R�����g) �ł͂Ȃ� & ��s�ł͂Ȃ��ꍇ
			If Not Left(strLine, 1) = "'" And Len(strLine) > 0 Then
				If arraystrLine(0) = "bundle" Then
					'�z��ւ̒ǉ�
					countLine = countLine + 1
					ReDim Preserve arrayOutput(countLine)
					arrayOutput(countLine - 1) = arraystrLine(1)
				End If
			End If
		End If
	Loop

	'3. ���X�g�t�@�C�������
	Close #fp
	'4. �߂�l��z��ŕԂ�
	list2array = arrayOutput
End Function'}}}

Private Function getExtention(myComponent) As String'{{{
	Dim extention As String
	Select Case myComponent.Type
		Case Module.Standard
			extention = ".bas"
		Case Module.Class
			extention = ".cls"
		Case Module.Forms
			extention = ".frm"
		Case Module.ActiveX
			extention = ".cls"
		Case Module.Document
			extention = ".cls"
	End Select

	getExtention = extention
End Function'}}}

Public Function absPath(ByVal pathFile As String) As String'{{{
	'------------ �t�@�C���p�X���΃p�X�ɕϊ� -----------------------
	'�ȗ�����(. .. ~)�̓W�J
	Select Case left(pathFile, 1)
	Case ".": 'Case1. . �Ŏn�܂�ꍇ(���Ύw��)
		Select Case left(pathFile, 2) ' Case1-1. ���Ύw�� "../" �Ή�
		Case "..":
			absPath = ThisWorkbook.Path & Application.PathSeparator & pathFile
			Exit Function
		Case Else: ' Case1-2. ���Ύw�� "./" �Ή�
			absPath = ThisWorkbook.Path & Mid(pathFile, 2, Len(pathFile) - 1)
			Exit Function
		End Select
	Case Application.PathSeparator: 'Case2. ��؂蕶���Ŏn�܂�ꍇ (��Ύw��)
		If left(pathFile, 2) = Chr(92) & Chr(92) Then ' Case2-1. Windows Network Drive ( chr(92) & chr(92) & "hoge")
			absPath = pathFile
			Exit Function
		Else ' Case2-2. Mac/UNIX Absolute path (/hoge)
			absPath = pathFile
			Exit Function
		End If
	Case "~"
		pathfile = Replace(pathfile, "~", Environ("homepath"))
	End Select

	'��؂蕶����OS�ɍ��킹�ĕϊ�
	nameOS = Application.OperatingSystem
	pathFile = Replace(pathFile, Chr(92), Application.PathSeparator) 'replace Win backslash(Chr(92))
	pathFile = Replace(pathFile, ":", Application.PathSeparator) 'replace Mac ":"Chr(58)
	pathFile = Replace(pathFile, "/", Application.PathSeparator) 'replace Unix "/"Chr(47)

	' 'Case3. [A-z][0-9]�Ŏn�܂�ꍇ (Mac��Office�Ő��K�\�����g����� select���ɓ����ׂ�...)
	' ' Case3-1.�h���C�u���^�[�Ή�("c:" & chr(92) �� "c" & chr(92) & chr(92)�ɂȂ��Ă��܂��̂ŏ����߂�)
	If nameOS Like "Windows *" And left(pathFile, 2) Like "[A-z]" & Application.PathSeparator Then
		'MsgBox "Case3-1" & pathFile
		absPath = Replace(pathFile, Application.PathSeparator, ":", 1, 1)
		Exit Function
	End If
	' Case3-2. ���w�� "filename"�Ή�
	If left(pathFile, 1) Like "[0-9]" Or left(pathFile, 1) Like "[A-z]" Then
		absPath = ThisWorkbook.Path & Application.PathSeparator & pathFile
		Exit Function
	Else
		MsgBox "Error[AbsPath]: fail to get absolute path."
	End If
End Function'}}}

Private Function isMemberOfCollection(col As Collection, query) As Boolean'{{{
	For Each item In col
		If item = query Then
			isMemberOfCollection = True
			Exit Function
		End If
	Next
	isMemberOfCollection = False
End Function'}}}

Private Function isMemberOfVBEComponets(book As Workbook, query) As Boolean'{{{
	For Each item In book.VBProject.VBComponents
		If item.Name = query Then
			isMemberOfVBEComponets = True
			Exit Function
		End If
	Next
	isMemberOfVBEComponets = False
End Function'}}}
