    <!--#include file="../include/inc_con.asp" -->
	<!--#include file="../include/fonction.asp" -->
    <!--#include file="../include/encryptions.asp" -->
    <!--#include file="../include/JSON_2.0.4.asp"-->
<%		
    If Session("Login") = False Or IsNull(Session("Login")) = True Then Response.Redirect "../expire.asp" End If		
                        
    '### - Declaration des Variables            
            Dim rs_Enr, Cmd_Db, Err_Msg, Erreur
            Dim Pm_Code, Pm_Option, Pm_Out
            Dim Code, Count, Choix_Enr

            Dim Ref, Id, Rec, Parite, Regime, Prdt, TypeOp, xOption, Diff, Special, TxCaut, Vigueur, StrTaxe, StrTaux
            Dim Pm_Ref, Pm_Id, Pm_Rec, Pm_Parite, Pm_Regime, Pm_Prdt, Pm_Trans, Pm_Diff, Pm_Spec, Pm_Tx, Pm_Vig, Pm_Lib, Pm_Taux



    '### - Récupération des Variables Session Utilisateur
            Code  = Session("Code")
            Choix_Enr = Request("Choix_Enr")
            Erreur = 0

'################################
	If Choix_Enr = "1" Then	' ###  => Choix Effectué - Validation annulation
