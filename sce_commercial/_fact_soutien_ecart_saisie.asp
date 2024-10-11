	<!--#include file="../include/inc_con.asp" -->
	<!--#include file="../include/fonction.asp" -->
	<!--#include file="../include/encryption.asp" -->
	<!--#include file="../include/inc_var.asp" -->
	
<%		
		If Session("Login") = False Or IsNull(Session("Login")) = True Then Response.Redirect "../expire.asp" End If		

		'If Not Acces_Page   = True Then Response.Redirect "../refuse.asp" & "?sigec=" & Server.UrlEncode(encrypt("?Motif=Menu_Refuse")) End If'
								
	'### - Declaration des Variables
				Dim Code, Agree, Trans
				Dim Edit, Err_Msg, Up_Edit
				Dim Cmd_Db
				Dim Pm_Out, Pm_Code, Pm_Fo1, Pm_Prdt, Pm_Id, Pm_Type
                Dim Pm_DtST, Pm_RefST, Pm_ListFact, Pm_TypeST, Pm_Option 
                Dim DtST, RefST, ListFact, TypeST
				Dim rs_Fo1, Count
				Dim Img, Fo1, Fo1_Option, Url
				Dim Nb, Cool
                Dim TContrat, Choix, Link
				
                Dim tabFact, tabFo1, tabsTransmis, TypeContrat, nFact
                Dim Pm_Camp, Pm_Reclt, Pm_Parite, Pm_LFrm, Pm_NumFact, Pm_DtFact, Pm_MtFact, Pm_VolFact, Pm_Banq, Pm_Form, Pm_TxRS, Pm_Poids, Pm_MtS, Pm_Str

	'### - Récupération des Variables Session Utilisateur
				Code  = Session("Code")

	'### - Pagination des Résultats renvoyés par la Procédure Stockée SQL
				Dim Nom_Page
					Nom_Page = "fact_soutien_ecart_saisie.asp"

				If (Len(Sigec("Page")) = 0) Or (IsNumeric(Sigec("Page")) = False) Then
					Page = 1
				Else
					Page = CInt(Sigec("Page"))
				End If

	'### - Récupération des Critères de Recherche 
					Dim Frm_Search
						Frm_Search = "Fact" 
			%>
					<!--#include file="../all_user/user_sql.asp" -->
			<%

	'### - Récupération des Options de Validation
				Edit 	= Sigec("Edit")
				Up_Edit = Sigec("Up_Edit")
	
'####################################
	If Up_Edit = "Yes" Then  ' ###  => Choix Effectué - Validation de l'Edition de la Formule dans la Base de Données
