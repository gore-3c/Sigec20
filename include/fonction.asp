<%
'#################################################################
'##################	FONCTION AFFICHAGE PRIX	######################
'#################################################################
	Public Function Prix(Nbre)
		If IsNull(Nbre) Then Nbre = 0
		Dim Nbre1, Cent, Ct, Mil, Mln, Mld, Lg, Bln, Bld, i, aPrix
		Dim Price
			Price = Split(Nbre, ",")
		'Nbre1 = Nbre
		If Nbre  = "" Then
			Prix = ""
		Else
			Nbre1 = Ccur(Price(0))
			Lg = CInt(Len(Nbre1))
			If Lg < 3 Then
				aPrix = Nbre1
			ElseIf Lg >= 3 And Lg < 7 Then
				Ct = Mid(Nbre1, Lg - 2, 3)
				Mil = Mid(Nbre1, 1, Lg - 3)
				aPrix = Mil & " " & Ct
			ElseIf Lg >= 7 And Lg < 10 Then
				Ct = Mid(Nbre1, Lg - 2, 3)
				Mil = Mid(Nbre1, Lg - 5, 3)
				Mln = Mid(Nbre1, 1, Lg - 6)
				aPrix = Mln & " " & Mil & " " & Ct
			ElseIf Lg >= 10 And Lg < 13 Then
				Ct = Mid(Nbre1, Lg - 2, 3)
				Mil = Mid(Nbre1, Lg - 5, 3)
				Mln = Mid(Nbre1, Lg - 8, 3)
				Mld = Mid(Nbre1, 1, Lg - 9)
				aPrix = Mld & " " & Mln & " " & Mil & " " & Ct
			ElseIf Lg >= 13 And Lg < 15 Then
				Ct = Mid(Nbre1, Lg - 2, 3)
				Mil = Mid(Nbre1, Lg - 5, 3)
				Mln = Mid(Nbre1, Lg - 8, 3)
				Mld = Mid(Nbre1, Lg - 11, 3)
				Bln = Mid(Nbre1, 1, Lg - 12)
				aPrix = Bln & " " & Mld & " " & Mln & " " & Mil & " " & Ct
			ElseIf Lg >= 15 And Lg < 18 Then
				Ct = Mid(Nbre1, Lg - 2, 3)
				Mil = Mid(Nbre1, Lg - 5, 3)
				Mln = Mid(Nbre1, Lg - 8, 3)
				Mld = Mid(Nbre1, Lg - 11, 3)
				Bln = Mid(Nbre1, Lg - 14, 3)
				Bld = Mid(Nbre1, 1, Lg - 15)
				aPrix = Bld & " " & Bln & " " & Mld & " " & Mln & " " & Mil & " " & Ct
			End If
			
			Prix = aPrix
				  
			If uBound(Price) >= 1 Then
				Nbre1 = Ccur(Price(1))
				Lg = CInt(Len(Nbre1))
				If Lg < 3 Then
					Prix = Nbre1
				ElseIf Lg >= 3 And Lg < 7 Then
					Ct = Mid(Nbre1, Lg - 2, 3)
					Mil = Mid(Nbre1, 1, Lg - 3)
					Prix = Mil & " " & Ct
				ElseIf Lg >= 7 And Lg < 10 Then
					Ct = Mid(Nbre1, Lg - 2, 3)
					Mil = Mid(Nbre1, Lg - 5, 3)
					Mln = Mid(Nbre1, 1, Lg - 6)
					Prix = Mln & " " & Mil & " " & Ct
				ElseIf Lg >= 10 And Lg < 13 Then
					Ct = Mid(Nbre1, Lg - 2, 3)
					Mil = Mid(Nbre1, Lg - 5, 3)
					Mln = Mid(Nbre1, Lg - 8, 3)
					Mld = Mid(Nbre1, 1, Lg - 9)
					Prix = Mld & " " & Mln & " " & Mil & " " & Ct
				ElseIf Lg >= 13 And Lg < 15 Then
					Ct = Mid(Nbre1, Lg - 2, 3)
					Mil = Mid(Nbre1, Lg - 5, 3)
					Mln = Mid(Nbre1, Lg - 8, 3)
					Mld = Mid(Nbre1, Lg - 11, 3)
					Bln = Mid(Nbre1, 1, Lg - 12)
					Prix = Bln & " " & Mld & " " & Mln & " " & Mil & " " & Ct
				ElseIf Lg >= 15 And Lg < 18 Then
					Ct = Mid(Nbre1, Lg - 2, 3)
					Mil = Mid(Nbre1, Lg - 5, 3)
					Mln = Mid(Nbre1, Lg - 8, 3)
					Mld = Mid(Nbre1, Lg - 11, 3)
					Bln = Mid(Nbre1, Lg - 14, 3)
					Bld = Mid(Nbre1, 1, Lg - 15)
					Prix = Bld & " " & Bln & " " & Mld & " " & Mln & " " & Mil & " " & Ct
				End If
				Prix = aPrix & "," & Prix
			End If
						
		End If
			 
	End Function

