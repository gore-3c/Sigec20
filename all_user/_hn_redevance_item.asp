    <!--#include file="../include/inc_con.asp" -->
	<!--#include file="../include/fonction.asp" -->
    <!--#include file="../include/encryptions.asp" -->
    <!--#include file="../include/JSON_2.0.4.asp"-->
    <%	

    If Session("Login") = False Or IsNull(Session("Login")) = True Then Response.Redirect "../_expire.asp" End If	
    
    '### - Declaration des Variables

            Dim Pm_Out, Pm_Option, Pm_Code 
            Dim Count, Nb, xOption
            Dim Cmd_Db, rs_Enr, Code
            Dim jsa, col, QueryToJSON

            Code = Session("Code")

            Search = ""
            xOption = Request("xOption")

            If Request("Recolte") <> "" And Request("Recolte") <> "0" Then
                Search = Search & " And (R.RCLT_ID = " & Request("Recolte") & ") "
            End If
            If Request("Produit") <> "" And Request("Produit") <> "0" Then
                Search = Search & " And (R.PRDT_ID = " & Request("Produit") & ") "
            End If
            If Request("Parite") <> "" And Request("Parite") <> "0" Then
                Search = Search & " And (R.PARITE = " & Request("Parite") & ") "
            End If

            '### - Création de la Commande à Exécuter
                Set Cmd_Db = Server.CreateObject("AdoDB.Command")
                    Cmd_Db.ActiveConnection = ado_Con
                    Cmd_Db.CommandText = "Ps_Doc_Fiscalite_HN"
                    Cmd_Db.CommandType = adCmdStoredProc

            '### - Définition des Paramètres de la Procédure Stockée SQL
                Set Pm_Out = Cmd_Db.CreateParameter("@Output", adInteger, adParamOutput)				: Cmd_Db.Parameters.Append Pm_Out
                Set Pm_Option = Cmd_Db.CreateParameter("@Option", adVarChar, adParamInput, 25, xOption)	: Cmd_Db.Parameters.Append Pm_Option				
                Set Pm_Code	= Cmd_Db.CreateParameter("@Code", adVarChar, adParamInput, 3, Code)		    : Cmd_Db.Parameters.Append Pm_Code
                Set Pm_Search = Cmd_Db.CreateParameter("@Search", adVarChar, adParamInput, 2500, Search)		: Cmd_Db.Parameters.Append Pm_Search
            
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
%>