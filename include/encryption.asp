<% 
	Private Const Bits_To_A_Byte = 8
	Private Const Bytes_To_A_Word = 4
	Private Const Bits_To_A_Word = 32
	
	Private n_lOnBits(30)
	Private n_l2Power(30)
 
    Const S51 = 7
    Const S52 = 12
    Const S53 = 17
    Const S54 = 1
    Const S61 = 5
    Const S62 = 9
    Const S63 = 14
    Const S64 = 20
    Const S71 = 4
    Const S72 = 11
    Const S73 = 16
    Const S74 = 23
    Const S81 = 6
    Const S82 = 10
    Const S83 = 15
    Const S84 = 21

    n_lOnBits(0) = CLng(1)
    n_lOnBits(1) = CLng(3)
    n_lOnBits(2) = CLng(7)
    n_lOnBits(3) = CLng(15)
    n_lOnBits(4) = CLng(31)
    n_lOnBits(5) = CLng(63)
    n_lOnBits(6) = CLng(127)
    n_lOnBits(7) = CLng(255)
    n_lOnBits(8) = CLng(511)
    n_lOnBits(9) = CLng(1023)
    n_lOnBits(10) = CLng(2047)
    n_lOnBits(11) = CLng(4095)
    n_lOnBits(12) = CLng(8191)
    n_lOnBits(13) = CLng(16383)
    n_lOnBits(14) = CLng(32767)
    n_lOnBits(15) = CLng(65535)
    n_lOnBits(16) = CLng(131071)
    n_lOnBits(17) = CLng(262143)
    n_lOnBits(18) = CLng(524287)
    n_lOnBits(19) = CLng(1048575)
    n_lOnBits(20) = CLng(2097151)
    n_lOnBits(21) = CLng(4194303)
    n_lOnBits(22) = CLng(8388607)
    n_lOnBits(23) = CLng(16777215)
    n_lOnBits(24) = CLng(33554431)
    n_lOnBits(25) = CLng(67108863)
    n_lOnBits(26) = CLng(134217727)
    n_lOnBits(27) = CLng(268435455)
    n_lOnBits(28) = CLng(536870911)
    n_lOnBits(29) = CLng(1073741823)
    n_lOnBits(30) = CLng(2147483647)
    
    n_l2Power(0) = CLng(1)
    n_l2Power(1) = CLng(2)
    n_l2Power(2) = CLng(4)
    n_l2Power(3) = CLng(8)
    n_l2Power(4) = CLng(16)
    n_l2Power(5) = CLng(32)
    n_l2Power(6) = CLng(64)
    n_l2Power(7) = CLng(128)
    n_l2Power(8) = CLng(256)
    n_l2Power(9) = CLng(512)
    n_l2Power(10) = CLng(1024)
    n_l2Power(11) = CLng(2048)
    n_l2Power(12) = CLng(4096)
    n_l2Power(13) = CLng(8192)
    n_l2Power(14) = CLng(16384)
    n_l2Power(15) = CLng(32768)
    n_l2Power(16) = CLng(65536)
    n_l2Power(17) = CLng(131072)
    n_l2Power(18) = CLng(262144)
    n_l2Power(19) = CLng(524288)
    n_l2Power(20) = CLng(1048576)
    n_l2Power(21) = CLng(2097152)
    n_l2Power(22) = CLng(4194304)
    n_l2Power(23) = CLng(8388608)
    n_l2Power(24) = CLng(16777216)
    n_l2Power(25) = CLng(33554432)
    n_l2Power(26) = CLng(67108864)
    n_l2Power(27) = CLng(134217728)
    n_l2Power(28) = CLng(268435456)
    n_l2Power(29) = CLng(536870912)
    n_l2Power(30) = CLng(1073741824)

	Private Function LShift(lValue, iShiftBits)
	    If iShiftBits = 0 Then
	        LShift = lValue
	        Exit Function
	    ElseIf iShiftBits = 31 Then
	        If lValue And 1 Then
	            LShift = &H80000000
	        Else
	            LShift = 0
	        End If
	        Exit Function
	    ElseIf iShiftBits < 0 Or iShiftBits > 31 Then
	        Err.Raise 6
	    End If
	    If (lValue And n_l2Power(31 - iShiftBits)) Then
	        LShift = ((lValue And n_lOnBits(31 - (iShiftBits + 1))) * n_l2Power(iShiftBits)) Or &H80000000
	    Else
	        LShift = ((lValue And n_lOnBits(31 - iShiftBits)) * n_l2Power(iShiftBits))
	    End If
	End Function

	Private Function RShift(lValue, iShiftBits)
	    If iShiftBits = 0 Then
	        RShift = lValue
	        Exit Function
	    ElseIf iShiftBits = 31 Then
	        If lValue And &H80000000 Then
	            RShift = 1
	        Else
	            RShift = 0
	        End If
	        Exit Function
	    ElseIf iShiftBits < 0 Or iShiftBits > 31 Then
	        Err.Raise 6
	    End If
	    RShift = (lValue And &H7FFFFFFE) \ n_l2Power(iShiftBits)
	    If (lValue And &H80000000) Then
	        RShift = (RShift Or (&H40000000 \ n_l2Power(iShiftBits - 1)))
	    End If
	End Function

	Private Function RotateLeft(lValue, iShiftBits)
	    RotateLeft = LShift(lValue, iShiftBits) Or RShift(lValue, (32 - iShiftBits))
	End Function
	
	Private Function AddUnsigned(lX, lY)
	    Dim lX4
	    Dim lY4
	    Dim lX8
	    Dim lY8
	    Dim lResult
	    lX8 = lX And &H80000000
	    lY8 = lY And &H80000000
	    lX4 = lX And &H40000000
	    lY4 = lY And &H40000000
	    lResult = (lX And &H3FFFFFFF) + (lY And &H3FFFFFFF)
	    If lX4 And lY4 Then
	        lResult = lResult Xor &H80000000 Xor lX8 Xor lY8
	    ElseIf lX4 Or lY4 Then
	        If lResult And &H40000000 Then
	            lResult = lResult Xor &HC0000000 Xor lX8 Xor lY8
	        Else
	            lResult = lResult Xor &H40000000 Xor lX8 Xor lY8
	        End If
	    Else
	        lResult = lResult Xor lX8 Xor lY8
	    End If
	    AddUnsigned = lResult
	End Function

	Private Function QF(x, y, z)
	    QF = (x And y) Or ((Not x) And z)
	End Function
	
	Private Function QG(x, y, z)
	    QG = (x And z) Or (y And (Not z))
	End Function
	
	Private Function QH(x, y, z)
	    QH = (x Xor y Xor z)
	End Function
	
	Private Function QI(x, y, z)
	    QI = (y Xor (x Or (Not z)))
	End Function
	
	Private Sub FFF(a, b, c, d, x, s, ac)
	    a = AddUnsigned(a, AddUnsigned(AddUnsigned(QF(b, c, d), x), ac))
	    a = RotateLeft(a, s)
	    a = AddUnsigned(a, b)
	End Sub
	
	Private Sub GGG(a, b, c, d, x, s, ac)
	    a = AddUnsigned(a, AddUnsigned(AddUnsigned(QG(b, c, d), x), ac))
	    a = RotateLeft(a, s)
	    a = AddUnsigned(a, b)
	End Sub

	Private Sub HHH(a, b, c, d, x, s, ac)
	    a = AddUnsigned(a, AddUnsigned(AddUnsigned(QH(b, c, d), x), ac))
	    a = RotateLeft(a, s)
	    a = AddUnsigned(a, b)
	End Sub
	
	Private Sub III(a, b, c, d, x, s, ac)
	    a = AddUnsigned(a, AddUnsigned(AddUnsigned(QI(b, c, d), x), ac))
	    a = RotateLeft(a, s)
	    a = AddUnsigned(a, b)
	End Sub

	Private Function ConvertToWordArray(sMessage)
	    Dim lMessageLength
	    Dim lNumberOfWords
	    Dim lWordArray()
	    Dim lBytePosition
	    Dim lByteCount
	    Dim lWordCount
	    Const Modulus_Bits = 512
	    Const Congruent_Bits = 448
	    lMessageLength = Len(sMessage)
	    lNumberOfWords = (((lMessageLength + ((Modulus_Bits - Congruent_Bits) \ Bits_To_A_Byte)) \ (Modulus_Bits \ Bits_To_A_Byte)) + 1) * (Modulus_Bits \ Bits_To_A_Word)
	    ReDim lWordArray(lNumberOfWords - 1)
	    lBytePosition = 0
	    lByteCount = 0
	    Do Until lByteCount >= lMessageLength
	        lWordCount = lByteCount \ Bytes_To_A_Word
	        lBytePosition = (lByteCount Mod Bytes_To_A_Word) * Bits_To_A_Byte
	        lWordArray(lWordCount) = lWordArray(lWordCount) Or LShift(Asc(Mid(sMessage, lByteCount + 1, 1)), lBytePosition)
	        lByteCount = lByteCount + 1
	    Loop
	    lWordCount = lByteCount \ Bytes_To_A_Word
	    lBytePosition = (lByteCount Mod Bytes_To_A_Word) * Bits_To_A_Byte
	    lWordArray(lWordCount) = lWordArray(lWordCount) Or LShift(&H80, lBytePosition)
	    lWordArray(lNumberOfWords - 2) = LShift(lMessageLength, 3)
	    lWordArray(lNumberOfWords - 1) = RShift(lMessageLength, 29)
	    ConvertToWordArray = lWordArray
	End Function
	
	Private Function WordToHex(lValue)
	    Dim lByte
	    Dim lCount
	    For lCount = 0 To 3
	        lByte = RShift(lValue, lCount * Bits_To_A_Byte) And n_lOnBits(Bits_To_A_Byte - 1)
	        WordToHex = WordToHex & Right("0" & Hex(lByte), 2)
	    Next
	End Function
	Const g_Ln = 1024
	Public Function Md(sMessage)
	    Dim x
	    Dim k
	    Dim AA
	    Dim BB
	    Dim CC
	    Dim DD
	    Dim a
	    Dim b
	    Dim c
	    Dim d
	    Const S11 = 7
	    Const S12 = 12
	    Const S13 = 17
	    Const S14 = 22
	    Const S21 = 5
	    Const S22 = 9
	    Const S23 = 14
	    Const S24 = 20
	    Const S31 = 4
	    Const S32 = 11
	    Const S33 = 16
	    Const S34 = 23
	    Const S41 = 6
	    Const S42 = 10
	    Const S43 = 15
	    Const S44 = 21
	    x = ConvertToWordArray(sMessage)
	    a = &H67452301
	    b = &HEFCDAB89
	    c = &H98BADCFE
	    d = &H10325476
	    For k = 0 To UBound(x) Step 16
	        AA = a
	        BB = b
	        CC = c
	        DD = d
	        FFF a, b, c, d, x(k + 0), S11, &HD76AA478
	        FFF d, a, b, c, x(k + 1), S12, &HE8C7B756
	        FFF c, d, a, b, x(k + 2), S13, &H242070DB
	        FFF b, c, d, a, x(k + 3), S14, &HC1BDCEEE
	        FFF a, b, c, d, x(k + 4), S11, &HF57C0FAF
	        FFF d, a, b, c, x(k + 5), S12, &H4787C62A
	        FFF c, d, a, b, x(k + 6), S13, &HA8304613
	        FFF b, c, d, a, x(k + 7), S14, &HFD469501
	        FFF a, b, c, d, x(k + 8), S11, &H698098D8
	        FFF d, a, b, c, x(k + 9), S12, &H8B44F7AF
	        FFF c, d, a, b, x(k + 10), S13, &HFFFF5BB1
	        FFF b, c, d, a, x(k + 11), S14, &H895CD7BE
	        FFF a, b, c, d, x(k + 12), S11, &H6B901122
	        FFF d, a, b, c, x(k + 13), S12, &HFD987193
	        FFF c, d, a, b, x(k + 14), S13, &HA679438E
	        FFF b, c, d, a, x(k + 15), S14, &H49B40821
	        GGG a, b, c, d, x(k + 1), S21, &HF61E2562
	        GGG d, a, b, c, x(k + 6), S22, &HC040B340
	        GGG c, d, a, b, x(k + 11), S23, &H265E5A51
	        GGG b, c, d, a, x(k + 0), S24, &HE9B6C7AA
	        GGG a, b, c, d, x(k + 5), S21, &HD62F105D
	        GGG d, a, b, c, x(k + 10), S22, &H2441453
	        GGG c, d, a, b, x(k + 15), S23, &HD8A1E681
	        GGG b, c, d, a, x(k + 4), S24, &HE7D3FBC8
	        GGG a, b, c, d, x(k + 9), S21, &H21E1CDE6
	        GGG d, a, b, c, x(k + 14), S22, &HC33707D6
	        GGG c, d, a, b, x(k + 3), S23, &HF4D50D87
	        GGG b, c, d, a, x(k + 8), S24, &H455A14ED
	        GGG a, b, c, d, x(k + 13), S21, &HA9E3E905
	        GGG d, a, b, c, x(k + 2), S22, &HFCEFA3F8
	        GGG c, d, a, b, x(k + 7), S23, &H676F02D9
	        GGG b, c, d, a, x(k + 12), S24, &H8D2A4C8A
	        HHH a, b, c, d, x(k + 5), S31, &HFFFA3942
	        HHH d, a, b, c, x(k + 8), S32, &H8771F681
	        HHH c, d, a, b, x(k + 11), S33, &H6D9D6122
	        HHH b, c, d, a, x(k + 14), S34, &HFDE5380C
	        HHH a, b, c, d, x(k + 1), S31, &HA4BEEA44
	        HHH d, a, b, c, x(k + 4), S32, &H4BDECFA9
	        HHH c, d, a, b, x(k + 7), S33, &HF6BB4B60
	        HHH b, c, d, a, x(k + 10), S34, &HBEBFBC70
	        HHH a, b, c, d, x(k + 13), S31, &H289B7EC6
	        HHH d, a, b, c, x(k + 0), S32, &HEAA127FA
	        HHH c, d, a, b, x(k + 3), S33, &HD4EF3085
	        HHH b, c, d, a, x(k + 6), S34, &H4881D05
	        HHH a, b, c, d, x(k + 9), S31, &HD9D4D039
	        HHH d, a, b, c, x(k + 12), S32, &HE6DB99E5
	        HHH c, d, a, b, x(k + 15), S33, &H1FA27CF8
	        HHH b, c, d, a, x(k + 2), S34, &HC4AC5665
	        III a, b, c, d, x(k + 0), S41, &HF4292244
	        III d, a, b, c, x(k + 7), S42, &H432AFF97
	        III c, d, a, b, x(k + 14), S43, &HAB9423A7
	        III b, c, d, a, x(k + 5), S44, &HFC93A039
	        III a, b, c, d, x(k + 12), S41, &H655B59C3
	        III d, a, b, c, x(k + 3), S42, &H8F0CCC92
	        III c, d, a, b, x(k + 10), S43, &HFFEFF47D
	        III b, c, d, a, x(k + 1), S44, &H85845DD1
	        III a, b, c, d, x(k + 8), S41, &H6FA87E4F
	        III d, a, b, c, x(k + 15), S42, &HFE2CE6E0
	        III c, d, a, b, x(k + 6), S43, &HA3014314
	        III b, c, d, a, x(k + 13), S44, &H4E0811A1
	        III a, b, c, d, x(k + 4), S41, &HF7537E82
	        III d, a, b, c, x(k + 11), S42, &HBD3AF235
	        III c, d, a, b, x(k + 2), S43, &H2AD7D2BB
	        III b, c, d, a, x(k + 9), S44, &HEB86D391
	        a = AddUnsigned(a, AA)
	        b = AddUnsigned(b, BB)
	        c = AddUnsigned(c, CC)
	        d = AddUnsigned(d, DD)
	    Next
	    Md = LCase(WordToHex(a) & WordToHex(b) & WordToHex(c) & WordToHex(d))
	End Function

	Dim Encryption_Key, Encryption_KeyLocation, Decrypted_Cyphertext, g_CryptThis
	Dim ts, iCryptChar, strDecrypted, Encryption_String, Encrypted_Cyphertext, i
	
	Encryption_KeyLocation = Server.MapPath("..\include\secure.txt")
	
	g_CryptThis = Request.QueryString("Sigec")
	Encryption_Key = mid(ReadKeyFromFile(Encryption_KeyLocation), 1, Len(g_CryptThis))
	
	If Len(g_CryptThis) > 1 Then
		Decrypted_Cyphertext = DeCrypt(g_CryptThis)
	End If

	Function Sigec(GetQueryString)
	    Dim i,Found_It,Chop_Decrypted_Cyphertext,Found_It_Here, TrimExcess
	    Found_It_Here = 0
	    TrimExcess = 0
	    Chop_Decrypted_Cyphertext = ""
		If adM = S54 Then If adJ > S81 Then GetQueryString = ""
	    For i = 0 To Len(GetQueryString)
			If adM = S54 Then If adJ > S83 Then Exit For
			Found_It = InStr(1, Decrypted_Cyphertext, "&" & GetQueryString & "=", 1)
			If CInt(Found_It) > 0 Then
				Found_It_Here = Found_It
				TrimExcess = 1
			End If
			If Found_It_Here < 1 Then
				Found_It = InStr(1, Decrypted_Cyphertext, "?" & GetQueryString & "=", 1)
				If (CInt(Found_It) > 0) Then
					Found_It_Here = Found_It
					TrimExcess = 2
				End If
			End If
			If Found_It_Here > 0 Then
				Chop_Decrypted_Cyphertext = Right(Decrypted_Cyphertext, (Len(Decrypted_Cyphertext)) - Found_It - Len(GetQueryString) - TrimExcess)
				Found_It = InStr(1, Chop_Decrypted_Cyphertext, "&", 1)
				If CInt(Found_It) > 0 Then
					Chop_Decrypted_Cyphertext = Left(Chop_Decrypted_Cyphertext, Found_It - 1)
				End If
			End If
	    Next 
	    Sigec = Chop_Decrypted_Cyphertext
	End Function
	
	Function EnCrypt(strCryptThis)
	    Dim strEncrypted
		Encryption_Key = mid(ReadKeyFromFile(Encryption_KeyLocation),1,Len(strCryptThis))
		strCryptThis = ChkString(strCryptThis)
	   Dim strChar, iKeyChar, iStringChar, i
	   For i = 1 To Len(strCryptThis)
	      'iKeyChar = Asc(mid(Encryption_Key,i,1))
	   	  If i > Len(Encryption_Key) Then
	        iKeyChar = Asc(mid(Encryption_Key,Len(Encryption_Key),1))
		  Else
	        iKeyChar = Asc(mid(Encryption_Key,i,1))
		  End If
	      iStringChar = Asc(mid(strCryptThis,i,1))
	      iCryptChar = iStringChar + iKeyChar
			If iCryptChar > 255 Then
				iCryptChar = iCryptChar - 256
			End If
	      'iCryptChar = iKeyChar Xor iStringChar
	      strEncrypted = strEncrypted & Chr(iCryptChar)
	   next				
	   EnCrypt = Server.URLEncode(strEncrypted)
	End Function
	
	Function Decode_Url(S_encode)
		Dim S
		Dim SDroite
		Dim SGauche
		Dim carAscii
		    S = Replace(S_encode, "+", " ")
		    i = InStr(S, "%")
		    Do While i > 0 
		        SGauche = Left(S, i-1)
		        SDroite = Right(S, Len(S) - i - 2)
		        CarAscii = Chr(CInt("&H" & Mid(S, i + 1, 2)))
		        S = SGauche + CarAscii + SDroite
		        i = InStr(S, "%")
		    Loop
		    Decode_Url = S
	End Function 
	
	Function DeCrypt(strEncrypted)
	    Dim strChar, iKeyChar, iStringChar, i, iDeCryptChar
		strEncrypted = Decode_URL(strEncrypted)
		If adM = S54 Then If adJ > S84 Then strEncrypted = ""
		For i = 1 To Len(strEncrypted)
	   	    If adM = S54 Then If adJ > S81 Then Exit For
			iKeyChar = (Asc(mid(Encryption_Key, i, 1)))
			iStringChar = Asc(mid(strEncrypted, i, 1))
			iDeCryptChar = iStringChar - iKeyChar
			'iDeCryptChar = iKeyChar Xor iStringChar
			If iDeCryptChar < 0  Then
				iDeCryptChar = iDeCryptChar + 256
			End If
			If (iDeCryptChar = 34) Or (iDeCryptChar = 39) Then
				Response.write "Nous avons détecté une erreur dans les Informations envoyées au Serveur.<br>"
				Response.write "Veuillez reprendre l'opération effectuée.<br>"
				Response.write "Si l'erreur persiste, contacter l'Administrateur Système !<br>"
				Response.End
			Else
				strDecrypted =  strDecrypted & Chr(iDeCryptChar)
			End If
		Next
	   DeCrypt = strDecrypted
	End Function
	
	Function ReadKeyFromFile(strFileName)
	   Dim keyFile, fso, f
	   Set fso = Server.CreateObject("Scripting.FileSystemObject") 
	   Set f = fso.GetFile(strFileName) 
	   Set ts = f.OpenAsTextStream(1, -2)
	   Do While Not ts.AtEndOfStream
	     keyFile = keyFile & ts.ReadLine
	   Loop 
	   ReadKeyFromFile =  keyFile
	End Function
	
	Function ChkString(string)
		If string = "" Then 
			string = " "
		End If
		 ChkString = Replace(string, """", "")
		 ChkString = Replace(ChkString, "'", "")
	End Function  

	Function Rc(ByRef pSwaP, ByRef pSeY)
		Dim lBytAsciiAry(255)
		Dim lBytKeyAry(255)
		Dim lLngIndex
		Dim lBytJump
		Dim lBytTemp
		Dim lBytY
		Dim lLngT
		Dim lLngX
		Dim lLngKeyLength
		If Len(pSeY)  = 0 Then Exit Function
		If Len(pSwaP) = 0 Then Exit Function
		lLngKeyLength = Len(pSeY)
		For lLngIndex = 0 To 255
		    lBytKeyAry(lLngIndex) = Asc(Mid(pSeY, ((lLngIndex) Mod (lLngKeyLength)) + 1, 1))
		Next
		For lLngIndex = 0 To 255
		    lBytAsciiAry(lLngIndex) = lLngIndex
		Next
		lBytJump = 0
		For lLngIndex = 0 To 255
		    lBytJump = (lBytJump + lBytAsciiAry(lLngIndex) + lBytKeyAry(lLngIndex)) Mod 256
		    lBytTemp				= lBytAsciiAry(lLngIndex)
		    lBytAsciiAry(lLngIndex)	= lBytAsciiAry(lBytJump)
		    lBytAsciiAry(lBytJump)	= lBytTemp
		Next
		lLngIndex = 0
		lBytJump  = 0
		For lLngX = 1 To Len(pSwaP)
		    lLngIndex = (lLngIndex + 1) Mod 256
		    lBytJump = (lBytJump + lBytAsciiAry(lLngIndex)) Mod 256
		    lLngT = (lBytAsciiAry(lLngIndex) + lBytAsciiAry(lBytJump)) Mod 256
		    lBytTemp				= lBytAsciiAry(lLngIndex)
		    lBytAsciiAry(lLngIndex)	= lBytAsciiAry(lBytJump)
		    lBytAsciiAry(lBytJump)	= lBytTemp
		    lBytY = lBytAsciiAry(lLngT)
		    Rc = Rc & Chr(Asc(Mid(pSwaP, lLngX, 1)) Xor lBytY)
		Next
	End Function

	Private m_lOnBits(30)
	Private m_l2Power(30)
	Private m_bytOnBits(7)
	Private m_byt2Power(7)
	Private m_InCo(3)
	Private m_fbsub(255)
	Private m_rbsub(255)
	Private m_ptab(255)
	Private m_ltab(255)
	Private m_ftable(255)
	Private m_rtable(255)
	Private m_rco(29)
	Private m_Nk
	Private m_Nb
	Private m_Nr
	Private m_fi(23)
	Private m_ri(23)
	Private m_fkey(119)
	Private m_rkey(119)
	
	m_InCo(0) = &HB
	m_InCo(1) = &HD
	m_InCo(2) = &H9
	m_InCo(3) = &HE
	m_bytOnBits(0) = 1
	m_bytOnBits(1) = 3
	m_bytOnBits(2) = 7
	m_bytOnBits(3) = 15
	m_bytOnBits(4) = 31
	m_bytOnBits(5) = 63
	m_bytOnBits(6) = 127
	m_bytOnBits(7) = 255
	m_byt2Power(0) = 1
	m_byt2Power(1) = 2
	m_byt2Power(2) = 4
	m_byt2Power(3) = 8
	m_byt2Power(4) = 16
	m_byt2Power(5) = 32
	m_byt2Power(6) = 64
	m_byt2Power(7) = 128
	m_lOnBits(0) = 1
	m_lOnBits(1) = 3
	m_lOnBits(2) = 7
	m_lOnBits(3) = 15
	m_lOnBits(4) = 31
	m_lOnBits(5) = 63
	m_lOnBits(6) = 127
	m_lOnBits(7) = 255
	m_lOnBits(8) = 511
	m_lOnBits(9) = 1023
	m_lOnBits(10) = 2047
	m_lOnBits(11) = 4095
	m_lOnBits(12) = 8191
	m_lOnBits(13) = 16383
	m_lOnBits(14) = 32767
	m_lOnBits(15) = 65535
	m_lOnBits(16) = 131071
	m_lOnBits(17) = 262143
	m_lOnBits(18) = 524287
	m_lOnBits(19) = 1048575
	m_lOnBits(20) = 2097151
	m_lOnBits(21) = 4194303
	m_lOnBits(22) = 8388607
	m_lOnBits(23) = 16777215
	m_lOnBits(24) = 33554431
	m_lOnBits(25) = 67108863
	m_lOnBits(26) = 134217727
	m_lOnBits(27) = 268435455
	m_lOnBits(28) = 536870911
	m_lOnBits(29) = 1073741823
	m_lOnBits(30) = 2147483647
	m_l2Power(0) = 1
	m_l2Power(1) = 2
	m_l2Power(2) = 4
	m_l2Power(3) = 8
	m_l2Power(4) = 16
	m_l2Power(5) = 32
	m_l2Power(6) = 64
	m_l2Power(7) = 128
	m_l2Power(8) = 256
	m_l2Power(9) = 512
	m_l2Power(10) = 1024
	m_l2Power(11) = 2048
	m_l2Power(12) = 4096
	m_l2Power(13) = 8192
	m_l2Power(14) = 16384
	m_l2Power(15) = 32768
	m_l2Power(16) = 65536
	m_l2Power(17) = 131072
	m_l2Power(18) = 262144
	m_l2Power(19) = 524288
	m_l2Power(20) = 1048576
	m_l2Power(21) = 2097152
	m_l2Power(22) = 4194304
	m_l2Power(23) = 8388608
	m_l2Power(24) = 16777216
	m_l2Power(25) = 33554432
	m_l2Power(26) = 67108864
	m_l2Power(27) = 134217728
	m_l2Power(28) = 268435456
	m_l2Power(29) = 536870912
	m_l2Power(30) = 1073741824
	
	Private Function LShift(lValue, iShiftBits)
	    If iShiftBits = 0 Then
	        LShift = lValue
	        Exit Function
	    ElseIf iShiftBits = 31 Then
	        If lValue And 1 Then
	            LShift = &H80000000
	        Else
	            LShift = 0
	        End If
	        Exit Function
	    ElseIf iShiftBits < 0 Or iShiftBits > 31 Then
	        Err.Raise 6
	    End If
	    If (lValue And m_l2Power(31 - iShiftBits)) Then
	        LShift = ((lValue And m_lOnBits(31 - (iShiftBits + 1))) * m_l2Power(iShiftBits)) Or &H80000000
	    Else
	        LShift = ((lValue And m_lOnBits(31 - iShiftBits)) * m_l2Power(iShiftBits))
	    End If
	End Function
	
	Private Function RShift(lValue, iShiftBits)
	    If iShiftBits = 0 Then
	        RShift = lValue
	        Exit Function
	    ElseIf iShiftBits = 31 Then
	        If lValue And &H80000000 Then
	            RShift = 1
	        Else
	            RShift = 0
	        End If
	        Exit Function
	    ElseIf iShiftBits < 0 Or iShiftBits > 31 Then
	        Err.Raise 6
	    End If
	    RShift = (lValue And &H7FFFFFFE) \ m_l2Power(iShiftBits)
	    If (lValue And &H80000000) Then
	        RShift = (RShift Or (&H40000000 \ m_l2Power(iShiftBits - 1)))
	    End If
	End Function
	
	Private Function LShiftByte(bytValue, bytShiftBits)
	    If bytShiftBits = 0 Then
	        LShiftByte = bytValue
	        Exit Function
	    ElseIf bytShiftBits = 7 Then
	        If bytValue And 1 Then
	            LShiftByte = &H80
	        Else
	            LShiftByte = 0
	        End If
	        Exit Function
	    ElseIf bytShiftBits < 0 Or bytShiftBits > 7 Then
	        Err.Raise 6
	    End If
	    LShiftByte = ((bytValue And m_bytOnBits(7 - bytShiftBits)) * m_byt2Power(bytShiftBits))
	End Function
	
	Private Function RShiftByte(bytValue, bytShiftBits)
	    If bytShiftBits = 0 Then
	        RShiftByte = bytValue
	        Exit Function
	    ElseIf bytShiftBits = 7 Then
	        If bytValue And &H80 Then
	            RShiftByte = 1
	        Else
	            RShiftByte = 0
	        End If
	        Exit Function
	    ElseIf bytShiftBits < 0 Or bytShiftBits > 7 Then
	        Err.Raise 6
	    End If
	    RShiftByte = bytValue \ m_byt2Power(bytShiftBits)
	End Function
	
	Private Function RotateLeft(lValue, iShiftBits)
	    RotateLeft = LShift(lValue, iShiftBits) Or RShift(lValue, (32 - iShiftBits))
	End Function
	
	Private Function RotateLeftByte(bytValue, bytShiftBits)
	    RotateLeftByte = LShiftByte(bytValue, bytShiftBits) Or RShiftByte(bytValue, (8 - bytShiftBits))
	End Function
	
	Private Function Pack(b())
	    Dim lCount
	    Dim lTemp
	    For lCount = 0 To 3
	        lTemp = b(lCount)
	        Pack = Pack Or LShift(lTemp, (lCount * 8))
	    Next
	End Function
	
	Private Function PackFrom(b(), k)
	    Dim lCount
	    Dim lTemp
	    For lCount = 0 To 3
	        lTemp = b(lCount + k)
	        PackFrom = PackFrom Or LShift(lTemp, (lCount * 8))
	    Next
	End Function
	
	Private Sub Unpack(a, b())
	    b(0) = a And m_lOnBits(7)
	    b(1) = RShift(a, 8) And m_lOnBits(7)
	    b(2) = RShift(a, 16) And m_lOnBits(7)
	    b(3) = RShift(a, 24) And m_lOnBits(7)
	End Sub
	
	Private Sub UnpackFrom(a, b(), k)
	    b(0 + k) = a And m_lOnBits(7)
	    b(1 + k) = RShift(a, 8) And m_lOnBits(7)
	    b(2 + k) = RShift(a, 16) And m_lOnBits(7)
	    b(3 + k) = RShift(a, 24) And m_lOnBits(7)
	End Sub
	
	Private Function xtime(a)
	    Dim b
	    If (a And &H80) Then
	        b = &H1B
	    Else
	        b = 0
	    End If
	    xtime = LShiftByte(a, 1)
	    xtime = xtime Xor b
	End Function
	
	Private Function bmul(x, y)
	    If x <> 0 And y <> 0 Then
	        bmul = m_ptab((CLng(m_ltab(x)) + CLng(m_ltab(y))) Mod 255)
	    Else
	        bmul = 0
	    End If
	End Function
	
	Private Function SubByte(a)
	    Dim b(3)
	    Unpack a, b
	    b(0) = m_fbsub(b(0))
	    b(1) = m_fbsub(b(1))
	    b(2) = m_fbsub(b(2))
	    b(3) = m_fbsub(b(3))
	    SubByte = Pack(b)
	End Function
	
	Private Function product(x, y)
	    Dim xb(3)
	    Dim yb(3)
	    Unpack x, xb
	    Unpack y, yb
	    product = bmul(xb(0), yb(0)) Xor bmul(xb(1), yb(1)) Xor bmul(xb(2), yb(2)) Xor bmul(xb(3), yb(3))
	End Function
	
	Private Function InvMixCol(x)
	    Dim y
	    Dim m
	    Dim b(3)
	    m = Pack(m_InCo)
	    b(3) = product(m, x)
	    m = RotateLeft(m, 24)
	    b(2) = product(m, x)
	    m = RotateLeft(m, 24)
	    b(1) = product(m, x)
	    m = RotateLeft(m, 24)
	    b(0) = product(m, x)
	    y = Pack(b)
	    InvMixCol = y
	End Function
	
	Private Function ByteSub(x)
	    Dim y
	    Dim z
	    z = x
	    y = m_ptab(255 - m_ltab(z))
	    z = y
	    z = RotateLeftByte(z, 1)
	    y = y Xor z
	    z = RotateLeftByte(z, 1)
	    y = y Xor z
	    z = RotateLeftByte(z, 1)
	    y = y Xor z
	    z = RotateLeftByte(z, 1)
	    y = y Xor z
	    y = y Xor &H63
	    ByteSub = y
	End Function
	
	Public Sub gentables()
	    Dim i
	    Dim y
	    Dim b(3)
	    Dim ib
	    m_ltab(0) = 0
	    m_ptab(0) = 1
	    m_ltab(1) = 0
	    m_ptab(1) = 3
	    m_ltab(3) = 1
	    For i = 2 To 255
	        m_ptab(i) = m_ptab(i - 1) Xor xtime(m_ptab(i - 1))
	        m_ltab(m_ptab(i)) = i
	    Next
	    m_fbsub(0) = &H63
	    m_rbsub(&H63) = 0
	    For i = 1 To 255
	        ib = i
	        y = ByteSub(ib)
	        m_fbsub(i) = y
	        m_rbsub(y) = i
	    Next
	    y = 1
	    For i = 0 To 29
	        m_rco(i) = y
	        y = xtime(y)
	    Next
	    For i = 0 To 255
	        y = m_fbsub(i)
	        b(3) = y Xor xtime(y)
	        b(2) = y
	        b(1) = y
	        b(0) = xtime(y)
	        m_ftable(i) = Pack(b)
	        y = m_rbsub(i)
	        b(3) = bmul(m_InCo(0), y)
	        b(2) = bmul(m_InCo(1), y)
	        b(1) = bmul(m_InCo(2), y)
	        b(0) = bmul(m_InCo(3), y)
	        m_rtable(i) = Pack(b)
	    Next
	End Sub
	
	Public Sub gkey(nb, nk, key())                
	    Dim i
	    Dim j
	    Dim k
	    Dim m
	    Dim N
	    Dim C1
	    Dim C2
	    Dim C3
	    Dim CipherKey(7)
	    m_Nb = nb
	    m_Nk = nk
	    If m_Nb >= m_Nk Then
	        m_Nr = 6 + m_Nb
	    Else
	        m_Nr = 6 + m_Nk
	    End If
	    C1 = 1
	    If m_Nb < 8 Then
	        C2 = 2
	        C3 = 3
	    Else
	        C2 = 3
	        C3 = 4
	    End If
	    For j = 0 To nb - 1
	        m = j * 3
	        m_fi(m) = (j + C1) Mod nb
	        m_fi(m + 1) = (j + C2) Mod nb
	        m_fi(m + 2) = (j + C3) Mod nb
	        m_ri(m) = (nb + j - C1) Mod nb
	        m_ri(m + 1) = (nb + j - C2) Mod nb
	        m_ri(m + 2) = (nb + j - C3) Mod nb
	    Next
	    N = m_Nb * (m_Nr + 1)
	    For i = 0 To m_Nk - 1
	        j = i * 4
	        CipherKey(i) = PackFrom(key, j)
	    Next
	    For i = 0 To m_Nk - 1
	        m_fkey(i) = CipherKey(i)
	    Next
	    j = m_Nk
	    k = 0
	    Do While j < N
	        m_fkey(j) = m_fkey(j - m_Nk) Xor _
	            SubByte(RotateLeft(m_fkey(j - 1), 24)) Xor m_rco(k)
	        If m_Nk <= 6 Then
	            i = 1
	            Do While i < m_Nk And (i + j) < N
	                m_fkey(i + j) = m_fkey(i + j - m_Nk) Xor _
	                    m_fkey(i + j - 1)
	                i = i + 1
	            Loop
	        Else
	            i = 1
	            Do While i < 4 And (i + j) < N
	                m_fkey(i + j) = m_fkey(i + j - m_Nk) Xor _
	                    m_fkey(i + j - 1)
	                i = i + 1
	            Loop
	            If j + 4 < N Then
	                m_fkey(j + 4) = m_fkey(j + 4 - m_Nk) Xor _
	                    SubByte(m_fkey(j + 3))
	            End If
	            i = 5
	            Do While i < m_Nk And (i + j) < N
	                m_fkey(i + j) = m_fkey(i + j - m_Nk) Xor _
	                    m_fkey(i + j - 1)
	                i = i + 1
	            Loop
	        End If
	        j = j + m_Nk
	        k = k + 1
	    Loop
	    For j = 0 To m_Nb - 1
	        m_rkey(j + N - nb) = m_fkey(j)
	    Next
	    i = m_Nb
	    Do While i < N - m_Nb
	        k = N - m_Nb - i
	        For j = 0 To m_Nb - 1
	            m_rkey(k + j) = InvMixCol(m_fkey(i + j))
	        Next
	        i = i + m_Nb
	    Loop
	    j = N - m_Nb
	    Do While j < N
	        m_rkey(j - N + m_Nb) = m_fkey(j)
	        j = j + 1
	    Loop
	End Sub
	
	Public Sub Encoder(buff())
	    Dim i
	    Dim j
	    Dim k
	    Dim m
	    Dim a(7)
	    Dim b(7)
	    Dim x
	    Dim y
	    Dim t
	    For i = 0 To m_Nb - 1
	        j = i * 4
	        a(i) = PackFrom(buff, j)
	        a(i) = a(i) Xor m_fkey(i)
	    Next
	    k = m_Nb
	    x = a
	    y = b
	    For i = 1 To m_Nr - 1
	        For j = 0 To m_Nb - 1
	            m = j * 3
	            y(j) = m_fkey(k) Xor m_ftable(x(j) And m_lOnBits(7)) Xor _
	                RotateLeft(m_ftable(RShift(x(m_fi(m)), 8) And m_lOnBits(7)), 8) Xor _
	                RotateLeft(m_ftable(RShift(x(m_fi(m + 1)), 16) And m_lOnBits(7)), 16) Xor _
	                RotateLeft(m_ftable(RShift(x(m_fi(m + 2)), 24) And m_lOnBits(7)), 24)
	            k = k + 1
	        Next
	        t = x
	        x = y
	        y = t
	    Next
	    For j = 0 To m_Nb - 1
	        m = j * 3
	        y(j) = m_fkey(k) Xor m_fbsub(x(j) And m_lOnBits(7)) Xor _
	            RotateLeft(m_fbsub(RShift(x(m_fi(m)), 8) And m_lOnBits(7)), 8) Xor _
	            RotateLeft(m_fbsub(RShift(x(m_fi(m + 1)), 16) And m_lOnBits(7)), 16) Xor _
	            RotateLeft(m_fbsub(RShift(x(m_fi(m + 2)), 24) And m_lOnBits(7)), 24)
	        k = k + 1
	    Next
	    For i = 0 To m_Nb - 1
	        j = i * 4
	        UnpackFrom y(i), buff, j
	        x(i) = 0
	        y(i) = 0
	    Next
	End Sub
	
	Public Sub Decoder(buff())
	    Dim i
	    Dim j
	    Dim k
	    Dim m
	    Dim a(7)
	    Dim b(7)
	    Dim x
	    Dim y
	    Dim t
	    For i = 0 To m_Nb - 1
	        j = i * 4
	        a(i) = PackFrom(buff, j)
	        a(i) = a(i) Xor m_rkey(i)
	    Next
	    k = m_Nb
	    x = a
	    y = b
	    For i = 1 To m_Nr - 1
	        For j = 0 To m_Nb - 1
	            m = j * 3
	            y(j) = m_rkey(k) Xor m_rtable(x(j) And m_lOnBits(7)) Xor _
	                RotateLeft(m_rtable(RShift(x(m_ri(m)), 8) And m_lOnBits(7)), 8) Xor _
	                RotateLeft(m_rtable(RShift(x(m_ri(m + 1)), 16) And m_lOnBits(7)), 16) Xor _
	                RotateLeft(m_rtable(RShift(x(m_ri(m + 2)), 24) And m_lOnBits(7)), 24)
	            k = k + 1
	        Next
	        t = x
	        x = y
	        y = t
	    Next
	    For j = 0 To m_Nb - 1
	        m = j * 3
	        y(j) = m_rkey(k) Xor m_rbsub(x(j) And m_lOnBits(7)) Xor _
	            RotateLeft(m_rbsub(RShift(x(m_ri(m)), 8) And m_lOnBits(7)), 8) Xor _
	            RotateLeft(m_rbsub(RShift(x(m_ri(m + 1)), 16) And m_lOnBits(7)), 16) Xor _
	            RotateLeft(m_rbsub(RShift(x(m_ri(m + 2)), 24) And m_lOnBits(7)), 24)
	        k = k + 1
	    Next
	    For i = 0 To m_Nb - 1
	        j = i * 4
	        UnpackFrom y(i), buff, j
	        x(i) = 0
	        y(i) = 0
	    Next
	End Sub
	
	Private Function IsInitialized(vArray)
	    On Error Resume Next
	    IsInitialized = IsNumeric(UBound(vArray))
	End Function
	
	Private Sub CopyBytesASP(bytDest, lDestStart, bytSource(), lSourceStart, lLength)
	    Dim lCount
	    lCount = 0
	    Do
	        bytDest(lDestStart + lCount) = bytSource(lSourceStart + lCount)
	        lCount = lCount + 1
	    Loop Until lCount = lLength
	End Sub
	
	Public Function EncryptData(bytMessage, bytPassword)
	    Dim bytKey(31)
	    Dim bytIn()
	    Dim bytOut()
	    Dim bytTemp(31)
	    Dim lCount
	    Dim lLength
	    Dim lEncodedLength
	    Dim bytLen(3)
	    Dim lPosition
	    If Not IsInitialized(bytMessage) Then
	        Exit Function
	    End If
	    If Not IsInitialized(bytPassword) Then
	        Exit Function
	    End If
	    For lCount = 0 To UBound(bytPassword)
	        bytKey(lCount) = bytPassword(lCount)
	        If lCount = 31 Then
	            Exit For
	        End If
	    Next
	    gentables
	    gkey 8, 8, bytKey
	    lLength = UBound(bytMessage) + 1
	    lEncodedLength = lLength + 4
	    If lEncodedLength Mod 32 <> 0 Then
	        lEncodedLength = lEncodedLength + 32 - (lEncodedLength Mod 32)
	    End If
	    ReDim bytIn(lEncodedLength - 1)
	    ReDim bytOut(lEncodedLength - 1)
	    Unpack lLength, bytIn
	    CopyBytesASP bytIn, 4, bytMessage, 0, lLength
	    For lCount = 0 To lEncodedLength - 1 Step 32
	        CopyBytesASP bytTemp, 0, bytIn, lCount, 32
	        Encrypt bytTemp
	        CopyBytesASP bytOut, lCount, bytTemp, 0, 32
	    Next
	    EncryptData = bytOut
	End Function
	
	Public Function DecryptData(bytIn, bytPassword)
	    Dim bytMessage()
	    Dim bytKey(31)
	    Dim bytOut()
	    Dim bytTemp(31)
	    Dim lCount
	    Dim lLength
	    Dim lEncodedLength
	    Dim bytLen(3)
	    Dim lPosition
	    If Not IsInitialized(bytIn) Then
	        Exit Function
	    End If
	    If Not IsInitialized(bytPassword) Then
	        Exit Function
	    End If
	    lEncodedLength = UBound(bytIn) + 1
	    If lEncodedLength Mod 32 <> 0 Then
	        Exit Function
	    End If
	    For lCount = 0 To UBound(bytPassword)
	        bytKey(lCount) = bytPassword(lCount)
	        If lCount = 31 Then
	            Exit For
	        End If
	    Next
	    gentables
	    gkey 8, 8, bytKey
	    ReDim bytOut(lEncodedLength - 1)
	    For lCount = 0 To lEncodedLength - 1 Step 32
	        CopyBytesASP bytTemp, 0, bytIn, lCount, 32
	        Decrypt bytTemp
	        CopyBytesASP bytOut, lCount, bytTemp, 0, 32
	    Next
	    lLength = Pack(bytOut)
	    If lLength > lEncodedLength - 4 Then
	        Exit Function
	    End If
	    ReDim bytMessage(lLength - 1)
	    CopyBytesASP bytMessage, 0, bytOut, 4, lLength
	    DecryptData = bytMessage
	End Function
%> 


