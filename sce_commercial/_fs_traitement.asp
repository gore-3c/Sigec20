<!--#include file="../include/inc_con.asp" -->
<!--#include file="../include/fonction.asp" -->
<!--#include file="../include/encryption.asp" -->
<!--#include file="../include/JSON_2.0.4.asp"-->
<%
    If Session("Login") = False Or IsNull(Session("Login")) = True Then Response.Redirect "../_expire.asp" End If

    Dim Id, Code, Nb, Count, Choix_Frm, Err_Msg
    Dim Pm_Out, Pm_Code, Pm_Type, Pm_Id
    Dim rs_Enr, Cmd_Db
    Dim xTContrat, xEtat, rMotif, idMotif
    Dim Pm_Ctrt, Pm_Etat, Pm_Rejet, Pm_Motif, Pm_LsFrm

    Code = Session("Code")
    Choix_Frm = Request("Choix_Frm")

'####################################
	If Choix_Frm = "Yes" Then  ' ###  => Choix Effectue - Validation du traitement de la Facture dans la Base de Donnees
'####################################

    '### - Declaration des Variables
        Dim jsa, col, QueryToJSON

    '### - Récupération des Valeurs de la Formule Sélectionnée
        Id = Int(Request("Id"))
        xTContrat = Request("typeContrat")
        xEtat = Request("Choix")

        rMotif = ""
        If xEtat = "Rejet" Then 
            rMotif = Request("rMotif")
            idMotif = Request("idMotif")
        End If

    '### - Déclaration des Variables
        Dim Erreur
        Erreur = 0

    '### - Controle du Formulaire

        If Id = "" Or xTContrat = "" Or xEtat = "" Then
            Err_Msg = Err_Msg & "Une Erreur (0) inatendue s'est produite."
            Err_Msg = Err_Msg & "Veuiller vérifier les informations saisies !"
            Err_Msg = Err_Msg & "Si l'Erreur persiste, veuillez contacter l'Administrateur !"
            Erreur = 1
        End If

        If Erreur = 0 Then

            '### - Création de la Commande à Exécuter
                Set Cmd_Db = Server.CreateObject("AdoDB.Command")
                    Cmd_Db.ActiveConnection = ado_Con
                    Cmd_Db.CommandText = "Ps_Doc_FactSoutien"
                    Cmd_Db.CommandType = adCmdStoredProc

            '### - Définition des Paramètres de la Procédure Stockée SQL
                Set Pm_Out		= Cmd_Db.CreateParameter("@Output", adInteger, adParamOutput)				: Cmd_Db.Parameters.Append Pm_Out
                Set Pm_Code		= Cmd_Db.CreateParameter("@Code", adVarChar, adParamInput, 3, Code)			: Cmd_Db.Parameters.Append Pm_Code
                Set Pm_Type		= Cmd_Db.CreateParameter("@Option", adVarChar, adParamInput, 25, "Valide")	: Cmd_Db.Parameters.Append Pm_Type
                Set Pm_Id		= Cmd_Db.CreateParameter("@Id", adInteger, adParamInput, , Id) 			    : Cmd_Db.Parameters.Append Pm_Id

                Set Pm_Search   = Cmd_Db.CreateParameter("@Search", adVarChar, adParamInput, 8000, "")      : Cmd_Db.Parameters.Append Pm_Search
                Set Pm_LsFrm    = Cmd_Db.CreateParameter("@ListForm", adVarChar, adParamInput, 2000, "")    : Cmd_Db.Parameters.Append Pm_LsFrm

                Set Pm_Ctrt	    = Cmd_Db.CreateParameter("@TContrat", adVarChar, adParamInput, 25, xTContrat)   : Cmd_Db.Parameters.Append Pm_Ctrt
                Set Pm_Etat	    = Cmd_Db.CreateParameter("@Etat", adVarChar, adParamInput, 6, xEtat)	        : Cmd_Db.Parameters.Append Pm_Etat
                Set Pm_Rejet	= Cmd_Db.CreateParameter("@Rejet", adVarChar, adParamInput, 300, rMotif)	    : Cmd_Db.Parameters.Append Pm_Rejet
                'Set Pm_Motif	= Cmd_Db.CreateParameter("@Str_Rejet", adVarChar, adParamInput, 1000, idMotif)	: Cmd_Db.Parameters.Append Pm_Motif
                
            '### - Exécution de la Commande SQL
                Cmd_Db.Execute

                Dim Retour	'### - Vérification du Paramètre de Retour et Affichage du Message de Confirmation
                Set Retour = Pm_Out

                Erreur = 1

                If Retour > 0 Then	 	'### - Aucune Erreur
                    Err_Msg = Err_Msg & " Facture soutien Validee ! "

                Else        '### - Erreur Rencontrée
                    Err_Msg = Err_Msg & "Une Erreur (" & Retour & ") inatendue s'est produite."
                    Err_Msg = Err_Msg & "Veuiller vérifier les informations saisies !"
                    Err_Msg = Err_Msg & "Si l'Erreur persiste, veuillez contacter l'Administrateur !"
                    Edit	= "0"
                End If

            '### - Fermeture des Objets de Connexion
                    Set Cmd_Db  = Nothing

                Set jsa = jsArray()
                Set jsa(Null) = jsObject()
                jsa(Null)("Erreur") = Erreur
                jsa(Null)("Err_Msg") = Err_Msg
                Set QueryToJSON = jsa
                
                Response.Charset = "utf-8"
                QueryToJSON.Flush

        End If 

