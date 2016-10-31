Attribute VB_Name = "AdobeRead"
'---------------------------------------------------------------------------------------
' Module    : AdobeReader
' Created   : 2010/02/06 21:14
' Updated   : 2010/09/17 0:23
' Version   : 1.1.0
' Author    : YU-TANG
' Purpose   : Adobe Reader �ɂ�镶���̕\���ƈ��
' Reference : http://www.f3.dion.ne.jp/~element/msaccess/AcTipsAdobeReader.html
' History   : 2010/02/09 1.0.0 Initioal Release
'             2010/09/17 1.1.0 Ver.9 �Ή�(Search �� View �I�v�V����)
'---------------------------------------------------------------------------------------
Option Compare Binary
'Option Explicit

' ************ PDF �\���p ************
' �y�[�W���[�h�񋓒萔
Public Enum OpenPdfPageMode
    oppmNone                ' �w��Ȃ�
    oppmBookmarks           ' ������
    oppmThumbs              ' �T���l�[��
End Enum

' �\�� �񋓒萔
Public Enum OpenPdfView
    opvNone                 ' �w��Ȃ�
    opvFitPage              ' �S�̕\��
    opvFitWidth             ' ���ɍ��킹��
    opvFitHeight            ' �����ɍ��킹��
    opvFitVisible           ' �`��̈�̕��ɍ��킹��
    opvRotateRight = &H10   ' �E90����]
    opvRotateLeft = &H20    ' ��90����]
End Enum

' ************ ���W�X�g���֘A ************
' ���ɂ���Ă� WScript.Shell �I�u�W�F�N�g�̐������֎~����Ă���
' �ꍇ������悤�Ȃ̂ŁAAPI �Ń��W�X�g���փA�N�Z�X���܂��B

'�Q��
'Shell Lightweight Utility APIs - HEROPA's HomePage
'http://www31.ocn.ne.jp/~heropa/vb123.htm#SHGetValue
Private Enum hKeyConstants
    HKEY_CLASSES_ROOT = &H80000000
    HKEY_CURRENT_USER = &H80000001
    HKEY_LOCAL_MACHINE = &H80000002
    HKEY_USERS = &H80000003
    HKEY_PERFORMANCE_DATA = &H80000004
    HKEY_CURRENT_CONFIG = &H80000005
    HKEY_DYN_DATA = &H80000006
End Enum

