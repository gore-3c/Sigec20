<%
	If Session("Login") = False Or IsNull(Session("Login")) = True Then Response.Redirect "../default.asp" End If
	'### - Declaration des Variables            
            Dim Code, Err_Msg, Erreur

    '### - Récupération des Variables Session Utilisateur
            Code  = Session("Code")
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
		<title>SIGEC4 - Agrément exportateur </title>
        
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
				<div class="app-header header d-flex">
					<div class="container">
						<div class="d-flex">
						    <a class="header-brand" href="index.html">
								<img src="../assets/images/logo.jpg" class="header-brand-img" alt="SIGEC4 logo">
							</a><!-- logo-->
							<a id="horizontal-navtoggle" class="animated-arrow"><span></span></a><!-- sidebar-toggle-->
							<a href="#" data-toggle="search" class="nav-link nav-link d-md-none navsearch"><i class="fa fa-search"></i></a><!-- search icon -->
							<div class="dropdown d-none d-md-flex">
								<a  class="nav-link icon full-screen-link">
									<i class="fe fe-maximize-2"  id="fullscreen-button"></i>
								</a>
							</div><!-- full-screen -->
							<div class="d-flex order-lg-2 ml-auto horizontal-dropdown">							
								<div class="dropdown dropdown-toggle">
									<a href="#" class="nav-link leading-none" data-toggle="dropdown">
										<span class="avatar avatar-md brround"><img src="../assets/images/faces/male/33.jpg" alt="Profile-img" class="avatar avatar-md brround"></span>
										<span class="mr-3 d-none d-lg-block ">
											<span class="text-gray-white"><span class="ml-2"><%=Session("Nom")%></span></span>
										</span>
									</a>
									<div class="dropdown-menu dropdown-menu-right dropdown-menu-arrow">
										<div class="text-center">
											<a href="#" class="dropdown-item text-center font-weight-sembold user"><%=Session("Nom")%></a>
											<div class="dropdown-divider"></div>
										</div>
										<a class="dropdown-item" href="#">
											<i class="dropdown-icon mdi mdi-account-outline "></i> Profile
										</a>
										<a class="dropdown-item" href="#">
											<i class="dropdown-icon  mdi mdi-settings"></i> Settings
										</a>
										<div class="dropdown-divider"></div>
										<a class="dropdown-item" href="../out.asp">
											<i class="dropdown-icon mdi  mdi-logout-variant"></i> Deconnexion
										</a>
									</div>
								</div><!-- profile -->
							</div>
						</div>
					</div>
				</div>
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
							<h4 class="page-title text-info"> Agrément - Exportateur </h4>
							<ol class="breadcrumb"><!-- breadcrumb -->
								<li class="breadcrumb-item"><a href="#">Exportateur</a></li>
								<li class="breadcrumb-item active" aria-current="page">Agrément</li>
							</ol><!-- End breadcrumb -->
						</div>
						<!-- End page-header -->
						
						<!-- row -->
						<div class="row">
							<div class="col-md-12 col-lg-12">
								<div class="card">
									<div class="card-header">
										<div class="card-title"> 
                                            <div class="form-group">
                                                <h3>Campagne <%=Session("wCamp")%></h3>                                             
                                            </div>
                                        </div>
									</div>
									<div class="card-body">
										<div class="panel panel-primary">
											<div class="tab-menu-heading">
												<div class="tabs-menu ">
													<!-- Tabs -->
													<ul class="nav panel-tabs">
														<li class="">
															<a href="#tab1" id="atab1" class="active" data-toggle="tab">
																Exportateurs agréés					
															</a>
														</li>
														<li><a href="#tab2" id="atab2" data-toggle="tab">Exportateurs non agréés</a></li>
													</ul>
												</div>
											</div>
											<div class="panel-body tabs-menu-body">
												<div class="tab-content">
													<div class="tab-pane active " id="tab1">
														<div class="table-responsive">
															<table id="xData" class="table table-striped table-bordered text-nowrap w-100"></table>
														</div>														
													</div>
													<div class="tab-pane  " id="tab2">
														<div class="table-responsive">
															<table id="wData" class="table table-striped table-bordered text-nowrap w-100"></table>
														</div>
													</div>
												</div>
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
		
		<div class="modal fade" id="FrmModal" tabindex="-1" role="dialog" aria-labelledby="FrmModalLabel" aria-hidden="true">
			<div class="modal-dialog" role="document">
				<div class="modal-content">
					<div class="modal-header">
						<h5 class="modal-title" id="FrmModalLabel">Activation - Suspension d'agrément exportateur.</h5>
						<button type="button" class="close" data-dismiss="modal" aria-label="Close">
							<span aria-hidden="true">×</span>
						</button>
					</div>
					<div class="modal-body">
						<p id="xMotif"></p>
						<form name="Frm" id="FrmExp" class="form-horizontal" action="#" method="post">
							<div class="row">
								<div class="col-md-12">
									<div class="form-group">
										<label for="Motif" class="control-label">Motif  </label>
										<input type="hidden" name="Exp" id="Exp" />
										<input type="hidden" name="vAgree" id="vAgree" />
										<input type="text" name="Motif" id="Motif" maxlength="100" placeholder="Motif" class="form-control" />
									</div>
								</div>
							</div>
						</form>
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-secondary" data-dismiss="modal">Fermer</button>
						<button type="button" id="btn" class="btn btn-primary">Enregistrer</button>
					</div>
				</div>
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
        <script type="text/javascript" src="../assets/scripts/module_exportateur.js"></script>
        
        <script>
            $(function() {

                //Exportateur_liste (id, agree, camp, xOption, xDiv);
				Exportateur_liste (0, '<%=Session("Camp")%>', 'ExpAgree', '#xData');
				Exportateur_liste (0, '<%=Session("Camp")%>', 'ExpNonAgree', '#wData');

				// -- ### - Agréer un exportateur
				$('a#atab1').click(function(){				
					Exportateur_liste (0, '<%=Session("Camp")%>', 'ExpAgree', '#xData');
				});

				$('a#atab2').click(function(){					
					Exportateur_liste (0, '<%=Session("Camp")%>', 'ExpNonAgree', '#wData');
				});

				$('#xData').on('click','button',function(){
                    var Lib = $(this).text();
					$('#Exp').val($(this).parents('tr').find('td:eq(1)').text());
					$('#xMotif').html(Lib + ' ' + $(this).parents('tr').find('td:eq(2)').text() + ' ?');
				});				
				
				$('#wData').on('click','button',function(){
                    var Lib = $(this).text();
                    var vAgree = $(this).attr('name');
                    var Exp = $(this).parents('tr').find('td:eq(1)').text();
                    swal({
                            title: 'Agrément Exportateur',
                            text: "Voulez-vous " + Lib.toLowerCase() + " " + $(this).parents('tr').find('td:eq(2)').text() + " ? ",
                            showCancelButton: true,
                            confirmButtonClass: 'btn-primary',
                            confirmButtonText: 'Oui',
                            cancelButtonText: 'Non',
                            closeOnConfirm: false
                        },
                            function(){
                                vAgrement(Exp,'<%=Session("Camp")%>');
                        });                    
				});

				$('#FrmModal').on('click','#btn',function(){
					swal({
                            title: 'Agrément Exportateur',
                            text: "Confirmez-vous le traitement ? ",
                            showCancelButton: true,
                            confirmButtonClass: 'btn-primary',
                            confirmButtonText: 'Oui',
                            cancelButtonText: 'Non',
                            closeOnConfirm: false
                        },
                            function(){
								vSuspension($('#Exp').val(), $('#Motif').val(),'<%=Session("Camp")%>');								
                        });
				});

            });

        </script>        
		
		<!-- Sweet alert js-->
		<script src="../assets/plugins/sweet-alert/jquery.sweet-modal.min.js"></script>
		<script src="../assets/plugins/sweet-alert/sweetalert.min.js"></script>

    </body>
    </html>