	<!--#include file="include/inc_con.asp" -->	
<%		

	Dim strVariable, Code, rs_Code, strSQL_Code
        Code = Session("Code")
	
	'Log "", "", "Session Expirée"

    '### - Supprimer les informations de la Session Ouverte pour l'utilisateur Connecté                                  
        'Set rs_Code = Server.CreateObject("ADODB.Recordset")
        'strSQL_Code = "Delete From EXP_SESSION Where CODE = '" & Code & "'"
        'rs_Code.Open strSQL_Code, str_Con, 3, 3
        
        'Set rs_Code = Nothing
        'Set str_Con = Nothing

    Dim Err_Msg
		Err_Msg = "<p>Votre session a expiré.<br>Veuillez vous authentifier pour accéder au Système ...</p>"
		Err_Msg = Err_Msg & "<p class=""text-center""><a class=""btn btn-info"" href=""../"" title=""Aller à la Page de connexion"">Retour</a></p><br><br>"
    
    Session("Login") = False
    For Each strVariable In Session.Contents
		Session.Abandon()
	Next
	
%>

<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title> SIVATC2 - Système Intégré de Ventes à Termes du Café et du Cacao</title>
    <link href="https://fonts.googleapis.com/css?family=Open+Sans:300,400,600,700,800|Shadows+Into+Light" rel="stylesheet" type="text/css">
    <link href="assets/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
    <link href="assets/css/theme-custom.css" rel="stylesheet" type="text/css" />      
</head>
<body>
    <header>
        <div class="container">
            <div class="row">
                <div class="col-md-12">
                    <p class="text-center"><img src="images/logo.jpg" class="img-responsive" alt="Logo Conseil du Cafe Cacao" /></p>
                </div>
            </div>
        </div>        
    </header>  
    <div class="container">
        <div class="row">         
            <div class="col-md-12">
			    <h1 class="text-center text-uppercase"><small>Session utilisateur</small></h1>
                <hr />
                <br /><br />
                <div class="text-danger"><%=Err_Msg%></div>
            </div>
        </div>        		
	    <br /><br />
    </div>
    <footer>
        <div class="container body-content">
            <!--#include file="include/inc_bas.asp" -->
        </div> 
    </footer>           
      
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>    
    <script src="assets/js/bootstrap.min.js"></script>
    <script  type="text/javascript">
	    // delai d'attente en ms
	    setTimeout("window.location='default.asp'", 8000); 
	</script>
</body>
</html>








