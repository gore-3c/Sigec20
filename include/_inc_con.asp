<%@ Language="VBScript" %>
<%
	Option Explicit

        'Response.Expires = -1
        'Response.AddHeader "Pragma", "no-cache"
        'Response.AddHeader "cache-control", "no-store"
%>
	<!-- #include file="inc_adovbs.asp" -->
<%
											
'########################################
'### - Configuration de la Connexion SQL
'########################################

	'### - D�claration des Variables de Connexion � SQL
			Dim Server_Name				'Holds the name of the SQL Server
			Dim Db_User_Name			'Holds the user name (for SQL Server Authentication)
			Dim Db_Password				'Holds the password (for SQL Server Authentication)
			Dim Db_Name					'Holds name of a database on the server'
			Dim str_Con					'Holds the Database driver and the path and name of the database
			
			
	'### - D�tail de la Connexion SQL 	#####	BUREAU	#####

			Server_Name  = "192.168.11.4" 	'Holds the name of the SQL Server
			DB_User_Name = "service-new-sivatc2" 		'Holds the user name (for SQL Server Authentication)
			DB_Password  = "wv3KFJB3"	 'Holds the password (for SQL Server Authentication)

			'Server_Name  = "datasrv_Test" 	'Holds the name of the SQL Server
			'DB_User_Name = "gore" 		'Holds the user name (for SQL Server Authentication)
			'DB_Password  = "$AlGore"	'Holds the password (for SQL Server Authentication)

			DB_Name  = "encheres"     	'Holds name of a database on the server	
								
	'### - SQL Server OLE Driver
			str_Con = "Provider = SqlOleDb; "
			str_Con = str_Con & " Server=" 	& Server_Name 	& "; "
			str_Con = str_Con & " User Id=" 	& Db_User_Name 	& "; "
			str_Con = str_Con & " Password=" 	& Db_Password 	& "; "
			str_Con = str_Con & " Database=" 	& Db_Name						
			
'####################################
'### - Ouverture de la Connexion SQL
'####################################

	'### - D�claration de la Variable de Connexion
			Dim ado_Con 			' Variable de Connexion Database

	'### - Cr�ation  de l'Objet Connexion
			Set ado_Con = Server.CreateObject("ADODB.Connection")

	'### - Ouverture de la Connexion � SQL
			ado_Con.Open str_Con

'###################
'### - Fin de Page
'##################
%>