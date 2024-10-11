<!--#include file="../include/inc_con.asp" -->
<!--#include file="../include/fonction.asp" -->
<!--#include file="../include/encryption.asp" -->
<!--#include file="../include/JSON_2.0.4.asp"-->
<%
    If Session("Login") = False Or IsNull(Session("Login")) = True Then Response.Redirect "../_expire.asp" End If

    Dim Id, Code, Nb, Count, Choix_Frm, Err_Msg
    Dim Pm_Out, Pm_Code, Pm_Type, Pm_Id, Pm_Option
    Dim Pm_ListFact, Pm_TypeST, Pm_DtST, Pm_RefST
    Dim rs_Enr, Cmd_Db
    Dim tr, Choix, ListFact, TypeST
    
    Code = Session("Code")
    Choix_Frm = Request("Choix_Frm")

'####################################
	If Choix_Frm = "Yes" Then  ' ###  => Choix Effectue - Validation du traitement de la Facture dans la Base de Donnees
'####################################

    '### - Declaration des Variables
        Dim jsa, col, QueryToJSON

        '### - Récupération des Valeurs de la Formule Sélectionnée
             
                Choix = Request("Choix")
                ListFact = Request("Fo1")
                TypeST = Request("TypeSt")
            
        '### - Déclaration des Variables
                Dim Erreur
                    Erreur = 0
                
        '### - Controle du Formulaire
                    
                If ListFact = ""  Then
                    Err_Msg = Err_Msg & "Une Erreur (0) inatendue s'est produite."
                    Err_Msg = Err_Msg & "Veuiller vérifier les informations saisies !"
                    Err_Msg = Err_Msg & "Si l'Erreur persiste, veuillez contacter l'Administrateur !"
                    Erreur = 1
                End If                    

                If Erreur = 0 Then

                    '### - Création de la Commande a Exécuter
                        Set Cmd_Db = Server.CreateObject("AdoDB.Command")
                            Cmd_Db.ActiveConnection = ado_Con
                            Cmd_Db.CommandText = "Ps_Doc_FactSoutien_St"
                            Cmd_Db.CommandType = adCmdStoredProc
                
                    '### - Définition des Paramètres de la Procédure Stockée SQL
                        Set Pm_Out		= Cmd_Db.CreateParameter("@Output", adInteger, adParamOutput)				: Cmd_Db.Parameters.Append Pm_Out
                        Set Pm_Code		= Cmd_Db.CreateParameter("@Code", adVarChar, adParamInput, 3, Code)			: Cmd_Db.Parameters.Append Pm_Code
                        Set Pm_Option	= Cmd_Db.CreateParameter("@Option", adVarChar, adParamInput, 15, "Valide")	: Cmd_Db.Parameters.Append Pm_Option
                        Set Pm_Id		= Cmd_Db.CreateParameter("@Id", adInteger, adParamInput, , 0) 				: Cmd_Db.Parameters.Append Pm_Id

                        Set Pm_ListFact	= Cmd_Db.CreateParameter("@ListeFact", adVarChar, adParamInput, 800, ListFact)	: Cmd_Db.Parameters.Append Pm_ListFact
                        Set Pm_TypeST	= Cmd_Db.CreateParameter("@TypeST", adVarChar, adParamInput, 10, TypeST)		: Cmd_Db.Parameters.Append Pm_TypeST
                        Set Pm_DtST		= Cmd_Db.CreateParameter("@DateST", adVarChar, adParamInput, 10, "")		: Cmd_Db.Parameters.Append Pm_DtST
                        Set Pm_RefST	= Cmd_Db.CreateParameter("@RefST", adVarChar, adParamInput, 50, "")		: Cmd_Db.Parameters.Append Pm_RefST	
                                                         
                    '### - Exécution de la Commande SQL
                        Cmd_Db.Execute
                                                
                        Dim Retour				'### - Vérification du Paramètre de Retour et Affichage du Message de Confirmation
                        Set Retour = Pm_Out
                        
                        Erreur = 1
                                
                        If Retour > 0 Then	 	'### - Aucune Erreur
                            Err_Msg = "Edition du Soit-Transmis Validée !"				
    %>
                            <script LANGUAGE="JScript">
                                var Fo1 = "'toolbar=yes, menubar=yes, location=no, directories=no, status=yes, resizable=yes, scrollbars=yes width=700, height=500, left=80, top=80";
                                window.open('../all_print/affiche_st_accord.asp<%="?sigec=" & Server.UrlEncode(Encrypt("?Fo1=" & Retour))%>', '', Fo1);
                            </script>  
    <%
                        Else		   	'### - Erreur Rencontrée
                            Err_Msg = Err_Msg & "Une Erreur (" & Retour & ") inatendue s'est produite."
                            Err_Msg = Err_Msg & "Veuiller vérifier les informations saisies !"
                            Err_Msg = Err_Msg & "Si l'Erreur persiste, veuillez contacter l'Administrateur !"
                            Edit	= "0"

                        End If

                        '### - Fermeture des Objets de Connexion
                            Set Cmd_Db  = Nothing
                                
                End If
            
            '### - Faire un retour en JSON
            
                Set jsa = jsArray()
                Set jsa(Null) = jsObject()
                jsa(Null)("Erreur") = Erreur
                jsa(Null)("Err_Msg") = Err_Msg
                Set QueryToJSON = jsa     
                
                Response.Charset = "utf-8"
                QueryToJSON.Flush