'#################################################################
'##################	NUMEROTATION CDC & FO1	######################
'#################################################################
	Function ZeroCool(Nb, nbZero)	' zerocool(nombre que l'on veux formater , nombre de zero à rajouter devant)
		If Nb <> "" Then ZeroCool = String(nbZero - Len(Nb), "0") & Nb End If
	End Function

'#################################################################
'##################	Fonction IS NUMERIC	REG EXE ##################
'#################################################################
	Dim sInvalidChars, a
		
    Function VerifNumerique(nb)
        Dim regEx
        Set regEx = New RegExp
        regEx.Global = False
			regEx.Pattern = "^[0-9]+$"
			notag = regEx.test(nb)
    End Function
		
	Function IsValidString(sValidate)
	    sInvalidChars = " !.#$%^&*()=+{}[]|\;:/?>,<§µù£¤^¨°àçèé&|@~'-`_€aAbBcCdDeEfFgGhHiIjJkKlLmMnNoOpPqQrRsStTuUvVwWxXyYzZ"
	    For a = 1 To Len(sInvalidChars)
            If InStr(sValidate, Mid(sInvalidChars, a, 1)) > 0 or sValidate = "" Then 
				IsValidString = False
				If IsValidString = False Then Exit For
			Else
				IsValidString = True
            End If
	    Next
	End Function

	Function IsNombre(sValidate)
	    sInvalidChars = " !.#$%^&*()=+{}[]|\;:/?>,<§µù£¤^¨°àçèé&|@~'`_€aAbBcCdDeEfFgGhHiIjJkKlLmMnNoOpPqQrRsStTuUvVwWxXyYzZ"
	    For a = 1 To Len(sInvalidChars)
            If InStr(sValidate, Mid(sInvalidChars, a, 1)) > 0 or sValidate = "" Then 
				IsNombre = False
				If IsNombre = False Then Exit For
			Else
				IsNombre = True
            End If
	    Next
	End Function

	Function IsValidDbl(sValidate)
	    sInvalidChars = " !.#$%^&*()=+{}[]|\;:/?><§µù£¤^¨°àçèé&|@~'-`_€aAbBcCdDeEfFgGhHiIjJkKlLmMnNoOpPqQrRsStTuUvVwWxXyYzZ"
	    For a = 1 To Len(sInvalidChars)
            If InStr(sValidate, Mid(sInvalidChars, a, 1)) > 0 or sValidate = "" Then 
				IsValidDbl = False
				If IsValidDbl = False Then Exit For
			Else
				IsValidDbl = True
            End If
	    Next
	End Function
	
	Function IsValidNombre(sValidate)
	    sInvalidChars = " !#$%^&*()=+{}[]|\;:/?>,<§µù£¤^¨°àçèé&|@~'-`_€aAbBcCdDeEfFgGhHiIjJkKlLmMnNoOpPqQrRsStTuUvVwWxXyYzZ"
	    For a = 1 To Len(sInvalidChars)
            If InStr(sValidate, Mid(sInvalidChars, a, 1)) > 0 or sValidate = "" Then 
				IsValidNombre = False
				If IsValidNombre = False Then Exit For
			Else
				IsValidNombre = True
            End If
	    Next
	End Function
	
	Function IsValidDate(sValidate)
	    sInvalidChars = " !#$%^&*()=+{}[]|\;:?>,<§µù£¤^¨°àçèé&|@~'-`_€aAbBcCdDeEfFgGhHiIjJkKlLmMnNoOpPqQrRsStTuUvVwWxXyYzZ"
	    For a = 1 To Len(sInvalidChars)
            If InStr(sValidate, Mid(sInvalidChars, a, 1)) > 0 or sValidate = "" Then 
				IsValidDate = False
				If IsValidDate = False Then Exit For
			Else
				IsValidDate = True
            End If
	    Next
	End Function

