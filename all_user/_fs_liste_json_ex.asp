	<!--#include file="../include/inc_con.asp" -->
    <!--#include file="../include/aspJSON.asp"-->
    <%
    
    '### - Declaration des Variables
        Dim Code, Erreur, Err_Msg, Count
        Dim Cmd_Db, rs_Enr, Search, Id, xOption, xType
        Dim Pm_Option, Pm_Id, Pm_Code, Pm_Search		
        Dim jsa, col, QueryToJSON	
        
    '### - Récupération des Variables Session Utilisateur
            Code  = Session("Code")
    
    '### - Récupération des Valeurs de parametres
            Search = ""
            Id = 0 'Request("id")
            xType = "" 'Request("xType") 
            xOption = "ListeFs" 'Request("xOption")
                    
            'If Request("User") = "Exp" Then
            ''    Search = Search & " And (FS.ID_EXP = " & Code & ") "
            'End If

            If xType = "ListeA" Then Search = Search & " And (FS.ETAT_VALIDE = 'Accord') "
            If xType = "ListeR" Then Search = Search & " And (FS.ETAT_VALIDE = 'Rejet') "

            Erreur = 0
            Err_Msg = ""

    
        '### - Création de la Commande à Exécuter
            Set Cmd_Db = Server.CreateObject("AdoDB.Command")
                Cmd_Db.ActiveConnection = ado_Con
                Cmd_Db.CommandText = "Ps_FS_Liste"
                Cmd_Db.CommandType = adCmdStoredProc
    
        '### - Définition des Paramètres de la Procédure Stockée SQL		
            Set Pm_Option = Cmd_Db.CreateParameter("@Option", adVarChar, adParamInput, 25, xOption)	: Cmd_Db.Parameters.Append Pm_Option				
            Set Pm_Code	= Cmd_Db.CreateParameter("@Code", adVarChar, adParamInput, 3, Code)			: Cmd_Db.Parameters.Append Pm_Code
            Set Pm_Id	= Cmd_Db.CreateParameter("@Id", adInteger, adParamInput, , Id)			    : Cmd_Db.Parameters.Append Pm_Id
            Set Pm_Search = Cmd_Db.CreateParameter("@Code", adVarChar, adParamInput, 2000, Search): Cmd_Db.Parameters.Append Pm_Search
                                        
        '### - Exécution de la Commande SQL
            Set rs_Enr = Cmd_Db.Execute
        
        '### - Convertir les données en JSON 
            Count = 0
            

            'While Not rs_Enr.Eof
					
                'Count = Count + 1
                                               
                'item.add "Cpte", Count
                'item.add "ID", rs_Fo1("FACTSOUT_ID")
                'item.add "REF", rs_Fo1("REF_FACTSOUT")
                'item.add "NUM", rs_Fo1("NUM_FACTSOUT")
                'item.add "DT", rs_Fo1("DATE_FACTSOUT")
                'item.add "QTE", rs_Fo1("VOL_FACTSOUT")
                'item.add "MT", rs_Fo1("MONT_FACTSOUT")
                'item.add "NOM", rs_Fo1("NOM")
				
				'rs_Enr.MoveNext
						
            'Wend                                    

            'Response.Clear
            'Response.ContentType = "application/json"
            Response.Write oJSON.JSONoutput()
            

    %>