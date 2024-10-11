
<%

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
		<title>SIGEC4 - Facture soutiens avec écart</title>

        
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
				<div class="horizontal-main clearfix">
					<div class="horizontal-mainwrapper container clearfix">
						<!--#include file="../include/_menu_com.asp" -->						
					</div>
				</div>

                <!--content-area-->
				<div class="content-area">
					<div class="container">

					    <!-- page-header -->
						<div class="page-header">
							<h4 class="page-title text-info"> Factures soutiens - Correction</h4>
							<ol class="breadcrumb"><!-- breadcrumb -->
								<li class="breadcrumb-item"><a href="#">Factures soutiens</a></li>
								<li class="breadcrumb-item active" aria-current="page">Correction</li>
							</ol><!-- End breadcrumb -->
						</div>
                        <!-- End page-header -->
                        
                        <!-- row -->
						<div class="row">
							<div class="col-md-12 col-lg-12">
                                <div class="card">
                                    <div class="card-header">
                                        <div class="card-title">Factures soutiens non validées</div>
                                    </div>
                                    <div class="card-body">
                                        <div class="table-responsive">
                                            <table id="xData" class="table table-striped table-bordered text-nowrap w-100"></table>
                                        </div>
                                    </div>
                                </div>
                            </div>
						</div>
						
						<!-- Message Modal -->
						<div class="modal fade" id="UpModal" tabindex="-1" role="dialog"  aria-hidden="true">
							<div class="modal-dialog modal-lg" role="document">
								<div class="modal-content">
									<div class="modal-header">
										<h5 class="modal-title" id="example-Modal3">Correction Facture Soutien</h5>
										<button type="button" class="close" data-dismiss="modal" aria-label="Close">
											<span aria-hidden="true">&times;</span>
										</button>
									</div>
									<div class="modal-body">
										<table class="table table-hover">
											<thead>
												<th>#</th>
												<th>N° FO1</th>
												<th>Tx</th>
												<th>Poids Fact</th>
												<th>Montant</th>
												<th>A Corriger</th>
												<th></th>
											</thead>
											<tbody id="wData"></tbody>
										</table>
									</div>
									<div class="modal-footer">
										<button type="button" class="btn btn-primary" data-dismiss="modal">Fermer</button>										
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
        <script type="text/javascript" src="../assets/scripts/fs_liste_json.js"></script>
        
        <script>
            $(function() {

				var xmt = 0;
				$('#UpModal').on('keypress', 'input[id^=Mt_]', function (e) {
					xmt = (Math.round($(this).val().replace(/ /g, "")) == 0) ? '' : Math.round($(this).val().replace(/ /g, ""));
					$(this).val(nbFormat(xmt, 0, ' '));
				});

				$('#UpModal').on('focus', 'input[id^=Mt_]', function (e) {
					xmt = Math.round($(this).val().replace(/ /g, ""));
					$(this).val(nbFormat(xmt, 0, ' '));
				});

				$('#UpModal').on('keyup', 'input[id^=Mt_]', function (e) {
					xmt = Math.round($(this).val().replace(/ /g, ""));
					$(this).val(xmt);
				});
				
				$('#UpModal').on('blur', 'input[id^=Mt_]', function (e) {					
					xmt = Math.round($(this).val().replace(/ /g, ""));					
					$(this).val(xmt);
				});
				
				factSoutien_liste (0, 'Up', 'ListeFs', '#xData');

				$('#UpModal').on('click', 'input[id^=btn_]', function () {
					var ik = $(this).attr('id').match(/[0-9]+/); 
					var Mt = $('#Mt_' + ik).val(); //alert(ik + ' - ' + Mt);
					fs_Up($('#ck_' + ik).val(), Mt);
				});
				
				$('#xData').on('click','button[type=button]',function(){
						var id = $(this).attr('id');
						fs_details_up(id, 'Up');
						/*
                        $('input[type=checkbox]').prop('checked',false);
                        $(this).prop('checked',true);
                        swal({
                            title: 'Réception de contrat',
                            text: "Validez-vous la réception de ce contrat ?",                            
                            showCancelButton: true,
                            confirmButtonClass: 'btn-primary',                            
                            confirmButtonText: 'Oui',
                            cancelButtonText: 'Non',
                            closeOnConfirm: false
                        },
                            function(){
                                reception(id);
						});
						*/
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