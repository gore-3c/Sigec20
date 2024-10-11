	<!--#include file="../include/inc_con.asp" -->
	<!--#include file="../include/fonction.asp" -->
	<!--#include file="../include/encryption.asp" -->
	<!--#include file="../include/inc_var.asp" -->
	
<%		
		If Session("Login") = False Or IsNull(Session("Login")) = True Then Response.Redirect "../expire.asp" End If

	'### - Declaration des Variables
				Dim Code
				Dim Choix_Chq, Err_Msg, Check_Chq
				Dim Cmd_Db, rs_Enr, Count
				Dim Pm_Out, Pm_Code, Pm_Type, Pm_Id, Pm_Rclt, Pm_Prdt, Pm_Parite, Pm_Camp, Pm_ListeF, Pm_Fo1
                Dim Pm_NumF, Pm_DtF, Pm_MtF, Pm_BanqF, Pm_FormF, Pm_TauxF, Pm_MtS, Pm_Str, Pm_VolF, Pm_NumOT
                Dim Pm_Mode, Pm_PoidsF, Pm_PoidsT, Pm_PoidsR
                Dim NumFact, NumOT, DateFact, MontFact, Str_Form, Str_TauxRS, Str_MtSout
                Dim Str_PoidsT, Str_PoidsF, Str_PoidsR, Str_ModeCal				
				Dim Img, Id, Prdt, Parite, Rclt, ListeF, Bank
                Dim Poids, Taux, Montant, VolFact, ModeCal, PoidsF, PoidsT, PoidsR 
                Dim Campagne, Produit, Recolte, Periode
				Dim Fo1, Fo1_Option, Url
				Dim Nb, Lign, Grp
				Dim Str

				
	'### - Récupération des Variables Session Utilisateur
				Code  = Session("Code")

	'### - Pagination des Résultats renvoyés par la Procédure Stockée SQL
				Dim Nom_Page
					Nom_Page = "fact_soutien.asp"

				If (Len(Sigec("Page")) = 0) Or (IsNumeric(Sigec("Page")) = False) Then
					Page = 1
				Else
					Page = CInt(Sigec("Page"))
				End If

	'### - Récupération des Critères de Recherche 
					Dim Frm_Search
						Frm_Search = "Fo1" 
			%>
					<!--#include file="../all_user/user_sql.asp" -->
			<%

	'### - Récupération des Options de Validation'
   

				'Fo1 	  = Sigec("Fo1")
				Choix_Chq = Sigec("Choix_Chq")
				Check_Chq = Sigec("Check_Chq")
                Lign      = Sigec("Ch")
                Grp       = Sigec("k")                
               
'####################################
	If Check_Chq = "Yes" Then		' ###  => Choix Effectué - Validation de la saisie dans la Base de Données
