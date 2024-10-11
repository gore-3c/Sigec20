<%
	If Session("Login") = False Or IsNull(Session("Login")) = True Then Response.Redirect "../default.asp" End If
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
		<title>SIGEC4 - Perceptions sur formules </title>
        
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
		<link href="../assets/fonts/fonts/font-awesome.min.css" rel="stylesheet">

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
				<!--#include file="../include/_menu_guichet.asp" -->

				<!--content-area-->
				<div class="content-area">
					<div class="container">

						<!-- page-header -->
						<div class="page-header">
							<h4 class="page-title text-info"> Bordereau de transmission</h4>
							<ol class="breadcrumb"><!-- breadcrumb -->
								<li class="breadcrumb-item"><a href="#">Etat de transmission</a></li>
								<li class="breadcrumb-item active" aria-current="page">Bordereaux de transmission</li>
							</ol><!-- End breadcrumb -->
						</div>
						<!-- End page-header -->
						
						<!-- row -->
						<div class="row">
							<div class="col-md-*9 col-lg-9">
								<div class="card">
									<div class="card-header">
										<div class="card-title">Bordereaux de transmission</div>
									</div>
									<div class="card-body">
										<div class="table-responsive">
											<table id="xData" class="table table-hover table-bordered text-nowrap w-100"></table>
											<!--<p><small>* Les Poids sont exprimés en kilogrammes</small></p>-->
										</div>
										<div id="wEdit">
											<div id="wEtat">

											</div>
										</div>
									</div>
								</div>
							</div>
							<div class="col-md-3 col-lg-3">
								<div class="card">
									<div class="card-body">
										<div id="toolbar">
											<div class="form-horizontal" role="form">
												<div class="form-group">
													<select name="wTaxe" id="wTaxe" class="form-control"> </select>
												</div>
												<div class="form-group">
													<input name="Dt" id="Dt" class="form-control" value="<%=FormatDateTime(Date,0)%>" type="text" placeholder="Saisir critère ici">
												</div>
												<button id="rbtn" type="button" class="btn btn-sm btn-primary">Afficher <i class="fa fa-search" data-toggle="tooltip" title="" data-original-title="fa fa-search"></i></button>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>

				<!-- Large Modal -->
				<div id="wEditxxx" class="modal fade">
					<div class="modal-dialog modal-lg" role="document">
						<div class="modal-content ">
							<div class="modal-body pd-20" id="xEdit"></div>
							<div class="modal-footer">								
								<button type="button" class="btn btn-secondary" data-dismiss="modal">Fermer</button>
							</div>
						</div>
					</div><!-- modal-dialog -->
				</div><!-- modal -->

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
        <script type="text/javascript" src="../assets/scripts/jquery-bord-transmis.js"></script>
        <script type="text/javascript" src="../assets/scripts/jquery-commun.js"></script>
        <script>
            $(function() {

				ComboListe(0, 0, 0, 'CboTaxe', '#wTaxe', 'Taxes');				
				
				$('#rbtn').click(function(){
					Bord_Perceptions($('#wTaxe').val(), $('#Dt').val(), '#wEtat');
					//Afficher("Voir_fo1", '../all_print/print_fo1.asp?' + $(this).attr('href').replace('#','') + '', 100, 100, 500, 500, 0, 0, 0, 1, 1);
					return false;
				});

				$('#xData').on('click','a.wImg', function(){
					//var id = $(this).attr('href').replace('#', ''); alert(id);
					//
					$('#xData').bootstrapTable('destroy');
					formule_detail($(this).attr('href').replace('#', ''), '#wEdit');
					return false;
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