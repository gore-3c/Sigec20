	<!--#include file="../include/inc_con.asp" -->
	<!--#include file="../include/fonction.asp" -->
	<!--#include file="../include/encryptions.asp" -->
	<!--#include file="../include/JSON_2.0.4.asp"-->
	
<%		
	If Session("Login") = False Or IsNull(Session("Login")) = True Then Response.Redirect "../expire.asp" End If		
	'If Not Acces_Page   = True Then Response.Redirect "../refuse.asp" & "?sigec=" & Server.UrlEncode(encrypt("?Motif=Menu_Refuse")) End If
								
	'### - Declaration des Variables
		Dim Code, Agree, Trans, Edit, Up_Edit, Erreur
		Dim Frc, Err_Msg, Up_Frc
		Dim Cmd_Db, rs_Fo1, Count, Dt 
		Dim Pm_Out, Pm_Code, Pm_Type, Pm_Fo1, Pm_Prdt, Pm_Dt, Pm_Num
		
		Dim Fo1, Fo1_Option, Url
		Dim Nb, Cool
		Dim LinkBv, bvUrl

		Dim jsa, col, QueryToJSON
				
	'### - Récupération des Variables Session Utilisateur
			Code  = Session("Code")

	'### - Récupération des Options de Validation
			Frc = Request("Frc")
			Up_Frc 	= Decode(request.querystring(encode("Up_Frc"))) 'Sigec("Up_Frc")
	
'####################################
	If Up_Frc = "Yes" Then  ' ###  => Choix Effectué - Validation du Traitement de la Formule dans la Base de Données
'####################################

	'### - Récupération des Valeurs de la Formule Sélectionnée
			Erreur = 0 			
			Dt = Request("Dt")	
			Fo1 = Int(Decode(request.querystring(encode("Fo1"))))
				
	'### - Controle du Formulaire

		If Fo1 = "" Or Dt = "" Or Request("Valider") = "" Then
			Err_Msg = Err_Msg & "Une Erreur inatendue s'est produite."
			Err_Msg = Err_Msg & "Veuiller vérifier les informations saisies !"
			Err_Msg = Err_Msg & "Si l'Erreur persiste, veuillez contacter l'Administrateur !"
			Erreur = 1
		Else
			If Len(Dt) <> 10 And Err_Msg = ""  Then
				Erreur = 1 : Err_Msg = Err_Msg & "Le Format de la Date saisie n'est pas valide <br>Ex (jj/mm/aaaa) : 01/01/2006 !"
			Else
				If IsDate(Dt) = False Then 
					Erreur = 1 : Err_Msg = Err_Msg & "Le Format de la Date saisie n'est pas valide <br>Ex (jj/mm/aaaa) : 01/01/2006 !"
				End If
				If Erreur = 0 Then 
					If CDate(Dt) > Date() Then 
						Erreur = 1 : Err_Msg = Err_Msg & "La Date saisie est supérieure à la Date du Jour !"
					End If
				End If
			End If
			
			If Request("Valider") = "" Then
				Erreur = 1 : Err_Msg = Err_Msg & "Veuillez cocher la case "" Valider "" !"
			End If
		End If
		
		If Erreur = 1 Then
			Frc  = "0"
		End If
			
		If Erreur = 0 Then

			'### - Création de la Commande à Exécuter
				Set Cmd_Db = Server.CreateObject("AdoDB.Command")
					Cmd_Db.ActiveConnection = ado_Con
					Cmd_Db.CommandText = "Ps_Tech_Frc"
					Cmd_Db.CommandType = adCmdStoredProc
		
			'### - Définition des Paramètres de la Procédure Stockée SQL
				Set Pm_Out	= Cmd_Db.CreateParameter("@Output", adInteger, adParamOutput)				: Cmd_Db.Parameters.Append Pm_Out
				Set Pm_Code	= Cmd_Db.CreateParameter("@Code", adVarChar, adParamInput, 3, Code)			: Cmd_Db.Parameters.Append Pm_Code
				Set Pm_Type	= Cmd_Db.CreateParameter("@Type", adVarChar, adParamInput, 25, "Valide")	: Cmd_Db.Parameters.Append Pm_Type
				Set Pm_Fo1	= Cmd_Db.CreateParameter("@Fo1", adInteger, adParamInput, , Fo1) 			: Cmd_Db.Parameters.Append Pm_Fo1
				Set Pm_Dt	= Cmd_Db.CreateParameter("@Date", adVarChar, adParamInput, 10, Dt)			: Cmd_Db.Parameters.Append Pm_Dt

				'Set Pm_Search = Cmd_Db.CreateParameter("@Search", adVarChar, adParamInput, 1000, Null)	: Cmd_Db.Parameters.Append Pm_Search
			
			'### - Exécution de la Commande SQL
				Cmd_Db.Execute
								
		   		Dim Retour				'### - Vérification du Paramètre de Retour et Affichage du Message de Confirmation
				Set Retour = Pm_Out
				
				Erreur = 1
				
				If Retour > 0 Then	 	'### - Aucune Erreur
					Err_Msg = Err_Msg & "Validation de la Formule Effectuée !"						
					Frc = "1" : Edit = "0"

					Log Fo1, "Fo1", "Valiation - Traitement Formule"					

				ElseIf Retour = -4 Then	'### - Erreur Rencontrée
					Err_Msg = Err_Msg & "Ce Numéro a déjà été saisi !"
					Frc	= "0"
				Else		   			'### - Erreur Rencontrée
					Err_Msg = Err_Msg & "Une Erreur " & Retour & " inatendue s'est produite."
					Err_Msg = Err_Msg & "Veuiller vérifier les informations saisies !"
					Err_Msg = Err_Msg & "Si l'Erreur persiste, veuillez contacter l'Administrateur !"
					Frc	= "0"
				End If

			'### - Faire un retour en JSON
				Set jsa = jsArray()
				Set jsa(Null) = jsObject()
				jsa(Null)("Erreur") = Erreur
				jsa(Null)("Err_Msg") = Err_Msg
				Set QueryToJSON = jsa     

				Response.Charset = "utf-8"
				QueryToJSON.Flush
						
		End If

		
						
				
	'### - Fermeture des Objets de Connexion
		Set Cmd_Db  = Nothing

