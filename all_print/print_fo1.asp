	<!--#include file="../include/inc_con.asp" -->
	<!--#include file="../include/fonction.asp" -->
	<!--#include file="../include/encryptions.asp" -->

	
<%		
	If Session("Login") = False or IsNull(Session("Login")) = True Then Response.Redirect "../expire.asp" End If	
    'If Not Acces_Page   = True Then Response.Redirect "../refuse.asp" & "?sigec=" & Server.UrlEncode(encrypt("?Motif=Menu_Refuse")) End If	

	'### - Récupération des Variables Session Utilisateur
				Dim Code, Trans, Fo1_Id, Fo1, Nb, Count, F_Prov, TypeCV 
				Dim Cmd_Db, Pm_Out, Pm_Code, rs_Fo1, Pm_Fo1, Lot, j, iCoef
				Dim Tonnage, TauxU, TauxC, MtR, MtRC, MtS, MtSC, Compense, MtRD, MtSD 
				
					Fo1	= Int(Decode(request.querystring(encode("Fo1")))) 'Sigec("Fo1")
					F_Prov = Decode(request.querystring(encode("F_Prov"))) 'Sigec("F_Prov")
					
	'### - Déclaration des Variables pour Afficher la Formule

				Dim Img
				Dim Enr, Date_Enr, Poids_Enr, Cdc, Date_Cdc, Net_Cdc, Caf, Kfe_Kko, Cdc_Exp, Nom, Enr_Per, Enr_Prix, Prix_Cv
				Dim Prdt, Produit, Region, Grade, Type_Grd, Prdt_Grd, G_Kko, Qlte, Qualite, Periode, Campagne, Recolte, Parite
				Dim Date_Fo1, Net_Fo1, Brut_Fo1, Fo1_Exp, Fo1_Bcc, Frc, Coef, Net, Net_Fini, Poids_Fo1
				Dim Transit,  Transitaire, Contrat, Pays, Debarq, Via, Embarq, Destinataire, Nomenc, Navire, Fob, Emballage, Sac				

				Dim LesTaxes, Enr_Mt, LesRedevances, Enr_Tx, Reverst, Taux, Decote_prix, Tx_Decote
				Dim Print
				Dim aLot, Queue
				
				Dim Execution, Ar
				
				Dim aa, bb, Marque, Numero

				Dim Lots, LibPrepaye
                Dim ChMtt 
	'### - Création de la Commande à Exécuter
				Set Cmd_Db = Server.CreateObject("AdoDB.Command")
					Cmd_Db.ActiveConnection = ado_Con
					Cmd_Db.CommandText = "Ps_User_Print_Fo1"
					Cmd_Db.CommandType = adCmdStoredProc

	'### - Définition des Paramètres de la Procédure Stockée SQL
				Set Pm_Out = Cmd_Db.CreateParameter("@Output", adInteger, adParamOutput)	     : Cmd_Db.Parameters.Append Pm_Out
				Set Pm_Fo1 = Cmd_Db.CreateParameter("@Fo1", adInteger, adParamInput, , Int(Fo1)) : Cmd_Db.Parameters.Append Pm_Fo1
	
	'### - Exécution de la Commande SQL
				Set rs_Fo1 = Cmd_Db.Execute
			
	'### - Affichage des Résultats de la Procédure SQL
				img = "<img src=""../images/warning.gif"" align=absmiddle border=0 width=33 height=34 alt=""Alerte !"">" 
				
				Tonnage = 0 : TauxU = 0 : TauxC = 0 : MtR = 0 : MtRC = 0	:  MtS = 0 : MtSC = 0 	: MtRD = 0 : MtSD = 0	
				Nb = 1 : Count = 0 : bb = 0 : j = 0 : Reverst = ""	: TypeCV = ""
				Marque = "" : Numero = "" : Lot = "" : aa = "" : LesRedevances = "" : LesTaxes = "" : Enr_Tx = 0 : Enr_Mt = 0
				Decote_prix = 0
				LibPrepaye =""
                ChMtt=0

				Do Until rs_Fo1 Is Nothing
				
					While Not rs_Fo1.Eof
					
						'############################
							If Nb = 1 Then		' ###  => Jeu de Résultats N° 1 - Informations de la Formule
						'############################

								Code  = rs_Fo1("Id_Exp")
								Trans = rs_Fo1("Id_Trans")
						
								Enr = rs_Fo1("Enr_Id")   : Date_Enr = rs_Fo1("Enr_Date") : Poids_Enr = rs_Fo1("Tonnage")
								Cdc = rs_Fo1("Cdc_Exp")  : Date_Cdc = rs_Fo1("Date_Cdc") : Net_Cdc = rs_Fo1("Poids")
								Caf = rs_Fo1("CAF_REF") : Kfe_Kko = rs_Fo1("Kfe_Kko")	 : Nom = rs_Fo1("Exportateur")
								Enr_Prix = rs_Fo1("Prix") : Prix_Cv = rs_Fo1("Prix_Cv")	 : Transit = rs_Fo1("Transit")	 
								
								Prdt = rs_Fo1("Prdt")    : Produit = rs_Fo1("Produit")   : Region = rs_Fo1("Region") 
								Grade = rs_Fo1("Grade")  : Type_Grd = rs_Fo1("Type_Grd") : Prdt_Grd = rs_Fo1("Lib_Grd")
								G_Kko = rs_Fo1("Kko")    : Qualite = rs_Fo1("Qlte")      : Coef = rs_Fo1("Coef_Qlte") 
								Parite = rs_Fo1("Parite"): Periode = rs_Fo1("Periode")   : Recolte = rs_Fo1("Recolte") 
								Fo1 = rs_Fo1("Fo1_Id")   : Date_Fo1 = rs_Fo1("Fo1_Date") : Campagne = rs_Fo1("Campagne") 
								
								Net_Fini = rs_Fo1("Net_Fini")    : Brut_Fo1 = rs_Fo1("Brut_Fo1") : Net_Fo1 = rs_Fo1("Net_Fo1")  
								Fo1_Exp = rs_Fo1("Fo1_Exp")      : Fo1_Bcc = rs_Fo1("Fo1_Base")	 : Frc = rs_Fo1("Num_Frc") 
								Transitaire = rs_Fo1("Transitaire")      : Contrat = rs_Fo1("Contrat")   : Pays = rs_Fo1("Pays")      
								Embarq = rs_Fo1("Emb_Port")      : Debarq = rs_Fo1("Port")       : Nomenc = rs_Fo1("Nomenc") 
								Navire = rs_Fo1("Navire")        : Fob = rs_Fo1("Fob")           : Via = rs_Fo1("Via") 	    
								Emballage = rs_Fo1("Emballage")  : Sac = rs_Fo1("Emb_Nb")	 	 : Enr_Per = rs_Fo1("Enr_Per")
								Poids_Fo1 = rs_Fo1("Poids_Fo1")  : Destinataire = rs_Fo1("Destinataire") : aLot = rs_Fo1("Sac_Lot")								
								
								Tx_Decote = rs_Fo1("Tx_Decote")
								Decote_prix = rs_Fo1("PRIX_DECOTE")
								
								Compense = rs_Fo1("CPens_ID")
								Tonnage = Poids_Fo1	
								LibPrepaye = rs_Fo1("PREPAYE")
                                'ChMtt = rs_Fo1("CH_MTT")

								'If Trans = 2 Then Tonnage = Net_Fini End If
																							
								TauxU = rs_Fo1("Tx")	:	TauxC = rs_Fo1("TxC") 
								Taux = TauxU	
                                If CDbl(TauxC) > 0 Then Taux = TauxC End If
								If CDbl(Tx_Decote) <> 0 Then Taux = Tx_Decote End If
								If CDbl(TauxU) > 0 Then
                                    'If ChMtt > 0 Then 
                                    '    MtR = Prix(Abs(ChMtt))
                                    'Else
									MtR = Abs(TauxU*Tonnage) 
                                    'End If
								Else
									MtS = Abs(TauxU*Tonnage)
								End If
								
								If CDbl(Tx_Decote) <> 0 Then TauxC = Tx_Decote	End If 	'La Décote existe
								If CDbl(TauxC) > 0 Then
									MtRC = Abs(TauxC*Tonnage)
								Else
									MtSC = Abs(TauxC*Tonnage)
								End If
															
								If Int(rs_Fo1("ID_EXP_LOCAL")) <> 0 Then 
									TypeCV = "international"
								Else
									TypeCV = ""	
								End If								
								
								' -- ### Arondir manuellement les nombres - 04/06/2020
								If (MtR - Fix(MtR)) >= 0.5 Then 
									MtR = Fix(MtR) + 1
								Else
									MtR = Fix(MtR) 
								End If

								If (MtS - Fix(MtS)) >= 0.5 Then 
									MtS = Fix(MtS) + 1
								Else
									MtS = Fix(MtS) 
								End If

								If (MtRC - Fix(MtRC)) >= 0.5 Then 
									MtRC = Fix(MtRC) + 1
								Else
									MtRC = Fix(MtRC) 
								End If

								If (MtSC - Fix(MtSC)) >= 0.5 Then 
									MtSC = Fix(MtSC) + 1
								Else
									MtSC = Fix(MtSC) 
								End If

								If rs_Fo1("STRCT_ID") <> 8 And rs_Fo1("STRCT_ID") <> 9 And rs_Fo1("STRCT_ID") <> 19 Then
                                LesRedevances = LesRedevances & "<tr valign='middle'> " & vbNewLine & _
                                    "<td width='65' height='39' align='left' rowspan='2'><font size='2' face='Americana BT'>&nbsp;" & rs_Fo1("STRCT") & "</font></td> " & vbNewLine & _
                                    "<td width='47' height='19' align='right'><font size='2' face='Americana BT'>Taux : &nbsp;</font></td> " & vbNewLine & _
                                    "<td width='29' height='19' align='left'><font size='2' face='Americana BT'>" & rs_Fo1("TAUX") & "</font></td> " & vbNewLine & _
                                    "<td width='72' height='19' align='right'><font size='2' face='Americana BT'>Montant :&nbsp;</font></td> " & vbNewLine & _
                                    "<td width='180' height='19' align='left'><font size='2' face='Americana BT'>" & Prix(rs_Fo1("CH_MTT")) & " Frs</font></td> " & vbNewLine & _
                                    "<td width='66' height='39' align='left' rowspan='2'><font size='2' face='Americana BT'>Chèque :&nbsp;</font></td> " & vbNewLine & _
                                    "<td width='87' height='39' align='left' rowspan='2'><font size='2' face='Americana BT'>" & rs_Fo1("CH_REF") & "</font></td> " & vbNewLine & _
                                "</tr> " & vbNewLine & _
                                "<tr valign='middle'> " & vbNewLine & _
                                    "<td width='47' height='19' align='right'><font size='2' face='Americana BT'>Date : &nbsp;</font></td> " & vbNewLine & _
                                    "<td width='29' height='19' align='left'><font size='2' face='Americana BT'>" & rs_Fo1("CH_DATE") & "</font></td> " & vbNewLine & _
                                    "<td width='72' height='19' align='right'><font size='2' face='Americana BT'>Banque :&nbsp;</font></td> " & vbNewLine & _
                                    "<td width='180' height='19' align='left'><font size='2' face='Americana BT'>" & rs_Fo1("BANK") & "</font></td> " & vbNewLine & _
                                "</tr>"														
						        ElseIf rs_Fo1("STRCT_ID") <> 19 Then
                                	LesTaxes = LesTaxes & "<tr valign='middle'> " & vbNewLine & _
                                    "<td width='65' height='39' align='left' rowspan='2'><font size='2' face='Americana BT'>&nbsp;" & rs_Fo1("STRCT") & "</font></td> " & vbNewLine & _
                                    "<td width='47' height='19' align='right'><font size='2' face='Americana BT'>Taux :&nbsp; </font></td> " & vbNewLine & _
                                    "<td width='29' height='19' align='left'><font size='2' face='Americana BT'>" & rs_Fo1("TAUX") & "</font></td> " & vbNewLine & _
                                    "<td width='72' height='19' align='right'><font size='2' face='Americana BT'>Montant :&nbsp;</font></td> " & vbNewLine & _
                                    "<td width='180' height='19' align='left'><font size='2' face='Americana BT'>" & Prix(rs_Fo1("CH_MTT")) & " Frs</font></td> " & vbNewLine & _
                                    "<td width='66' height='39' align='left' rowspan='2'><font size='2' face='Americana BT'>Chèque :&nbsp;</font></td> " & vbNewLine & _
                                    "<td width='87' height='39' align='left' rowspan='2'><font size='2' face='Americana BT'>" & rs_Fo1("CH_REF") & "</font></td> " & vbNewLine & _
                                "</tr> " & vbNewLine & _
                                "<tr valign='middle' height='19'> " & vbNewLine & _
                                    "<td width='47' align='right'><font size='2' face='Americana BT'>Date :&nbsp; </font></td> " & vbNewLine & _
                                    "<td width='29' align='left'><font size='2' face='Americana BT'>" & rs_Fo1("CH_DATE") & "</font></td> " & vbNewLine & _
                                    "<td width='72' align='right'><font size='2' face='Americana BT'>Banque :&nbsp;</font></td> " & vbNewLine & _
                                    "<td width='180' align='left'><font size='2' face='Americana BT'>" & rs_Fo1("BANK") & "</font></td> " & vbNewLine & _
                                "</tr>"	
								ElseIf rs_Fo1("STRCT_ID") = 19  And rs_Fo1("CH_MTT") > 0 then  'And rs_Fo1("TAUX")> 0  Then	Round(Poids_Fo1*Taux,0)' 
								
                                	Reverst = Reverst & "<tr valign='middle'> " & vbNewLine & _
                                    "<td width='65' height='39' align='left' rowspan='2'><font size='2' face='Americana BT'>&nbsp;" & rs_Fo1("STRCT") & "</font></td> " & vbNewLine & _
                                    "<td width='47' height='19' align='right'><font size='2' face='Americana BT'>Taux :&nbsp; </font></td> " & vbNewLine & _
                                    "<td width='29' height='19' align='left'><font size='2' face='Americana BT'>" & Taux & "</font></td> " & vbNewLine & _
                                    "<td width='72' height='19' align='right'><font size='2' face='Americana BT'>Montant :&nbsp;</font></td> " & vbNewLine & _
                                    "<td width='180' height='19' align='left'><font size='2' face='Americana BT'>" & Prix(rs_Fo1("CH_MTT")) & " Frs</font></td> " & vbNewLine & _
                                    "<td width='66' height='39' align='left' rowspan='2'><font size='2' face='Americana BT'>Chèque :&nbsp;</font></td> " & vbNewLine & _
                                    "<td width='87' height='39' align='left' rowspan='2'><font size='2' face='Americana BT'>" & rs_Fo1("CH_REF") & "</font></td> " & vbNewLine & _
                                "</tr> " & vbNewLine & _
                                "<tr valign='middle' height='19'> " & vbNewLine & _
                                    "<td width='47' align='right'><font size='2' face='Americana BT'>Date :&nbsp; </font></td> " & vbNewLine & _
                                    "<td width='29' align='left'><font size='2' face='Americana BT'>" & rs_Fo1("CH_DATE") & "</font></td> " & vbNewLine & _
                                    "<td width='72' align='right'><font size='2' face='Americana BT'>Banque :&nbsp;</font></td> " & vbNewLine & _
                                    "<td width='180' align='left'><font size='2' face='Americana BT'>" & rs_Fo1("BANK") & "</font></td> " & vbNewLine & _
                                "</tr>"			
                                End If
                                
                                If rs_Fo1("STRCT_ID") = 8 Then
                                	Enr_Tx = rs_Fo1("TAUX") : Enr_Mt = Prix(rs_Fo1("CH_MTT"))
                                End If    
								Print = rs_Fo1("Modele")
								
								Redim Lots(Int(rs_Fo1("NB_LOT")), 1)
								
								If Embarq = "SAN PEDRO" And rs_Fo1("L_Edit") = "Abj" Then
									Execution = "EXECUTION A SAN - PEDRO" 
								ElseIf Embarq = "ABIDJAN" And rs_Fo1("L_Edit") = "Sp" Then 
									Execution = "EXECUTION A ABIDJAN"     
								Else 
									Execution = "" 
								End If
																
								If rs_Fo1("AR_FO1") = True Then
									Ar = "ANNULE ET REMPLACE LA FORMULE N° " & Fo1_Exp & "/" & rs_Fo1("Fo1_Mere") & " POUR :<br>"
									Ar = Ar & UCase(rs_Fo1("AR_LIB")) & "<br>"
								End If
								
						        If rs_Fo1("A_FO1") = True Then
									Ar = UCase(rs_Fo1("A_LIB")) & "<br>"
								End If
								
								Redim Lots(Int(rs_Fo1("NB_LOT")), 1)
								
								j = j + 1														
								
						'############################
							ElseIf Nb = 2 Then	' ###  => Jeu de Résultats N° 2 - Liste des Lots
						'############################
													   
								If Count > 0 Then aa = " - " Else aa = "" End If
								
								If Marque <> rs_Fo1("Marque") Then aa = "" : bb = bb + 1 End If
								
								Lots(bb, 0) = rs_Fo1("Marque")
								
								If rs_Fo1("Numero") <> "" Then ' Si Le Numero n'est Pas Vide
									If rs_Fo1("Sacs") <> aLot Then Queue = "[" & rs_Fo1("Sacs") & "]" Else Queue = "" End If
								   	Lots(bb, 1) = Lots(bb, 1) & aa & CStr(rs_Fo1("Numero") & Queue)
								End If
								 
								Marque = rs_Fo1("Marque")
								
								Count = Count + 1														
								
						'###############
							End If ' ###  => Fin de Sélection du Jeu de Résultats 
						'###############
						
						rs_Fo1.MoveNext
						
					Wend
					
					Set rs_Fo1 = rs_Fo1.NextRecordset
					
					Nb = Nb + 1
					
				Loop

	'### - Fermeture des Objets de Connexion
				'rs_Fo1.Close
				
				Set rs_Fo1 = Nothing
				Set Cmd_Db = Nothing

