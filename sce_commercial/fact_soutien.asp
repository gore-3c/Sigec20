	<!--#include file="../include/inc_con.asp" -->
	<!--#include file="../include/fonction.asp" -->
	<!--#include file="../include/encryption.asp" -->
	<!--include file="../include/inc_var.asp" -->
	
<%		
		If Session("Login") = False Or IsNull(Session("Login")) = True Then Response.Redirect "../expire.asp" End If		

		'If Not Acces_Page   = True Then Response.Redirect "../refuse.asp" & "?sigec=" & Server.UrlEncode(encrypt("?Motif=Menu_Refuse")) End If'
								
	'### - Declaration des Variables
				Dim Code, Agree, Trans
				Dim Edit, Err_Msg, Up_Edit
				Dim Cmd_Db
				Dim Pm_Out, Pm_Code, Pm_Type, Pm_Fo1, Pm_Prdt, Pm_Id
				Dim rs_Fo1, Count
				Dim Img, Fo1, Fo1_Option, Url
				Dim Nb, Cool
                Dim TContrat, Choix, rMotif, idMotif
				
                Dim tabFact, tabFo1, tabsTransmis, TypeContrat, nFact, tabMotif
                Dim Pm_Camp, Pm_Reclt, Pm_Parite, Pm_LFrm, Pm_NumFact, Pm_DtFact, Pm_MtFact, Pm_VolFact, Pm_Banq, Pm_Form, Pm_TxRS, Pm_Poids, Pm_MtS, Pm_Str, Pm_StrId

	'### - R�cup�ration des Variables Session Utilisateur
				Code  = Session("Code")

	'### - Pagination des R�sultats renvoy�s par la Proc�dure Stock�e SQL
				Dim Nom_Page
					Nom_Page = "fact_soutien.asp"

				If (Len(Sigec("Page")) = 0) Or (IsNumeric(Sigec("Page")) = False) Then
					Page = 1
				Else
					Page = CInt(Sigec("Page"))
				End If

	'### - R�cup�ration des Crit�res de Recherche 
					Dim Frm_Search
						Frm_Search = "Soutien" 
			%>
					<!--include file="../all_user/soutien_sql.asp" -->
			<%

	'### - R�cup�ration des Options de Validation
				Edit 	= Sigec("Edit")
				Up_Edit = Sigec("Up_Edit")
	
'####################################
	If Up_Edit = "Yes" Then  ' ###  => Choix Effectu� - Validation de l'Edition de la Formule dans la Base de Donn�es
