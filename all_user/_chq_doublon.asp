    <!--#include file="../include/inc_con.asp" -->
    <!--#include file="../include/JSON_2.0.4.asp"-->
    <!--#include file="../include/fonction.asp" -->
<%		
    If Session("Login") = False Or IsNull(Session("Login")) = True Then Response.Redirect "../expire.asp" End If		
                        
    '### - Declaration des Variables            
            Dim rs_Enr, Cmd_Db, Err_Msg, Erreur
            Dim Pm_Code, Pm_Option, Pm_Out, Pm_Id ', Pm_Search, Search, Zone, rZone
            Dim Code, Count, Choix_Enr, tr, Id, Fo1, Chq
            Dim jsa, col, QueryToJSON


    '### - Récupération des Variables Session Utilisateur
            Code  = Session("Code")
            Choix_Enr = Request("Choix_Enr")
            Erreur = 0 : Err_Msg = ""

'################################
	If Choix_Enr = "2" Then	' ###  => Choix Effectué - Validation annulation
'################################

    '### - Declaration des Variables

        Fo1 = CDbl(Request("Chq")) 
        
        If Code = "" Or Fo1 = "" Or Fo1 = "0" Or Fo1 = 0 Then 
            Err_Msg = "Une Erreur inatendue (0) s'est produite."  
            Err_Msg = Err_Msg & "Veuiller vérifier les informations saisies !" 
            Err_Msg = Err_Msg & "Si l'Erreur persiste, veuillez contacter l'Administrateur !" 
            Erreur = 1   
            Err_Msg = "Chq: " & Fo1
        End If

        If Erreur = 0  then

            '### - Création de la Commande à Exécuter
                Set Cmd_Db = Server.CreateObject("AdoDB.Command")
                    Cmd_Db.ActiveConnection = ado_Con
                    Cmd_Db.CommandText = "Ps_Tech_Cheq_Doublon"
                    Cmd_Db.CommandType = adCmdStoredProc

            '### - Définition des Paramètres de la Procédure Stockée SQL
                Set Pm_Out	    = Cmd_Db.CreateParameter("@Output", adInteger, adParamOutput)				: Cmd_Db.Parameters.Append Pm_Out
                Set Pm_Option	= Cmd_Db.CreateParameter("@Option", adVarChar, adParamInput, 15, "Valide")	: Cmd_Db.Parameters.Append Pm_Option
                Set Pm_Code		= Cmd_Db.CreateParameter("@Code", adVarChar, adParamInput, 3, Code)		    : Cmd_Db.Parameters.Append Pm_Code
                Set Pm_Id		= Cmd_Db.CreateParameter("@Fo1", adInteger, adParamInput, , Fo1)		    : Cmd_Db.Parameters.Append Pm_Id
            
                Cmd_Db.Execute
                Dim Retour				'### - Vérification du Paramètre de Retour et Affichage du Message de Confirmation
                Set Retour = Pm_Out

                Erreur = 1
                If Retour > 0 Then	 	'### - Aucune Erreur
                    Err_Msg = " Cheque retiré !"
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
    ElseIf Choix_Enr = "1" Then ' Liste des cheques à traiter