'######################################
	Else	  ' ###  => Choix Effectue - Affichage de la Facture a traiter 
'######################################

        '### - Récupération des Valeurs de la Facturee Sélectionnée
                Id = CInt(Request("Id")/365)

        '### - Création de la Commande à Exécuter
                    Set Cmd_Db = Server.CreateObject("AdoDB.Command")
                        Cmd_Db.ActiveConnection = ado_Con
                        Cmd_Db.CommandText = "Ps_Doc_STransmisFactSoutien"
                        Cmd_Db.CommandType = adCmdStoredProc

        '### - Définition des Paramètres de la Procédure Stockée SQL
                Set Pm_Out		= Cmd_Db.CreateParameter("@Output", adInteger, adParamOutput)				: Cmd_Db.Parameters.Append Pm_Out
                Set Pm_Code		= Cmd_Db.CreateParameter("@Code", adVarChar, adParamInput, 3, Code)			: Cmd_Db.Parameters.Append Pm_Code
                Set Pm_Option	= Cmd_Db.CreateParameter("@Option", adVarChar, adParamInput, 15, "Saisie")		: Cmd_Db.Parameters.Append Pm_Option
                Set Pm_Id		= Cmd_Db.CreateParameter("@Id", adInteger, adParamInput, , Id) 				: Cmd_Db.Parameters.Append Pm_Id

                Set Pm_ListFact	= Cmd_Db.CreateParameter("@ListeFact", adVarChar, adParamInput, 800, Id)		: Cmd_Db.Parameters.Append Pm_ListFact
                Set Pm_TypeST	= Cmd_Db.CreateParameter("@TypeST", adVarChar, adParamInput, 10, "")		: Cmd_Db.Parameters.Append Pm_TypeST
                Set Pm_DtST		= Cmd_Db.CreateParameter("@DateST", adVarChar, adParamInput, 10, "")		: Cmd_Db.Parameters.Append Pm_DtST
                Set Pm_RefST	= Cmd_Db.CreateParameter("@RefST", adVarChar, adParamInput, 50, "")		: Cmd_Db.Parameters.Append Pm_RefST			

        '### - Exécution de la Commande SQL
                    Set rs_Enr = Cmd_Db.Execute
                
        '### - Affichage des Résultats de la Procédure SQL												
            
            tr = ""
                    
            While Not rs_Enr.Eof						

                tr = tr & "<tr>" & vbNewLine & _							
                            "	<td>" & rs_Enr("REF_FACTSOUT") & "</td>" & vbNewLine &_
                            "	<td>" & FormatDateTime(rs_Enr("DATE_FACTSOUT"), 2) & "</td>" & vbNewLine &_
                            "	<td>" & rs_Enr("NUM_FACTSOUT") & "</td>" & vbNewLine &_
                            "	<td>" & Prix(rs_Enr("VOL_FACTSOUT")) & "</td>" & vbNewLine &_
                            "	<td>" & Prix(rs_Enr("MONT_FACTSOUT")) & "</td>" & vbNewLine &_									
                            "	<td>" & rs_Enr("NOM") & "</td>" & vbNewLine &_                                    							
                            "</tr>"
                            TypeSt = rs_Enr("ETAT_VALIDE")

                rs_Enr.MoveNext											
                            
            Wend			


        '### - Fermeture des Objets de Connexion
                    
            Set rs_Enr  = Nothing
            Set Cmd_Db = Nothing

'######################################
	End If 						  ' ###  => Fin Validation 
'######################################
%>

<table id="xData" class="table table-striped table-bordered text-nowrap w-100">
    <thead></thead>
    <tbody><%=Id%></tbody>
</table>