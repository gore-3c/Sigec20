	<!--#include file="../include/inc_con.asp" -->
    <!--#include file="../include/JSON_2.0.4.asp"-->
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
            Id = Request("id")
            xType = Request("xType") 
            xOption = Request("xOption")
                    
            'If Request("User") = "Exp" Then
            ''    Search = Search & " And (FS.ID_EXP = " & Code & ") "
            'End If

            If xType = "Up" Then Search = Search & " And (FS.V_RECU = 0) "
            If xType = "ListeA" Then Search = Search & " And (FS.ETAT_VALIDE = 'Accord') "
            If xType = "ListeR" Then Search = Search & " And (FS.ETAT_VALIDE = 'Rejet') "

            Erreur = 0
            Err_Msg = ""
    
    If Erreur = 0 Then
    
        '### - Création de la Commande à Exécuter
            Set Cmd_Db = Server.CreateObject("AdoDB.Command")
                Cmd_Db.ActiveConnection = ado_Con
                Cmd_Db.CommandText = "Ps_FS_Liste"
                Cmd_Db.CommandType = adCmdStoredProc
    
        '### - Définition des Paramètres de la Procédure Stockée SQL		
            Set Pm_Option = Cmd_Db.CreateParameter("@Option", adVarChar, adParamInput, 25, xOption)	: Cmd_Db.Parameters.Append Pm_Option				
            Set Pm_Code	= Cmd_Db.CreateParameter("@Code", adVarChar, adParamInput, 3, Code)			: Cmd_Db.Parameters.Append Pm_Code
            Set Pm_Id	= Cmd_Db.CreateParameter("@Id", adInteger, adParamInput, , Id)			    : Cmd_Db.Parameters.Append Pm_Id
            Set Pm_Search = Cmd_Db.CreateParameter("@Search", adVarChar, adParamInput, 1000, Search): Cmd_Db.Parameters.Append Pm_Search
                                        
        '### - Exécution de la Commande SQL
            Set rs_Enr = Cmd_Db.Execute
        
        '### - Convertir les données en JSON 
            Count = 0                         
            Set jsa = jsArray()
    
            'Set jsa(Null) = jsObject()
            'jsa(Null)("Erreur") = "0"  
            'jsa(Null)("Err_Msg") = ""          
            'Set QueryToJSON = jsa
    
            Do While Not (rs_Enr.EOF Or rs_Enr.BOF)
                Count = Count + 1
                Set jsa(Null) = jsObject()
                For Each col In rs_Enr.Fields
                    jsa(Null)(col.Name) = col.Value
                Next                
                rs_Enr.MoveNext
            Loop
    
            Set jsa(Null) = jsObject()
            jsa(Null)("Count") = Count                     
            Set QueryToJSON = jsa
                            
    Else 
            'Set jsa = jsArray()
            'Set jsa(Null) = jsObject()
            'jsa(Null)("Erreur") = Erreur
            'jsa(Null)("Err_Msg") = Err_Msg
            'Set QueryToJSON = jsa     
    End If
    
            Response.Charset = "utf-8"
            QueryToJSON.Flush			        
    %>