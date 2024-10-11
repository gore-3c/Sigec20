    <!--#include file="../include/inc_con.asp" -->
	<!--#include file="../include/fonction.asp" -->
    <!--#include file="../include/encryptions.asp" -->
    <!--#include file="../include/JSON_2.0.4.asp"-->
<%		
    If Session("Login") = False Or IsNull(Session("Login")) = True Then Response.Redirect "../expire.asp" End If		
                        
    '### - Declaration des Variables            
            Dim rs_Cdc, Cmd_Db, Err_Msg, Erreur
            Dim Pm_Code, Pm_Option, Pm_Out, xOption

            Dim Code, Count, Choix_Enr

            Dim Ref, Id, Diff, RecolteStock, CampCV, PariteStock, PariteCV, PariteMixte, Prdt, TypeOp, Redv
            Dim Pm_Ref, Pm_Id, Pm_Rec, Pm_Camp, Pm_Parite, Pm_aParite, Pm_xParite, Pm_Prdt, Pm_Trans, Pm_Redv

            Dim CAF_REF, FIXE_CAF, TX_CAF, TX_VAR, CAF_FOB, FIXE_CF, TX_CF, ASS
            Dim Pm_CAF_REF, Pm_FIXE_CAF, Pm_TX_CAF, Pm_TX_VAR, Pm_CAF_FOB, Pm_FIXE_CF, Pm_TX_CF, Pm_ASS

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

        Prdt = Request("Prdt")
        Redv = Request("Redev")
        Diff = Request("Revsou") 
        TypeOp = Request("typeOp")

        CampCV = Request("CampCV")        
        PariteCV = Request("PariteCV")
        PariteStock = Request("PariteStock")
        PariteMixte = Request("PariteMixte")
        RecolteStock = Request("RcltStock")

        ASS = Replace(Request("ASS"),".",",")
        CAF_REF = Replace(Request("CAF_REF"),".",",")
        CAF_FOB = Replace(Request("CAF_FOB"),".",",")
        FIXE_CAF = Replace(Request("FIXE_CAF"),".",",")        
        FIXE_CF = Replace(Request("FIXE_CF"),".",",")
        
        TX_CAF = Replace(Request("TX_CAF"),".",",")
        TX_CF = Replace(Request("TX_CF"),".",",")
        TX_VAR = Replace(Request("TX_VAR"),".",",")
        
        If Code = "" Then 
            Err_Msg = "Une Erreur inatendue (0) s'est produite." 
            Err_Msg = Err_Msg & "Veuiller vérifier les informations saisies !" 
            Err_Msg = Err_Msg & "Si l'Erreur persiste, veuillez contacter l'Administrateur !" 
            Erreur = -1
        Else
            If Request("RcltStock") = ""  Or Request("RcltStock") = "0"  Then 
                Err_Msg =  Err_Msg & "Erreur! Récoltes du Stock non saisie!"
                Erreur = 1
            End If
         
            If Request("CampCV") = "" Or Request("CampCV") = "0"  Then 
                Err_Msg =  Err_Msg & "Erreur! Campagnes de la CV non saisie ! "
                Erreur = -1
            End If   

            If Request("TypeOp") = "" Then 
                Err_Msg =  Err_Msg & "Erreur! Differentiel pour Usinier ou Exp de fèves ? "
                Erreur = -1
            End If

            If Request("PariteStock") = "" Or Request("PariteStock") = "0" Then 
                Err_Msg =  Err_Msg & "Erreur! Parités du Stock non saisie ! "
                Erreur = -1
            End If

            If Request("PariteCV") = "" Or Request("PariteCV") = "0" Then 
                Err_Msg =  Err_Msg & "Erreur! Parités de la CV non saisie ! "
                Erreur = -1
            End If

            If Request("PariteMixte") = "" Or Request("PariteMixte") = "0" Then 
                Err_Msg =  Err_Msg & "Erreur! Parités mixte non définie ! "
                Erreur = -1
            End If

            If Request("Prdt") = "" Or Request("Prdt") = "0" Then 
                Err_Msg =  Err_Msg & "Erreur! Produit  non saisie ! "
                Erreur = -1
            End If            

            If Request("CAF_REF") = "" Then 
                Err_Msg =  Err_Msg & "Erreur! CAF_REF non défini ! "
                Erreur = -1
            End If
            If Request("FIXE_CAF") = "" Then 
                Err_Msg =  Err_Msg & "Erreur! FIXE_CAF non saisi ! "
                Erreur = -1
            End If
            If Request("CAF_FOB") = "" Then 
                Err_Msg =  Err_Msg & "Erreur! CAF_FOB non saisi ! "
                Erreur = -1
            End If
            If Request("FIXE_CF") = "" Then 
                Err_Msg =  Err_Msg & "Erreur! FIXE_CF non saisi ! "
                Erreur = -1
            End If
            If Request("ASS") = "" Then 
                Err_Msg =  Err_Msg & "Erreur! Montant assurance non saisi ! "
                Erreur = -1
            End If
            If Request("TX_CAF") = "" Then 
                Err_Msg =  Err_Msg & "Erreur! TX_CAF non saisi ! "
                Erreur = -1
            End If
            If Request("TX_VAR") = "" Then 
                Err_Msg =  Err_Msg & "Erreur! TX_VAR non saisi ! "
                Erreur = -1
            End If
            If Request("TX_CF") = "" Then 
                Err_Msg =  Err_Msg & "Erreur! TX_CF non saisi ! "
                Erreur = -1
            End If
                
        End If

        If Erreur = 0  then

            '### - Création de la Commande à Exécuter
                Set Cmd_Db = Server.CreateObject("AdoDB.Command")
                    Cmd_Db.ActiveConnection = ado_Con
                    Cmd_Db.CommandText = "Ps_Doc_Differentiel_Mixte"
                    Cmd_Db.CommandType = adCmdStoredProc

            '### - Définition des Paramètres de la Procédure Stockée SQL
                Set Pm_Out	    = Cmd_Db.CreateParameter("@Output", adInteger, adParamOutput)				: Cmd_Db.Parameters.Append Pm_Out
                Set Pm_Option	= Cmd_Db.CreateParameter("@Option", adVarChar, adParamInput, 15, xOption)	: Cmd_Db.Parameters.Append Pm_Option
                Set Pm_Code		= Cmd_Db.CreateParameter("@Code", adVarChar, adParamInput, 3, Code)		    : Cmd_Db.Parameters.Append Pm_Code
                Set Pm_Search   = Cmd_Db.CreateParameter("@Search", adVarChar, adParamInput, 2000, "")      : Cmd_Db.Parameters.Append Pm_Search

                Set Pm_Id		= Cmd_Db.CreateParameter("@Id", adInteger, adParamInput, , 0)		      : Cmd_Db.Parameters.Append Pm_Id
                Set Pm_Redv     = Cmd_Db.CreateParameter("@Redev", adInteger, adParamInput, , Redv)       : Cmd_Db.Parameters.Append Pm_Redv
                Set Pm_Prdt     = Cmd_Db.CreateParameter("@Prdt", adInteger, adParamInput, , Prdt)        : Cmd_Db.Parameters.Append Pm_Prdt
                Set Pm_Camp     = Cmd_Db.CreateParameter("@CampCv", adInteger, adParamInput, , CampCV)    : Cmd_Db.Parameters.Append Pm_Camp
                Set Pm_Rec      = Cmd_Db.CreateParameter("@RcltStock", adInteger, adParamInput, , RecolteStock)      : Cmd_Db.Parameters.Append Pm_Rec                
                Set Pm_Parite   = Cmd_Db.CreateParameter("@PariteCV", adInteger, adParamInput, , PariteCV)      : Cmd_Db.Parameters.Append Pm_Parite
                Set Pm_aParite  = Cmd_Db.CreateParameter("@PariteStock", adInteger, adParamInput, , PariteStock)    : Cmd_Db.Parameters.Append Pm_aParite
                Set Pm_xParite  = Cmd_Db.CreateParameter("@PariteMixte", adInteger, adParamInput, , PariteMixte)    : Cmd_Db.Parameters.Append Pm_xParite
                Set Pm_Trans    = Cmd_Db.CreateParameter("@Trans", adInteger, adParamInput, , TypeOp)     : Cmd_Db.Parameters.Append Pm_Trans
                Set Pm_Ref      = Cmd_Db.CreateParameter("@Ref", adVarChar, adParamInput, 2000, Ref)      : Cmd_Db.Parameters.Append Pm_Ref

                Set Pm_ASS      = Cmd_Db.CreateParameter("@Assurance", adDouble, adParamInput, , ASS)      : Cmd_Db.Parameters.Append Pm_ASS
                Set Pm_CAF_FOB  = Cmd_Db.CreateParameter("@Caf_Fob", adDouble, adParamInput, , CAF_FOB)   : Cmd_Db.Parameters.Append Pm_CAF_FOB
                Set Pm_CAF_REF  = Cmd_Db.CreateParameter("@Caf_Ref", adDouble, adParamInput, , CAF_REF)   : Cmd_Db.Parameters.Append Pm_CAF_REF
                Set Pm_FIXE_CAF = Cmd_Db.CreateParameter("@Frais_Caf", adDouble, adParamInput, , Round(TX_CAF,5)): Cmd_Db.Parameters.Append Pm_FIXE_CAF
                Set Pm_FIXE_CF  = Cmd_Db.CreateParameter("@Frais_CF", adDouble, adParamInput, , TX_CF)  : Cmd_Db.Parameters.Append Pm_FIXE_CF
                Set Pm_TX_VAR   = Cmd_Db.CreateParameter("@Tx_Var", adDouble, adParamInput, , TX_VAR): Cmd_Db.Parameters.Append Pm_TX_VAR
                Set Pm_TX_CAF = Cmd_Db.CreateParameter("@TX_Caf", adDouble, adParamInput, , TX_CAF): Cmd_Db.Parameters.Append Pm_TX_CAF
                Set Pm_TX_CF  = Cmd_Db.CreateParameter("@TX_CF", adDouble, adParamInput, , TX_CF)  : Cmd_Db.Parameters.Append Pm_TX_CF

                Cmd_Db.Execute
                Dim Retour				'### - Vérification du Paramètre de Retour et Affichage du Message de Confirmation
                Set Retour = Pm_Out

                Erreur = 1
                If Retour > 0 Then	 	'### - Aucune Erreur                    
                    Err_Msg = " Nouveau differentiel mixte créé !"
                Else		   			'### - Erreur Rencontrée
                    Erreur = -1                                  	
                    Err_Msg = Err_Msg & "Une Erreur inatendue N° (" & Retour & ") s'est produite. \n" 
                    Err_Msg = Err_Msg & "Veuiller vérifier les informations saisies !\n" 
                    Err_Msg = Err_Msg & "Si l'Erreur persiste, veuillez contacter l'Administrateur !" 
                End If

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
                        <option value="2"> CACAO</option>
                        <option value="1"> CAFE</option>
                    </select>
                </div>
                <div class="form-group"> 
                    <label for="CampCV" class="control-label">Campagne CV</label>  
                    <select name="CampCV" id="CampCV" class="form-control">
                        <option value="<%=Session("Camp")%>"> <%=Session("wCamp")%></option>
                    </select>
                </div>
                <div class="form-group">
                    <label for="PariteCV" class="control-label"> Récolte CV</label> 
                    <select name="PariteCV" id="PariteCV" class="form-control">
                        <option value="0"> --- </option>
                        <option value="1">Principale</option>
                        <option value="2">Intermédiaire</option>
                    </select>
                </div>
            </div>
            <div class="col-md-3">
                <div class="form-group">
                    <select name="TypeOp" id="TypeOp" class="form-control">
                        <option value=""> Type opérateur </option>
                        <option value="1">Exp. Fèves</option>
                        <option value="2">Usiniers</option>
                    </select>
                </div> 
                <div class="form-group">
                    <label for="RcltStock" class="control-label">Stock </label> 
                    <select name="RcltStock" id="RcltStock" class="form-control"> 
                        <option value="0">---</option>
                    </select>
                </div>
                <div class="form-group">
                    <label for="PariteStock" class="control-label">Récolte du Stock </label> 
                    <select name="PariteStock" id="PariteStock" class="form-control">
                        <option value="0">---</option>
                        <option value="1">Principale</option>
                        <option value="2">Intermédiaire</option>
                    </select>
                </div>
            </div>
            <div class="col-md-2">
                <div class="form-group">
                    <label for="PariteMixte" class="control-label">PARITE MIXTE</label>                            
                    <input type="text" name="PariteMixte" id="PariteMixte" maxlength="20" placeholder="" class="form-control" readonly />
                </div>                
                <div class="form-group">
                    <label for="TX_VAR" class="control-label">TAUX VAR (Freintes)</label>                            
                    <input type="text" name="TX_VAR" id="TX_VAR" maxlength="20" placeholder="TAUX VAR" class="form-control" />
                </div>
                <div class="form-group">
                    <label for="ASS" class="control-label">ASSURANCE </label>                            
                    <input type="text" name="ASS" id="ASS" maxlength="20" placeholder="ASSURANCE" class="form-control" />
                </div>
                <div class="form-group"> 
                    <label for="Redev" class="control-label">REDEVANCE </label> 
                    <select name="Redev" id="Redev" class="form-control">
                        <option value="0">---</option>
                    </select>
                </div>
            </div>
            <div class="col-md-4">
                <div class="form-group">
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label for="CAF_REF" class="control-label">CAF REF </label>                            
                                <input type="text" name="CAF_REF" id="CAF_REF" maxlength="20" placeholder="Prix CAF de référence" class="form-control" />
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <label for="CAF_FOB" class="control-label">CAF FOB </label>                            
                                <input type="text" name="CAF_FOB" id="CAF_FOB" maxlength="20" placeholder="CAF FOB" class="form-control" />
                            </div>
                        </div>
                    </div>                    
                </div>
                
                <div class="form-group ">
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label for="FIXE_CAF" class="control-label">FOB FRAIS FIXE CAF </label>                            
                                <input type="text" name="FIXE_CAF" id="FIXE_CAF" maxlength="20" placeholder="FOB FRAIS FIXE CAF" class="form-control" />
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <label for="FIXE_CF" class="control-label">FOB FRAIS FIXE CF </label>                            
                                <input type="text" name="FIXE_CF" id="FIXE_CF" maxlength="20" placeholder="FOB FRAIS FIXE CF" class="form-control" />
                            </div>
                        </div>
                    </div>
                </div>
                <div class="form-group ">
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label for="TX_CAF" class="control-label">TAUX CAF  </label>                            
                                <input type="text" name="TX_CAF" id="TX_CAF" maxlength="20" placeholder="TAUX CAF" class="form-control" />
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <label for="TX_CF" class="control-label">TAUX CF  </label>                            
                                <input type="text" name="TX_CF" id="TX_CF" maxlength="20" placeholder="TAUX CF" class="form-control" />
                            </div>
                        </div>
                    </div>                    
                </div>
                             
            </div>
        </div>
        
        <p class="text-center"> 
            <input type="hidden" id="Id" name="Id" value="" />
            <input type="hidden" id="Redev" name="Redev" value="" />
            <input type="hidden" id="Revsou" name="Revsou" value="" />
            <input type="hidden" id="Choix_Enr" name="Choix_Enr" value="1" />
            <input type="button" value="Enregistrer" id="btn" class="btn btn-primary" />
        </p>                                                 
    </form>

<%
'################################
    End If
'################################   
%>