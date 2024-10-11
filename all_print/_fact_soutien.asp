	<!--#include file="../include/inc_con.asp" -->
	<!--#include file="../include/fonction.asp" -->
	<!--#include file="../include/encryption.asp" -->
	
<%		
		If Session("Login") = False Or IsNull(Session("Login")) = True Then Response.Redirect "../expire.asp" End If		
								
	'### - Declaration des Variables
				Dim Code
				Dim Cmd_Db, rs_Fo1, Count
				Dim Pm_Out, Pm_Code, Pm_Type, Pm_Fo1
				Dim Fo1, Nb
				
                Dim tabFact, tabFo1, tabsTransmis, nFact, DtFact


	'### - Récupération des Variables Session Utilisateur
				Code  = Session("Code")			

	'### - Récupération des Valeurs de la Formule Sélectionnée
				Fo1 = Int(Request("Id")/365)
    
    '#####################################################
	'#####  Récupération de la Facture  #####  
	'#####################################################

		'### - Création de la Commande a Exécuter
				Set Cmd_Db = Server.CreateObject("AdoDB.Command")
					Cmd_Db.ActiveConnection = ado_Con
					Cmd_Db.CommandText = "Ps_Exp_FactSoutien"
					Cmd_Db.CommandType = adCmdStoredProc
	
		'### - Définition des Paramétres de la Procédure Stockée SQL
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
					If Nb = 1 Then		' ###  => Jeu de Résultats N0 1 - Informations de la facture globale sélectionnée	
				'############################

                        DtFact = rs_Fo1("DATE_FACTSOUT")

                        tabFact = "<tr class=""text-left""><td><b></b></td><td></td><td></td><td><b>DOIT:</b></td></tr>" & vbNewLine &_
                                    "<tr class=""text-left""><td width=""50""></td><td></td><td></td><td><b>Le Conseil du Café-Cacao <br />17 BP 797 Abidjan 17<br/>Tel: 20 26 69 69/20 25 69 70</b></td></tr>" & vbNewLine &_
                                    "<tr><td colspan=""4"">&nbsp;</td></tr>" & vbNewLine &_ 
                                    "<tr class=""text-left""><td><b>N° Facture</b></td><td>: &nbsp;" & rs_Fo1("NUM_FACTSOUT") & "</td><td><b>Référence CCC</b></td><td>:&nbsp;&nbsp;" & rs_Fo1("REF_FACTSOUT") & "</td></tr>" & vbNewLine &_
                                    "<tr class=""text-left""><td><b>N° OT</b></td><td>: &nbsp;" & rs_Fo1("Numero_OT") & "</td><td width=""120""><b>Date Facture </b></td><td>:&nbsp;&nbsp;" & rs_Fo1("DATE_FACTSOUT") & "</td></tr>" & vbNewLine &_   
                                    "<tr class=""text-left""><td><b>Campagne</b></td><td>: &nbsp;" & rs_Fo1("CAMPAGNE") & "</td><td><b></b></td><td></td></tr>" & vbNewLine &_ 
                                    "<tr class=""text-left""><td><b>Récolte</b></td><td>: &nbsp;" & rs_Fo1("RECOLTE") & "</td><td><b></b></td><td></td></tr>" & vbNewLine &_
                                    "<tr class=""text-left""><td><b>Produit</b></td><td colspan=""3"">: &nbsp;" & rs_Fo1("PRODUIT")  & "</td></tr>" & vbNewLine &_
                                    "<tr class=""text-left""><td><b>Domiciliation</b></td><td colspan=""3"">: &nbsp;" & rs_Fo1("BANK") & ", " & rs_Fo1("COMPTE")  & "</td></tr>" & vbNewLine
                                    										   
				'############################
					ElseIf Nb = 2 Then	' ###  => Jeu de Résultats N0 1 - Liste des formules de la facture
				'############################
						
                        Per1 = rs_Fo1("PERIODE")  
                        If Per1 <> Per2  Then 
                            If tabFo1 <> "" Then                                         
                                tabFo1 = tabFo1 & _
                                    "<tr bgcolor=""#EEEEEE"">" & _
                                        "<td colspan=""2""><b>S/TOTAL " & Periode & "</b> : </td>" & _ 
                                        "<td class=""text-right""><b>" & Prix(sTPoids) & "</b></td>" & _ 
                                        "<td class=""text-right""><b>" & Prix(sPReel) & "</b></td>" & _ 
                                        "<td class=""text-right""><b>" & Prix(sPFact) & "</b></td>" & _ 
                                        "<td> - </td>" & _ 
                                        "<td class=""text-right""><b>" & Prix(sMont) & "</b></td>" & _ 
                                    "</tr>"
                                    sTPoids = 0  : sMont = 0 : sPReel = 0 : sPFact = 0 : k = k+1                                           
                            End If

                            Periode = rs_Fo1("PERIODE") 
                            tabFo1 = tabFo1 & "<tr align=""text-center""><td colspan=""5""><b>" & rs_Fo1("PERIODE") & "</b></td></tr>"                             
                        End If	

						tabFo1 = tabFo1 & "<tr id=""" & Count & "_h0"">" & vbNewLine & _
									"	<td>" & rs_Fo1("CV") & "</td>" & vbNewLine &_
                                    "	<td>" & rs_Fo1("FO1") & "</td>" & vbNewLine &_
                                    "	<td class=""text-right"">" & Prix(rs_Fo1("POIDS_FO1")) & "</td>" & vbNewLine &_
                                    "	<td class=""text-right"">" & Prix(rs_Fo1("POIDS_R")) & "</td>" & vbNewLine &_  
                                    "	<td class=""text-right"">" & Prix(rs_Fo1("POIDSFACT")) & "</td>" & vbNewLine &_                                   
                                    "	<td class=""text-right"">" & rs_Fo1("TAUXSOUT") & "</td>" & vbNewLine &_                                    
                                    "	<td class=""text-right"">" & Prix(rs_Fo1("MONTSOUT")) & "</td>" & vbNewLine &_							
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
                        "<tr bgcolor=""#EEEEEE"">" & _
                            "<td colspan=""2""><b>S/TOTAL " & Periode & "</b> : </td>" & _
                            "<td class=""text-right""><b>" & Prix(sTPoids) & "</b></td>" & _ 
                            "<td class=""text-right""><b>" & Prix(sPReel) & "</b></td>" & _ 
                            "<td class=""text-right""><b>" & Prix(sPFact) & "</b></td>" & _ 
                            "<td> - </td>" & _ 
                            "<td class=""text-right""><b>" & Prix(sMont) & "</b></td>" & _ 
                        "</tr>"
                tabFo1 = tabFo1 & _
                    "<tr bgcolor=""#EEEEEE"">" & _
                        "<td colspan=""2""><b>TOTAL FACTURE</b> : </td>" & _
                        "<td class=""text-right""><b>" & Prix(TPoids) & "</b></td>" & _ 
                        "<td class=""text-right""><b>" & Prix(PReel) & "</b></td>" & _
                        "<td class=""text-right""><b>" & Prix(PFact) & "</b></td>" & _ 
                        "<td> - </td>" & _ 
                        "<td class=""text-right""><b>" & Prix(Mont) & "</b></td>" & _ 
                    "</tr>"
            End If
			
			Set rs_Fo1 = rs_Fo1.NextRecordset
			Nb = Nb + 1
						
        Loop
        
		'### - Fermeture des Objets de Connexion					
					
					Set rs_Fo1  = Nothing
					Set Cmd_Db = Nothing				
%>
    <table>
        <%=tabFact%>			
    </table>
    <br />
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
    <p>Arretè la présente facture à la somme de <b><%=NversL(Mont,"","")%> F CFA</b></p>