%>
	<head>
		<title>Le Conseil du Café-Cacao - Formule Provisoire</title>
		<link href="../include/global.css" type="text/css" rel="stylesheet">
		<link href="../include/print.css" type="text/css" rel="stylesheet">
		<style> 
	        @media print{   
	            .ecran 
	                {display: none;}
	        }
		</style>
	</head>
	
	<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">

<%	
	If J = 0 Then	
%>
	<p align="center"><font face="Verdana" size="3" color="red"><b>ERREUR NUMERO FORMULE !<br>Veuillez contacter votre Administrateur</b></font></p>
<%
	Else	
%>

<table align="center" border="0" cellpadding="0" cellspacing="0" width="751">
    <tr>
        <td width="751" valign="top">
		
<table border="0" width="750" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF" bordercolorlight="#000000" bordercolordark="#FFFFFF" summary="" align="center">
    <tr>
        <td width="752" align="left" valign="top" colspan="2">
            <table width="737" border="0" cellpadding="0" cellspacing="0" summary="" height="30">
			<%
				If Len(Execution) > 0 Then
			%>
				<tr>
                    <td width="737" align="center" valign="middle" colspan="3" height="20">
						<font face="Americana BT"><span style="font-size:10pt; text-align: center"><b><%=Execution%></b></span></font>
                    </td>
                </tr>
			<%
				End If
			%>
                <tr>
                    <td width="166" height="44" align="center">
                    	<font face="Americana BT"><span style="font-size:7pt;">REPUBLIQUE DE COTE D'IVOIRE<br>MINISTERE DE L'ECONOMIE<br>ET DES FINANCES<br></span></font>
					</td>
                    <td width="394" height="44" align="center">
						<u><b><font size="3" face="Americana BT">DIRECTION DU COMMERCE EXTERIEUR<br />DEMANDE D'AUTORISATION D'EXPORTATION</font></b>
					</td>
                    <td width="177" height="44" align="center"><b><font size="2" face="Americana BT">CAFE VERT<br>CACAO FEVES</font></b></td>
                </tr>
			<%
				If Len(Ar) > 0 Then
			%>
				<tr>
                    <td width="737" align="center" valign="middle" colspan="3" height="20">
						<font face="Americana BT" color="red"><span style="font-size:10pt; text-align: center"><b><%=Ar%></b></span></font>
                    </td>
                </tr>
			<%
				End If
			%>
            </table>
        </td>
    </tr>
	<tr>
	    <td width="173" height="" align="left" valign="top">
		
