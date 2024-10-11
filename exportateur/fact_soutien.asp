	<!--#include file="../include/inc_con.asp" -->
	<!--#include file="../include/fonction.asp" -->
	<!--#include file="../include/encryption.asp" -->
	
	
<%		
		'If Session("Login") = False Or IsNull(Session("Login")) = True Then Response.Redirect "../expire.asp" End If
		
		Dim Choix_Chq, Link
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>Le Conseil du Café-Cacao - Création Facture Soutien - <%=Session("Nom_Complet")%></title>
	<meta http-equiv="content-type" content="text/html; charset=iso-8859-1">
	<link href="../include/global.css" type="text/css" rel="stylesheet">
    <link type="text/css" href="../css/app3.css" rel="stylesheet">
    <link type="text/css" href="../css/jquery-ui-1.8.5.custom.css" rel="stylesheet">
    <link type="text/css" href="../css/css-buttons.css" rel="stylesheet">
    <script type="text/javascript" src="../js/menu_file/stm31.js"></script>
    <script type="text/javascript" src="../js/mesJS.js"></script>
    <script type="text/javascript" src="../js/jquery-1.4.2.min.js"></script>
    <script type="text/javascript" src="../js/jquery-ui-1.8.5.custom.min.js"></script>    
    
    <style>
        #mainContent {
            padding: 0 1px;
        }
        #otable{
            width: 98%;
            height: 350px;
            overflow: auto;
        }
        .Mt{
            text-align: right;
        }
        .iSaisie{                       
            border: 1px solid #d7f0fb;
        }
    </style>
</head>    
<body class="page">
	<div id="container">
       <!-- Zone : En tête -->
        <div id="header"> <!--include file="../include/inc_hautc.asp" --> </div>
        <div id="sidebar">  </div>         
        <div id="mainContent">
			          
<%					
'####################################
	If Choix_Chq = "" Then		' ###  => Choix Effectué - Affichage des Formules en soutien 
'####################################
%>				
            <h1>Formules de soutien à traiter</h1>
			<br />						
            <form method="post" action="fact_soutien.asp<%=Link%>" id="frm_Search">                
                <table>
                    <!--
                    <tr>
                        <td>
                            <span style="font-size: 14px;"> Liste de Fo1 séparées par des ";"<br /></span>
                            <textarea name="ListFo1" id="ListFo1" cols="50" rows="5"></textarea>
                        </td>
                    </tr>
                    -->
                    <tr>
                        <td>
                            <select id="SelectList" name="SelectList"><%=options%></select>
                            <input type="hidden" name="ListFo1"  id="ListFo1" />
                            <input type="button" class="button dark" value="OK" id="btn_ok" />
                        </td>
                    </tr>
                </table>
                <p></p>
                <input type="hidden" name="Prdt" id="Prdt" />
                <input type="hidden" name="Rclt" id="Rclt" />
                <input type="hidden" name="Camp" id="Camp" />
                <input type="hidden" name="Parite" id="Parite" />
                <input type="hidden" name="ListId" id="ListId" />
                <div id="otable">
                    <table width="100%" border="1" align="center" cellpadding="5" cellspacing="0" bordercolor="#859AA6" rules="rows" frame="hsides">
			            <tr bgcolor="#EEEEEE" height="25">
			              <th align="center"><b>N°</b></td>
			              <th align="center"><b>Période</b></td>
			              <th align="center"><b>N° CV</b></td>
			              <th align="center"><b>Prix</b></th>
                          <th align="center"><b>N° Fo1</b></th>
                          <th align="center"><b>Date Fo1</b></th>
                          <th align="center"><b>Poids Fo1</b></th>
                          <th align="center"><b>Poids Réel</b></th>
                          <th align="center"><b>Ecart</b></th>
                          <th align="center"><b>Taux R/S</b></th>
			              <th align="center"><b>&nbsp;</b></th>
			            </tr>
                        <tr height="25">
                            <td colspan="9">Aucune formule disponible</td>
                        </tr>
			        </table>           
		        </div>
                <br />
                <input type="button" class="button blue" id="btn" value="Créer facture" />
            </form>      
					
			<br><br>
			
