<%		

	Dim strVariable, Code, rs_Code, strSQL_Code
        Code = Session("Code")

    Dim Err_Msg
		Err_Msg = "<p>Votre session a expiré.<br>Veuillez vous authentifier pour accéder au Système ...</p>"
		Err_Msg = Err_Msg & "<p class=""text-center""><a class=""btn btn-info"" href=""../"" title=""Aller à la Page de connexion"">Retour</a></p><br><br>"
    
    Session("Login") = False
    For Each strVariable In Session.Contents
		Session.Abandon()
	Next
	
%>

<h1 class="text-center text-uppercase"><small>Fin de Session utilisateur</small></h1>
<hr />
<br /><br />
<div class="text-danger"><%=Err_Msg%></div>