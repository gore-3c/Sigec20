	<!--#include file="../include/inc_con.asp" -->
	<!--#include file="../include/fonction.asp" -->
	<!--#include file="../include/encryption.asp" -->
	<!--#include file="../include/inc_var.asp" -->
	
<%		
		If Session("Login") = False Or IsNull(Session("Login")) = True Then Response.Redirect "../expire.asp" End If		

		'If Not Acces_Page   = True Then Response.Redirect "../refuse.asp" & "?sigec=" & Server.UrlEncode(encrypt("?Motif=Menu_Refuse")) End If
								
	'### - Declaration des Variables
				Dim Code, Agree, Trans, Edit, Up_Edit
				Dim Frc, Err_Msg, Up_Frc
				Dim Cmd_Db
				Dim Pm_Out, Pm_Code, Pm_Type, Pm_Fo1, Pm_Prdt, Pm_Dt, Pm_Num
				Dim rs_Fo1, Count
				Dim Img, Fo1, Fo1_Option, Url
				Dim Nb, Cool
				
	'### - Récupération des Variables Session Utilisateur
				Code  = Session("Code")

	'### - Pagination des Résultats renvoyés par la Procédure Stockée SQL
				Dim Nom_Page
					Nom_Page = "frc.asp"

				If (Len(Sigec("Page")) = 0) Or (IsNumeric(Sigec("Page")) = False) Then
					Page = 1
				Else
					Page = CInt(Sigec("Page"))
				End If

	'### - Récupération des Critères de Recherche 
					Dim Frm_Search
						Frm_Search = "Fo1" 
			%>
					<!--#include file="../all_user/user_sql.asp" -->
			<%

	'### - Récupération des Options de Validation
				Frc 	= Sigec("Frc")
				Up_Frc 	= Sigec("Up_Frc")
	
'####################################
	If Up_Frc = "Yes" Then  ' ###  => Choix Effectué - Validation du Traitement de la Formule dans la Base de Données