<table width="181" border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF" bordercolorlight="#000000" bordercolordark="#FFFFFF" summary="">
	<tr>
		<td width="181" align="center" valign="top">
			<table border="1" cellpadding="0" cellspacing="0" bordercolorlight="#000000" width="180" style="border-collapse: collapse" bordercolor="#111111">
				<tr>					
					<td width="180" height="139" align="center" valign="top"><font size="2" face="Americana BT">Le Conseil du Caf&eacute;-Cacao<br> Autorisation
					   accordée le<br></font>
					<% IF len(F_Prov) > 0 Then %>
						<table border="0" height="90" width="133">						
						    <tr><td width="127" height="103" valign="bottom" align="center">							
								<font size="4" face="Americana BT">Formule Provisoire<br></font>							
							</td>
						   </tr>						
						   <tr><td width="127" height="82" valign="bottom" align="center">														
								<font size="2" face="Americana BT">( Cachet et Visa )<br></font>
							</td></tr>
						</table>
					<% Else %>
						<table border="0" height="90" width="133">
						   <tr><td width="127" height="185" valign="bottom" align="center">														
								<font size="2" face="Americana BT">( Cachet et Visa )<br></font>
							</td></tr>
						</table>
					<% End IF %>
					</td>
			    </tr>
			</table>
			<table width="125" border="0" cellpadding="0" cellspacing="0" summary="">
				<tr><td width="125"><font style="font-size: 3pt" face="Americana BT">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</font></td></tr>
			</table>
			
            <table border="0" cellpadding="0" cellspacing="0" width="116">
				<tr><td width="116"><font style="font-size: 3pt" face="Americana BT">&nbsp;&nbsp;&nbsp;&nbsp;</font></td></tr>
            </table>
			<table width="180" border="1" cellpadding="0" cellspacing="0" bordercolor="#111111" bordercolorlight="#000000" style="border-collapse: collapse" summary="">
				<tr>
					<td width="180" height="" valign="top" align="center"><font size="2" face="Americana BT">Direction Générale<br>des Impôts<br>
						<br><br><%=Enr_Tx%> % x <%=Caf%> = <%=Prix(Enr_Mt)%> Frs<br>
                        <br><br><%'=NversL(Enr_Mt,"Fr","")%><br><br><br>Le Receveur de<br>l'Enregistrement</font>
					</td>
				</tr>
			</table>
            <table border="0" cellpadding="0" cellspacing="0" width="112">
				<tr><td width="112"><font style="font-size: 3pt" face="Americana BT">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</font></td></tr>
            </table>
			<table border="1" cellpadding="0" cellspacing="0" bordercolorlight="#000000" width="180" style="border-collapse: collapse" bordercolor="#111111">
			    <tr>
			        <td width="180" height="" valign="top" align="center">
						<font size="2" face="Americana BT">Déclaration en Douane<br><br>............... &nbsp;N° .................<br><br>
						Abidjan, le<br><br>......................................<br><br>L'Inspecteur<br></font><br>
					</td>
			    </tr>
			</table>
            <table border="0" cellpadding="0" cellspacing="0" width="118">
				<tr><td width="118"><font style="font-size: 3pt" face="Americana BT">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</font></td></tr>
            </table>
			<table border="1" cellpadding="0" cellspacing="0" bordercolorlight="#000000" style="border-collapse: collapse" bordercolor="#111111" width="180">
				<tr valign="top" align="center">
				    <td width="180"><font size="2" face="Americana BT">
					Vu Embarquer - Navire<br> parti le<br><br><br><br><br><br><br>(Cachet et Visa de<br>la Douane)<br><br></font></td>
				</tr>
				<tr>
					<td width="180"><font size="2" face="Americana BT"><br>REF Fo1:<br><%=Fo1_Exp&"/"&Fo1_Bcc%><br></font></td> 
				</tr>
			</table>
		</td>
	</tr>
