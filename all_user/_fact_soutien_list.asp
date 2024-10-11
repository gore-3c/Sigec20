    <!--#include file="../include/inc_con.asp" -->
	<!--#include file="../include/fonction.asp" -->
    <!--#include file="../include/encryptions.asp" -->
    <!--#include file="../include/JSON_2.0.4.asp"-->
    <%	

    If Session("Login") = False Or IsNull(Session("Login")) = True Then Response.Redirect "../_expire.asp" End If	
    
    '### - Declaration des Variables
            Dim Code
            Dim Pm_Code, Pm_Option, Pm_Id, Pm_Out
            Dim Count, Nb, Mt, Id, Lien, Url, Nom, Xtype, xOption
            Dim Cmd_Db, rs_Enr
            Dim jsa, col, QueryToJSON

            Code = Session("Code")

            Search = ""
            Id = Request("id")
            Mt = Request("Mt")
            xType = Request("xType") 
            xOption = Request("xOption")

            
            Zone   = Request("Zone")					
            rZone  = Request("rZone")
            
            'Zone   = Replace(Zone 	,"'", "''")
            'rZone  = Replace(rZone 	,"'", "''")
            
            Search = " And (Month(FS.DATE_FACTSOUT) = " & Month(Now) & " And Year(FS.DATE_FACTSOUT) = " & Year(Now) & ") "
            If Zone <> "" Then
                Select Case rZone                    
                    Case "Date"	: Search = " And (Month(FS.DATE_FACTSOUT) = " & Month(Zone) & " And Year(FS.DATE_FACTSOUT) = " & Year(Zone) & ") "
                    Case "Exp"	: Search = " And ((E.NOM Like '%" & Zone & "%') Or (E.EXPORTATEUR Like '%" & Zone & "%')  Or (FS.ID_EXP = '" & Zone & "')) "                    
                    Case "Ref"	: Search = " And (FS.REF_FACTSOUT Like '%" & Zone & "%') "
                End Select
            End If

            Select Case xType
                Case "ListeUp"	: Search = Search & " And (ISNULL(FS.V_RECU,0) = 0) "                 
                Case "Recept"	: Search = Search & " And (ISNULL(FS.V_RECU,0) = 0)  " 
                Case "ListeA"	: Search = Search & " And (FS.ETAT_VALIDE = 'Accord') AND FS.FACTSOUT_ID NOT IN (SELECT FACTSOUT_ID FROM DETAILSTRANSMIS_SOUTIEN) "
                Case "ListeE"	: Search = Search & " And (FS.ETAT_VALIDE = 'Ecart') "
                Case "ListeR"	: Search = Search & " And (FS.ETAT_VALIDE = 'Rejet') "
                Case "Suivi"	: Search = Search & " And (ISNULL(FS.MONT_FACTSOUT,0) > 0) " 
                Case "Traiter"	: Search = Search & " And (ISNULL(FS.V_RECU,0) = 1) And (ISNULL(FS.V_COM,0) = 0)  "
            End Select 

            '### - Création de la Commande à Exécuter
                Set Cmd_Db = Server.CreateObject("AdoDB.Command")
                    Cmd_Db.ActiveConnection = ado_Con
                    Cmd_Db.CommandText = "Ps_FS_Liste"
                    Cmd_Db.CommandType = adCmdStoredProc

            '### - Définition des Paramètres de la Procédure Stockée SQL		
                Set Pm_Option = Cmd_Db.CreateParameter("@Option", adVarChar, adParamInput, 25, xOption)	: Cmd_Db.Parameters.Append Pm_Option				
                Set Pm_Code	= Cmd_Db.CreateParameter("@Code", adVarChar, adParamInput, 3, Code)		: Cmd_Db.Parameters.Append Pm_Code
                Set Pm_Id	= Cmd_Db.CreateParameter("@Id", adInteger, adParamInput, , Id)			    : Cmd_Db.Parameters.Append Pm_Id
                Set Pm_Search = Cmd_Db.CreateParameter("@Search", adVarChar, adParamInput, 1000, Search): Cmd_Db.Parameters.Append Pm_Search
                                            
            '### - Exécution de la Commande SQL
                Set rs_Enr = Cmd_Db.Execute
            
            '### - Convertir les données en JSON 
                Count = 0                         
                Set jsa = jsArray()

                Do While Not (rs_Enr.EOF Or rs_Enr.BOF)
                    Count = Count + 1
                    Set jsa(Null) = jsObject()
                    For Each col In rs_Enr.Fields
                        'If Col.Name = "Url" Then 
                        ''    jsa(Null)(col.Name) = Lien & encode("Id=" & col.Value)
                        'Else
                            jsa(Null)(col.Name) = col.Value
                        'End If
                    Next                
                    rs_Enr.MoveNext
                Loop

                Set jsa(Null) = jsObject()
                jsa(Null)("Count") = Count                     
                Set QueryToJSON = jsa

                Response.Charset = "utf-8"
                QueryToJSON.Flush
%>