' DWORD�^�̃^�C�v
Private Enum RegTypeConstants
'    REG_NONE = (0)                         ' ��`����Ă��Ȃ����
    REG_SZ = (1)                           ' NULL �ŏI��镶����
'    REG_EXPAND_SZ = (2)                    ' �W�J�O�̊��ϐ��ւ̎Q�� �������� NULL �ŏI��镶����
'    REG_BINARY = (3)                       ' �C�ӂ̌`���̃o�C�i���f�[�^
    REG_DWORD = (4)                        ' 32 �r�b�g�l
    REG_DWORD_LITTLE_ENDIAN = (4)          ' ���g���G���f�B�A���`���� 32 �r�b�g�l
'    REG_DWORD_BIG_ENDIAN = (5)             ' �r�b�O�G���f�B�A���`���� 32 �r�b�g�l
'    REG_LINK = (6)                         ' Unicode �̃V���{���b�N�����N
'    REG_MULTI_SZ = (7)                     ' NULL �ŏI��镶����̔z��
'    REG_RESOURCE_LIST = (8)                ' �f�o�C�X�h���C�o�̃��\�[�X���X�g
End Enum


Private Const ERROR_SUCCESS     As Long = 0

Private Declare Function SHGetValue Lib "SHLWAPI.DLL" Alias "SHGetValueA" _
                                (ByVal hKey As Long, _
                                 ByVal pszSubKey As String, _
                                 ByVal pszValue As String, _
                                 pdwType As Long, _
                                 pvData As Any, _
                                 pcbData As Long) As Long

' ************ �E�B���h�E�擾�֘A ************
'�Q��
'�C���X�^���X �n���h������E�B���h�E�̃n���h��������������@
'http://support.microsoft.com/kb/242308/ja
Private Const GW_HWNDNEXT = 2

Private Declare Function GetParent Lib "User32" (ByVal hWnd As Long) As Long
Private Declare Function GetWindow Lib "User32" (ByVal hWnd As Long, ByVal wCmd As Long) As Long
Private Declare Function FindWindow Lib "User32" Alias "FindWindowA" (ByVal lpClassName As String, ByVal lpWindowName As String) As Long
Private Declare Function IsWindow Lib "User32" (ByVal hWnd As Long) As Long
Private Declare Function GetWindowThreadProcessId Lib "User32" (ByVal hWnd As Long, lpdwprocessid As Long) As Long
Private Declare Function GetClassName Lib "User32" Alias "GetClassNameA" (ByVal hWnd As Long, ByVal lpClassName As String, ByVal nMaxCount As Long) As Long
Private Declare Sub Sleep Lib "kernel32.dll" (ByVal dwMillsecounds As Long)
Private Declare Function PostMessage Lib "User32" Alias "PostMessageA" (ByVal hWnd As Long, ByVal wMsg As Long, ByVal wParam As Long, ByVal lParam As Long) As Long

Private Const WM_COMMAND                As Long = &H111&
Private Const WM_CLOSE                  As Long = &H10&     '�I�����b�Z�[�W

Private Const MENU_ID_ZOOM_FIT_PAGE     As Long = 6074&     ' [�\��]-[�Y�[��]-[�S�̕\��]
Private Const MENU_ID_ZOOM_FIT_WIDTH    As Long = 6075&     ' [�\��]-[�Y�[��]-[���ɍ��킹��]
Private Const MENU_ID_ZOOM_FIT_HEIGHT   As Long = 6076&     ' [�\��]-[�Y�[��]-[�����ɍ��킹��]
Private Const MENU_ID_ZOOM_FIT_VISIBLE  As Long = 6077&     ' [�\��]-[�Y�[��]-[�`��̈�̕��ɍ��킹��]
Private Const MENU_ID_VIEW_ROTATE_RIGHT As Long = 6090&     ' [�\��]-[�\������]]-[�E90����]]
Private Const MENU_ID_VIEW_ROTATE_LEFT  As Long = 6091&     ' [�\��]-[�\������]]-[��90����]]
Private Const MENU_ID_EDIT_SEARCH       As Long = 6042&     ' [�ҏW]-[�ȈՌ���]

' ************ UTF-8 �ϊ��֘A ************
'based on:
'�ۑ��`����UTF-8�ɂ�����
'http://rararahp.cool.ne.jp/cgi-bin/lng/vb/vblng.cgi?print+200508/05080003.txt
Private Declare Function WideCharToMultiByte Lib "kernel32" _
        (ByVal CodePage As Long, ByVal dwFlags As Long, ByVal lpWideCharStr As Long, ByVal cchWideChar As Long, _
         lpMultiByteStr As Byte, ByVal cchMultiByte As Long, ByVal lpDefaultChar As Long, ByVal lpUsedDefaultChar As Long) As Long

Private Const CP_UTF8 = 65001

' ************ ShellExecute �֘A ************
Private Declare Function ShellExecute Lib "shell32.dll" Alias "ShellExecuteA" _
    (ByVal hWnd As Long, _
     ByVal lpOperation As String, _
     ByVal lpFile As String, _
     Optional ByVal lpParameters As String, _
     Optional ByVal lpDirectory As String, _
     Optional ByVal nShowCmd As VbAppWinStyle) As Long

