Attribute VB_Name = "keystroke"

Private Declare Function GetAsyncKeyState Lib "user32.dll" (ByVal vKey As Long) As Long
Private Declare Function GetKeyboardState Lib "user32" (pbKeyState As Byte) As Long
Private Declare Function GetTickCount Lib "kernel32" () As Long '�p�t�H�[�}���X�v���̂��ߡ

Public Const timeoutLen As Single = 1000 '���̃L�[�܂Ť�ҋ@���鎞�ԡ(�b)

Dim keyStroke As String
Dim keyMapDic As Object 'key��func�����т��鎫��
Dim isNewStroke As Boolean
Dim keybinde As String
Dim s As Double '�O��̃L�[���͂̎��Ԃ�ۊǂ��Ă����

Public Sub toggleVimKeybinde()'{{{
	If keybinde <> "off" Then
		Call AllKeyAssign_reset()
		keybinde = "off"
	Else
		Call AllKeyToAssesKeyFunc()
	End If
End Sub'}}}

Public Sub AllKeyAssign_dummy() '{{{
    Application.OnKey "a", "dummy"
    Application.OnKey "b", "dummy"
    Application.OnKey "c", "dummy"
    Application.OnKey "d", "dummy"
    Application.OnKey "e", "dummy"
    Application.OnKey "f", "dummy"
    Application.OnKey "g", "dummy"
    Application.OnKey "h", "dummy"
    Application.OnKey "i", "dummy"
    Application.OnKey "j", "dummy"
    Application.OnKey "k", "dummy"
    Application.OnKey "l", "dummy"
    Application.OnKey "m", "dummy"
    Application.OnKey "n", "dummy"
    Application.OnKey "o", "dummy"
    Application.OnKey "p", "dummy"
    Application.OnKey "q", "dummy"
    Application.OnKey "r", "dummy"
    Application.OnKey "s", "dummy"
    Application.OnKey "t", "dummy"
    Application.OnKey "u", "dummy"
    Application.OnKey "v", "dummy"
    Application.OnKey "w", "dummy"
    Application.OnKey "x", "dummy"
    Application.OnKey "y", "dummy"
    Application.OnKey "z", "dummy"
    
    Application.OnKey "0", "dummy"
    Application.OnKey "1", "dummy"
    Application.OnKey "2", "dummy"
    Application.OnKey "3", "dummy"
    Application.OnKey "4", "dummy"
    Application.OnKey "5", "dummy"
    Application.OnKey "6", "dummy"
    Application.OnKey "7", "dummy"
    Application.OnKey "8", "dummy"
    Application.OnKey "9", "dummy"
    
    Application.OnKey "=", "dummy"
    Application.OnKey "-", "dummy"
    Application.OnKey "{^}", "dummy"
    Application.OnKey "@", "dummy"
    Application.OnKey "{[}", "dummy"
    Application.OnKey ";", "dummy"
    Application.OnKey ":", "dummy"
    Application.OnKey "{]}", "dummy"
    Application.OnKey ",", "dummy" '
    Application.OnKey ".", "dummy"
    Application.OnKey "/", "dummy" '
    
    Application.OnKey "+a", "dummy"
    Application.OnKey "+b", "dummy"
    Application.OnKey "+c", "dummy"
    Application.OnKey "+d", "dummy"
    Application.OnKey "+e", "dummy"
    Application.OnKey "+f", "dummy"
    Application.OnKey "+g", "dummy"
    Application.OnKey "+h", "dummy"
    Application.OnKey "+i", "dummy"
    Application.OnKey "+j", "dummy"
    Application.OnKey "+k", "dummy"
    Application.OnKey "+l", "dummy"
    Application.OnKey "+m", "dummy"
    Application.OnKey "+n", "dummy"
    Application.OnKey "+o", "dummy"
    Application.OnKey "+p", "dummy"
    Application.OnKey "+q", "dummy"
    Application.OnKey "+r", "dummy"
    Application.OnKey "+s", "dummy"
    Application.OnKey "+t", "dummy"
    Application.OnKey "+u", "dummy"
    Application.OnKey "+v", "dummy"
    Application.OnKey "+w", "dummy"
    Application.OnKey "+x", "dummy"
    Application.OnKey "+y", "dummy"
    Application.OnKey "+z", "dummy"
    
    Application.OnKey "+0", "dummy"
    Application.OnKey "+1", "dummy"
    Application.OnKey "+2", "dummy"
    Application.OnKey "+3", "dummy"
    Application.OnKey "+4", "dummy"
    Application.OnKey "+5", "dummy"
    Application.OnKey "+6", "dummy"
    Application.OnKey "+7", "dummy"
    Application.OnKey "+8", "dummy"
    Application.OnKey "+9", "dummy"
End Sub '}}}