<%
'####################################
	ElseIf Choix_Chq = "1" Then	' ###  => Choix Effectué - Saisie des Chèques dans le Formulaire Web
'####################################

	'############################################################
	'#####  Récupération des Formules - Chèques Non Saisis  #####  
	'############################################################ 
	
		'### - Annulation de l'action Rafraichissement (Bouton F5) - Vérification de l'état de Validation
					Session(Nom_Page) 	= ""					
		
		'### - Déclaration des Variables
					Dim Zero, aLink, FrmSaisie, Ch, jk, FrmReverst
				
		'### - Récupération des Valeurs de la Formule Sélectionnée
					ListeF = Request("ListId") 'replace(,",",";")					
                    Prdt = Request("Prdt")
                    Camp = Request("Camp")
                    Parite = Request("Parite")
                    Rclt = Request("Rclt")
          'response.write "prdt:" & Prdt & "camp:" & camp & "parite:" & parite & "recolte:" & Rclt  & " List:" & ListeF
                    
		'### - Création de la Commande à Exécuter
					Set Cmd_Db = Server.CreateObject("AdoDB.Command")
						Cmd_Db.ActiveConnection = ado_Con
						Cmd_Db.CommandText = "Ps_Exp_FactSoutien"
						Cmd_Db.CommandType = adCmdStoredProc
	
		'### - Définition des Paramètres de la Procédure Stockée SQL
					Set Pm_Out		= Cmd_Db.CreateParameter("@Output", adInteger, adParamOutput)				: Cmd_Db.Parameters.Append Pm_Out
					Set Pm_Code		= Cmd_Db.CreateParameter("@Code", adVarChar, adParamInput, 3, Code)			: Cmd_Db.Parameters.Append Pm_Code
                    Set Pm_Type	    = Cmd_Db.CreateParameter("@Option", adVarChar, adParamInput, 25, "Saisie")	: Cmd_Db.Parameters.Append Pm_Type
					Set Pm_Id	    = Cmd_Db.CreateParameter("@Id", adInteger, adParamInput, , 0) 			    : Cmd_Db.Parameters.Append Pm_Id
                    Set Pm_Search	= Cmd_Db.CreateParameter("@Search", adVarChar, adParamInput, 1000, "")	: Cmd_Db.Parameters.Append Pm_Search
                    Set Pm_Prdt	    = Cmd_Db.CreateParameter("@Prdt", adInteger, adParamInput, , Prdt) 			: Cmd_Db.Parameters.Append Pm_Prdt
                    Set Pm_Rclt	    = Cmd_Db.CreateParameter("@Reclt", adInteger, adParamInput, , Rclt) 		: Cmd_Db.Parameters.Append Pm_Rclt
                    Set Pm_Camp	    = Cmd_Db.CreateParameter("@Camp", adInteger, adParamInput, , Camp) 			: Cmd_Db.Parameters.Append Pm_Camp
                    Set Pm_Parite	= Cmd_Db.CreateParameter("@Parite", adInteger, adParamInput, , Parite) 		: Cmd_Db.Parameters.Append Pm_Parite
                    Set Pm_ListeF	= Cmd_Db.CreateParameter("@ListForm", adVarChar, adParamInput, 2000, ListeF)	: Cmd_Db.Parameters.Append Pm_ListeF					
		
		'### - Exécution de la Commande SQL
					Set rs_Ch = Cmd_Db.Execute
				
		'### - Affichage des Résultats de la Procédure SQL
					img = "<img src=""../images/warning.gif"" align=""absmiddle"" border=""0"" width=""33"" height=""34"" alt=""Alerte !"">"
				
					Nb = 1 : i = 0 : FrmReverst = ""
                    Dim Per1, Per2, sTaux, sTPoids, TPoids, MtReel, sMtReel, sTPoidsReel, sTPoidsFact, TPoidsReel, TPoidsFact, sEcart, Ecart
                        Per1 = "" : Per2 = "" : sTPoids = 0 : k = 0
                        TPoids = 0 : MtReel = 0 : sTPoidsFact = 0
                        sEcart = 0 : Ecart = 0

					Do Until rs_Ch Is Nothing
					
						Count = 0
						
						While Not rs_Ch.EOF
						
							'############################
								If Nb = 1 Then		' ###  => Jeu de Résultats N° 1 - Récupération de la campagne, du produit, de la recolte/parité des formules selectionnées
							'############################
                                    
                            		Campagne = rs_ch("CAMPAGNE")   
                                    Produit = rs_ch("PRODUIT")
                                    Recolte = rs_ch("RECOLTE")                                                                      
                                                                                                          								
							'############################
								ElseIf Nb = 2 Then	' ###  => Jeu de Résultats N° 2 - Récupération des Informations des formules Sélectionées
							'############################
                                
                                Per1 = rs_ch("PER_ID")  
                                If Per1 <> Per2 Then 
                                    If FrmReverst <> "" Then                                         
                                        FrmReverst = FrmReverst & _
                                             "<tr bgcolor=""#EEEEEE"" height=""25"">" & _
                                                "<td colspan=""5""><b>S/TOTAL " & Periode & "</b> : </td>" & _
                                                "<td><b>" & Prix(sTPoids) & "</b></td>" & _
                                                "<td><input type=""text"" name=""txtsPoids" & k & """ size=""8"" value=""" & Prix(Abs(sTPoidsReel)) & """ /></td>" & _ 
                                                "<td>" & Prix(Abs(sTPoidsFact)) & "</td>" & _                                               
                                                "<td> - </td>" & _
                                                "<td> - </td>" & _
                                                "<td> - </td>" & _
                                                "<td><input type=""text"" name=""txtsMt" & k & """ size=""10"" value=""" & Prix(Abs(sMtReel)) & """ /></td>" & _
                                            "</tr>"
                                            sTPoids = 0  : k = k+1  
                                            sMtReel = 0 : sTPoidsReel = 0 : sTPoidsFact = 0                                        
                                    End If
                                    Periode = rs_ch("PERIODE") 
                                    FrmReverst = FrmReverst & "<tr height=""25""><td colspan=""9""><b>" & rs_ch("PERIODE") & "</b></td></tr>" 
                                End If

                                '### - Si PoidsReel > 0 => On calcule l'ecart
                                sEcart = 0
                                If rs_ch("POIDS_REEL") > 0 Then sEcart = rs_ch("POIDS_REEL")-rs_ch("POIDS_FO1")
                                  
								FrmReverst = FrmReverst & "<tr height=""25"">" & vbNewLine & _										
                                                                "<td><input type=""hidden"" name=""txtModeCal" & k & "_" & i & """ id=""txtModeCal" & k & "_" & i & """ value=""" & rs_ch("MODECALCUL") & """ />" & rs_ch("CDC_CGFCC") & "</td>"& vbNewLine & _                                                                
                                                                "<td>" & Prix(rs_ch("POIDS_CDC")) & "</td>"& vbNewLine & _
                                                                "<td>" & Prix(rs_ch("CAF_REF")) & "</td>"& vbNewLine & _
                                                                "<td>" & rs_ch("NUM_FRC") & "<input type=""hidden"" name=""txtFo1" & k & "_" & i & """ id=""txtFo1" & k & "_" & i & """ value=""" & rs_ch("Fo1_Id") & """ /></td>"& vbNewLine & _
                                                                "<td>" & FormatDateTime(rs_ch("DATE_FRC"),2) & "</td>"& vbNewLine & _
                                                                "<td><input type=""hidden"" name=""txtPoidsFo1" & k & "_" & i & """ id=""txtPoidsFo1" & k & "_" & i & """ value=""" & rs_ch("POIDS_FO1") & """ />" & Prix(round(rs_ch("POIDS_FO1"),0)) & "</td>"& vbNewLine & _
                                                                "<td><input type=""text"" name=""txtPoids" & k & "_" & i & """ id=""txtPoids" & k & "_" & i & """ size=""8"" value=""" & rs_ch("POIDS_REEL") & """ readonly=""readonly"" /></td>"& vbNewLine & _
                                                                "<td><input type=""text"" name=""txtPoidsFact" & k & "_" & i & """ id=""txtPoidsFact" & k & "_" & i & """ size=""8"" value=""" & rs_ch("POIDS_FACT") & """ readonly=""readonly"" /></td>"& vbNewLine & _
                                                                "<td>" & Prix(Abs(rs_ch("TAUXRS"))) & "<input type=""hidden"" name=""txtTx" & k & "_" & i & """ id=""txtTx" & k & "_" & i & """ value=""" & replace(Abs(rs_ch("TAUXRS")),",",".") & """ /></td>"& vbNewLine & _ 
                                                                "<td><input type=""text"" name=""txtEcartv" & k & "_" & i & """ id=""txtEcartv" & k & "_" & i & """ size=""4"" value=""" & round(sEcart,0) & """ /></td>"& vbNewLine & _
                                                                "<td><input type=""text"" name=""txtEcartp" & k & "_" & i & """ id=""txtEcartp" & k & "_" & i & """ size=""3"" value=""" & round(sEcart*100/rs_ch("POIDS_FO1"),3) & """ /></td>"& vbNewLine & _                                                                
                                                                "<td><input type=""text"" name=""txtMt" & k & "_" & i & """ size=""10"" id=""txtMt" & k & "_" & i & """ value=""" & Abs(rs_ch("MONTANT")) & """ /></td>"& vbNewLine & _                                                               
                                                          "</tr>"													
						       Per2 = Per1 : i = i+1
                               sTPoids = sTPoids + round(rs_ch("POIDS_FO1"),0)
                               sMtReel = sMtReel + round(rs_ch("MONTANT"),0)  
                               sTPoidsReel = sTPoidsReel + round(rs_ch("POIDS_REEL"),0)
                               sTPoidsFact = sTPoidsFact + round(rs_ch("POIDS_FACT"),0)

                               TPoids = TPoids + round(rs_ch("POIDS_FO1"),0)

                               MtReel = MtReel + round(rs_ch("MONTANT"),0)
                               TPoidsReel = TPoidsReel + round(rs_ch("POIDS_REEL"),0)
                               TPoidsFact = TPoidsFact + round(rs_ch("POIDS_FACT"),0)

							'############################
								ElseIf Nb = 3 Then	' ###  => Jeu de Résultats N° 3 - Sélection de la Liste des Banques
							'############################
                            		
									Bank = Bank & vbNewLine & "<option value='" & rs_Ch("DOMBANK_ID") & "'>&nbsp;&nbsp;" & rs_Ch("Bank") & "</option>"	
                                                                                                            									                                                                      	 			
							'###############
								End If ' ###  => Fin de Sélection du Jeu de Résultats 
							'###############
							
							Count = Count + 1
							
							rs_Ch.MoveNext

                            If Nb = 2 And rs_Ch.Eof Then
                            FrmReverst = FrmReverst & _
                                             "<tr bgcolor=""#EEEEEE"" height=""25"">" & _
                                                "<td colspan=""5""><b>S/TOTAL " & Periode & "</b> : </td>" & _
                                                "<td><b>" & Prix(sTPoids) & "</b></td>" & _
                                                "<td><input type=""text"" name=""txtsPoids" & k & """ size=""8"" value=""" & Prix(Abs(sTPoidsReel)) & """ /></td>" & _   
                                                "<td>" & Prix(Abs(sTPoidsFact)) & "</td>" & _                                                
                                                "<td> - </td>" & _
                                                "<td> - </td>" & _
                                                "<td> - </td>" & _
                                                "<td><input type=""text"" name=""txtsMt" & k & """ size=""10"" value=""" & Prix(Abs(sMtReel)) & """ /></td>" & _
                                            "</tr>"  
                            End If
							
						Wend
						
						Set rs_Ch = rs_Ch.NextRecordset
						
						Nb = Nb + 1
						
					Loop
					
		'### - Fermeture des Objets de Connexion
					'rs_Ch.Close
					
					Set rs_Ch  = Nothing
					Set Cmd_Db = Nothing									
					 
			Link = "?Check_Chq=Yes&Choix_Chq=0&Ch=" & i & "&k=" & k & rSearch
			Link = "?sigec=" & Server.UrlEncode(Encrypt(Link))             			  
	
