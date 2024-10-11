

<!--#include file="../include/inc_con.asp" -->
<!--#include file="../include/fonction.asp" -->
<!--#include file="../include/encryptions.asp" -->
<!--#include file="../include/JSON_2.0.4.asp"-->

<%	

    If Session("Login") = False Or IsNull(Session("Login")) = True Then Response.Redirect "../_expire.asp" End If	
    
    '### - Declaration des Variables
        Dim Code
        Dim Pm_Code, Pm_Option, Pm_Id, Pm_Out, Pm_Dt
        Dim Count, Nb, Dt, Id, Lien, Url, Nom, Xtype, xOption
        Dim Cmd_Db, rs_Enr
        Dim jsa, col, QueryToJSON, Erreur, Err_Msg

        Code = Session("Code")

	If Request("Choix_Enr") = "0" Then

        Search = "" 'Request("Search")
        xOption = Request("xOption")
                    
        '### - Création de la Commande à Exécuter
            Set Cmd_Db = Server.CreateObject("AdoDB.Command")
                Cmd_Db.ActiveConnection = ado_Con
                Cmd_Db.CommandText = "Ps_Doc_Transfert_CV_Deblocage"
                Cmd_Db.CommandType = adCmdStoredProc

        '### - Définition des Paramètres de la Procédure Stockée SQL		
			Set Pm_Out		= Cmd_Db.CreateParameter("@Output", adInteger, adParamOutput)				: Cmd_Db.Parameters.Append Pm_Out
            Set Pm_Option = Cmd_Db.CreateParameter("@Option", adVarChar, adParamInput, 25, xOption)	: Cmd_Db.Parameters.Append Pm_Option				
            Set Pm_Code	= Cmd_Db.CreateParameter("@Code", adVarChar, adParamInput, 3, Code)		    : Cmd_Db.Parameters.Append Pm_Code
            Set Pm_Search = Cmd_Db.CreateParameter("@Search", adVarChar, adParamInput, 1000, Search): Cmd_Db.Parameters.Append Pm_Search
                                        
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

            Response.Charset = "utf-8"
            QueryToJSON.Flush

	End If

    If Request("Choix_Enr") = "1" Then

        '### - Declaration des Variables

         Id = Request("Id")
        
        If Code = "" Or Id = "" Then 
            Err_Msg = "Une Erreur inatendue (0) s'est produite."  
            Err_Msg = Err_Msg & "Veuiller vérifier les informations saisies !" 
            Err_Msg = Err_Msg & "Si l'Erreur persiste, veuillez contacter l'Administrateur !" 
            Erreur = 1
        End If

        If Erreur = 0  then

            '### - Création de la Commande à Exécuter
                Set Cmd_Db = Server.CreateObject("AdoDB.Command")
                    Cmd_Db.ActiveConnection = ado_Con
                    Cmd_Db.CommandText = "Ps_Doc_Transfert_CV_Deblocage"
                    Cmd_Db.CommandType = adCmdStoredProc

            '### - Définition des Paramètres de la Procédure Stockée SQL
                Set Pm_Out		= Cmd_Db.CreateParameter("@Output", adInteger, adParamOutput)				: Cmd_Db.Parameters.Append Pm_Out
	            Set Pm_Option = Cmd_Db.CreateParameter("@Option", adVarChar, adParamInput, 25, "Valider")	: Cmd_Db.Parameters.Append Pm_Option				
	            Set Pm_Code	= Cmd_Db.CreateParameter("@Code", adVarChar, adParamInput, 3, Code)		    : Cmd_Db.Parameters.Append Pm_Code
	            Set Pm_Search = Cmd_Db.CreateParameter("@Search", adVarChar, adParamInput, 1000, Id): Cmd_Db.Parameters.Append Pm_Search
            
                Cmd_Db.Execute
                Dim Retour				'### - Vérification du Paramètre de Retour et Affichage du Message de Confirmation
                Set Retour = Pm_Out

                Erreur = 1
                If Retour > 0 Then	 	'### - Aucune Erreur
                    Err_Msg = " CV transférées !"
                Else		   			'### - Erreur Rencontrée
                    Erreur = Retour                                 	
                    Err_Msg = Err_Msg & "Une Erreur inatendue N° (" & Retour & ") s'est produite. \n"
                    Err_Msg = Err_Msg & "Veuiller vérifier les informations saisies !\n"
                    Err_Msg = Err_Msg & "Si l'Erreur persiste, veuillez contacter l'Administrateur !"
                End If

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


 %>