' ************ �o�[�W�������֘A ************
Private Type VS_FIXEDFILEINFO
        dwSignature As Long
        dwStrucVersion As Long         '  e.g. 0x00000042 = "0.42"
        dwFileVersionMS As Long        '  e.g. 0x00030075 = "3.75"
        dwFileVersionLS As Long        '  e.g. 0x00000031 = "0.31"
        dwProductVersionMS As Long     '  e.g. 0x00030010 = "3.10"
        dwProductVersionLS As Long     '  e.g. 0x00000031 = "0.31"
        dwFileFlagsMask As Long        '  = 0x3F for version "0.42"
        dwFileFlags As Long            '  e.g. VFF_DEBUG Or VFF_PRERELEASE
        dwFileOS As Long               '  e.g. VOS_DOS_WINDOWS16
        dwFileType As Long             '  e.g. VFT_DRIVER
        dwFileSubtype As Long          '  e.g. VFT2_DRV_KEYBOARD
        dwFileDateMS As Long           '  e.g. 0
        dwFileDateLS As Long           '  e.g. 0
End Type

Private Declare Function GetFileVersionInfoSize Lib "version.dll" Alias "GetFileVersionInfoSizeA" (ByVal lptstrFilename As String, lpdwHandle As Long) As Long
Private Declare Function GetFileVersionInfo Lib "version.dll" Alias "GetFileVersionInfoA" (ByVal lptstrFilename As String, ByVal dwHandle As Long, ByVal dwLen As Long, lpData As Any) As Long
Private Declare Function VerQueryValue Lib "version.dll" Alias "VerQueryValueA" (pBlock As Any, ByVal lpSubBlock As String, lplpBuffer As Long, puLen As Long) As Long
Private Declare Sub CopyMemory Lib "kernel32" Alias "RtlMoveMemory" (dst As Any, src As Any, ByVal num As Long)


'---------------------------------------------------------------------------------------
' Procedure : OpenPdf
' DateTime  : 2010/02/02 21:20
' Author    : YU-TANG
' Purpose   :
'---------------------------------------------------------------------------------------
'
Public Function OpenPdf( _
        ByRef FilePath As String, _
        Optional ByVal Page As Long, _
        Optional ByVal Comment As String, _
        Optional ByVal Zoom As String, _
        Optional ByVal PageMode As OpenPdfPageMode = oppmNone, _
        Optional ByVal ScrollBar As Variant, _
        Optional ByVal Search As String, _
        Optional ByVal ToolBar As Variant, _
        Optional ByVal NavPanes As Boolean, _
        Optional ByVal View As OpenPdfView, _
        Optional ByVal WindowStyle As VbAppWinStyle = vbNormalFocus) As Double
