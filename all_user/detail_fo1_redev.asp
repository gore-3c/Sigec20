<%
	'### - Récupération des Valeurs de la Formule Sélectionnée
				Frm_Fo1 = Int(Sigec("Fo1"))

	'### - Création de la Commande à Exécuter
				Set Cmd_Db = Server.CreateObject("AdoDB.Command")
					Cmd_Db.ActiveConnection = ado_Con
					Cmd_Db.CommandText = "Ps_Exp_Detail_Fo1_FRC"	
					Cmd_Db.CommandType = adCmdStoredProc

	'### - Définition des Paramètres de la Procédure Stockée SQL
				Set Pm_Out = Cmd_Db.CreateParameter("@Output", adInteger, adParamOutput)	: Cmd_Db.Parameters.Append Pm_Out
				Set Pm_Fo1 = Cmd_Db.CreateParameter("@Fo1", adInteger, adParamInput, , Frm_Fo1)	: Cmd_Db.Parameters.Append Pm_Fo1

	'### - Exécution de la Commande SQL
				Set rs_Frm = Cmd_Db.Execute
				
				Dim Fi_Tx, Fi_Mt, Fi_Dt, Fi_Ch, Fi_Bk, Poids_Fo1, Print, Lot_Bv								
				Dim Redevances
                	Redevances = ""
				While Not rs_Frm.Eof 															
					
					Frm_Produit = rs_Frm("Produit")  : Frm_Prdt    = rs_Frm("Prdt")	   	 : Frm_Kfe_Kko = rs_Frm("Kfe_Kko") : Frm_Grade     = rs_Frm("Lib_Grade")
					Frm_Region  = rs_Frm("Lib_Reg")  : Frm_Periode = rs_Frm("Periode") 	 : Frm_Recolte = rs_Frm("Recolte") : Frm_Parite    = rs_Frm("Parite")		   
					Frm_Enr	    = rs_Frm("Enr_Id")   : Frm_Camp    = rs_Frm("Campagne")	 : Frm_Qlte    = rs_Frm("Qlte")	   : Frm_Emb	   = rs_Frm("Emb_Port")
				 	Frm_Caf	    = rs_Frm("Prix_caf") : Frm_Tonnage = rs_Frm("Poids_Fo1") 	 : Frm_Contrat = rs_Frm("Contrat") : Frm_Transit   = rs_Frm("Transit")
					Frm_Pays    = rs_Frm("Pays")	 : Frm_Deb     = rs_Frm("Port")    	 : Frm_Nb_Emb  = rs_Frm("Emb_Nb")  : Frm_Emballage = rs_Frm("Emballage")
					
					Frm_Kko		= rs_Frm("KKO")	 : Frm_Frc     = rs_Frm("Num_Frc")	 : Frm_Lot  = rs_Frm("Nb_Lot")		': Lot_Bv = rs_Frm("Lot_Bv")				  
					Frm_Nb_Fo1	= rs_Frm("Fo1")	 : Frm_Lance   = rs_Frm("Net__Fo1")	 : Frm_Solde	= rs_Frm("Solde")	 : Frm_Net_Cdc   = rs_Frm("Net")
					
					Frm_Fo1		= rs_Frm("Fo1_Bcc") 	: Poids_Fo1 = rs_Frm("Poids_Fo1")
					Frm_Dte		= FormatDateTime(rs_Frm("FO1_DATE"),2)

					Frm_Cdc		= rs_Frm("Cdc_Exp") '& "/" & Frm_Prdt & "-" & Frm_Kfe_Kko
					Frm_Nom	 	= rs_Frm("Exportateur")											

					'Print = rs_Frm("Modele")
								
					Redim Lots(Int(rs_Frm("NB_LOT")), 1)											
										
					Frm_Url_Enr = "?Enr=" & rs_Frm("Enr_Id")
					Frm_Url_Enr = "?sigec=" & Server.UrlEncode(Encrypt(Frm_Url_Enr))
					Frm_Url_Enr = "Afficher('Avis_Enr', '../all_print/affiche_enr.asp" & Frm_Url_Enr & "', 100, 100, 600, 400, 0, 0, 0, 1, 1);"
					
					Frm_Url_Cdc = "?Cdc=" & rs_Frm("Cdc_Id")
					Frm_Url_Cdc = "?sigec=" & Server.UrlEncode(Encrypt(Frm_Url_Cdc))
					Frm_Url_Cdc = "Afficher('Voir_cdc', '../all_print/affiche_cdc.asp" & Frm_Url_Cdc & "', 100, 100, 500, 500, 0, 0, 0, 1, 1);"
						
					Frm_Url_Fo1 = "?Fo1=" & rs_Frm("Fo1_Id")
					Frm_Url_Fo1 = "?sigec=" & Server.UrlEncode(Encrypt(Frm_Url_Fo1))
					Frm_Url_Fo1 = "Afficher('Voir_fo1', '../all_print/affiche_fo1.asp" & Frm_Url_Fo1 & "', 100, 100, 700, 500, 0, 0, 0, 1, 1);"
						
					Frm_Url_Niv = "?Cdc=" & rs_Frm("Cdc_Id")
					Frm_Url_Niv = "?sigec=" & Server.UrlEncode(Encrypt(Frm_Url_Niv))
					Frm_Url_Niv = "Afficher('Niveau', '../all_print/affiche_niveau_cdc.asp" & Frm_Url_Niv & "', 100, 100, 700, 500, 0, 0, 0, 1, 1);"
						
					Redevances = Redevances & "<tr>" & vbNewLine &_
                                              "  <td><b>" & rs_Frm("LIB_AFF") & "</b></td>" & vbNewLine &_
                                              "  <td align='center'><span class=""val"">" & rs_Frm("TAUX") & "</span></td>" & vbNewLine &_
                                              "  <td align='center'>" & rs_Frm("CH_DATE") & "</td>" & vbNewLine &_
                                              "  <td align='right'><span class=""val"">" & Prix(rs_Frm("CH_MTT")) & "</span></td>" & vbNewLine &_
                                              "  <td align='center'>" & rs_Frm("BANK") & "</td>" & vbNewLine &_
                                              "  <td align='center'><span class=""val"">" & rs_Frm("CH_REF") & "</span></td>" & vbNewLine &_
                                              "</tr>"                    
					rs_Frm.MoveNext
                    
                Wend

				'### - Fermeture des Objets de Connexion
					rs_Frm.Close
					
					Set rs_Frm  = Nothing
					Set Cmd_Db = Nothing