'####################################

	'### - Récupération des Valeurs de la Formule Sélectionnée
				nFact = Request("Fo1")                
                Choix = Request("Choix")
                DtST = Request("Dt")
                RefST = Request("Ref")
                ListFact = Request("Fo1")
                TypeST = Request("TypeSt")
            
	'### - Déclaration des Variables
				Dim Erreur
					Erreur = 0
				 
	'### - Controle du Formulaire
					
				If nFact = ""  Then
					Err_Msg = Err_Msg & "Une Erreur (0) inatendue s'est produite."
					Err_Msg = Err_Msg & "Veuiller vérifier les informations saisies !"
					Err_Msg = Err_Msg & "Si l'Erreur persiste, veuillez contacter l'Administrateur !"
					Erreur = 1
				End If
					
				If Session(Nom_Page) <> "" Then 
					Edit = ""
	
				Else

					If Erreur = 0 Then
	
						'### - Création de la Commande à Exécuter
							Set Cmd_Db = Server.CreateObject("AdoDB.Command")
								Cmd_Db.ActiveConnection = ado_Con
								Cmd_Db.CommandText = "Ps_Doc_STransmisFactSoutien"
								Cmd_Db.CommandType = adCmdStoredProc
					
						'### - Définition des Paramètres de la Procédure Stockée SQL
							Set Pm_Out		= Cmd_Db.CreateParameter("@Output", adInteger, adParamOutput)				: Cmd_Db.Parameters.Append Pm_Out
				            Set Pm_Code		= Cmd_Db.CreateParameter("@Code", adVarChar, adParamInput, 3, Code)			: Cmd_Db.Parameters.Append Pm_Code
				            Set Pm_Option	= Cmd_Db.CreateParameter("@Option", adVarChar, adParamInput, 15, "Valide")	: Cmd_Db.Parameters.Append Pm_Option
				            Set Pm_Fo1		= Cmd_Db.CreateParameter("@Id", adInteger, adParamInput, , 0) 				: Cmd_Db.Parameters.Append Pm_Fo1

                            Set Pm_ListFact	= Cmd_Db.CreateParameter("@ListeFact", adVarChar, adParamInput, 800, ListFact)	: Cmd_Db.Parameters.Append Pm_ListFact
                            Set Pm_TypeST	= Cmd_Db.CreateParameter("@TypeST", adVarChar, adParamInput, 10, TypeST)		: Cmd_Db.Parameters.Append Pm_TypeST
                            Set Pm_DtST		= Cmd_Db.CreateParameter("@DateST", adVarChar, adParamInput, 10, DtST)		: Cmd_Db.Parameters.Append Pm_DtST
                            Set Pm_RefST	= Cmd_Db.CreateParameter("@RefST", adVarChar, adParamInput, 50, RefST)		: Cmd_Db.Parameters.Append Pm_RefST	
							
                            Set Pm_Page		= Cmd_Db.CreateParameter("@Page", adInteger, adParamInput, , 0)					: Cmd_Db.Parameters.Append Pm_Page
							Set Pm_PageSize	= Cmd_Db.CreateParameter("@PageSize", adInteger, adParamInput, , 0)				: Cmd_Db.Parameters.Append Pm_PageSize
							Set Pm_Search	= Cmd_Db.CreateParameter("@Search", adVarChar, adParamInput, 8000, Null)		: Cmd_Db.Parameters.Append Pm_Search	
									
						'### - Exécution de la Commande SQL
							Cmd_Db.Execute
													
							Dim Retour				'### - Vérification du Paramètre de Retour et Affichage du Message de Confirmation
							Set Retour = Pm_Out
							
							Erreur = 1
									
							If Retour > 0 Then	 	'### - Aucune Erreur
								Err_Msg = Err_Msg & "Edition de la Formule Validée !"
								Session(Nom_Page) 	= Retour					
								Edit	= ""
										
								Log Fo1, "Fo1", "Facture - Soutien" 					
%>
								<script LANGUAGE="JScript">
									var Fo1 = "'toolbar=yes, menubar=yes, location=no, directories=no, status=yes, resizable=yes, scrollbars=yes width=700, height=500, left=80, top=80";
									window.open('../all_print/print_fiche_depassement.asp<%="?sigec=" & Server.UrlEncode(Encrypt("?Fo1=" & Retour))%>', '', Fo1);
                                    window.open('../all_print/affiche_soit_transmis_ecart.asp<%="?sigec=" & Server.UrlEncode(Encrypt("?Fo1=" & Retour))%>', '', Fo1);
								</script>  
<%
							Else		   	'### - Erreur Rencontrée
								Err_Msg = Err_Msg & "Une Erreur (" & Retour & ") inatendue s'est produite."
								Err_Msg = Err_Msg & "Veuiller vérifier les informations saisies !"
								Err_Msg = Err_Msg & "Si l'Erreur persiste, veuillez contacter l'Administrateur !"
								Edit	= "0"
'response.write Erreur & " - " & Retour & " - " & Pm_Out	& " - " & ListFact & " - " & DtST & " - " & RefST	
							End If
									
					End If
				End If
						

				
	'### - Fermeture des Objets de Connexion
				Set Cmd_Db  = Nothing

'######################################
	End If 						  ' ###  => Fin Validation 
'######################################
		
