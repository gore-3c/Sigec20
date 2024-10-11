	<!--#include file="../include/inc_con.asp" -->
    <!--#include file="../include/JSON_2.0.4.asp"-->

<%
    
'### - Declaration des Variables
	Dim Code, Erreur, Err_Msg, Count
	Dim Cmd_Db, rs_Enr, Search, Id, xId, Prdt
	Dim Pm_Option, Pm_Id, Pm_Code, Pm_Search, Pm_xId, Pm_Prdt 		
	Dim jsa, col, QueryToJSON, Ps_Name, xOption, xType

'### - Récupération des Valeurs de parametres
        Id = Request("Id")        
        xId = Request("xId")
        Prdt = Request("Prdt")
        xOption = Request("xOption") 

        If Id = "" Then Id = 0
        If xId = "" Then xId = 0
        If Prdt = "" Then Prdt = 0

        Erreur = 0
        Err_Msg = ""
        Search = ""

If Erreur = 0 Then

	'### - Création de la Commande à Exécuter
		Set Cmd_Db = Server.CreateObject("AdoDB.Command")
			Cmd_Db.ActiveConnection = ado_Con
			Cmd_Db.CommandText = "Les_Parametres"
			Cmd_Db.CommandType = adCmdStoredProc

	'### - Définition des Paramètres de la Procédure Stockée SQL		
		Set Pm_Option = Cmd_Db.CreateParameter("@Option", adVarChar, adParamInput, 25, xOption)	: Cmd_Db.Parameters.Append Pm_Option
        Set Pm_Id   = Cmd_Db.CreateParameter("@Id", adInteger, adParamInput, , Id)              : Cmd_Db.Parameters.Append Pm_Id
        Set Pm_xId   = Cmd_Db.CreateParameter("@xId", adInteger, adParamInput, , xId)            : Cmd_Db.Parameters.Append Pm_xId
        Set Pm_Prdt   = Cmd_Db.CreateParameter("@Prdt", adInteger, adParamInput, , Prdt)           : Cmd_Db.Parameters.Append Pm_Prdt				
		Set Pm_Search	= Cmd_Db.CreateParameter("@Search", adVarChar, adParamInput, 1000, Search)	: Cmd_Db.Parameters.Append Pm_Search
                
            					
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

        'Set jsa(Null) = jsObject()
        'jsa(Null)("Count") = Count                       
        Set QueryToJSON = jsa
                        
Else 
        Set jsa = jsArray()
        Set jsa(Null) = jsObject()
        jsa(Null)("Erreur") = Erreur
        jsa(Null)("Err_Msg") = Err_Msg
        Set QueryToJSON = jsa     
End If

        Response.Charset = "utf-8"
        QueryToJSON.Flush			
        

%>