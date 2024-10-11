	<!--#include file="../include/inc_con.asp" -->
	<!--#include file="../include/fonction.asp" -->
	<!--#include file="../include/encryption.asp" -->
	<!--#include file="../include/JSON_2.0.4.asp"-->
	
<%		
	If Session("Login") = False Or IsNull(Session("Login")) = True Then Response.Redirect "../_expire.asp" End If		
								
	'### - Declaration des Variables
		Dim Code, Err_Msg, Erreur
		Dim Cmd_Db, rs_Enr
		Dim Pm_Out, Pm_Code, Pm_Type, Pm_Fo1, Pm_Prop
		Dim Img, Fo1, Proper, Choix_Frm, xOption, Count
		Dim jsa, col, QueryToJSON

	'### - Recuperation des Variables Session Utilisateur
		Code  = Session("Code")

	'### - Recuperation des Valeurs du formulaire
		Choix_Frm = Request("Choix_Frm")
		xOption = Request("xOption")
		Proper = Request("Proper")
		Erreur = 0 : Err_Msg = ""

	'### - Controle du Formulaire
		If Proper = ""  Then
			Err_Msg = Err_Msg & "Une Erreur (0) inatendue s'est produite."
			Err_Msg = Err_Msg & "Veuiller verifier les informations saisies !"
			Err_Msg = Err_Msg & "Si l'Erreur persiste, veuillez contacter l'Administrateur !"
			Erreur = 1
		End If

		If Erreur = 0 Then

		'### - Creation de la Commande à Executer
			Set Cmd_Db = Server.CreateObject("AdoDB.Command")
				Cmd_Db.ActiveConnection = ado_Con
				Cmd_Db.CommandText = "Ps_Reajusts_MaJ"
				Cmd_Db.CommandType = adCmdStoredProc

		'### - Definition des Parametres de la Procedure Stockee SQL
			Set Pm_Out		= Cmd_Db.CreateParameter("@Output", adInteger, adParamOutput)				: Cmd_Db.Parameters.Append Pm_Out
			Set Pm_Type		= Cmd_Db.CreateParameter("@Option", adVarChar, adParamInput, 25, xOption)	: Cmd_Db.Parameters.Append Pm_Type
			Set Pm_Code		= Cmd_Db.CreateParameter("@Code", adVarChar, adParamInput, 3, Code)			: Cmd_Db.Parameters.Append Pm_Code
			Set Pm_Prop		= Cmd_Db.CreateParameter("@Code", adVarChar, adParamInput, 3, Proper)		: Cmd_Db.Parameters.Append Pm_Prop

		'####################################
			If Choix_Frm = "MaJ" Then  ' ###  => Choix Effectue - Chargement des donnees
		'####################################

			'### - Exécution de la Commande SQL
				Cmd_Db.Execute

				Dim Retour				'### - Vérification du Parametre de Retour et Affichage du Message de Confirmation
				Set Retour = Pm_Out

				Erreur = 1

				If Retour > 0 Then	 	'### - Aucune Erreur
					Err_Msg = "Chargement des données des ajustements terminé !"					

				Else		   	'### - Erreur Rencontrée
					Err_Msg = Err_Msg & "Une Erreur (" & Retour & ") inatendue s'est produite."
					Err_Msg = Err_Msg & "Veuiller vérifier les informations saisies !"
					Err_Msg = Err_Msg & "Si l'Erreur persiste, veuillez contacter l'Administrateur !"
				End If	

			'### - Fermeture des Objets de Connexion
				Set Cmd_Db  = Nothing

			'### - Faire un retour en JSON
				Set jsa = jsArray()
				Set jsa(Null) = jsObject()
				jsa(Null)("Erreur") = Erreur
				jsa(Null)("Err_Msg") = Err_Msg
				Set QueryToJSON = jsa

		'######################################
			Else	  		  ' ###  => Choix Effectue - Lister les formules à charger 
		'###################################### 

			'### - Exécution de la Commande SQL
            	Set rs_Enr = Cmd_Db.Execute
        
		    '### - Convertir les données en JSON 
		            Count = 0                         
		            Set jsa = jsArray()

		            Do While Not (rs_Enr.EOF Or rs_Enr.BOF)
		                Count = Count + 1
		                Set jsa(Null) = jsObject()
		                For Each col In rs_Enr.Fields
		                   jsa(Null)(col.Name) = col.Value
		                Next                
		                rs_Enr.MoveNext
		            Loop

		            Set jsa(Null) = jsObject()
		            jsa(Null)("Count") = Count                     
		            Set QueryToJSON = jsa

		'######################################
			End If 						  ' ###  => Fin des traitements 
		'######################################

			Response.Charset = "utf-8"
			QueryToJSON.Flush

		End If
%>