%>

<form action="fact_soutien.asp<%=Link%>" method="post" Name="Chq" id="Chq" enctype="application/x-www-form-urlencoded">

	<br /><h1>Saisie des Infos de la facture</h1><br />			
    <table width="100%" cellpadding="0" cellspacing="0" align="center">
        <tr height="25">
            <td align="left">Campagne</td><td align="left">: <%=Campagne%></td> <td align="left">N° Facture</td><td align="left">: <input type="text" name="txtFact" id="txtFact" /></td>
        </tr>
        <tr height="25">
            <td align="left">Produit</td><td align="left">: <%=Produit%></td> <td align="left">Date Facture</td> <td align="left">: <input type="text" name="DateFact" id="DateFact" /></td> 
        </tr>
        <tr height="25">
            <td align="left">Récolte</td><td align="left">: <%=Recolte%></td> <td align="left">Domiciliation bancaire</td> <td align="left">: <select name="Banq" id="Banq"><option></option><%=bank%></select></td> 
        </tr>  
    </table>
    <br /><br />

    <table width="100%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#859AA6" rules="rows" frame="hsides">
        <tr bgcolor="#EEEEEE" height="25">
            <th>CV</th>
            <th>Tonnage</th>
            <th>Prix</th>
            <th>Fo1</th>
            <th>Date Fo1</th>
            <th>Poids Fo1</th>
            <th>Poids Réel</th>
            <th>Poids Facturé</th>
            <th>Taux</th>
            <th>Ecart</th>
            <th>Ecart %</th>
            <th>Montant</th>
        </tr>
        <%=FrmReverst%>
        <tr>
            <th colspan="6">TOTAL FACTURE : </th>
            <th><input type="text" size="10" name="vTotal" id="vTotal" readonly="readonly" value="<%=Prix(TPoidsReel)%>" /></th>
            <th><input type="text" size="10" name="PoidsFact" id="PoidsFact" readonly="readonly" value="<%=Prix(TPoidsFact)%>" /></th>
            <th></th>
            <th></th>
            <th colspan="2"><input type="text" size="20" name="mtTotal" id="mtTotal" readonly="readonly" value="<%=Prix(Abs(MtReel))%>" /></th>
        </tr> 
    </table>	
	<table width="500" border="0" align="center" cellpadding="0" cellspacing="0" summary="">
		<tr><td width="500" height="20" align="right"><font face="Verdana" size="1">* Les Poids sont exprimés en Kilogrammes</font></td></tr>
	</table>
	<br /><br />
            <input type="hidden" name="Prdt" id="Prdt" value="<%=Prdt%>" />
            <input type="hidden" name="Rclt" id="Rclt" value="<%=Rclt%>" />
            <input type="hidden" name="Camp" id="Camp" value="<%=Camp%>" />
            <input type="hidden" name="Parite" id="Parite" value="<%=Parite%>" />
            <input type="hidden" name="txtOT" id="txtOT" value="--">
			<input type="image" src="../images/frm_ok.gif" alt="Valider la Saisie" id="frm_ok" />
	<br /><br />