On Error GoTo eh

    Dim App         As String
    Dim Command     As String
    Dim OpenActions As String
    Dim OpenAction  As String
    Dim hInst       As Long         ' Instance handle from Shell function.
    Dim hWndApp     As Long         ' Window handle from GetWinHandle.
    Dim MajorVer    As Long

    ' Adobe Reader �̃p�X���擾
    App = AdobeReaderPath

    ' Adobe Reader �̃��W���[�o�[�W�������擾
    Call GetVersion(App, MajorVer)

    ' �t�@�C�������݂��邩�`�F�b�N
    IsFileExists FilePath
    
    '�ȉ��AOpenActions ����

    ' -- 1.�y�[�W�ԍ�
    If Page > 0 Then
        OpenAction = "Page=" & Page
        GoSub AddOpenAction
    ' -- 2.�R�����g
        If Comment <> vbNullString Then
            OpenAction = "Comment=" & Comment
            GoSub AddOpenAction
        End If
    End If

    ' -- 3.�\���{��
    If Zoom <> vbNullString Then
        OpenAction = "Zoom=" & Zoom
        GoSub AddOpenAction
    End If

    ' -- 4.�y�[�W���[�h
    Select Case PageMode
        Case oppmBookmarks
            OpenAction = "PageMode=bookmarks"
            GoSub AddOpenAction
            NavPanes = True
        Case oppmThumbs
            OpenAction = "PageMode=thumbs"
            GoSub AddOpenAction
            NavPanes = True
    End Select
    
    ' -- 5.�X�N���[���o�[
    If Not IsMissing(ScrollBar) Then
        OpenAction = "ScrollBar=" & IIf(ScrollBar <> 0, "1", "0")
        GoSub AddOpenAction
    End If

    ' -- 6.����
    If Search <> vbNullString Then
        Select Case MajorVer
            Case Is <= 8    ' Version 8 �ȑO
                OpenAction = "Search=""" & UrlEncodeUTF8(Search) & """"
            Case Else       ' Version 9 �Ȍ�
                OpenAction = "Search=" & UrlEncodeUTF8(Search)
        End Select
        GoSub AddOpenAction
    End If

    ' -- 7.�c�[���o�[
    If Not IsMissing(ToolBar) Then
        OpenAction = "ToolBar=" & IIf(ToolBar <> 0, "1", "0")
        GoSub AddOpenAction
    End If

    ' -- 8.�i�r�Q�[�V�����p�l��
    '  + �y�[�W���[�h�Łu������v���u�T���l�[���v�w�莞�́A
    '    �i�r�Q�[�V�����p�l���̎w��͖�������A��ɕ\������܂��B
    OpenAction = "NavPanes=" & IIf(NavPanes, "1", "0")
    GoSub AddOpenAction

    ' �R�}���h�𐶐�
    If View <> opvNone Then
        ' NewInstance �X�C�b�` /n ��t���Ȃ��ƁA�����̃C���X�^���X��
        ' ���݂����ꍇ�� Window �n���h�������Ȃ����߁A�\���I�v�V����
        ' ���w�肳�ꂽ�ꍇ�� /n �������I�ɕt�����܂��B
        Command = "'<App>' /n /a '<OpenActions>' '<File>'"
    Else
        Command = "'<App>' /a '<OpenActions>' '<File>'"
    End If
    Command = Replace(Command, "'", """")
    Command = Replace(Command, "<App>", App)
    Command = Replace(Command, "<File>", FilePath)
    If OpenActions <> vbNullString Then
        Command = Replace(Command, "<OpenActions>", OpenActions)
    End If

    ' PDF ���J��
    hInst = Shell(Command, WindowStyle)
    OpenPdf = hInst

    ' �\���I�v�V����
    If View <> opvNone Then
        hWndApp = GetWinHandle(hInst)
        If hWndApp <> 0& Then
            Select Case MajorVer
                Case Is <= 8    ' Version 8 �ȑO
                    ' Rotate
                    Select Case View And &HF0
                        Case opvRotateRight     ' �E90����]
                            PostMessage hWndApp, WM_COMMAND, MENU_ID_VIEW_ROTATE_RIGHT, 0&
                        Case opvRotateLeft      ' ��90����]
                            PostMessage hWndApp, WM_COMMAND, MENU_ID_VIEW_ROTATE_LEFT, 0&
                    End Select
                    
                    ' Zoom
                    Select Case View And &HF
                        Case opvFitPage         ' �S�̕\��
                            PostMessage hWndApp, WM_COMMAND, MENU_ID_ZOOM_FIT_PAGE, 0&
                        Case opvFitWidth        ' ���ɍ��킹��
                            PostMessage hWndApp, WM_COMMAND, MENU_ID_ZOOM_FIT_WIDTH, 0&
                        Case opvFitHeight       ' �����ɍ��킹��
                            PostMessage hWndApp, WM_COMMAND, MENU_ID_ZOOM_FIT_HEIGHT, 0&
                        Case opvFitVisible      ' �`��̈�̕��ɍ��킹��
                            PostMessage hWndApp, WM_COMMAND, MENU_ID_ZOOM_FIT_VISIBLE, 0&
                    End Select

                Case Else       ' Version 9 �Ȍ�
                    ' Rotate
                    Select Case View And &HF0
                        Case opvRotateRight     ' �E90����]
                            PostMessage hWndApp, WM_COMMAND, MENU_ID_VIEW_ROTATE_RIGHT + 8, 0&
                        Case opvRotateLeft      ' ��90����]
                            PostMessage hWndApp, WM_COMMAND, MENU_ID_VIEW_ROTATE_LEFT + 8, 0&
                    End Select
                    
                    ' Zoom
                    Select Case View And &HF
                        Case opvFitPage         ' �S�̕\��
                            PostMessage hWndApp, WM_COMMAND, MENU_ID_ZOOM_FIT_PAGE + 8, 0&
                        Case opvFitWidth        ' ���ɍ��킹��
                            PostMessage hWndApp, WM_COMMAND, MENU_ID_ZOOM_FIT_WIDTH + 8, 0&
                        Case opvFitHeight       ' �����ɍ��킹��
                            PostMessage hWndApp, WM_COMMAND, MENU_ID_ZOOM_FIT_HEIGHT + 8, 0&
                        Case opvFitVisible      ' �`��̈�̕��ɍ��킹��
                            PostMessage hWndApp, WM_COMMAND, MENU_ID_ZOOM_FIT_VISIBLE + 8, 0&
                    End Select
            End Select  ' MajorVer
        End If  ' hWndApp <> 0&
    End If  ' View <> opvNone

    Exit Function

