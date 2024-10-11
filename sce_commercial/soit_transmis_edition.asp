<%
	If Session("Login") = False Or IsNull(Session("Login")) = True Then Response.Redirect "../expire.asp" End If
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
		<title>SIGEC4 - Soit-Transmis | Edition</title>

        
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
		<link  href="../assets/fonts/fonts/font-awesome.min.css" rel="stylesheet">

		<!---Sweetalert css-->
		<link href="../assets/plugins/sweet-alert/jquery.sweet-modal.min.css" rel="stylesheet" />
		<link href="../assets/plugins/sweet-alert/sweetalert.css" rel="stylesheet" />

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
							<h4 class="page-title text-info"> Soit Transmis - Edition</h4>
							<ol class="breadcrumb"><!-- breadcrumb -->
								<li class="breadcrumb-item"><a href="#">Accueil</a></li>
								<li class="breadcrumb-item active" aria-current="page">Soit Transmis </li>
							</ol><!-- End breadcrumb -->
						</div>
                        <!-- End page-header -->
                        
                        <!-- row -->
						<div class="row">
							<div class="col-md-9 col-lg-9">
                                <div class="card">
                                    <div class="card-header">
										<div class="card-title">
											Soit - Transmis de Factures soutien
										</div>
                                    </div>
                                    <div class="card-body">
                                        <div class="table-responsive">												
											<table id="xData" class="table table-striped table-bordered text-nowrap w-100"></table>
											<div id="wFrm"></div>
										</div>
										<form id="FrmUp">
											<input type="hidden" name="Id" id="Id" />
										</form>
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
														<option value="Date">Date</option>
														<option value="Ref">Reférence</option>
														<option value="Exp">Exportateur</option>
													</select>
												</div>
												<div class="form-group">
													<input name="Zone" id="Zone" class="form-control" value="<%=FormatDateTime(Date,0)%>" type="text" placeholder="Saisir critère ici">
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
		<script src="../assets/js/vendors/jquery-3.2.1.min.js"></script>
		<!--Bootstrap js-->
        <script src="../assets/js/vendors/bootstrap.bundle.min.js"></script>
        <!--Horizontal js-->
        <script src="../assets/plugins/horizontal-menu/horizontal.js"></script>        
        <!-- Data tables js-->
        <script type="text/javascript" src="../assets/plugins/bootstrap-table/bootstrap-table.min.js"></script>
        <script type="text/javascript" src="../assets/plugins/bootstrap-table/bootstrap-table-fr-FR.min.js"></script>
        <script type="text/javascript" src="../assets/plugins/sweet-alert/js/sweetalert.min.js"></script>
		
		<script src="../assets/scripts/fs_soit_transmis.js"></script>
        <script type="text/javascript">
			function Afficher(name, url, left, top, width, height, toolbar, menubar, statusbar, scrollbar, resizable)
			{
				toolbar_str = toolbar ? 'yes' : 'no';
				menubar_str = menubar ? 'yes' : 'no';
				statusbar_str = statusbar ? 'yes' : 'no';
				scrollbar_str = scrollbar ? 'yes' : 'no';
				resizable_str = resizable ? 'yes' : 'no';
			
				cookie_str = document.cookie;
				cookie_str.toString();
			
				pos_start  = cookie_str.indexOf(name);
				pos_end    = cookie_str.indexOf('=', pos_start);
			
				cookie_name = cookie_str.substring(pos_start, pos_end);
			
				pos_start  = cookie_str.indexOf(name);
				pos_start  = cookie_str.indexOf('=', pos_start);
				pos_end    = cookie_str.indexOf(';', pos_start);
				
				if (pos_end <= 0) pos_end = cookie_str.length;
				cookie_val = cookie_str.substring(pos_start + 1, pos_end);
				if (cookie_name == name && cookie_val  == "done")
				return;
			
				window.open(url, name, 'left='+left+',top='+top+',width='+width+',height='+height+',toolbar='+toolbar_str+',menubar='+menubar_str+',status='+statusbar_str+',scrollbars='+scrollbar_str+',resizable='+resizable_str);
			}
	   </script>
        <script>
            $(function() {

				soit_transmis_liste(0, 'ListST', '', '', 'ListST', '#xData');
				$('#rbtn').click(function(){
					$('#wFrm').html('');
					soit_transmis_liste(0, 'ListST', $('#Zone').val(), $('#rZone').val(), 'ListST', '#xData');
				});
				
				$('#xData').on('click','a',function(){
					
					Afficher('Print_ST', $(this).attr('href'), 100, 100, 500, 500, 0, 0, 0, 1, 1);
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