'####################################

	'### - Récupération des Valeurs de la Formule Sélectionnée
				 Fo1 = Int(Sigec("Fo1"))

	'### - Déclaration des Variables
				Dim Erreur
					Erreur = 0 
					
				Dim Dt, LinkBv, bvUrl
					Dt = Request("Dt")					 				

				LinkBv = "?Fo1=" & Fo1 & rSearch
					LinkBv = "?sigec=" & Server.UrlEncode(Encrypt(LinkBv))

					bvUrl = "Afficher('Verification_BV', '../all_print/affiche_lot_bv.asp" & LinkBv& "', 100, 100, 600, 500, 0, 0, 0, 1, 1);"				
				
	'### - Controle du Formulaire

				If Fo1 = "" Or Dt = "" Or Request("Valider") = "" Then
					Err_Msg = Err_Msg & "Une Erreur inatendue s'est produite."
					Err_Msg = Err_Msg & "Veuiller vérifier les informations saisies !"
					Err_Msg = Err_Msg & "Si l'Erreur persiste, veuillez contacter l'Administrateur !"
					Erreur = 1
				Else
					If Len(Dt) <> 10 And Err_Msg = ""  Then
						Erreur = 1 : Err_Msg = Err_Msg & "Le Format de la Date saisie n'est pas valide <br>Ex (jj/mm/aaaa) : 01/01/2006 !"
					Else
						If IsDate(Dt) = False Then 
							Erreur = 1 : Err_Msg = Err_Msg & "Le Format de la Date saisie n'est pas valide <br>Ex (jj/mm/aaaa) : 01/01/2006 !"
						End If
						If Erreur = 0 Then 
							If CDate(Dt) > Date() Then 
								Erreur = 1 : Err_Msg = Err_Msg & "La Date saisie est supérieure à la Date du Jour !"
							End If
						End If
					End If
					
					If Request("Valider") = "" Then
						Erreur = 1 : Err_Msg = Err_Msg & "Veuillez cocher la case "" Valider "" !"
					End If
				End If
				
				If Erreur = 1 Then
					Frc  = "0"
				End If
					
				If Session(Nom_Page) <> "" Then 
					Frc = ""
				Else
					If Erreur = 0 Then
	
						'### - Création de la Commande à Exécuter
									Set Cmd_Db = Server.CreateObject("AdoDB.Command")
										Cmd_Db.ActiveConnection = ado_Con
										Cmd_Db.CommandText = "Ps_Tech_Frc"
										Cmd_Db.CommandType = adCmdStoredProc
					
						'### - Définition des Paramètres de la Procédure Stockée SQL
									Set Pm_Out	= Cmd_Db.CreateParameter("@Output", adInteger, adParamOutput)				: Cmd_Db.Parameters.Append Pm_Out
									Set Pm_Code	= Cmd_Db.CreateParameter("@Code", adVarChar, adParamInput, 3, Code)			: Cmd_Db.Parameters.Append Pm_Code
									Set Pm_Type	= Cmd_Db.CreateParameter("@Type", adVarChar, adParamInput, 25, "Valide")	: Cmd_Db.Parameters.Append Pm_Type
									Set Pm_Fo1	= Cmd_Db.CreateParameter("@Fo1", adInteger, adParamInput, , Fo1) 			: Cmd_Db.Parameters.Append Pm_Fo1
									Set Pm_Dt	= Cmd_Db.CreateParameter("@Date", adVarChar, adParamInput, 10, Dt)			: Cmd_Db.Parameters.Append Pm_Dt
									'Set Pm_Num	= Cmd_Db.CreateParameter("@Frc", adVarChar, adParamInput, 10, Num) 			: Cmd_Db.Parameters.Append Pm_Num
									Set Pm_Page	= Cmd_Db.CreateParameter("@Page", adInteger, adParamInput, , 0)				: Cmd_Db.Parameters.Append Pm_Page
									Set Pm_PageSize	= Cmd_Db.CreateParameter("@PageSize", adInteger, adParamInput, , 0)			: Cmd_Db.Parameters.Append Pm_PageSize
									Set Pm_Search	= Cmd_Db.CreateParameter("@Search", adVarChar, adParamInput, 1000, Null)	: Cmd_Db.Parameters.Append Pm_Search
						
						'### - Exécution de la Commande SQL
									Cmd_Db.Execute
													
							   		Dim Retour				'### - Vérification du Paramètre de Retour et Affichage du Message de Confirmation
									Set Retour = Pm_Out
									
									Erreur = 1
									
									If Retour > 0 Then	 	'### - Aucune Erreur
										Err_Msg = Err_Msg & "Validation de la Formule Effectuée !"
										Session(Nom_Page) 	= Retour					
										Frc = "1" : Edit = "0"

										Log Fo1, "Fo1", "Valiation - Traitement Formule"					

									ElseIf Retour = -4 Then	'### - Erreur Rencontrée
										Err_Msg = Err_Msg & "Ce Numéro a déjà été saisi !"
										Frc	= "0"
									Else		   			'### - Erreur Rencontrée
										Err_Msg = Err_Msg & "Une Erreur " & Retour & " inatendue s'est produite."
										Err_Msg = Err_Msg & "Veuiller vérifier les informations saisies !"
										Err_Msg = Err_Msg & "Si l'Erreur persiste, veuillez contacter l'Administrateur !"
										Frc	= "0"
									End If
									
					End If
				End If
						
				
	'### - Fermeture des Objets de Connexion
				Set Cmd_Db  = Nothing

'######################################
	End If 						  ' ###  => Fin Validation 
'######################################
%>



<%		
'######################################
	If Frc = "" Then	  		  ' ###  => Choix Effectué - Affichage des Formules non Validées Frc 