</table>

        </td>
	    <td align="left" valign="top" width="581" height="">

<table border="0" cellspacing="0" width="569" bordercolordark="white" bordercolorlight="black" cellpadding="0">
	<tr>
        <td width="361" colspan="1" valign="top" align="left">
			<table width="360" border="0" cellpadding="0" cellspacing="0" bordercolorlight="#000000" bordercolordark="#FFFFFF" summary="">
				<tr>
					<td width="93" height="20" align="left"><font size="2" face="Americana BT">&nbsp;Exportateur :</font></td>
					<td width="263" height="20" align="left"><font size="3" face="Americana BT"><%=Nom%></font></td>
				</tr>
				<tr>
					<td width="93" height="20" align="left"><font size="2" face="Americana BT">&nbsp;Transitaire :</font></td>
					<td width="263" height="20" align="left"><font size="3" face="Americana BT"><%=Transitaire%></font></td>
				</tr>
			</table>

			<table width="360" border="0" cellpadding="0" cellspacing="0" height="125">
				<tr align="left" valign="middle">
				    <td height="20" width="357" colspan="2"><font size="2" face="Americana BT">&nbsp;N° d'Autorisation :</font></td>
				</tr>
				<tr valign="middle">
					<td width="94" align="left" height="20"><font size="2" face="Americana BT">&nbsp;N° Contrat</font></td>
					<td width="263"><font size="2" face="Americana BT">: <%=Contrat%></font></td>
				</tr>
				<tr valign="middle" height="20">
					<td width="94" align="left"><font size="2" face="Americana BT">&nbsp;Produit</font></td>
					<td width="263"><font size="2" face="Americana BT">: <%=Prdt_Grd%></font></td> 
				</tr>
				<tr>
					<td width="94" align="left" valign="middle" height="20"><font size="2" face="Americana BT">&nbsp;Campagne</font></td>
					<td width="263" valign="middle" height="20"><font size="2" face="Americana BT">: <%=Campagne%></font></td>
				</tr>
				<tr>
					<td width="94" align="left" valign="middle" height="20"><font size="2" face="Americana BT">&nbsp;Récolte</font></td>
					<td width="263" valign="middle" height="20"><font size="2" face="Americana BT">: <%=Recolte%> / <%=Prdt & "-" & Parite%></font></td>
				</tr>
				<tr>
					<td width="94" align="left" valign="middle" height="20"><font size="2" face="Americana BT">&nbsp;Grade</font></td>
					<td width="263" valign="middle" height="20"><font size="2" face="Americana BT">: <%=Grade & "&nbsp;&nbsp;" & G_Kko %></font></td>
				</tr>
				<tr>
					<td width="94" align="left" valign="middle" height="20"><font size="2" face="Americana BT">&nbsp;Qualité</font></td>
					<td width="263" valign="middle" height="20"><font size="2" face="Americana BT">: <%=Qualite%></font></td>
				</tr>
			</table>
			
			<table width="359" border="0" cellpadding="0" cellspacing="0" summary="" height="">
				<tr>
					<td align="center" valign="middle" width="71" height="60" rowspan="3"><font size="2" face="Americana BT">Destination<br><%=Region%></font></td>
					<td align="left" valign="middle" width="41" height="20"><font size="2" face="Americana BT">&nbsp;Pays </font></td>
					<td align="left" valign="middle" width="247" height="20"><font size="2" face="Americana BT">: <%=Pays%></font></td>
				</tr>
				<tr>
					<td align="left" valign="middle" width="41" height="20"><font size="2" face="Americana BT">&nbsp;Port </font></td>
					<td align="left" valign="middle" width="247" height="20"><font size="2" face="Americana BT">: <%=Debarq%></font></td>
				</tr>
				<tr>
					<td align="left" valign="middle" width="41" height="20"><font size="2" face="Americana BT">&nbsp;Via </font></td>
					<td align="left" valign="middle" width="247" height="20"><font size="2" face="Americana BT">: <%=Via%></font></td>
				</tr>
			</table>
			
			<table width="360" border="0" cellpadding="0" cellspacing="0">
				<tr align="left">
					<td width="61" height="40" rowspan="2"><font size="2" face="Americana BT">&nbsp;Origine</font></td>
					<td valign="middle" width="299" height="20" colspan="2"><font size="2" face="Americana BT">&nbsp;Port d'Embarq :&nbsp;<%=Embarq%></font></td>
				</tr>
				<tr align="left">
					<td valign="middle" width="299" height="20" colspan="2"><font size="2" face="Americana BT">&nbsp;Période d'Embarq :&nbsp;<%=Periode%></font></td>
				</tr>
			</table>
			
		<%If Trans = 1 Then%>
			<table width="360" border="0" cellpadding="0" cellspacing="0" summary="" height="40">
				<tr align="left" valign="middle">
					<td width="70" height="20" rowspan="2"><font size="2" face="Americana BT">&nbsp;Tonnage</font></td>
					<td width="290" height="20"><font size="2" face="Americana BT">&nbsp;Net&nbsp;&nbsp;:&nbsp;<%=Prix(Poids_Fo1)%> Kg</font></td>
				</tr>
				<tr align="left" valign="middle">
					<td width="290" height="20"><font size="2" face="Americana BT">&nbsp;Brut&nbsp;:&nbsp;<%=Prix(Brut_Fo1)%> Kg</font></td>
				</tr>
			</table>
		<%ElseIf Trans = 2 Then%>
			<table width="360" border="0" cellpadding="0" cellspacing="0" summary="" height="40">
				<tr align="left" valign="middle" height="20">
					<td width="70" rowspan="2"><font size="2" face="Americana BT">&nbsp;Tonnage</font><font face="Americana BT"></font></td>
					<td width="290"><font size="2" face="Americana BT">&nbsp;Net&nbsp;&nbsp;:&nbsp;<%=Prix(Net_Fini)%> x <%=Coef%> = <%=Prix(Poids_Fo1)%> Kg</font></td>
				</tr>
				<tr align="left" valign="middle" height="20">
					<td width="290"><font size="2" face="Americana BT">&nbsp;Brut&nbsp;:&nbsp;<%=Prix(Brut_Fo1)%> Kg</font></td>
				</tr>
			</table>
		<%End If%>
		
			<table width="360" border="0" cellpadding="0" cellspacing="0" summary="" height="">
                <tr>
                    <td width="220" valign="middle" align="left" height="20">
						<table border="0" cellspacing="0" cellpadding="0" width="220">
                            <tr>
                                <td width="80"><font size="2" face="Americana BT">&nbsp;Emballage : </font></td>
                                <td width="140"><font size="2" face="Americana BT"> <%=Emballage%></font></td>
                            </tr>
                        </table>
                    </td>                    
                    <td width="140" valign="middle" align="left" height="20">                                                
						<table border="0" cellspacing="0" cellpadding="0" width="140">
                            <tr>
                                <td width="60"><font size="2" face="Americana BT">Nombre : </font></td>
                                <td width="80"><font size="2" face="Americana BT"><%=Prix(Sac)%></font></td>
                            </tr>
                        </table>
                    </td>
                </tr>
                
			</table>

            <table border="0" cellspacing="0" cellpadding="0" width="360">
                <tr>
                    <td width="50"><font size="2" face="Americana BT">&nbsp;Transit : </font></td>
                    <td width="170" align="left"><font size="2" face="Americana BT"> <%=Transit%></font></td>
                </tr>
            </table>

			<table width="360" border="0" cellpadding="0" cellspacing="0" summary="" height="20">
				<tr><td width="360" valign="middle" align="left" height="20"><font size="2" face="Americana BT">&nbsp;Destinataire :<b>&nbsp;</b><%=Destinataire%></font></td></tr>
				<tr><td width="360" valign="middle" align="left" height="20"><font size="2" face="Americana BT">&nbsp;Nomenclature Douanière :<b>&nbsp;</b><%=Nomenc%></font></td></tr>
				<tr><td width="360" valign="middle" align="left" height="20"><font size="2" face="Americana BT">&nbsp;Navire :<b>&nbsp;</b><%=Navire%></font></td></tr>
				<tr><td width="360" valign="middle" align="left" height="20"><font size="2" face="Americana BT">&nbsp;Valeur FOB réelle en Douane : <%If Fob <> 0 Then Response.Write Prix(Fob) & " Frs"  End If%></font></td></tr>
			</table>                    

		</td>
		<td width="208" align="left" height="" valign="top">
		
			<table border="1" cellpadding="0" cellspacing="0" width="205" bordercolorlight="#000000" height="" style="border-collapse: collapse" bordercolor="#111111">
				<tr>
					<td align="center" colspan="2" height="25" width="205">			
						<table border="0" cellpadding="0" cellspacing="0" width="205" bordercolorlight="#000000" height="" style="border-collapse: collapse" bordercolor="#111111">
							<tr>
							  <td align="center" colspan="2" height="25" width="205"><font size="2" face="Americana BT">Contrat <%=TypeCV%></font></td>
						  </tr>
							<tr>
								<td width="65" align="left" valign="middle" height="20"><font size="2" face="Americana BT">&nbsp;N&deg;</font></td>
						      <td width="140" align="left" valign="middle" height="20"><font size="2" face="Americana BT">: <%=Enr%></font></td>
						  </tr>
							<tr>
								<td width="65" align="left" valign="middle" height="20"><font size="2" face="Americana BT">&nbsp;Date</font></td>
								<td width="140" align="left" valign="middle" height="20"><font size="2" face="Americana BT">: <%=FormatDateTime(Date_Enr,2)%></font></td>
							</tr>
							<tr>
								<td width="65" align="left" valign="middle" height="20"><font size="2" face="Americana BT">&nbsp;Prix</font></td>
							  <td width="140" align="left" valign="middle" height="20"><font size="2" face="Americana BT">: <%=Prix(Enr_Prix)%> Frs CFA</font></td>
							</tr>
							<tr>
								<td width="65" align="left" valign="middle" height="20"><font size="2" face="Americana BT">&nbsp;Période</font></td>
								<td width="140" align="left" valign="middle" height="20"><font size="2" face="Americana BT">: <%=Enr_Per%></font></td>
							</tr>
						</table>
					</td>								
				</tr>
			</table>								

			<table border="0" cellpadding="0" cellspacing="0">
			    <tr><td width="100"><font face="Americana BT"><span style="font-size:2pt;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></font></td></tr>
			</table>
			<table border="1" cellpadding="0" cellspacing="0" width="205" bordercolorlight="#000000" height="" style="border-collapse: collapse" bordercolor="#111111">
				<tr>
					<td align="center" colspan="2" height="25" width="205">			
						<table border="0" cellpadding="0" cellspacing="0" width="205" bordercolorlight="#000000" height="" style="border-collapse: collapse" bordercolor="#111111">
							<tr>
								<td align="center" colspan="2" height="25" width="205"><font size="2" face="Americana BT">Confirmation de vente</font></td>
						  </tr>
							<tr>
								<td width="65" align="left" valign="middle" height="20"><font size="2" face="Americana BT">&nbsp;N°</font></td>
							  <td width="140" align="left" valign="middle" height="20"><font size="2" face="Americana BT">: <%=Cdc%></font></td>
							</tr>
							<tr>
								<td width="65" align="left" valign="middle" height="20"><font size="2" face="Americana BT">&nbsp;Date</font></td>
								<td width="140" align="left" valign="middle" height="20"><font size="2" face="Americana BT">: <%=FormatDateTime(Date_Cdc,2)%></font></td>
							</tr>
                            <tr>
								<td width="65" align="left" valign="middle" height="20"><font size="2" face="Americana BT">&nbsp;Prix</font></td>
							  <td width="140" align="left" valign="middle" height="20"><font size="2" face="Americana BT">: <%=Prix(Prix_Cv)%> Frs CFA</font></td>
							</tr>
							<tr>
								<td width="65" align="left" valign="middle" height="20"><font size="2" face="Americana BT">&nbsp;Prix Ref</font></td>
							  <td width="140" align="left" valign="middle" height="20"><font size="2" face="Americana BT">: <%=Caf%> Frs CFA</font></td>
							</tr>
                            <%If Tx_Decote<>0 Then%>
                            <tr>
								<td width="65" align="left" valign="middle" height="20"><font size="2" face="Americana BT">&nbsp;Prix Décoté</font></td>
							  <td width="140" align="left" valign="middle" height="20"><font size="2" face="Americana BT">: <%=Decote_prix%> Frs CFA</font></td>
							</tr>
                            <%End If%>
							<tr>
								<td width="65" align="left" valign="middle" height="20"><font size="2" face="Americana BT">&nbsp;Période</font></td>
								<td width="140" align="left" valign="middle" height="20"><font size="2" face="Americana BT">: <%=Periode%></font></td>
							</tr>
						</table>
					</td>								
				</tr>
			</table>								

			<table border="0" cellpadding="0" cellspacing="0">
			    <tr><td width="100"><font face="Americana BT"><span style="font-size:2pt;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></font></td></tr>
			</table>
			<table border="1" cellspacing="0" width="207" bordercolorlight="#000000" cellpadding="0" style="border-collapse: collapse" bordercolor="#111111" height="25">
			    <tr><td align="center" width="207"><font size="2" face="Americana BT">Date FO1 : <b><%=FormatDateTime(Date_Fo1,2)%></b></font></td></tr>
			</table>
			<table border="0" cellpadding="0" cellspacing="0">
			    <tr><td width="100"><font face="Americana BT"><span style="font-size:2pt;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></font></td></tr>
			</table>
			
			<table border="0" cellpadding="0" cellspacing="0">
			    <tr><td width="100"><font face="Americana BT"><span style="font-size:2pt;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></font></td></tr>
			</table>
		<% IF len(F_Prov) > 0 Then %>
			<table border="1" cellspacing="0" width="207" bordercolorlight="#000000" cellpadding="0" style="border-collapse: collapse" bordercolor="#111111" height="30">
			    <tr><td align="center" valign="top" width="207" height="30"><font size="2" face="Americana BT">REFERENCE FO1</font><br><font size="2" face="Arial Black" color="#FF0000"><%=Fo1_Exp&"/"&Fo1_Bcc%></font></td></tr>
			</table>
		<% Else %>			
			<table border="1" cellspacing="0" width="207" bordercolorlight="#000000" cellpadding="0" style="border-collapse: collapse" bordercolor="#111111" height="30">
			    <tr><td align="center" valign="top" width="207" height="30"><font size="2" face="Americana BT">N° FO1</font><br><font size="6" face="Arial Black" color="#FF0000"><%=Frc%></font></td></tr>
			</table>
		<% End IF %>
			<table border="0" cellpadding="0" cellspacing="0">
			    <tr><td width="100"><font face="Americana BT" size="2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</font></td></tr>
			</table>
			<table border="1" cellspacing="0" width="207" bordercolorlight="#000000" cellpadding="0" height="50" style="border-collapse: collapse" bordercolor="#111111">
				<tr>
                <td width="207" align="center" valign="top" height="64">
                <font size="2" face="Americana BT">Date, Signature et Cachet du Demandeur<br><br><br></font></td></tr>
			</table>
	    </td>
	</tr>
