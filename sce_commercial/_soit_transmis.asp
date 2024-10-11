	<!--#include file="../include/inc_con.asp" -->
	<!--#include file="../include/fonction.asp" -->
	<!--#include file="../include/encryption.asp" -->
	<!--#include file="../include/JSON_2.0.4.asp"-->
<%		
	If Session("Login") = False Or IsNull(Session("Login")) = True Then Response.Redirect "../_expire.asp" End If		
								
	'### - Declaration des Variables
			Dim Code, Agree, Trans
			Dim Edit, Err_Msg, Frm_Up
			Dim Cmd_Db
			Dim Pm_Out, Pm_Code, Pm_Fo1, Pm_Prdt, Pm_Id, Pm_Type
			Dim Pm_DtST, Pm_RefST, Pm_ListFact, Pm_TypeST, Pm_Option 
			Dim DtST, RefST, ListFact, TypeST
			Dim rs_Fo1, Count
			Dim Img, Fo1, Fo1_Option, Url
			Dim Nb, Cool
			Dim TContrat, Choix, Link

			Dim jsa, col, QueryToJSON
			
			Dim tabFact, tabFo1, tabsTransmis, TypeContrat, nFact
			Dim Pm_Camp, Pm_Reclt, Pm_Parite, Pm_LFrm, Pm_NumFact, Pm_DtFact, Pm_MtFact, Pm_VolFact, Pm_Banq, Pm_Form, Pm_TxRS, Pm_Poids, Pm_MtS, Pm_Str

	'### - Récupération des Variables Session Utilisateur
				Code  = Session("Code")

	'### - Récupération des Options de Validation
				Frm_Up = Request("Frm_Up")
	
'####################################
	If Frm_Up = "Yes" Then  ' ###  => Choix Effectué - Création du Soit Transmis
'####################################

	'### - Récupération des Valeurs des Factures
			ListFact = Request("Id")
            
	'### - Déclaration des Variables
			Dim Erreur
				Erreur = 0
				 
	'### - Controle du Formulaire
					
			If ListFact = ""  Then
				Err_Msg = Err_Msg & "Une Erreur (0) inatendue s'est produite."
				Err_Msg = Err_Msg & "Veuiller vérifier les informations saisies !"
				Err_Msg = Err_Msg & "Si l'Erreur persiste, veuillez contacter l'Administrateur !"
				Erreur = 1
			End If

			If Erreur = 0 Then

				'### - Création de la Commande à Exécuter
					Set Cmd_Db = Server.CreateObject("AdoDB.Command")
						Cmd_Db.ActiveConnection = ado_Con
						Cmd_Db.CommandText = "Ps_Doc_FS_STransmis"
						Cmd_Db.CommandType = adCmdStoredProc
			
				'### - Définition des Paramètres de la Procédure Stockée SQL
					Set Pm_Out		= Cmd_Db.CreateParameter("@Output", adInteger, adParamOutput)				: Cmd_Db.Parameters.Append Pm_Out
					Set Pm_Code		= Cmd_Db.CreateParameter("@Code", adVarChar, adParamInput, 3, Code)			: Cmd_Db.Parameters.Append Pm_Code
					Set Pm_Option	= Cmd_Db.CreateParameter("@Option", adVarChar, adParamInput, 15, "Valide")	: Cmd_Db.Parameters.Append Pm_Option
					Set Pm_Fo1		= Cmd_Db.CreateParameter("@Id", adInteger, adParamInput, , 0) 				: Cmd_Db.Parameters.Append Pm_Fo1

					Set Pm_ListFact	= Cmd_Db.CreateParameter("@ListeFact", adVarChar, adParamInput, 800, ListFact)	: Cmd_Db.Parameters.Append Pm_ListFact
					'Set Pm_TypeST	= Cmd_Db.CreateParameter("@TypeST", adVarChar, adParamInput, 10, "")		: Cmd_Db.Parameters.Append Pm_TypeST
					'Set Pm_DtST		= Cmd_Db.CreateParameter("@DateST", adVarChar, adParamInput, 10, "")			: Cmd_Db.Parameters.Append Pm_DtST
					'Set Pm_RefST	= Cmd_Db.CreateParameter("@RefST", adVarChar, adParamInput, 50, "")				: Cmd_Db.Parameters.Append Pm_RefST	
					
					'Set Pm_Search	= Cmd_Db.CreateParameter("@Search", adVarChar, adParamInput, 8000, Null)		: Cmd_Db.Parameters.Append Pm_Search	
							
				'### - Exécution de la Commande SQL
					Cmd_Db.Execute
											
					Dim Retour				'### - Vérification du Paramétre de Retour et Affichage du Message de Confirmation
					Set Retour = Pm_Out
					
					Erreur = 1
							
					If Retour > 0 Then	 	'### - Aucune Erreur
						Err_Msg = Err_Msg & "Traitement du Soit Transmis créé !"						
					Else		   	'### - Erreur Rencontrée
						Err_Msg = Err_Msg & "Une Erreur (" & Retour & ") inatendue s'est produite."
						Err_Msg = Err_Msg & "Veuiller vérifier les informations saisies !"
						Err_Msg = Err_Msg & "Si l'Erreur persiste, veuillez contacter l'Administrateur !"
					End If
							
			End If
				
	'### - Fermeture des Objets de Connexion
				Set Cmd_Db  = Nothing

				Set jsa = jsArray()
                Set jsa(Null) = jsObject()
                jsa(Null)("Erreur") = Erreur
                jsa(Null)("Err_Msg") = Err_Msg
                Set QueryToJSON = jsa
                
                Response.Charset = "utf-8"
                QueryToJSON.Flush