'######################################

	'#####################################################
	'#####  Récupération des Formules - Non Validées #####  
	'#####################################################

		'### - Création de la Commande à Exécuter
					Set Cmd_Db = Server.CreateObject("AdoDB.Command")
						Cmd_Db.ActiveConnection = ado_Con
						Cmd_Db.CommandText = "Ps_Tech_Frc"
						Cmd_Db.CommandType = adCmdStoredProc
	
		'### - Définition des Paramètres de la Procédure Stockée SQL
					Set Pm_Out	= Cmd_Db.CreateParameter("@Output", adInteger, adParamOutput)			: Cmd_Db.Parameters.Append Pm_Out
					Set Pm_Code	= Cmd_Db.CreateParameter("@Code", adVarChar, adParamInput, 3, Code)		: Cmd_Db.Parameters.Append Pm_Code
					Set Pm_Type	= Cmd_Db.CreateParameter("@Type", adVarChar, adParamInput, 25, "Liste")		: Cmd_Db.Parameters.Append Pm_Type
					Set Pm_Fo1	= Cmd_Db.CreateParameter("@Fo1", adInteger, adParamInput, , 0) 			: Cmd_Db.Parameters.Append Pm_Fo1
					Set Pm_Dt	= Cmd_Db.CreateParameter("@Date", adVarChar, adParamInput, 10, Null)		: Cmd_Db.Parameters.Append Pm_Dt
					''Set Pm_Num	= Cmd_Db.CreateParameter("@Frc", adVarChar, adParamInput, 10, Null) 		: Cmd_Db.Parameters.Append Pm_Num
					Set Pm_Page	= Cmd_Db.CreateParameter("@Page", adInteger, adParamInput, , Page)		: Cmd_Db.Parameters.Append Pm_Page
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
		
						Fo1_Option = "?Frc=0&Fo1=" & rs_Fo1("FO1_ID") & rSearch
						Fo1_Option = "?sigec=" & Server.UrlEncode(Encrypt(Fo1_Option))
			
						Url = "Afficher('Voir_fo1', '../all_print/affiche_fo1.asp" & Fo1_Option & "', 100, 100, 500, 500, 0, 0, 0, 1, 1);"
					
						aUrl = "?Print=Yes&Enr=" & rs_Fo1("ENR_ID") & rSearch
						aUrl = "?sigec=" & Server.UrlEncode(Encrypt(aUrl))
						aUrl = "Afficher('Avis_Enr', '../all_print/affiche_enr.asp" & aUrl & "', 100, 100, 600, 500, 0, 0, 0, 1, 1);"
						
						bUrl = "?Print=Yes&Cdc=" & rs_Fo1("Cdc_ID") & rSearch
						bUrl = "?sigec=" & Server.UrlEncode(Encrypt(bUrl))
						bUrl = "Afficher('Voir_cdc', '../all_print/affiche_cdc.asp" & bUrl & "', 100, 100, 500, 500, 0, 0, 0, 1, 1);"
						
						If rs_Fo1("A_Fo1") = True Then w = "<strike>" : x = "</strike>" Else w = "" : x = "" End If
								
						Fo1 = Fo1 & "<tr id=""" & Count & "_h0"">" & vbNewLine & _
									"	<td width="""" height=""25"" valign=""middle"" align=""center"" " & Cool & ">" & Paging & "</td>" & vbNewLine &_
									"	<td width="""" height=""25"" valign=""middle"" align=""center"">" & w & FormatDateTime(rs_Fo1("Fo1_Date"), 2) & x & "</td>" & vbNewLine &_
									"	<td width="""" height=""25"" valign=""middle"" align=""center""><a href=""javascript:" & Url & """>" & w & rs_Fo1("Fo1") & x & "</a></td>" & vbNewLine &_
									"	<td width="""" height=""25"" valign=""middle"" align=""center"">" & w & rs_Fo1("Produit") & " " & rs_Fo1("Grade") & x & "</td>" & vbNewLine &_
									"	<td width="""" height=""25"" valign=""middle"" align=""center"">" & w & rs_Fo1("Qualite") & x & "</td>" & vbNewLine &_
									"	<td width="""" height=""25"" valign=""middle"" align=""center"">" & w & Prix(rs_Fo1("Poids_Fo1")) & x & "</td>" & vbNewLine &_
									"	<td width="""" height=""25"" valign=""middle"" align=""center""><a href=""frc.asp" & Fo1_Option & """ target=""_self"">" & vbNewLine &_
									"	<img src=""../images/sign.gif"" width=""15"" height=""15"" border=""0"" alt=""Valider la Formule""></a></td>" & vbNewLine &_
									"</tr>" & vbNewLine
									
						Fo1 = Fo1 & "<tr valign=""middle"" height=""15"" id=""" & Count & "_h1"" class=""htr"">" & vbNewLine &_
									"	<td colspan=""7"" bordercolorlight=""#FFFFFF"" bordercolordark=""#FFFFFF"">" & vbNewLine
												  
						Fo1 = Fo1 & "	<table align=""right"" border=""0"" cellpadding=""1"" cellspacing=""1"" bordercolor=""#859AA6"" summary="""" rules=""rows"" frame=""hsides"">" & vbNewLine &_
									"		<tr height=""20"" bgcolor=""#EEEEEE"" valign=""middle"">" & vbNewLine &_
									"			<td width=""120"" align=""center""><font class=""Liste""><b>Exportateur</b></font></td>" & vbNewLine &_
									"			<td width=""50"" align=""center""><font class=""Liste""><b>N° Enr</b></font></td>" & vbNewLine &_
									"			<td width=""100"" align=""center""><font class=""Liste""><b>N° Cdc</b></font></td>" & vbNewLine &_
									"			<td width=""120"" align=""center""><font class=""Liste""><b>Période</b></font></td>" & vbNewLine &_
									"			<td width=""60"" align=""center""><font class=""Liste""><b>Dest.</b></font></td>" & vbNewLine &_
									"		</tr>" & vbNewLine &_
									"		<tr height=""20"" bgcolor=""#EEEEEE"" valign=""middle"">" & vbNewLine &_
									"			<td width="""" align=""center""><font class=""Liste"">" & rs_Fo1("Nom") & "</font></td>" & vbNewLine &_
									"			<td width="""" align=""center""><font class=""Liste""><a href=""javascript:" & aUrl & """>" & rs_Fo1("Enr_Id") & "</a></font></td>" & vbNewLine &_
									"			<td width="""" align=""center""><font class=""Liste""><a href=""javascript:" & bUrl & """>" & rs_Fo1("Cdc_Exp") & "</a></font></td>" & vbNewLine &_
									"			<td width="""" align=""center""><font class=""Liste"">" & rs_Fo1("Periode") & "</font></td>" & vbNewLine &_
									"			<td width="""" align=""center""><font class=""Liste"">" & rs_Fo1("Region") & "</a></font></td>" & vbNewLine &_
									"		</tr>" & vbNewLine &_
									"	</table>" & vbNewLine
										
						Fo1 = Fo1 & "	</td>" & vbNewLine &_
									"</tr>" & vbNewLine
				
						rs_Fo1.MoveNext
						
					Wend

		'### - Fermeture des Objets de Connexion
					rs_Fo1.Close
					
					Set rs_Fo1  = Nothing
					Set Cmd_Db = Nothing	