'#################################################################
'###################### FONCTION ARRONDI #########################
'#################################################################
	Function FormatNombre(ArrondiNombre)
		Dim Nombre
		If ArrondiNombre = "" Or IsNull(ArrondiNombre) = True Then ArrondiNombre = 0 End If
		    Nombre = FormatNumber(ArrondiNombre,0)
	    If Int(Right(CStr(Nombre),1)) > 0 Then Nombre = Round(Nombre) End If
			FormatNombre = Cdbl(Int(Nombre))
	End Function
	
	Function Nombre_Lot(ArrondiNbre)
		Dim Nbre
		If ArrondiNbre = "" Or IsNull(ArrondiNbre) = True Then ArrondiNbre = 0 End If
		    Nbre = FormatNumber(ArrondiNbre,2)
	    If Int(Right(CStr(Nbre),2)) > 0 Then Nbre = Nbre + 1 End If
			Nombre_Lot = Cdbl(Int(Nbre))
	End Function

'#################################################################
'###################### Fonction REPLACE #########################
'#################################################################
	Function Remplace(Message)
		If IsNull(Message) = False Then Message = Replace(Message, "'", "''") End If
	    Remplace = Message
	End Function

'#################################################################
'###################### Fonction BOOLEAN #########################
'#################################################################
	Function Bool(Etat)
		If CBool(Etat) = True  Then Etat = 1 End If
		If CBool(Etat) = False Then Etat = 0 End If
		Bool = Etat
	End Function

'#################################################################
'###################### Fonction Date ############################
'#################################################################
	Function InsertDate(RempDate)
		If Isnull(RempDate) = True  Then InsertDate = "Null" End If
		If IsNull(RempDate) = False Then InsertDate = "'" & CDate(RempDate) & "'" End If
	End Function


'#################################################################
'###################### RECHERCHE DE TEXTE	######################
'#################################################################
	' ------------------------------------------
	' renvoit True si le deuxième texte passé 
	' en paramètre est dans le premier
	' ------------------------------------------
	Function Cherche(txtBase, txtRecherche)
		Cherche = False
		i = 1
		Do While (i + Len(txtRecherche) <= Len (txtBase) + 1) And Cherche = False
		    If LCase(txtRecherche) = LCase(Mid(txtBase, i, Len(txtRecherche))) Then
		        Cherche = True
		    End If
		    i = i + 1
		Loop
	End Function     