'######################################
	End If 						  ' ###  => Fin Validation 
'######################################	
	If Frc = "" Then	  		  ' ###  => Choix Effectué - Affichage des Formules non Validées Frc 
'######################################

		Search = ""
        Zone   = Request("Zone")					
        rZone  = Request("rZone")

        'Response.Write "Zone:" & Zone & " - " & "rZone:" & rZone
        
        'Zone   = Replace(Zone 	,"'", "''")
        'rZone  = Replace(rZone 	,"'", "''")
        
        Search = " And (Month(FORMULE.FO1_DATE) = " & Month(Now) & " And Year(FORMULE.FO1_DATE) = " & Year(Now) & ") "
        If Zone <> "" Then
            Select Case rZone                    
                Case "Date"	: Search = " And (Month(FORMULE.FO1_DATE) = " & Month(Zone) & " And Year(FORMULE.FO1_DATE) = " & Year(Zone) & ") "
                Case "Exp"	: Search = " And ((EXPORTATEUR.NOM Like '%" & Zone & "%') Or (EXPORTATEUR.EXPORTATEUR Like '%" & Zone & "%')  Or (EXPORTATEUR.ID_EXP = '" & Zone & "')) "                    
                Case "Ref"	: Search = " And (FORMULE.FO1_BCC Like '%" & Zone & "%') "
            End Select
        End If

	'#####################################################
	'#####  Récupération des Formules - Non Validées #####  
	'#####################################################


		'### - Création de la Commande à Exécuter
			Set Cmd_Db = Server.CreateObject("AdoDB.Command")
				Cmd_Db.ActiveConnection = ado_Con
				Cmd_Db.CommandText = "Ps_Tech_Frc_New"
				Cmd_Db.CommandType = adCmdStoredProc
	
		'### - Définition des Paramètres de la Procédure Stockée SQL
			Set Pm_Out	= Cmd_Db.CreateParameter("@Output", adInteger, adParamOutput)			: Cmd_Db.Parameters.Append Pm_Out
			Set Pm_Code	= Cmd_Db.CreateParameter("@Code", adVarChar, adParamInput, 3, Code)		: Cmd_Db.Parameters.Append Pm_Code
			Set Pm_Type	= Cmd_Db.CreateParameter("@Type", adVarChar, adParamInput, 25, "Liste")		: Cmd_Db.Parameters.Append Pm_Type
			Set Pm_Fo1	= Cmd_Db.CreateParameter("@Fo1", adInteger, adParamInput, , 0) 			: Cmd_Db.Parameters.Append Pm_Fo1
			Set Pm_Dt	= Cmd_Db.CreateParameter("@Date", adVarChar, adParamInput, 10, "")		: Cmd_Db.Parameters.Append Pm_Dt

			Set Pm_Search	= Cmd_Db.CreateParameter("@Search", adVarChar, adParamInput, 1000, Search)	: Cmd_Db.Parameters.Append Pm_Search
		
		'### - Exécution de la Commande SQL
			Set rs_Fo1 = Cmd_Db.Execute
				
		'### - Affichage des Résultats de la Procédure SQL
									
			Count = 0
			Fo1   = ""
					
			Dim aUrl, bUrl, w, x

			Set jsa = jsArray()
			'Lien & encode("Id=" & col.Value)
            Do While Not (rs_Fo1.EOF Or rs_Fo1.BOF)
                Count = Count + 1
                Set jsa(Null) = jsObject()
                For Each col In rs_Fo1.Fields
                    If Col.Name = "FO1_ID" Then 
                        jsa(Null)(col.Name) = encode("Fo1=" & col.Value)
                    ElseIf Col.Name = "CDC_ID" Then
                    	jsa(Null)(col.Name) = encode("Cdc=" & col.Value)
                    Else
                        jsa(Null)(col.Name) = col.Value
                    End If
                Next                
                	rs_Fo1.MoveNext
            	Loop

                Set jsa(Null) = jsObject()
                jsa(Null)("Count") = Count                     
                Set QueryToJSON = jsa

                Response.Charset = "utf-8"
                QueryToJSON.Flush
			

		'### - Fermeture des Objets de Connexion
			rs_Fo1.Close
			
			Set rs_Fo1  = Nothing
			Set Cmd_Db = Nothing

