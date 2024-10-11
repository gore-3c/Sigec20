

<!--#include file="../include/inc_con.asp" -->
<!--#include file="../include/fonction.asp" -->
<!--#include file="../include/encryptions.asp" -->
<!--#include file="../include/JSON_2.0.4.asp"-->

<%	

    If Session("Login") = False Or IsNull(Session("Login")) = True Then Response.Redirect "../_expire.asp" End If	
    
    '### - Declaration des Variables
            Dim Code
            Dim Pm_Code, Pm_Option, Pm_Id, Pm_Out, Pm_Dt, Pm_Num, Pm_Type
            Dim Count, Nb, Dt, Id, Num, xOption
            Dim xMt, XDt, xChq, wFo1, wQte, wDt, Fo1, Strct, xType
            Dim Cmd_Db, rs_Enr, Err_Msg, Erreur
            Dim jsa, col, QueryToJSON

            Code = Session("Code")

	If Request("xChoix") = "0" Then

			Search = ""
            Strct = Request("Id")
            'Id = Request("Id") 
            Dt = Request("Dt") 
            Num  = Request("Num") 
            'xType  = Request("Cheq") 
                        
            '### - Création de la Commande à Exécuter
                Set Cmd_Db = Server.CreateObject("AdoDB.Command")
                    Cmd_Db.ActiveConnection = ado_Con
                    Cmd_Db.CommandText = "Ps_Admin_transfert_Vers_SYGESAP"
                    Cmd_Db.CommandType = adCmdStoredProc

            '### - Définition des Paramètres de la Procédure Stockée SQL		
				Set Pm_Out		= Cmd_Db.CreateParameter("@Output", adInteger, adParamOutput)			: Cmd_Db.Parameters.Append Pm_Out
                Set Pm_Option = Cmd_Db.CreateParameter("@Option", adVarChar, adParamInput, 25, "Select")	: Cmd_Db.Parameters.Append Pm_Option				
                Set Pm_Code	= Cmd_Db.CreateParameter("@Code", adVarChar, adParamInput, 3, Code)		    : Cmd_Db.Parameters.Append Pm_Code
                Set Pm_Id       = Cmd_Db.CreateParameter("@Id", adInteger, adParamInput, , 0)           : Cmd_Db.Parameters.Append Pm_Id
                Set Pm_Type     = Cmd_Db.CreateParameter("@Str_Id", adInteger, adParamInput, , Strct)      : Cmd_Db.Parameters.Append Pm_Type
			    Set Pm_Dt       = Cmd_Db.CreateParameter("@Dt", adVarchar, adParamInput, 10, Dt)          : Cmd_Db.Parameters.Append Pm_Dt
                Set Pm_Num      = Cmd_Db.CreateParameter("@Num", adVarchar, adParamInput, 15, Num)         : Cmd_Db.Parameters.Append Pm_Num
                                            
            '### - Exécution de la Commande SQL
                Set rs_Enr = Cmd_Db.Execute

                Do While Not (rs_Enr.EOF Or rs_Enr.BOF)

                    xMt = Prix(rs_Enr("CH_MTT"))
                    xDt = rs_Enr("CH_DATE")
                    xChq = rs_Enr("CH_REF")
                    wFo1 = rs_Enr("NUM_FRC")
                    wQte = Prix(rs_Enr("POIDS_FO1"))
                    wDt = rs_Enr("DATE_FRC")

                    Fo1 = rs_Enr("FO1_ID")
                    Strct = rs_Enr("STRCT_ID")
                    
                    rs_Enr.MoveNext

                Loop

