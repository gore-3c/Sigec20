	<!--#include file="../include/inc_con.asp" -->
	<!--#include file="../include/fonction.asp" -->
	<!--#include file="../include/encryption.asp" -->
	<!--include file="../include/inc_var.asp" -->
	
<%		
	If Session("Login") = False or IsNull(Session("Login")) = True Then Response.Redirect "../expire.asp" End If		

	'### - Récupération des Variables Session Utilisateur
				Dim Code, Fact, Fo1, Nb, Count 
				Dim Cmd_Db, Pm_Out, Pm_Code, Pm_Option, rs_Fo1, Pm_Id, j
				
				
					Code  = Session("Code")
					Fact	= 8 'Sigec("Fo1")				
					
	'### - Déclaration des Variables pour Afficher la Formule

				Dim Img
                Dim Tonnage, Emeteur, Recepteur, Objet, Ref, tr, Signataire, Campagne
				Dim Exportateur, Dt, Produit
                Dim Mt, PFo1, PReel, PFact, Fact1, Fact2
				Dim Print


	'### - Création de la Commande à Exécuter
				Set Cmd_Db = Server.CreateObject("AdoDB.Command")
					Cmd_Db.ActiveConnection = ado_Con
					Cmd_Db.CommandText = "Ps_Doc_STransmisFactSoutien"
					Cmd_Db.CommandType = adCmdStoredProc

	'### - Définition des Paramètres de la Procédure Stockée SQL
					Set Pm_Out		= Cmd_Db.CreateParameter("@Output", adInteger, adParamOutput)				: Cmd_Db.Parameters.Append Pm_Out
					Set Pm_Code		= Cmd_Db.CreateParameter("@Code", adVarChar, adParamInput, 3, Code)			: Cmd_Db.Parameters.Append Pm_Code
					Set Pm_Option	= Cmd_Db.CreateParameter("@Option", adVarChar, adParamInput, 15, "EditAccord")	: Cmd_Db.Parameters.Append Pm_Option
                    Set Pm_Id		= Cmd_Db.CreateParameter("@Id", adVarChar, adParamInput, 800, Fact) 	: Cmd_Db.Parameters.Append Pm_Id
	
	'### - Exécution de la Commande SQL
				Set rs_Fo1 = Cmd_Db.Execute
			
	'### - Affichage des Résultats de la Procédure SQL
				
				Mt = 0 : PFo1 = 0 : PReel = 0 : PFact = 0 : Fact1 = "" : Fact2 = "" : J = 0
				Dim s, TypeTonage, Nombre(10,2), V1, V2, V3, sMt 
                    s = "" : TypeTonage = "FORMULE"

                    Nombre(0,0)  = "01" : Nombre(0,1)  = "un"
                    Nombre(1,0)  = "02" : Nombre(1,1)  = "deux"
                    Nombre(2,0)  = "03" : Nombre(2,1)  = "trois"
                    Nombre(3,0)  = "04" : Nombre(3,1)  = "quatre"
                    Nombre(4,0)  = "05" : Nombre(4,1)  = "cinq"
                    Nombre(5,0)  = "06" : Nombre(5,1)  = "six"
                    Nombre(6,0)  = "07" : Nombre(6,1)  = "sept"
                    Nombre(7,0)  = "08" : Nombre(7,1)  = "huit"
                    Nombre(8,0)  = "09" : Nombre(8,1)  = "neuf"
                    Nombre(9,0)  = "10" : Nombre(9,1)  = "dix"
                    

				While Not rs_Fo1.Eof
                    'Compte le nbre de factures
                    Fact1 = rs_Fo1("REF_FACTSOUT")
                    If Fact1 <> Fact2 Then 
                        J = J + 1
                    End If

                    If Fact1 <> Fact2 And J > 1 Then 
                        tr = tr & "<tr>" & _
                                  "  <th colspan=""3"">SOUS TOTAUX " & Fact2 & "</th>" & _
                                  "  <th class=""text-right"">" & Prix(V1) & "</th>" & _
                                  "  <th class=""text-right"">" & Prix(V2) & "</th>" & _
                                  "  <th class=""text-right"">" & Prix(V3) & "</th>" & _
                                  "  <th></th>" & _
                                  "  <th class=""text-right"">" & Prix(sMt) & "</th>" &_ 
                                "</tr>"
                                                        
                        V1 = 0 : V2 = 0 : V3 = 0 : sMt = 0
                    End If

                    'Définit un libelle de colonne en fonction de Trans_id
                    If rs_Fo1("ID_TRANS") = 2 THEN TypeTonage = "CERTIFIE"

					Emeteur = rs_Fo1("EMETTEUR")
                    Recepteur = rs_Fo1("RECEPTEUR")
                    Ref = rs_Fo1("REF_ST") 
                    Campagne = rs_Fo1("CAMPAGNE")
                    Signataire = rs_Fo1("SIGNATAIRE")
                    Exportateur = rs_Fo1("NOM")
                    Dt = rs_Fo1("DATE_RECU") 
                    Produit = rs_Fo1("PRODUIT")               


                    tr = tr & "<tr>" &_
                                    "<td class=""text-center"">" & rs_Fo1("NUM_FACTSOUT") & "/<br/>" & rs_Fo1("REF_FACTSOUT") & "</td>" & _
                                    "<td class=""text-center"">" & rs_Fo1("CDC_CGFCC") & "</td>" & _
                                    "<td class=""text-center"">" & rs_Fo1("NUM_FRC") & "</td>" & _
                                    "<td class=""text-right"">" & Prix(rs_Fo1("POIDS_FO1")) & "</td>" & _
                                    "<td class=""text-right"">" & Prix(rs_Fo1("POIDSREEL")) & "</td>" & _
                                    "<td class=""text-right"">" & Prix(rs_Fo1("POIDSFACT")) & "</td>" & _
                                    "<td class=""text-right"">" & Round(rs_Fo1("TAUXSOUT"),3) & "</td>" & _
                                    "<td class=""text-right"">" & Prix(rs_Fo1("MONTSOUT")) & "</td>" & _
                              "</tr>"

					Mt = Mt + round(rs_Fo1("MONTSOUT"),0)
                    PFo1 = PFo1 + round(rs_Fo1("POIDS_FO1"),0)
                    Preel = Preel + round(rs_Fo1("POIDSREEL"),0)
                    PFact = PFact + round(rs_Fo1("POIDSFACT"),0)	

                    sMt = sMt + round(rs_Fo1("MONTSOUT"),0)
                    V1 = V1 + round(rs_Fo1("POIDS_FO1"),0)
                    V2 = V2 + round(rs_Fo1("POIDSREEL"),0)
                    V3 = V3 + round(rs_Fo1("POIDSFACT"),0)

                    Fact2 = Fact1

					rs_Fo1.MoveNext
						
				Wend					

	'### - Fermeture des Objets de Connexion
				'rs_Fo1.Close
				
				Set rs_Fo1 = Nothing
				Set Cmd_Db = Nothing

                If J > 1 Then 
                        tr = tr & "<tr>" & _
                                  "  <th colspan=""3"">SOUS TOTAUX " & Fact2 & "</th>" & _
                                  "  <th class=""text-right"">" & Prix(V1) & "</th>" & _
                                  "  <th class=""text-right"">" & Prix(V2) & "</th>" & _
                                  "  <th class=""text-right"">" & Prix(V3) & "</th>" & _
                                  "  <th></th>" & _
                                  "  <th class=""text-right"">" & Prix(sMt) & "</th>" &_ 
                                "</tr>"
                                                        
                        V1 = 0 : V2 = 0 : V3 = 0 : sMt = 0
                End If

                If J > 1 Then 
                    s = "s"                    
                End If
                J = J - 1
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
        <meta charset="UTF-8">
        <title>Le Conseil du Café-Cacao - Soit Transmis</title>
        <link href="../assets/css/dashboard.css" rel="stylesheet" />
		<!-- Font family -->
		<link href="https://fonts.googleapis.com/css?family=Comfortaa:300,400,700" rel="stylesheet">
		<style> 
	        @media print{   
	            .ecran 
	                {display: none;}
	        }
            #xtable{
                font-size: 0.9em;
            }
		</style>
	</head>
	
	<body class="page">
        <div class="page">
			<div class="page-main">
                <!--content-area-->
				<div class="content-area">
					<div class="container">
                        <div class="row">
							<div class="col-md-12">
								<div class="card-box card shadow">
									<div class="card-body">
                                        <img src="../assets/images/logo.jpg" alt="logo" /> 

                                        <h3 class="text-left">LE DIRECTEUR DE LA COMMERCIALISATION EXTERIEURE</3>
                                        <p class="text-right">Abidjan, le .......................................</p>

                                        <h3>N/REF: <%=Ref%></h3>
                                        
                                        <h1 class="text-center"> SOIT - TRANSMIS</h1>	
                                        <hr>
                                        <div class="float-left">
                                            <address>
                                                <strong>De </strong> : <%=Emeteur%><br>
                                                <strong>A </strong> : <%=Recepteur%><br>
                                                <strong>Objet </strong> : Facture de soutien <%=Produit%> campagne <%=campagne%>
                                            </address>
                                        </div>
                                        <!--
                                        <table class="xtable">
                                            <tr>
                                                <td><b>De</b></td> <td>: <%=Emeteur%></td>
                                            </tr>
                                            <tr>
                                                <td><b>A</b></td> <td>: <%=Recepteur%></td>
                                            </tr>
                                            <tr>
                                                <td><b>Objet</b></td> <td>: Facture de soutien <%=Produit%> campagne <%=campagne%></td>
                                            </tr>            
                                        </table>-->
                                        <hr>
                                        <div class="float-left">
                                            <p>Veuillez trouver ci-joint <%=Nombre(J,1)%> (<%=Nombre(J,0)%>) facture<%=s%> de soutien <%=Produit%> de la société <b><%=Exportateur%></b> reçue<%=s%> le <%=Dt%> <br /><br /></p>
                                        </div>
                                        

                                        <table class="table table-bordered" id="xtable">
                                            <tr>
                                                <th>N° FACTURE</th>
                                                <th>N° CV</th>
                                                <th>N° FO1</th>
                                                <th>POIDS FO1</th>
                                                <th>POIDS REEL</th>
                                                <th>POIDS FACTURE</th>
                                                <th>TAUX</th>
                                                <th>MONTANT</th>
                                            </tr>
                                            <%=tr%>
                                            <tr>
                                                <th colspan="3">TOTAUX</th>
                                                <th><%=Prix(PFo1)%></th>
                                                <th><%=Prix(PReel)%></th>
                                                <th><%=Prix(PFact)%></th>
                                                <th></th>
                                                <th><%=Prix(Mt)%></th>
                                            </tr>
                                        </table>

                                        <p class="text-right"><br><br><br><br><br><br><br><br><br><%=Signataire%></p>

                                        <div style="text-align:center;">
                                            <a href="javascript:onClick=window.print()"><font face="Americana BT" size="2" class="ecran" color="#ff0000">Imprimer</font></a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                    </div>
                </div>
            </div>
        </div>
    
        <!-- Jquery js-->
		<script src="../assets/js/vendors/jquery-3.2.1.min.js"></script>
		<!--Bootstrap js-->
        <script src="../assets/js/vendors/bootstrap.bundle.min.js"></script>
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
</body></html>