'################
	End If	' ###  => Fin Option
'################											
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>Le Conseil du Café-Cacao - Validation du Traitement des Formules - <%=Session("Nom_Complet")%></title>
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
		$(function() {	
						
			$("#Debut").datepicker( {dateFormat:'dd/mm/yy', dayNamesMin: ['Di', 'Lu', 'Ma', 'Me', 'Je', 'Ve', 'Sa'], changeMonth: true } );
			$("#Fin").datepicker( {dateFormat:'dd/mm/yy', dayNamesMin: ['Di', 'Lu', 'Ma', 'Me', 'Je', 'Ve', 'Sa'], changeMonth: true } );
			$("#Dt").datepicker( {dateFormat:'dd/mm/yy', dayNamesMin: ['Di', 'Lu', 'Ma', 'Me', 'Je', 'Ve', 'Sa'], maxDate:+0 } );										
			
			$("tr[id$=_h0]").click(function(){
				$("tr[id$=_h0]").removeClass("hover");
				$("tr[id$=_h1]").addClass("htr");
				$(this).addClass("hover");
				var i = $(this).attr('id').match(/[0-9]+/);
				$('#'+i+'_h1').removeClass("htr");
			});		
						 
			$("tr[id$=_h1]").click(function(){
				 	var i = $(this).attr('id').match(/[0-9]+/);
				   $(this).addClass("htr");
			 });	
			 
			$('#msg').dialog({
					width:460,
					modal:true,
					//autoOpen:true,
					buttons:{
						'OK':function(){ $(this).dialog('close'); }
						}
			});		
			
			$('#frm_ok').click(function(){
				var msg = "";
				if ($('#Dt').val() == "") msg = '**********   ATTENTION   **********  <br />     Veuillez saisir la Date de Traitement !';										
				if ($('#Valider').attr("checked") == "") msg = '**********   ATTENTION   **********  <br />     Veuillez cocher la case " Valider " !';
				
				if(msg == ""){
					
					$('#dialog').html("<br />Confirmez-vous la Validation de cette Formule ?").dialog({
						width:460,
						modal:true,
						autoOpen:true,
						buttons:{
							'Oui':function(){ $(this).dialog('close'); $('#Frc').submit();},
							'Non':function(){ $(this).dialog('close'); return false;}
							}
					});	return false;
				}
				else{
					
					$('#dialog').html(msg).dialog({
						width:460,
						modal:true,
						autoOpen:true,
						buttons:{
							'Ok':function(){ $(this).dialog('close'); return false;}
							}
					});
					return false;
				}
			});	
			
			$('#frm_ok2').click(function(){
				var msg = "";										
				if ($('#Editer').attr("checked") == "") msg = '**********   ATTENTION   **********  <br />     Veuillez cocher la case " Editer " !';
				
				if(msg == ""){
					
					$('#dialog').html("<br />Confirmez-vous l'édition de cette Formule ?").dialog({
						width:460,
						modal:true,
						autoOpen:true,
						buttons:{
							'Oui':function(){ $(this).dialog('close'); $('#Edition').submit();},
							'Non':function(){ $(this).dialog('close'); return false;}
							}
					});	return false;
				}
				else{
					
					$('#dialog').html(msg).dialog({
						width:460,
						modal:true,
						autoOpen:true,
						buttons:{
							'Ok':function(){ $(this).dialog('close'); return false;}
							}
					});
					return false;
				}
			});	
			
			// - Fin des Scripts jQuery						
		});	 	
	</script>
					
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
				<!--#include file="../all_user/user_search.asp" -->
			<%
					Dim Out
						Out = "Fo1"
						
					Search = Search & " And	(IsNull(FORMULE.V_EDIT, 0) = 0) And (IsNull(FORMULE.V_FRC, 0) = 0) And (IsNull(A_FO1, 0) = 0) And (IsNull(V_D6, 0) = 0) "
			%>
				<!--#include file="../all_user/frm_stat.asp" -->

        </div>         
        <div id="mainContent">
            <div id="dialog" title="SIGEC4 - Validation du Traitement des Formules - "> </div>         
            <%If Erreur>0 Then %>
                <div id="msg" title=" SIGEC4 - Validation du Traitement des Formules - ">
                    <p><span style="margin:0px 07px 50px 0px; float:left" class="ui-icon ui-icon-alert"></span> <%=Err_Msg%></p>
                </div>
            <%End If %>
            <br /><br />
            <img src="../images/tech_frc.gif" border="0" width="257" height="44" alt="Validation du Traitement des Formules" align="middle">
			<br><br>   
 <%           