'####################################

	'### - R�cup�ration des Valeurs de la Formule S�lectionn�e
				 Fo1 = Int(Sigec("Fo1"))
                TContrat = Request("TypeContrat")
                Choix = Request("Choix")
                                
                rMotif = Null
                If Choix = "Rejet" Then 
                    rMotif = Request("rMotif")
                    idMotif = Request("idMotif")
                End If
                
	'### - D�claration des Variables
				Dim Erreur
					Erreur = 0
								 
	'### - Controle du Formulaire
					
				If Fo1 = ""  Then
					Err_Msg = Err_Msg & "Une Erreur (0) inatendue s'est produite."
					Err_Msg = Err_Msg & "Veuiller v�rifier les informations saisies !"
					Err_Msg = Err_Msg & "Si l'Erreur persiste, veuillez contacter l'Administrateur !"
					Erreur = 1
				End If
					
				If Session(Nom_Page) <> "" Then 
					Edit = ""
				Else
					If Erreur = 0 Then
	
						'### - Cr�ation de la Commande � Ex�cuter
							Set Cmd_Db = Server.CreateObject("AdoDB.Command")
								Cmd_Db.ActiveConnection = ado_Con
								Cmd_Db.CommandText = "Ps_Doc_FactSoutien"
								Cmd_Db.CommandType = adCmdStoredProc
					
						'### - D�finition des Param�tres de la Proc�dure Stock�e SQL
							Set Pm_Out		= Cmd_Db.CreateParameter("@Output", adInteger, adParamOutput)				: Cmd_Db.Parameters.Append Pm_Out
							Set Pm_Code		= Cmd_Db.CreateParameter("@Code", adVarChar, adParamInput, 3, Code)			: Cmd_Db.Parameters.Append Pm_Code
							Set Pm_Type		= Cmd_Db.CreateParameter("@Option", adVarChar, adParamInput, 25, "Valide")	: Cmd_Db.Parameters.Append Pm_Type
							Set Pm_Id		= Cmd_Db.CreateParameter("@Id", adInteger, adParamInput, , Fo1) 			: Cmd_Db.Parameters.Append Pm_Id
                            Set Pm_Search	= Cmd_Db.CreateParameter("@Search", adVarChar, adParamInput, 1000, "")	    : Cmd_Db.Parameters.Append Pm_Search

                            Set Pm_Prdt		= Cmd_Db.CreateParameter("@Prdt", adInteger, adParamInput, , 0) 			: Cmd_Db.Parameters.Append Pm_Prdt
                            Set Pm_Reclt	= Cmd_Db.CreateParameter("@Reclt", adInteger, adParamInput, , 0) 			: Cmd_Db.Parameters.Append Pm_Reclt
                            Set Pm_Camp		= Cmd_Db.CreateParameter("@Camp", adInteger, adParamInput, , 0) 			: Cmd_Db.Parameters.Append Pm_Camp
                            Set Pm_Parite	= Cmd_Db.CreateParameter("@Parite", adInteger, adParamInput, , 0) 			: Cmd_Db.Parameters.Append Pm_Parite
                                    
                            Set Pm_LFrm		= Cmd_Db.CreateParameter("@ListForm", adVarChar, adParamInput, 25, "")	: Cmd_Db.Parameters.Append Pm_LFrm
                            Set Pm_NumFact	= Cmd_Db.CreateParameter("@NumFact", adVarChar, adParamInput, 25, "")	: Cmd_Db.Parameters.Append Pm_NumFact
                            Set Pm_DtFact	= Cmd_Db.CreateParameter("@DateFact", adVarChar, adParamInput, 25, "")	: Cmd_Db.Parameters.Append Pm_DtFact
                                    
                            Set Pm_MtFact	= Cmd_Db.CreateParameter("@MontFact", adInteger, adParamInput, , 0) 	: Cmd_Db.Parameters.Append Pm_MtFact
                            Set Pm_VolFact	= Cmd_Db.CreateParameter("@VolFact", adInteger, adParamInput, , 0) 		: Cmd_Db.Parameters.Append Pm_VolFact
                            Set Pm_Banq	    = Cmd_Db.CreateParameter("@Banq", adInteger, adParamInput, , 0) 		: Cmd_Db.Parameters.Append Pm_Banq

                            Set Pm_Form		= Cmd_Db.CreateParameter("@Str_Form", adVarChar, adParamInput, 8000, "")	: Cmd_Db.Parameters.Append Pm_Form
                            Set Pm_TxRS		= Cmd_Db.CreateParameter("@Str_TauxRS", adVarChar, adParamInput, 8000, "")	: Cmd_Db.Parameters.Append Pm_TxRS
                            Set Pm_Poids	= Cmd_Db.CreateParameter("@Str_PoidsR", adVarChar, adParamInput, 8000, "")	: Cmd_Db.Parameters.Append Pm_Poids
                            Set Pm_MtS	    = Cmd_Db.CreateParameter("@Str_MTSout", adVarChar, adParamInput, 8000, "")	: Cmd_Db.Parameters.Append Pm_MtS
                            Set Pm_Str		= Cmd_Db.CreateParameter("@Str", adVarChar, adParamInput, 4, "")	        : Cmd_Db.Parameters.Append Pm_Str

                            Set Pm_Poids	= Cmd_Db.CreateParameter("@TContrat", adVarChar, adParamInput, 25, TContrat): Cmd_Db.Parameters.Append Pm_Poids
                            Set Pm_MtS	    = Cmd_Db.CreateParameter("@Etat", adVarChar, adParamInput, 6, Choix)	    : Cmd_Db.Parameters.Append Pm_MtS
                            Set Pm_Str		= Cmd_Db.CreateParameter("@Rejet", adVarChar, adParamInput, 300, rMotif)	: Cmd_Db.Parameters.Append Pm_Str
                            Set Pm_Page		= Cmd_Db.CreateParameter("@Page", adInteger, adParamInput, , 0)	: Cmd_Db.Parameters.Append Pm_Page
                            Set Pm_PageSize		= Cmd_Db.CreateParameter("@PageSize", adInteger, adParamInput, , 0)	: Cmd_Db.Parameters.Append Pm_PageSize
                            Set Pm_StrId		= Cmd_Db.CreateParameter("@Str_Rejet", adVarChar, adParamInput, 8000, idMotif)	: Cmd_Db.Parameters.Append Pm_StrId
																	
						'### - Ex�cution de la Commande SQL
							Cmd_Db.Execute
													
							Dim Retour				'### - V�rification du Param�tre de Retour et Affichage du Message de Confirmation
							Set Retour = Pm_Out
									
							Erreur = 1
									
							If Retour > 0 Then	 	'### - Aucune Erreur
								Err_Msg = Err_Msg & "Edition de la Formule Valid�e !"
								Session(Nom_Page) 	= Retour					
								Edit	= ""
										
								Log Fo1, "Fo1", "Edition - Formule" 					

							Else		   	'### - Erreur Rencontr�e
								Err_Msg = Err_Msg & "Une Erreur (" & Retour & ") inatendue s'est produite."
								Err_Msg = Err_Msg & "Veuiller v�rifier les informations saisies !"
								Err_Msg = Err_Msg & "Si l'Erreur persiste, veuillez contacter l'Administrateur !"
								Edit	= "0"
							End If
									
					End If
				End If
						

				
	'### - Fermeture des Objets de Connexion
				Set Cmd_Db  = Nothing