AddOpenAction:
    If OpenActions <> vbNullString Then
        OpenActions = OpenActions & "&"
    End If
    OpenActions = OpenActions & OpenAction
    Return

eh:
    If Err.Number = 16 Then
        ' Shell ���s���� '�������G�����܂�' �G���[�B
        ' �N������N���Ȃ�������B�����s�������A����Ɏx��͂Ȃ��̂Ŗ����B
    Else
        ' �Ăяo�����ɒʒm���邽�߁A���߂Ď��s���G���[�𔭐�������B
        Dim num  As Long:   num = Err.Number
        Dim desc As String: desc = Err.Description
        On Error GoTo 0
        Err.Raise num, "OpenPdf", desc
    End If

End Function

'---------------------------------------------------------------------------------------
' Procedure : PrintPdf
' DateTime  : 2010/02/04 00:21
' Author    : YU-TANG
' Purpose   :
' Return    : ShowPrintSettings ���� = True �̏ꍇ�́A�����I�Ɏg�p���� Shell �֐���
'             �߂�l�����̂܂ܕԋp���܂��B�ڍׂ̓w���v���Q�Ƃ��Ă��������B
'             ShowPrintSettings ���� = False �̏ꍇ�́A�����I�Ɏg�p���� ShellExecute
'             API �֐��̖߂�l�����̂܂ܕԋp���܂��B�ڍׂ͉��L���Q�Ƃ��Ă��������B
'             http://msdn.microsoft.com/ja-jp/library/cc422072.aspx
'---------------------------------------------------------------------------------------
'
Public Function PrintPdf( _
        ByRef FilePath As String, _
        Optional ByRef PrinterName As String, _
        Optional ByRef DriverName As String, _
        Optional ByRef PortName As String, _
        Optional ByVal ShowPrintSettings As Boolean) As Double
On Error GoTo eh

    Dim App         As String
    Dim Command     As String
    Dim hInst       As Long         ' Instance handle from Shell function.
    Dim hWndApp     As Long         ' Window handle from GetWinHandle.

    ' Adobe Reader �̃p�X���擾
    App = AdobeReaderPath

    ' �t�@�C�������݂��邩�`�F�b�N
    IsFileExists FilePath

    ' ����ݒ��\������ꍇ
    If ShowPrintSettings Then
        ' �R�}���h�𐶐�
        Command = "'<App>' /s /p '<File>'"      'Print with dialog
        GoSub ParseCommand

        ' PDF �����
        hInst = Shell(Command, vbHide)
        PrintPdf = hInst

        ' �����I��
        ' -- �_�C�A���O��\�������ꍇ�͏I��������̂Ŋ���
        'hWndApp = GetWinHandle(hInst)
        'If hWndApp <> 0& Then
        '    PostMessage hWndApp, WM_CLOSE, 0&, 0&
        'End If

    ' ����ݒ��\�����Ȃ��ꍇ
    Else
        ' PDF �����
        ' -- Shell �֐��� CreateProcess ���g���Ă݂����A�ǂ����Ă���u
        '    Adobe Reader �̃E�B���h�E���\�������B�܂��A������
        '    �E�B���h�E���c��̂ŁA�I��������K�v������B
        '    ���̂��߁A�E�B���h�E���\������Ȃ� ShellExecute �̕����g���B

        If PrinterName = vbNullString Then
            PrintPdf = ShellExecute(Application.hWnd, "print", FilePath)
        Else
            ' �R�}���h�𐶐�
            Command = "'<PrinterName>' '<DriverName>' '<PortName>'"  'PrintTo
            GoSub ParseCommand
            PrintPdf = ShellExecute(Application.hWnd, "printto", FilePath, Command)
        End If
    End If

    Exit Function