'################################

    '### - Declaration des Variables 

        Err_Msg = ""
        Erreur = 0

        Id = Request("Id") : xOption = "Modifier"
        If Id = "" Then 
            Id = 0 : xOption = "Valider"
        End If
        xOption = "Valider"
        Prdt = Request("Prdt")        
        Rec = Request("Rclt")
        Diff = Request("Diff")
        Regime = Request("Regime")
        Parite = Request("Parite")
        TypeOp = Request("typeOp")
        Vigueur = Request("Vigueur")
        Special = Request("TypeDiff")

        StrTaxe = Request("StrTaxe")
        StrTaux = Request("StrTaux")

        TxCaut = Replace(Request("TX_CAUT"),".",",")

        If Code = "" Or StrTaux = "" Or StrTaxe = "" Then 
            Err_Msg = "Une Erreur inatendue (0) s'est produite." 
            Err_Msg = Err_Msg & "Veuiller vérifier les informations saisies !" 
            Err_Msg = Err_Msg & "Si l'Erreur persiste, veuillez contacter l'Administrateur !" 
            Erreur = -1
        Else

            If Request("Rclt") = "" Or Request("Rclt") = "0" Then 
                Err_Msg =  Err_Msg & "Récolte non saisie ! "
                Erreur = -1
            End If         
            If Request("Regime") = "" Or Request("Regime") = "0" Then 
                Err_Msg =  Err_Msg & "Régime non saisi ! "
                Erreur = -1
            End If
            If Request("TypeOp") = "" Or Request("TypeOp") = "0" Then 
                Err_Msg =  Err_Msg & "Type de l'exportateur non défini ! "
                Erreur = -1
            End If
            If Request("Parite") = "" Or Request("Parite") = "0" Then 
                Err_Msg =  Err_Msg & "Parité non saisie ! "
                Erreur = -1
            End If
            If Request("Prdt") = "" Or Request("Prdt") = "0" Then 
                Err_Msg =  Err_Msg & "Produit  non saisie ! "
                Erreur = -1
            End If            
            If Request("TX_CAUT") = "" Then 
                Err_Msg =  Err_Msg & "Taux caution non défini ! "
                Erreur = -1
            End If            
                
        End If

        If Erreur = 0  then

            '### - Création de la Commande à Exécuter
                Set Cmd_Db = Server.CreateObject("AdoDB.Command")
                    Cmd_Db.ActiveConnection = ado_Con
                    Cmd_Db.CommandText = "Ps_Doc_Fiscalite_HN"
                    Cmd_Db.CommandType = adCmdStoredProc

            '### - Définition des Paramètres de la Procédure Stockée SQL
                Set Pm_Out	    = Cmd_Db.CreateParameter("@Output", adInteger, adParamOutput)				: Cmd_Db.Parameters.Append Pm_Out
                Set Pm_Option	= Cmd_Db.CreateParameter("@Option", adVarChar, adParamInput, 25, xOption)	: Cmd_Db.Parameters.Append Pm_Option
                Set Pm_Code		= Cmd_Db.CreateParameter("@Code", adVarChar, adParamInput, 3, Code)		    : Cmd_Db.Parameters.Append Pm_Code
                Set Pm_Search   = Cmd_Db.CreateParameter("@Search", adVarChar, adParamInput, 2000, "")      : Cmd_Db.Parameters.Append Pm_Search

                Set Pm_Id		= Cmd_Db.CreateParameter("@Id", adInteger, adParamInput, , Id)		      : Cmd_Db.Parameters.Append Pm_Id
                Set Pm_Prdt     = Cmd_Db.CreateParameter("@Prdt", adInteger, adParamInput, , Prdt)        : Cmd_Db.Parameters.Append Pm_Prdt
                Set Pm_Regime   = Cmd_Db.CreateParameter("@Regime", adInteger, adParamInput, , Regime)    : Cmd_Db.Parameters.Append Pm_Regime
                Set Pm_Trans    = Cmd_Db.CreateParameter("@Trans", adInteger, adParamInput, , TypeOp)     : Cmd_Db.Parameters.Append Pm_Trans
                Set Pm_Parite   = Cmd_Db.CreateParameter("@Parite", adInteger, adParamInput, , Parite)    : Cmd_Db.Parameters.Append Pm_Parite
                Set Pm_Rec      = Cmd_Db.CreateParameter("@Recolte", adInteger, adParamInput, , Rec)      : Cmd_Db.Parameters.Append Pm_Rec                
                Set Pm_Spec     = Cmd_Db.CreateParameter("@Special", adInteger, adParamInput, , Special)     : Cmd_Db.Parameters.Append Pm_Spec
                Set Pm_Tx       = Cmd_Db.CreateParameter("@TxCaut", adDouble, adParamInput, 10, TxCaut)     : Cmd_Db.Parameters.Append Pm_Tx
                Set Pm_Vig      = Cmd_Db.CreateParameter("@Vigueur", adVarChar, adParamInput, 10, Vigueur)     : Cmd_Db.Parameters.Append Pm_Vig

                Set Pm_Lib      = Cmd_Db.CreateParameter("@StrTaxe", adVarChar, adParamInput, 100, StrTaxe)     : Cmd_Db.Parameters.Append Pm_Lib
                Set Pm_Taux     = Cmd_Db.CreateParameter("@StrTaux", adVarChar, adParamInput, 1000, StrTaux)    : Cmd_Db.Parameters.Append Pm_Taux

                Cmd_Db.Execute

                Dim Retour				'### - Vérification du Paramètre de Retour et Affichage du Message de Confirmation
                Set Retour = Pm_Out

                Erreur = 1
                If Retour > 0 Then	 	'### - Aucune Erreur                    
                    Err_Msg = " Nouvelles Redevances enregistrées !"
                Else		   			'### - Erreur Rencontrée
                    Erreur = -1                                  	
                    Err_Msg = Err_Msg & "Une Erreur inatendue N° (" & Retour & ") s'est produite. \n" 
                    Err_Msg = Err_Msg & "Veuiller vérifier les informations saisies !\n" 
                    Err_Msg = Err_Msg & "Si l'Erreur persiste, veuillez contacter l'Administrateur !" 
                End If
                'Err_Msg = StrTaux '& "  -  " & StrTaxe
                'Err_Msg = Prdt & "  Reg: " & Regime & "  Op: " & TypeOp & "  Parite: " & Parite & "  Rec: " & Rec & "  Diff: " & Diff & "  Spe: " & Special & "  Tx: " & TxCaut & "  Vigueur: " & Vigueur

        End If

    '### - Faire un retour en JSON
        Dim jsa, col, QueryToJSON

            Set jsa = jsArray()
            Set jsa(Null) = jsObject()
            jsa(Null)("Erreur") = Erreur
            jsa(Null)("Err_Msg") = Err_Msg
            Set QueryToJSON = jsa     
            
            Response.Charset = "utf-8"
            QueryToJSON.Flush

