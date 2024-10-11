
	<!--#include file="include/inc_con.asp" -->
	<!--#include file="include/fonction.asp" -->
	<!--#include file="include/encryptions.asp" -->
<%
        Response.Expires = -1
        Response.AddHeader "Pragma", "no-cache"
        Response.AddHeader "cache-control", "no-store"

    '### - Récupération des Options de Validation
            Dim Nom, Code, rs_User, strSQL_User, Login_User, strSQL_Code, rs_Code
		    Dim Identifiant, CodeAcces, Password
		    Dim Choix, Err_Msg
                Err_Msg = ""

                Choix = Decode(request.querystring(encode("Choix_Cnx")))
                Identifiant	= Request("Identifiant")
			    CodeAcces	= Request("CodeAcces")

    '########################################
    '### - Création de la Session utilisateur
    '######################################## 
    
    If 	Choix = "1" Then

	    '### - Récupération des Informations du Formulaire
		    Dim Pm_Login, Pm_Code, Pm_Pwd, Pm_Out, Pm_Option
		    Dim rs_Db 						    
				
			Identifiant	= Request("Identifiant")
			CodeAcces	= Request("CodeAcces")
			Password	= Request("Password")

			Nom = Request("Identifiant")
            Code = Request("CodeAcces")	

            session("Camp_Id") = Request("lstCamp")
            Session("Campagne") = Request("Campagne")
	  
	    '### - Création de la Commande à Exécuter
		    Dim Cmd_Db
	
		    Set Cmd_Db = Server.CreateObject("AdoDb.Command")
			    Cmd_Db.ActiveConnection = ado_Con
			    Cmd_Db.CommandText = "Ps_Login"
			    Cmd_Db.CommandType = adCmdStoredProc
	
	    '### - Définition des Paramètres de la Procédure Stockée SQL
		    Set Pm_Code	 	= Cmd_Db.CreateParameter("@Code", adVarChar, adParamInput, 50, CodeAcces)		: Cmd_Db.Parameters.Append Pm_Code
		    Set Pm_Login 	= Cmd_Db.CreateParameter("@Login", adVarChar, adParamInput, 50, Identifiant)	: Cmd_Db.Parameters.Append Pm_Login
		    Set Pm_Pwd	 	= Cmd_Db.CreateParameter("@Password", adVarChar, adParamInput, 50, Password)	: Cmd_Db.Parameters.Append Pm_Pwd
	
	    '### - Exécution de la Commande SQL
		    Set rs_Db = Cmd_Db.Execute 
	
	    '### - Récupération des Informations d'Identification
		    Dim Acces 	: Acces = 0
		    Dim Dmz
				
		    Dim Count 	: Count = 0
		    Dim Nb		: Nb 	= 1
				
		    Dim Log_Exp : Log_Exp = 0
		    Dim Log_Use : Log_Use = 0
				
		    Session("Code") = CodeAcces			
		    Session("Nom") 	= Identifiant			

	    '### - Récupération des Informations d'Identification				
													
		    Do Until rs_Db Is Nothing
				
			    Count = 0
					
			    While Not rs_Db.Eof
		
				    '############################
					    If Nb = 1 Then		' ###  => Jeu de Résultats N° 1 -  Information Exportateur
				    '############################
								
						    Count   = Count   + 1
						    Log_Exp = Log_Exp + 1
								
						    Acces = rs_Db("Access")
						    Dmz   = rs_Db("Zone")
			
						    Session("Type")  	= rs_Db("Type")
						    Session("Domaine")  = LCase(Dmz)		
											
						    Session("Sus_Mess") = rs_Db("ss_Mess")
						    Session("Agree_Id") = rs_Db("Agree_Id") 
                            Session("V_Agree") = rs_Db("V_AGREE")
                            Session("Origine") 	= rs_Db("Origine_libelle")
                            Session("OrigineCode") 	= rs_Db("Origine_code")
                            Session("TypeSession") 	= rs_Db("TypeSession")
                            Session("Session_Id") 	= rs_Db("Session_Id")

						    Session("Login") = True			
								
						    Log "", "", "Connexion SIVATC2" 
							
						    Response.Redirect LCase(Dmz) & "/index.asp"		'### - Redirection de l'Utilisateur Athentifié	
								
				    '############################
					    ElseIf Nb = 2 Then	' ###  => Jeu de Résultats N° 2 -  Information User
				    '############################ 

						    Count   = Count   + 1
						    Log_Use = Log_Use + 1
								
						    Acces = rs_Db("Access")
						    Dmz   = rs_Db("Zone")
			
                            Session("Login") = True
                            
                            Session("Camp") = rs_Db("Camp")
                            Session("wCamp") = rs_Db("wCamp")
																		
						    Session("Agree_Id") = 0
						    Session("Type")  	= rs_Db("Type")
						    Session("Domaine")  = LCase(Dmz)		
											
						    Response.Redirect LCase(Dmz) & "/index.asp"		'### - Redirection de l'Utilisateur Athentifié	                                
                                                                                        
                    '############################
							ElseIf Nb = 3 Then	' ###  => Jeu de Résultats N° 3 -  Information User
					'############################ 

							Count   = Count   + 1
							Log_Use = Log_Use + 1
								
							Acces = rs_Db("Access")
							Dmz   = rs_Db("Zone")
			
							Session("Login") = True	
																										
							Session("Type")  	= rs_Db("Type")
							Session("Domaine")  = LCase(Dmz)		
								
							Response.Redirect LCase(Dmz) & "/index.asp"		'### - Redirection de l'Utilisateur Athentifié	 
                                           	
				    '###############
					    End If ' ###  => Fin de Sélection du Jeu de Résultats 
				    '###############
						
				    rs_Db.MoveNext
						
			    Wend
					
			    Set rs_Db = rs_Db.NextRecordset
					
			    Nb = Nb + 1
					
		    Loop
		
            Set Cmd_Db = Nothing		
                																	
		    If (Log_Exp + Log_Use) = 0 Then
			    Session("Login") = False
                Err_Msg = "Désolé, vous n'êtes pas autorisé à voir le contenu de cette page!</br>"
                Err_Msg = Err_Msg & "Assurez-vous que vous avez rentré des informations correctes dans le formulaire.</br>"	
                Err_Msg = Err_Msg & "Si l'erreur persiste veuillez contacter l'Administrateur!"						
		    End If

    ElseIf Choix = "" Then
           
        Login_User = Mid(Request.ServerVariables("LOGON_USER" ),1)                                                
        
        Set rs_Code = Server.CreateObject("ADODB.Recordset")
        strSQL_Code = "SELECT CODE FROM CERTIFICAT WHERE NOM LIKE '" & UCase(Login_User) & "'"
        strSQL_Code = "SELECT ID_EXP, NOM FROM EXPORTATEUR WHERE ID_EXP = (" & strSQL_Code & ")"
        rs_Code.Open strSQL_Code, str_Con, 3, 3
                        
        If NOT rs_Code.EOF Then		'SI EXPORTATEUR
            Nom = rs_Code("NOM")
            Code = rs_Code("ID_EXP")
            rs_Code.close
            Set rs_Code = Nothing
        Else 						'SI UTILISATEUR	
            Set rs_User = Server.CreateObject("ADODB.Recordset")
            strSQL_User = "SELECT CODE FROM CERTIFICAT WHERE NOM LIKE '" & UCase(Login_User) & "'"
            strSQL_User = "SELECT USER_ID, LOGIN FROM USER_BCC WHERE USER_ID = (" & strSQL_User & ")"
               	
            rs_User.Open strSQL_User, str_Con, 3, 3
                If NOT rs_User.EOF Then
                    Nom = rs_User("LOGIN")
                    Code = rs_User("USER_ID") 
                    rs_User.close                                     
                Else
                    Nom = "gore"
                    Code = "95" 
                End If
        End If
                           
        Set str_Con = Nothing

    End If
    
    Dim Link
        Link = encode("Choix_Cnx=1")              