%>
        <table id="oData" class="table table-striped table-bordered text-nowrap w-100">
            <tr>
                <td>N° FO1</td>
                <td><%=wFo1%></td>
                <td>N° Chèque</td>
                <td><%=xChq%></td>
            </tr>
            <tr>
                <td>Date FO1</td>
                <td><%=wDt%></td>
                <td>Date Chèque</td>
                <td><%=xDt%></td>
            </tr>
            <tr>
                <td>Tonnage FO1</td>
                <td><%=wQte%></td>
                <td>Motant Chèque</td>
                <td><%=xMt%></td>
            </tr>
        </table>
        <form id="xFrm" class="form-horizontal" role="form">
            <div class="form-group">
                <input type="hidden" name="Strct" id="Strct" value="<%=Strct%>" />
                <input type="hidden" name="Fo1" id="Fo1" value="<%=Fo1%>" />
            </div>
            <button id="xbtn" type="button" class="btn btn-sm btn-primary">Transférer</button>
        </form>
<%
    End If

    If Request("xChoix") = "1" Then

        '### - Declaration des Variables

            Id = Request("Fo1")
            Strct = Request("Strct") 

        
        If Code = "" Or Strct = "" Or Id = "" Then 
            Err_Msg = "Une Erreur inatendue (0) s'est produite."  
            Err_Msg = Err_Msg & "Veuiller vérifier les informations saisies !" 
            Err_Msg = Err_Msg & "Si l'Erreur persiste, veuillez contacter l'Administrateur !" 
            Erreur = 1
        End If

        If Erreur = 0  then

            '### - Création de la Commande à Exécuter
                Set Cmd_Db = Server.CreateObject("AdoDB.Command")
                    Cmd_Db.ActiveConnection = ado_Con
                    Cmd_Db.CommandText = "Ps_Admin_transfert_Vers_SYGESAP"
                    Cmd_Db.CommandType = adCmdStoredProc

            '### - Définition des Paramètres de la Procédure Stockée SQL
                Set Pm_Out	    = Cmd_Db.CreateParameter("@Output", adInteger, adParamOutput)				: Cmd_Db.Parameters.Append Pm_Out
                Set Pm_Option	= Cmd_Db.CreateParameter("@Option", adVarChar, adParamInput, 15, "Valider")	: Cmd_Db.Parameters.Append Pm_Option
                Set Pm_Code		= Cmd_Db.CreateParameter("@Code", adVarChar, adParamInput, 3, Code)		    : Cmd_Db.Parameters.Append Pm_Code
                Set Pm_Id       = Cmd_Db.CreateParameter("@Id", adInteger, adParamInput, , Id)           : Cmd_Db.Parameters.Append Pm_Id
                Set Pm_Type     = Cmd_Db.CreateParameter("@Str_Id", adInteger, adParamInput, , Strct)      : Cmd_Db.Parameters.Append Pm_Type
			    Set Pm_Dt       = Cmd_Db.CreateParameter("@Date", adVarchar, adParamInput, 10, "")          : Cmd_Db.Parameters.Append Pm_Dt
                Set Pm_Num      = Cmd_Db.CreateParameter("@Num", adVarchar, adParamInput, 15, "")         : Cmd_Db.Parameters.Append Pm_Num
            
                Cmd_Db.Execute
                Dim Retour				'### - Vérification du Paramètre de Retour et Affichage du Message de Confirmation
                Set Retour = Pm_Out

                Erreur = 1
                If Retour > 0 Then	 	'### - Aucune Erreur
                    Err_Msg = " Cheque transféré !"
                Else		   			'### - Erreur Rencontrée
                    Erreur = Retour                                 	
                    Err_Msg = Err_Msg & "Une Erreur inatendue N° (" & Retour & ") s'est produite. \n"
                    Err_Msg = Err_Msg & "Veuiller vérifier les informations saisies !\n"
                    Err_Msg = Err_Msg & "Si l'Erreur persiste, veuillez contacter l'Administrateur !"
                End If

        End If

    '### - Faire un retour en JSON

        Set jsa = jsArray()
        Set jsa(Null) = jsObject()
        jsa(Null)("Erreur") = Erreur
        jsa(Null)("Err_Msg") = Err_Msg
        Set QueryToJSON = jsa
        
        Response.Charset = "utf-8"
        QueryToJSON.Flush

    End If
%>