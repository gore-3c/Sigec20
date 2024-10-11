<!--#include file="../include/inc_con.asp" -->
<!--#include file="../include/fonction.asp" -->
<!--#include file="../include/encryption.asp" -->
<!--include file="../include/inc_var.asp" -->
<%		
	
	If Session("Login") = False Or IsNull(Session("Login")) = True Then Response.Redirect "../expire.asp" End If
	
	'### - Declaration des Variables
		Dim Cmd_Db, rs_Cdc
		Dim Pm_Out, Pm_Code, Pm_Camp, Pm_Option
		Dim Code, Camp, tr, xtr, wtr, ztr, xEtat
		Dim Count, Nb, Err_Msg
		Dim Exp_Feves, Exp_Usinier
		Dim pKKO, pKFE, TxKKO, TxKFE
	
	'### - Récupération des Variables Session Utilisateur
		Code  = Session("Code")
		Search = ""

	

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
		<title>SIGEC4 - Tableau de bord DEC</title>

		<!-- Dashboard css -->
		<link href="../assets/css/dashboard.css" rel="stylesheet" />

		<!-- Font family -->
		<link href="https://fonts.googleapis.com/css?family=Comfortaa:300,400,700" rel="stylesheet">

		<!--C3 Charts css -->
		<link href="../assets/plugins/charts-c3/c3-chart.css" rel="stylesheet" />

		<!-- Custom scroll bar css-->
		<link href="../assets/plugins/scroll-bar/jquery.mCustomScrollbar.css" rel="stylesheet" />

		<!--Horizontal css -->
        <link href="../assets/plugins/horizontal-menu/dropdown-effects/fade-down.css" rel="stylesheet" />
        <link href="../assets/plugins/horizontal-menu/horizontal.css" rel="stylesheet" />

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
				<div class="app-header header d-flex">
					<div class="container">
						<div class="d-flex">
						    <a class="header-brand" href="../sce_commercial/index.asp">
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
						<!--#include file="../include/_menu_guichet.asp" -->						
					</div>
				</div>

                <!--content-area-->
				<div class="content-area">
					<div class="container">

					    <!-- page-header -->
						<div class="page-header">
							<h4 class="page-title text-info"> <%=Camp%></h4>
							<ol class="breadcrumb"><!-- breadcrumb -->
								<li class="breadcrumb-item"><a href="#">Accueil</a></li>
								<li class="breadcrumb-item active" aria-current="page">Tableau de bord</li>
							</ol><!-- End breadcrumb -->
						</div>
						<!-- End page-header -->

        
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
				<!-- End content-area-->
			</div>
		</div>
		<!-- End Page-->

		<!-- Back to top -->
		<a href="#top" id="back-to-top"><i class="fa fa-angle-up"></i></a>

		<!-- Jquery js-->
		<script src="../assets/js/vendors/jquery-3.2.1.min.js"></script>

		<!--Bootstrap js-->
		<script src="../assets/js/vendors/bootstrap.bundle.min.js"></script>

		<!--Jquery Sparkline js-->
		<script src="../assets/js/vendors/jquery.sparkline.min.js"></script>

		<!-- Chart Circle js-->
		<script src="assets/js/vendors/circle-progress.min.js"></script>

		<!-- Star Rating js-->
		<script src="assets/plugins/rating/jquery.rating-stars.js"></script>

		<!-- Flot Chart js-->
		<script src="assets/plugins/flot/jquery.flot.js"></script>
		<script src="assets/plugins/flot/jquery.flot.fillbetween.js"></script>
		<script src="assets/plugins/flot/jquery.flot.pie.js"></script>

		<!--Jquery.knob js-->
		<script src="assets/plugins/othercharts/jquery.knob.js"></script>

		<!--Other charts js-->
		<script src="assets/js/othercharts.js"></script>

		<!-- Chart js -->
		<script src="assets/plugins/chart/Chart.bundle.js"></script>
		<script src="assets/plugins/chart/utils.js"></script>

		<!-- Peity Chart js-->
		<script src="assets/plugins/peitychart/jquery.peity.min.js"></script>
		<script src="assets/plugins/peitychart/peitychart.init.js"></script>

		<!-- Input Mask js -->
		<script src="assets/plugins/input-mask/jquery.mask.min.js"></script>

		<!-- Custom scroll bar js-->
		<script src="assets/plugins/scroll-bar/jquery.mCustomScrollbar.concat.min.js"></script>

		<!--Horizontal js-->
		<script src="../assets/plugins/horizontal-menu/horizontal.js"></script>

		<!-- Index js -->
		<script src="../assets/js/index1.js"></script>

		<!-- Search Js-->
		<script src="assets/js/prefixfree.min.js"></script>

		<!-- ECharts js -->
	    <script src="./assets/plugins/echarts/echarts.js"></script>

		<!-- Custom js-->
		<script src="../assets/js/custom.js"></script>

	</body>
</html>