'####################################

	'### - Déclaration des Variables
			Dim Erreur
				Erreur = 0
                    
				Str = "|@¤|"
                    
                Poids = ""
                Taux = ""
                Fo1 = ""
                Montant = ""
                'Struct = ""	
                    		 
	'### - Controle du Formulaire
                    
				If Choix_Chq = "" Then 
					Err_Msg = Err_Msg & "Une Erreur inatendue (0) s'est produite."
					Err_Msg = Err_Msg & "Veuiller vérifier les informations saisies !"
					Err_Msg = Err_Msg & "Si l'Erreur persiste, veuillez contacter l'Administrateur !"
					Erreur  = 1
				Else
					Dim k, m, j 
                    k = 0 : m = 1 : j = 0
				    For j = 0 To Int(Grp)
                        For k = 0 To Int(Lign)-1  
                            If Request("txtFo1" & j & "_" & k) <> "" Then 'And Request("txtPoids" & j & "_" & k) <> "0"

                                'Poids = Poids & Replace(Request("txtPoids" & j & "_" & k)," ", "") & Str
                                Taux = Taux & Request("txtTx" & j & "_" & k) & Str 
                                Fo1 = Fo1 & Request("txtFo1" & j & "_" & k) & Str 
                                Montant = Montant & Replace(Request("txtMt" & j & "_" & k)," ", "") & Str  

                                PoidsT = PoidsT & Replace(Request("txtPoidsFo1" & j & "_" & k)," ", "") & Str
                                PoidsF = PoidsF & Replace(Request("txtPoidsFact" & j & "_" & k)," ", "") & Str
                                PoidsR = PoidsR & Replace(Request("txtPoids" & j & "_" & k)," ", "") & Str
                                ModeCal = ModeCal & Request("txtModeCal" & j & "_" & k) & Str

                            Else   
                                If Request("txtFo1"  & j & "_" & k)  <> ""  Then 
                                    Erreur = 1 : Err_Msg = Err_Msg & "Erreur sur la formule de la ligne N° " & k+1 & " !" 
                                End If                          
                            End If                                                                            
                        Next
                    Next

                    NumOT = Request("txtOT")  
                    NumFact = Request("txtFact")   
                    DateFact = Request("DateFact") 
                    MontFact = Replace(Request("mtTotal")," ", "")
                    VolFact = Replace(Request("PoidsFact")," ", "") 'vTotal
                    
                    Prdt = Request("Prdt")
                    Camp = Request("Camp")
                    Parite = Request("Parite")
                    Rclt = Request("Rclt")
                    Bank = Request("banq") 

                    Str_Form = Fo1
                    Str_TauxRS = Taux 
                    'Str_PoidsR = Poids
                    Str_MtSout  = Montant

                    Str_PoidsT = PoidsT
                    Str_PoidsF = PoidsF
                    Str_PoidsR = PoidsR
                    Str_ModeCal = ModeCal
                         
                End If
             
				If Erreur = 1 Then
					Choix_Chq = "1"
                    'response.write Erreur
				End If
                
				If Session(Nom_Page) <> "" Then 
					Choix_Chq = ""
				Else
					If Erreur = 0 Then 
	
						'###########################################################
						'#####  Récupération des Références de Chèques Saisis  #####  
						'###########################################################
						
							'### - Récupération des Informations du Formulaire
																				
								'response.write Prdt & " - " & Rclt  & " - " & Camp   & " - " & Parite & " - " & MontFact & " - " & VolFact & " - " & Bank & " - " & MontFact & " <br>"		
																									
						'### - Création de la Commande à Exécuter
									Set Cmd_Db = Server.CreateObject("AdoDB.Command")
										Cmd_Db.ActiveConnection = ado_Con
										Cmd_Db.CommandText = "Ps_Exp_FactSoutien"
										Cmd_Db.CommandType = adCmdStoredProc
					
						'### - Définition des Paramètres de la Procédure Stockée SQL
									Set Pm_Out		= Cmd_Db.CreateParameter("@Output", adInteger, adParamOutput)				: Cmd_Db.Parameters.Append Pm_Out
					                Set Pm_Code		= Cmd_Db.CreateParameter("@Code", adVarChar, adParamInput, 3, Code)			: Cmd_Db.Parameters.Append Pm_Code
                                    Set Pm_Type	    = Cmd_Db.CreateParameter("@Option", adVarChar, adParamInput, 25, "Valide")	: Cmd_Db.Parameters.Append Pm_Type
					                Set Pm_Id	    = Cmd_Db.CreateParameter("@Id", adInteger, adParamInput, , 0) 			    : Cmd_Db.Parameters.Append Pm_Id
                                    Set Pm_Search	= Cmd_Db.CreateParameter("@Search", adVarChar, adParamInput, 1000, Search)	: Cmd_Db.Parameters.Append Pm_Search

                                    Set Pm_Prdt	    = Cmd_Db.CreateParameter("@Prdt", adInteger, adParamInput, , Prdt) 			: Cmd_Db.Parameters.Append Pm_Prdt
                                    Set Pm_Rclt	    = Cmd_Db.CreateParameter("@Reclt", adInteger, adParamInput, , Rclt) 		: Cmd_Db.Parameters.Append Pm_Rclt
                                    Set Pm_Camp	    = Cmd_Db.CreateParameter("@Camp", adInteger, adParamInput, , Camp) 			: Cmd_Db.Parameters.Append Pm_Camp
                                    Set Pm_Parite	= Cmd_Db.CreateParameter("@Parite", adInteger, adParamInput, , Parite) 		: Cmd_Db.Parameters.Append Pm_Parite
                                    Set Pm_ListeF	= Cmd_Db.CreateParameter("@ListForm", adVarChar, adParamInput, 2000, ListeF)	: Cmd_Db.Parameters.Append Pm_ListeF

                                    Set Pm_NumOT	= Cmd_Db.CreateParameter("@NumOT", adVarChar, adParamInput, 500, NumOT)	: Cmd_Db.Parameters.Append Pm_NumOT
                                    Set Pm_NumF	= Cmd_Db.CreateParameter("@NumFact", adVarChar, adParamInput, 25, NumFact)	: Cmd_Db.Parameters.Append Pm_NumF
                                    Set Pm_DtF	= Cmd_Db.CreateParameter("@DateFact", adVarChar, adParamInput, 10, DateFact)	: Cmd_Db.Parameters.Append Pm_DtF
                                    Set Pm_MtF	= Cmd_Db.CreateParameter("@MontFact", adInteger, adParamInput, , MontFact)	: Cmd_Db.Parameters.Append Pm_MtF
                                    Set Pm_VolF	= Cmd_Db.CreateParameter("@VolFact", adInteger, adParamInput, , VolFact)	: Cmd_Db.Parameters.Append Pm_VolF
                                    Set Pm_BanqF	= Cmd_Db.CreateParameter("@Bank", adInteger, adParamInput, , Bank)	: Cmd_Db.Parameters.Append Pm_BanqF

                                    Set Pm_FormF	= Cmd_Db.CreateParameter("@Str_Form", adVarChar, adParamInput, 8000, Str_Form)	: Cmd_Db.Parameters.Append Pm_FormF
                                    Set Pm_TauxF	= Cmd_Db.CreateParameter("@Str_TauxRS", adVarChar, adParamInput, 8000, Str_TauxRS)	: Cmd_Db.Parameters.Append Pm_TauxF
                                    Set Pm_PoidsR	= Cmd_Db.CreateParameter("@Str_PoidsR", adVarChar, adParamInput, 8000, Str_PoidsR)	: Cmd_Db.Parameters.Append Pm_PoidsR                                    
                                    Set Pm_MtS	= Cmd_Db.CreateParameter("@Str_MtSout", adVarChar, adParamInput, 8000, Str_MtSout)	: Cmd_Db.Parameters.Append Pm_MtS
                                    Set Pm_PoidsT	= Cmd_Db.CreateParameter("@Str_PoidsT", adVarChar, adParamInput, 8000, Str_PoidsT)	: Cmd_Db.Parameters.Append Pm_PoidsT
                                    Set Pm_PoidsF	= Cmd_Db.CreateParameter("@Str_PoidsF", adVarChar, adParamInput, 8000, Str_PoidsF)	: Cmd_Db.Parameters.Append Pm_PoidsF
                                    Set Pm_Mode	= Cmd_Db.CreateParameter("@Str_ModCal", adVarChar, adParamInput, 8000, Str_ModeCal)	: Cmd_Db.Parameters.Append Pm_Mode
                                    Set Pm_Str	= Cmd_Db.CreateParameter("@Str", adVarChar, adParamInput, 4, Str)	: Cmd_Db.Parameters.Append Pm_Str
                                                                 
	                    
                        'response.write Str & " - " & Str_Form  & " - " & Str_ModeCal   & " - " & Str_TauxRS & " - " & Str_PoidsR & " - " & Str_MtSout & " - " & Str_PoidsT & " - " & Str_PoidsT & " <br>"
						'### - Exécution de la Commande SQL
									Cmd_Db.Execute
				
						'### - Vérification du Paramètre de Retour et Affichage du Message de Confirmation								
				   		
									Dim Retour				'### - Vérification du Paramètre de Retour et Affichage du Message de Confirmation
									Set Retour = Pm_Out
									Erreur = 1 
									If Retour > 0 Then	 	'### - Aucune Erreur
										Err_Msg = Err_Msg & "Saisie de Facture de soutien Validee !"
										Choix_Chq = ""
	
										Log Fo1, "Fo1", "Saisie de Facture de soutien " & NumFact 					

									Else		   			'### - Erreur Rencontrée
										Err_Msg = Err_Msg & "Une Erreur inatendue (" & Retour & ") s'est produite."
										Err_Msg = Err_Msg & "Veuiller vérifier les informations saisies !"
										Err_Msg = Err_Msg & "Si l'Erreur persiste, veuillez contacter l'Administrateur !!!"
										Choix_Chq = ""
									End If
									
					End If
                        
			End If

			'### - Fermeture des Objets de Connexion
			Set Cmd_Db = Nothing
						