</table>
<hr />
<table width="95%" border="0" cellspacing="0" cellpadding="2" align="center">
  <tr>
    <th scope="col" align="center" height="25" colspan="5"><font face="Americana BT" size="2"><b>&nbsp; <u>REVERSEMENT/SOUTIEN(F CFA)</u></b></font></th>
  </tr>
  <tr height="20">
    <th scope="col" align="center"><font face="Americana BT" size="2"><b>&nbsp;TONNAGE</b></font></th>
    <th colspan="2" align="center" scope="col"><font face="Americana BT" size="2"><b>&nbsp;TAUX(FCFA/KG) </b></font></th>
    <th scope="col" align="center"><font face="Americana BT" size="2"><b> REVERSEMENT</b></font></th>
    <th scope="col" align="center"><font face="Americana BT" size="2"><b> SOUTIEN</b></font></th>
  </tr>
  <tr align="center" height="20">
    <td><font face="Americana BT" size="2">&nbsp;<%=Prix(Tonnage)%>&nbsp;</font></td>
    <td><font face="Americana BT" size="2"><b>BASE</b>&nbsp;&nbsp;</font></td>
    <td><font face="Americana BT" size="2">&nbsp;<%=TauxU%></font></td>
    <td><font face="Americana BT" size="2">&nbsp;<%=Prix(MtR)%></font></td>
    <td><font face="Americana BT" size="2">&nbsp;<%=Prix(MtS)%></font></td>
  </tr>
  <%If Tx_Decote <> 0 Then%>
  <tr align="center" height="20">
    <td><font face="Americana BT" size="2">&nbsp;<%=Prix(Tonnage)%>&nbsp;</font></td>
    <td><font face="Americana BT" size="2"><b>DECOTE</b>&nbsp;&nbsp;</font></td>
    <td><font face="Americana BT" size="2">&nbsp;<%=Tx_Decote%></font></td>
    <td><font face="Americana BT" size="2">&nbsp;<%=Prix(MtRC)%></font></td>
    <td><font face="Americana BT" size="2">&nbsp;<%=Prix(MtSC)%></font></td>
  </tr>  
  <%ElseIf Compense>0 Then%>
  <tr align="center" height="20">
    <td><font face="Americana BT" size="2">&nbsp;<%=Prix(Tonnage)%>&nbsp;</font></td>
    <td><font face="Americana BT" size="2"><b>COMPENSE</b>&nbsp;&nbsp;</font></td>
    <td><font face="Americana BT" size="2">&nbsp;<%=TauxC%></font></td>
    <td><font face="Americana BT" size="2">&nbsp;<%=Prix(MtRC)%></font></td>
    <td><font face="Americana BT" size="2">&nbsp;<%=Prix(MtSC)%></font></td>
  </tr>

  <%End If%>  