'#################################################################
'###################### NOMBRE - LETTRE	 #########################
'#################################################################
	'Public Function NversL(NversL_n As Double, NversL_entier As String, NversL_reel As String)
	Public Function NversL(NversL_n, NversL_entier, NversL_reel)
	
		Dim NversL_n1 
		Dim NversL_n2 
		Dim NversL_t 
		Dim NversL_x 
		
			NversL_n1 = NversL_n
			NversL_t  = ""
		
		'Erreur
		If NversL_n1 > 999999999999.99 Then	
			NversL = "Erreur !"	
			Exit Function 
		End If
		
		'Milliard
		NversL_n2 = Int(NversL_n1 / 1000000000)
		NversL_x  = NversL_cent(NversL_n2, False)
		NversL_n1 = NversL_n1 - NversL_n2 * 1000000000
		If Trim(NversL_x) <> "zéro" Then 
			NversL_t = NversL_t & NversL_x & " milliard"
			If Trim(NversL_x) <> "un" Then NversL_t = NversL_t & "s" End If
			'Pour avoir 'un milliard [de] francs'
			If Int(NversL_n1) = 0 Then NversL_t = NversL_t & " de"	End If
		End If 
		
		'Million
		NversL_n2 = Int(NversL_n1 / 1000000)
		NversL_x  = NversL_cent(NversL_n2, False)
		NversL_n1 = NversL_n1 - NversL_n2 * 1000000
		If Trim(NversL_x) <> "zéro" Then 
			NversL_t = NversL_t & NversL_x & " million"
			If Trim(NversL_x) <> "un" Then	NversL_t = NversL_t & "s" End If
			'Pour avoir 'un million [de] francs'
			If Int(NversL_n1) = 0 Then NversL_t = NversL_t & " de" End If
		End If 
		
		'Millier
		NversL_n2 = Int(NversL_n1 / 1000)
		NversL_x  = NversL_cent(NversL_n2, True)
		NversL_n1 = NversL_n1 - NversL_n2 * 1000
		If Trim(NversL_x) <> "zéro" Then
			If Trim(NversL_x) <> "un" Then NversL_t = NversL_t & NversL_x & " mille" Else NversL_t = NversL_t & " mille" End If
		End If
		
		'Unité
		NversL_n2 = Int(NversL_n1)
		NversL_x  = NversL_cent(NversL_n2, False)
		NversL_n1 = NversL_n1 - NversL_n2
		If Trim(NversL_x) <> "zéro" Then NversL_t = NversL_t & NversL_x End If
		
		'zéro
		If Len(NversL_t) = 0 Then NversL_t = "zéro" End If
		
		'Franc(s)
		If NversL_entier <> "" Then NversL_t = NversL_t & " " & NversL_entier End If
		If Int(NversL_n) > 1 And Trim(NversL_entier) <> "" Then NversL_t = NversL_t & "s" End If
		
		'Dixième
		NversL_n2 = CInt(NversL_n1 * 100)
		NversL_x  = NversL_cent(NversL_n2, False)
		NversL_n1 = NversL_n1 - NversL_n2
		
		If Trim(NversL_x) <> "zéro" Then 
			NversL_t = NversL_t & " et" & NversL_x & IIf(NversL_reel <> "", " " & NversL_reel, "")
			If NversL_n2 > 1 And Trim(NversL_reel) <> "" Then NversL_t = NversL_t & "s" End If
		End If
		
		NversL_t = Trim(NversL_t)
		NversL   = UCase(Left(NversL_t, 1)) & Right(NversL_t, Len(NversL_t) - 1)
		
	End Function
	
	Private Function NversL_cent(n_cent, mille_cent)
	
		'mille_cent : 'oui' si sa correspond à un millier
		
		Dim n1_cent 
		Dim n2_cent
		Dim t_cent
		Dim x_cent 
		
		n1_cent = n_cent
		t_cent  = ""
		
		'Centaine
		n2_cent = Int(n1_cent / 100)
		x_cent  = NversL_chiffre(n2_cent)
		n1_cent = n1_cent - n2_cent * 100
		If Trim(x_cent) <> "zéro" Then
			If Trim(x_cent) <> "un" Then t_cent = t_cent & " " & x_cent End If
			t_cent = t_cent & " cent"
			If Trim(x_cent) <> "un" Then
				'Pas de 's' s'il y a un nombre derrière la centaine
				If n1_cent = 0 Then
					'Pas de 's' s'il y a le mot 'mille' derrière la centaine
					If Not mille_cent Then t_cent = t_cent & "s" End If
				End If
			End If
		End If
		
		'Dizaine
		
		n2_cent = n1_cent
		
		Select Case n2_cent
		
			Case 0,1,2,3,4,5,6,7,8,9
				x_cent = NversL_chiffre(n2_cent)
			Case 10
				x_cent = "dix"
			Case 11
				x_cent = "onze"
			Case 12
				x_cent = "douze"
			Case 13
				x_cent = "treize"
			Case 14
				x_cent = "quatorze"
			Case 15
				x_cent = "quinze"
			Case 16
				x_cent = "seize"
			Case 17
				x_cent = "dix-sept"
			Case 18
				x_cent = "dix-huit"
			Case 19
				x_cent = "dix-neuf"
			Case 20
				x_cent = "vingt"
			Case 21
				x_cent = "vingt et un"
			Case 22,23,24,25,26,27,28,29
				x_cent = "vingt-" & NversL_chiffre(n2_cent - Int(n2_cent / 10) * 10)
			Case 30
				x_cent = "trente"
			Case 31
				x_cent = "trente et un"
			Case 32,33,34,35,36,37,38,39
				x_cent = "trente-" & NversL_chiffre(n2_cent - Int(n2_cent / 10) * 10)
			Case 40
				x_cent = "quarante"
			Case 41
				x_cent = "quarante et un"
			Case 42,43,44,45,46,47,48,49
				x_cent = "quarante-" & NversL_chiffre(n2_cent - Int(n2_cent / 10) * 10)
			Case 50
				x_cent = "cinquante"
			Case 51
				x_cent = "cinquante et un"
			Case 52,53,54,55,56,57,58,59
				x_cent = "cinquante-" & NversL_chiffre(n2_cent - Int(n2_cent / 10) * 10)
			Case 60
				x_cent = "soixante"
			Case 61
				x_cent = "soixante et un"
			Case 62,63,64,65,66,67,68,69
				x_cent = "soixante-" & NversL_chiffre(n2_cent - Int(n2_cent / 10) * 10)
			Case 70
				x_cent = "soixante-dix"
			Case 71
				x_cent = "soixante et onze"
			Case 72,73,74,75,76,77,78,79
				x_cent = "soixante-" & Trim(NversL_cent(n2_cent - 60, False))
			Case 80
				x_cent = "quatre-vingts"
			Case 81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99
				x_cent = "quatre-vingt-" & Trim(NversL_cent(n2_cent - 80, False))
		
		End Select
		
		n1_cent = n1_cent - n2_cent
		
		'Pour éviter 'cent zéro'
		If Len(t_cent) = 0 Or Trim(x_cent) <> "zéro" Then t_cent = t_cent & " " & x_cent End If
		
		NversL_cent = t_cent
		
	End Function

	Private Function NversL_chiffre(n_chiffre )
	
		Dim n1_chiffre 
		Dim t_chiffre 
		n1_chiffre = n_chiffre
		
		Select Case n1_chiffre
			Case 0
				t_chiffre = "zéro"
			Case 1
				t_chiffre = "un"
			Case 2
				t_chiffre = "deux"
			Case 3
				t_chiffre = "trois"
			Case 4
				t_chiffre = "quatre"
			Case 5
				t_chiffre = "cinq"
			Case 6
				t_chiffre = "six"
			Case 7
				t_chiffre = "sept"
			Case 8
				t_chiffre = "huit"
			Case 9
				t_chiffre = "neuf"
		End Select
		
		NversL_chiffre = t_chiffre
		
	End Function 