'######################################
	Else	  		  ' ###  => Choix Effectue - Affichage de la Facture a traiter 
'######################################

        Id = CInt(Request("Id")/365)
        Code = Session("Code")

    '### - Création de la Commande à Exécuter
        Set Cmd_Db = Server.CreateObject("AdoDB.Command")
            Cmd_Db.ActiveConnection = ado_Con
            Cmd_Db.CommandText = "Ps_Doc_FactSoutien"
            Cmd_Db.CommandType = adCmdStoredProc

    '### - Définition des Paramètres de la Procédure Stockée SQL
                Set Pm_Out		= Cmd_Db.CreateParameter("@Output", adInteger, adParamOutput)				: Cmd_Db.Parameters.Append Pm_Out
                Set Pm_Code		= Cmd_Db.CreateParameter("@Code", adVarChar, adParamInput, 3, Code)			: Cmd_Db.Parameters.Append Pm_Code
                Set Pm_Type		= Cmd_Db.CreateParameter("@Type", adVarChar, adParamInput, 25, "Saisie")	: Cmd_Db.Parameters.Append Pm_Type
                Set Pm_Id		= Cmd_Db.CreateParameter("@Fo1", adInteger, adParamInput, , Id) 			: Cmd_Db.Parameters.Append Pm_Id						

    '### - Exécution de la Commande SQL
                Set rs_Enr = Cmd_Db.Execute

    '### - Affichage des Résultats de la Procédure SQL									
            Nb = 1
        Dim tabTransmis, tabMotif, nFact, tabFact, tabFo1, TypeContrat
        Dim sTPoids, sPReel, sPFact, sTotal, sMont, Per1, Per2, k, sEcart, Ecart
        Dim TPoids, Total, PReel, PFact, Mont, Periode
            sPReel = 0 : sTPoids = 0 : sTotal = 0 : sPFact = 0 : sMont = 0 : i = 0 : k = 0 : Per1 = "" : Per2 = ""
            PReel = 0 : TPoids = 0 : PFact = 0 : Mont = 0 : Total = 0
            sEcart = 0 :  Ecart = 0

        tabMotif = ""

        Do Until rs_Enr Is Nothing
                    
            While Not rs_Enr.Eof
                        
                '############################
                    If Nb = 1 Then		' ###  => Jeu de Résultats N0 1 - Informations de la facture globale sélectionnée	
                '############################

                        nFact = rs_Enr("REF_FACTSOUT")
                            
                        tabFact = "<tr><td><strong>Campagne</strong></td><td>: " & rs_Enr("CAMPAGNE") & "</td><td><strong>No Facture Exp.</strong><td><td>: " & rs_Enr("REF_FACTSOUT") & "</td></tr>" & vbNewLine &_  
                                "<tr><td><strong>Produit</strong></td><td>: " & rs_Enr("PRODUIT") & "</td><td><strong>Date Facture</strong> <td><td>: " & rs_Enr("DATE_FACTSOUT") & "</td></tr>" & vbNewLine &_ 
                                "<tr><td><strong>Récolte</strong></td><td>: " & rs_Enr("RECOLTE") & "</td><td><strong>Domiciliation</strong><td><td>: " & rs_Enr("BANK") & "</td></tr>" & vbNewLine
                    
                '############################
                    ElseIf Nb = 2 Then	' ###  => Jeu de Résultats N 1 - Liste des formules de la facture
                '############################
                        
                        Per1 = rs_Enr("PERIODE")  
                        If Per1 <> Per2  Then 
                            If tabFo1 <> "" Then   
                                                                    
                                tabFo1 = tabFo1 & _
                                    "<tr bgcolor=""#EEEEEE"">" & _
                                        "<td colspan=""2""><b>S/TOTAL " & Periode & "</b> : </td>" & _
                                        "<td><b>" & Prix(sTPoids) & "</b></td>" & _
                                        "<td><b>" & Prix(sPReel) & "</b></td>" & _ 
                                        "<td><b>" & Prix(sPFact) & "</b></td>" & _   
                                        "<td><b>" & Prix(sEcart) & "</b></td>" & _
                                        "<td><b>" & Round(sEcart*100/sTPoids,3) & "</b></td>" & _                                             
                                        "<td> - </td>" & _
                                        "<td class=""text-right""><b>" & Prix(sMont) & "</b></td>" & _ 
                                    "</tr>"
                                    sTPoids = 0  : sMont = 0 : sPReel = 0 : sPFact = 0  : sEcart = 0  : k = k+1                                        
                            End If

                            Periode = rs_Enr("PERIODE") 
                            tabFo1 = tabFo1 & "<tr><td colspan=""11""><b>" & rs_Enr("PERIODE") & "</b></td></tr>"                             
                        End If	

                        tabFo1 = tabFo1 & "<tr id=""" & Count & "_h0"">" & vbNewLine & _									
                                    "	<td>" & rs_Enr("FO1") & "</td>" & vbNewLine &_
                                    "	<td>" & FormatDateTime(rs_Enr("DATE_FO1"), 2) & "</td>" & vbNewLine &_
                                    "	<td class=""text-right"">" & Prix(rs_Enr("POIDS_FO1")) & "</td>" & vbNewLine &_
                                    "	<td class=""text-right"">" & Prix(rs_Enr("POIDSREEL")) & "</td>" & vbNewLine &_
                                    "	<td class=""text-right"">" & Prix(rs_Enr("POIDSFACT")) & "</td>" & vbNewLine &_
                                    "	<td>" & rs_Enr("ECART") & "</td>" & vbNewLine &_																											
                                    "	<td>" & rs_Enr("ECART_TX") & "</td>" & vbNewLine &_
                                    "	<td>" & rs_Enr("TAUXSOUT") & "</td>" & vbNewLine &_
                                    "	<td class=""text-right"">" & Prix(rs_Enr("MONTSOUT")) & "</td>" & vbNewLine &_									
                                    "</tr>" &_
                                    "<tr class=""" & Count & "_h1"">" & vbNewLine & _ 
                                    "	<td colspan=""10"" class=""text-center""> CV: " & rs_Enr("CV") & " - Tonnage: " & Prix(rs_Enr("TONNAGE")) & " - CAF REF: " & Prix(rs_Enr("PRIX")) & "</td>" & vbNewLine &_
                                    "</tr>"

                        Per2 = Per1 : i = i+1

                        sEcart = sEcart + round(rs_Enr("ECART"),0)
                        sTPoids = sTPoids + round(rs_Enr("POIDS_FO1"),0)
                        sPReel = sPReel + round(rs_Enr("POIDSREEL"),0)
                        sMont = sMont + Replace(rs_Enr("MONTSOUT")," ","")
                        sPFact = sPFact + round(rs_Enr("POIDSFACT"),0)

                        Ecart = Ecart + round(rs_Enr("ECART"),0)
                        TPoids = TPoids + round(rs_Enr("POIDS_FO1"),0)
                        PReel = PReel + round(rs_Enr("POIDSREEL"),0)
                        PFact = PFact + round(rs_Enr("POIDSFACT"),0)
                        Mont = Mont + Replace(rs_Enr("MONTSOUT")," ","")                        

                '############################
                    ElseIf Nb = 3 Then	' ###  => Jeu de Résultats N 2 - 
                '############################

                        TypeContrat = TypeContrat & "<option value='" & rs_Enr("TYPECONTRAT") & "'>&nbsp;&nbsp;&nbsp;" & rs_Enr("TYPECONTRAT") & "&nbsp;&nbsp;&nbsp;</option>"				               

                '############################
                    ElseIf Nb = 4 Then	' ###  => Jeu de Résultats N 2 - 
                '############################
                        
                        tabMotif = tabMotif & "<li><input type=""checkbox"" name=""oCheckbox"" value=""" & rs_Enr("MOTIFR_ID") & """ /> - " & rs_Enr("LIBMOTIF") & "</li>"

                '############################
                    End If 				' ###  => Fin de Sélection du Jeu de Résultats 
                '############################

                rs_Enr.MoveNext

                Count = Count + 1

            Wend

            If Nb = 2 Then

                tabFo1 = tabFo1 & _
                        "<tr bgcolor=""#EEEEEE"">" & _
                            "<td colspan=""2""><b>S/TOTAL " & Periode & "</b> : </td>" & _
                            "<td class=""text-right""><b>" & Prix(sTPoids) & "</b></td>" & _
                            "<td class=""text-right""><b>" & Prix(sPReel) & "</b></td>" & _
                            "<td class=""text-right""><b>" & Prix(sPFact) & "</b></td>" & _
                            "<td class=""text-right""><b>" & Prix(sEcart) & "</b></td>" & _
                            "<td class=""text-right""><b>" & Round(sEcart*100/sTPoids,3) & "</b></td>" & _
                            "<td> - </td>" & _ 
                            "<td class=""text-right""><b>" & Prix(sMont) & "</b></td>" & _ 
                        "</tr>"

                tabFo1 = tabFo1 & _
                    "<tr bgcolor=""#EEEEEE"">" & _
                        "<td colspan=""2""><b>TOTAL FACTURE</b> : </td>" & _
                        "<td class=""text-right""><b>" & Prix(TPoids) & "</b></td>" & _
                        "<td class=""text-right""><b>" & Prix(PReel) & "</b></td>" & _
                        "<td class=""text-right""><b>" & Prix(PFact) & "</b></td>" & _
                        "<td class=""text-right""><b>" & Prix(Ecart) & "</b></td>" & _
                        "<td class=""text-right""><b>" & Round(Ecart*100/TPoids,3) & "</b></td>" & _
                        "<td> - </td>" & _ 
                        "<td class=""text-right""><b>" & Prix(Mont) & "</b></td>" & _ 
                    "</tr>"

            End If
            
            Set rs_Enr = rs_Enr.NextRecordset
                        
            Nb = Nb + 1
                        
        Loop

    '### - Fermeture des Objets de Connexion
                
                Set rs_Enr  = Nothing
                Set Cmd_Db = Nothing
%>

<h3 class="text-center text-uppercase">Controle de la facture n <%=nFact%></h3>
<table class="table">
    <%=tabFact%>			
</table>
<div class="table-responsive" id="wFrm">
    <table class="table table-bordered table-condensed">
        <thead>
            <tr bgcolor="#EEEEEE">
                <th>Fo1</th>
                <th>Date Fo1</th>
                <th>Poids Fo1</th>
                <th>Poids Réel</th>
                <th>Poids Facturé</th>
                <th>Ecart (T)</th>
                <th>Ecart (%)</th>
                <th>Taux</th>
                <th>Montant</th>
            </tr>
        </thead>
        <tbody><%=tabFo1%></tbody>			
    </table>
</div>

<form action="fact_soutien.asp" class="form-horizontal" method="post" Name="FrmUp" id="FrmUp">    
    <div class="row">
        <div class="col-md-4">
            <div class="form-group overflow-hidden">
                <select class="form-control" name="typeContrat" id="typeContrat">
                    <option value="">Type de contrat</option>
                    <%=typeContrat%>
                </select>
            </div>
            <div class="custom-controls-stacked">
                <label class="custom-control custom-radio">
                    <input type="radio" name="Choix" class="custom-control-input" value="Accord" />
                    <span class="custom-control-label"> Accepter</span>
                </label>
            </div>
            <div class="form-group overflow-hidden">
                <label class="custom-control custom-radio">
                    <input type="radio" name="Choix" class="custom-control-input" value="Ecart" />
                    <span class="custom-control-label">Ecart de plus de 2%</span>
                </label>
            </div>
            <div class="form-group overflow-hidden">
                <label class="custom-control custom-radio">
                    <input type="radio" name="Choix" class="custom-control-input" value="Rejet">
                    <span class="custom-control-label">Rejeter</span><span  id="rejet"></span>
                </label>
                <input type="hidden" name="Id" value="<%=Id%>" />
                <input type="hidden" name="idMotif" id="idMotif" />
                <input type="hidden" name="Choix_Frm" value="Yes" />
            </div>
        </div>
        <div class="col-md-4">
            <ul align="left" class="uMotif"><%=tabMotif%></ul>
        </div>
        <div class="col-md-4">
            <textarea class="form-control" name="rMotif" id="rMotif" rows="3" cols="50">Autre motif de rejet</textarea>
        </div>
    </div>
    <p class="text-center"><a href="#" id="btn"class="btn btn-lg btn-success"> <i class="fa fa-save"></i> Valider </a></p>
</form>

<%
'######################################
	End If 						  ' ###  => Fin Validation 
'######################################
%>