'####################################
	End If						' ###  => Fin de la Validation 
'####################################

'####################################
	If Choix_Chq = "" Then		' ###  => Choix Effectué - Affichage des Campagnes/Produits/Recoltes 
'####################################
			

		'### - Création de la Commande à Exécuter
			Set Cmd_Db = Server.CreateObject("AdoDB.Command")
				Cmd_Db.ActiveConnection = ado_Con
				Cmd_Db.CommandText = "Ps_Exp_FactSoutien"
				Cmd_Db.CommandType = adCmdStoredProc
	
		'### - Définition des Paramètres de la Procédure Stockée SQL
			Set Pm_Out	= Cmd_Db.CreateParameter("@Output", adInteger, adParamOutput)			: Cmd_Db.Parameters.Append Pm_Out
			Set Pm_Code	= Cmd_Db.CreateParameter("@Code", adVarChar, adParamInput, 3, Code)		: Cmd_Db.Parameters.Append Pm_Code
			Set Pm_Type	= Cmd_Db.CreateParameter("@Option", adVarChar, adParamInput, 25, "Liste")	: Cmd_Db.Parameters.Append Pm_Type
			Set Pm_Fo1	= Cmd_Db.CreateParameter("@Id", adInteger, adParamInput, , 0) 			: Cmd_Db.Parameters.Append Pm_Fo1

		'### - Exécution de la Commande SQL
			Set rs_Ch = Cmd_Db.Execute
				
		'### - Affichage des Résultats de la Procédure SQL
			Dim w, x, options
            
            	options = ""

			While Not rs_Enr.EOF

                x = rs_Ch("PRDT_ID")

                If x <> w Then
                    If options <> "" Then options = options & "</optgroup>" End If
                    options = options & "<optgroup label=""" & rs_Enr("PRODUIT") & """>"
                End If

                options = options & "<option value=""" & rs_Enr("PRDT_ID") & "&" & rs_Enr("CAMP_ID") & "&" & rs_Enr("RCLT_ID") & "&" & rs_Enr("PARITE") & """>" & rs_Enr("CAMPAGNE") & " | " & rs_Enr("RECOLTE") & "</option>"
				
                w = x		
				rs_Ch.MoveNext                        
				
			Wend

            options = "<option value="""">Campagne | Recolte</option>" & options & "</optgroup>"
                    
		'### - Fermeture des Objets de Connexion
			rs_Ch.Close
			
			Set rs_Ch  = Nothing
			Set Cmd_Db = Nothing
                                        