'#################################################################
'###################### PAGINATION	 #############################
'#################################################################
	'---- Définition du Nombre d'Eléments par Page
	Dim Page, 		Pm_Page
	Dim PageSize, 	Pm_PageSize
		PageSize = 20
							
	Dim Zone,   rZone
	Dim Search, rSearch, Pm_Search
		Search = ""
		
	Dim Frm,	 	wFrm
		Frm	= "" : 	wFrm = "" 
		
'#################################################################
'###################### DATE HEURE	 #############################
'#################################################################
'	Forcer la format de Date en Français
	Session.LCID = &H040c

	Const CustomFontColorMenu			= "A0D3F9"
	Const CustomFondMenu	 			= "395169"
	Const CustomBackgroundColor			= "001E3C"
	Const CustomFontColor	 			= "7390C0"
	Const CustomLinkFontColor			= "BAB7FF"
	Const CustomBgColorSite				= "395169"
	Const CustomBorderTreeColor			= "A0D3F9"
	Const CustomBgColorSiteMenu 		= "A0D3F9"
	Const CustomBgColorTitle			= "A0D3F9"
	Const CustomFondBgcolor				= "849ABD"
	Const CustomTextBoxColor  			= "7390C0"
	Const CustomTextBoxSolid  			= "7390C0"
	Const CustomTextBoxBackground		= "001E3C"
	Const CustomSelectBoxColor   		= "7390C0"
	Const CustomSelectBackground		= "7390C0"