%>
<table width="495" border="1" cellpadding="1" cellspacing="2" bordercolor="#859AA6" summary="" rules="rows" frame="hsides" align="center">
	    <tr>
	        <td width="91" height="25" align="left" valign="middle"><b><font size="1" face="Verdana">&nbsp;Exportateur</font></b></td>
	        <td width="8" height="25" align="center" valign="middle"><b><font size="1" face="Verdana">:</font></b></td>
	        <td width="374" height="25" align="center" valign="middle" colspan="4"><b><font size="2" face="Verdana"><%=Frm_Nom%></font></b></td>
	    </tr>
	    <tr>
	        <td width="91" height="25" align="left" valign="middle"><b><font size="1" face="Verdana">&nbsp;Ref. Formule</font></b></td>
	        <td width="8" height="25" align="center" valign="middle"><b><font size="1" face="Verdana">:</font></b></td>
	        <td width="374" height="25" align="center" valign="middle" colspan="4">
				<font size="1" face="Verdana">&nbsp;&nbsp;</font><font size="2" face="Verdana"><b><%=Frm_Fo1%></b></font>
	        </td>
	    </tr>
	    <tr>
	        <td width="91" height="25" align="left" valign="middle"><b><font size="1" face="Verdana">&nbsp;Date Fo1</font></b></td>
	        <td width="8" height="25" align="center" valign="middle"><b><font size="1" face="Verdana">:</font></b></td>
	        <td width="132" height="25" align="left" valign="middle"><font size="1" face="Verdana">&nbsp;&nbsp;<%=Frm_Dte%></font></td>
	        <td width="63" height="25" align="left" valign="middle"><b><font size="1" face="Verdana">&nbsp;&nbsp;Produit</font></b></td>
	        <td width="4" height="25" align="center" valign="middle"><b><font size="1" face="Verdana">:</font></b></td>
	        <td width="157" height="25" align="left" valign="middle"><font size="1" face="Verdana">&nbsp;&nbsp;<%=Frm_Produit%></font></td>
	    </tr>
	    <tr>
	        <td width="91" height="25" align="left" valign="middle"><b><font size="1" face="Verdana">&nbsp;N° Cdc</font></b></td>
	        <td width="8" height="25" align="center" valign="middle"><b><font size="1" face="Verdana">:</font></b></td>
	        <td width="132" height="25" align="left" valign="middle">
				<font size="1" face="Verdana">&nbsp;&nbsp;</font><a href="javascript:<%=Frm_Url_Niv%>"><font size="1" face="Verdana"><%=Frm_Cdc%></font></a>
			</td>
	        <td width="63" height="25" align="left" valign="middle"><b><font size="1" face="Verdana">&nbsp;&nbsp;Grade</font></b></td>
	        <td width="4" height="25" align="center" valign="middle"><b><font size="1" face="Verdana">:</font></b></td>
	        <td width="157" height="25" align="left" valign="middle"><font size="1" face="Verdana">&nbsp;&nbsp;<%=Frm_Grade%><%If Len(Frm_Kko) > 0 Then%><br>&nbsp;&nbsp;<%=Frm_Kko%><%End If%></font></td>
	    </tr>
	    <tr>
	        <td width="91" height="25" align="left" valign="middle"><b><font size="1" face="Verdana">&nbsp;N° Enreg.</font></b></td>
	        <td width="8" height="25" align="center" valign="middle"><b><font size="1" face="Verdana">:</font></b></td>
	        <td width="132" height="25" align="left" valign="middle">
				<font size="1" face="Verdana">&nbsp;&nbsp;</font><a href="javascript:<%=Frm_Url_Enr%>"><font size="1" face="Verdana"><%=Frm_Enr%></font></a>
			</td>
	        <td width="63" height="25" align="left" valign="middle"><b><font size="1" face="Verdana">&nbsp;&nbsp;Qualité</font></b></td>
	        <td width="4" height="25" align="center" valign="middle"><b><font size="1" face="Verdana">:</font></b></td>
	        <td width="157" height="25" align="left" valign="middle"><font size="1" face="Verdana">&nbsp;&nbsp;<%=Frm_Qlte%></font></td>
	    </tr>
	    <tr>
	        <td width="91" height="25" align="left" valign="middle"><b><font size="1" face="Verdana">&nbsp;&nbsp;Récolte</font></b></td>
	        <td width="8" height="25" align="center" valign="middle"><b><font size="1" face="Verdana">:</font></b></td>
	        <td width="132" height="25" align="left" valign="middle"><font size="1" face="Verdana">&nbsp;&nbsp;<%=Frm_Recolte & " / " & Frm_Parite%></font></td>
	        <td width="63" height="25" align="left" valign="middle"><b><font size="1" face="Verdana">&nbsp;&nbsp;</font></b></td>
	        <td width="4" height="25" align="center" valign="middle"><b><font size="1" face="Verdana"></font></b></td>
	        <td width="157" height="25" align="left" valign="middle"><font size="1" face="Verdana">&nbsp;</font></td>
	    </tr>
	    <tr>
	        <td width="91" height="25" align="left" valign="middle"><b><font size="1" face="Verdana">&nbsp;Région</font></b></td>
	        <td width="8" height="25" align="center" valign="middle"><b><font size="1" face="Verdana">:</font></b></td>
	        <td width="132" height="25" align="left" valign="middle"><font size="1" face="Verdana">&nbsp;&nbsp;<%=Frm_Region%></font></td>
	        <td width="236" height="53" align="center" valign="middle" colspan="3" rowspan="3">
			<font size="1" face="Verdana"><b>Tonnage Fo1&nbsp;&nbsp; : &nbsp;&nbsp;</b><%=Prix(Frm_Tonnage)%> Kg</font>
	        </td>
	    </tr>
	    <tr>
	        <td width="91" height="25" align="left" valign="middle"><b><font size="1" face="Verdana">&nbsp;Période</font></b></td>
	        <td width="8" height="25" align="center" valign="middle"><b><font size="1" face="Verdana">:</font></b></td>
	        <td width="132" height="25" align="left" valign="middle"><font size="1" face="Verdana">&nbsp;&nbsp;<%=Frm_Periode%></font></td>
	    </tr>
	    <tr>
	        <td width="91" height="25" align="left" valign="middle"><b><font size="1" face="Verdana">&nbsp;Prix Caf</font></b></td>
	        <td width="8" height="25" align="center" valign="middle"><b><font size="1" face="Verdana">:</font></b></td>
	        <td width="132" height="25" align="left" valign="middle"><font size="1" face="Verdana">&nbsp; <%=Prix(Frm_Caf)%> Francs</font></td>
	    </tr>
	    <tr>
	        <td width="91" height="25" align="left" valign="middle"><b><font size="1" face="Verdana">&nbsp;Embarquement</font></b></td>
	        <td width="8" height="25" align="center" valign="middle"><b><font size="1" face="Verdana">:</font></b></td>
	        <td width="132" height="25" align="left" valign="middle"><font size="1" face="Verdana">&nbsp;&nbsp;<%=Frm_Emb%> </font></td>
	        <td width="63" height="25" align="left" valign="middle"><b><font size="1" face="Verdana">&nbsp;&nbsp;Contrat</font></b></td>
	        <td width="4" height="25" align="center" valign="middle"><b><font size="1" face="Verdana">:</font></b></td>
	        <td width="157" height="25" align="left" valign="middle"><font size="1" face="Verdana">&nbsp;&nbsp;<%=Frm_Contrat%> </font></td>
	    </tr>
	    <tr>
	        <td width="91" height="25" align="left" valign="middle"><b><font size="1" face="Verdana">&nbsp;Destination</font></b></td>
	        <td width="8" height="25" align="center" valign="middle"><b><font size="1" face="Verdana">:</font></b></td>
	        <td width="132" height="25" align="left" valign="middle"><font size="1" face="Verdana">&nbsp;&nbsp;<%=Frm_Pays%></font></td>
	        <td width="63" height="25" align="left" valign="middle"><b><font size="1" face="Verdana">&nbsp;&nbsp;Port</font></b></td>
	        <td width="4" height="25" align="center" valign="middle"><b><font size="1" face="Verdana">:</font></b></td>
	        <td width="157" height="25" align="left" valign="middle"><font size="1" face="Verdana">&nbsp;&nbsp;<%=Frm_Deb%></font></td>
	    </tr>
	    <tr>
	        <td width="91" height="25" align="left" valign="middle"><b><font size="1" face="Verdana">&nbsp;Transitaire</font></b></td>
	        <td width="8" height="25" align="center" valign="middle"><b><font size="1" face="Verdana">:</font></b></td>
	        <td width="374" height="25" align="left" valign="middle" colspan="4"><font size="1" face="Verdana">&nbsp;&nbsp;<%=Frm_Transit%></font></td>
	    </tr>
	    <tr>
	        <td width="91" height="25" align="left" valign="middle"><b><font size="1" face="Verdana">&nbsp;Nombre de Lot</font></b></td>
	        <td width="8" height="25" align="center" valign="middle"><b><font size="1" face="Verdana">:</font></b></td>
	        <td width="374" height="25" align="left" valign="middle" colspan="4"><font size="1" face="Verdana">&nbsp;&nbsp;<a href="javascript:<%=bvUrl%>"><%=Prix(Frm_Lot)%></a></font></td>
	    </tr>
	    <tr>
	        <td width="91" height="25" align="left" valign="middle"><b><font size="1" face="Verdana">&nbsp;Emballage</font></b></td>
	        <td width="8" height="25" align="center" valign="middle"><b><font size="1" face="Verdana">:</font></b></td>
	        <td width="132" height="25" align="left" valign="middle"><font size="1" face="Verdana">&nbsp; <%=Frm_Emballage%></font></td>
	        <td width="63" height="25" align="left" valign="middle"><b><font size="1" face="Verdana">&nbsp;&nbsp;Nombre</font></b></td>
	        <td width="4" height="25" align="center" valign="middle"><b><font size="1" face="Verdana">:</font></b></td>
	        <td width="157" height="25" align="left" valign="middle"><font size="1" face="Verdana">&nbsp; <%=Prix(Frm_Nb_Emb)%></font></td>
	    </tr>
	    <tr>
	        <td width="91" height="25" align="left" valign="middle"><b><font size="1" face="Verdana">&nbsp;Net Cdc</font></b></td>
	        <td width="8" height="25" align="center" valign="middle"><b><font size="1" face="Verdana">:</font></b></td>
	        <td width="132" height="25" align="left" valign="middle"><font size="1" face="Verdana">&nbsp; <%=Prix(Frm_Net_Cdc)%> Kg</font></td>
	        <td width="63" height="25" align="left" valign="middle"><b><font size="1" face="Verdana">&nbsp;&nbsp;Fo1 Lancé</font></b></td>
	        <td width="4" height="25" align="center" valign="middle"><b><font size="1" face="Verdana">:</font></b></td>
	        <td width="157" height="25" align="left" valign="middle"><font size="1" face="Verdana">&nbsp; <%=Prix(Frm_Lance)%> Kg</font></td>
	    </tr>
	    <tr>
	        <td width="91" height="25" align="left" valign="middle"><b><font size="1" face="Verdana">&nbsp;Nb Fo1</font></b></td>
	        <td width="8" height="25" align="center" valign="middle"><b><font size="1" face="Verdana">:</font></b></td>
	        <td width="132" height="25" align="left" valign="middle"><font size="1" face="Verdana">&nbsp; <%=Prix(Frm_Nb_Fo1)%></font></td>
	        <td width="63" height="25" align="left" valign="middle"><b><font size="1" face="Verdana">&nbsp;&nbsp;Solde Cdc</font></b></td>
	        <td width="4" height="25" align="center" valign="middle"><b><font size="1" face="Verdana">:</font></b></td>
	        <td width="157" height="25" align="left" valign="middle"><font size="1" face="Verdana">&nbsp; <%=Prix(Frm_Solde)%> Kg</font></td>
	    </tr>
</table>

<h1>REDEVANCES - TAXES - REVERSEMENT</h1>

<table width="90%" border="1" cellpadding="2" cellspacing="2" bordercolor="#859AA6" summary="" rules="rows" frame="hsides" align="center">
  <tr>
    <th scope="col"><b>TAXE</th>
    <th scope="col">TAUX</th>
    <th scope="col">DATE</th>
    <th scope="col">MONTANT</th>
    <th scope="col">BANQUE</th>
    <th scope="col">N° CHEQUE</th>
  </tr>
  <%=Redevances%>                          
</table>

	

<!-- <font size="1" face="Verdana">&nbsp;&nbsp;<a href="javascript:<%'=Frm_Url_Niv%>"><font size="1" face="Verdana"><%'=Prix(Frm_Solde)%> Kg</font></a></font> -->

	
	