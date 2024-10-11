	<!--#include file="../include/inc_con.asp" -->
	<!--#include file="../include/fonction.asp" -->
	<!--#include file="../include/encryption.asp" -->
	<!--#include file="../include/inc_var.asp" -->
	
<%		
		If Session("Login") = False Or IsNull(Session("Login")) = True Then Response.Redirect "../expire.asp" End If		

		'If Not Acces_Page   = True Then Response.Redirect "../refuse.asp" & "?sigec=" & Server.UrlEncode(encrypt("?Motif=Menu_Refuse")) End If

		'### - Redirection si Suspendue
					Dim ssLink
						ssLink = ""
					
		'### - Redirection si Suspendue de la Messagerie
					If Session("Sus_Mess") = 1 Then
						Link = "?sigec=" & Server.UrlEncode(encrypt("?Motif=Sus_Mess"))
						Response.redirect("../refuse.asp" & Link)
					End If

		'### - Redirection si Suspendue des Contrats'
					If Session("Sus_Cdc") = 1 Then
						ssLink = "?sigec=" & Server.UrlEncode(encrypt("?Motif=Sus_Cdc"))
						Response.redirect("../refuse.asp" & ssLink)
					End If

	'### - Déclaration des Variables
				Dim Code
				Dim Cmd_Db
				Dim Pm_Out, Pm_Code
				Dim rs_Cdc
				Dim Img
				Dim Cdc, Url, Url_1
				Dim Count
				Dim Pm_Option, Pm_Id, Id
				Dim Prepaye, Err_Msg, V_Prepaye
				
                Dim Pm_Ch, Pm_Mt, Pm_Struct, Pm_Bk, Pm_Dt, Pm_Chq, Pm_Str

				Dim Str
                Dim Cheque, Dates, Montant, Struct, Banque
                
	'### - Récupération des Variables Session Utilisateur
				Code  = Session("Code")
				
	'### - Pagination des Résultats renvoyés par la Procédure Stockée SQL
				Dim Nom_Page
					Nom_Page = "prep_saisie.asp"

				If (Len(Sigec("Page")) = 0) Or (IsNumeric(Sigec("Page")) = False) Then
					Page = 1
				Else
					Page = CInt(Sigec("Page"))
				End If

	'### - Récupération des Critères de Recherche 
					Dim Frm_Search
						Frm_Search = "Cdc" 
			%>
					<!--#include file="../all_user/user_sql.asp" -->
			<%

	'### - Récupération des Options de Validation
				Cdc   	  = Sigec("Cdc")
				Prepaye   = Sigec("Prepaye")
				V_Prepaye = Sigec("V_Prepaye")

'####################################
	If V_Prepaye = "Yes" Then		' ###  => Choix Effectué - Validation de la Saisie des Chèques Prépayés dans la Base de Données
