<!--#include file="../include/encryptions.asp" -->
<%

Dim Cmd_Db, rs_Enr, Count, Lien
Dim Pm_Option, Pm_Id, Pm_Code, Pm_Search, Pm_Out, Pm_Mt, Pm_Num		
Dim jsa, col, QueryToJSON
Dim Retour, Erreur, Err_Msg 
' & encode("Id=" & rs_Cdc("ID")) & """>Traiter</a>"'
Class FSoutien
        
        Private Id
        Private Mt
        Private Num
        Private Code
        Private Search
        Private xOption

        Public Property Let GetId(wId)
            Id = wId
        End Property

        Public Property Let GetMt(wMt)
            Mt = wMt
        End Property

        Public Property Let GetNum(wNum)
            Num = wNum
        End Property

        Public Property Let GetSearch(wSearch)
            Search = wSearch
        End Property

        Public Property Let GetOption(wOption)
            xOption = wOption
        End Property
        
        Public Sub Liste(ByRef ado_Con)

            Lien = ""

            Select Case xType
                Case "Suivi"	: Search = Search & " And (ISNULL(FS.MONT_FACTSOUT,0) > 0) " 
                Case "Recept"	: Search = Search & " And (ISNULL(FS.V_RECU,0) = 0)  " 
                Case "ListeA"	: Search = Search = Search & " And (FS.ETAT_VALIDE = 'Accord') " : Lien = ""
                Case "ListeR"	: Search = Search = Search & " And (FS.ETAT_VALIDE = 'Rejet') " : Lien = ""
                Case "Liste"	: Search = Search & " And (ISNULL(FS.V_RECU,0) = 1) And (ISNULL(FS.V_COM,0) = 0)  " : Lien = "fact_soutien_vdoc.asp?"
            End Select 

            '### - Création de la Commande à Exécuter
                Set Cmd_Db = Server.CreateObject("AdoDB.Command")
                    Cmd_Db.ActiveConnection = ado_Con
                    Cmd_Db.CommandText = "Ps_FS_Liste"
                    Cmd_Db.CommandType = adCmdStoredProc

            '### - Définition des Paramètres de la Procédure Stockée SQL		
                Set Pm_Option = Cmd_Db.CreateParameter("@Option", adVarChar, adParamInput, 25, xOption)	: Cmd_Db.Parameters.Append Pm_Option				
                Set Pm_Code	= Cmd_Db.CreateParameter("@Code", adVarChar, adParamInput, 3, "000")		: Cmd_Db.Parameters.Append Pm_Code
                Set Pm_Id	= Cmd_Db.CreateParameter("@Id", adInteger, adParamInput, , Id)			    : Cmd_Db.Parameters.Append Pm_Id
                Set Pm_Search = Cmd_Db.CreateParameter("@Search", adVarChar, adParamInput, 1000, Search): Cmd_Db.Parameters.Append Pm_Search
                'Set Pm_Num = Cmd_Db.CreateParameter("@Num", adVarChar, adParamInput, 50, Num): Cmd_Db.Parameters.Append Pm_Num
                                            
            '### - Exécution de la Commande SQL
                Set rs_Enr = Cmd_Db.Execute
            
            '### - Convertir les données en JSON 
                Count = 0                         
                Set jsa = jsArray()

                Do While Not (rs_Enr.EOF Or rs_Enr.BOF)
                    Count = Count + 1
                    Set jsa(Null) = jsObject()
                    For Each col In rs_Enr.Fields
                        If Col.Name = "Url" Then 
                            jsa(Null)(col.Name) = Lien & encode("Id=" & col.Value)
                        Else
                            jsa(Null)(col.Name) = col.Value
                        End If
                    Next                
                    rs_Enr.MoveNext
                Loop

                Set jsa(Null) = jsObject()
                jsa(Null)("Count") = Count                     
                Set QueryToJSON = jsa

                Response.Charset = "utf-8"
                QueryToJSON.Flush

        End Sub

        Public Sub UpMt(ByRef ado_Con)			
        Code = Session("Code")
            '### - Création de la Commande à Exécuter
                Set Cmd_Db = Server.CreateObject("AdoDB.Command")
                    Cmd_Db.ActiveConnection = ado_Con
                    Cmd_Db.CommandText = "Ps_FS_Up"
                    Cmd_Db.CommandType = adCmdStoredProc

            '### - Définition des Paramètres de la Procédure Stockée SQL		
                Set Pm_Out	= Cmd_Db.CreateParameter("@Output", adInteger, adParamOutput)				: Cmd_Db.Parameters.Append Pm_Out
                Set Pm_Option = Cmd_Db.CreateParameter("@Option", adVarChar, adParamInput, 25, xOption)	: Cmd_Db.Parameters.Append Pm_Option				
                Set Pm_Code	= Cmd_Db.CreateParameter("@Code", adVarChar, adParamInput, 3, Code)			: Cmd_Db.Parameters.Append Pm_Code                
                Set Pm_Id	= Cmd_Db.CreateParameter("@Id", adInteger, adParamInput, , Id)			    : Cmd_Db.Parameters.Append Pm_Id
                Set Pm_Mt	= Cmd_Db.CreateParameter("@Mt", adInteger, adParamInput, , Mt)			    : Cmd_Db.Parameters.Append Pm_Mt
                Set Pm_Search = Cmd_Db.CreateParameter("@Search", adVarChar, adParamInput, 1000, ""): Cmd_Db.Parameters.Append Pm_Search
                Set Pm_Num = Cmd_Db.CreateParameter("@Num", adVarChar, adParamInput, 50, Num): Cmd_Db.Parameters.Append Pm_Num
                                        
            '### - Exécution de la Commande SQL
                Cmd_Db.Execute
            
            '### - Convertir les données en JSON 
                
                Set Retour = Pm_Out
                Erreur = Retour
                Err_Msg  = " Correction effectuee !"
                If Erreur < 0 Then Err_Msg = "Erreur! Saisie non validee suite à une erreur systeme ! "

                Set jsa = jsArray()
                Set jsa(Null) = jsObject()
                jsa(Null)("Erreur") = Erreur
                jsa(Null)("Err_Msg") = Err_Msg
                Set QueryToJSON = jsa     
                        
                Response.Charset = "utf-8"
                QueryToJSON.Flush

        End Sub


End Class

%>