'************************************
'FIND THE PATH / RETROUVE LE CHEMIN 
'************************************
Public Function Path_Translated(ByVal ThisPath)
	i = 0 
	Str = ""
	NewPath = Split(ThisPath,"\")
	For i = 0 To Ubound(NewPath) -1
		Str = Str & NewPath(i)&"\"
	Next
	Path_Translated = Str
End Function

'***********************************
'CATCH ERROR / PREVIENT LES ERREUR
'***********************************
Function Check_Erreur (obj_Connection)
	Dim obj_Error
	If Err.Number <> obj_Connection.Errors(0).Number Then
		Exit Function
	End If
	If obj_Connection.Errors.Count > 0 Then
		For Each obj_Error in obj_Connection.Errors
			If obj_Error.Number <> 0 Then
				Response.Write "" & _
"<table border=0 align=""center"" cellpadding=0 cellspacing=0 size=""300"">" & _
	"<tr><th align=right><font face=Verdana size=2>Numéro : </th><td align=left><font face=Verdana size=2>&nbsp;&nbsp;" & obj_Error.Number & "</font></td></tr>" & _
	"<tr><th align=right><font face=Verdana size=2>Erreur Native : </th><td align=left><font face=Verdana size=2>&nbsp;&nbsp;" & obj_Error.NativeError & "</font></td></tr>" & _
	"<tr><th align=right><font face=Verdana size=2>Etat SQL : </th><td align=left><font face=Verdana size=2>&nbsp;&nbsp;" & obj_Error.SQLState & "</font></td></tr>" & _
	"<tr><th align=right><font face=Verdana size=2>Source : </th><td align=left><font face=Verdana size=2>&nbsp;&nbsp;" & obj_Error.Source & "</font></td></tr>" & _
	"<tr><th align=right><font face=Verdana size=2>Description : </th><td align=left><font face=Verdana size=2>&nbsp;&nbsp;" & obj_Error.Description & "</font></td></tr>" & _
"</table>"
				Check_Erreur = True
			End If
		Next
	Else
		Check_Erreur = False
	End If
End Function


'#################################################################
'#####################  Historisation  ###########################
'#################################################################

	Dim adJ, adM, adA
    	adJ = Left(Now(), 2) : adM = Mid(Now(), 4, 2) : adA = Mid(Now(), 7, 4)
	Function Log(DocId, DocType, Historique)
	
		Dim Dossier
		Dim Fichier 
		
		Dim Url 		: Url 			= Request.ServerVariables("Url")
		Dim RemoteHost	: RemoteHost 	= Request.ServerVariables("Remote_Host")
		Dim RemoteAddr	: RemoteAddr 	= Request.ServerVariables("Remote_Addr")
		Dim HttpReferer	: HttpReferer 	= Request.ServerVariables("Http_Referer")
		
		Dim UserId		: UserId 		= Session("Code")
		Dim UserName	: UserName 		= Session("Nom")
		
		If UserName = "" Then UserName = "Exception"
		
		Dim Jour, Mois, Annee
	    	Jour = Left(Date(), 2) : Mois = Mid(Date(), 4, 2) : Annee = Right(Date(), 4)
			
		Dim Log_Folder 	: Log_Folder 	= "[log]"
		
		Dim File_Name 	: File_Name  	= LCase(Annee & Mois & Jour) & ".log"
		
		Dim Folder_Name	: Folder_Name 	= LCase(UserName)
			
		Dim Folder 
			Folder = Server.MapPath("/sivat/" & Log_Folder & "/" & Folder_Name & "/")
		  	
		Dim Chemin
	    	Chemin = Server.MapPath("/sivat/" & Log_Folder & "/" & Folder_Name & "/" & File_Name)
		
	    Dim Fso
		Set Fso = CreateObject("Scripting.FileSystemObject")
	
	    'If Fso.FolderExists(Folder) = True Then
	    '    Response.Write "Le Dossier est présent<br>" 
	    'Else 
	    '    Response.Write "Le Dossier n'est pas présent<br>" 
		'	Set Dossier = Fso.CreateFolder(Folder)
	    'End If	
		
	    If Fso.FolderExists(Folder) = False Then
			Set Dossier = Fso.CreateFolder(Folder)
	    End If	
		
		Dim Entete 		: Entete = ""
		Dim Operation 	: Operation = ""
			
	    If Fso.FileExists(Chemin) = True Then
			Set Fichier = Fso.OpenTextFile(Chemin, 8)
	    Else 
		    Set Fichier = Fso.CreateTextFile(Chemin, True)
				Entete  = Entete & "Date" & VbTab & "Heure" & VbTab & "Certificat" & VbTab & "Url" & VbTab & "NomClient" & VbTab & "IpClient" & VbTab & "HttpReferer" & VbTab & _
							  	   "UserId" & VbTab & "UserName" & VbTab & "Doc_Id" & VbTab & "Doc_Type" & VbTab & "Historique" & vbCrLf 
	    End If
		
			Operation   = Entete & Date() & VbTab & Time() & VbTab & Session("Certificat") & VbTab & Url & VbTab & RemoteHost & VbTab & RemoteAddr & VbTab & HttpReferer & VbTab & _
							 UserId & VbTab & UserName & VbTab & DocId & VbTab & DocType & VbTab & Historique & vbCrLf
		
	    Fichier.Write Operation  
	    Fichier.Close
		
	    Set Fichier = Nothing 
	    Set Dossier = Nothing 
	    Set Fso 	= Nothing 
	    
		Call Histo(DocId, DocType, Historique)
		 
	End Function
	 
	Function Histo(DocId, DocType, Historique)
	
		Dim Dossier
		Dim Fichier 
		
		Dim Url 		: Url 			= Request.ServerVariables("Url")
		Dim RemoteHost	: RemoteHost 	= Request.ServerVariables("Remote_Host")
		Dim RemoteAddr	: RemoteAddr 	= Request.ServerVariables("Remote_Addr")
		Dim HttpReferer	: HttpReferer 	= Request.ServerVariables("Http_Referer")
		
		Dim UserId		: UserId 		= Session("Code")
		Dim UserName	: UserName 		= Session("Nom")
		
		If UserName = "" Then UserName = "Exception"
		
		Dim Log_Folder 	: Log_Folder 	= "[log]"
		Dim File_Name 	: File_Name  	= "Global.log"
		
		Dim Jour, Mois, Annee
	    	Jour = Left(Date(), 2) : Mois = Mid(Date(), 4, 2) : Annee = Right(Date(), 4)
			
		'Dim Folder_Name	: Folder_Name = Annee & Mois & Jour
		Dim Folder_Name	: Folder_Name = "[Global]"
			
		Dim Folder 
			Folder = Server.MapPath("/sivat/" & Log_Folder & "/" & Folder_Name & "/")
		  	
		Dim Chemin
	    	Chemin = Server.MapPath("/sivat/" & Log_Folder & "/" & Folder_Name & "/" & File_Name)
		
	    Dim Fso
		Set Fso = CreateObject("Scripting.FileSystemObject")
	
	    'If Fso.FolderExists(Folder) = True Then
	    '    Response.Write "Le Dossier est présent<br>" 
	    'Else 
	    '    Response.Write "Le Dossier n'est pas présent<br>" 
		'	Set Dossier = Fso.CreateFolder(Folder)
	    'End If	
		
	    If Fso.FolderExists(Folder) = False Then
			Set Dossier = Fso.CreateFolder(Folder)
	    End If	
		
		Dim Entete 		: Entete 	= ""
		Dim Operation 	: Operation = ""
			
	    If Fso.FileExists(Chemin) = True Then
			Set Fichier = Fso.OpenTextFile(Chemin, 8)
	    Else 
		    Set Fichier = Fso.CreateTextFile(Chemin, True)
				Entete  = Entete & "Date" & VbTab & "Heure" & VbTab & "Certificat" & VbTab & "Url" & VbTab & "NomClient" & VbTab & "IpClient" & VbTab & "HttpReferer" & VbTab & _
							  	   "UserId" & VbTab & "UserName" & VbTab & "Doc_Id" & VbTab & "Doc_Type" & VbTab & "Historique" & vbCrLf 
	    End If
		
			Operation   = Entete & Date() & VbTab & Time() & VbTab & Session("Certificat") & VbTab & Url & VbTab & RemoteHost & VbTab & RemoteAddr & VbTab & HttpReferer & VbTab & _
							 UserId & VbTab & UserName & VbTab & DocId & VbTab & DocType & VbTab & Historique & vbCrLf
		
	    Fichier.Write Operation  
	    Fichier.Close
		
	    Set Fichier = Nothing 
	    Set Dossier = Nothing 
	    Set Fso 	= Nothing 
	     
	End Function 
'#################################################################
'#####################  Fin Fonction  ############################
'#################################################################

'#################################################################
'##  Vérification des Accès Utilisateurs aux Pages du SIGEC 4  ###
'#################################################################
	Function Acces_Page()
		Dim Domaine
		Dim Referer, Pager, Page_Name
			Referer	  = Trim(Request.ServerVariables("Script_Name"))
			Page_Name = Right(Referer, Int(Len(Referer) - InStrRev(Referer, "/")))  
			'Page_Name = Right(Referer, (InStr(StrReverse(Referer), "/") - 1))
			
		If Referer = "" Then
		   Acces_Page = False
		Else
			If InStr(Session("Acces"), "," & Page_Name) <> 0 Then Acces_Page = True Else Acces_Page = False End If
		End If
		
		If Session("Sigec") = True Then 
			Acces_Page = True 
		Else
			Domaine = Split(Request.ServerVariables("Url") & "/", "/")
			If Session("Domaine") <> Domaine(1) And InStr("sce_local,sce_mail,[export],all_user,all_print,download,pmex_expert,sce_achat", Domaine(1)) = 0 Then 
				Acces_Page = False	
			End If
		End If
	End Function
'#################################################################
'#####################  Fin Fonction  ############################
'#################################################################

%>