'######################################
	If Frc = "" Then	  		  '' ###  => Choix Effectué - Affichage des Formules non Validées Frc 
'######################################
%>		
			<table width="90%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#859AA6" summary="" rules="rows" frame="hsides">
			    <tr bgcolor="#EEEEEE">
			      <td height="25" align="center"><b>N°</b></td>
			      <td height="25" align="center"><b>Date</b></td>
			      <td height="25" align="center"><b>Formule</b></td>
			      <td height="25" align="center"><b>Produit</b></td>
			      <td height="25" align="center"><b>Qualité</b></td>
			      <td height="25" align="center"><b>Tonnage</b></td>
			      <td height="25" align="center"><b>&nbsp;</b></td>
			    </tr>
		<%
				If Fo1 = "" Then
					Response.Write "<tr><td height=""50"" colspan=""7"" valign=""middle"" align=""center"">" & Img
					Response.Write " &nbsp;<font face=""Verdana"" size=""2""><b> - &nbsp;Aucune Formule Disponible !</b></font></td></tr>"
				Else
					Response.Write Fo1
				End If
		%>
			</table>
			
			<table width="500" border="0" align="center" cellpadding="0" cellspacing="0" summary="">
				<tr><td width="500" height="20" align="right" valign="middle"><font face="Verdana" size="1">* Les Poids sont exprimés en Kilogrammes</font></td></tr>
			</table>
		
			 <br>
			
			<!--#include file="../include/inc_paging.asp" -->
			
			<br><br>
			
<%

'######################################
	ElseIf Frc = "0" Then  		''	###  => Choix Effectué - Saisie des Informations de Validation de la Fomule Sélectionnée