'######################################
	End If 						  ' ###  => Fin Validation 
'######################################
		
'######################################
	If Frm_Up = "Edit" Then	  		  ' ###  => Choix Effectué - Affichage des Factures à traiter 
'######################################

	'#####################################################
	'#####  Récupération des Formules - Non Editées  #####  
	'#####################################################

		'### - Création de la Commande à Exécuter
					Set Cmd_Db = Server.CreateObject("AdoDB.Command")
						Cmd_Db.ActiveConnection = ado_Con
						Cmd_Db.CommandText = "Ps_Doc_STransmisFactSoutien"
						Cmd_Db.CommandType = adCmdStoredProc

                    Search = ""
		'### - Définition des Paramètres de la Procédure Stockée SQL
					Set Pm_Out		= Cmd_Db.CreateParameter("@Output", adInteger, adParamOutput)				: Cmd_Db.Parameters.Append Pm_Out
					Set Pm_Code		= Cmd_Db.CreateParameter("@Code", adVarChar, adParamInput, 3, Code)			: Cmd_Db.Parameters.Append Pm_Code
					Set Pm_Option	= Cmd_Db.CreateParameter("@Option", adVarChar, adParamInput, 15, "ListAccord")		: Cmd_Db.Parameters.Append Pm_Option
					Set Pm_Fo1		= Cmd_Db.CreateParameter("@Id", adInteger, adParamInput, , 0) 				: Cmd_Db.Parameters.Append Pm_Fo1

                    Set Pm_ListFact	= Cmd_Db.CreateParameter("@ListeFact", adVarChar, adParamInput, 800, "")		: Cmd_Db.Parameters.Append Pm_ListFact
                    Set Pm_TypeST	= Cmd_Db.CreateParameter("@TypeST", adVarChar, adParamInput, 10, "")		: Cmd_Db.Parameters.Append Pm_TypeST
                    Set Pm_DtST		= Cmd_Db.CreateParameter("@DateST", adVarChar, adParamInput, 10, "")		: Cmd_Db.Parameters.Append Pm_DtST
                    Set Pm_RefST	= Cmd_Db.CreateParameter("@RefST", adVarChar, adParamInput, 50, "")		: Cmd_Db.Parameters.Append Pm_RefST

		'### - Exécution de la Commande SQL
					Set rs_Fo1 = Cmd_Db.Execute
				
		'### - Affichage des Résultats de la Procédure SQL

					Count = 0
					Fo1   = ""
							
					Dim Records, Paging, aUrl, bUrl, w, x

					While Not rs_Fo1.Eof
					
						Count = Count + 1
					
						Records	= rs_Fo1("Record_Count")		
						Paging 	= Int(Count + Int(PageSize * Int(Page - 1)))
		
						Fo1_Option = "?Edit=0&Fo1=" & rs_Fo1("FACTSOUT_ID") & rSearch
						Fo1_Option = "?sigec=" & Server.UrlEncode(Encrypt(Fo1_Option))
			
						Url = "Afficher('Voir_fo1', '../all_print/affiche_fo1.asp" & Fo1_Option & "', 100, 100, 500, 500, 0, 0, 0, 1, 1);"																
						
						'bUrl = "?Print=Yes&Cdc=" & rs_Fo1("Cdc_ID") & rSearch
						'bUrl = "?sigec=" & Server.UrlEncode(Encrypt(bUrl))
						'bUrl = "Afficher('Voir_cdc', '../all_print/affiche_cdc.asp" & bUrl & "', 100, 100, 500, 500, 0, 0, 0, 1, 1);"												
								
						Fo1 = Fo1 & "<tr id=""" & Count & "_h0"">" & vbNewLine & _
									"	<td height=""25"" valign=""middle"" align=""center"" " & Cool & ">" & Paging & "</td>" & vbNewLine &_
                                    "	<td height=""25"" valign=""middle"" align=""center"">" & rs_Fo1("REF_FACTSOUT") & "</td>" & vbNewLine &_
									"	<td height=""25"" valign=""middle"" align=""center"">" & FormatDateTime(rs_Fo1("DATE_FACTSOUT"), 2) & "</td>" & vbNewLine &_
									"	<td height=""25"" valign=""middle"" align=""center"">" & rs_Fo1("NUM_FACTSOUT") & "</td>" & vbNewLine &_
									"	<td height=""25"" valign=""middle"" align=""center"">" & Prix(rs_Fo1("VOL_FACTSOUT")) & "</td>" & vbNewLine &_
									"	<td height=""25"" valign=""middle"" align=""center"">" & Prix(rs_Fo1("MONT_FACTSOUT")) & "</td>" & vbNewLine &_									
                                    "	<td height=""25"" valign=""middle"" align=""center"">" & rs_Fo1("NOM") & "</td>" & vbNewLine &_                                    
									"	<td height=""25"" valign=""middle"" align=""center""><input type=""checkbox"" name=""Fo1"" value=""" & rs_Fo1("FACTSOUT_ID") & """ /></td>" & vbNewLine &_
									"</tr>" '& vbNewLine					
				
						rs_Fo1.MoveNext
						
					Wend


		'### - Fermeture des Objets de Connexion
					rs_Fo1.Close
					
					Set rs_Fo1  = Nothing
					Set Cmd_Db = Nothing							

        Link = "?Edit=0" 
		Link = "?sigec=" & Server.UrlEncode(Encrypt(Link))

'######################################
	ElseIf Frm_Up = "0" Then  ' ###  => Choix Effectué - Saisie des infos complémentaires
'######################################			

	'### - Récupération des Valeurs de la Formule Sélectionnée
                Fo1 = request("Fo1")

    '#####################################################
	'#####  Récupération des Factures - Non traitée  #####  
	'#####################################################

		'### - Création de la Commande à Exécuter
					Set Cmd_Db = Server.CreateObject("AdoDB.Command")
						Cmd_Db.ActiveConnection = ado_Con
						Cmd_Db.CommandText = "Ps_Doc_STransmisFactSoutien"
						Cmd_Db.CommandType = adCmdStoredProc
	
		'### - Définition des Paramètres de la Procédure Stockée SQL
				Set Pm_Out		= Cmd_Db.CreateParameter("@Output", adInteger, adParamOutput)				: Cmd_Db.Parameters.Append Pm_Out
				Set Pm_Code		= Cmd_Db.CreateParameter("@Code", adVarChar, adParamInput, 3, Code)			: Cmd_Db.Parameters.Append Pm_Code
				Set Pm_Option	= Cmd_Db.CreateParameter("@Option", adVarChar, adParamInput, 15, "Saisie")		: Cmd_Db.Parameters.Append Pm_Option
				Set Pm_Fo1		= Cmd_Db.CreateParameter("@Id", adInteger, adParamInput, , 0) 				: Cmd_Db.Parameters.Append Pm_Fo1

                Set Pm_ListFact	= Cmd_Db.CreateParameter("@ListeFact", adVarChar, adParamInput, 800, Fo1)		: Cmd_Db.Parameters.Append Pm_ListFact
                Set Pm_TypeST	= Cmd_Db.CreateParameter("@TypeST", adVarChar, adParamInput, 10, "")		: Cmd_Db.Parameters.Append Pm_TypeST
                Set Pm_DtST		= Cmd_Db.CreateParameter("@DateST", adVarChar, adParamInput, 10, "")		: Cmd_Db.Parameters.Append Pm_DtST
                Set Pm_RefST	= Cmd_Db.CreateParameter("@RefST", adVarChar, adParamInput, 50, "")		: Cmd_Db.Parameters.Append Pm_RefST			
		
		'### - Exécution de la Commande SQL
					Set rs_Fo1 = Cmd_Db.Execute
				
		'### - Affichage des Résultats de la Procédure SQL												
            
            Fo1 = ""
					
			While Not rs_Fo1.Eof						

				Fo1 = Fo1 & "<tr>" & vbNewLine & _							
                            "	<td>" & rs_Fo1("REF_FACTSOUT") & "</td>" & vbNewLine &_
							"	<td>" & FormatDateTime(rs_Fo1("DATE_FACTSOUT"), 2) & "</td>" & vbNewLine &_
							"	<td>" & rs_Fo1("NUM_FACTSOUT") & "</td>" & vbNewLine &_
							"	<td>" & Prix(rs_Fo1("VOL_FACTSOUT")) & "</td>" & vbNewLine &_
							"	<td>" & Prix(rs_Fo1("MONT_FACTSOUT")) & "</td>" & vbNewLine &_									
                            "	<td>" & rs_Fo1("NOM") & "</td>" & vbNewLine &_                                    							
							"</tr>"
							TypeSt = rs_Fo1("ETAT_VALIDE")
				rs_Fo1.MoveNext											
							
			Wend			


		'### - Fermeture des Objets de Connexion
					'rs_Fo1.Close
					
					Set rs_Fo1  = Nothing
					Set Cmd_Db = Nothing		
		
'################
	End If	' ###  => Fin Option
'################			

%>















