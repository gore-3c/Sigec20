	<!--#include file="../include/inc_con.asp" -->
	<!--#include file="../include/fonction.asp" -->
	<!--#include file="../include/encryption.asp" -->
	<!--#include file="../include/inc_var.asp" -->
	
<%		
		If Session("Login") = False Or IsNull(Session("Login")) = True Then Response.Redirect "../expire.asp" End If		

		'If Not Acces_Page   = True Then Response.Redirect "../refuse.asp" & "?sigec=" & Server.UrlEncode(encrypt("?Motif=Menu_Refuse")) End If

	'### - Declaration des Variables
				Dim Code
				Dim Choix_Chq, Err_Msg
				Dim Cmd_Db
				Dim Pm_Out, Pm_Code, Pm_Type
                Dim Pm_Id, Pm_Rclt, Pm_Prdt, Pm_Parite, Pm_Camp, Pm_ListeF
				Dim rs_Fo1, Count, Fo1
				Dim Img, Id, Fo1_Option, Url, Prdt, Parite, Rclt, Camp, ListeF
				Dim Nb
				
	'### - Récupération des Variables Session Utilisateur
				Code  = Session("Code")
                Prdt = Request("Prdt")
                Camp = Request("Camp")
                Parite = Request("Parite")
                Rclt = Request("Rclt")
                ListeF = Request("ListFo1")

                ListeF = Replace(Request("ListFo1")," ","")
                ListeF = Replace(ListeF,";","','")
                ListeF = "'" & ListeF & "'"                
                        
	'##############################################################
	'#####  Récupération de la Liste des Formules en soutien ######  
	'##############################################################

		'### - Création de la Commande à Exécuter
					Set Cmd_Db = Server.CreateObject("AdoDB.Command")
						Cmd_Db.ActiveConnection = ado_Con
						Cmd_Db.CommandText = "Ps_Exp_FactSoutien"
						Cmd_Db.CommandType = adCmdStoredProc
	
		'### - Définition des Paramètres de la Procédure Stockée SQL
					Set Pm_Out		= Cmd_Db.CreateParameter("@Output", adInteger, adParamOutput)				: Cmd_Db.Parameters.Append Pm_Out
					Set Pm_Code		= Cmd_Db.CreateParameter("@Code", adVarChar, adParamInput, 3, Code)			: Cmd_Db.Parameters.Append Pm_Code
                    Set Pm_Type	    = Cmd_Db.CreateParameter("@Option", adVarChar, adParamInput, 25, "Formule")	: Cmd_Db.Parameters.Append Pm_Type
					Set Pm_Id	    = Cmd_Db.CreateParameter("@Id", adInteger, adParamInput, , 0) 			    : Cmd_Db.Parameters.Append Pm_Id
                    Set Pm_Search	= Cmd_Db.CreateParameter("@Search", adVarChar, adParamInput, 1000, "")	: Cmd_Db.Parameters.Append Pm_Search

                    Set Pm_Prdt	    = Cmd_Db.CreateParameter("@Prdt", adInteger, adParamInput, , Prdt) 			: Cmd_Db.Parameters.Append Pm_Prdt
                    Set Pm_Rclt	    = Cmd_Db.CreateParameter("@Reclt", adInteger, adParamInput, , Rclt) 		: Cmd_Db.Parameters.Append Pm_Rclt
                    Set Pm_Camp	    = Cmd_Db.CreateParameter("@Camp", adInteger, adParamInput, , Camp) 			: Cmd_Db.Parameters.Append Pm_Camp
                    Set Pm_Parite	= Cmd_Db.CreateParameter("@Parite", adInteger, adParamInput, , Parite) 		: Cmd_Db.Parameters.Append Pm_Parite
                    Set Pm_ListeF	= Cmd_Db.CreateParameter("@ListForm", adVarChar, adParamInput, 2000, ListeF)	: Cmd_Db.Parameters.Append Pm_ListeF	
		
		'### - Exécution de la Commande SQL
					Set rs_Fo1 = Cmd_Db.Execute
				
		'### - Affichage des Résultats de la Procédure SQL
					img = "<img src=""../images/warning.gif"" align=""absmiddle"" border=""0"" width=""33"" height=""34"" alt=""Alerte !"">"
				
					Count = 0
							
					Dim Records, Paging, aUrl, bUrl, w, x
                    'response.write "page: " & Page & "prdt:" & Prdt & "camp:" & camp & "parie:" & parite & "recolte:" & Rclt & " - " & Code
					While Not rs_Fo1.EOF
					
						Count = Count + 1

						Fo1_Option = "?Fo1=" & rs_Fo1("FO1_ID") & rSearch
						Fo1_Option = "?sigec=" & Server.UrlEncode(Encrypt(Fo1_Option))
								
						Fo1 = Fo1 & "<tr height=""25"" valign=""middle"" id=""" & Count & "_h0"">" & vbNewLine & _
									"	<td align=""center"">" & Count & "</td>" & vbNewLine &_
                                    "	<td align=""center"">" & rs_Fo1("PERIODE") & "</td>" & vbNewLine &_
                                    "	<td align=""center"">" & rs_Fo1("CDC_CGFCC") & "</td>" & vbNewLine &_
                                    "	<td align=""right"">" & Prix(rs_Fo1("PRIX")) & "</td>" & vbNewLine &_
                                    "	<td align=""center"">" & rs_Fo1("NUM_FRC") & "</td>" & vbNewLine &_
									"	<td align=""center"">" & FormatDateTime(rs_Fo1("DATE_FRC"),2) & "</td>" & vbNewLine &_
                                    "	<td align=""right"">" & Prix(rs_Fo1("POIDS_FO1")) & "</td>" & vbNewLine &_
                                    "	<td align=""right"">" & Prix(rs_Fo1("POIDS_REEL")) & "</td>" & vbNewLine &_ 
									"	<td align=""center"">" & rs_Fo1("TAUXRS") & "</td>" & vbNewLine &_									
									"	<td align=""center""><input type=""checkbox"" name=""oCheckbox"" value=""" & rs_Fo1("FO1_ID") & """ /></td>" & vbNewLine &_
									"</tr>" & vbNewLine
				
						rs_Fo1.MoveNext
						
					Wend

		'### - Fermeture des Objets de Connexion
					rs_Fo1.Close
					
					Set rs_Fo1  = Nothing
					Set Cmd_Db = Nothing	
%>
											
			<br /><br />
		
			<table width="96%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#859AA6" rules="rows" frame="hsides">
			    <tr bgcolor="#EEEEEE" height="25">
			      <th align="center"><b>#</b></td>
			      <th height="25" align="center"><b>Periode</b></td>
			      <th height="25" align="center"><b>CV</b></td>
			      <th height="25" align="center"><b>Prix</b></th>
                  <th height="25" align="center"><b>Fo1</b></th>
                  <th height="25" align="center"><b>Date Fo1</b></th>
                  <th height="25" align="center"><b>Poids Fo1</b></th>
                  <th height="25" align="center"><b>Poids Reel</b></th>                  
                  <th height="25" align="center"><b>Taux R/S</b></th>
			      <th height="25" align="center"><b>&nbsp;</b></th>
			    </tr>
		<%
				If Count = 0 Then
					Response.Write "<tr><td height=""50"" colspan=""8"" valign=""middle"" align=""center"">" & Img
					Response.Write " &nbsp;<font face=""Verdana"" size=""2""><b> - &nbsp;Vous n'avez pas de Formule disponible !</b></font></td></tr>"
				Else
					Response.Write Fo1
				End If
		%>
			</table>

			<table width="500" border="0" align="center" cellpadding="0" cellspacing="0" summary="">
				<tr><td width="500" height="20" align="right" valign="middle"><font face="Verdana" size="1">* Les Poids sont exprimes en Kilogrammes</font></td></tr>
			</table>
		
			 <br>

								










