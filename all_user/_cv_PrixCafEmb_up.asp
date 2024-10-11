    <!--#include file="../include/inc_con.asp" -->
    <!--#include file="../include/JSON_2.0.4.asp"-->
    <!--#include file="../include/fonction.asp" -->
    <%		
    If Session("Login") = False Or IsNull(Session("Login")) = True Then Response.Redirect "../expire.asp" End If		
                        
    '### - Declaration des Variables            
            Dim rs_Enr, Cmd_Db, Err_Msg, Erreur
            Dim Pm_Code, Pm_Option, Pm_Out, Pm_Id, Pm_Cdc, Pm_Emb, Pm_Caf
            Dim Code, Count, Choix_Enr, tr, Id, Caf, Emb, Cdc
            Dim jsa, col, QueryToJSON


    '### - Récupération des Variables Session Utilisateur            
            Choix_Enr = Request("Choix_Enr")
            Erreur = 0 : Err_Msg = ""
            Code  = Session("Code")

'################################
	If Choix_Enr = "1" Then	' ###  => Choix Effectué - Validation 
'################################

        Id = Request("Id")
        Caf = Replace(Request("Caf"),".",",")
        Emb = Replace(Request("Emb"),".",",")
        
        If Code = "" Or Id = "0" Or Id = "" Or Caf = "" Or Emb = "" Then
            Err_Msg = "Une Erreur inatendue (0) s'est produite."
            Err_Msg = Err_Msg & "Veuiller vérifier les informations saisies !"
            Err_Msg = Err_Msg & "Si l'Erreur persiste, veuillez contacter l'Administrateur !"
            Erreur = -1
        End If

        If Erreur = 0  then

            '### - Création de la Commande à Exécuter
                Set Cmd_Db = Server.CreateObject("AdoDB.Command")
                    Cmd_Db.ActiveConnection = ado_Con
                    Cmd_Db.CommandText = "Ps_Admin_Prix_Ar"
                    Cmd_Db.CommandType = adCmdStoredProc

            '### - Définition des Paramètres de la Procédure Stockée SQL
                Set Pm_Out	    = Cmd_Db.CreateParameter("@Output", adInteger, adParamOutput)				: Cmd_Db.Parameters.Append Pm_Out
                Set Pm_Option	= Cmd_Db.CreateParameter("@Option", adVarChar, adParamInput, 15, "Valide")	: Cmd_Db.Parameters.Append Pm_Option
                Set Pm_Code		= Cmd_Db.CreateParameter("@Code", adVarChar, adParamInput, 3, Code)		    : Cmd_Db.Parameters.Append Pm_Code
                Set Pm_Cdc      = Cmd_Db.CreateParameter("@Cdc", adVarChar, adParamInput, 15, "")         : Cmd_Db.Parameters.Append Pm_Cdc
                Set Pm_Id       = Cmd_Db.CreateParameter("@Id", adInteger, adParamInput, , Id)              : Cmd_Db.Parameters.Append Pm_Id
                Set Pm_Caf      = Cmd_Db.CreateParameter("@Caf", adDouble, adParamInput, , Caf)            : Cmd_Db.Parameters.Append Pm_Caf
                Set Pm_Emb      = Cmd_Db.CreateParameter("@Emb", adDouble, adParamInput, , Emb)            : Cmd_Db.Parameters.Append Pm_Emb

                Cmd_Db.Execute

                Dim Retour				'### - Vérification du Paramètre de Retour et Affichage du Message de Confirmation
                Set Retour = Pm_Out
                
                If Retour > 0 Then	 	'### - Aucune Erreur
                    Erreur = 1
                    Err_Msg = " Traitement effectué !"
                Else		   			'### - Erreur Rencontrée
                    Erreur = -1
                    Err_Msg = Err_Msg & "Une Erreur inatendue (" & Retour & ") s'est produite. \n"
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
        
        Response.Charset = "iso-8859-1"
        QueryToJSON.Flush

'################################
    ElseIf Choix_Enr = "2" Then ' Rechercher les DUS à traiter
