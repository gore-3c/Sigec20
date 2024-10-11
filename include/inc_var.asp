<%
	'### - Création de la Commande à Exécuter
				Dim Db_Cmd
				Set Db_Cmd = Server.CreateObject("AdoDb.Command")
					Db_Cmd.ActiveConnection = ado_Con
					Db_Cmd.CommandText = "Ps_Login"
					Db_Cmd.CommandType = adCmdStoredProc
					
	'### - Définition des Paramètres de la Procédure Stockée SQL
				Dim Pm_1, Pm_2, Pm_3
				Set Pm_1	= Db_Cmd.CreateParameter("@Code", adVarChar, adParamInput, 50, Session("Code"))			: Db_Cmd.Parameters.Append Pm_1
				Set Pm_2	= Db_Cmd.CreateParameter("@Login", adVarChar, adParamInput, 50, Session("Nom"))			: Db_Cmd.Parameters.Append Pm_2
				Set Pm_3	= Db_Cmd.CreateParameter("@Password", adVarChar, adParamInput, 50, Session("Pass"))		: Db_Cmd.Parameters.Append Pm_3
	
	'### - Exécution de la Commande SQL
				Dim rs_Var
				Set rs_Var = Db_Cmd.Execute 
	
				Dim Var_Count 	: Var_Count = 0
				Dim Var_Nb		: Var_Nb 	= 1
				
				Dim Var_Exp 	: Var_Exp = 0
				Dim Var_Use 	: Var_Use = 0
				
	'########
	'### - Création des Variables Session Exportateur
	'######## 
	
				Do Until rs_Var Is Nothing
				
					Var_Count = 0
					
					While Not rs_Var.Eof
		
						'############################
							If Var_Nb = 1 Then		' ###  => Jeu de Résultats N° 1 -  Information Exportateur
						'############################
						
								Var_Count = Var_Count + 1
								Var_Exp   = Var_Exp   + 1
																	
								Session("Exportateur") 	= rs_Var("EXPORTATEUR")		
								Session("Nom_Complet") 	= rs_Var("EXPORTATEUR")		
								Session("Nom") 		= rs_Var("NOM")			
								Session("Nom_Lot") 	= rs_Var("Nom_Lot")		
								Session("Log_Pass") 	= rs_Var("PASS_EXP") 
								Session("Enr_Pass") 	= rs_Var("PASS_ENR") 
								Session("Adresse") 	= rs_Var("ADR_EXP") 	
								Session("Telephone") 	= rs_Var("TEL_EXP") 
								Session("Fax") 		= rs_Var("FAX_EXP")		
								Session("Email") 	= rs_Var("EMAIL_EXP") 	
								Session("Representant")	= rs_Var("REPRESENTANT")	
								Session("CC") 		= rs_Var("CONTRIBUABLE") 	
								Session("Localisation") = rs_Var("LOCALISATION") 
								Session("Agrement") 	= rs_Var("AGREE_ID") 	 
								Session("Campagne_Exp") = rs_Var("CAMP_ID")   	
								Session("Regime") 	= rs_Var("REGIME_ID") 		
								Session("Transfo") 	= rs_Var("ID_TRANS") 	  	
								Session("Agree") 	= rs_Var("V_AGREE")		
								Session("Prepaiement") 	= rs_Var("V_PREP")	
								Session("V_Lot") 	= rs_Var("V_LOT")		
								Session("Sus_Enr") 	= rs_Var("SS_ENR") 		
								Session("Sus_CDC") 	= rs_Var("SS_CDC")		
								Session("Sus_FO1")	= rs_Var("SS_FO1")		
								Session("Menu") 	= "exportateur.js"		
								Session("Domaine") 	= "exportateur"			
								Session("User") 	= "exportateur"			
								Session("Mail") 	= rs_Var("Mail")		
								Session("Port_Emb")     = "%"				
								Session("Sigec")	= Sigec("Sigec")
						
								Session("Sus_Mess") = rs_Var("SS_Mess")		
								Session("Achat") 	= rs_Var("Achat")		
								Session("Report") 	= rs_Var("Report")		
								Session("Rejet") 	= rs_Var("Rejet")		
								
								Session("Acces")  = ",report.asp,apure_cdc.asp,ar_cdc.asp,ch.asp,ch_comp.asp,enr.asp,enr_special.asp,fo1.asp,index.asp,lot.asp,prep_fiche.asp,prep_liste.asp,prep_saisie.asp,prep_solde.asp,pwd_enr.asp,pwd_sys.asp,refuse.asp,sign_cdc.asp,up_ch.asp,up_comp.asp,up_fo1.asp,up_lot.asp,up_prep.asp,vierge.asp,arbre.asp,cotation_kfe.asp,cotation_kko.asp,enr_cdc_fo1.asp,import.asp,liste_cdc.asp,liste_enr.asp,liste_fo1.asp,niveau_cdc.asp,origine.asp,refuse.asp,search_cdc.asp,search_enr.asp,search_fo1.asp,suivi_cdc.asp,suivi_ch.asp,suivi_fo1.asp,suivi_lot.asp,brouillon.asp,ecrire.asp,error.asp,index.asp,lien.asp,liste.asp,msg.asp,option.asp,outil.asp,panier.asp,send.asp,user_list.asp,down.asp,download.asp,force.asp,export.asp,data.asp,local.asp,extract.asp,poids.asp"				
								Session("Acces")  = Session("Acces") & ",achat_br.asp,achat_lot.asp,achat_tv.asp,cession_lot.asp,cession_tv.asp,cloture.asp,list_br.asp,list_hebdo.asp,list_lot.asp,list_tv.asp,list_usn.asp,rsn.asp,up_br.asp,up_lot.asp,up_rsn.asp,up_tv.asp,up_usn.asp,usn.asp,br.asp,hebdo_kfe.asp,hebdo_kko.asp,lot.asp,tv.asp,usn.asp,edition.asp,edit_fo1.asp"
																																			
								
								Dim Inc_Var : Inc_Var = 0
								
								If (Session("Sus_Mess") = 1) And (Inc_Var = 0) Then
									Inc_Var = 1
									Response.Redirect "../logout.asp?Acces=Sus_Mess"
									Session("Acces") = ""
								End If 
								
								If (Session("Achat") = 0) And (Inc_Var = 0) Then
									Inc_Var = 1
									Session("Acces") = ",achat_br.asp,print_br.asp,list_br.asp,up_br.asp"
								End If
																						
								If (Session("Report") <> 0) And (Inc_Var = 0) Then
									Inc_Var = 1
									Session("Acces") = ",report.asp,apure_cdc.asp,sign_cdc.asp,arbre.asp,niveau_cdc.asp,suivi_cdc.asp,suivi_fo1.asp,enr_cdc_fo1.asp,search_enr.asp,search_cdc.asp,search_fo1.asp"			
								End If														
							
								If (Session("Rejet") <> 0) And (Inc_Var = 0) Then
									Inc_Var = 1
									Session("Acces") = ""
								End If
																						
						'############################
							ElseIf Var_Nb = 2 Then	' ###  => Jeu de Résultats N° 2 -  Information User
						'############################
						 
								Var_Count = Var_Count + 1
								Var_Use   = Var_Use   + 1
														  	
								Session("Nom_Complet") 	= rs_Var("Nom")							
								Session("Nom") 			= rs_Var("Login")	   					
								Session("Log_Pass") 	= rs_Var("Pass") 						
								Session("Domaine") 		= rs_Var("Domaine") 					
								Session("Abidjan") 		= rs_Var("Abj")   						
								Session("SanPedro") 	= rs_Var("Sp")							
								Session("Acces") 		= rs_Var("Acces") 						
								Session("Menu") 		= rs_Var("Domaine") & ".js"				
								Session("User") 		= "user_bcc"							
								Session("Mail") 		= rs_Var("Mail")						
								Session("Sigec")		= rs_Var("Sigec")
							
								If Session("Abidjan") = True And Session("SanPedro") = True Then
									Session("Port_Emb") = "%"											
								ElseIf Session("Abidjan") = True And Session("SanPedro") = False Then
									Session("Port_Emb") = "1"												
								ElseIf Session("Abidjan") = False And Session("SanPedro") = True Then
									Session("Port_Emb") = "2"												
								ElseIf Session("Abidjan") = False And Session("SanPedro") = False Then
									Session("Port_Emb") = "Null"											
								End If
		
						'###############
							End If ' ###  => Fin de Sélection du Jeu de Résultats 
						'###############
						
						rs_Var.MoveNext
						
					Wend
					
					Set rs_Var = rs_Var.NextRecordset
					
					Var_Nb = Var_Nb + 1
					
				Loop
																					
				If (Var_Exp + Var_Use) = 0 Then
					Session("Login") = False
					Response.Redirect "../logout.asp"				'### - Redirection de l'Utilisateur Non Athentifié 
				End If

		
%>




