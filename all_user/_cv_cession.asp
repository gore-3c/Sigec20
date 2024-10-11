    <!--#include file="../include/inc_con.asp" -->
    <!--#include file="../include/JSON_2.0.4.asp"-->
    <!--#include file="../include/fonction.asp" -->
    <%		
    If Session("Login") = False Or IsNull(Session("Login")) = True Then Response.Redirect "../expire.asp" End If		
                        
    '### - Declaration des Variables            
            Dim rs_Enr, Cmd_Db, Err_Msg, Erreur
            Dim Pm_Code, Pm_Option, Pm_Out, Pm_Id, Pm_Cdc, Pm_Exp, Pm_Ref, Pm_Dt
            Dim Code, Count, Choix_Enr, tr, Id, Dt, Ref, Exp, Cdc
            Dim jsa, col, QueryToJSON


    '### - Récupération des Variables Session Utilisateur            
            Choix_Enr = Request("Choix_Enr")
            Erreur = 0 : Err_Msg = ""
            Code  = Session("Code")

'################################
	If Choix_Enr = "1" Then	' ###  => Choix Effectué - Validation 
'################################

        Dt = Request("Dt")
        Id = Request("Id")
        Ref = Request("Ref")
        Exp = Request("Exp")
        
        If Code = "" Or Id = "0" Or Id = "" Or Dt = "" Or Ref = "" Or Exp = "" Then
            Err_Msg = "Une Erreur inatendue (0) s'est produite."
            Err_Msg = Err_Msg & "Veuiller vérifier les informations saisies !"
            Err_Msg = Err_Msg & "Si l'Erreur persiste, veuillez contacter l'Administrateur !"
            Erreur = -1
        End If

        If Erreur = 0  then

            '### - Création de la Commande à Exécuter
                Set Cmd_Db = Server.CreateObject("AdoDB.Command")
                    Cmd_Db.ActiveConnection = ado_Con
                    Cmd_Db.CommandText = "Ps_Admin_Cession_Contrat"
                    Cmd_Db.CommandType = adCmdStoredProc

            '### - Définition des Paramètres de la Procédure Stockée SQL
                Set Pm_Out	    = Cmd_Db.CreateParameter("@Output", adInteger, adParamOutput)				: Cmd_Db.Parameters.Append Pm_Out
                Set Pm_Option	= Cmd_Db.CreateParameter("@Option", adVarChar, adParamInput, 15, "Valide")	: Cmd_Db.Parameters.Append Pm_Option
                Set Pm_Code		= Cmd_Db.CreateParameter("@Code", adVarChar, adParamInput, 3, Code)		    : Cmd_Db.Parameters.Append Pm_Code
                Set Pm_Id       = Cmd_Db.CreateParameter("@Id", adInteger, adParamInput, , Id)              : Cmd_Db.Parameters.Append Pm_Id
                Set Pm_Cdc      = Cmd_Db.CreateParameter("@Cdc", adVarChar, adParamInput, 15, "")           : Cmd_Db.Parameters.Append Pm_Cdc
                Set Pm_Exp      = Cmd_Db.CreateParameter("@Exp", adVarChar, adParamInput, 15, Exp)          : Cmd_Db.Parameters.Append Pm_Exp
                Set Pm_Ref      = Cmd_Db.CreateParameter("@Ref", adVarChar, adParamInput, 100, Ref)          : Cmd_Db.Parameters.Append Pm_Ref
                Set Pm_Dt       = Cmd_Db.CreateParameter("@Dt", adVarChar, adParamInput, 10, Dt)            : Cmd_Db.Parameters.Append Pm_Dt
                
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
            Cmd_Db.CommandText = "Ps_Admin_Cession_Contrat"
            Cmd_Db.CommandType = adCmdStoredProc

    '### - Définition des Paramètres de la Procédure Stockée SQL
        Set Pm_Out      = Cmd_Db.CreateParameter("@Output", adInteger, adParamOutput)               : Cmd_Db.Parameters.Append Pm_Out
        Set Pm_Option   = Cmd_Db.CreateParameter("@Option", adVarChar, adParamInput, 15, "Select") : Cmd_Db.Parameters.Append Pm_Option
        Set Pm_Code     = Cmd_Db.CreateParameter("@Code", adVarChar, adParamInput, 3, Code)         : Cmd_Db.Parameters.Append Pm_Code        
        Set Pm_Id       = Cmd_Db.CreateParameter("@Id", adInteger, adParamInput, , 0)            : Cmd_Db.Parameters.Append Pm_Id
        Set Pm_Cdc     = Cmd_Db.CreateParameter("@Cdc", adVarChar, adParamInput, 15, Cdc)         : Cmd_Db.Parameters.Append Pm_Cdc        

        '### - Exécution de la Commande SQL
        Set rs_Enr = Cmd_Db.Execute

        tr = "" 
        Dim ExpListe, Nb
        Nb = 1 : ExpListe = "<option value="""">Eportateurs agréés</option>"
        Do Until rs_Enr Is Nothing

            Count = 0 

			While Not rs_Enr.Eof

            '############################
                If Nb = 1 Then		' ###  => Jeu de Résultats N° 1 - Liste des Exportateurs agrees
            '############################
                
                ExpListe = ExpListe & "<option value=""" & rs_Enr("ID_EXP") & """>" & rs_Enr("NOM") & "</option>"

            '############################
                ElseIf Nb = 2 Then	' ###  => Jeu de Résultats N° 2 - Formulaire de Cession
            '############################ 

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
                        "    <td><input type=""text"" name=""Dt"" id=""Dt"" class=""form-control"" placeholder=""jj/mm/aaaa"" /> </td>" & vbNewLine &_
                        "    <td><input id=""Ref"" name=""Ref"" class=""form-control"" placeholder=""REFERENCE"" /></td>" & vbNewLine &_
                        "    <td><select id=""Exp"" name=""Exp"" class=""form-control"">" & ExpListe & "</select><input type=""hidden"" name=""Id"" id=""Id"" value=""" & rs_Enr("ENR_ID") & """></td>" & vbNewLine &_
                        "    <td><input type=""button"" id=""btn"" value=""Ceder"" class=""btn btn-success btn-sm"" /></td>" & vbNewLine &_
                        "</tr>"

                '###############
                    End If ' ###  => Fin de Sélection du Jeu de Résultat 
                '###############
                
                Count = Count + 1
                
                rs_Enr.MoveNext
                
            Wend
            
            Set rs_Enr = rs_Enr.NextRecordset
            
            Nb = Nb + 1
            
        Loop
        'rs_Enr.Close

        Set rs_Enr = Nothing
        Set Cmd_Db = Nothing

        If tr = "" Then tr = "<tr><td colspan=""4"">  CE CONTRAT N'EXISTE PAS </td></tr>" 

        Response.write tr         

'################################
    End If
'################################   
%>