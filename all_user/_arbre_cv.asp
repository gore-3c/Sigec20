    <!--#include file="../include/inc_con.asp" -->
    <!--#include file="../include/JSON_2.0.4.asp"-->
    <!--#include file="../include/fonction.asp" -->
    <%		
    If Session("Login") = False Or IsNull(Session("Login")) = True Then Response.Redirect "../expire.asp" End If		
                        
    '### - Declaration des Variables            
            Dim rs_Enr, Cmd_Db, Err_Msg, Erreur
            Dim Pm_Code, Pm_Option, Pm_Out, Pm_Id, Pm_Mt, Pm_Typ ', Pm_Search, Search, Zone, rZone
            Dim Code, Count, Choix_Enr, tr, Id, Fo1, Chq, Mt, xType
            Dim jsa, col, QueryToJSON


    '### - Récupération des Variables Session Utilisateur
            Code  = Session("Code")
            Choix_Enr = Request("Choix_Enr")
            Erreur = 0 : Err_Msg = ""

'################################
	If Choix_Enr = "1" Then	' ###  => Choix Effectué - Validation annulation
'################################

    '### - Declaration des Variables

        Id = Request("Id")
        Mt = Request("Mt") 
        xType  = Request("xType")

        
        If Code = "" Or Mt = "" Or Mt = "0" Or Id = 0 Then 
            Err_Msg = "Une Erreur inatendue (0) s'est produite."  
            Err_Msg = Err_Msg & "Veuiller vérifier les informations saisies !" 
            Err_Msg = Err_Msg & "Si l'Erreur persiste, veuillez contacter l'Administrateur !" 
            Erreur = 1
        End If

        If Erreur = 0  then

            '### - Création de la Commande à Exécuter
                Set Cmd_Db = Server.CreateObject("AdoDB.Command")
                    Cmd_Db.ActiveConnection = ado_Con
                    Cmd_Db.CommandText = "Ps_Admin_DUS_Up"
                    Cmd_Db.CommandType = adCmdStoredProc

            '### - Définition des Paramètres de la Procédure Stockée SQL
                Set Pm_Out	    = Cmd_Db.CreateParameter("@Output", adInteger, adParamOutput)				: Cmd_Db.Parameters.Append Pm_Out
                Set Pm_Option	= Cmd_Db.CreateParameter("@Option", adVarChar, adParamInput, 15, "Valide")	: Cmd_Db.Parameters.Append Pm_Option
                Set Pm_Code		= Cmd_Db.CreateParameter("@Code", adVarChar, adParamInput, 3, Code)		    : Cmd_Db.Parameters.Append Pm_Code
                Set Pm_Id       = Cmd_Db.CreateParameter("@Id", adInteger, adParamInput, , Id)          : Cmd_Db.Parameters.Append Pm_Id
                Set Pm_Typ     = Cmd_Db.CreateParameter("@Type", adVarChar, adParamInput, 15, xType)         : Cmd_Db.Parameters.Append Pm_Typ
                Set Pm_Mt       = Cmd_Db.CreateParameter("@Mt", adInteger, adParamInput, , Mt)            : Cmd_Db.Parameters.Append Pm_Mt
            
                Cmd_Db.Execute
                Dim Retour				'### - Vérification du Paramètre de Retour et Affichage du Message de Confirmation
                Set Retour = Pm_Out

                Erreur = 1
                If Retour > 0 Then	 	'### - Aucune Erreur
                    Err_Msg = " DUS corrigé !"
                Else		   			'### - Erreur Rencontrée
                    Erreur = -1                                  	
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

'################################
    ElseIf Choix_Enr = "2" Then ' Rechercher les DUS à traiter
'################################

        Search = ""
        Zone   = Request("Zone")                    
        rZone  = Request("rZone")
        xType  = Request("xType")

        If Zone <> "" Then
            Select Case rZone   
                Case "Fo1" : Search = Search & " And ((F.FO1_EXP like '%" & Zone & "%') Or (F.NUM_FRC like '%" & Zone & "%')) "
                Case "Exp" : Search = Search & " And (E.NOM like '%" & Zone & "%') Or (E.ID_EXP like '%" & Zone & "%') Or (E.ID_EXP = '" & Zone & "') "
            End Select
        End If 

    '### - Création de la Commande à Exécuter
        Set Cmd_Db = Server.CreateObject("AdoDB.Command")
            Cmd_Db.ActiveConnection = ado_Con
            Cmd_Db.CommandText = "Ps_Admin_Arbre_CDC"
            Cmd_Db.CommandType = adCmdStoredProc

    '### - Définition des Paramètres de la Procédure Stockée SQL
        Set Pm_Option   = Cmd_Db.CreateParameter("@Option", adVarChar, adParamInput, 15, "Select") : Cmd_Db.Parameters.Append Pm_Option
        Set Pm_Code     = Cmd_Db.CreateParameter("@Cdc", adVarChar, adParamInput, 15, Code)         : Cmd_Db.Parameters.Append Pm_Code


        '### - Exécution de la Commande SQL
        Set rs_Enr = Cmd_Db.Execute

        tr = "" 
        
        While Not rs_Cdc.Eof 
            If Count = 0 Then                
                geoJson = geoJson & "{""id"":""" & rs_Cdc("id") & """,""type"":""" & rs_Cdc("type") & """,""geometry"":" & rs_Cdc("geometry") & ",""properties"":{""nom"":""" & rs_Cdc("NOM") & """}}"
            Else                
                geoJson = geoJson & ",{""id"":""" & rs_Cdc("id") & """,""type"":""" & rs_Cdc("type") & """,""geometry"":" & rs_Cdc("geometry") & ",""properties"":{""nom"":""" & rs_Cdc("NOM") & """}}"
            End If
            Count = Count + 1
            rs_Cdc.MoveNext
        Wend

        Do While Not (rs_Enr.EOF Or rs_Enr.BOF)
            tr = tr &"<tr>" & vbNewLine &_
                    "    <td> N° FO1 : <input type=""hidden"" name=""xType"" id=""xType"" value=""" & rs_Enr("xType") & """></td>" & vbNewLine &_
                    "    <td colspan=""3"">" & rs_Enr("FO1_EXP") & "</td>" & vbNewLine &_
                    "</tr>" & vbNewLine &_
                    "<tr>" & vbNewLine &_
                    "    <td> Date : </td>" & vbNewLine &_
                    "    <td>" & rs_Enr("FO1_DATE") & "</td>" & vbNewLine &_
                    "    <td> Poids : </td>" & vbNewLine &_
                    "    <td>" & Prix(rs_Enr("POIDS_FO1")) & " T</td>" & vbNewLine &_
                    "</tr>" & vbNewLine &_
                    "<tr>" & vbNewLine &_
                    "    <td> Montant : </td>" & vbNewLine &_
                    "    <td>" & Prix(rs_Enr("CH_MTT")) & "</td>" & vbNewLine &_
                    "    <td> <input type=""hidden"" name=""Id"" id=""Id"" value=""" & rs_Enr("CHQ_ID") & """> " & _
                    "    <input type=""text"" name=""Mt"" id=""Mt"" value=""" & Prix(rs_Enr("CH_MTT")) & """></td>" & vbNewLine &_   
                    "    <td><input type=""button"" id=""btn"" value=""OK"" class=""btn btn-success btn-sm"" /></td>" & vbNewLine &_                    
                    "</tr>"

            rs_Enr.MoveNext
        Loop

        rs_Enr.Close
                    
        Set rs_Enr = Nothing
        Set Cmd_Db = Nothing

        Response.write tr         

'################################
    End If
'################################   
%>