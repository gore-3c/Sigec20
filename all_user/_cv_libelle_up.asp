    <!--#include file="../include/inc_con.asp" -->
    <!--#include file="../include/JSON_2.0.4.asp"-->
    <!--#include file="../include/fonction.asp" -->
    <%		
    If Session("Login") = False Or IsNull(Session("Login")) = True Then Response.Redirect "../expire.asp" End If		
                        
    '### - Declaration des Variables            
            Dim rs_Enr, Cmd_Db, Err_Msg, Erreur
            Dim Pm_Code, Pm_Option, Pm_Out, Pm_Id
            Dim Code, Count, Choix_Enr, tr, Id, Cdc, vApure, vQte, vRec
            Dim jsa, col, QueryToJSON


    '### - Récupération des Variables Session Utilisateur            
            Choix_Enr = Request("Choix_Enr")
            Erreur = 0 : Err_Msg = ""
            Code  = Session("Code")

'################################
	If Choix_Enr = "1" Then	' ###  => Choix Effectué - Validation 
'################################

        Id = Request("Id")
        vRec = Request("vRec")
        vQte = Request("vQte")
        vApure = Request("vApure")
        
        If Code = "" Or Id = "0" Or Id = "" Then
            Err_Msg = "Une Erreur inatendue (0) s'est produite."
            Err_Msg = Err_Msg & "Veuiller vérifier les informations saisies !"
            Err_Msg = Err_Msg & "Si l'Erreur persiste, veuillez contacter l'Administrateur !"
            Erreur = -1
        End If

        If Erreur = 0  then

            '### - Création de la Commande à Exécuter
                Set Cmd_Db = Server.CreateObject("AdoDB.Command")
                    Cmd_Db.ActiveConnection = ado_Con
                    Cmd_Db.CommandText = "Ps_Admin_Libelle_Up"
                    Cmd_Db.CommandType = adCmdStoredProc

            '### - Définition des Paramètres de la Procédure Stockée SQL
                Set Pm_Out	    = Cmd_Db.CreateParameter("@Output", adInteger, adParamOutput)				: Cmd_Db.Parameters.Append Pm_Out
                Set Pm_Option	= Cmd_Db.CreateParameter("@Option", adVarChar, adParamInput, 15, "Valide")	: Cmd_Db.Parameters.Append Pm_Option
                Set Pm_Code		= Cmd_Db.CreateParameter("@Code", adVarChar, adParamInput, 3, Code)		    : Cmd_Db.Parameters.Append Pm_Code
                Set Pm_Cdc		= Cmd_Db.CreateParameter("@Cdc", adVarChar, adParamInput, 15, "")		    : Cmd_Db.Parameters.Append Pm_Cdc
                Set Pm_Id       = Cmd_Db.CreateParameter("@Id", adInteger, adParamInput, , Id)              : Cmd_Db.Parameters.Append Pm_Id
                Set Pm_Apu       = Cmd_Db.CreateParameter("@vApure", adInteger, adParamInput, , vApure)     : Cmd_Db.Parameters.Append Pm_Apu
                Set Pm_Qte       = Cmd_Db.CreateParameter("@vQte", adInteger, adParamInput, , vQte)         : Cmd_Db.Parameters.Append Pm_Qte
                Set Pm_Rec       = Cmd_Db.CreateParameter("@vRec", adInteger, adParamInput, , vRec)         : Cmd_Db.Parameters.Append Pm_Rec
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
            Cmd_Db.CommandText = "Ps_Admin_Libelle_Up"
            Cmd_Db.CommandType = adCmdStoredProc

    '### - Définition des Paramètres de la Procédure Stockée SQL
        Set Pm_Out      = Cmd_Db.CreateParameter("@Output", adInteger, adParamOutput)               : Cmd_Db.Parameters.Append Pm_Out
        Set Pm_Option   = Cmd_Db.CreateParameter("@Option", adVarChar, adParamInput, 15, "Select") : Cmd_Db.Parameters.Append Pm_Option
        Set Pm_Code     = Cmd_Db.CreateParameter("@Code", adVarChar, adParamInput, 3, Code)         : Cmd_Db.Parameters.Append Pm_Code
        Set Pm_Cdc      = Cmd_Db.CreateParameter("@Cdc", adVarChar, adParamInput, 15, Cdc)  : Cmd_Db.Parameters.Append Pm_Cdc

        '### - Exécution de la Commande SQL
        Set rs_Enr = Cmd_Db.Execute

        tr = "" 
        Dim vRec_Check, vApure_Check, vQte_Check
            vRec_Check = "" : vApure_Check = "" : vQte_Check = ""
        
        Do While Not (rs_Enr.EOF Or rs_Enr.BOF)
        
            If rs_Enr("AR_RECOLTE") = 1 Then vRec_Check = " checked"
            If rs_Enr("AR_TONNAGE") = 1 Then vQte_Check = " checked"
            If rs_Enr("LIB_APURE") = 1 Then vApure_Check = " checked"

            tr = tr & "<table class=""table table-bordered"">" &
                        "<tr>" & vbNewLine &_
                        "    <td> N° CDC : " & rs_Enr("CDC_CGFCC") & "</td>" & vbNewLine &_
                        "    <td> NOM : " & rs_Enr("NOM") & "</td>" & vbNewLine &_
                        "</tr>" & vbNewLine &_
                        "<tr>" & vbNewLine &_
                        "    <td> DIMUNITION : <input type=""checkbox"" id=""vRec_" & k & """ name=""vRec_" & k & """ " & vRec_Check & " /></td>" & vbNewLine &_
                        "    <td> LIBELLE : " & rs_Enr("AR_RECOLTE") & "</td>" & vbNewLine &_
                        "</tr>" & vbNewLine &_
                        "<tr>" & vbNewLine &_
                            "    <td> APUREMENT : <input type=""checkbox"" id=""vApure_" & k & """ name=""vApure_" & k & """ " & vApure_Check & " /></td>" & vbNewLine &_
                            "    <td> LIBELLE : " & rs_Enr("LIB_APURE") & "</td>" & vbNewLine &_
                        "</tr>" & vbNewLine &_
                        "<tr>" & vbNewLine &_
                        "    <td> <input type=""hidden"" name=""Cdc_" & k & """ id=""Cdc_" & k & """ value=""" & rs_Enr("CDC_ID") & """></td>" & vbNewLine &_
                        "    <td><input type=""button"" id=""btn_" & k & """ value=""Enregistrer"" class=""btn btn-success btn-sm"" /></td>" & vbNewLine &_
                        "</tr></table>"
            rs_Enr.MoveNext
        Loop

        rs_Enr.Close
                    
        Set rs_Enr = Nothing
        Set Cmd_Db = Nothing

        If tr = "" Then tr = "<tr><td colspan=""4"">  Ce contrat n'existe pas ou est déja Parametré </td></tr>" 

        Response.write tr         

'################################
    End If
'################################   
%>