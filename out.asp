	<!--include file="include/inc_con.asp" -->
	<!--include file="../include/fonction.asp" -->
	<!--include file="../include/encryption.asp" -->

<%
	'Log "", "", "Deconnexion Sigec"
	
	Dim strVariable
	
	For Each strVariable In Session.Contents
		Session.Abandon()
	Next
	
	Session("Login") = False
	
	
	'Redirect to the default user page
	Response.Redirect "default.asp"
%>