'######################################
								 
	'### - Annulation de l'action Rafraichissement (Bouton F5) - Vérification de l'état de Validation
				Session(Nom_Page) 	= ""					

	'### - Récupération des Valeurs de la Formule Sélectionnée
				Fo1 = Int(Sigec("Fo1"))

				Dim Link
					Link = "?Frc=0&Up_Frc=Yes&Fo1=" & Fo1 & rSearch
					Link = "?sigec=" & Server.UrlEncode(Encrypt(Link))

					LinkBv = "?Fo1=" & Fo1 & rSearch
					LinkBv = "?sigec=" & Server.UrlEncode(Encrypt(LinkBv))

					bvUrl = "Afficher('Verification_BV', '../all_print/affiche_lot_bv.asp" & LinkBv& "', 100, 100, 600, 500, 0, 0, 0, 1, 1);"
					
				If Request("Dt")  = "" Then Dt  = Date() Else Dt  = Request("Dt")
				''If Request("Num") = "" Then Num = "" 	 Else Num = Request("Num")
			
%>

	<form action="frc.asp<%=Link%>" method="post" Name="Frc" id="Frc" enctype="application/x-www-form-urlencoded" target="_self">
	
		<!--#include file="../all_user/detail_fo1_redev.asp" -->
	
		<br /><h1>Validation &nbsp;~&nbsp; FRC</h1><br />
	
		<table width="450" border="0" align="center" cellpadding="2" cellspacing="2" summary="">
<% If Int(Lot_Bv) = 0 Then %>
			<tr>
				<td width="200" height="24" align="right" valign="middle">Date Frc :</td>
				<td width="250" height="24" align="left" valign="middle">&nbsp;<%Call Zone_Txt("Dt","20","22",Dt,"10", 0, "")%></td>
			</tr>			
			<tr>
				<td height="45" align="center" valign="bottom" colspan="2">&nbsp;<input type="checkbox" name="Valider" id="Valider">Valider</td>
			</tr>
			<tr>
				<td height="45" align="center" valign="bottom" colspan="2">&nbsp;<input type="image" src="../images/frm_ok.gif" border="0" alt="Valider la Saisie" align="absmiddle" id="frm_ok"></td>
			</tr>
<% Else %>
			<tr>
				<td height="45" align="center" valign="bottom" colspan="2"><font size="2" face="Verdana" color="red"><b>Vous ne pouvez pas valider la formue: BV périmé(s).</b><br> <a href="javascript:<%=bvUrl%>">Consulter les BV</a></font></td>
			</tr>
<% End If %>

		</table>

	</form>

<%		
'######################################
	ElseIf Frc = "1" And Edit = "0" Then  '' ###  => Choix Effectué - Edition de la Formule Sélectionnée (10/07/09)
'######################################
								 
	'### - Annulation de l'action Rafraichissement (Bouton F5) - Vérification de l'état de Validation
				Session(Nom_Page) 	= ""					

	'### - Récupération des Valeurs de la Formule Sélectionnée
				Fo1 = Int(Sigec("Fo1"))
		
		Link = "?Edit=5&Up_Edit=Yes&Fo1=" & Fo1 & rSearch
		Link = "?sigec=" & Server.UrlEncode(Encrypt(Link))
			
%>
	<form action="frc.asp<%=Link%>" method="post" Name="Edition" id="Edition" enctype="application/x-www-form-urlencoded">
	
		<!--#include file="../all_user/detail_fo1.asp" -->
	
		<br /><h1>Edition des Formules</h1><br />
	
		<table width="400" border="0" cellpadding="0" cellspacing="0" summary="" align="center">
			<tr><td align="center" valign="middle" width="400" height="50"><input type="checkbox" name="Editer" value="Editer">&nbsp;&nbsp;Editer</td></tr>
			<tr><td align="center" valign="middle" width="400" height="50"><input type="image" src="../images/frm_ok.gif" border="0" alt="Valider l'Edition de la Formule" align="absmiddle" id="frm_ok2"></td></tr>
		</table>
	
	</form>

<%		

'################
	End If	' ###  => Fin Option
'################

%>


<%
	
	'### - Récupération des Options de Validation
		Edit 	= Sigec("Edit")
		Up_Edit = Sigec("Up_Edit")
	
'####################################
	If Up_Edit = "Yes" Then  '' ###  => Choix Effectué - Validation de l'Edition de la Formule dans la Base de Données