'######################################
	End If	' ###  => Fin Option
'######################################
	If Frc = "0" Then  		''	###  => Choix Effectué - Saisie des Informations de Validation de la Fomule Sélectionnée
'######################################

	'### - Récupération des Valeurs de la Formule Sélectionnée
		'Decode(request.querystring(encode("rZone")))
		Fo1 = Decode(request.querystring(encode("Fo1")))
		'Fo1 = Request("Fo1")

		Dim Link, Lot_Bv
		Lot_Bv = 0
		Link = encode("Fo1=" & Fo1)
		'Link = "?Frc=0&Up_Frc=Yes&Fo1=" & Fo1 & rSearch
		'Link = "?sigec=" & Server.UrlEncode(Encrypt(Link))

		'LinkBv = "?Fo1=" & Fo1 & rSearch
		'LinkBv = "?sigec=" & Server.UrlEncode(Encrypt(LinkBv))
		LinkBv = encode("Fo1=" & Fo1)

		bvUrl = "Afficher('Verifi_BV', '../all_print/affiche_lot_bv.asp?" & encode("Fo1=" & Fo1) & "', 100, 100, 600, 500, 0, 0, 0, 1, 1);"
			
		If Request("Dt")  = "" Then Dt  = Date() Else Dt  = Request("Dt")
		''If Request("Num") = "" Then Num = "" 	 Else Num = Request("Num")
			
%>
	<h1>Validation &nbsp;~&nbsp; FRC</h1><br />
	<form action="_perceptions.asp?<%=Link%>" method="post" Name="Frc" id="Frc" enctype="application/x-www-form-urlencoded" target="_self">
	
		<!--include file="../all_user/detail_fo1_redev.asp" -->
	
		<hr />
		<div class="row">
		<% If Int(Lot_Bv) = 0 Then %>	
			<div class="offset-md-4">
				<div class="form-group overflow-hidden">
					<label>Date FRC</label>
					<input type="text" id="Dt" name="Dt" class="form-control w-100" />
				</div>
				<div class="form-group mb-md-0 overflow-hidden">
					<label>Valider</label>
					<input type="checkbox" name="Valider" id="Valider" class="form-control w-100" />
				</div><p class="text-center"><input type="image" src="../images/frm_ok.gif" border="0" alt="Valider l'Edition de la Formule" align="absmiddle" id="frm_ok2"></p>
			</div>
			
		<% Else %>
			<p><b>Vous ne pouvez pas valider la formue: BV périmé(s).</b><br> <a href="javascript:<%=bvUrl%>">Consulter les BV</a></p>
		<% End If %>
		</div>

	</form>

<%		
'######################################
	ElseIf Frc = "1" And Edit = "0" Then  '' ###  => Choix Effectué - Edition de la Formule Sélectionnée (10/07/09)
'######################################			

	'### - Récupération des Valeurs de la Formule Sélectionnée
		Fo1 = Int(Decode(request.querystring(encode("Fo1")))) 'Int(Sigec("Fo1"))
		
		'Link = "?Edit=5&Up_Edit=Yes&Fo1=" & Fo1 & rSearch
		'Link = "?sigec=" & Server.UrlEncode(Encrypt(Link))
			
%>
	<form action="frc.asp?<%=Link%>" method="post" Name="Edition" id="Edition" enctype="application/x-www-form-urlencoded">
	
		<!--include file="../all_user/detail_fo1.asp" -->
	
		<br /><h1>Edition des Formules</h1><br />
	
		<table width="400" border="0" cellpadding="0" cellspacing="0" summary="" align="center">
			<tr><td align="center" valign="middle" width="400" height="50"><input type="checkbox" name="Editer" value="Editer">&nbsp;&nbsp;Editer</td></tr>
			<tr><td align="center" valign="middle" width="400" height="50"><input type="image" src="../images/frm_ok.gif" border="0" alt="Valider l'Edition de la Formule" align="absmiddle" id="frm_ok2"></td></tr>
		</table>
	
	</form>

