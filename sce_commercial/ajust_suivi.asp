
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

		<meta name="msapplication-TileColor" content="#0061da">
		<meta name="theme-color" content="#1643a3">
		<meta name="apple-mobile-web-app-status-bar-style" content="black-translucent"/>
		<meta name="apple-mobile-web-app-capable" content="yes">
		<meta name="mobile-web-app-capable" content="yes">
		<meta name="HandheldFriendly" content="True">
		<meta name="MobileOptimized" content="320">
		<link rel="icon" href="favicon.ico" type="image/x-icon"/>
		<link rel="shortcut icon" type="image/x-icon" href="favicon.ico" />

		<!-- Title -->
		<title>SIGEC4 - Ajustements sur poids réels</title>

        
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
							<div class="dropdown d-none d-lg-block">
								<a class="nav-link icon" data-toggle="dropdown" aria-expanded="false">
									<i class="fe fe-bell "></i>
									<span class="pulse bg-danger"></span>
								</a>
								<div class="dropdown-menu dropdown-menu-right dropdown-menu-arrow">
									<a href="#" class="dropdown-item text-center">3 New Notifications</a>
									<div class="dropdown-divider"></div>
									<a href="#" class="dropdown-item d-flex pb-3">
										<div class="notifyimg bg-green">
											<i class="fa fa-thumbs-o-up "></i>
										</div>
										<div>
											<strong>Someone likes our posts.</strong>
											<div class="small text-muted">3 hours ago</div>
										</div>
									</a>
									<a href="#" class="dropdown-item d-flex pb-3">
										<div class="notifyimg bg-blue">
											<i class="fa fa-commenting-o"></i>
										</div>
										<div>
											<strong> 3 New Comments</strong>
											<div class="small text-muted">5  hour ago</div>
										</div>
									</a>
									<a href="#" class="dropdown-item d-flex pb-3">
										<div class="notifyimg bg-orange">
											<i class="fa fa-eye"></i>
										</div>
										<div>
											<strong> 10 views</strong>
											<div class="small text-muted">2  hour ago</div>
										</div>
									</a>
									<div class="dropdown-divider"></div>
									<a href="#" class="dropdown-item text-center">View all Notifications</a>
								</div>
							</div><!-- notifications -->
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
				<!--#include file="../include/_menu_com.asp" -->						
					

                <!--content-area-->
				<div class="content-area">
					<div class="container">

					    <!-- page-header -->
						<div class="page-header">
							<h4 class="page-title text-info"> Ajustements poids réels - Suivi</h4>
							<ol class="breadcrumb"><!-- breadcrumb -->
								<li class="breadcrumb-item"><a href="#"> Gestion</a></li>
								<li class="breadcrumb-item active" aria-current="page">Ajustements poids réels</li>
							</ol><!-- End breadcrumb -->
						</div>
                        <!-- End page-header -->
                        
                        <!-- row -->
						<div class="row">
							<div class="col-md-12 col-lg-12">
                                <div class="card">
                                    <div class="card-header">
                                        <div class="card-title">
                                        	<form method="post" action="/" class="form-inline">
										        <div class="form-group">
										            <label for="Prdt">Produit</label>
										            <select class="form-control" id="Prdt" name="Prdt">
										                <option value="2">Cacao</option>
										                <option value="1">Café</option>
										            </select>
										        </div>
										        <div class="form-group">
										            <label for="Camp">Campagne</label>
										            <select class="form-control" id="Camp" name="Camp"> </select>
										            <span id="xLoad"></span>
										        </div>
										    </form>
                                        </div>
                                    </div>
                                    <div class="card-body">                                    	
                                        <div class="table-responsive">
                                            <table id="xData" class="table table-striped table-bordered text-nowrap w-100"></table>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!--footer-->
                <footer class="footer">
                    <div class="container">
                        <div class="row align-items-center flex-row-reverse">
                            <div class="col-lg-12 col-sm-12   text-center">
                                Copyright © 2020 - Conseil du Café-Cacao
                            </div>
                        </div>
                    </div>
                </footer>
                <!-- End Footer-->
            </div>
        </div>

        <!-- Back to top -->
		<a href="#top" id="back-to-top"><i class="fa fa-angle-up"></i></a>
		<!-- Jquery js-->
		<script src="../assets/js/vendors/jquery-3.2.1.min.js"></script>
        <script src="../assets/js/vendors/bootstrap.bundle.min.js"></script>
        <script src="../assets/plugins/horizontal-menu/horizontal.js"></script>

		<script src="../assets/scripts/jquery-commun.js"></script>
        <script src="../assets/scripts/jquery-ajustements.js"></script>
        
        <script>
            $(function() {

            	ComboListe(0, 0, 0, 'CboCamp', '#Camp');
            	$('#Camp,#Prdt').change(function(){
            		EtatSuivi3C($('#Camp').val(), $('#Prdt').val());
            	});

                //EtatSuivi3C(); //factSoutien_Suivi (0, 'Suivi', 'ListeFs','#xData');

            });
        </script>
        <!-- Custom js-->
        <script src="../assets/js/custom.js"></script>
        <script src="../assets/scripts/custom.js"></script>
    </body>
    </html>