'####################################

	'### - Déclaration des Variables
				Dim Erreur
					Erreur = 0
                    Dates = ""

								 
	'### - Controle du Formulaire

				If Cdc = "" Or Prepaye = "" Then 
					Err_Msg = Err_Msg & "Une Erreur inatendue s'est produite."
					Err_Msg = Err_Msg & "Veuiller vérifier les informations saisies !"
					Err_Msg = Err_Msg & "Si l'Erreur persiste, veuillez contacter l'Administrateur !"
					Erreur  = 1
				Else                                        

					Dates = Dates & Request("DtCheq")
					
					If Request("DtCheq") = "" And Err_Msg = "" Then
						Erreur = 1 : Err_Msg = Err_Msg & "La Date de Chèque n'est pas saisie !" 
					End If
					
					If Len(Request("DtCheq")) <> 10 And Err_Msg = "" Then 
						Erreur = 1 : Err_Msg = Err_Msg & "Une Date de Chèque n'est pas valide : jj/mm/aaaa !" 
					End If
										 
				End If								
				
				If Erreur = 1 Then
					Prepaye = "1"
				End If
			
				If Session(Nom_Page) <> "" Then 
					Prepaye = ""
				Else
					If Erreur = 0 Then 
	
						'###########################################################
						'#####  Récupération des Références de Chèques Saisis  #####  
						'###########################################################
						
							'### - Récupération des Informations du Formulaire																				
                                        
									Cdc 		= Int(Sigec("Cdc"))																																	
						
						'### - Création de la Commande à Exécuter
									Set Cmd_Db = Server.CreateObject("AdoDB.Command")
										Cmd_Db.ActiveConnection = ado_Con
										Cmd_Db.CommandText = "Ps_Tech_Prepaye"
										Cmd_Db.CommandType = adCmdStoredProc
					
						'### - Définition des Paramètres de la Procédure Stockée SQL
									Set Pm_Out		= Cmd_Db.CreateParameter("@Output", adInteger, adParamOutput)				: Cmd_Db.Parameters.Append Pm_Out
									Set Pm_Code		= Cmd_Db.CreateParameter("@Code", adVarChar, adParamInput, 3, Code)			: Cmd_Db.Parameters.Append Pm_Code
									Set Pm_Option	= Cmd_Db.CreateParameter("@Option", adVarChar, adParamInput, 10, "Valide")	: Cmd_Db.Parameters.Append Pm_Option
                                    Set Pm_Id		= Cmd_Db.CreateParameter("@Cdc", adInteger, adParamInput, , Cdc)			: Cmd_Db.Parameters.Append Pm_Id
                                    Set Pm_Dt 		= Cmd_Db.CreateParameter("@Date ", adVarChar, adParamInput, 8000, Dates )  	: Cmd_Db.Parameters.Append Pm_Dt 
										   
									Set Pm_Page		= Cmd_Db.CreateParameter("@Page", adInteger, adParamInput, , 0)			: Cmd_Db.Parameters.Append Pm_Page
									Set Pm_PageSize	= Cmd_Db.CreateParameter("@PageSize", adInteger, adParamInput, , 0)		: Cmd_Db.Parameters.Append Pm_PageSize
									Set Pm_Search	= Cmd_Db.CreateParameter("@Search", adVarChar, adParamInput, 8000, Null): Cmd_Db.Parameters.Append Pm_Search
	
						'### - Exécution de la Commande SQL
									Cmd_Db.Execute
				
						'### - Vérification du Paramètre de Retour et Affichage du Message de Confirmation								
				   		
									Dim Retour				'### - Vérification du Paramètre de Retour et Affichage du Message de Confirmation
									Set Retour = Pm_Out
									Erreur = 1
									If Retour > 0 Then	 	'### - Aucune Erreur
										Err_Msg = Err_Msg & " Chèques Prépayés Validés !"
										Session(Nom_Page) 	= Retour					
										Prepaye = ""
										
										Log Cdc, "CDC", "Validation des Chèques Prépayés - Cdc N° " & Cdc 					

									Else		   			'### - Erreur Rencontrée
										Err_Msg = Err_Msg & "Une Erreur (" & Retour & ") inatendue s'est produite."
										Err_Msg = Err_Msg & "Veuiller vérifier les informations saisies !"
										Err_Msg = Err_Msg & "Si l'Erreur persiste, veuillez contacter l'Administrateur !"
										Prepaye = "1"
									End If
									
					End If
				End If		
			
		'### - Fermeture des Objets de Connexion
				Set Cmd_Db = Nothing
						
'####################################
	End If 							' ###  => Fin Validation des Chèques dans la base de Données
'####################################
	
'####################################
	If Prepaye = "" Then	' ###  => Choix Effectué - Affichage de la Liste des CDC Emises 
