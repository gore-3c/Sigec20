	<!--#include file="../include/inc_con.asp" -->
	<!--#include file="../include/fonction.asp" -->
	<!--#include file="../include/encryption.asp" -->
	<!--#include file="../include/inc_var.asp" -->
	
<%		
		If Session("Login") = False Or IsNull(Session("Login")) = True Then Response.Redirect "../expire.asp" End If		

		'If Not Acces_Page   = True Then Response.Redirect "../refuse.asp" & "?sigec=" & Server.UrlEncode(encrypt("?Motif=Menu_Refuse")) End If'
								
	'### - Declaration des Variables
				Dim Code
				Dim Edit, Err_Msg, Up_Edit
				Dim Cmd_Db
				Dim Pm_Out, Pm_Code, Pm_Type, Pm_Fo1
				Dim rs_Fo1, Count
				Dim Fo1, Url
				Dim Nb, Cool
				
                Dim tabFact, tabFo1, tabsTransmis, nFact, DtFact


	'### - Récupération des Variables Session Utilisateur
				Code  = Session("Code")			

	'### - Récupération des Valeurs de la Formule Sélectionnée
				Fo1 = Int(Sigec("Fo1"))
    
    '#####################################################
	'#####  Récupération des Formules - Non Editées  #####  
	'#####################################################

		'### - Création de la Commande à Exécuter
				Set Cmd_Db = Server.CreateObject("AdoDB.Command")
					Cmd_Db.ActiveConnection = ado_Con
					Cmd_Db.CommandText = "Ps_Exp_FactSoutien"
					Cmd_Db.CommandType = adCmdStoredProc
	
		'### - Définition des Paramètres de la Procédure Stockée SQL
				Set Pm_Out		= Cmd_Db.CreateParameter("@Output", adInteger, adParamOutput)				: Cmd_Db.Parameters.Append Pm_Out
				Set Pm_Code		= Cmd_Db.CreateParameter("@Code", adVarChar, adParamInput, 3, Code)			: Cmd_Db.Parameters.Append Pm_Code
				Set Pm_Type		= Cmd_Db.CreateParameter("@Type", adVarChar, adParamInput, 25, "Edit")		: Cmd_Db.Parameters.Append Pm_Type
				Set Pm_Fo1		= Cmd_Db.CreateParameter("@Fo1", adInteger, adParamInput, , Fo1) 			: Cmd_Db.Parameters.Append Pm_Fo1						
		
		'### - Exécution de la Commande SQL
					Set rs_Fo1 = Cmd_Db.Execute
				
		'### - Affichage des Résultats de la Procédure SQL									
			    Nb = 1
        Dim tabTransmis
        Dim sTPoids, sPReel, sPFact, sTotal, sMont, Per1, Per2, k
        Dim TPoids, Total, PReel, PFact, Mont, Periode
            sPReel = 0 : sTPoids = 0 : sTotal = 0 : sMont = 0 : i = 0 : k = 0 : Per1 = "" : Per2 = ""
			PReel = 0 : PFact = 0 : TPoids = 0 : Mont = 0 : Total = 0
	
		Do Until rs_Fo1 Is Nothing
					
			While Not rs_Fo1.Eof
						
				'############################
					If Nb = 1 Then		' ###  => Jeu de Résultats N° 1 - Informations de la facture globale sélectionnée	
				'############################

                        DtFact = rs_Fo1("DATE_FACTSOUT")

                        tabFact = "<tr align=""left""><td><b></b></td><td></td><td></td><td><b>DOIT:</b></td></tr>" & vbNewLine &_
                                    "<tr align=""left""><td width=""50""></td><td></td><td></td><td><b>Le Conseil du Café-Cacao <br />17 BP 797 Abidjan 17<br/>Tel: 20 26 69 69/20 25 69 70</b></td></tr>" & vbNewLine &_
                                    "<tr><td colspan=""4"">&nbsp;</td></tr>" & vbNewLine &_ 
                                    "<tr align=""left""><td><b>N° Facture</b></td><td>: &nbsp;" & rs_Fo1("NUM_FACTSOUT") & "</td><td><b>Référence CCC</b></td><td>:&nbsp;&nbsp;" & rs_Fo1("REF_FACTSOUT") & "</td></tr>" & vbNewLine &_
                                    "<tr align=""left""><td><b>N° OT</b></td><td>: &nbsp;" & rs_Fo1("Numero_OT") & "</td><td width=""120""><b>Date Facture </b></td><td>:&nbsp;&nbsp;" & rs_Fo1("DATE_FACTSOUT") & "</td></tr>" & vbNewLine &_   
                                    "<tr align=""left""><td><b>Campagne</b></td><td>: &nbsp;" & rs_Fo1("CAMPAGNE") & "</td><td><b></b></td><td></td></tr>" & vbNewLine &_ 
                                    "<tr align=""left""><td><b>Récolte</b></td><td>: &nbsp;" & rs_Fo1("RECOLTE") & "</td><td><b></b></td><td></td></tr>" & vbNewLine &_
                                    "<tr align=""left""><td><b>Produit</b></td><td colspan=""3"">: &nbsp;" & rs_Fo1("PRODUIT")  & "</td></tr>" & vbNewLine &_
                                    "<tr align=""left""><td><b>Domiciliation</b></td><td colspan=""3"">: &nbsp;" & rs_Fo1("BANK") & ", " & rs_Fo1("COMPTE")  & "</td></tr>" & vbNewLine
                                    										   
				'############################
					ElseIf Nb = 2 Then	' ###  => Jeu de Résultats N° 1 - Liste des formules de la facture
				'############################
						
                        Per1 = rs_Fo1("PERIODE")  
                        If Per1 <> Per2  Then 
                            If tabFo1 <> "" Then                                         
                                tabFo1 = tabFo1 & _
                                    "<tr bgcolor=""#EEEEEE"" height=""25"">" & _
                                        "<td colspan=""2""><b>S/TOTAL " & Periode & "</b> : </td>" & _ 
                                        "<td class=""right""><b>" & Prix(sTPoids) & "</b></td>" & _ 
                                        "<td class=""right""><b>" & Prix(sPReel) & "</b></td>" & _ 
                                        "<td class=""right""><b>" & Prix(sPFact) & "</b></td>" & _ 
                                        "<td> - </td>" & _ 
                                        "<td class=""right""><b>" & Prix(sMont) & "</b></td>" & _ 
                                    "</tr>"
                                    sTPoids = 0  : sMont = 0 : sPReel = 0 : sPFact = 0 : k = k+1                                           
                            End If

                            Periode = rs_Fo1("PERIODE") 
                            tabFo1 = tabFo1 & "<tr height=""25"" align=""center""><td colspan=""5""><b>" & rs_Fo1("PERIODE") & "</b></td></tr>"                             
                        End If	

						tabFo1 = tabFo1 & "<tr height=""25"" id=""" & Count & "_h0"">" & vbNewLine & _
									"	<td>" & rs_Fo1("CV") & "</td>" & vbNewLine &_
                                    "	<td>" & rs_Fo1("FO1") & "</td>" & vbNewLine &_
                                    "	<td class=""right"">" & Prix(rs_Fo1("POIDS_FO1")) & "</td>" & vbNewLine &_
                                    "	<td class=""right"">" & Prix(rs_Fo1("POIDS_R")) & "</td>" & vbNewLine &_  
                                    "	<td class=""right"">" & Prix(rs_Fo1("POIDSFACT")) & "</td>" & vbNewLine &_                                   
                                    "	<td class=""right"">" & rs_Fo1("TAUXSOUT") & "</td>" & vbNewLine &_                                    
                                    "	<td class=""right"">" & Prix(rs_Fo1("MONTSOUT")) & "</td>" & vbNewLine &_							
									"</tr>"

						Per2 = Per1 : i = i+1

                        sTPoids = sTPoids + round(rs_Fo1("POIDS_FO1"),0)
			            sPReel = sPReel + round(rs_Fo1("POIDS_R"),0)
                        sPFact = sPFact + round(rs_Fo1("POIDSFACT"),0)
                        sMont = sMont + Replace(rs_Fo1("MONTSOUT")," ","")
                        
                        TPoids = TPoids + round(rs_Fo1("POIDS_FO1"),0)
			            PReel = PReel + round(rs_Fo1("POIDS_R"),0)
                        PFact = PFact + round(rs_Fo1("POIDSFACT"),0)
                        Mont = Mont + Replace(rs_Fo1("MONTSOUT")," ","")                        
				
                		
				'############################
					End If 				' ###  => Fin de Sélection du Jeu de Résultats 
				'############################
							
				rs_Fo1.MoveNext
							
				Count = Count + 1
							
			Wend

			If Nb = 2 Then
                tabFo1 = tabFo1 & _
                        "<tr bgcolor=""#EEEEEE"" height=""25"">" & _
                            "<td colspan=""2""><b>S/TOTAL " & Periode & "</b> : </td>" & _
                            "<td class=""right""><b>" & Prix(sTPoids) & "</b></td>" & _ 
                            "<td class=""right""><b>" & Prix(sPReel) & "</b></td>" & _ 
                            "<td class=""right""><b>" & Prix(sPFact) & "</b></td>" & _ 
                            "<td> - </td>" & _ 
                            "<td class=""right""><b>" & Prix(sMont) & "</b></td>" & _ 
                        "</tr>"

                tabFo1 = tabFo1 & _
                    "<tr bgcolor=""#EEEEEE"" height=""25"">" & _
                        "<td colspan=""2""><b>TOTAL FACTURE</b> : </td>" & _
                        "<td class=""right""><b>" & Prix(TPoids) & "</b></td>" & _ 
                        "<td class=""right""><b>" & Prix(PReel) & "</b></td>" & _
                        "<td class=""right""><b>" & Prix(PFact) & "</b></td>" & _ 
                        "<td> - </td>" & _ 
                        "<td class=""right""><b>" & Prix(Mont) & "</b></td>" & _ 
                    "</tr>"
                        
            End If
			
			Set rs_Fo1 = rs_Fo1.NextRecordset
						
			Nb = Nb + 1
						
		Loop


		'### - Fermeture des Objets de Connexion					
					
					Set rs_Fo1  = Nothing
					Set Cmd_Db = Nothing
		
				
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
        <meta http-equiv="content-type" content="text/html; charset=iso-8859-1">
		<title>Le Conseil du Café-Cacao - Soit Transmis</title>
        <link type="text/css" href="../css/etat.css" rel="stylesheet">
        <link type="text/css" href="../css/jquery-ui-1.8.5.custom.css" rel="stylesheet">
		<style> 
	        @media print{   
	            .ecran 
	                {display: none;}
	        }
            .table th, .table td {
                font-size: 12px;
            }
            p{font-size: 12px;}
		</style>
	</head>   
