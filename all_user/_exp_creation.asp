    <!--#include file="../include/inc_con.asp" -->
	<!--#include file="../include/fonction.asp" -->
    <!--#include file="../include/encryptions.asp" -->
    <!--#include file="../include/JSON_2.0.4.asp"-->
<%		
    If Session("Login") = False Or IsNull(Session("Login")) = True Then Response.Redirect "../expire.asp" End If		
                        
    '### - Declaration des Variables            
            Dim rs_Cdc, Cmd_Db, Err_Msg, Erreur
            Dim Pm_Code, Pm_Option, Pm_Out

            Dim Code, Url, Count, Choix_Enr, Link, Id
            Dim Lib, Ref, Exp, Nom, CC, vLot, TypeOp, DG, Dt, Statut, vPrep, Marq, Regime
            Dim Pm_Exp, Pm_Nom, Pm_Type, Pm_Cc, Pm_Dg, Pm_Dt, Pm_Ref, Pm_Lot, Pm_Id, Pm_Statut, Pm_Prep, Pm_Marq, Pm_Regime

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

        Id = Request("Id")
        
        CC = Request("CC")
        Dt = Request("Dt")
        DG = Request("DG")
        
        Exp = Request("Exp")
        Nom = Request("Nom")
        Ref = Request("Ref")
        
        Marq = Request("Marq")
        Regime = Request("Regime")

        vLot = Request("vLot") 
        vPrep = Request("vPrep") 

        Statut = Request("Statut")
        TypeOp = Request("typeOp")
        
        If Code = "" Then 
            Err_Msg = "Une Erreur inatendue (0) s'est produite."  
            Err_Msg = Err_Msg & "Veuiller vérifier les informations saisies !" 
            Err_Msg = Err_Msg & "Si l'Erreur persiste, veuillez contacter l'Administrateur !" 
            Erreur = 1
        Else
            If Request("Exp") = "" Then 
                Err_Msg =  Err_Msg & "Nom de société non saisie! \n"
                Erreur = 1
            End If
            If Request("Id") = "" Then 
                Err_Msg =  Err_Msg & "Code exportateur non saisie! \n"
                Erreur = 1
            End If
            If Request("Nom") = "" Then 
                Err_Msg =  Err_Msg & "Nom de l'exportateur non saisie! \n"
                Erreur = 1
            End If
            
            If Request("Statut") = "" Then 
                Err_Msg =  Err_Msg & "L'exportateur est Exportateur de fèves ou Usinier ! \n"
                Erreur = 1
            End If
            If Request("TypeOp") = "" Then 
                Err_Msg =  Err_Msg & "Type de l'exportateur non défini! \n"
                Erreur = 1
            End If
            If Request("Ref") = "" Then 
                Err_Msg =  Err_Msg & "reference du courrier non saisie! \n"
                Erreur = 1
            End If
            If Request("vLot") = "" Then 
                Err_Msg =  Err_Msg & "Nom de Lot non saisie! \n"
                Erreur = 1
            End If
            If Request("vPrep") = "" Then 
                Err_Msg =  Err_Msg & "Statut prépaiement non défini! \n"
                Erreur = 1
            End If
            If Request("DG") = "" Then 
                Err_Msg =  Err_Msg & "Nom du Représentant (DG) non saisie! \n"
                Erreur = 1
            End If
            If Request("Dt") = "" Then 
                Err_Msg =  Err_Msg & "Date du courrier non saisie! \n"
                Erreur = 1
            End If
            If Request("CC") = "" Then 
                Err_Msg =  Err_Msg & "Compte contribuable non saisie! \n"
                Erreur = 1
            End If
                
        End If

        If Erreur = 0  then

            '### - Création de la Commande à Exécuter
                Set Cmd_Db = Server.CreateObject("AdoDB.Command")
                    Cmd_Db.ActiveConnection = ado_Con
                    Cmd_Db.CommandText = "Ps_Doc_Exp_New"
                    Cmd_Db.CommandType = adCmdStoredProc

            '### - Définition des Paramètres de la Procédure Stockée SQL
                Set Pm_Out	    = Cmd_Db.CreateParameter("@Output", adInteger, adParamOutput)				: Cmd_Db.Parameters.Append Pm_Out
                Set Pm_Option	= Cmd_Db.CreateParameter("@Option", adVarChar, adParamInput, 15, "Valider")	: Cmd_Db.Parameters.Append Pm_Option
                Set Pm_Code		= Cmd_Db.CreateParameter("@Code", adVarChar, adParamInput, 3, Code)		    : Cmd_Db.Parameters.Append Pm_Code

                Set Pm_Exp		= Cmd_Db.CreateParameter("@Exp", adVarChar, adParamInput, 150, Exp)		    : Cmd_Db.Parameters.Append Pm_Exp                
                Set Pm_Nom		= Cmd_Db.CreateParameter("@Nom", adVarChar, adParamInput, 20, Nom)		    : Cmd_Db.Parameters.Append Pm_Nom
                Set Pm_Id		= Cmd_Db.CreateParameter("@Id", adVarChar, adParamInput, 3, Id)		        : Cmd_Db.Parameters.Append Pm_Id

                Set Pm_Statut	= Cmd_Db.CreateParameter("@Stat", adVarChar, adParamInput, 20, Statut)		: Cmd_Db.Parameters.Append Pm_Statut
                Set Pm_Regime	= Cmd_Db.CreateParameter("@Type", adVarChar, adParamInput, 20, Regime)		: Cmd_Db.Parameters.Append Pm_Regime
                Set Pm_Prep		= Cmd_Db.CreateParameter("@Prep", adInteger, adParamInput, , vPrep)		    : Cmd_Db.Parameters.Append Pm_Prep
                Set Pm_Lot		= Cmd_Db.CreateParameter("@Lot", adInteger, adParamInput, , vLot)		    : Cmd_Db.Parameters.Append Pm_Lot
                Set Pm_Marq		= Cmd_Db.CreateParameter("@Mark", adVarChar, adParamInput, 20, Marq)		: Cmd_Db.Parameters.Append Pm_Marq

                Set Pm_Cc		= Cmd_Db.CreateParameter("@CC", adVarChar, adParamInput, 10, CC)		    : Cmd_Db.Parameters.Append Pm_Cc
                Set Pm_Dg		= Cmd_Db.CreateParameter("@Dg", adVarChar, adParamInput, 150, DG)		    : Cmd_Db.Parameters.Append Pm_Dg
                Set Pm_Type 	= Cmd_Db.CreateParameter("@TypeOp", adInteger, adParamInput, , TypeOp)		: Cmd_Db.Parameters.Append Pm_Type

                Set Pm_Ref		= Cmd_Db.CreateParameter("@Ref", adVarChar, adParamInput, 150, Ref)		    : Cmd_Db.Parameters.Append Pm_Ref
                Set Pm_Dt		= Cmd_Db.CreateParameter("@Date", adVarChar, adParamInput, 150, Dt)		    : Cmd_Db.Parameters.Append Pm_Dt
            
                Cmd_Db.Execute
                Dim Retour				'### - Vérification du Paramètre de Retour et Affichage du Message de Confirmation
                Set Retour = Pm_Out

                Erreur = 1
                If Retour > 0 Then	 	'### - Aucune Erreur
                    Choix_Enr = ""
                    Err_Msg = " Nouvel exportateur créé !"
                ElseIf Retour < -99 Then
                    Erreur = -1
                    Err_Msg = " Ce Code ou cet Exportateur existe déjà !"
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
                     
    <form name="Frm" id="FrmExp" class="form-horizontal" action="exp_creation.asp" method="post">
        <div class="row">
            <div class="col-md-12">
                <div class="form-group">
                    <label for="Exp" class="control-label">Société (<span id="nbExp" class="text-danger">0</span>/100) </label>
                    <input type="text" name="Exp" id="Exp" maxlength="100" placeholder="Nom de société" class="form-control" />
                </div>
            </div>
        </div>
        <div class="row">
            <div class="col-md-6">
                <div class="form-group">
                    <label for="Id" class="control-label">Code (<span id="nbId" class="text-danger">0</span>/3) </label>
                    <input type="text" name="Id" id="Id" value="<%=Id%>" maxlength="3" placeholder="Code exportateur" class="form-control" />
                </div>
                <div class="form-group">
                    <label for="CC" class="control-label">Compte CC (<span id="nbCC" class="text-danger">0</span>/8) </label>                            
                    <input type="text" name="CC" id="CC" maxlength="8" placeholder="Compte contribuable" class="form-control" />
                </div>
                <div class="form-group">
                    <div class="row">
                        <div class="col-md-4">
                            <div class="form-group">
                                <label for="typeOp" class="control-label"> Type </label>
                                <select name="TypeOp" id="TypeOp" class="form-control">
                                    <option value="0"> </option>
                                    <option value="1">National</option>
                                    <option value="2">International</option>
                                </select>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group">
                                <label for="Statut" class="control-label"> Statut </label>
                                <select name="Statut" id="Statut" class="form-control">
                                    <option value=""> </option>
                                    <option value="Exportateur">Export. Fèves</option>
                                    <option value="Transformateur">Usinier</option>
                                </select>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group">
                                <label for="Regime" class="control-label"> Regime </label>
                                <select name="Regime" id="Regime" class="form-control">
                                    <option value="Normal" selected>Normal</option>
                                    <option value="Coopex">Coopex</option>
                                    <option value="Pmex">Pmex</option>
                                </select>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="form-group">
                    <div class="row">
                        <div class="col-md-5">
                            <div class="form-group">
                                <label for="vLot" class="control-label">Saisie Lot ? : </label>
                                <input type="radio" name="vLot" value="0" /> <label class="control-label">Non </label>
                                <input type="radio" name="vLot" value="1" /> <label class="control-label">Oui </label>
                            </div>
                            <div class="form-group">
                                <label for="vPrep" class="control-label">Prépaiment ? : </label>
                                <input type="radio" name="vPrep" value="0" /> <label class="control-label">Non </label>
                                <input type="radio" name="vPrep" value="1" /> <label class="control-label">Oui </label>
                            </div>
                        </div>
                        
                        <div class="col-md-7">
                            <div class="form-group">
                                <label for="Marq" class="control-label">Marque Lot (<span id="nbLot" class="text-danger">0</span>/20) </label>                            
                                <input type="text" name="Marq" id="Marq" maxlength="20" placeholder="Nom de marque de lot" class="form-control" />
                            </div>
                        </div>
                    </div>
                </div>                
            </div>
            <div class="col-md-6">
                <div class="form-group">
                    <label for="Nom" class="control-label">Dénomination (<span id="nbNom" class="text-danger">0</span>/20) </label>
                    <input type="text" name="Nom" id="Nom" maxlength="20" placeholder="Nom court" class="form-control" />
                </div>
                
                <div class="form-group">
                    <label for="DG" class="control-label">Représentant (<span id="nbDG" class="text-danger">0</span>/30) </label>                            
                    <input type="text" name="DG" id="DG" placeholder="Nom du DG" class="form-control" />
                </div>
                <div class="form-group">
                    <label for="Dt" class="control-label">Date courrier </label>
                    <input type="text" name="Dt" id="Dt" class="form-control" placeholder="DD/MM/YYYY" />
                </div>
                <div class="form-group">
                    <label for="Ref" class="control-label">Référence courrier (<span id="nbRef" class="text-danger">0</span>/50) </label>                            
                    <input type="text" name="Ref" id="Ref" placeholder="Référence courrier / Décision d'agrément" maxlength="50" class="form-control" />                            
                </div>
            </div>
        </div>
        
        <p class="text-center"> 
            <input type="hidden" name="Choix_Enr" value="1" />
            <input type="button" value="Enregistrer" id="btn" class="btn btn-primary" />
        </p>                                                 
    </form>

<%
'################################
    End If
'################################   
%>