'####################################

	'################################################################
	'#####  Récupération des Cdc - Chèques Prépayés Non Saisis  #####  
	'################################################################
	
		'### - Création de la Commande à Exécuter
					Set Cmd_Db = Server.CreateObject("AdoDB.Command")
						Cmd_Db.ActiveConnection = ado_Con
						Cmd_Db.CommandText = "Ps_Tech_Prepaye"
						Cmd_Db.CommandType = adCmdStoredProc
	
		'### - Définition des Paramètres de la Procédure Stockée SQL
					Set Pm_Out		= Cmd_Db.CreateParameter("@Output", adInteger, adParamOutput)				: Cmd_Db.Parameters.Append Pm_Out
					Set Pm_Code		= Cmd_Db.CreateParameter("@Code", adVarChar, adParamInput, 3, Code)			: Cmd_Db.Parameters.Append Pm_Code
					Set Pm_Option	= Cmd_Db.CreateParameter("@Option", adVarChar, adParamInput, 10, "Liste")	: Cmd_Db.Parameters.Append Pm_Option
					Set Pm_Id		= Cmd_Db.CreateParameter("@Cdc", adInteger, adParamInput, , 0)				: Cmd_Db.Parameters.Append Pm_Id
					
					Set Pm_Chq = Cmd_Db.CreateParameter("@Date", adVarChar, adParamInput, 8000, Null) 		: Cmd_Db.Parameters.Append Pm_Chq
					Set Pm_Page		= Cmd_Db.CreateParameter("@Page", adInteger, adParamInput, , Page)			: Cmd_Db.Parameters.Append Pm_Page
					Set Pm_PageSize	= Cmd_Db.CreateParameter("@PageSize", adInteger, adParamInput, , PageSize)	: Cmd_Db.Parameters.Append Pm_PageSize
					Set Pm_Search	= Cmd_Db.CreateParameter("@Search", adVarChar, adParamInput, 8000, Search)	: Cmd_Db.Parameters.Append Pm_Search
				
		'### - Exécution de la Commande SQL
					Set rs_Cdc = Cmd_Db.Execute
				
		'### - Affichage des Résultats de la Procédure SQL
			img = "<img src=""../images/warning.gif"" align=absmiddle border=0 width=33 height=34 alt=""Alerte !"">"
					
		Count = 0
		Cdc	  = ""
					
		Dim Records, Paging, aUrl

		While Not rs_Cdc.Eof
		
			Count = Count + 1
		
			Records	= rs_Cdc("Record_Count")		
			Paging 	= Int(Count + Int(PageSize * Int(Page - 1)))
		
			Url = "?Prepaye=1&Cdc=" & rs_Cdc("Cdc_ID") & "&Produit=" & rs_Cdc("PRODUIT") & rSearch
			Url = "?sigec=" & Server.UrlEncode(Encrypt(Url))
			Url_1 = "Afficher('Voir_cdc', '../all_print/affiche_cdc.asp" & Url & "', 100, 100, 500, 500, 0, 0, 0, 1, 1);"
			 
			aUrl = "?Print=Yes&Enr=" & rs_Cdc("ENR_ID") & rSearch
			aUrl = "?sigec=" & Server.UrlEncode(Encrypt(aUrl))
			aUrl = "Afficher('Avis_Enr', '../all_print/affiche_enr.asp" & aUrl & "', 100, 100, 600, 500, 0, 0, 0, 1, 1);"
																		
			Cdc = Cdc & "<tr height=""25"" valign=""middle"" id=""" & Count & "_h0"">" & vbNewLine & _
						"	<td align=""center"">" & Paging & "</td>" & vbNewLine &_
						"	<td align=""center"">" & FormatDateTime(rs_Cdc("DATE_CDC"), 2) & "</td>" & vbNewLine &_
						"	<td align=""center"">" & rs_Cdc("PRODUIT") & " " & rs_Cdc("GRADE") & "</td>" & vbNewLine &_
						"	<td align=""right"">" & Prix(rs_Cdc("POIDS")) & "</td>" & vbNewLine &_
						"	<td align=""center"">" & rs_Cdc("PER_REF") & "</td>" & vbNewLine &_
						"	<td align=""center"">" & rs_Cdc("REGION") & "</td>" & vbNewLine &_
						"	<td align=""center""><a href=""javascript:" & Url_1 & """>" & rs_Cdc("CDC_EXP") & "</a></td>" & vbNewLine &_
						"	<td align=""center""><a href=""prep_saisie.asp" & Url & """ target=""_self"">" & vbNewLine &_
						"	<img src=""../images/saisie.gif"" width=""15"" height=""13"" border=""0"" alt=""Saisie des Références des Chèques Prépayés""></a></td>" & vbNewLine &_
						"</tr>" & vbNewLine			
								
			rs_Cdc.MoveNext
			
		Wend
					
		'### - Fermeture des Objets de Connexion
					rs_Cdc.Close
	
					Set rs_Cdc = Nothing
					Set Cmd_Db = Nothing
	
'################
	End If	'' ###  => Fin Option
