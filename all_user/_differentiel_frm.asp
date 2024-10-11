    <!--#include file="../include/inc_con.asp" -->
	<!--#include file="../include/fonction.asp" -->
    <!--#include file="../include/encryptions.asp" -->
    <!--#include file="../include/JSON_2.0.4.asp"-->
<%		
    If Session("Login") = False Or IsNull(Session("Login")) = True Then Response.Redirect "../expire.asp" End If		
                        
    '### - Declaration des Variables            
            Dim rs_Cdc, Cmd_Db, Err_Msg, Erreur
            Dim Pm_Code, Pm_Option, Pm_Out

            Dim Code, Count, Choix_Enr
            Dim CAF_REF, FIXE_CAF, TX_CAF, TX_VAR, CAF_FOB, FIXE_CF, TX_CF, ASS
            Dim Pm_CAF_REF, Pm_FIXE_CAF, Pm_TX_CAF, Pm_TX_VAR, Pm_CAF_FOB, Pm_FIXE_CF, Pm_TX_CF, Pm_ASS

            Dim Ref, Id, Rec, Camp, Per, Parite, Regime, Prdt, TypeOp, xOption
            Dim Pm_Ref, Pm_Id, Pm_Rec, Pm_Camp, Pm_Per, Pm_Parite, Pm_Regime, Pm_Prdt, Pm_Trans

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

        ASS = Replace(Request("ASS"),".",",")
        CAF_REF = Replace(Request("CAF_REF"),".",",")
        FIXE_CAF = Replace(Request("FIXE_CAF"),".",",")
        CAF_FOB = Replace(Request("CAF_FOB"),".",",")
        FIXE_CF = Replace(Request("FIXE_CF"),".",",")
        
        TX_CAF = Replace(Request("TX_CAF"),".",",")
        TX_CF = Replace(Request("TX_CF"),".",",")
        TX_VAR = Replace(Request("TX_VAR"),".",",")
        
        Per = Request("Per")
        Prdt = Request("Prdt")
        Camp = Request("Camp")
        Rec = Request("Rclt")
        Regime = Request("Regime")
        Parite = Request("Parite")
        TypeOp = Request("typeOp")

        If Code = "" Then 
            Err_Msg = "Une Erreur inatendue (0) s'est produite." 
            Err_Msg = Err_Msg & "Veuiller vérifier les informations saisies !" 
            Err_Msg = Err_Msg & "Si l'Erreur persiste, veuillez contacter l'Administrateur !" 
            Erreur = -1
        Else
            If Request("Rclt") = "" Then 
                Err_Msg =  Err_Msg & "Récolte non saisie!"
                Erreur = 1
            End If

            If Request("Per") = "" Or Request("Per") = "0" Then 
                Err_Msg =  Err_Msg & "Période d'embarquement non saisie ! "
                Erreur = -1
            End If            
            If Request("Camp") = "" Or Request("Camp") = "0" Then 
                Err_Msg =  Err_Msg & "Campagne non saisie ! "
                Erreur = -1
            End If   
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
            
            If Request("CAF_REF") = "" Then 
                Err_Msg =  Err_Msg & "CAF_REF non défini ! "
                Erreur = -1
            End If
            If Request("FIXE_CAF") = "" Then 
                Err_Msg =  Err_Msg & "FIXE_CAF non saisi ! "
                Erreur = -1
            End If
            If Request("CAF_FOB") = "" Then 
                Err_Msg =  Err_Msg & "CAF_FOB non saisi ! "
                Erreur = -1
            End If
            If Request("FIXE_CF") = "" Then 
                Err_Msg =  Err_Msg & "FIXE_CF non saisi ! "
                Erreur = -1
            End If
            If Request("ASS") = "" Then 
                Err_Msg =  Err_Msg & "Montant assurance non saisi ! "
                Erreur = -1
            End If
            If Request("TX_CAF") = "" Then 
                Err_Msg =  Err_Msg & "TX_CAF non saisi ! "
                Erreur = -1
            End If
            If Request("TX_VAR") = "" Then 
                Err_Msg =  Err_Msg & "TX_VAR non saisi ! "
                Erreur = -1
            End If
            If Request("TX_CF") = "" Then 
                Err_Msg =  Err_Msg & "TX_CF non saisi ! "
                Erreur = -1
            End If
                
        End If

        If Erreur = 0  then

            '### - Création de la Commande à Exécuter
                Set Cmd_Db = Server.CreateObject("AdoDB.Command")
                    Cmd_Db.ActiveConnection = ado_Con
                    Cmd_Db.CommandText = "Ps_Doc_Differentiel"
                    Cmd_Db.CommandType = adCmdStoredProc

            '### - Définition des Paramètres de la Procédure Stockée SQL
                Set Pm_Out	    = Cmd_Db.CreateParameter("@Output", adInteger, adParamOutput)				: Cmd_Db.Parameters.Append Pm_Out
                Set Pm_Option	= Cmd_Db.CreateParameter("@Option", adVarChar, adParamInput, 15, xOption)	: Cmd_Db.Parameters.Append Pm_Option
                Set Pm_Code		= Cmd_Db.CreateParameter("@Code", adVarChar, adParamInput, 3, Code)		    : Cmd_Db.Parameters.Append Pm_Code
                Set Pm_Search   = Cmd_Db.CreateParameter("@Search", adVarChar, adParamInput, 2000, "")      : Cmd_Db.Parameters.Append Pm_Search

                Set Pm_Id		= Cmd_Db.CreateParameter("@Id", adInteger, adParamInput, , Id)		      : Cmd_Db.Parameters.Append Pm_Id
                Set Pm_Camp     = Cmd_Db.CreateParameter("@Camp", adInteger, adParamInput, , Camp)        : Cmd_Db.Parameters.Append Pm_Camp
                Set Pm_Rec      = Cmd_Db.CreateParameter("@Recolte", adInteger, adParamInput, , Rec)      : Cmd_Db.Parameters.Append Pm_Rec
                Set Pm_Prdt     = Cmd_Db.CreateParameter("@Prdt", adInteger, adParamInput, , Prdt)        : Cmd_Db.Parameters.Append Pm_Prdt
                Set Pm_Per      = Cmd_Db.CreateParameter("@Periode", adInteger, adParamInput, , Per)      : Cmd_Db.Parameters.Append Pm_Per
                Set Pm_Regime   = Cmd_Db.CreateParameter("@Regime", adInteger, adParamInput, , Regime)    : Cmd_Db.Parameters.Append Pm_Regime
                Set Pm_Trans    = Cmd_Db.CreateParameter("@Trans", adInteger, adParamInput, , TypeOp)     : Cmd_Db.Parameters.Append Pm_Trans
                Set Pm_Parite   = Cmd_Db.CreateParameter("@Parite", adInteger, adParamInput, , Parite)    : Cmd_Db.Parameters.Append Pm_Parite
                Set Pm_Ref      = Cmd_Db.CreateParameter("@Ref", adVarChar, adParamInput, 2000, Ref)      : Cmd_Db.Parameters.Append Pm_Ref

                Set Pm_ASS      = Cmd_Db.CreateParameter("@Assurance", adInteger, adParamInput, , ASS)      : Cmd_Db.Parameters.Append Pm_ASS
                Set Pm_CAF_FOB	= Cmd_Db.CreateParameter("@Caf_Fob", adDouble, adParamInput, , CAF_FOB)	: Cmd_Db.Parameters.Append Pm_CAF_FOB
                Set Pm_CAF_REF	= Cmd_Db.CreateParameter("@Caf_Ref", adDouble, adParamInput, , CAF_REF)   : Cmd_Db.Parameters.Append Pm_CAF_REF
                Set Pm_FIXE_CAF	= Cmd_Db.CreateParameter("@Frais_Caf", adDouble, adParamInput, , FIXE_CAF): Cmd_Db.Parameters.Append Pm_FIXE_CAF
                Set Pm_FIXE_CF	= Cmd_Db.CreateParameter("@Frais_CF", adDouble, adParamInput, , FIXE_CF)	: Cmd_Db.Parameters.Append Pm_FIXE_CF

                Set Pm_TX_VAR	= Cmd_Db.CreateParameter("@Tx_Var", adDouble, adParamInput, 10, TX_VAR)	    : Cmd_Db.Parameters.Append Pm_TX_VAR
                Set Pm_TX_CF	= Cmd_Db.CreateParameter("@Tx_CF", adDouble, adParamInput, 10, TX_CF)		: Cmd_Db.Parameters.Append Pm_TX_CF
                Set Pm_TX_CAF 	= Cmd_Db.CreateParameter("@Tx_CAF", adDouble, adParamInput, 10, TX_CAF)		: Cmd_Db.Parameters.Append Pm_TX_CAF

                            
                Cmd_Db.Execute
                Dim Retour				'### - Vérification du Paramètre de Retour et Affichage du Message de Confirmation
                Set Retour = Pm_Out

                Erreur = 1
                If Retour > 0 Then	 	'### - Aucune Erreur                    
                    Err_Msg = " Nouveau differentiel créé !"
                Else		   			'### - Erreur Rencontrée
                    Erreur = -1                                  	
                    Err_Msg = Err_Msg & "Une Erreur inatendue N° (" & Retour & ") s'est produite. \n" 
                    Err_Msg = Err_Msg & "Veuiller vérifier les informations saisies !\n" 
                    Err_Msg = Err_Msg & "Si l'Erreur persiste, veuillez contacter l'Administrateur !" 
                End If
                'Err_Msg = " CAF_REF: " & CAF_REF & "  FIXE_CAF: " & FIXE_CAF & "  TX_CAF: " & TX_CAF & "  TX_VAR: " & TX_VAR & "  CAF_FOB: " & CAF_FOB & "  FIXE_CF: " & FIXE_CF & "  TX_CF: " & TX_CF & "  ASS: " & ASS & " Rec: " & Rec & " Camp: " & Camp & " Per: " & Per & " Parite: " & Parite & " Regime: " & Regime & " Prdt: " & Prdt & " TypeOp: " & TypeOp

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
            <div class="col-md-3">  
                <div class="form-group">                                            
                    <select name="Prdt" id="Prdt" class="form-control">
                        <option value="0"> Produit</option>
                        <option value="2"> Cacao</option>
                        <option value="1"> Café</option>
                    </select>
                </div>              
                <div class="form-group">                    
                    <select name="Camp" id="Camp" class="form-control">
                        <option value="<%=Session("Camp")%>"> <%=Session("wCamp")%></option>
                    </select>
                </div>
                <div class="form-group">                    
                    <select name="Per" id="Per" class="form-control">
                        <option value="0"> Période</option>                        
                    </select>
                </div>
                <div class="form-group">                    
                    <select name="Rclt" id="Rclt" class="form-control"> </select>
                </div>
            </div>
            <div class="col-md-3">
                <div class="form-group">                    
                    <select name="TypeOp" id="TypeOp" class="form-control">
                        <option value="0"> Type exportateur </option>
                        <option value="1" selected>Exp. Fèves</option>
                    </select>
                </div>
                <div class="form-group">                    
                    <select name="Regime" id="Regime" class="form-control">
                        <option value="0"> Regime</option>
                        <option value="1" selected> Normal</option>

                    </select>
                </div>
                <div class="form-group">                    
                    <select name="Parite" id="Parite" class="form-control">
                        <option value="0">Parité</option>
                        <option value="1">1</option>
                        <option value="2">2</option>
                    </select>
                </div>
            </div>
            <div class="col-md-3">
                <div class="form-group"> 
                    <label for="CAF_REF" class="control-label">CAF REF </label>                            
                    <input type="text" name="CAF_REF" id="CAF_REF" maxlength="20" placeholder="Prix CAF de référence" class="form-control" />
                </div>
                <div class="form-group">
                    <label for="FIXE_CAF" class="control-label">FOB FRAIS FIXE CAF </label>                            
                    <input type="text" name="FIXE_CAF" id="FIXE_CAF" maxlength="20" placeholder="FOB FRAIS FIXE CAF" class="form-control" />
                </div>
                <div class="form-group">
                    <label for="TX_VAR" class="control-label">TAUX VAR (Taux Freinte)</label>                            
                    <input type="text" name="TX_VAR" id="TX_VAR" maxlength="20" placeholder="TAUX VAR" class="form-control" />
                </div>              
            </div>
            <div class="col-md-3">
                <div class="form-group">
                    <label for="CAF_FOB" class="control-label">CAF FOB  </label>                            
                    <input type="text" name="CAF_FOB" id="CAF_FOB" maxlength="20" placeholder="CAF FOB" class="form-control" />
                </div>
                <div class="form-group">
                    <label for="FIXE_CF" class="control-label">FOB FRAIS FIXE CF </label>                            
                    <input type="text" name="FIXE_CF" id="FIXE_CF" maxlength="20" placeholder="FOB FRAIS FIXE CF" class="form-control" />
                </div>
                <div class="form-group ">
                    <div class="row">
                        <div class="col-md-6">
                            <label for="TX_CAF" class="control-label">TAUX CAF  </label>                            
                            <input type="text" name="TX_CAF" id="TX_CAF" maxlength="20" placeholder="TAUX CAF" class="form-control" />
                        </div>
                        <div class="col-md-6">
                            <label for="TX_CF" class="control-label">TAUX CF  </label>                            
                            <input type="text" name="TX_CF" id="TX_CF" maxlength="20" placeholder="TAUX CF" class="form-control" />
                        </div>
                    </div>                    
                </div>
                <div class="form-group">
                    <label for="ASS" class="control-label">ASSURANCE </label>                            
                    <input type="text" name="ASS" id="ASS" maxlength="20" placeholder="ASSURANCE" class="form-control" />
                </div>              
            </div>
        </div>
        
        <p class="text-center"> 
            <input type="hidden" id="Id" name="Id" value="" />
            <input type="hidden" id="Choix_Enr" name="Choix_Enr" value="1" />
            <input type="button" value="Enregistrer" id="btn" class="btn btn-primary" />
        </p>                                                 
    </form>

<%
'################################
    End If
'################################   
%>