</table>
<table width="568" border="0"  cellspacing="0">
	<tr><td width="564" colspan="7" height="20"></td></tr>
    <%=Reverst%>
</table>
<hr />
<table width="568" border="0"  cellspacing="0">
	<tr><td width="564" colspan="7"></td></tr>
	<tr>
		<td width="564" height="18" valign="middle" align="center" colspan="7"><u><b><font size="2" face="Americana BT">REDEVANCES</font></b></u></td>
	</tr>
    <%=LesRedevances%>
    <tr><td width="564" colspan="7"><hr></td></tr>
	<tr>
		<td width="564" height="18" valign="middle" align="center" colspan="7"><u><b><font size="2" face="Americana BT">TAXES</font></b></u></td>
	</tr>    
    <%=LesTaxes%>
</table>
			<table width="100%">
				<tr align="center">
					<td width="193"><font size="6" face="Americana BT"><strong><%=LibPrepaye%></strong></font></td> <td width="193">&nbsp;</td> 
					<td width="194"><font size="4" face="Americana BT">CAMPAGNE <br><%=Campagne%></font></td>
				</tr>
			</table>
		</td>
	</tr>
</table>
<table align="center" width="750" border="0" cellpadding="0" cellspacing="0" summary="">
	<tr>
		<td align="center" width="10"><font size="1" face="Americana BT">&nbsp;</font></td>
		<td width="740">
			<%
				Dim ii
				
				If Count > 0 Then
				
				   	If Int(bb) < 1 Then ii = "Left" Else ii ="center" End If
					
					Response.Write "<div align=""center""><font size=""1"" face=""Americana BT"" ><b><u>MARQUE ET NUMERO DE LOTS</u></b></font></div>" & vbNewLine
					Response.Write "<table width=""735"" border=""0"" align=""" & ii & """ cellpadding=""0"" cellspacing=""0"">" & vbNewLine
					
						For i = 1 To bb	
																				
							Response.Write "    <tr>" & VbNewLine
							Response.Write "        <td align=""left"" valign=""top"" width=""50""><font size=""2"" face=""Americana BT""><nobr>" & Lots(i,0) & " &nbsp;:&nbsp;&nbsp;</nobr></font><td>" & vbNewLine
							Response.Write "        <td align=""left"" valign=""top"" width=""725""><font size=""2"" face=""Americana BT"">" & Lots(i,1) & "</font><td>" & vbNewLine
							Response.Write "    </tr>" & vbNewLine
							
						Next
						
					Response.Write "</table>" & vbNewLine
					
				End If
			%>
		</td>
	</tr>
</table>
			
<div style="text-align:center;">
	<a href="javascript:onClick=window.print()"><font face="Americana BT" size="2" class="Ecran" color="#ff0000">Imprimer</font></a>
</div>
			
		</td>
    </tr>
</table> 


<%	End If	%>

</BODY></HTML>


