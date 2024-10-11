	<!--#include file="../include/inc_con.asp" -->
	<!--#include file="../include/fonction.asp" -->
	<!--#include file="../include/encryption.asp" -->
	<!--#include file="../include/JSON_2.0.4.asp"-->
	
<%		
	If Session("Login") = False Or IsNull(Session("Login")) = True Then Response.Redirect "../_expire.asp" End If		
								
	'### - Declaration des Variables
		Dim Count, Err_Msg, Erreur
		Dim Cmd_Db, rs_Enr
		Dim Pm_Out, Pm_Code, Pm_Prdt, Pm_Num, Pm_Pro, Pm_Type, Pm_Fo1
		Dim Proper, Num, Prdt, Fo1, Code, xOption
		Dim jsa, col, QueryToJSON

	'### - Recuperation des Variables Session Utilisateur
		Code  = Session("Code")

	'### - Recuperation des Valeurs de la Facture Selectionnee			
		Num = Request("Num")
		Fo1 = Request("Fo1")
		Code = Request("Exp")
		Prdt = Request("Prdt")
		Proper = Request("Proper")
		xOption = Request("xOption")

	'### - Creation de la Commande à Executer
		Set Cmd_Db = Server.CreateObject("AdoDB.Command")
			Cmd_Db.ActiveConnection = ado_Con
			Cmd_Db.CommandText = "Ps_Reajusts_Etats_Cplt_New"
			Cmd_Db.CommandType = adCmdStoredProc

	'### - Definition des Parametres de la Procedure Stockee SQL			
			Set Pm_Type		= Cmd_Db.CreateParameter("@Option", adVarChar, adParamInput, 25, xOption)	: Cmd_Db.Parameters.Append Pm_Type
			Set Pm_Pro		= Cmd_Db.CreateParameter("@Proper", adInteger, adParamInput, , Proper)	: Cmd_Db.Parameters.Append Pm_Pro
			Set Pm_Code		= Cmd_Db.CreateParameter("@Exp", adVarChar, adParamInput, 3, Code)	: Cmd_Db.Parameters.Append Pm_Code
			Set Pm_Fo1		= Cmd_Db.CreateParameter("@Fo1", adInteger, adParamInput, , Fo1)	: Cmd_Db.Parameters.Append Pm_Fo1
			Set Pm_Num		= Cmd_Db.CreateParameter("@Num", adInteger, adParamInput, , Num)	: Cmd_Db.Parameters.Append Pm_Num
			Set Pm_Prdt		= Cmd_Db.CreateParameter("@Prdt", adInteger, adParamInput, , Prdt)	: Cmd_Db.Parameters.Append Pm_Prdt

	'### - Exécution de la Commande SQL
            Set rs_Enr = Cmd_Db.Execute
        
    '### - Convertir les données en JSON 
            Count = 0                         
            Set jsa = jsArray()

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

            Response.Charset = "utf-8"
            QueryToJSON.Flush				

'### - Fermeture des Objets de Connexion
		Set Cmd_Db  = Nothing


%>