'######################################
	End If 						  ' ###  => Fin Validation 
'######################################
		
'######################################
	If Edit = "" Then	  		  ' ###  => Choix Effectu� - Affichage des Factures � traiter 
'######################################

	'#####################################################
	'#####  R�cup�ration des Formules - Non Edit�es  #####  
	'#####################################################

		'### - Cr�ation de la Commande � Ex�cuter
					Set Cmd_Db = Server.CreateObject("AdoDB.Command")
						Cmd_Db.ActiveConnection = ado_Con
						Cmd_Db.CommandText = "Ps_Doc_FactSoutien"
						Cmd_Db.CommandType = adCmdStoredProc
	
		'### - D�finition des Param�tres de la Proc�dure Stock�e SQL
					Set Pm_Out		= Cmd_Db.CreateParameter("@Output", adInteger, adParamOutput)				: Cmd_Db.Parameters.Append Pm_Out
					Set Pm_Code		= Cmd_Db.CreateParameter("@Code", adVarChar, adParamInput, 3, Code)			: Cmd_Db.Parameters.Append Pm_Code
					Set Pm_Type		= Cmd_Db.CreateParameter("@Type", adVarChar, adParamInput, 25, "Liste")		: Cmd_Db.Parameters.Append Pm_Type
					Set Pm_Fo1		= Cmd_Db.CreateParameter("@Fo1", adInteger, adParamInput, , 0) 				: Cmd_Db.Parameters.Append Pm_Fo1
                    Set Pm_Search	= Cmd_Db.CreateParameter("@Search", adVarChar, adParamInput, 1000, Search)	: Cmd_Db.Parameters.Append Pm_Search
                    
					'Set Pm_Page		= Cmd_Db.CreateParameter("@Page", adInteger, adParamInput, , Page)			: Cmd_Db.Parameters.Append Pm_Page
					'Set Pm_PageSize	= Cmd_Db.CreateParameter("@PageSize", adInteger, adParamInput, , PageSize)	: Cmd_Db.Parameters.Append Pm_PageSize	
					'
		
		'### - Ex�cution de la Commande SQL
					Set rs_Fo1 = Cmd_Db.Execute
				
		'### - Affichage des R�sultats de la Proc�dure SQL
					img = "<img src=""../images/warning.gif"" align=""absmiddle"" border=""0"" width=""33"" height=""34"" alt=""Alerte !"">"
				
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
								
						Fo1 = Fo1 & "<tr id=""" & Count & "_h0"">" & vbNewLine & _
									"	<td height=""25"" valign=""middle"" align=""center"" " & Cool & ">" & Paging & "</td>" & vbNewLine &_
                                    "	<td height=""25"" valign=""middle"" align=""center"">" & rs_Fo1("REF_FACTSOUT") & "</td>" & vbNewLine &_
									"	<td height=""25"" valign=""middle"" align=""center"">" & FormatDateTime(rs_Fo1("DATE_FACTSOUT"), 2) & "</td>" & vbNewLine &_
									"	<td height=""25"" valign=""middle"" align=""center"">" & rs_Fo1("NUM_FACTSOUT") & "</td>" & vbNewLine &_
									"	<td height=""25"" valign=""middle"" align=""center"">" & Prix(rs_Fo1("VOL_FACTSOUT")) & "</td>" & vbNewLine &_
									"	<td height=""25"" valign=""middle"" align=""center"">" & Prix(rs_Fo1("MONT_FACTSOUT")) & "</td>" & vbNewLine &_									
                                    "	<td height=""25"" valign=""middle"" align=""center"">" & rs_Fo1("NOM") & "</td>" & vbNewLine &_                                    
									"	<td height=""25"" valign=""middle"" align=""center""><a href=""fact_soutien.asp" & Fo1_Option & """ target=""_self"">" & vbNewLine &_
									"	<img src=""../images/sign.gif"" width=""15"" height=""17"" border=""0"" alt=""Traiter la Facture""></a></td>" & vbNewLine &_
									"</tr>" '& vbNewLine					
				
						rs_Fo1.MoveNext
						
					Wend


		'### - Fermeture des Objets de Connexion
					rs_Fo1.Close
					
					Set rs_Fo1  = Nothing
					Set Cmd_Db = Nothing							


'######################################
	ElseIf Edit = "0" Then  '' ###  => Choix Effectu� - Saisie des infos compl�mentaires
'######################################
								 
	'### - Annulation de l'action Rafraichissement (Bouton F5) - V�rification de l'�tat de Validation
				Session(Nom_Page) 	= ""					

	'### - R�cup�ration des Valeurs de la Formule S�lectionn�e
				Fo1 = Int(Sigec("Fo1"))
    
    '#####################################################
	'#####  R�cup�ration des Formules - Non Edit�es  #####  
	'#####################################################

		'### - Cr�ation de la Commande � Ex�cuter
					Set Cmd_Db = Server.CreateObject("AdoDB.Command")
						Cmd_Db.ActiveConnection = ado_Con
						Cmd_Db.CommandText = "Ps_Doc_FactSoutien"
						Cmd_Db.CommandType = adCmdStoredProc
	
		'### - D�finition des Param�tres de la Proc�dure Stock�e SQL
					Set Pm_Out		= Cmd_Db.CreateParameter("@Output", adInteger, adParamOutput)				: Cmd_Db.Parameters.Append Pm_Out
					Set Pm_Code		= Cmd_Db.CreateParameter("@Code", adVarChar, adParamInput, 3, Code)			: Cmd_Db.Parameters.Append Pm_Code
					Set Pm_Type		= Cmd_Db.CreateParameter("@Type", adVarChar, adParamInput, 25, "Saisie")		: Cmd_Db.Parameters.Append Pm_Type
					Set Pm_Fo1		= Cmd_Db.CreateParameter("@Fo1", adInteger, adParamInput, , Fo1) 				: Cmd_Db.Parameters.Append Pm_Fo1						
		
		'### - Ex�cution de la Commande SQL
					Set rs_Fo1 = Cmd_Db.Execute
				
		'### - Affichage des R�sultats de la Proc�dure SQL									
			    Nb = 1
        Dim tabTransmis
        Dim sTPoids, sPReel, sPFact, sTotal, sMont, Per1, Per2, k, sEcart, Ecart
        Dim TPoids, Total, PReel, PFact, Mont, Periode
            sPReel = 0 : sTPoids = 0 : sTotal = 0 : sPFact = 0 : sMont = 0 : i = 0 : k = 0 : Per1 = "" : Per2 = ""
			PReel = 0 : TPoids = 0 : PFact = 0 : Mont = 0 : Total = 0
            sEcart = 0 :  Ecart = 0

	    tabMotif = ""

		Do Until rs_Fo1 Is Nothing
					
			While Not rs_Fo1.Eof
						
				'############################
					If Nb = 1 Then		' ###  => Jeu de R�sultats N� 1 - Informations de la facture globale s�lectionn�e	
				'############################

						nFact = rs_Fo1("REF_FACTSOUT")
							
                        tabFact = "<tr align=""left"" height=""25""><td><font size=""2"" face=""Verdana"">Campagne</font></td><td>:<font size=""2"" face=""Verdana"">" & rs_Fo1("CAMPAGNE") & "</font></td><td><font size=""2"" face=""Verdana"">N� Facture Exp.</font><td><td>:<font size=""2"" face=""Verdana"">" & rs_Fo1("REF_FACTSOUT") & "</font></td></tr>" & vbNewLine &_  
                                    "<tr align=""left"" height=""25""><td><font size=""2"" face=""Verdana"">Produit</font></td><td>:<font size=""2"" face=""Verdana"">" & rs_Fo1("PRODUIT") & "</font></td><td><font size=""2"" face=""Verdana"">Date Facture </font><td><td>:<font size=""2"" face=""Verdana"">" & rs_Fo1("DATE_FACTSOUT") & "</font></td></tr>" & vbNewLine &_ 
                                    "<tr align=""left"" height=""25""><td><font size=""2"" face=""Verdana"">R�colte</font></td><td>:<font size=""2"" face=""Verdana"">" & rs_Fo1("RECOLTE") & "</font></td><td><font size=""2"" face=""Verdana"">Domiciliation</font><td><td>:<font size=""2"" face=""Verdana"">" & rs_Fo1("BANK") & "</font></td></tr>" & vbNewLine
										   
				'############################
					ElseIf Nb = 2 Then	' ###  => Jeu de R�sultats N� 1 - Liste des formules de la facture
				'############################
						
                        Per1 = rs_Fo1("PERIODE")  
                        If Per1 <> Per2  Then 
                            If tabFo1 <> "" Then   
                                                                   
                                tabFo1 = tabFo1 & _
                                    "<tr bgcolor=""#EEEEEE"" height=""25"">" & _
                                        "<td colspan=""2""><b>S/TOTAL " & Periode & "</b> : </td>" & _
                                        "<td><b>" & Prix(sTPoids) & "</b></td>" & _
                                        "<td><b>" & Prix(sPReel) & "</b></td>" & _ 
                                        "<td><b>" & Prix(sPFact) & "</b></td>" & _   
                                        "<td><b>" & Prix(sEcart) & "</b></td>" & _
                                        "<td><b>" & Round(sEcart*100/sTPoids,3) & "</b></td>" & _                                             
                                        "<td> - </td>" & _
                                        "<td><b>" & Prix(sMont) & "</b></td>" & _ 
                                    "</tr>"
                                    sTPoids = 0  : sMont = 0 : sPReel = 0 : sPFact = 0  : sEcart = 0  : k = k+1                                        
                            End If

                            Periode = rs_Fo1("PERIODE") 
                            tabFo1 = tabFo1 & "<tr height=""25""><td colspan=""11""><b>" & rs_Fo1("PERIODE") & "</b></td></tr>"                             
                        End If	

						tabFo1 = tabFo1 & "<tr align=""center"" id=""" & Count & "_h0"" height=""25"">" & vbNewLine & _									
                                    "	<td>" & rs_Fo1("FO1") & "</td>" & vbNewLine &_
									"	<td>" & FormatDateTime(rs_Fo1("DATE_FO1"), 2) & "</td>" & vbNewLine &_
                                    "	<td>" & Prix(rs_Fo1("POIDS_FO1")) & "</td>" & vbNewLine &_
                                    "	<td>" & Prix(rs_Fo1("POIDSREEL")) & "</td>" & vbNewLine &_
                                    "	<td>" & Prix(rs_Fo1("POIDSFACT")) & "</td>" & vbNewLine &_
									"	<td>" & rs_Fo1("ECART") & "</td>" & vbNewLine &_																											
                                    "	<td>" & rs_Fo1("ECART_TX") & "</td>" & vbNewLine &_
                                    "	<td>" & rs_Fo1("TAUXSOUT") & "</td>" & vbNewLine &_
                                    "	<td>" & Prix(rs_Fo1("MONTSOUT")) & "</td>" & vbNewLine &_									
									"</tr>" &_
                                    "<tr class=""" & Count & "_h1"" height=""25"">" & vbNewLine & _ 
                                    "	<td colspan=""10"" align=""center""> CV: " & rs_Fo1("CV") & " - Tonnage: " & Prix(rs_Fo1("TONNAGE")) & " - CAF REF: " & Prix(rs_Fo1("PRIX")) & "</td>" & vbNewLine &_
                                    "</tr>"

						Per2 = Per1 : i = i+1

                        sEcart = sEcart + round(rs_Fo1("ECART"),0)
                        sTPoids = sTPoids + round(rs_Fo1("POIDS_FO1"),0)
			            sPReel = sPReel + round(rs_Fo1("POIDSREEL"),0)
                        sMont = sMont + Replace(rs_Fo1("MONTSOUT")," ","")
                        sPFact = sPFact + round(rs_Fo1("POIDSFACT"),0)

                        Ecart = Ecart + round(rs_Fo1("ECART"),0)
                        TPoids = TPoids + round(rs_Fo1("POIDS_FO1"),0)
			            PReel = PReel + round(rs_Fo1("POIDSREEL"),0)
                        PFact = PFact + round(rs_Fo1("POIDSFACT"),0)
                        Mont = Mont + Replace(rs_Fo1("MONTSOUT")," ","")                        

				'############################
					ElseIf Nb = 3 Then	' ###  => Jeu de R�sultats N� 2 - 
				'############################
												
						TypeContrat = TypeContrat & "<option value='" & rs_Fo1("TYPECONTRAT") & "'>&nbsp;&nbsp;&nbsp;" & rs_Fo1("TYPECONTRAT") & "&nbsp;&nbsp;&nbsp;</option>"				               
                
                '############################
					ElseIf Nb = 4 Then	' ###  => Jeu de R�sultats N� 2 - 
				'############################

                		'tabMotif = tabMotif & "<tr><td height=""25"" align=""right"">" & rs_Fo1("LIBMOTIF") & "</td><td><input type=""checkbox"" name=""oCheckbox"" value=""" & rs_Fo1("MOTIFR_ID") & """ /></td></tr>"
                        tabMotif = tabMotif & "<li><input type=""checkbox"" name=""oCheckbox"" value=""" & rs_Fo1("MOTIFR_ID") & """ /> - " & rs_Fo1("LIBMOTIF") & "</li>"

				'############################
					End If 				' ###  => Fin de S�lection du Jeu de R�sultats 
				'############################
							
				rs_Fo1.MoveNext
							
				Count = Count + 1
							
			Wend

			If Nb = 2 Then
                
                tabFo1 = tabFo1 & _
                        "<tr bgcolor=""#EEEEEE"" height=""30"">" & _
                            "<td colspan=""2""><b>S/TOTAL " & Periode & "</b> : </td>" & _
                            "<td><b>" & Prix(sTPoids) & "</b></td>" & _
                            "<td><b>" & Prix(sPReel) & "</b></td>" & _
                            "<td><b>" & Prix(sPFact) & "</b></td>" & _
                            "<td><b>" & Prix(sEcart) & "</b></td>" & _
                            "<td><b>" & Round(sEcart*100/sTPoids,3) & "</b></td>" & _
                            "<td> - </td>" & _ 
                            "<td><b>" & Prix(sMont) & "</b></td>" & _ 
                        "</tr>"
                
                tabFo1 = tabFo1 & _
                    "<tr bgcolor=""#EEEEEE"" height=""30"">" & _
                        "<td colspan=""2""><b>TOTAL FACTURE</b> : </td>" & _
                        "<td><b>" & Prix(TPoids) & "</b></td>" & _
                        "<td><b>" & Prix(PReel) & "</b></td>" & _
                        "<td><b>" & Prix(PFact) & "</b></td>" & _
                        "<td><b>" & Prix(Ecart) & "</b></td>" & _
                        "<td><b>" & Round(Ecart*100/TPoids,3) & "</b></td>" & _
                        "<td> - </td>" & _ 
                        "<td><b>" & Prix(Mont) & "</b></td>" & _ 
                    "</tr>"
                        
            End If
			
			Set rs_Fo1 = rs_Fo1.NextRecordset
						
			Nb = Nb + 1
						
		Loop


		'### - Fermeture des Objets de Connexion
					'rs_Fo1.Close
					
					Set rs_Fo1  = Nothing
					Set Cmd_Db = Nothing
		
	Dim Link
		Link = "?Up_Edit=Yes&Fo1=" & Fo1 & rSearch
		Link = "?sigec=" & Server.UrlEncode(Encrypt(Link))
		
'################
	End If	'' ###  => Fin Option
'################			
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>Bourse du Caf� et du Cacao - Edition des Formules - <%=Session("Nom_Complet")%></title>
	<meta http-equiv="content-type" content="text/html; charset=iso-8859-1">
	<link type="text/css" href="../include/global.css" rel="stylesheet">
    <link type="text/css" href="../css/app.css" rel="stylesheet">
    <link type="text/css" href="../css/css-buttons.css" rel="stylesheet">
    <link type="text/css" href="../css/jquery-ui-1.8.5.custom.css" rel="stylesheet">
    <script type="text/javascript" src="../js/menu_file/stm31.js"></script>
    <script type="text/javascript" src="../js/jquery-1.4.2.min.js"></script>
    <script type="text/javascript" src="../js/jquery-ui-1.8.5.custom.min.js"></script>    
    <script language="JavaScript">
		<!--
			function Afficher(name, url, left, top, width, height, toolbar, menubar, statusbar, scrollbar, resizable)
				{
				  toolbar_str = toolbar ? 'yes' : 'no';
				  menubar_str = menubar ? 'yes' : 'no';
				  statusbar_str = statusbar ? 'yes' : 'no';
				  scrollbar_str = scrollbar ? 'yes' : 'no';
				  resizable_str = resizable ? 'yes' : 'no';
				
				  cookie_str = document.cookie;
				  cookie_str.toString();
				
				  pos_start  = cookie_str.indexOf(name);
				  pos_end    = cookie_str.indexOf('=', pos_start);
				
				  cookie_name = cookie_str.substring(pos_start, pos_end);
				
				  pos_start  = cookie_str.indexOf(name);
				  pos_start  = cookie_str.indexOf('=', pos_start);
				  pos_end    = cookie_str.indexOf(';', pos_start);
				  
				  if (pos_end <= 0) pos_end = cookie_str.length;
				  cookie_val = cookie_str.substring(pos_start + 1, pos_end);
				  if (cookie_name == name && cookie_val  == "done")
				    return;
				
				  window.open(url, name, 'left='+left+',top='+top+',width='+width+',height='+height+',toolbar='+toolbar_str+',menubar='+menubar_str+',status='+statusbar_str+',scrollbars='+scrollbar_str+',resizable='+resizable_str);
				}		
		// -->
	</script>
    <script type="text/javascript">
        $(function () {

            $("#Debut").datepicker({ dateFormat: 'dd/mm/yy', dayNamesMin: ['Di', 'Lu', 'Ma', 'Me', 'Je', 'Ve', 'Sa'], changeMonth: true/*, changeYear: true*/ });
            $("#Fin").datepicker({ dateFormat: 'dd/mm/yy', dayNamesMin: ['Di', 'Lu', 'Ma', 'Me', 'Je', 'Ve', 'Sa'], changeMonth: true/*, changeYear: true*/ });

            $("#rMotif,.uMotif").css("display", "none");
            $('tr[class$=_h1]').css("display", "none");
            $('tr[id$=_h0]').css('cursor', 'pointer');
            $('tr[id$=_h0]').click(function () {
                var i = $(this).attr('id').match(/[0-9]+/);
                $('tr[class='+i+'_h1]').toggle();                
            });
            $("input[type=radio]").click(function () {
                if ($(this).val() == 'Rejet') {
                    $(".uMotif").css("display", "block");
                } else {
                    $(".uMotif").css("display", "none");
                }
                if ($(this).val() == 'Ecart') {
                    // -- D�passement de poids -- //
                    $('#dialog').html('D�passement de poids').dialog({
                        width: 460,
                        modal: true,
                        autoOpen: true,
                        buttons: {
                            'Ok': function () { $(this).dialog('close'); return false; }
                        }
                    });
                }
            });

            $("input[type=checkbox]").click(function () {
                if ($(this).val() == '1' && $(this).is(':checked')) {
                    $("#rMotif").css("display", "block");
                } else {
                    $("#rMotif").css("display", "none");
                }
            });

            $('#typeContrat').focus(function () {
                $(".uMotif,#rMotif").css("display", "none");
                $("input[type=radio]").attr("checked", '');
            });

            $('#msg').dialog({
                width: 460,
                modal: true,
                //autoOpen:true,
                buttons: {
                    'OK': function () { $(this).dialog('close'); }
                }
            });


            $('#frm_ok').click(function () {
                var msg = "", sListe = "";
                $('input[type=checkbox]:checked').each(function (i) {
                    vir = (i == 0) ? '' : ',';
                    sListe = sListe + vir + $(this).val();
                });

                if (sListe == '' && $("input[type=radio]:checked").val() == 'Rejet') { msg = "Veuillez cocher les motifs � traiter !"; alert(msg) }
                else $('#idMotif').val(sListe);

                if ($('#Editer').attr("checked") == "") msg = '**********   ATTENTION   **********  <br />     Veuillez cocher la case " Editer " !';

                if (msg == "") {

                    $('#dialog').html("<br />Confirmez-vous l'�dition de cette Formule?").dialog({
                        width: 460,
                        modal: true,
                        autoOpen: true,
                        buttons: {
                            'Oui': function () { $(this).dialog('close'); $('#Edition').submit(); },
                            'Non': function () { $(this).dialog('close'); return false; }
                        }
                    }); return false;
                }
                else {

                    $('#dialog').html(msg).dialog({
                        width: 460,
                        modal: true,
                        autoOpen: true,
                        buttons: {
                            'Ok': function () { $(this).dialog('close'); return false; }
                        }
                    });
                    return false;
                }
            });
            // - Fin des Scripts jQuery                     
        });     
	</script>

</head>    
<body class="page">
	<div id="container">
       <!-- Zone : En t�te -->
        <div id="header"> <!--include file="../include/inc_hautc.asp" --> </div>
        <div id="sidebar">        	
			<%
					Frm_Search 	= "Soutien" 
					Frm 		= "Soutien" 
			%>
				<!--include file="../all_user/soutien_search.asp" -->

        </div>         
        <div id="mainContent">
            <div id="dialog" title="SIGEC4 - Factures de Soutien - "> </div>         
            <%If Erreur>0 Then %>
                <div id="msg" title=" SIGEC4 - Factures de Soutien - ">
                    <p><span style="margin:0px 07px 50px 0px; float:left" class="ui-icon ui-icon-alert"></span> <%=Err_Msg%></p>
                </div>
            <%End If %>
            <br /><br />
              
 <%           
'######################################
	If Edit = "" Then	  		  '' ###  => Choix Effectu� - Affichage des Formules � Editer 
'######################################  
%>
            <h1>Factures de Soutien</h1>
			<br /><br />            
			<table width="90%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#859AA6" summary="" rules="rows" frame="hsides">
			    <tr bgcolor="#EEEEEE">
			      <td height="25" align="center"><b>N�</b></td>
			      <td height="25" align="center"><b>Ref Fact</b></td>
			      <td height="25" align="center"><b>Date</b></td>
			      <td height="25" align="center"><b>N� Fact</b></td>
			      <td height="25" align="center"><b>Tonnage</b></td>
			      <td height="25" align="center"><b>Montant</b></td>                  
                  <td height="25" align="center"><b>Exportateur</b></td>                  
			      <td height="25" align="center"><b>&nbsp;</b></td>
			    </tr>
		<%
				If Fo1 = "" Then
					Response.Write "<tr><td height=""50"" colspan=""8"" valign=""middle"" align=""center"">" & Img
					Response.Write " &nbsp;<font face=""Verdana"" size=""2""><b> - &nbsp;Aucune Formule Disponible !</b></font></td></tr>"
				Else
					Response.Write Fo1
				End If
				
		%>
			</table>
			
			<table width="500" border="0" align="center" cellpadding="0" cellspacing="0" summary="">
				<tr><td width="500" height="20" align="right" valign="middle"><font face="Verdana" size="1">* Les Poids sont exprim�s en Kilogrammes</font></td></tr>
			</table>
		
			 <br />
			
			<!--include file="../include/inc_paging.asp" -->
			
			<br /><br />			
<%
'######################################
	ElseIf Edit = "0" Then  '' ###  => Choix Effectu� - Traitement de la facture s�lectionn�e
'######################################
%>			
	<form action="fact_soutien.asp<%=Link%>" method="post" Name="Edition" id="Edition" enctype="application/x-www-form-urlencoded">			
	
		<br />
        <h1>Contr�le des infos de la facture n� <%=nFact%></h1>
        <br />
	
		<table width="600" border="0" cellpadding="5" cellspacing="0" summary="" align="center">
			<%=tabFact%>			
		</table>
        <p><br /></p>
        <table width="99%" border="1" cellpadding="5" cellspacing="0" bordercolor="#859AA6"  rules="all">
            <tr align="center" height="25" bgcolor="#dbe7f9">
                <td><b><font size="2" face="Verdana">Fo1</font></b></td>
                <td><b><font size="2" face="Verdana">Date Fo1</font></b></td>
                <td><b><font size="2" face="Verdana">Poids Fo1</font></b></td>
                <td><b><font size="2" face="Verdana">Poids R�el</font></b></td>
                <td><b><font size="2" face="Verdana">Poids Factur�</font></b></td>
                <td><b><font size="2" face="Verdana">Ecart (T)</font></b></td>
                <td><b><font size="2" face="Verdana">Ecart (%)</font></b></td>
                <td><b><font size="2" face="Verdana">Taux</font></b></td>
                <td><b><font size="2" face="Verdana">Montant</font></b></td>
            </tr>
			<%=tabFo1%>			
		</table>
        <br />
        <table width="400" border="0" cellpadding="0" cellspacing="0" summary="" align="center">
			<tr align="left"><td><font size="2" face="Verdana">Type de contrat</font></td><td><select name="typeContrat" id="typeContrat"><option></option><%=typeContrat%></select></td></tr>
            <tr align="left"><td><font size="2" face="Verdana">Accepter</font></td><td><input type="radio" name="choix" value="Accord" /></td></tr>
            <tr align="left"><td><font size="2" face="Verdana">Ecart de plus de 2%</font></td><td><input type="radio" name="choix" value="Ecart" /></td></tr>
            <tr align="left">
                <td><font size="2" face="Verdana">Rejeter</font></td>
                <td>
                    <input type="radio" name="choix" value="Rejet" /><span  id="rejet"></span>
                    <input type="hidden" name="idMotif" id="idMotif" />
                </td>
            </tr>            
		</table>
        <ul align="left" class="uMotif"><%=tabMotif%></ul>
        <p><textarea name="rMotif" id="rMotif" rows="3" cols="50">Autre motif de rejet</textarea></p>
        <br /><br />
        <table width="400" border="0" cellpadding="0" cellspacing="0" summary="" align="center">			
			<tr><td align="center" colspan="4" width="400" height="50"><font size="2" face="Verdana"><input type="image" src="../images/frm_ok.gif" border="0" alt="Valider l'Edition de la Formule" align="absmiddle" id="frm_ok"></td></tr>
		</table>
	</form>
            <div id="ecart_msg" title=" SIGEC4 - Factures de Soutien - ">
                <p><%=Err_Msg%></p>
            </div>

<%		
'################
	End If	'' ###  => Fin Option
'################

%>		

	</div> 
    		<div class="clearfloat" ></div>
            <div id="footer"> <!--include file="../include/inc_basc.asp" --> </div>
    </div>


</body>
</html>