'####################################

	'### - Récupération des Valeurs de la Formule Sélectionnée
				 Fo1 = Int(Sigec("Fo1"))

	'### - Déclaration des Variables
				Erreur = 0
								 
	'### - Controle du Formulaire
					
				If Fo1 = "" Or Request("Editer") = "" Then
					Err_Msg = Err_Msg & "Une Erreur  inatendue s'est produite."
					Err_Msg = Err_Msg & "Veuiller vérifier les informations saisies !"
					Err_Msg = Err_Msg & "Si l'Erreur persiste, veuillez contacter l'Administrateur !"
					Erreur = 1
				Else
					If Request("Editer") = "" Then
						Erreur = 1 : Err_Msg = Err_Msg & "Veuillez cocher la case "" Editer "" !"
					End If
					 
				End If
				
				If Erreur = 1 Then
					Edit  = "0" : Frc = "1"
				End If
					
				If Session(Nom_Page) <> "" Then 
					Frc = ""
				Else
					If Erreur = 0 Then
	
						'### - Création de la Commande à Exécuter
								Set Cmd_Db = Server.CreateObject("AdoDB.Command")
									Cmd_Db.ActiveConnection = ado_Con
									Cmd_Db.CommandText = "Ps_Tech_Edit_Fo1"
									Cmd_Db.CommandType = adCmdStoredProc
					
						'### - Définition des Paramètres de la Procédure Stockée SQL
									Set Pm_Out		= Cmd_Db.CreateParameter("@Output", adInteger, adParamOutput)				: Cmd_Db.Parameters.Append Pm_Out
									Set Pm_Code		= Cmd_Db.CreateParameter("@Code", adVarChar, adParamInput, 3, Code)			: Cmd_Db.Parameters.Append Pm_Code
									Set Pm_Type		= Cmd_Db.CreateParameter("@Type", adVarChar, adParamInput, 25, "Valide")	: Cmd_Db.Parameters.Append Pm_Type
									Set Pm_Fo1		= Cmd_Db.CreateParameter("@Fo1", adInteger, adParamInput, , Fo1) 			: Cmd_Db.Parameters.Append Pm_Fo1
									Set Pm_Page		= Cmd_Db.CreateParameter("@Page", adInteger, adParamInput, , 0)				: Cmd_Db.Parameters.Append Pm_Page
									Set Pm_PageSize	= Cmd_Db.CreateParameter("@PageSize", adInteger, adParamInput, , 0)			: Cmd_Db.Parameters.Append Pm_PageSize
		
									Set Pm_Search	= Cmd_Db.CreateParameter("@Search", adVarChar, adParamInput, 1000, Null)	: Cmd_Db.Parameters.Append Pm_Search
						
						'### - Exécution de la Commande SQL
									Cmd_Db.Execute
													
							   		'### - Vérification du Paramètre de Retour et Affichage du Message de Confirmation
									Set Retour = Pm_Out
									
									If Retour > 0 Then	 	'### - Aucune Erreur
										Err_Msg = Err_Msg & "Edition de la Formule Validée !"
										Session(Nom_Page) 	= Retour					
										Frc = ""
										
										Log Fo1, "Fo1", "Edition - Formule" 					
	%>
										<script LANGUAGE="JScript">
											var Fo1 = "'toolbar=yes, menubar=yes, location=no, directories=no, status=yes, resizable=yes, scrollbars=yes width=700, height=500, left=80, top=80";
											window.open('../all_print/formule.asp<%="?sigec=" & Server.UrlEncode(Encrypt("?Fo1=" & Fo1))%>', '', Fo1);
										</script>  
	<%
									Else		   			'### - Erreur Rencontrée
										Err_Msg = Err_Msg & "Une Erreur "& Retour & " inatendue s'est produite."
										Err_Msg = Err_Msg & "Veuiller vérifier les informations saisies !"
										Err_Msg = Err_Msg & "Si l'Erreur persiste, veuillez contacter l'Administrateur !"
										Edit	= "0" : Frc = "1"
									End If
									
					End If
				End If
						
				
				
	'### - Fermeture des Objets de Connexion
				Set Cmd_Db  = Nothing

	'######################################
		End If 						  '' ###  => Fin Validation 
	'######################################
%>
	
	</div>                      
    		<div class="clearfloat" ></div>
            <div id="footer"> <!--#include file="../include/inc_basc.asp" --> </div>
    </div>

</body>
</html>