'################################

        
        Cdc = Request("Cdc") 
        

    '### - Création de la Commande à Exécuter
        Set Cmd_Db = Server.CreateObject("AdoDB.Command")
            Cmd_Db.ActiveConnection = ado_Con
            Cmd_Db.CommandText = "Ps_Admin_Prix_Ar"
            Cmd_Db.CommandType = adCmdStoredProc

    '### - Définition des Paramètres de la Procédure Stockée SQL
        Set Pm_Out      = Cmd_Db.CreateParameter("@Output", adInteger, adParamOutput)               : Cmd_Db.Parameters.Append Pm_Out
        Set Pm_Option   = Cmd_Db.CreateParameter("@Option", adVarChar, adParamInput, 15, "Select") : Cmd_Db.Parameters.Append Pm_Option
        Set Pm_Code     = Cmd_Db.CreateParameter("@Code", adVarChar, adParamInput, 3, Code)         : Cmd_Db.Parameters.Append Pm_Code     
        Set Pm_Cdc      = Cmd_Db.CreateParameter("@Cdc", adVarChar, adParamInput, 15, Cdc)         : Cmd_Db.Parameters.Append Pm_Cdc   
        Set Pm_Id       = Cmd_Db.CreateParameter("@Id", adInteger, adParamInput, , 0)            : Cmd_Db.Parameters.Append Pm_Id
        Set Pm_Caf      = Cmd_Db.CreateParameter("@Caf", adDouble, adParamInput, ,0)            : Cmd_Db.Parameters.Append Pm_Caf
        Set Pm_Emb      = Cmd_Db.CreateParameter("@Emb", adDouble, adParamInput, , 0)            : Cmd_Db.Parameters.Append Pm_Emb

        '### - Exécution de la Commande SQL
        Set rs_Enr = Cmd_Db.Execute

        tr = "" 

        Do While Not (rs_Enr.EOF Or rs_Enr.BOF)

            tr = tr &"<tr>" & vbNewLine &_
                    "    <td><input type=""hidden"" name=""CDC"" id=""CDC"" value=""" & rs_Enr("CDC_CGFCC") & """> N° CDC : </td>" & vbNewLine &_
                    "    <td colspan=""3"">" & rs_Enr("CDC_CGFCC") & " - " & rs_Enr("PRODUIT") & " </td>" & vbNewLine &_
                    "</tr>" & vbNewLine &_
                    "<tr>" & vbNewLine &_
                    "    <td> PERIODE : </td>" & vbNewLine &_
                    "    <td>" & rs_Enr("PERIODE") & "  " & rs_Enr("CAMPAGNE") & "</td>" & vbNewLine &_
                    "    <td> POIDS : </td>" & vbNewLine &_
                    "    <td>" & PRIX(rs_Enr("NET")) & " KG</td>" & vbNewLine &_
                    "</tr>" & vbNewLine &_
                    "<tr>" & vbNewLine &_
                    "    <td> FORMULES : </td>" & vbNewLine &_
                    "    <td>" & rs_Enr("NB_FO1") & " FO1 DE " & PRIX(rs_Enr("POIDS_FO1")) & " KG</td>" & vbNewLine &_
                    "    <td> SOLDE : </td>" & vbNewLine &_
                    "    <td>" & Prix(rs_Enr("NET")-rs_Enr("POIDS_FO1")) & " KG</td>" & vbNewLine &_
                    "</tr>" & vbNewLine &_
                    "<tr>" & vbNewLine &_
                    "    <td><input type=""hidden"" name=""Id"" id=""Id"" value=""" & rs_Enr("CDC_ID") & """>  </td>" & vbNewLine &_
                    "    <td>PRIX CAF : <input type=""text"" name=""Caf"" id=""Caf"" value=""" & rs_Enr("PRIX_CAF") & """>  </td>" & vbNewLine &_
                    "    <td>PRIX EMB: <input type=""text"" name=""Emb"" id=""Emb"" value=""" & rs_Enr("PRIX_EMB") & """></td>" & vbNewLine &_   
                    "    <td><input type=""button"" id=""btn"" value=""Corriger"" class=""btn btn-success btn-sm"" /></td>" & vbNewLine &_                    
                    "</tr>"
            rs_Enr.MoveNext
        Loop

        rs_Enr.Close
                    
        Set rs_Enr = Nothing
        Set Cmd_Db = Nothing

        If tr = "" Then tr = "<tr><td colspan=""4"">  CE CONTRAT N'EXISTE PAS  </td></tr>" 

        Response.write tr         

'################################
    End If
'################################   
%>