    <!--#include file="../include/inc_con.asp" -->
	<!--#include file="../include/fonction.asp" -->
    <!--#include file="../include/encryptions.asp" -->
    <!--#include file="../include/JSON_2.0.4.asp"-->
<%		
    If Session("Login") = False Or IsNull(Session("Login")) = True Then Response.Redirect "../expire.asp" End If		
                        
    '### - Declaration des Variables            
            Dim rs_Enr, Cmd_Db, Err_Msg, Erreur
            Dim Pm_Code, Pm_Option, Pm_Out, Pm_Id
            Dim Code, Count, Id


            Dim Parite, Campagne, Recolte, TypeOp, CafRef, Vigueur, Periode, Produit, trTaxes



    '### - Récupération des Variables Session Utilisateur
        Code  = Session("Code")

        Err_Msg = ""
        Erreur = 0

        Id = Request("Id")
        If Id = "" Then Id = 216

        If Code = "" Or Id = ""  Then 
            Err_Msg = "Une Erreur inatendue (0) s'est produite." 
            Err_Msg = Err_Msg & "Veuiller vérifier les informations saisies !" 
            Err_Msg = Err_Msg & "Si l'Erreur persiste, veuillez contacter l'Administrateur !"
            Erreur = 1
        End If

        If Erreur = 0  then

            '### - Création de la Commande à Exécuter
                Set Cmd_Db = Server.CreateObject("AdoDB.Command")
                    Cmd_Db.ActiveConnection = ado_Con
                    Cmd_Db.CommandText = "Ps_Doc_Fiscalite"
                    Cmd_Db.CommandType = adCmdStoredProc

            '### - Définition des Paramètres de la Procédure Stockée SQL
                Set Pm_Out	    = Cmd_Db.CreateParameter("@Output", adInteger, adParamOutput)				: Cmd_Db.Parameters.Append Pm_Out
                Set Pm_Option	= Cmd_Db.CreateParameter("@Option", adVarChar, adParamInput, 25, "Affiche")	: Cmd_Db.Parameters.Append Pm_Option
                Set Pm_Code		= Cmd_Db.CreateParameter("@Code", adVarChar, adParamInput, 3, Code)		    : Cmd_Db.Parameters.Append Pm_Code
                Set Pm_Search   = Cmd_Db.CreateParameter("@Search", adVarChar, adParamInput, 2000, "")      : Cmd_Db.Parameters.Append Pm_Search

                Set Pm_Id		= Cmd_Db.CreateParameter("@Id", adInteger, adParamInput, , Id)		      : Cmd_Db.Parameters.Append Pm_Id

                Set rs_Enr = Cmd_Db.Execute

                trTaxes = "" : Count = 1

                While Not rs_Enr.Eof

                    Parite = rs_Enr("PARITE") 
                    Campagne = rs_Enr("CAMPAGNE") 
                    Recolte = rs_Enr("RECOLTE") 
                    TypeOp = rs_Enr("TRANS_LIB") 
                    CafRef = rs_Enr("CAF_REF") 
                    Vigueur = rs_Enr("Vigueur") 
                    Periode = rs_Enr("PERIODE") 
                    Produit = rs_Enr("PRODUIT") 

                    trTaxes = trTaxes & "<tr><td>"  &  Count & "</td><td>"  &  rs_Enr("STRCT") & "</td><td>"  &  rs_Enr("TAUX") & "</td></tr>"
                    Count = Count + 1
                    rs_Enr.MoveNext
                Wend

        End If

%>    
    <h3 class="text-center">PARAMETRES DE LA FISCALITE</h3>
    <table class="table table-hover table-bordered">
        <tr>
            <th>CAMPAGNE</th><td><%=Campagne%></td>
            <th>RECOLTE</th><td><%=Recolte%>/<%=Parite%></td>
        </tr>
        <tr>
            <th>PERIODE</th><td><%=Periode%></td>
            <th>PRIX CAF REF</th><td><%=CafRef%></td>
        </tr>
        <tr>
            <th>TYPE EXPORATEUR</th><td><%=TypeOp%></td>
            <th>PRODUIT</th><td><%=Produit%></td>
        </tr>
    </table>
    <hr>
    <table class="table table-condensed table-striped">
        <thead>
            <tr>
                <th>#</th>
                <th>Redevance</th>
                <th>Taux</th>
            </tr>
        </thead>
        <tbody id=""><%=trTaxes%></tbody>
    </table>