<body class="page">
        <div id="container">
            <p class="text-right">
                <br /> <br /> <br /> Abidjan le <%=DtFact%><br /> <br /> <br /> <br /> <br /> <br /> <br /> <br /> <br /> <br /> <br /> <br /> <br /> <br /> </p> <br />
        <h2>FACTURE SOUTIEN </h2>
        <br />
	
		<table cellpadding="4" border="0" class="table">
			<%=tabFact%>			
		</table>
            <br /><br /><br />
        <table class="table table-bordered" id="xtable">
            <tr>
                <th><b>CV</b> </th>
                <th><b>Fo1</b></th>
                <th><b>Poids Fo1</b></th>
                <th><b>Poids Réel</b></th>
                <th><b>Poids Facturé</b></th>
                <th><b>Taux</b></th>
                <th><b>Montant </b></th>
            </tr>
			<%=tabFo1%>			
		</table>
        <br />
        
        <p>Arreté la présente facture à la somme de <b><%=NversL(Mont,"","")%> F CFA</b></p>
        <p class="text-right"><br /><br /><b><u>Cachet/Signature Exportateur</u></b></p>
	    <div style="text-align:center;">
	        <a href="javascript:onClick=window.print()"><font face="Americana BT" size="2" class="ecran" color="#ff0000">Imprimer</font></a>
        </div>

    </div>
    <script type="text/javascript" src="../js/jquery-1.4.2.min.js"></script> 
        <script type="text/javascript">	
            $(function () {
                groupTable($('#xtable tr:has(td)'), 0, 2);
                $('#xtable .deleted').remove();

                function groupTable($rows, startIndex, total) {
                    if (total === 0) {
                        return;
                    }
                    var i, currentIndex = startIndex, count = 1, lst = [];
                    var tds = $rows.find('td:eq(' + currentIndex + ')');
                    var ctrl = $(tds[0]);
                    lst.push($rows[0]);
                    for (i = 1; i <= tds.length; i++) {
                        if (ctrl.text() == $(tds[i]).text()) {
                            count++;
                            $(tds[i]).addClass('deleted');
                            lst.push($rows[i]);
                        }
                        else {
                            if (count > 1) {
                                ctrl.attr('rowspan', count);
                                groupTable($(lst), startIndex + 1, total - 1)
                            }
                            count = 1;
                            lst = [];
                            ctrl = $(tds[i]);
                            lst.push($rows[i]);
                        }
                    }
                }

            });
        </script>
</body>
</html>
