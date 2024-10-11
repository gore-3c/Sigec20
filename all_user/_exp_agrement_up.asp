	<!--#include file="../include/inc_con.asp" -->
    <!--#include file="../include/JSON_2.0.4.asp"-->

<%
    
'### - Declaration des Variables
	Dim Code, Prdt, Erreur, Err_Msg, Count
	Dim Cmd_Db, rs_Enr, Choix, Id, Motif
    Dim Pm_Option, Pm_Out, Pm_Id, Pm_Code, Pm_Camp, Pm_Motif

    Dim Pm_Exp, Pm_Search
    Dim Exp, Search, vAgree

	Dim jsa, col, QueryToJSON, Ps_Name, xOption, xType, Camp	
    
'### - Récupération des Variables Session Utilisateur
		Code  = Session("Code")

'### - Récupération des Valeurs de parametres
        Exp = Request("Exp")
        Camp = Request("Camp")
        Motif = Request("Motif")
        xOption = Request("xOption") 

        If Camp = "" Then Camp = 0
        If vAgree = "" Then vAgree = 0

        Erreur = 0
        Err_Msg = ""

        If Code = "" Or Exp = "" Then 
            Err_Msg = "Une Erreur inatendue (0) s'est produite. "
            Err_Msg = Err_Msg & "Veuiller vérifier les informations saisies ! " 
            Err_Msg = Err_Msg & "Si l'Erreur persiste, veuillez contacter l'Administrateur ! " 
            Erreur = -1
        End If

        If Erreur = 0 Then

            '### - Création de la Commande à Exécuter
                Set Cmd_Db = Server.CreateObject("AdoDB.Command")
                    Cmd_Db.ActiveConnection = ado_Con
                    Cmd_Db.CommandText = "Ps_Doc_Agrement_Exp"
                    Cmd_Db.CommandType = adCmdStoredProc

            '### - Définition des Paramètres de la Procédure Stockée SQL
                Set Pm_Out	    = Cmd_Db.CreateParameter("@Output", adInteger, adParamOutput)				: Cmd_Db.Parameters.Append Pm_Out
                Set Pm_Option = Cmd_Db.CreateParameter("@Option", adVarChar, adParamInput, 25, xOption)	: Cmd_Db.Parameters.Append Pm_Option				
                Set Pm_Code	= Cmd_Db.CreateParameter("@Code", adVarChar, adParamInput, 3, Code)			: Cmd_Db.Parameters.Append Pm_Code
                Set Pm_Exp	= Cmd_Db.CreateParameter("@Exp", adVarChar, adParamInput, 3, Exp)	        : Cmd_Db.Parameters.Append Pm_Exp
                
                Set Pm_Camp = Cmd_Db.CreateParameter("@Camp", adInteger, adParamInput, , Camp)	      : Cmd_Db.Parameters.Append Pm_Camp
                Set Pm_Motif	= Cmd_Db.CreateParameter("@Motif", adVarChar, adParamInput, 100, Motif)		: Cmd_Db.Parameters.Append Pm_Motif
                                           
            '### - Exécution de la Commande SQL
                Cmd_Db.Execute

                Dim Retour				'### - Vérification du Paramètre de Retour et Affichage du Message de Confirmation
                Set Retour = Pm_Out

                Erreur = 1
                If Retour > 0 Then	 	'### - Aucune Erreur
                    Err_Msg = " Statut exportateur modifié !"
                Else		   			'### - Erreur Rencontrée
                    Erreur = -1                                  	
                    Err_Msg = Err_Msg & "Une Erreur inatendue N° (" & Retour & ") s'est produite. \n" 
                    Err_Msg = Err_Msg & "Veuiller vérifier les informations saisies !\n" 
                    Err_Msg = Err_Msg & "Si l'Erreur persiste, veuillez contacter l'Administrateur !" 
                End If

        End If                        
         
        Set jsa = jsArray()
        Set jsa(Null) = jsObject()
        jsa(Null)("Erreur") = Erreur
        jsa(Null)("Err_Msg") = Err_Msg
        Set QueryToJSON = jsa     
        

        Response.Charset = "utf-8"
        QueryToJSON.Flush			
        

%>