'################################
    Else
'################################

%>
    
    <form name="Frm" id="FrmDiff" class="form-horizontal" action="#" method="post">
        <div class="row">            
            <div class="col-md-5">
                <div class="form-group">
                    <div class="row">
                        <div class="col-md-6">
                            <label for="Prdt" class="control-label">Produit  </label>                            
                            <select name="Prdt" id="Prdt" class="form-control">
                                <option value="0"> --- </option>
                                <option value="2"> CACAO</option>
                                <option value="1"> CAFE</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label for="TX_CF" class="control-label">Récolte  </label>                            
                            <select name="Rclt" id="Rclt" class="form-control"> </select>
                        </div>
                    </div>                     
                </div>
                <div class="form-group">
                    <div class="row">
                        <div class="col-md-6">
                            <label for="TypeOp" class="control-label"> Type exportateur </label>                            
                            <select name="TypeOp" id="TypeOp" class="form-control">
                                <option value="0"> -- </option>
                                <option value="1"> Exp. Fèves</option>
                                <option value="2"> Usinier</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label for="Regime" class="control-label"> Regime </label>                            
                            <select name="Regime" id="Regime" class="form-control">
                                <option value="0"> -- </option>
                                <option value="1" selected> Normal</option>
                            </select>
                        </div>
                    </div>                     
                </div>

                <div class="form-group">
                    <div class="row">
                        <div class="col-md-6">
                            <label for="Parite" class="control-label">Parité </label>
                            <select name="Parite" id="Parite" class="form-control">
                                <option value="0"> --- </option>
                                <option value="1">1</option>
                                <option value="2">2</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label for="" class="control-label"> Type Redevance </label>                            
                            <select name="TypeDiff" id="TypeDiff" class="form-control">
                                <option value="0"> Normal</option>
                                <option value="1"> Special</option>
                            </select>
                        </div>
                    </div>                     
                </div>
                <div class="form-group">
                    <div class="row">
                        <div class="col-md-6">
                            <label for="TX_CAUT" class="control-label">  TX Caution</label>                            
                            <input type="text" name="TX_CAUT" id="TX_CAUT" maxlength="5" value="2,5" placeholder="Taux de la Caution" class="form-control" />
                        </div>
                        <div class="col-md-6">
                            <label for="Vigueur" class="control-label"> Date Vigueur </label>                            
                            <input type="text" name="Vigueur" id="Vigueur" maxlength="10" value="<%=FormatDateTime(Now(),2)%>" class="form-control" />
                        </div>
                    </div>                    
                </div>
            </div>
            <div class="col-md-7">
                <table class="table table-condensed table-hover">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Redevance</th>
                            <th>Taux</th>
                        </tr>
                    </thead>
                    <tbody id="TabloRedevances"></tbody>
                </table>
              
            </div>            
        </div>
        
        <p class="text-center"> 
            
            <input type="hidden" id="StrTaux" name="StrTaux" value="" />
            <input type="hidden" id="StrTaxe" name="StrTaxe" value="" />
            <input type="hidden" id="Choix_Enr" name="Choix_Enr" value="1" />
            <input type="hidden" id="Camp" name="Camp" value="<%=Session("Camp")%>" />
            <input type="button" value="Enregistrer" id="btn" class="btn btn-primary" />
        </p>                                                 
    </form>

<%
'################################
    End If
'################################   
%>