%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->
        <meta name="description" content="">
        <meta name="author" content="">
        <link rel="icon" href="../favicon.ico">

        <title>SIGEC4 - Connexion</title>

        <!-- Bootstrap core CSS | Raleway:400,300,600|-->
        <!-- Dashboard css -->
        <link href="assets/css/dashboard.css" rel="stylesheet" />

        <!-- Font family -->
        <link href="https://fonts.googleapis.com/css?family=Comfortaa:300,400,700" rel="stylesheet">

        <!---Font icons css-->
        <link href="assets/plugins/iconfonts/plugin.css" rel="stylesheet" />
        <link  href="assets/fonts/fonts/font-awesome.min.css" rel="stylesheet">
    </head>

    <body class="login-ximg">

        <div class="page-main">
            <!-- page-single -->
            <div class="page-single">
                <div class="container">
                    <div class="row">
                        <div class="col mx-auto">
                            <div class="text-center mb-6">
                                <img src="assets/images/logo.JPG" class="" alt="">
                            </div>
                            <div class="row justify-content-center">
                                <div class="col-md-8 col-lg-6 col-xl-5 col-sm-7 ">
                                    <div class="card-group mb-0">
                                        <div class="card p-4">
                                            <div class="card-body">
                                                <h1>SIGEC4 - CONNEXION</h1>
                                                <p class="text-muted text-center">Suivi des contrats</p>
                                                <form name="identification" id="identification" class="form-horizontal" action="default.asp?<%=Link%>" method="post" enctype="application/x-www-form-urlencoded">
                                                    <div class="input-group mb-3">
                                                        <span class="input-group-addon"><i class="fa fa-user"></i></span>
                                                        <input type="text" id="Identifiant" name="Identifiant" class="form-control" value="<%=Nom%>" placeholder="Utilisateur">
                                                        <!--<input type="hidden" name="Identifiant" value="<%=Nom%>"> <b><%=Nom%></b>-->
                                                    </div>
                                                    <div class="input-group mb-3">
                                                        <span class="input-group-addon"><i class="fa fa-key"></i></span>
                                                        <input type="text" id="CodeAcces" name="CodeAcces" value="<%=Code%>" class="form-control" placeholder="Code d'Acces">
                                                        <!--<input type="hidden" name="CodeAcces" value="<%=Code%>"> <b><%=Code%></b>-->
                                                    </div>
                                                    <div class="input-group mb-4">
                                                        <span class="input-group-addon"><i class="fa fa-unlock-alt"></i></span>
                                                        <input type="password" id="Password" name="Password" class="form-control" placeholder="Mot de Passe">
                                                    </div>
                                                    <div class="row">
                                                        <div class="col-12">
                                                            <button type="submit" class="btn btn-gradient-primary btn-block">Connexion</button>
                                                        </div>
                                                        <!--
                                                        <div class="col-12">
                                                            <a href="forgot-password.html" class="btn btn-link box-shadow-0 px-0">Forgot password?</a>
                                                        </div>-->
                                                    </div>
                                                </form>
                                            </div>
                                        </div>
                                    </div>
                                </div><!-- col end -->
                            </div><!-- row end -->
                        </div>
                    </div><!-- row end -->
                </div>
            </div>
            <!-- page-single end -->
        </div>    

    <!-- Jquery js-->
    <script src="assets/js/vendors/jquery-3.2.1.min.js"></script>		
    <!--Bootstrap js-->
    <script src="assets/js/vendors/bootstrap.bundle.min.js"></script>		
    <!--Jquery Sparkline js-->
    <script src="assets/js/vendors/jquery.sparkline.min.js"></script>		
    <!-- Chart Circle js-->
    <script src="assets/js/vendors/circle-progress.min.js"></script>		
    <!-- Star Rating js-->
    <script src="assets/plugins/rating/jquery.rating-stars.js"></script>		
    <!-- Custom scroll bar js-->
    <script src="assets/plugins/scroll-bar/jquery.mCustomScrollbar.concat.min.js"></script>
    <script type="text/javascript">

        $(function () {

            $('#CodeAcces').keypress(function (e) {
                var keycode = window.event ? e.keyCode : e.which;
                if (parseInt(keycode) != 0 && parseInt(keycode) != 8 && parseInt(keycode) < 48 || parseInt(keycode) > 57) return false;
            });

            // Validation du formulaire
            $("#CheckForm").click(function () {

                var errorMsg = "", msg = "";

                if ($("#Password").val() == "") {
                    errorMsg += "Mot de passe incorrect !";
                    $("#Password").focus();
                }

                //If there is aproblem with the form then display an error
                if (errorMsg != "") {
                    msg = "_______________________________________________________________<br /><br />";
                    msg += "Le formulaire n'a été validé suite à des erreurs dans les valeurs soumises.<br />";
                    msg += "Veuillez corriger les erreurs et soumettre à nouveau le formulaire SVP.<br />";
                    msg += "_______________________________________________________________<br /><br />";
                    msg += "Les informations suivantes doivent être corrigées : <br />";
                    msg += errorMsg;
                    $('.modal-body p').addClass('text-danger').html(msg);

                } else return true;

                $('#myModal').modal('show');
            });
        }); 
    </script>
    
  </body>
</html>