'################
	End If	' ###  => Fin Option
'################											
				

'####################################
	If Choix_Chq = "1" Then	' ###  => Choix Effectué - Choix des Formules à traiter
'####################################
				
		'### - Déclaration des Variables
					Dim Zero, aLink, FrmSaisie, Ch, jk, FrmReverst
				
		'### - Récupération des Valeurs de la Formule Sélectionnée
					ListeF = Request("ListId") 'replace(,",",";")					
                    Prdt = Request("Prdt")
                    Camp = Request("Camp")
                    Parite = Request("Parite")
                    Rclt = Request("Rclt")
          'response.write "prdt:" & Prdt & "camp:" & camp & "parite:" & parite & "recolte:" & Rclt  & " List:" & ListeF
                    
		'### - Création de la Commande à Exécuter
					Set Cmd_Db = Server.CreateObject("AdoDB.Command")
						Cmd_Db.ActiveConnection = ado_Con
						Cmd_Db.CommandText = "Ps_Exp_FactSoutien"
						Cmd_Db.CommandType = adCmdStoredProc
	
		'### - Définition des Paramètres de la Procédure Stockée SQL
					Set Pm_Out		= Cmd_Db.CreateParameter("@Output", adInteger, adParamOutput)				: Cmd_Db.Parameters.Append Pm_Out
					Set Pm_Code		= Cmd_Db.CreateParameter("@Code", adVarChar, adParamInput, 3, Code)			: Cmd_Db.Parameters.Append Pm_Code
                    Set Pm_Type	    = Cmd_Db.CreateParameter("@Option", adVarChar, adParamInput, 25, "Saisie")	: Cmd_Db.Parameters.Append Pm_Type
					Set Pm_Id	    = Cmd_Db.CreateParameter("@Id", adInteger, adParamInput, , 0) 			    : Cmd_Db.Parameters.Append Pm_Id
                    Set Pm_Search	= Cmd_Db.CreateParameter("@Search", adVarChar, adParamInput, 1000, "")		: Cmd_Db.Parameters.Append Pm_Search
                    Set Pm_Prdt	    = Cmd_Db.CreateParameter("@Prdt", adInteger, adParamInput, , Prdt) 			: Cmd_Db.Parameters.Append Pm_Prdt
                    Set Pm_Rclt	    = Cmd_Db.CreateParameter("@Reclt", adInteger, adParamInput, , Rclt) 		: Cmd_Db.Parameters.Append Pm_Rclt
                    Set Pm_Camp	    = Cmd_Db.CreateParameter("@Camp", adInteger, adParamInput, , Camp) 			: Cmd_Db.Parameters.Append Pm_Camp
                    Set Pm_Parite	= Cmd_Db.CreateParameter("@Parite", adInteger, adParamInput, , Parite) 		: Cmd_Db.Parameters.Append Pm_Parite
                    Set Pm_ListeF	= Cmd_Db.CreateParameter("@ListForm", adVarChar, adParamInput, 2000, ListeF)	: Cmd_Db.Parameters.Append Pm_ListeF					
		
		'### - Exécution de la Commande SQL
					Set rs_Enr = Cmd_Db.Execute
				
		'### - Affichage des Résultats de la Procédure SQL					
				
					Nb = 1 : i = 0 : FrmReverst = ""
                    Dim Per1, Per2, sTaux, sTPoids, TPoids, MtReel, sMtReel, sTPoidsReel, sTPoidsFact, TPoidsReel, TPoidsFact, sEcart, Ecart
                        Per1 = "" : Per2 = "" : sTPoids = 0 : k = 0
                        TPoids = 0 : MtReel = 0 : sTPoidsFact = 0
                        sEcart = 0 : Ecart = 0

					Do Until rs_Ch Is Nothing
					
						Count = 0
						
						While Not rs_Ch.EOF
						
							'############################
								If Nb = 1 Then		' ###  => Jeu de Résultats N° 1 - Récupération de la campagne, du produit, de la recolte/parité des formules selectionnées
							'############################
                                    
                            		Campagne = rs_ch("CAMPAGNE")   
                                    Produit = rs_ch("PRODUIT")
                                    Recolte = rs_ch("RECOLTE")                                                                      
                                                                                                          								
							'############################
								ElseIf Nb = 2 Then	' ###  => Jeu de Résultats N° 2 - Récupération des Informations des formules Sélectionées
							'############################
                                
                                Per1 = rs_ch("PER_ID")  
                                If Per1 <> Per2 Then 
                                    If FrmReverst <> "" Then                                         
                                        FrmReverst = FrmReverst & _
                                             "<tr bgcolor=""#EEEEEE"">" & _
                                                "<td colspan=""5""><b>S/TOTAL " & Periode & "</b> : </td>" & _
                                                "<td><b>" & Prix(sTPoids) & "</b></td>" & _
                                                "<td><input type=""text"" name=""txtsPoids" & k & """ size=""8"" value=""" & Prix(Abs(sTPoidsReel)) & """ /></td>" & _ 
                                                "<td>" & Prix(Abs(sTPoidsFact)) & "</td>" & _                                               
                                                "<td> - </td>" & _
                                                "<td> - </td>" & _
                                                "<td> - </td>" & _
                                                "<td><input type=""text"" name=""txtsMt" & k & """ size=""10"" value=""" & Prix(Abs(sMtReel)) & """ /></td>" & _
                                            "</tr>"
                                            sTPoids = 0  : k = k+1  
                                            sMtReel = 0 : sTPoidsReel = 0 : sTPoidsFact = 0                                        
                                    End If
                                    Periode = rs_ch("PERIODE") 
                                    FrmReverst = FrmReverst & "<tr><td colspan=""9""><b>" & rs_ch("PERIODE") & "</b></td></tr>" 
                                End If

                                '### - Si PoidsReel > 0 => On calcule l'ecart
                                sEcart = 0
                                If rs_ch("POIDS_REEL") > 0 Then sEcart = rs_ch("POIDS_REEL")-rs_ch("POIDS_FO1")
                                  
								FrmReverst = FrmReverst & "<tr height=""25"">" & vbNewLine & _										
                                                                "<td><input type=""hidden"" name=""txtModeCal" & k & "_" & i & """ id=""txtModeCal" & k & "_" & i & """ value=""" & rs_ch("MODECALCUL") & """ />" & rs_ch("CDC_CGFCC") & "</td>"& vbNewLine & _ 
                                                                "<td>" & Prix(rs_ch("POIDS_CDC")) & "</td>"& vbNewLine & _
                                                                "<td>" & Prix(rs_ch("CAF_REF")) & "</td>"& vbNewLine & _
                                                                "<td>" & rs_ch("NUM_FRC") & "<input type=""hidden"" name=""txtFo1" & k & "_" & i & """ id=""txtFo1" & k & "_" & i & """ value=""" & rs_ch("Fo1_Id") & """ /></td>"& vbNewLine & _
                                                                "<td>" & FormatDateTime(rs_ch("DATE_FRC"),2) & "</td>"& vbNewLine & _
                                                                "<td><input type=""hidden"" name=""txtPoidsFo1" & k & "_" & i & """ id=""txtPoidsFo1" & k & "_" & i & """ value=""" & rs_ch("POIDS_FO1") & """ />" & Prix(round(rs_ch("POIDS_FO1"),0)) & "</td>"& vbNewLine & _
                                                                "<td><input type=""text"" name=""txtPoids" & k & "_" & i & """ id=""txtPoids" & k & "_" & i & """ size=""8"" value=""" & rs_ch("POIDS_REEL") & """ readonly=""readonly"" /></td>"& vbNewLine & _
                                                                "<td><input type=""text"" name=""txtPoidsFact" & k & "_" & i & """ id=""txtPoidsFact" & k & "_" & i & """ size=""8"" value=""" & rs_ch("POIDS_FACT") & """ readonly=""readonly"" /></td>"& vbNewLine & _
                                                                "<td>" & Prix(Abs(rs_ch("TAUXRS"))) & "<input type=""hidden"" name=""txtTx" & k & "_" & i & """ id=""txtTx" & k & "_" & i & """ value=""" & replace(Abs(rs_ch("TAUXRS")),",",".") & """ /></td>"& vbNewLine & _ 
                                                                "<td><input type=""text"" name=""txtEcartv" & k & "_" & i & """ id=""txtEcartv" & k & "_" & i & """ size=""4"" value=""" & round(sEcart,0) & """ /></td>"& vbNewLine & _
                                                                "<td><input type=""text"" name=""txtEcartp" & k & "_" & i & """ id=""txtEcartp" & k & "_" & i & """ size=""3"" value=""" & round(sEcart*100/rs_ch("POIDS_FO1"),3) & """ /></td>"& vbNewLine & _                                                                
                                                                "<td><input type=""text"" name=""txtMt" & k & "_" & i & """ size=""10"" id=""txtMt" & k & "_" & i & """ value=""" & Abs(rs_ch("MONTANT")) & """ /></td>"& vbNewLine & _                                                               
                                                          "</tr>"

						       Per2 = Per1 : i = i+1
                               sTPoids = sTPoids + round(rs_ch("POIDS_FO1"),0)
                               sMtReel = sMtReel + round(rs_ch("MONTANT"),0)  
                               sTPoidsReel = sTPoidsReel + round(rs_ch("POIDS_REEL"),0)
                               sTPoidsFact = sTPoidsFact + round(rs_ch("POIDS_FACT"),0)

                               TPoids = TPoids + round(rs_ch("POIDS_FO1"),0)

                               MtReel = MtReel + round(rs_ch("MONTANT"),0)
                               TPoidsReel = TPoidsReel + round(rs_ch("POIDS_REEL"),0)
                               TPoidsFact = TPoidsFact + round(rs_ch("POIDS_FACT"),0)

							'############################
								ElseIf Nb = 3 Then	' ###  => Jeu de Résultats N° 3 - Sélection de la Liste des Banques
							'############################
                            		
									Bank = Bank & vbNewLine & "<option value='" & rs_Ch("DOMBANK_ID") & "'>&nbsp;&nbsp;" & rs_Ch("Bank") & "</option>"	
                                                                                                            									                                                                      	 			
							'###############
								End If ' ###  => Fin de Sélection du Jeu de Résultats 
							'###############
							
							Count = Count + 1
							
							rs_Ch.MoveNext

                            If Nb = 2 And rs_Ch.Eof Then
                            FrmReverst = FrmReverst & _
                                             "<tr bgcolor=""#EEEEEE"" height=""25"">" & _
                                                "<td colspan=""5""><b>S/TOTAL " & Periode & "</b> : </td>" & _
                                                "<td><b>" & Prix(sTPoids) & "</b></td>" & _
                                                "<td><input type=""text"" name=""txtsPoids" & k & """ size=""8"" value=""" & Prix(Abs(sTPoidsReel)) & """ /></td>" & _ 
                                                "<td>" & Prix(Abs(sTPoidsFact)) & "</td>" & _
                                                "<td> - </td>" & _
                                                "<td> - </td>" & _
                                                "<td> - </td>" & _
                                                "<td><input type=""text"" name=""txtsMt" & k & """ size=""10"" value=""" & Prix(Abs(sMtReel)) & """ /></td>" & _
                                            "</tr>"
                            End If

						Wend

						Set rs_Ch = rs_Ch.NextRecordset
						
						Nb = Nb + 1
						
					Loop

		'### - Fermeture des Objets de Connexion
					'rs_Ch.Close
					
					Set rs_Ch  = Nothing
					Set Cmd_Db = Nothing

			'Link = "?Check_Chq=Yes&Choix_Chq=0&Ch=" & i & "&k=" & k & rSearch
			'Link = "?sigec=" & Server.UrlEncode(Encrypt(Link))
	