'################												
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>Le Conseil du Café-Cacao - Validation des Chèques Prépayés - <%=Session("Nom_Complet")%></title>
	<meta http-equiv="content-type" content="text/html; charset=iso-8859-1">
	<link href="../include/global.css" type="text/css" rel="stylesheet">
    <link type="text/css" href="../css/app.css" rel="stylesheet">
    <link type="text/css" href="../css/jquery-ui-1.8.5.custom.css" rel="stylesheet">
    <script type="text/javascript" src="../js/menu_file/stm31.js"></script>
    <script type="text/javascript" src="../js/jquery-1.4.2.min.js"></script>
    <script type="text/javascript" src="../js/jquery-ui-1.8.5.custom.min.js"></script>
    <script type="text/javascript">
		$(function() {			
			$("#Debut").datepicker( {dateFormat:'dd/mm/yy', dayNamesMin: ['Di', 'Lu', 'Ma', 'Me', 'Je', 'Ve', 'Sa'], changeMonth: true } );
			$("#Fin").datepicker( {dateFormat:'dd/mm/yy', dayNamesMin: ['Di', 'Lu', 'Ma', 'Me', 'Je', 'Ve', 'Sa'], changeMonth: true } );
			$("#DtCheq").datepicker( {dateFormat:'dd/mm/yy', dayNamesMin: ['Di', 'Lu', 'Ma', 'Me', 'Je', 'Ve', 'Sa'], changeMonth: true } );
			
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
					
				if($("#DtCheq").val() == "") msg = "<br />Vous devez saisie la date de traitement !";
				if($("#Valider").attr("checked") == false) msg = "<br />Vous devez cocher la case 'Valider' !";
		
				if(msg == ""){
						
						$('#dialog').html("<br />Confirmez-vous la Validation de ces Chèques Prépayés ?").dialog({
							width:460,
							modal:true,
							autoOpen:true,
							buttons:{
								'Oui':function(){ $(this).dialog('close'); $('#Prep').submit();},
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
	
    <script for="document" event="onclick()">Annule();</script>
    <script type="text/javascript">		
				
		 <!-- Hide from older browsers...
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
</head>    
<body class="page">
	<div id="container">
       <!-- Zone : En tête -->
        <div id="header"> <!--#include file="../include/inc_hautc.asp" --> </div>
        <div id="sidebar">        	
		<%
                Frm_Search 	= "Cdc" 
                Frm			= "Cdc" 
        %>
            <!--#include file="../all_user/user_search.asp" -->
        <%
                Dim Out
                    Out = "Cdc"
                    
                Search = Search & " And (IsNull(V_PREP, 0) = 1) AND (IsNull(V_PREPAYE, 0) = 0) "
        %>
            <!--#include file="../all_user/frm_stat.asp" -->
        </div>         
        <div id="mainContent">
			<div id="dialog" title="SIGEC4 - Traitement des Prépayés -"> </div>         
            <%If Erreur>0 Then %>
                <div id="msg" title="SIGEC4 - Traitement des Prépayés - ">
                    <p><span style="margin:0px 07px 50px 0px; float:left" class="ui-icon ui-icon-alert"></span> <%=Err_Msg%></p>
                </div>
            <%End If %>
            <br /><br />
            <img src="../images/tech_prepayes.gif" border="0" width="382" height="48" alt="Saisie des Références des Chèques Prépayés" align="middle">
			<br /><br />
<%					
'####################################
	If Prepaye = "" Then	'' ###  => Choix Effectué - Affichage de la Liste des CDC Emises 
'####################################
%>	


	<table width="90%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#859AA6" summary="" rules="rows" frame="hsides">
	    <tr bgcolor="#EEEEEE">
	      <td height="25" align="center"><b>N°</b></td>
	      <td height="25" align="center"><b>Date</b></td>
	      <td height="25" align="center"><b>Produit</b></td>
	      <td height="25" align="center"><b>Tonnage</b></td>
	      <td height="25" align="center"><b>Période</b></td>
	      <td height="25" align="center"><b>Dest.</b></td>
	      <td height="25" align="center"><b>Numéro CV</b></td>
          <td height="25" align="center"><b>&nbsp;</b></td>
	      <td height="25" align="center"><b>&nbsp;</b></td>
	    </tr>
	<%
		If Cdc = "" Then

				Response.Write "<tr><td height=50 colspan=9 valign=middle align=center>" & Img & "&nbsp;<font face=Verdana size=2><b> - &nbsp;Vous n'avez pas de CDC prépayés en cours !</b></font></td></tr>"
			
		Else
		
			Response.Write Cdc
			
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
'####################################
	ElseIf Prepaye = "1" Then	' ###  => Choix Effectué - Saisie des Chèques dans le Formulaire Web
'####################################

	'############################################################
	'#####  Récupération des Formules - Chèques Non Saisis  #####  
	'############################################################
	
		'### - Annulation de l'action Rafraichissement (Bouton F5) - Vérification de l'état de Validation
					Session(Nom_Page) 	= ""					
	
		'### - Récupération des Valeurs de la Cdc Sélectionnée
					
					Dim Produit, Prdt, Kfe_Kko, Dte, Grade, Net
					Dim Region, Periode, Recolte, Parite
					Dim Enr, Camps
					Dim Cdc_Exp, Provenance, Origine, Mere, Ar, Ar_Cdc, Ar_KfeKko
					Dim Nb, Bank, Ch
					Dim Zero, FrmSaisie
					Dim aLink										
				
		'### - Récupération des Valeurs de la Cdc Sélectionnée
					 Cdc = Int(Sigec("Cdc"))					 

		'### - Création de la Commande à Exécuter
					Set Cmd_Db = Server.CreateObject("AdoDB.Command")
						Cmd_Db.ActiveConnection = ado_Con
						Cmd_Db.CommandText = "Ps_Tech_Prepaye"
						Cmd_Db.CommandType = adCmdStoredProc
	
		'### - Définition des Paramètres de la Procédure Stockée SQL
					Set Pm_Out	  = Cmd_Db.CreateParameter("@Output", adInteger, adParamOutput)					: Cmd_Db.Parameters.Append Pm_Out
					Set Pm_Code	  = Cmd_Db.CreateParameter("@Code", adVarChar, adParamInput, 3, Code)			: Cmd_Db.Parameters.Append Pm_Code
					Set Pm_Option = Cmd_Db.CreateParameter("@Option", adVarChar, adParamInput, 10, "Saisie")	: Cmd_Db.Parameters.Append Pm_Option
					Set Pm_Id	  = Cmd_Db.CreateParameter("@Cdc", adInteger, adParamInput, , Cdc)				: Cmd_Db.Parameters.Append Pm_Id
		
		'### - Exécution de la Commande SQL
					Set rs_Cdc = Cmd_Db.Execute
				
		'### - Affichage des Résultats de la Procédure SQL
					img = "<img src=""../images/warning.gif"" align=""absmiddle"" border=""0"" width=""33"" height=""34"" alt=""Alerte !"">"				
					
					While Not rs_Cdc.EOF						
						
						FrmSaisie = FrmSaisie & "<table width=""90%"" border=""0"" cellspacing=""0"" cellpadding=""0"" align=""center"">"& vbNewLine & _
							  "<tr align=""left"">"& vbNewLine & _
								"<td rowspan=""2"" width=""30%""><b>" & rs_Cdc("STRCT") & "</b></td>"& vbNewLine & _
								"<td><b>CHEQUE</b></td>"& vbNewLine & _
								"<td>:  <span class=""val"">" & rs_Cdc("CH_REF") & "</span></td>"& vbNewLine & _
								"<td><b>MONTANT</b></td>"& vbNewLine & _
								"<td>:<span class=""val""> " & Prix(rs_Cdc("CH_MTT")) & " F CFA</span> </td>"& vbNewLine & _
							  "</tr>"& vbNewLine & _
							  "<tr align=""left"">"& vbNewLine & _
								"<td><b>DATE</b></td>"& vbNewLine & _
								"<td>: <span class=""val"">" & rs_Cdc("CH_DATE") & "</span></td>"& vbNewLine & _
								"<td><b>BANQUE</b></td>"& vbNewLine & _
								"<td>: <span class=""val"">" & rs_Cdc("BANK") & "</span></td>"& vbNewLine & _
							  "</tr>"& vbNewLine & _
							"</table><hr />"
																														
						rs_Cdc.MoveNext
						
					Wend
																
		'### - Fermeture des Objets de Connexion
					
					Set rs_Cdc  = Nothing
					Set Cmd_Db = Nothing							
                    

		Dim Link
			Link = "?Prepaye=1&V_Prepaye=Yes&Cdc=" & Cdc & rSearch
			Link = "?sigec=" & Server.UrlEncode(Encrypt(Link))
	
%>

<form action="prep_saisie.asp<%=Link%>" method="post" Name="Prep" id="Prep" enctype="application/x-www-form-urlencoded">

	<!--#include file="../all_user/detail_cdc.asp" -->

	<br /><h1>Références des Chèques</h1>
	    <table width="98%" border="0" cellpadding="0" cellspacing="0" summary="" align="center">
            <tr>
                <td align="left" valign="middle">	<%=FrmSaisie%> </td>
            </tr>
        </table>				
	<br /><br />
    	<table width="70%" border="0" cellspacing="0" cellpadding="2" align="center">
          <tr>
            <td align="right"><b>&nbsp;Date de traitement</b></td>
            <td align="left">&nbsp;: <input type="text" name="DtCheq" id="DtCheq" /></td>
          </tr>
          <tr>
            <td colspan="2" align="center"> <b>Valider&nbsp;</b><input type="checkbox" name="Valider" id="Valider" /></td>
          </tr>
        </table>
		<br />
		<input type="image" src="../images/frm_ok.gif" border="0" alt="Valider la Saisie" align="absmiddle" id="frm_ok">
		<br /><br /><br />
	
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