</form>

<%
'################
	End If	'' ###  => Fin Option
'################
%>
		</div> 
				<div class="clearfloat" ></div>
				<div id="footer"> <!--include file="../include/inc_basc.asp" --> </div>
	</div>	
    <script type="text/javascript">
        $(function () {

            var ListFo1 = "";
            $('input[name^=txtPoids]').addClass("iSaisie");
            $("#Debut").datepicker({ dateFormat: 'dd/mm/yy', dayNamesMin: ['Di', 'Lu', 'Ma', 'Me', 'Je', 'Ve', 'Sa'], changeMonth: true });
            $("#Fin").datepicker({ dateFormat: 'dd/mm/yy', dayNamesMin: ['Di', 'Lu', 'Ma', 'Me', 'Je', 'Ve', 'Sa'], changeMonth: true });
            $("#DateFact").datepicker({ dateFormat: 'dd/mm/yy', dayNamesMin: ['Di', 'Lu', 'Ma', 'Me', 'Je', 'Ve', 'Sa'], maxDate: +0 });
            $('input[name^=txtPoids],input[name^=txtMt],input[name^=txtsPoids],input[name^=txtsMt],input[name^=txtEcart],#PoidsFact,#vTotal,#mtTotal').addClass("Mt");
            $('input[name^=txtMt],input[name^=txtEcart]').attr("readonly", "readonly");
            $('input[name^=txtsPoids],input[name^=txtsMt]').attr("disabled", "disabled");

            $("#SelectList").change(function () {

                var params = $(this).val().split('&');
                $("#otable").html('<img src="../images/ajax-loader.gif" border="0" />');
                
                $.ajax({
                    url: '../all_user/liste_fo1_soutien.asp',
                    data: 'Prdt=' + params[0] + '&Camp=' + params[1] + '&Rclt=' + params[2] + '&Parite=' + params[3] + '&ListFo1=' + $("#ListFo1").val(),
                    type: 'GET',
                    dataType: 'html',
                    success: function (tr) {
                        $("#otable").html(tr);
                        $('#Prdt').val(params[0]);
                        $('#Camp').val(params[1]);
                        $('#Rclt').val(params[2]);
                        $('#Parite').val(params[3]);
                    },
                    error: function (resultat, statut, erreur) {
                        $("#otable").html('Une erreur inattendue est intervevue!');
                    }
                });
            });


            $("#btn_ok").click(function () {
                var params = $('#SelectList').val().split('&');
                $("#otable").html('<img src="../images/ajax-loader.gif" border="0" />');
                $.ajax({
                    url: '../all_user/liste_fo1_soutien.asp',
                    data: 'Prdt=' + params[0] + '&Camp=' + params[1] + '&Rclt=' + params[2] + '&Parite=' + params[3] + '&ListFo1=' + $("#ListFo1").val(),
                    type: 'GET',
                    dataType: 'html',
                    success: function (tr) {
                        $("#otable").html(tr);
                        $('#Prdt').val(params[0]);
                        $('#Camp').val(params[1]);
                        $('#Rclt').val(params[2]);
                        $('#Parite').val(params[3]);
                    },
                    error: function (resultat, statut, erreur) {
                        $("#otable").html('Une erreur inattendue est intervevue!');
                    }
                });
            });

            $('#msg').dialog({
                width: 460,
                modal: true,
                //autoOpen:true,
                buttons: {
                    'OK': function () { $(this).dialog('close'); }
                }
            });

            $('#btn').click(function () {

                var msg = "", sListe = "", vir = '';
                $('input[type=checkbox]:checked').each(function (i) {
                    vir = (i == 0) ? '' : ',';
                    sListe = sListe + vir + $(this).val();
                });

                if (sListe == '') msg = "<br />Veuillez cocher les formules à traiter !";
                else $('#ListId').val(sListe);

                if (msg == "") {

                    $('#dialog').html("<br />Confirmez-vous le traitement de ces formules ?").dialog({
                        width: 460,
                        modal: true,
                        autoOpen: true,
                        buttons: {
                            'Oui': function () { $(this).dialog('close'); $('#frm_Search').submit(); },
                            'Non': function () { $(this).dialog('close'); return false; }
                        }
                    });
                    return false;
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

            // -- Validation du formulaire de Saisie -- //
            $('#frm_ok').click(function () {
                var msg = "";
                if ($('#txtFact').val() == "") msg = "<br />Veuillez renseigner le numero de la facture !";
                if ($('#DateFact').val() == "") msg = "<br />Veuillez renseigner la date de la facture !";
                if ($('#Banq').val() == "") msg = "<br />Veuillez renseigner la banque pour la facture !";
                if ($('input[name="mtTotal"]').val() == "" || $('input[name="vTotal"]').val() == "") msg = "<br />Veuillez renseigner les poids réels !";

                if (msg == "") {

                    $('#dialog').html("<br />Confirmez-vous le traitement de la facture ?").dialog({
                        width: 460,
                        modal: true,
                        autoOpen: true,
                        buttons: {
                            'Oui': function () { $(this).dialog('close'); $('#Chq').submit(); },
                            'Non': function () { $(this).dialog('close'); return false; }
                        }
                    });
                    return false;
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
</body>
</html>











