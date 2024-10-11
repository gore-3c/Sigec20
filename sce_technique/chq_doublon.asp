
<%
	If Session("Login") = False Or IsNull(Session("Login")) = True Then Response.Redirect "../default.asp" End If
	Dim Code
		Code 	= Session("Code")
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
		<title>SIGEC4 - Cheques en double</title>

        
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
							<h4 class="page-title text-info"> Cheques en double - Correction</h4>
							<ol class="breadcrumb"><!-- breadcrumb -->
								<li class="breadcrumb-item"><a href="#">Cheques en double</a></li>
								<li class="breadcrumb-item active" aria-current="page">Correction</li>
							</ol><!-- End breadcrumb -->
						</div>
                        <!-- End page-header -->
                        
                        <!-- row -->
						<div class="row">
							<div class="col-md-9 col-lg-9">
                                <div class="card">
                                    <div class="card-header">
                                        <div class="card-title">Formules à traiter</div>
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
													<select name="rZone" id="rZone" class="form-control">
														<option value="Fo1">Numéro FO1</option>
														<option value="Exp">Code ou Exportateur</option>
													</select>
												</div>
												<div class="form-group">
													<input type="hidden" name="xChq" id="xChq">
													<input name="Zone" id="Zone" class="form-control" type="text" placeholder="Saisir critère ici">
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
        <script type="text/javascript" src="../assets/scripts/cheq-doublon.js"></script>
        
        <script>
            $(function() {

				$('#rZone').change(function(){
					$('#Zone').val('');
				});

				// - ### - Liste des formules
				cheq_doublon_liste_fo1('#xData', '', '');
				$('#rbtn').click(function(){
					$('#wFrm').html('');
					cheq_doublon_liste_fo1('#xData', $('#Zone').val(), $('#rZone').val());
					return false;
				});

				$('#wFrm').on('click','input[type=checkbox]',function(){
					
					//var Chq_Id = $(this).attr('id').match(/[0-9]+/);
					$('#xChq').val($(this).attr('id').match(/[0-9]+/));
					var wChq = $(this).closest('tr').find('td:eq(2)').text();
					$('input[type=checkbox]').prop('checked',false);
					$(this).prop('checked',true);
					
					swal({
	                    title: "Cheques en double",
	                    text: 'Voulez-vous retirer le chèque ' + wChq + ' de la formule ?',
	                    type: 'warning',
	                    showCancelButton: true,
	                    cancelButtonText: 'Non',	                    
	                    confirmButtonClass: 'btn-primary',
	                    confirmButtonText: 'Oui',	                    
	                    closeOnConfirm: true
	                },
	                function(){	                	
	                    cheq_doublon_annule($('#xChq').val(), $('#Fo1').val());
	                });
				});

				// -- ### - Afficher facture
				$('#xData').on('click','a.wEdit',function(){					
					var id = $(this).attr('href');
					cheq_doublon_frm(id, '#wFrm');
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