

<!--#include file="../include/inc_con.asp" -->
<!--#include file="../include/fonction.asp" -->
<!--#include file="../include/encryptions.asp" -->
<!--#include file="../include/JSON_2.0.4.asp"-->

<%	

    If Session("Login") = False Or IsNull(Session("Login")) = True Then Response.Redirect "../_expire.asp" End If	
    
    '### - Declaration des Variables
            Dim Code
            Dim Pm_Code, Pm_Option, Pm_Id, Pm_Out, Pm_Dt
            Dim Count, Nb, Dt, Id, Lien, Url, Nom, xListe, xOption
            Dim Cmd_Db, rs_Enr
            Dim jsa, col, QueryToJSON

            Code = Session("Code")

			Search = ""
	
		'### - Création de la Commande à Exécuter
			Set Cmd_Db = Server.CreateObject("AdoDB.Command")
				Cmd_Db.ActiveConnection = ado_Con
				Cmd_Db.CommandText = "Ps_Admin_transfert_Vers_SYGESAP"
				Cmd_Db.CommandType = adCmdStoredProc
	
		'### - Définition des Paramètres de la Procédure Stockée SQL
			Set Pm_Out      = Cmd_Db.CreateParameter("@Output", adInteger, adParamOutput)               : Cmd_Db.Parameters.Append Pm_Out
			Set Pm_Option   = Cmd_Db.CreateParameter("@Option", adVarChar, adParamInput, 15, "Liste") : Cmd_Db.Parameters.Append Pm_Option
			Set Pm_Code     = Cmd_Db.CreateParameter("@Code", adVarChar, adParamInput, 3, Code)         : Cmd_Db.Parameters.Append Pm_Code
			Set Pm_Id       = Cmd_Db.CreateParameter("@Id", adInteger, adParamInput, , 0)            : Cmd_Db.Parameters.Append Pm_Id
			Set Pm_Dt       = Cmd_Db.CreateParameter("@Dt", adInteger, adParamInput, , 15)            : Cmd_Db.Parameters.Append Pm_Dt
			'Set Pm_Search   = Cmd_Db.CreateParameter("@Search", adVarChar, adParamInput, 1000, Search)  : Cmd_Db.Parameters.Append Pm_Search
	
			'### - Exécution de la Commande SQL
			Set rs_Enr = Cmd_Db.Execute
	
			xListe = "<option value=""0""></option>"
	
			Do While Not (rs_Enr.EOF Or rs_Enr.BOF)
	
			xListe = xListe & "<option value=""" & rs_Enr("STRCT_ID") & """>" & rs_Enr("LIB_STRCT")  & "</option>" & vbNewLine
	
				rs_Enr.MoveNext
			Loop
	
			rs_Enr.Close
						
			Set rs_Enr = Nothing
			Set Cmd_Db = Nothing		

	


%>
<!doctype html>
<html lang="en" dir="ltr">
	<head>
		<meta charset="UTF-8">
		<meta name='viewport' content='width=device-width, initial-scale=1.0, user-scalable=0'>
		<meta http-equiv="X-UA-Compatible" content="IE=edge">

		<meta name="apple-mobile-web-app-status-bar-style" content="black-translucent"/>
		<meta name="apple-mobile-web-app-capable" content="yes">
		<meta name="mobile-web-app-capable" content="yes">
		<meta name="HandheldFriendly" content="True">
		<meta name="MobileOptimized" content="320">
		<link rel="icon" href="favicon.ico" type="image/x-icon"/>
		<link rel="shortcut icon" type="image/x-icon" href="favicon.ico" />

		<!-- Title -->
		<title>SIGEC4 - Transfert de Perceptions vers SYGESAP</title>

        
		<link href="../assets/css/dashboard.css" rel="stylesheet" />
		<!-- Font family -->
		<link href="https://fonts.googleapis.com/css?family=Comfortaa:300,400,700" rel="stylesheet">

		<!-- Custom scroll bar css-->
        <link href="../assets/plugins/scroll-bar/jquery.mCustomScrollbar.css" rel="stylesheet" />
        <!-- Data table css -->
        <link href="../assets/plugins/bootstrap-table/bootstrap-table.min.css" rel="stylesheet" type="text/css" />

		<!--Horizontal css -->
        <link href="../assets/plugins/horizontal-menu/dropdown-effects/fade-down.css" rel="stylesheet" />
		<link href="../assets/plugins/horizontal-menu/horizontal.css" rel="stylesheet" />
		
		<!---Sweetalert css-->
		<link href="../assets/plugins/sweet-alert/jquery.sweet-modal.min.css" rel="stylesheet" />
		<link href="../assets/plugins/sweet-alert/sweetalert.css" rel="stylesheet" />

		<!---Font icons css-->
		<link href="../assets/plugins/iconfonts/plugin.css" rel="stylesheet" />
		<link  href="../assets/fonts/fonts/font-awesome.min.css" rel="stylesheet">

	</head>
	<body class="app sidebar-mini rtl">

		<!--Global-Loader-->
		<div id="global-loader"></div>

		<div class="page">
			<div class="page-main">

				<!--app-header-->
				<!--#include file="../include/inc_haut.asp" -->
				<!--app-header end-->

				<!--Horizontal-menu-->
				<%If Code = "95" Or Code = "77" Then%>
				<!--#include file="../include/_menu_com.asp" -->
				<%Else%>
				<!--#include file="../include/_menu_guichet.asp" -->
				<%End If%>					
					
                <!--content-area-->
				<div class="content-area">
					<div class="container">

					    <!-- page-header -->
						<div class="page-header">
							<h4 class="page-title text-info"> Transfert de Chèques</h4>
							<ol class="breadcrumb"><!-- breadcrumb -->
								<li class="breadcrumb-item"><a href="#"> Chèques</a></li>
								<li class="breadcrumb-item active" aria-current="page">Transfert</li>
							</ol><!-- End breadcrumb -->
						</div>
                        <!-- End page-header -->
                        
                        <!-- row -->
						<div class="row">
							<div class="col-md-9 col-lg-9">
                                <div class="card">
                                    <div class="card-header">
                                        <div class="card-title"> Chèques à transférer dans SYGESAP</div>
                                    </div>
                                    <div class="card-body">
                                        <div class="table-responsive">
											<table id="xData" class="table table-striped table-bordered text-nowrap w-100"></table>
										</div>
										<div id="wFrm"></div>
                                    </div>
                                </div>
							</div>
							<div class="col-md-3 col-lg-3">
								<div class="card">
									<div class="card-body">
										<div id="toolbar">
											<div class="form-horizontal" role="form">
												<div class="form-group">
													<select name="Chq" id="Chq" class="form-control">
														<%=xListe%>
													</select>
												</div>
												<div class="form-group">
													<input type="text" name="Dt" id="Dt" class="form-control" placeholder="Date" />
												</div>
												<div class="form-group">
													<input type="text" name="Fo1" id="Fo1" class="form-control" placeholder="Num FO1" />
												</div>
												<button id="rbtn" type="button" class="btn btn-sm btn-primary">Rechercher <i class="fa fa-search" data-toggle="tooltip" title="" data-original-title="fa fa-search"></i></button>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
						
                    </div>
				</div>

                <!--footer-->
                <!--#include file="../include/inc_bas.asp" -->
                <!-- End Footer-->
            </div>
        </div>

        <!-- Back to top -->
		<a href="#top" id="back-to-top"><i class="fa fa-angle-up"></i></a>

		<!-- Jquery js-->
		<script type="text/javascript" src="../assets/js/vendors/jquery-3.2.1.min.js"></script>
        <script type="text/javascript" src="../assets/js/vendors/bootstrap.bundle.min.js"></script>
        <script type="text/javascript" src="../assets/plugins/horizontal-menu/horizontal.js"></script>
        <script type="text/javascript" src="../assets/plugins/bootstrap-table/bootstrap-table.min.js"></script>
        <script type="text/javascript" src="../assets/plugins/bootstrap-table/bootstrap-table-fr-FR.min.js"></script>
        <script type="text/javascript" src="../assets/scripts/jquery.administrations.js"></script>
        
        <script>
            $(function() {

				// - ### - Liste des formules
				$('#rbtn').click(function(){
					$('#wFrm').html('');
					form_Chq_transfert_SYGESAP($('#Chq').val(), $('#Dt').val(), $('#Fo1').val(), '#wFrm');
					return false;
				});

				$('#wFrm').on('click','#xbtn',function(){
					
					swal({
	                    title: "Transfert de chèque",
	                    text: 'Voulez-vous transferer ce chèque ?',
	                    type: 'warning',
	                    showCancelButton: true,
	                    cancelButtonText: 'Non',	                    
	                    confirmButtonClass: 'btn-primary',
	                    confirmButtonText: 'Oui',	                    
	                    closeOnConfirm: true
	                },
	                function(){
	                    transfet_cheq_SYGESAP($('#Fo1').val(), $('#Strct').val());
	                });
				});
				
            });
        </script>
        <!-- Custom js-->
        <script src="../assets/js/custom.js"></script>
		<script src="../assets/scripts/custom.js"></script>
		
		<!-- Sweet alert js-->
		<script src="../assets/plugins/sweet-alert/jquery.sweet-modal.min.js"></script>
		<script src="../assets/plugins/sweet-alert/sweetalert.min.js"></script>

    </body>
    </html>

<% 'End If %>