<%		

'################
	End If	' ###  => Fin Option
'################

	
	'### - Récupération des Options de Validation
		'Edit 	= Sigec("Edit")
		'Up_Edit = Sigec("Up_Edit")
	
'####################################
	If Up_Edit = "Yes" Then  '' ###  => Choix Effectué - Validation de l'Edition de la Formule dans la Base de Données
'####################################

	'### - Récupération des Valeurs de la Formule Sélectionnée
				 Fo1 = Int(Decode(request.querystring(encode("Fo1")))) 'Int(Sigec("Fo1"))

	'### - Déclaration des Variables
				Erreur = 0
								 
	'### - Controle du Formulaire
					
				If Fo1 = "" Or Request("Editer") = "" Then
					Err_Msg = Err_Msg & "Une Erreur  inatendue s'est produite."
					Err_Msg = Err_Msg & "Veuiller vérifier les informations saisies !"
					Err_Msg = Err_Msg & "Si l'Erreur persiste, veuillez contacter l'Administrateur !"
					Erreur = 1
				Else
					If Request("Editer") = "" Then
						Erreur = 1 : Err_Msg = Err_Msg & "Veuillez cocher la case "" Editer "" !"
					End If
					 
				End If
				
				If Erreur = 1 Then
					Edit  = "0" : Frc = "1"
				End If
					
				If Session(Nom_Page) <> "" Then 
					Frc = ""
				Else
					If Erreur = 0 Then
	
						'### - Création de la Commande à Exécuter
								Set Cmd_Db = Server.CreateObject("AdoDB.Command")
									Cmd_Db.ActiveConnection = ado_Con
									Cmd_Db.CommandText = "Ps_Tech_Edit_Fo1"
									Cmd_Db.CommandType = adCmdStoredProc
					
						'### - Définition des Paramètres de la Procédure Stockée SQL
									Set Pm_Out		= Cmd_Db.CreateParameter("@Output", adInteger, adParamOutput)				: Cmd_Db.Parameters.Append Pm_Out
									Set Pm_Code		= Cmd_Db.CreateParameter("@Code", adVarChar, adParamInput, 3, Code)			: Cmd_Db.Parameters.Append Pm_Code
									Set Pm_Type		= Cmd_Db.CreateParameter("@Type", adVarChar, adParamInput, 25, "Valide")	: Cmd_Db.Parameters.Append Pm_Type
									Set Pm_Fo1		= Cmd_Db.CreateParameter("@Fo1", adInteger, adParamInput, , Fo1) 			: Cmd_Db.Parameters.Append Pm_Fo1
									Set Pm_Page		= Cmd_Db.CreateParameter("@Page", adInteger, adParamInput, , 0)				: Cmd_Db.Parameters.Append Pm_Page
									Set Pm_PageSize	= Cmd_Db.CreateParameter("@PageSize", adInteger, adParamInput, , 0)			: Cmd_Db.Parameters.Append Pm_PageSize
		
									Set Pm_Search	= Cmd_Db.CreateParameter("@Search", adVarChar, adParamInput, 1000, Null)	: Cmd_Db.Parameters.Append Pm_Search
						
						'### - Exécution de la Commande SQL
									Cmd_Db.Execute
													
							   		'### - Vérification du Paramètre de Retour et Affichage du Message de Confirmation
									Set Retour = Pm_Out
									
									If Retour > 0 Then	 	'### - Aucune Erreur
										Err_Msg = Err_Msg & "Edition de la Formule Validée !"
										Session(Nom_Page) 	= Retour					
										Frc = ""
										
										Log Fo1, "Fo1", "Edition - Formule" 					
	%>
										<script LANGUAGE="JScript">
											var Fo1 = "'toolbar=yes, menubar=yes, location=no, directories=no, status=yes, resizable=yes, scrollbars=yes width=700, height=500, left=80, top=80";
											window.open('../all_print/formule.asp<%="?sigec=" & Server.UrlEncode(Encrypt("?Fo1=" & Fo1))%>', '', Fo1);
										</script>  
	<%
									Else		   			'### - Erreur Rencontrée
										Err_Msg = Err_Msg & "Une Erreur "& Retour & " inatendue s'est produite."
										Err_Msg = Err_Msg & "Veuiller vérifier les informations saisies !"
										Err_Msg = Err_Msg & "Si l'Erreur persiste, veuillez contacter l'Administrateur !"
										Edit	= "0" : Frc = "1"
									End If
									
					End If
				End If
						
				
				
	'### - Fermeture des Objets de Connexion
				Set Cmd_Db  = Nothing

	'######################################
		End If 						  '' ###  => Fin Validation 
	'######################################
%>
	
