Public Sub AllKeyAssign_reset() '{{{
    Application.OnKey "a"
    Application.OnKey "b"
    Application.OnKey "c"
    Application.OnKey "d"
    Application.OnKey "e"
    Application.OnKey "f"
    Application.OnKey "g"
    Application.OnKey "h"
    Application.OnKey "i"
    Application.OnKey "j"
    Application.OnKey "k"
    Application.OnKey "l"
    Application.OnKey "m"
    Application.OnKey "n"
    Application.OnKey "o"
    Application.OnKey "p"
    Application.OnKey "q"
    Application.OnKey "r"
    Application.OnKey "s"
    Application.OnKey "t"
    Application.OnKey "u"
    Application.OnKey "v"
    Application.OnKey "w"
    Application.OnKey "x"
    Application.OnKey "y"
    Application.OnKey "z"
    
    Application.OnKey "0"
    Application.OnKey "1"
    Application.OnKey "2"
    Application.OnKey "3"
    Application.OnKey "4"
    Application.OnKey "5"
    Application.OnKey "6"
    Application.OnKey "7"
    Application.OnKey "8"
    Application.OnKey "9"
    
    Application.OnKey "="
    Application.OnKey "-"
    Application.OnKey "{^}"
    Application.OnKey "?"
    Application.OnKey "@"
    Application.OnKey "{[}"
    Application.OnKey ";"
    Application.OnKey ":"
    Application.OnKey "{]}"
    Application.OnKey "."
    
    Application.OnKey "+a"
    Application.OnKey "+b"
    Application.OnKey "+c"
    Application.OnKey "+d"
    Application.OnKey "+e"
    Application.OnKey "+f"
    Application.OnKey "+g"
    Application.OnKey "+h"
    Application.OnKey "+i"
    Application.OnKey "+j"
    Application.OnKey "+k"
    Application.OnKey "+l"
    Application.OnKey "+m"
    Application.OnKey "+n"
    Application.OnKey "+o"
    Application.OnKey "+p"
    Application.OnKey "+q"
    Application.OnKey "+r"
    Application.OnKey "+s"
    Application.OnKey "+t"
    Application.OnKey "+u"
    Application.OnKey "+v"
    Application.OnKey "+w"
    Application.OnKey "+x"
    Application.OnKey "+y"
    Application.OnKey "+z"
    
    Application.OnKey "+0"
    Application.OnKey "+1"
    Application.OnKey "+2"
    Application.OnKey "+3"
    Application.OnKey "+4"
    Application.OnKey "+5"
    Application.OnKey "+6"
    Application.OnKey "+7"
    Application.OnKey "+8"
    Application.OnKey "+9"
    
    Application.OnKey "+-"
    Application.OnKey "+{^}"
    Application.OnKey "+?"
    Application.OnKey "+@"
    Application.OnKey "+{[}"
    Application.OnKey "+;"
    Application.OnKey "+:"
    Application.OnKey "+{]}"
    Application.OnKey "<"
    Application.OnKey "+."
    Application.OnKey "+/"
    Application.OnKey "_"
    
    'Ctrl
    Application.OnKey "^a"
    Application.OnKey "^b"
    Application.OnKey "^c"
    Application.OnKey "^d"
    Application.OnKey "^e"
    Application.OnKey "^f"
    Application.OnKey "^g"
    Application.OnKey "^h"
    Application.OnKey "^i"
    Application.OnKey "^j"
    Application.OnKey "^k"
    Application.OnKey "^l"
    Application.OnKey "^m"
    Application.OnKey "^n"
    Application.OnKey "^o"
    Application.OnKey "^p"
    Application.OnKey "^q"
    Application.OnKey "^r"
    Application.OnKey "^s"
    Application.OnKey "^t"
    Application.OnKey "^u"
    Application.OnKey "^v"
    Application.OnKey "^w"
    Application.OnKey "^x"
    Application.OnKey "^y"
    Application.OnKey "^z"
    
    Application.OnKey "^0"
    Application.OnKey "^1"
    Application.OnKey "^2"
    Application.OnKey "^3"
    Application.OnKey "^4"
    Application.OnKey "^5"
    Application.OnKey "^6"
    Application.OnKey "^7"
    Application.OnKey "^8"
    Application.OnKey "^9"
    
    Application.OnKey "^-"
    Application.OnKey "^{^}"
    Application.OnKey "^?"
    Application.OnKey "^@"
    Application.OnKey "^{[}"
    Application.OnKey "^;"
    Application.OnKey "^:"
    Application.OnKey "^{]}"
    Application.OnKey "^."
    
    Application.OnKey "^+a"
    Application.OnKey "^+b"
    Application.OnKey "^+c"
    Application.OnKey "^+d"
    Application.OnKey "^+e"
    Application.OnKey "^+f"
    Application.OnKey "^+g"
    Application.OnKey "^+h"
    Application.OnKey "^+i"
    Application.OnKey "^+j"
    Application.OnKey "^+k"
    Application.OnKey "^+l"
    Application.OnKey "^+m"
    Application.OnKey "^+n"
    Application.OnKey "^+o"
    Application.OnKey "^+p"
    Application.OnKey "^+q"
    Application.OnKey "^+r"
    Application.OnKey "^+s"
    Application.OnKey "^+t"
    Application.OnKey "^+u"
    Application.OnKey "^+v"
    Application.OnKey "^+w"
    Application.OnKey "^+x"
    Application.OnKey "^+y"
    Application.OnKey "^+z"
    
    Application.OnKey "^+0"
    Application.OnKey "^+1"
    Application.OnKey "^+2"
    Application.OnKey "^+3"
    Application.OnKey "^+4"
    Application.OnKey "^+5"
    Application.OnKey "^+6"
    Application.OnKey "^+7"
    Application.OnKey "^+8"
    Application.OnKey "^+9"
    
    Application.OnKey "^+-"
    Application.OnKey "^+{^}"
    Application.OnKey "^+?"
    Application.OnKey "^+@"
    Application.OnKey "^+{[}"
    Application.OnKey "^+;"
    Application.OnKey "^+:"
    Application.OnKey "^+{]}"
    Application.OnKey "^<"
    Application.OnKey "^+."
    Application.OnKey "^+/"
    Application.OnKey "^_"
