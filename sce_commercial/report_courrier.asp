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
		<title>SIGEC4 - Reception Facture soutiens </title>
        
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
				<!--#include file="../include/_menu_com.asp" -->

				<!--content-area-->
				<div class="content-area">
					<div class="container">

						<!-- page-header -->
						<div class="page-header">
							<h4 class="page-title text-info"> Report - Courrier</h4>
							<ol class="breadcrumb"><!-- breadcrumb -->
								<li class="breadcrumb-item"><a href="#">Gestion</a></li>
								<li class="breadcrumb-item active" aria-current="page">Report</li>
							</ol><!-- End breadcrumb -->
						</div>
						<!-- End page-header -->
						
						<!-- row -->
						<div class="row">
							<div class="col-md-*9 col-lg-9">
								<div class="card">
									<div class="card-header">
										<div class="card-title">Recherche de CV</div>
									</div>
									<div class="card-body">
										<div class="table-responsive">
											<table id="xData" class="table table-striped table-bordered text-nowrap w-100">
												<thead>
													<tr>
														<th>#</th>
														<th>Contrat</th>
														<th>Tonnage</th>
														<th>Nb Fo1</th>
														<th>Volume FO1</th>
														<th>Solde CV</th>
														<th>Reporté</th>
													</tr>
												</thead>
												<tbody>
													<tr><td colspan="7" class="text-center"> Aucun enregistrement disponible </td></tr>
												</tbody>
											</table>
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
													<select class="form-control" id="Prdt" name="Prdt">
														<option value="2">Cacao</option>
														<option value="1">Café</option>
													</select>
												</div>
												<div class="form-group">													
													<select class="form-control" id="Camp" name="Camp"> </select>
												</div>
												<div class="form-group">													
													<select class="form-control" id="Per" name="Per"> </select>													
												</div>												
												<div class="form-group">
													<select name="rZone" id="rZone" class="form-control">
														<option value="Exp">Exportateur</option>
													</select>
												</div>
												<div class="form-group">
													<input name="Zone" id="Zone" class="form-control" value="<%=FormatDateTime(Date,0)%>" type="text" placeholder="Saisir critère ici">
												</div>
												<button id="rbtn" type="button" class="btn btn-sm btn-primary">Rechercher <i class="fa fa-search" data-toggle="tooltip" title="" data-original-title="fa fa-search"></i> <span id="xLoad"></span> </button>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>

				<!-- Large Modal -->
				<div id="wEdit" class="modal fade">
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
        <script type="text/javascript" src="../assets/plugins/bootstrap-table/bootstrap-table.min.js"></script>
        <script type="text/javascript" src="../assets/plugins/bootstrap-table/bootstrap-table-fr-FR.min.js"></script>
		<script src="../assets/scripts/jquery-commun.js"></script>
		<script src="../assets/scripts/jquery-report-cv.js"></script>
        <script>
            $(function() {
								
				//factSoutien_liste (0, 'Recept', '', '', 'ListeFs', '#xData');
				
				$('#rZone').change(function(){
					$('#Zone').val('');
				});

				ComboListe(0, 0, 0, 'CboCamp', '#Camp', 'Campagne');

            	$('#Camp,#Prdt').change(function(){
            		ComboListe(0, $('#Camp').val(), $('#Prdt').val(), 'CboCamPdtPer', '#Per','Periode');            		
            	});
				$('#Per').change(function(){
            		Liste_Contrats($('#Exp').val(),$(this).val(),'#xData');
            	});
            	$('#btn').click(function(){
					Liste_Contrats($('#Exp').val(),$('#Per').val(),'#xData');
				});
				
				$('#xData').on('click', 'tr td[class^=id_l]', function () {
                    var i = $(this).attr('class').match(/[0-9]+/);                    
                    $('tr[class~="parent_l' + i + '"]').toggle();
                });
                
                $('#xData').on('click', 'tr td[class^=id_m]', function () {
                    var i = $(this).attr('class').match(/[0-9]+/);                    
                    $('tr[class~="parent_m' + i + '"]').toggle();
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