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
                Search = Search & " And (D.RCLT_ID = " & Request("Recolte") & ") "
            End If
            If Request("Rclt") <> "" And Request("Rclt") <> "0" Then
                Search = Search & " And (D.RCLT_ID = " & Request("Rclt") & ") "
            End If
            If Request("Prdt") <> "" And Request("Prdt") <> "0" Then
                Search = Search & " And (D.PRDT_ID = " & Request("Prdt") & ") "
            End If
            If Request("Regime") <> "" And Request("Regime") <> "0" Then
                Search = Search & " And (D.REGIME_ID = " & Request("Regime") & ") "
            End If
            If Request("TypeOp") <> "" And Request("TypeOp") <> "0" Then
                Search = Search & " And (D.TRANS_ID = " & Request("TypeOp") & ") "
            End If
            If Request("Parite") <> "" And Request("Parite") <> "0" Then
                Search = Search & " And (D.PARITE = " & Request("Parite") & ") "
            End If
            If Request("Per") <> "" And Request("Per") <> "0" Then
                Search = Search & " And (D.PER_ID = " & Request("Per") & ") "
            End If

            '### - Création de la Commande à Exécuter
                Set Cmd_Db = Server.CreateObject("AdoDB.Command")
                    Cmd_Db.ActiveConnection = ado_Con
                    Cmd_Db.CommandText = "Ps_Doc_Differentiel"
                    Cmd_Db.CommandType = adCmdStoredProc

            '### - Définition des Paramètres de la Procédure Stockée SQL
                Set Pm_Out = Cmd_Db.CreateParameter("@Output", adInteger, adParamOutput)				    : Cmd_Db.Parameters.Append Pm_Out
                Set Pm_Option = Cmd_Db.CreateParameter("@Option", adVarChar, adParamInput, 25, xOption)	    : Cmd_Db.Parameters.Append Pm_Option
                Set Pm_Code	= Cmd_Db.CreateParameter("@Code", adVarChar, adParamInput, 3, Code)		        : Cmd_Db.Parameters.Append Pm_Code
                Set Pm_Search = Cmd_Db.CreateParameter("@Search", adVarChar, adParamInput, 2500, Search)	: Cmd_Db.Parameters.Append Pm_Search
            
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