'######################################
	If Edit = "" Then	  		  ' ###  => Choix Effectué - Affichage des Factures à traiter 
'######################################

	'#####################################################
	'#####  Récupération des Formules - Non Editées  #####  
	'#####################################################

		'### - Création de la Commande à Exécuter
					Set Cmd_Db = Server.CreateObject("AdoDB.Command")
						Cmd_Db.ActiveConnection = ado_Con
						Cmd_Db.CommandText = "Ps_Doc_STransmisFactSoutien"
						Cmd_Db.CommandType = adCmdStoredProc

                    Search = ""
		'### - Définition des Paramètres de la Procédure Stockée SQL
					Set Pm_Out		= Cmd_Db.CreateParameter("@Output", adInteger, adParamOutput)				: Cmd_Db.Parameters.Append Pm_Out
					Set Pm_Code		= Cmd_Db.CreateParameter("@Code", adVarChar, adParamInput, 3, Code)			: Cmd_Db.Parameters.Append Pm_Code
					Set Pm_Option	= Cmd_Db.CreateParameter("@Option", adVarChar, adParamInput, 15, "ListEcart")		: Cmd_Db.Parameters.Append Pm_Option
					Set Pm_Fo1		= Cmd_Db.CreateParameter("@Id", adInteger, adParamInput, , 0) 				: Cmd_Db.Parameters.Append Pm_Fo1

                    Set Pm_ListFact	= Cmd_Db.CreateParameter("@ListeFact", adVarChar, adParamInput, 800, "")		: Cmd_Db.Parameters.Append Pm_ListFact
                    Set Pm_TypeST	= Cmd_Db.CreateParameter("@TypeST", adVarChar, adParamInput, 10, "")		: Cmd_Db.Parameters.Append Pm_TypeST
                    Set Pm_DtST		= Cmd_Db.CreateParameter("@DateST", adVarChar, adParamInput, 10, "")		: Cmd_Db.Parameters.Append Pm_DtST
                    Set Pm_RefST	= Cmd_Db.CreateParameter("@RefST", adVarChar, adParamInput, 50, "")		: Cmd_Db.Parameters.Append Pm_RefST

					Set Pm_Page		= Cmd_Db.CreateParameter("@Page", adInteger, adParamInput, , Page)			: Cmd_Db.Parameters.Append Pm_Page
					Set Pm_PageSize	= Cmd_Db.CreateParameter("@PageSize", adInteger, adParamInput, , PageSize)	: Cmd_Db.Parameters.Append Pm_PageSize	
					Set Pm_Search	= Cmd_Db.CreateParameter("@Search", adVarChar, adParamInput, 1000, Search)	: Cmd_Db.Parameters.Append Pm_Search
		
		'### - Exécution de la Commande SQL
					Set rs_Fo1 = Cmd_Db.Execute
				
		'### - Affichage des Résultats de la Procédure SQL
					img = "<img src=""../images/warning.gif"" align=""absmiddle"" border=""0"" width=""33"" height=""34"" alt=""Alerte !"">"
				
					Count = 0
					Fo1   = ""
							
					Dim Records, Paging, aUrl, bUrl, w, x

					While Not rs_Fo1.Eof
					
						Count = Count + 1
					
						Records	= rs_Fo1("Record_Count")		
						Paging 	= Int(Count + Int(PageSize * Int(Page - 1)))
		
						Fo1_Option = "?Edit=0&Fo1=" & rs_Fo1("FACTSOUT_ID") & rSearch
						Fo1_Option = "?sigec=" & Server.UrlEncode(Encrypt(Fo1_Option))
			
						Url = "Afficher('Voir_fo1', '../all_print/affiche_fo1.asp" & Fo1_Option & "', 100, 100, 500, 500, 0, 0, 0, 1, 1);"																
						
						'bUrl = "?Print=Yes&Cdc=" & rs_Fo1("Cdc_ID") & rSearch
						'bUrl = "?sigec=" & Server.UrlEncode(Encrypt(bUrl))
						'bUrl = "Afficher('Voir_cdc', '../all_print/affiche_cdc.asp" & bUrl & "', 100, 100, 500, 500, 0, 0, 0, 1, 1);"												
								
						Fo1 = Fo1 & "<tr id=""" & Count & "_h0"">" & vbNewLine & _
									"	<td height=""25"" valign=""middle"" align=""center"" " & Cool & ">" & Paging & "</td>" & vbNewLine &_
                                    "	<td height=""25"" valign=""middle"" align=""center"">" & rs_Fo1("REF_FACTSOUT") & "</td>" & vbNewLine &_
									"	<td height=""25"" valign=""middle"" align=""center"">" & FormatDateTime(rs_Fo1("DATE_FACTSOUT"), 2) & "</td>" & vbNewLine &_
									"	<td height=""25"" valign=""middle"" align=""center"">" & rs_Fo1("NUM_FACTSOUT") & "</td>" & vbNewLine &_
									"	<td height=""25"" valign=""middle"" align=""center"">" & Prix(rs_Fo1("VOL_FACTSOUT")) & "</td>" & vbNewLine &_
									"	<td height=""25"" valign=""middle"" align=""center"">" & Prix(rs_Fo1("MONT_FACTSOUT")) & "</td>" & vbNewLine &_									
                                    "	<td height=""25"" valign=""middle"" align=""center"">" & rs_Fo1("NOM") & "</td>" & vbNewLine &_                                    
									"	<td height=""25"" valign=""middle"" align=""center""><input type=""checkbox"" name=""Fo1"" value=""" & rs_Fo1("FACTSOUT_ID") & """ /></td>" & vbNewLine &_
									"</tr>" '& vbNewLine					
				
						rs_Fo1.MoveNext
						
					Wend


		'### - Fermeture des Objets de Connexion
					rs_Fo1.Close
					
					Set rs_Fo1  = Nothing
					Set Cmd_Db = Nothing							

        Link = "?Edit=0" 
		Link = "?sigec=" & Server.UrlEncode(Encrypt(Link))

'######################################
	ElseIf Edit = "0" Then  ' ###  => Choix Effectué - Saisie des infos complémentaires
'######################################
								 
	'### - Annulation de l'action Rafraichissement (Bouton F5) - Vérification de l'état de Validation
				Session(Nom_Page) 	= ""					

	'### - Récupération des Valeurs de la Formule Sélectionnée
                Fo1 = request("Fo1")
                nFact = request("Fo1")

    '#####################################################
	'#####  Récupération des Formules - Non Editées  #####  
	'#####################################################

		'### - Création de la Commande à Exécuter
					Set Cmd_Db = Server.CreateObject("AdoDB.Command")
						Cmd_Db.ActiveConnection = ado_Con
						Cmd_Db.CommandText = "Ps_Doc_STransmisFactSoutien"
						Cmd_Db.CommandType = adCmdStoredProc
	
		'### - Définition des Paramètres de la Procédure Stockée SQL
				Set Pm_Out		= Cmd_Db.CreateParameter("@Output", adInteger, adParamOutput)				: Cmd_Db.Parameters.Append Pm_Out
				Set Pm_Code		= Cmd_Db.CreateParameter("@Code", adVarChar, adParamInput, 3, Code)			: Cmd_Db.Parameters.Append Pm_Code
				Set Pm_Option	= Cmd_Db.CreateParameter("@Option", adVarChar, adParamInput, 15, "Saisie")		: Cmd_Db.Parameters.Append Pm_Option
				Set Pm_Fo1		= Cmd_Db.CreateParameter("@Id", adInteger, adParamInput, , 0) 				: Cmd_Db.Parameters.Append Pm_Fo1

                Set Pm_ListFact	= Cmd_Db.CreateParameter("@ListeFact", adVarChar, adParamInput, 800, Fo1)		: Cmd_Db.Parameters.Append Pm_ListFact
                Set Pm_TypeST	= Cmd_Db.CreateParameter("@TypeST", adVarChar, adParamInput, 10, "")		: Cmd_Db.Parameters.Append Pm_TypeST
                Set Pm_DtST		= Cmd_Db.CreateParameter("@DateST", adVarChar, adParamInput, 10, "")		: Cmd_Db.Parameters.Append Pm_DtST
                Set Pm_RefST	= Cmd_Db.CreateParameter("@RefST", adVarChar, adParamInput, 50, "")		: Cmd_Db.Parameters.Append Pm_RefST			
		
		'### - Exécution de la Commande SQL
					Set rs_Fo1 = Cmd_Db.Execute
				
		'### - Affichage des Résultats de la Procédure SQL												
            
            Fo1 = ""
					
			While Not rs_Fo1.Eof						

				Fo1 = Fo1 & "<tr>" & vbNewLine & _							
                            "	<td height=""25"" valign=""middle"" align=""center"">" & rs_Fo1("REF_FACTSOUT") & "</td>" & vbNewLine &_
							"	<td height=""25"" valign=""middle"" align=""center"">" & FormatDateTime(rs_Fo1("DATE_FACTSOUT"), 2) & "</td>" & vbNewLine &_
							"	<td height=""25"" valign=""middle"" align=""center"">" & rs_Fo1("NUM_FACTSOUT") & "</td>" & vbNewLine &_
							"	<td height=""25"" valign=""middle"" align=""center"">" & Prix(rs_Fo1("VOL_FACTSOUT")) & "</td>" & vbNewLine &_
							"	<td height=""25"" valign=""middle"" align=""center"">" & Prix(rs_Fo1("MONT_FACTSOUT")) & "</td>" & vbNewLine &_									
                            "	<td height=""25"" valign=""middle"" align=""center"">" & rs_Fo1("NOM") & "</td>" & vbNewLine &_                                    							
							"</tr>"
							TypeSt = rs_Fo1("ETAT_VALIDE")
				rs_Fo1.MoveNext											
							
			Wend			


		'### - Fermeture des Objets de Connexion
					'rs_Fo1.Close
					
					Set rs_Fo1  = Nothing
					Set Cmd_Db = Nothing
		
		Link = "?Up_Edit=Yes"
		Link = "?sigec=" & Server.UrlEncode(Encrypt(Link))
		
'################
	End If	' ###  => Fin Option
'################			
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>Bourse du Café et du Cacao - Facture soutien : Soit - Transmis - <%=Session("Nom_Complet")%></title>
	<meta http-equiv="content-type" content="text/html; charset=iso-8859-1">
	<link type="text/css" href="../include/global.css" rel="stylesheet">
    <link type="text/css" href="../css/app.css" rel="stylesheet">
    <link type="text/css" href="../css/css-buttons.css" rel="stylesheet">
    <link type="text/css" href="../css/jquery-ui-1.8.5.custom.css" rel="stylesheet">
    <script type="text/javascript" src="../js/menu_file/stm31.js"></script>
    <script type="text/javascript" src="../js/jquery-1.4.2.min.js"></script>
    <script type="text/javascript" src="../js/jquery-ui-1.8.5.custom.min.js"></script>    
    <script language="JavaScript">
		<!--
			function Afficher(name, url, left, top, width, height, toolbar, menubar, statusbar, scrollbar, resizable)
				{
				  toolbar_str = toolbar ? 'yes' : 'no';
				  menubar_str = menubar ? 'yes' : 'no';
				  statusbar_str = statusbar ? 'yes' : 'no';
				  scrollbar_str = scrollbar ? 'yes' : 'no';
				  resizable_str = resizable ? 'yes' : 'no';
				
				  cookie_str = document.cookie;
				  cookie_str.toString();
				
				  pos_start  = cookie_str.indexOf(name);
				  pos_end    = cookie_str.indexOf('=', pos_start);
				
				  cookie_name = cookie_str.substring(pos_start, pos_end);
				
				  pos_start  = cookie_str.indexOf(name);
				  pos_start  = cookie_str.indexOf('=', pos_start);
				  pos_end    = cookie_str.indexOf(';', pos_start);
				  
				  if (pos_end <= 0) pos_end = cookie_str.length;
				  cookie_val = cookie_str.substring(pos_start + 1, pos_end);
				  if (cookie_name == name && cookie_val  == "done")
				    return;
				
				  window.open(url, name, 'left='+left+',top='+top+',width='+width+',height='+height+',toolbar='+toolbar_str+',menubar='+menubar_str+',status='+statusbar_str+',scrollbars='+scrollbar_str+',resizable='+resizable_str);
				}		
		// -->
	</script>
    <script type="text/javascript">
        $(function () {

            $('#msg').dialog({
					width:460,
					modal:true,
					//autoOpen:true,
					buttons:{
						'OK':function(){ $(this).dialog('close'); }
						}
			});

            $("#Dt").datepicker({ dateFormat: 'dd/mm/yy', dayNamesMin: ['Di', 'Lu', 'Ma', 'Me', 'Je', 'Ve', 'Sa'] });            
              
            $('#btn').click(function () {
                var msg = "";                
                if($("#ref").val() == "") { msg = "Erreur! Reférence non saisie";}
                if($("#Dt").val() == "") { msg = "Erreur! Date non saisie"; }
                if (msg == "") {

                    $('#dialog').html("<br />Confirmez-vous l'édition de ce Soit-Transmis ?").dialog({
                        width: 460,
                        modal: true,
                        autoOpen: true,
                        buttons: {
                            'Oui': function () { $(this).dialog('close'); $('#Edition').submit(); },
                            'Non': function () { $(this).dialog('close'); return false; }
                        }
                    }); return false;
                }
                else {

                    $('#dialog').html(msg).dialog({
                        width: 460,
                        modal: true,
                        autoOpen: true,
                        buttons: {
                            'Ok': function () { $(this).dialog('close'); return false; }
                        }
                    });
                    return false;
                }
            });
            // - Fin des Scripts jQuery                     
        });     
	</script>
    <style type="text/css">
        table 
    </style>
</head>    
<body class="page">
	<div id="container">
       <!-- Zone : En tête -->
        <div id="header"> <!--#include file="../include/inc_hautc.asp" --> </div>
        <div id="sidebar">        	
			<%
					Frm_Search 	= "Fo1" 
					Frm 		= "Fo1" 
			%>
				<!--include file="../all_user/user_search.asp" -->
			<%
					Dim Out
						Out = "Fo1"
						
					'Search = Search & " And	(IsNull(FORMULE.V_LOT, 0) = 1) And (IsNull(V_CHQ, 0) = 1) And (IsNull(A_FO1, 0) = 0) And (IsNull(V_D6, 0) = 0) "
			%>
				<!--include file="../all_user/frm_stat.asp" -->
        </div>         
        <div id="mainContent">
            <div id="dialog" title="SIGEC4 - Soit-Transmis - "> </div>         
            <%If Erreur>0 Then%>
                <div id="msg" title=" SIGEC4 - Soit-Transmis - ">
                    <p><span style="margin:0px 07px 50px 0px; float:left" class="ui-icon ui-icon-alert"></span> <%=Err_Msg%></p>
                </div>
            <%End If %>
            <br /><br />
              
 <%           
'######################################
	If Edit = "" Then	  		  '' ###  => Choix Effectué - Affichage des Formules à Editer 
'######################################  
%>
            <h1>Factures de Soutien avec écarts</h1>
			<br /><br />  
            <form action="fact_soutien_ecart_saisie.asp<%=Link%>" method="post" Name="Edition" id="Edition" enctype="application/x-www-form-urlencoded">	          
			    <table width="90%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#859AA6" summary="" rules="rows" frame="hsides">
			        <tr bgcolor="#EEEEEE">
			          <td height="25" align="center"><b>N°</b></td>
			          <td height="25" align="center"><b>Ref Fact</b></td>
			          <td height="25" align="center"><b>Date</b></td>
			          <td height="25" align="center"><b>N° Fact</b></td>
			          <td height="25" align="center"><b>Tonnage</b></td>
			          <td height="25" align="center"><b>Montant</b></td>                  
                      <td height="25" align="center"><b>Exportateur</b></td>                  
			          <td height="25" align="center"><b>&nbsp;</b></td>
			        </tr>
		    <%
				    If Fo1 = "" Then
					    Response.Write "<tr><td height=""50"" colspan=""8"" valign=""middle"" align=""center"">" & Img
					    Response.Write " &nbsp;<font face=""Verdana"" size=""2""><b> - &nbsp;Aucune Formule Disponible !</b></font></td></tr>"
				    Else
					    Response.Write Fo1
				    End If
				
		    %>
			    </table>
                <p text="align"><br /><br /><input type="image" src="../images/frm_ok.gif" alt="Creer le Soit-Transmis" align="absmiddle" id="btn"> </p>
			</form>

			<table width="500" border="0" align="center" cellpadding="0" cellspacing="0" summary="">
				<tr><td width="500" height="20" align="right" valign="middle"><font face="Verdana" size="1">* Les Poids sont exprimés en Kilogrammes</font></td></tr>
			</table>
		
			 <br />
			
			<!--#include file="../include/inc_paging.asp" -->
			
			<br /><br />			
<%
'######################################
	ElseIf Edit = "0" Then  ' ###  => Choix Effectué - Traitement de la facture sélectionnée
'######################################
%>			
	<form action="fact_soutien_ecart_saisie.asp<%=Link%>" method="post" Name="Edition" id="Edition" enctype="application/x-www-form-urlencoded">			
	
		<br />
        <h1>Création du Soit - Transmis dépassement de poids </h1>
        <br />
	
		<table width="90%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#859AA6" summary="" rules="rows" frame="hsides">
			<tr bgcolor="#EEEEEE">			    
			    <td height="25" align="center"><b>Ref Fact</b></td>
			    <td height="25" align="center"><b>Date</b></td>
			    <td height="25" align="center"><b>N° Fact</b></td>
			    <td height="25" align="center"><b>Tonnage</b></td>
			    <td height="25" align="center"><b>Montant</b></td>                  
                <td height="25" align="center"><b>Exportateur</b></td>                  			    
			</tr>
	<%
			If Fo1 = "" Then
				Response.Write "<tr><td height=""50"" colspan=""8"" valign=""middle"" align=""center"">" & Img
				Response.Write " &nbsp;<font face=""Verdana"" size=""2""><b> - &nbsp;Aucune Formule Disponible !</b></font></td></tr>"
			Else
				Response.Write Fo1
			End If
				
	%>
            
		</table>
        <p><br /></p>
        <table>
            <tr height="25">
                <td>Reférence Soit-Transmis</td>
                <td> : <input type="text" name="Ref" id="Ref" value="<%=RefST%>" /></td>
            </tr>
            <tr height="25">
                <td>Date Soit-Transmis</td>
                <td> : <input type="text" name="Dt" id="Dt" value="<%=DtST%>" /></td>
            </tr>
            <tr height="25">
                <td text="align" colspan="2">
                    <input type="hidden" name="Fo1" value="<%=nFact%>" /> 
                    <input type="hidden" name="TypeSt" value="<%=TypeSt%>" />
                    <input type="image" src="../images/frm_ok.gif" alt="Creer le Soit-Transmis" align="absmiddle" id="btn" /> 
                </td>
            </tr>
        </table>
        <br />
        
	</form>


<%		
'################
	End If	'' ###  => Fin Option
'################

%>		

	</div> 
    		<div class="clearfloat" ></div>
            <div id="footer"> <!--#include file="../include/inc_basc.asp" --> </div>
    </div>


</body>
</html>