End Sub '}}}

Public Sub AllKeyToAssesKeyFunc()'{{{
    Application.OnKey "a", "AssesKey"
    Application.OnKey "b", "AssesKey"
    Application.OnKey "c", "AssesKey"
    Application.OnKey "d", "AssesKey"
    Application.OnKey "e", "AssesKey"
    Application.OnKey "f", "AssesKey"
    Application.OnKey "g", "AssesKey"
    Application.OnKey "h", "AssesKey"
    Application.OnKey "i", "AssesKey"
    Application.OnKey "j", "AssesKey"
    Application.OnKey "k", "AssesKey"
    Application.OnKey "l", "AssesKey"
    Application.OnKey "m", "AssesKey"
    Application.OnKey "n", "AssesKey"
    Application.OnKey "o", "AssesKey"
    Application.OnKey "p", "AssesKey"
    Application.OnKey "q", "AssesKey"
    Application.OnKey "r", "AssesKey"
    Application.OnKey "s", "AssesKey"
    Application.OnKey "t", "AssesKey"
    Application.OnKey "u", "AssesKey"
    Application.OnKey "v", "AssesKey"
    Application.OnKey "w", "AssesKey"
    Application.OnKey "x", "AssesKey"
    Application.OnKey "y", "AssesKey"
    Application.OnKey "z", "AssesKey"
    
    Application.OnKey "0", "AssesKey"
    Application.OnKey "1", "AssesKey"
    Application.OnKey "2", "AssesKey"
    Application.OnKey "3", "AssesKey"
    Application.OnKey "4", "AssesKey"
    Application.OnKey "5", "AssesKey"
    Application.OnKey "6", "AssesKey"
    Application.OnKey "7", "AssesKey"
    Application.OnKey "8", "AssesKey"
    Application.OnKey "9", "AssesKey"
    
    Application.OnKey "-", "AssesKey"
    Application.OnKey "{^}", "AssesKey"
    Application.OnKey "@", "AssesKey"
    Application.OnKey "{[}", "AssesKey"
    Application.OnKey ";", "AssesKey"
    Application.OnKey ":", "AssesKey"
    Application.OnKey "{]}", "AssesKey"
    Application.OnKey ",", "AssesKey"
    Application.OnKey ".", "AssesKey"
    Application.OnKey "/", "AssesKey"
    Application.OnKey "=", "AssesKey"
    Application.OnKey "{+}", "AssesKey"
    Application.OnKey ">", "AssesKey"
    Application.OnKey "<", "AssesKey"
    Application.OnKey "?", "AssesKey"
    Application.OnKey "|", "AssesKey"
    Application.OnKey "'", "AssesKey"
    Application.OnKey "*", "AssesKey"
    Application.OnKey "{{}", "AssesKey"
    Application.OnKey "{}}", "AssesKey"
    Application.OnKey "{(}", "AssesKey"
    Application.OnKey "{)}", "AssesKey"
    Application.OnKey "!", "AssesKey"
    Application.OnKey "#", "AssesKey"

    Application.OnKey "+{a}", "AssesKey"
    Application.OnKey "+{b}", "AssesKey"
    Application.OnKey "+{c}", "AssesKey"
    Application.OnKey "+{d}", "AssesKey"
    Application.OnKey "+{e}", "AssesKey"
    Application.OnKey "+{f}", "AssesKey"
    Application.OnKey "+{g}", "AssesKey"
    Application.OnKey "+{h}", "AssesKey"
    Application.OnKey "+{i}", "AssesKey"
    Application.OnKey "+{j}", "AssesKey"
    Application.OnKey "+{k}", "AssesKey"
    Application.OnKey "+{l}", "AssesKey"
    Application.OnKey "+{m}", "AssesKey"
    Application.OnKey "+{n}", "AssesKey"
    Application.OnKey "+{o}", "AssesKey"
    Application.OnKey "+{p}", "AssesKey"
    Application.OnKey "+{q}", "AssesKey"
    Application.OnKey "+{r}", "AssesKey"
    Application.OnKey "+{s}", "AssesKey"
    Application.OnKey "+{t}", "AssesKey"
    Application.OnKey "+{u}", "AssesKey"
    Application.OnKey "+{v}", "AssesKey"
    Application.OnKey "+{w}", "AssesKey"
    Application.OnKey "+{x}", "AssesKey"
    Application.OnKey "+{y}", "AssesKey"
    Application.OnKey "+{z}", "AssesKey"
    Application.OnKey "+0", "AssesKey"
    Application.OnKey "+1", "AssesKey"
    Application.OnKey "+2", "AssesKey"
    Application.OnKey "+3", "AssesKey"
    Application.OnKey "+4", "AssesKey"
    Application.OnKey "+5", "AssesKey"
    Application.OnKey "+6", "AssesKey"
    Application.OnKey "+7", "AssesKey"
    Application.OnKey "+8", "AssesKey"
    Application.OnKey "+9", "AssesKey"

    'Application.OnKey "^{a}", "AssesKey"
    Application.OnKey "^{b}", "AssesKey"
    'Application.OnKey "^{c}", "AssesKey"
    Application.OnKey "^{d}", "AssesKey"
    Application.OnKey "^{e}", "AssesKey"
    Application.OnKey "^{f}", "AssesKey"
    Application.OnKey "^{g}", "AssesKey"
    Application.OnKey "^{h}", "AssesKey"
    Application.OnKey "^{i}", "AssesKey"
    Application.OnKey "^{j}", "AssesKey"
    Application.OnKey "^{k}", "AssesKey"
    Application.OnKey "^{l}", "AssesKey"
    Application.OnKey "^{m}", "AssesKey"
    'Application.OnKey "^{n}", "AssesKey"
    Application.OnKey "^{o}", "AssesKey"
    'Application.OnKey "^{p}", "AssesKey"
    Application.OnKey "^{q}", "AssesKey"
    Application.OnKey "^{r}", "AssesKey"
    'Application.OnKey "^{s}", "AssesKey"
    Application.OnKey "^{t}", "AssesKey"
    Application.OnKey "^{u}", "AssesKey"
    'Application.OnKey "^{v}", "AssesKey"
    'Application.OnKey "^{w}", "AssesKey"
    'Application.OnKey "^{x}", "AssesKey"
    Application.OnKey "^{y}", "AssesKey"
    'Application.OnKey "^{z}", "AssesKey"
    Application.OnKey "^0", "AssesKey"
    Application.OnKey "^1", "AssesKey"
    Application.OnKey "^2", "AssesKey"
    Application.OnKey "^3", "AssesKey"
    Application.OnKey "^4", "AssesKey"
    Application.OnKey "^5", "AssesKey"
    Application.OnKey "^6", "AssesKey"
    Application.OnKey "^7", "AssesKey"
    Application.OnKey "^8", "AssesKey"
    Application.OnKey "^9", "AssesKey"

    Application.OnKey "{F1}", "AssesKey"
    'Application.OnKey "{F2}", "AssesKey"
    Application.OnKey "{F3}", "AssesKey"
    Application.OnKey "{F4}", "AssesKey"
    Application.OnKey "{F5}", "AssesKey"
    Application.OnKey "{F6}", "AssesKey"
    Application.OnKey "{F7}", "AssesKey"
    Application.OnKey "{F8}", "AssesKey"
    Application.OnKey "{F9}", "AssesKey"
    Application.OnKey "{F10}", "AssesKey"
    'Application.OnKey "{F11}", "AssesKey" KeyStroke�͏����Ă��܂��̂ł���łȂ��Ăѕ����K�v�Ȃ��ߡ
    ' Application.OnKey "{F12}", "AssesKey" �㏑���ۑ������̂܂܎g���
    Application.OnKey "{F13}", "AssesKey"
    Application.OnKey "{F14}", "AssesKey"
    Application.OnKey "{F15}", "AssesKey"
    Application.OnKey "{F16}", "AssesKey"
    Application.OnKey "{ESC}", "AssesKey"

	Application.OnKey "{HOME}", "move_head"
	Application.OnKey "{END}", "move_tail"