%>

<form action="fact_soutien.asp<%=Link%>" method="post" Name="Chq" id="Chq" enctype="application/x-www-form-urlencoded">

	<br /><h1>Saisie des Infos de la facture</h1><br />			
    <table width="100%" cellpadding="0" cellspacing="0" align="center">
        <tr height="25">
            <td align="left">Campagne</td><td align="left">: <%=Campagne%></td> <td align="left">N° Facture</td><td align="left">: <input type="text" name="txtFact" id="txtFact" /></td>
        </tr>
        <tr height="25">
            <td align="left">Produit</td><td align="left">: <%=Produit%></td> <td align="left">Date Facture</td> <td align="left">: <input type="text" name="DateFact" id="DateFact" /></td> 
        </tr>
        <tr height="25">
            <td align="left">Récolte</td><td align="left">: <%=Recolte%></td> <td align="left">Domiciliation bancaire</td> <td align="left">: <select name="Banq" id="Banq"><option></option><%=bank%></select></td> 
        </tr>  
    </table>
    <br /><br />

    <table class="table">
        <tr bgcolor="#EEEEEE" height="25">
            <th>CV</th>
            <th>Tonnage</th>
            <th>Prix</th>
            <th>Fo1</th>
            <th>Date Fo1</th>
            <th>Poids Fo1</th>
            <th>Poids Réel</th>
            <th>Poids Facturé</th>
            <th>Taux</th>
            <th>Ecart</th>
            <th>Ecart %</th>
            <th>Montant</th>
        </tr>
        <%=FrmReverst%>
        <tr>
            <th colspan="6">TOTAL FACTURE : </th>
            <th><input type="text" size="10" name="vTotal" id="vTotal" readonly="readonly" value="<%=Prix(TPoidsReel)%>" /></th>
            <th><input type="text" size="10" name="PoidsFact" id="PoidsFact" readonly="readonly" value="<%=Prix(TPoidsFact)%>" /></th>
            <th></th>
            <th></th>
            <th colspan="2"><input type="text" size="20" name="mtTotal" id="mtTotal" readonly="readonly" value="<%=Prix(Abs(MtReel))%>" /></th>
        </tr> 
    </table>	
	<table width="500" border="0" align="center" cellpadding="0" cellspacing="0" summary="">
		<tr><td width="500" height="20" align="right"><font face="Verdana" size="1">* Les Poids sont exprimés en Kilogrammes</font></td></tr>
	</table>
	<br /><br />
            <input type="hidden" name="Prdt" id="Prdt" value="<%=Prdt%>" />
            <input type="hidden" name="Rclt" id="Rclt" value="<%=Rclt%>" />
            <input type="hidden" name="Camp" id="Camp" value="<%=Camp%>" />
            <input type="hidden" name="Parite" id="Parite" value="<%=Parite%>" />
            <input type="hidden" name="txtOT" id="txtOT" value="--">
			<input type="image" src="../images/frm_ok.gif" alt="Valider la Saisie" id="frm_ok" />
	<br /><br />

</form>

<%
'################
	End If	'' ###  => Fin Option
'################
%>
		











