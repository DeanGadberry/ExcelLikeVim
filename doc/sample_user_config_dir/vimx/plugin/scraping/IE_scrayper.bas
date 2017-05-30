Attribute VB_Name = "IE_scrayper"
#If VBA7 Then
Private Declare PtrSafe Sub Sleep Lib "kernel32" (ByVal ms As LongPtr)
#Else
Private Declare Sub Sleep Lib "kernel32" (ByVal ms As Long)
#End If

'----------------------------------------------------------------
'�@�w��URL��\������T�u���[�`���uieView�v
Sub ieView(objIE As InternetExplorer, _
           urlName As String, _
           Optional viewFlg As Boolean = True)

  'IE(InternetExplorer)�̃I�u�W�F�N�g���쐬����
  Set objIE = CreateObject("InternetExplorer.Application")

  'IE(InternetExplorer)��\���E��\��
  objIE.Visible = viewFlg

  '�w�肵��URL�̃y�[�W��\������
  objIE.navigate urlName
 
 'IE�����S�\�������܂őҋ@
 Call ieCheck(objIE)

End Sub


'----------------------------------------------------------------
'�AWeb�y�[�W���S�Ǎ��ҋ@�����T�u���[�`���uieCheck�v
Sub ieCheck(objIE As InternetExplorer)

  Dim timeOut As Date

  timeOut = Now + TimeSerial(0, 0, 20)

  Do While objIE.Busy = True Or objIE.readyState <> 4
    DoEvents
    Sleep 1
    If Now > timeOut Then
      objIE.Refresh
      timeOut = Now + TimeSerial(0, 0, 20)
    End If
  Loop

  timeOut = Now + TimeSerial(0, 0, 20)

  Do While objIE.Document.readyState <> "complete"
    DoEvents
    Sleep 1
    If Now > timeOut Then
      objIE.Refresh
      timeOut = Now + TimeSerial(0, 0, 20)
    End If
   Loop

End Sub


'----------------------------------------------------------------
'���T�u���[�`���𗘗p���ĕ����T�C�g��IE�ŋN��������}�N��
Sub IEsample()

  Dim objIE  As InternetExplorer
  Dim objIE2  As InternetExplorer

  '�{�T�C�g��IE�ŋN��
  Call ieView(objIE, "http://www.vba-ie.net/")

  'yahoo�T�C�g��IE�ŋN��
  Call ieView(objIE2, "http://www.yahoo.co.jp/")

End Sub