eh:
    If Err.Number = 16 Then
        ' Shell ���s���� '�������G�����܂�' �G���[�B
        ' �N������N���Ȃ�������B�����s�������A����Ɏx��͂Ȃ��̂Ŗ����B
    Else
        ' �Ăяo�����ɒʒm���邽�߁A���߂Ď��s���G���[�𔭐�������B
        Dim num  As Long:   num = Err.Number
        Dim desc As String: desc = Err.Description
        On Error GoTo 0
        Err.Raise num, "PrintPdf", desc
    End If
    Exit Function

ParseCommand:
    Command = Replace(Command, "'", """")
    Command = Replace(Command, "<App>", App)
    Command = Replace(Command, "<File>", FilePath)
    Command = Replace(Command, "<PrinterName>", PrinterName)
    Command = Replace(Command, "<DriverName>", DriverName)
    Command = Replace(Command, "<PortName>", PortName)
    Return

End Function



'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
' �ȉ��A�T�u���[�`��
'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

Private Function AdobeReaderPath() As String
    
    Const SUB_KEY = "SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\AcroRd32.exe"
    Dim sPath As String

    ' Adobe Reader �̃p�X���擾
    sPath = RegGetValue(HKEY_LOCAL_MACHINE, SUB_KEY, "", REG_SZ, "")
    ' �O����d���p���Ŋ����Ă����ꍇ�ɔ����āA���p�����폜
    sPath = Replace(sPath, """", vbNullString)
    If sPath = vbNullString Then
        Err.Raise 5, "OpenPdf", "Adobe Reader ��������܂���B"
    Else
        AdobeReaderPath = sPath
    End If

End Function

' �t�@�C����������Ȃ��ꍇ�͎��s���G���[����
Private Sub IsFileExists(ByRef strFilePath As String)

    If strFilePath <> vbNullString Then
        If Dir$(strFilePath) <> vbNullString Then
            Exit Sub
        End If
    End If

    Err.Raise 53    ' File not found

End Sub

'Shell Lightweight Utility APIs - HEROPA's HomePage
'http://www31.ocn.ne.jp/~heropa/vb123.htm#SHGetValue

'
' ���W�X�g���̒l���擾����B
'
Private Function RegGetValue(lnghInKey As hKeyConstants, _
                            ByVal strSubKey As String, _
                            ByVal strValName As String, _
                            lngType As RegTypeConstants, _
                            ByVal varDefault As Variant) As Variant
    ' lngInKey   : �L�[
    ' strSubKey  : �T�u�L�[
    ' strValName : �l
    ' lngType    : �f�[�^�^�C�v
    ' lngDefault : �f�t�H���g�̒l
    ' �߂�l     : �Ή�����l
    Dim varRetVal           As Variant
    Dim lnghSubKey          As Long
    Dim lngBuffer           As Long
    Dim strBuffer           As String
    Dim lngResult           As Long
    ' �f�t�H���g�̒l�����B
    varRetVal = varDefault
    Select Case lngType
        Case REG_DWORD, REG_DWORD_LITTLE_ENDIAN
            ' �����l�����Ă����B
            lngBuffer = 0
            lngResult = SHGetValue(lnghInKey, _
                                   strSubKey, _
                                   strValName, _
                                   REG_DWORD, _
                                   lngBuffer, _
                                   Len(lngBuffer))
            If lngResult = ERROR_SUCCESS Then
                varRetVal = lngBuffer
            End If
        Case REG_SZ
            ' �o�b�t�@���m�ۂ���B
            strBuffer = String(256, vbNullChar)
            lngResult = SHGetValue(lnghInKey, _
                                   strSubKey, _
                                   strValName, _
                                   REG_SZ, _
                                   ByVal strBuffer, _
                                   Len(strBuffer))
            If lngResult = ERROR_SUCCESS Then
                varRetVal = Left$(strBuffer, InStr(strBuffer, vbNullChar) - 1)
            End If
    End Select
    RegGetValue = varRetVal
End Function


' �Q��
'�C���X�^���X �n���h������E�B���h�E�̃n���h��������������@
'http://support.microsoft.com/kb/242308/ja
Private Function ProcIDFromWnd(ByVal hWnd As Long) As Long
   Dim idProc As Long
   
   ' Get PID for this HWnd
   GetWindowThreadProcessId hWnd, idProc
   
   ' Return PID
   ProcIDFromWnd = idProc
End Function
      
Private Function GetWinHandle(hInstance As Long) As Long
    Dim hWnd        As Long
    Dim Length      As Long
    Dim sClassName  As String * 100

    ' Grab the first window handle that Windows finds:
    hWnd = FindWindow(vbNullString, vbNullString)

    ' Loop until you find a match or there are no more window handles:
    Do Until hWnd = 0&
        ' Check if no parent for this window
        If GetParent(hWnd) = 0& Then
            ' Check for PID match
            If hInstance = ProcIDFromWnd(hWnd) Then
                ' Check for class name match
                Length = GetClassName(hWnd, sClassName, 100&)     ' �E�B���h�E�N���X
                If Left(sClassName, Length) = "AcrobatSDIWindow" Then
                    ' Return found handle
                    GetWinHandle = hWnd
                    ' Exit search loop
                    Exit Do
                End If
            End If
        End If

        ' Get the next window handle
        hWnd = GetWindow(hWnd, GW_HWNDNEXT)
    Loop
End Function

' ************ UTF-8 �ϊ��֘A ************
'based on:
'�ۑ��`����UTF-8�ɂ�����
'http://rararahp.cool.ne.jp/cgi-bin/lng/vb/vblng.cgi?print+200508/05080003.txt
Private Function UrlEncodeUTF8(ByRef strInput As String) As String

    Dim s           As String
    Dim p           As Long
    Dim buff()      As Byte
    Dim i           As Integer
    Dim fPercentize As Boolean

    buff = EncodeUTF8(strInput)
    s = Space$((UBound(buff) + 1) * 3)
    p = 1
    For i = LBound(buff) To UBound(buff)
        If buff(i) < 128 Then
            Select Case buff(i)
                Case 32, 34: fPercentize = True     ' �X�y�[�X�Ɠ�d���p��
                Case Else:   fPercentize = False
            End Select
        Else
            fPercentize = True
        End If
        If fPercentize Then
            Mid(s, p) = "%":           p = p + 1
            Mid(s, p) = Hex(buff(i)):  p = p + 2
        Else
            Mid(s, p) = Chr$(buff(i)): p = p + 1
        End If
    Next

    UrlEncodeUTF8 = Left$(s, p - 1)

End Function

Private Function EncodeUTF8(ByVal strInput As String) As Byte()

    Dim lngLength     As Long    ' �ϊ��Ώۂ̕�����
    Dim lngSize       As Long    ' �ϊ���UTF8������o�C�g��
    Dim bytUTF8Buff() As Byte    ' �ϊ���UTF8������o�b�t�@
    Dim lngBuffSize   As Long    ' ������o�b�t�@�̈搔

    ' �ϊ��Ώە��������擾
    lngLength = Len(strInput)
    If lngLength = 0 Then Exit Function

    ' ������o�b�t�@�̈��ݒ�
    lngBuffSize = lngLength * 3

    ' �ϊ��㕶����o�b�t�@�̈�̊m��
    ReDim bytUTF8Buff(lngBuffSize - 1)
    ' Unicode������UTF8������ϊ�
    lngSize = WideCharToMultiByte( _
                CP_UTF8, _
                0&, _
                StrPtr(strInput), _
                lngLength, _
                bytUTF8Buff(LBound(bytUTF8Buff)), _
                lngBuffSize, _
                0&, _
                0&)

    ' �ϊ����s�̏ꍇ�͏I��
    If lngSize = 0 Then Exit Function

    ' �s�v�ȗ̈���J��
    ReDim Preserve bytUTF8Buff(lngSize - 1)

    EncodeUTF8 = bytUTF8Buff

End Function

' Based on:
' Visual Basic �Ńt�@�C���̃o�[�W�������擾
' http://aircross.hp.infoseek.co.jp/vb_ver.htm
'
'   �o�[�W���������擾
'
'       FullPath   �o�[�W�������擾����t�@�C���̃t���p�X
'       Major      ���W���[ �����[�X�ԍ�  �i�[��
'       Minor      �}�C�i�[ �����[�X�ԍ�  �i�[��
'       RevisionH  ���r�W�����ԍ�         �i�[��
'       RevisionL  ���r�W�����ԍ�         �i�[��
'
'       �߂�l      True:����   False:���s
'
Private Function GetVersion( _
        ByVal FullPath As String, _
        Optional ByRef Major As Long, _
        Optional ByRef Minor As Long, _
        Optional ByRef RevisionH As Long, _
        Optional ByRef RevisionL As Long _
    ) As Boolean

    GetVersion = False

    Dim ret         As Boolean
    Dim nLen        As Long
    Dim nHandle     As Long

    '   �o�[�W������񂪎擾�ł��邩�`�F�b�N
    Dim nVerInfoSize    As Long
    nVerInfoSize = GetFileVersionInfoSize(FullPath, 0&)
    If nVerInfoSize < 1 Then Exit Function

    '   �o�[�W���������擾
    Dim cVerInfo()  As Byte
    ReDim cVerInfo(nVerInfoSize) As Byte
    ret = GetFileVersionInfo(FullPath, 0&, nVerInfoSize, cVerInfo(0))
    If ret = False Then Exit Function

    Dim vf  As VS_FIXEDFILEINFO
    ret = VerQueryValue(cVerInfo(0), "\", nHandle, nLen)
    CopyMemory vf.dwSignature, ByVal nHandle, nLen

    'File Version ��
    '   Major, Minor, Revision �ɕҏW
    '(Product Version �Ȃ� dwProductVersionMS �� dwProductVersionLS ���g��)
    CopyMemory Major, ByVal VarPtr(vf.dwFileVersionMS) + 2, 2
    CopyMemory Minor, vf.dwFileVersionMS, 2
    CopyMemory RevisionH, ByVal VarPtr(vf.dwFileVersionLS) + 2, 2
    CopyMemory RevisionL, vf.dwFileVersionLS, 2

    '** �Q�l:
    ' API �Ń��������삹���AVBA �݂̂ŋ��߂�ꍇ�͈ȉ��̂悤�ɂȂ�
'    If vf.dwFileVersionMS < 0 Then
'        Major = &HFFFF& - (Not vf.dwFileVersionMS) \ &H10000
'        Minor = &HFFFF& - Not vf.dwFileVersionMS
'    Else
'        Major = vf.dwFileVersionMS \ &H10000
'        Minor = vf.dwFileVersionMS Mod &H10000
'    End If
'    If vf.dwFileVersionMS < 0 Then
'        RevisionH = &HFFFF& - (Not vf.dwFileVersionLS) \ &H10000
'        RevisionL = &HFFFF& - Not vf.dwFileVersionLS
'    Else
'        RevisionH = vf.dwFileVersionLS \ &H10000
'        RevisionL = vf.dwFileVersionLS Mod &H10000
'    End If

    GetVersion = True

End Function