'################################

        Id = Replace(Request("Id"),"#","")        

    '### - Création de la Commande à Exécuter
        Set Cmd_Db = Server.CreateObject("AdoDB.Command")
            Cmd_Db.ActiveConnection = ado_Con
            Cmd_Db.CommandText = "Ps_Tech_Cheq_Doublon"
            Cmd_Db.CommandType = adCmdStoredProc

    '### - Définition des Paramètres de la Procédure Stockée SQL
        Set Pm_Out      = Cmd_Db.CreateParameter("@Output", adInteger, adParamOutput)               : Cmd_Db.Parameters.Append Pm_Out
        Set Pm_Option   = Cmd_Db.CreateParameter("@Option", adVarChar, adParamInput, 15, "Cheques") : Cmd_Db.Parameters.Append Pm_Option
        Set Pm_Code     = Cmd_Db.CreateParameter("@Code", adVarChar, adParamInput, 3, Code)         : Cmd_Db.Parameters.Append Pm_Code
        Set Pm_Id       = Cmd_Db.CreateParameter("@Fo1", adInteger, adParamInput, , Id)            : Cmd_Db.Parameters.Append Pm_Id
        'Set Pm_Search   = Cmd_Db.CreateParameter("@Search", adVarChar, adParamInput, 2000, Search)  : Cmd_Db.Parameters.Append Pm_Search

        '### - Exécution de la Commande SQL
        Set rs_Enr = Cmd_Db.Execute

        tr = "" 

        Do While Not (rs_Enr.EOF Or rs_Enr.BOF)
            Fo1 = rs_Enr("FO1_EXP") 
            tr = tr & "<tr>" & _
                            "<td>" & rs_Enr("STRCT_ID") & "</td>" & vbNewLine &_
                            "<td>" & rs_Enr("STRCT") & "</td>" & vbNewLine &_
                            "<td>" & rs_Enr("CH_REF") & "</td>" & vbNewLine &_
                            "<td class=""text-right"">" & Prix(rs_Enr("CH_MTT")) & "</td>" & vbNewLine &_
                            "<td>" & rs_Enr("CH_DATE") & "</td>" & vbNewLine &_
                            "<td><input type=""checkbox"" name=""wTaxe_" & rs_Enr("CHQ_ID") & """ id=""wTaxe_" & rs_Enr("CHQ_ID") & """ class=""form-control"" /></td>" & vbNewLine &_
                    "</tr>"
            rs_Enr.MoveNext
        Loop

        rs_Enr.Close
                    
        Set rs_Enr = Nothing
        Set Cmd_Db = Nothing
%>
    <h2 class="text-center"><%=Fo1%></h2>
    <input type="hidden" name="Fo1" id="Fo1" value="<%=Id%>">
    <table class="table table-hover">
        <thead>
            <tr>
                <th>#</th>
                <th>Taxe</th>
                <th>N° Cheque</th>
                <th>Montant</th>
                <th>Date</th>
                <th>#</th>
            </tr>
        </thead>
        <tbody><%=tr%></tbody>
    </table>
<%            

'################################
    Else
'################################   
       
        Search = ""
        Zone   = Request("Zone")                    
        rZone  = Request("rZone")

        If Zone <> "" Then
            Select Case rZone   
                Case "Fo1" : Search = Search & " And ((F.FO1_EXP like '%" & Zone & "%') Or (F.NUM_FRC like '%" & Zone & "%')) "
                Case "Exp" : Search = Search & " And (E.NOM like '%" & Zone & "%') Or (E.ID_EXP like '%" & Zone & "%') Or (E.ID_EXP = '" & Zone & "') "
            End Select
        End If

'### - Création de la Commande à Exécuter
        Set Cmd_Db = Server.CreateObject("AdoDB.Command")
            Cmd_Db.ActiveConnection = ado_Con
            Cmd_Db.CommandText = "Ps_Tech_Cheq_Doublon"
            Cmd_Db.CommandType = adCmdStoredProc

    '### - Définition des Paramètres de la Procédure Stockée SQL
        Set Pm_Out      = Cmd_Db.CreateParameter("@Output", adInteger, adParamOutput)              : Cmd_Db.Parameters.Append Pm_Out
        Set Pm_Option   = Cmd_Db.CreateParameter("@Option", adVarChar, adParamInput, 15, "Liste")   : Cmd_Db.Parameters.Append Pm_Option
        Set Pm_Code     = Cmd_Db.CreateParameter("@Code", adVarChar, adParamInput, 3, Code)         : Cmd_Db.Parameters.Append Pm_Code
        Set Pm_Id       = Cmd_Db.CreateParameter("@Fo1", adInteger, adParamInput, , 0)              : Cmd_Db.Parameters.Append Pm_Id
        Set Pm_Search   = Cmd_Db.CreateParameter("@Search", adVarChar, adParamInput, 2000, Search)  : Cmd_Db.Parameters.Append Pm_Search
                                    
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

        Set rs_Enr = Nothing

        Set jsa(Null) = jsObject()
        jsa(Null)("Count") = Count                     
        Set QueryToJSON = jsa

        Response.Charset = "utf-8"
        QueryToJSON.Flush

'################################
    End If
'################################   
%>