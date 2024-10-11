
<%
	Dim Code
	Code = Session("Code")
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
		<title>SIGEC4 - Correction du DUS</title>

        
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
							<h4 class="page-title text-info"> DUS - Correction</h4>
							<ol class="breadcrumb"><!-- breadcrumb -->
								<li class="breadcrumb-item"><a href="#">Montant DUS</a></li>
								<li class="breadcrumb-item active" aria-current="page">Correction</li>
							</ol><!-- End breadcrumb -->
						</div>
                        <!-- End page-header -->
                        
                        <!-- row -->
						<div class="row">
							<div class="col-md-9 col-lg-9">
                                <div class="card">
                                    <div class="card-header">
                                        <div class="card-title">Montant DUS à corriger </div>
                                    </div>
                                    <div class="card-body">
                                        <div class="table-responsive">
											<table id="xData" class="table table-striped table-bordered text-nowrap w-100"></table>
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
													<select name="xType" id="xType" class="form-control">
														<option value="SIGEC4" selected>SIGEC4</option>
														<option value="Hors Normes">Hors Normes</option>
													</select>
												</div>
												<div class="form-group">
													<select name="rZone" id="rZone" class="form-control">
														<option value="Date">Date</option>
														<option value="Fo1" selected>N° F01 EXP</option>
														<option value="Exp">Exportateur</option>
													</select>
												</div>
												<div class="form-group">
													<input name="Zone" id="Zone" class="form-control" value="<%'=FormatDateTime(Date,0)%>" type="text" placeholder="Saisir critère ici">
													<input type="hidden" name="Choix_Enr" id="Choix_Enr" value="2" />
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
        <script type="text/javascript" src="../assets/scripts/jquery.administrations.js"></script>
        
        <script>
            $(function() {

				var xmt = 0;
				$('#xData').on('keypress', '#Mt', function (e) {
					xmt = (Math.round($(this).val().replace(/ /g, "")) == 0) ? '' : Math.round($(this).val().replace(/ /g, ""));
					$(this).val(nbFormat(xmt, 0, ' '));
				});

				$('#xData').on('focus', '#Mt', function (e) {
					xmt = Math.round($(this).val().replace(/ /g, ""));
					$(this).val(nbFormat(xmt, 0, ' '));
				});

				$('#xData').on('keyup', '#Mt', function (e) {
					xmt = Math.round($(this).val().replace(/ /g, ""));
					$(this).val(xmt);
				});
				
				$('#xData').on('blur', '#Mt', function (e) {					
					xmt = Math.round($(this).val().replace(/ /g, ""));					
					$(this).val(xmt);
				});

				$('#rZone').change(function(){
					$('#Zone').val('');
				});

				// - ### - Recherche du DUS à corriger
				$('#rbtn').click(function(){
					dus_up_form($('#Zone').val(), $('#rZone').val(), $('#xType').val(), '#xData');
				});				

				// -- ### - Enregistrer les modifications
				$('#xData').on('click','#btn',function(){
					if($('#Id').val() != '' && $('#Mt').val().replace(/ /g, "") != ''){
						swal({
							title: "Correction du DUS",
							text: "Voulez-vous confirmer les saisies ?",
							type: "warning",
							showCancelButton: true,
							cancelButtonText: "Non",
							confirmButtonText: "Oui",
							closeOnConfirm: true
							},
								function(){ dus_up($('#Id').val(), $('#xType').val(), $('#Mt').val().replace(/ /g, "")); }
						);
						return false;
					}else{ swal('Correction du DUS', 'Erreur: vérifiez les saisies','warning'); }
					
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