End Sub'}}}

Public Function SetKeyMapDic(Optional mode As String = "normal", Optional settingFilePath As String = "") As Variant '{{{
	'keyMpaDictionay�̏�����
	Set keyMapDic = CreateObject("Scripting.Dictionary")

	Call SetKeyMapDicCore(mode) 'default_mapping�̓ǂݍ���
	If settingFilePath = "" Then
		Call SetKeyMapDicCore(mode, "C:\" & Environ("homepath") & "\mapping.txt") 'customize_mapping�̓ǂݍ���
	End If
End Function '}}}

Public Function SetKeyMapDicCore(Optional mode As String = "normal", Optional settingFilePath As String = "") As Variant '{{{
	If settingFilePath = "" Then
		Open ThisWorkbook.path & "\data\" & "default_mapping.txt" For Input As #1
	Else
		Open settingFilePath For Input As #1
	End If

	intCount = 0
	matchContext = True

	Select Case mode
		Case "normal"
			instruction = "nmap"
		Case "visual"
			instruction = "vmap"
		Case "line_visual"
			instruction = "lvmap"
	End Select

	Do Until EOF(1)
		Line Input #1, buf
		buf = Replace(buf,vbTab,"") 'tab(�C���f���g)�𖳎�
		If buf <> "" Then
			list = Split(buf, " ")
			if list(0) = instruction And matchContext Then
				commandString = Mid(buf, Instr(Instr(buf, " ") + 1, buf, " ") + 1) '2�ڂ̃X�y�[�X�ȍ~���擾
				keyMapDic.Item(list(1)) = commandString '�����̍��ڒǉ�
			ElseIf list(0) = "for" Then
				list2 = Split(list(1),":")
				If list2(0) = ActiveWorkbook.Name And (list2(1) = "" OR list2(1) = ActiveSheet.Name) Then '���܂Ƀt�@�C���ɂ���Ă̓C���f�b�N�X�̕s��
					matchContext = True
				Else
					matchContext = False
				End If
			End If
		End If
	Loop
	Close #1
	'MsgBox "SetKeyMapDic���V���ɌĂ΂�܂���"

	isNewStroke = True '������
End Function '}}}

Private Sub AssesKey()'{{{
	'���̊֐��̓L�[�ɂ���ČĂяo����,���s���ׂ������𔻒肵�܂��

	'TODO strokkey��keystring�̏��Ԃɂ���ĘA���ŉ��ߏo������̂Ƃ����łȂ����̂��o���Ă��܂��Ă���B
	Application.EnableCancelKey = xlDisabled 'for Esc Command.Without this, cannot catch ESC key.

	s = GetTickCount '0�~���Z�J���h

	'AppEvent Class���p������Ă��Ȃ����L�[�̊m�F����܂�object���p������Ă���̂š'{{{
	If myobject.appevent is Nothing Then 
		Call SetAppEvent
	End If'}}}

	'keyMap����`����Ă��Ȃ��ꍇ�͒�`����B'{{{
	If keyMapDic is Nothing Then 
		SetKeyMapDic
	End If'}}}

	'Update keyStroke
	If isNewStroke = True Then
		keyStroke = "" 'global�ϐ�keyStroke�����Z�b�g
		newkey = KeyString '�V�K�̏ꍇ�ͤGetKeyboardState���g���B������̊֐��łȂ��Ƥ�̂ǂ���modifierkey�̉e�����󂯂Ă��܂��
		keyStroke = keyStroke + newkey
	Else
		newkey = KeyStringAsync 'GetKeyboardState���g���ƑO�̃L�[�̏�񂪎c���Ă��܂��Ă��鎖�����邽�ߤ��������g���
		if newkey = "<ESC>" Then 'ESC�������ꍇ�̓X�g���[�N�����Z�b�g
			SendKeys "{ESC}"
			isNewStroke = True
			Exit Sub
		Else
			keyStroke = keyStroke + newkey
		End If
	End If

	'When Application.OnKey Works, but KeyString does not work.'{{{
	if newkey = "" Then 
		Debug.Print "StringKey����̂��ߏI��"
		Exit Sub
	End If'}}}

	'keyStroke��]��
	Debug.print KeyStroke & "��]�����܂�"
	If NumberOfHits(keyStroke) = 0 Then 'keyStroke�Ƀq�b�g��0��
'		Debug.Print "�q�b�g��0��"
		isNewStroke = True
		Exit Sub
	ElseIf NumberOfHits(keyStroke) = 1 And keyMapDic.Exists(keyStroke) Then '��₪��ӂ��q�b�g���Ă��鎞
'		Debug.print "��₪��ӂ��q�b�g���Ă��鎞��AssesKey��(�֐��Ăяo���܂ł�)���s���Ԃ�" & GetTickCount - st & "�~���Z�J���h"
		Debug.Print keyMapDic.Item(keyStroke) & "��keystroke����Ăяo��"
		Call ExeStringPro(keyMapDic.Item(keyStroke), ActiveWorkbook.Name)
		isNewStroke = True
		Debug.Print "poformanace time is " & GetTickCount - s
		Exit Sub
	Else 
'		Debug.print "��₪�����̎�"
		isNewStroke = False
		e = GetTickCount

		'�Ď��̐�
		Do until e-s > timeoutLen
			key = KeyStringAsync '(��)KeyStringAsync�͉���������Ă��Ȃ����A""��Ԃ��B
			'���̃L�[���������O�ɤ�O�̃L�[�������ꂽ�ꍇ�
			if key = "" Then
'				Debug.print "�ŏ��̃L�[������܂����"
				Exit Do
			End if

			'�O�̃L�[���������O�Ɏ��̃L�[�������ꂽ�ꍇ
			if key <> "" And key <> newkey Then
'				Debug.print "�ŏ��̃L�[��������Ȃ��܂܂ɤ�ʂ̃L�["& key &"���A���ŉ�����܂���"
				'AssesKeyCore(key) ��������s�����Ƃ�Application.onkey�ɂ���Ď���AssesKey���Ă΂��
				Exit Sub
			End if
			e = GetTickCount
		Loop

		'�ŏ��̃L�[������Ă���̊Ď��̐�
		Do until e-s > timeoutLen
			key = KeyStringAsync
			if key <> "" Then
				Exit Sub 
			End if
			e = GetTickCount
		Loop

		Debug.print "loop���S�ĉ�������ߤ���̃X�g���[�N�ŕ]�����܂��"
		Application.Run keyMapDic.Item(keyStroke)
		isNewStroke = True
	End If
End Sub
'}}}

Private Function KeyStringAsync()'{{{
	'�֐����s���_�ŉ�����Ă���L�[�𔻕ʂ��ĕԂ��܂��
	'shift'{{{
	shift = False
    If GetAsyncKeyState(16) <> 0 Then shift = True '}}} '�Ȃ���<0���ƌ��m���Ȃ��

	'control'{{{
	control = False
    If GetAsyncKeyState(17) <> 0 Then control = True'}}}

	'main'{{{
	main = ""
	'alphabet'{{{
    If GetAsyncKeyState(65) < 0 Then main = "a"
    If GetAsyncKeyState(66) < 0 Then main = "b"
    If GetAsyncKeyState(67) < 0 Then main = "c"
    If GetAsyncKeyState(68) < 0 Then main = "d"
    If GetAsyncKeyState(69) < 0 Then main = "e"
    If GetAsyncKeyState(70) < 0 Then main = "f"
    If GetAsyncKeyState(71) < 0 Then main = "g"
    If GetAsyncKeyState(72) < 0 Then main = "h"
    If GetAsyncKeyState(73) < 0 Then main = "i"
    If GetAsyncKeyState(74) < 0 Then main = "j"
    If GetAsyncKeyState(75) < 0 Then main = "k"
    If GetAsyncKeyState(76) < 0 Then main = "l"
    If GetAsyncKeyState(77) < 0 Then main = "m"
    If GetAsyncKeyState(78) < 0 Then main = "n"
    If GetAsyncKeyState(79) < 0 Then main = "o" '�Ȃ���
    If GetAsyncKeyState(80) < 0 Then main = "p"
    If GetAsyncKeyState(81) < 0 Then main = "q"
    If GetAsyncKeyState(82) < 0 Then main = "r"
    If GetAsyncKeyState(83) < 0 Then main = "s"
    If GetAsyncKeyState(84) < 0 Then main = "t"
    If GetAsyncKeyState(85) < 0 Then main = "u" '�Ȃ���
    If GetAsyncKeyState(86) < 0 Then main = "v"
    If GetAsyncKeyState(87) < 0 Then main = "w"
    If GetAsyncKeyState(88) < 0 Then main = "x"
    If GetAsyncKeyState(89) < 0 Then main = "y"
    If GetAsyncKeyState(90) < 0 Then main = "z"'}}}
	'number'{{{
    If GetAsyncKeyState(48) < 0 Then main = "0"
    If GetAsyncKeyState(49) < 0 Then main = "1"
    If GetAsyncKeyState(50) < 0 Then main = "2"
    If GetAsyncKeyState(51) < 0 Then main = "3"
    If GetAsyncKeyState(52) < 0 Then main = "4"
    If GetAsyncKeyState(53) < 0 Then main = "5"
    If GetAsyncKeyState(54) < 0 Then main = "6"
    If GetAsyncKeyState(55) < 0 Then main = "7"
    If GetAsyncKeyState(56) < 0 Then main = "8"
    If GetAsyncKeyState(57) < 0 Then main = "9"'}}}
	'symbol'{{{
	If GetAsyncKeyState(186) < 0 Then main = ":"
    If GetAsyncKeyState(187) < 0 Then main = ";"
    If GetAsyncKeyState(188) < 0 Then main = ","
    If GetAsyncKeyState(189) < 0 Then main = "-"
    If GetAsyncKeyState(190) < 0 Then main = "."
    If GetAsyncKeyState(191) < 0 Then main = "/"
    If GetAsyncKeyState(192) < 0 Then main = "@"
    If GetAsyncKeyState(219) < 0 Then main = "["
    If GetAsyncKeyState(220) < 0 Then main = "\"
    If GetAsyncKeyState(221) < 0 Then main = "]"
    If GetAsyncKeyState(222) < 0 Then main = "^"'}}}
	'others'{{{
	If GetAsyncKeyState(23) < 0 Then main = "<END>"
	If GetAsyncKeyState(vbKeyEscape) < 0 Then main = "<ESC>"
    If GetAsyncKeyState(24) < 0 Then main = "<HOME>"'}}}
	'Function key'{{{
    If GetAsyncKeyState(112) < 0 Then main = "F1"
    If GetAsyncKeyState(113) < 0 Then main = "F2"
    If GetAsyncKeyState(114) < 0 Then main = "F3"
    If GetAsyncKeyState(115) < 0 Then main = "F4"
    If GetAsyncKeyState(116) < 0 Then main = "F5"
    If GetAsyncKeyState(117) < 0 Then main = "F6"
    If GetAsyncKeyState(118) < 0 Then main = "F7"
    If GetAsyncKeyState(119) < 0 Then main = "F8"
    If GetAsyncKeyState(120) < 0 Then main = "F9"
    If GetAsyncKeyState(121) < 0 Then main = "F10"
    'If GetAsyncKeyState(122) < 0 Then main = "F11" '�Ȃ���F11���������鎖������̂Ť�㏑�����悤�ɏ�Ɂ�VBE�N���L�[��F11
    If GetAsyncKeyState(123) < 0 Then main = "F12"
    If GetAsyncKeyState(124) < 0 Then main = "F13"
    If GetAsyncKeyState(125) < 0 Then main = "F14"
    If GetAsyncKeyState(126) < 0 Then main = "F15"
    If GetAsyncKeyState(127) < 0 Then main = "F16"
'}}}'}}}

	'�Ԃ�l���Z�b�g'{{{
	keyStringAsync = ""
	If shift Then
		KeyStringAsync = UCase(main)
	ElseIf control Then
		KeyStringAsync = "<c-" & main & ">"
	Else
		KeyStringAsync = main
	End If'}}}
'	'Debug.print "KeyString�̎��s���Ԃ�" & GetTickCount - s & "�~���Z�J���h"
End Function'}}}

Private Function KeyString()'{{{
'nodoka��modifierkey�ȂǂɂȂ��Ă���L�[�ͤAsync�ł͎擾�o���Ȃ����߂�����Ŏ擾
	'keyboard�̏�Ԃ�state�ɃZ�b�g'{{{
	Dim state(255) As Byte
	Call GetKeyboardState(state(0))
	'http://www.yoshidastyle.net/2007/10/windowswin32api.html
	' For i = 0 to 255
	' 	if state(i) <> 0 And state(i) <> 1 Then
'	' 		Debug.Print "���z�L�[�R�[�h" & i "�̏�Ԃ�" & state(i)
	' 	End If
	' Next i'}}}

	'shift�L�[�̔���'{{{
	Dim shift As boolean
	shift = False
	shift = state(16) >= 128'}}}

	'control�L�[�̔���'{{{
	Dim control As boolean
	control = False
	control = state(17) >= 128'}}}

	'main�L�[�̎擾'{{{
	Dim main As String : main = ""
	'main
	If shift Then
		'number
		If state(49) >= 128 Then main = "!"
		If state(50) >= 128 Then main = """
		If state(51) >= 128 Then main = "#"
		If state(52) >= 128 Then main = "$"
		If state(53) >= 128 Then main = "%"
		If state(54) >= 128 Then main = "&"
		If state(55) >= 128 Then main = "'"
		If state(56) >= 128 Then main = "("
		If state(57) >= 128 Then main = ")"
		'alphabet
		If state(65) >= 128 Then main = "A"
		If state(66) >= 128 Then main = "B"
		If state(67) >= 128 Then main = "C"
		If state(68) >= 128 Then main = "D"
		If state(69) >= 128 Then main = "E"
		If state(70) >= 128 Then main = "F"
		If state(71) >= 128 Then main = "G"
		If state(72) >= 128 Then main = "H"
		If state(73) >= 128 Then main = "I"
		If state(74) >= 128 Then main = "J"
		If state(75) >= 128 Then main = "K"
		If state(76) >= 128 Then main = "L"
		If state(77) >= 128 Then main = "M"
		If state(78) >= 128 Then main = "N"
		If state(79) >= 128 Then main = "O"
		If state(80) >= 128 Then main = "P"
		If state(81) >= 128 Then main = "Q"
		If state(82) >= 128 Then main = "R"
		If state(83) >= 128 Then main = "S"
		If state(84) >= 128 Then main = "T"
		If state(85) >= 128 Then main = "U"
		If state(86) >= 128 Then main = "V"
		If state(87) >= 128 Then main = "W"
		If state(88) >= 128 Then main = "X"
		If state(89) >= 128 Then main = "Y"
		If state(90) >= 128 Then main = "Z"
		'symbol
		If state(186) >= 128 Then main = "*"
		If state(187) >= 128 Then main = "+"
		If state(188) >= 128 Then main = "<"
		If state(189) >= 128 Then main = "="
		If state(190) >= 128 Then main = ">"
		If state(191) >= 128 Then main = "?"
		If state(192) >= 128 Then main = "`"
		If state(219) >= 128 Then main = "{"
		If state(220) >= 128 Then main = "|"
		If state(221) >= 128 Then main = "}"
		If state(222) >= 128 Then main = "~"
	Else
		If state(48) >= 128 Then main = "0"
		If state(49) >= 128 Then main = "1"
		If state(50) >= 128 Then main = "2"
		If state(51) >= 128 Then main = "3"
		If state(52) >= 128 Then main = "4"
		If state(53) >= 128 Then main = "5"
		If state(54) >= 128 Then main = "6"
		If state(55) >= 128 Then main = "7"
		If state(56) >= 128 Then main = "8"
		If state(57) >= 128 Then main = "9"
		'alphabet
		If state(86) >= 128 Then main = "v" 'visual_mode���ォ��̈ړ��L�[���X���[�Y�ɂ��邽�ߐ擪�ɡ
		If state(65) >= 128 Then main = "a"
		If state(66) >= 128 Then main = "b"
		If state(67) >= 128 Then main = "c"
		If state(68) >= 128 Then main = "d"
		If state(69) >= 128 Then main = "e"
		If state(70) >= 128 Then main = "f"
		If state(71) >= 128 Then main = "g"
		If state(72) >= 128 Then main = "h"
		If state(73) >= 128 Then main = "i"
		If state(74) >= 128 Then main = "j"
		If state(75) >= 128 Then main = "k"
		If state(76) >= 128 Then main = "l"
		If state(77) >= 128 Then main = "m"
		If state(78) >= 128 Then main = "n"
		If state(79) >= 128 Then main = "o"
		If state(80) >= 128 Then main = "p"
		If state(81) >= 128 Then main = "q"
		If state(82) >= 128 Then main = "r"
		If state(83) >= 128 Then main = "s"
		If state(84) >= 128 Then main = "t"
		If state(85) >= 128 Then main = "u"
		If state(87) >= 128 Then main = "w"
		If state(88) >= 128 Then main = "x"
		If state(89) >= 128 Then main = "y"
		If state(90) >= 128 Then main = "z"
		'symbol
		If state(186) >= 128 Then main = ":"
		If state(187) >= 128 Then main = ";"
		If state(188) >= 128 Then main = ","
		If state(189) >= 128 Then main = "-"
		If state(190) >= 128 Then main = "."
		If state(191) >= 128 Then main = "/"
		If state(192) >= 128 Then main = "@"
		If state(219) >= 128 Then main = "["
		If state(220) >= 128 Then main = "\"
		If state(221) >= 128 Then main = "]"
		If state(222) >= 128 Then main = "^"
		'others
		If state(23) >= 128 Then main = "<END>"
		If state(24) >= 128 Then main = "<HOME>"
		If state(vbKeyEscape) >= 128 Then main = "<ESC>"
	End If

	'Function key'{{{
    If state(112) >= 128 Then main = "F1"
    If state(113) >= 128 Then main = "F2"
    If state(114) >= 128 Then main = "F3"
    If state(115) >= 128 Then main = "F4"
    If state(116) >= 128 Then main = "F5"
    If state(117) >= 128 Then main = "F6"
    If state(118) >= 128 Then main = "F7"
    If state(119) >= 128 Then main = "F8"
    If state(120) >= 128 Then main = "F9"
    If state(121) >= 128 Then main = "F10"
    'If state(122) >= 128 Then main = "F11" '�Ȃ���F11���������鎖������̂Ť�㏑�����悤�ɏ�Ɂ�VBE�N���L�[��F11
    If state(123) >= 128 Then main = "F12"
    If state(124) >= 128 Then main = "F13"
    If state(125) >= 128 Then main = "F14"
    If state(126) >= 128 Then main = "F15"
    If state(127) >= 128 Then main = "F16"
'}}}
'}}}

	'�Ԃ�l�ɃZ�b�g'{{{
	If control Then
		KeyString = "<c-" & main & ">"
	Else
		KeyString = main
	End If'}}}

End Function'}}}

Function NumberOfHits(stroke As String) As Long'{{{
	Dim s As Long
	s = GetTickCount '0�~���Z�J���h

	'�z��̒��Ť�O����v���鍀�ڂ̐���Ԃ��֐�
	c = 0
	keyList = keyMapDic.Keys
	For i = 0 To UBound(keyList)
		If InStr(keyList(i), stroke) = 1 Then
			c = c + 1
		End If
	Next i
	NumberOfHits = c

'	' Debug.print "NumberOfHits�̎��s���Ԃ�" & GetTickCount - s & "�~���Z�J���h"
End Function'}}}

'Application.onkey��2��Ă΂�Ă��܂����
'�����Application.onkey���Ăяo�����L�[�ͤ���̌�C�x���g�ɖ�������邪
'�����łȂ��L�[(�Ō�̃X�g���[�N)�ͤ�I������Ɏ��Ȃ�application.onkey�����ł��܂��

