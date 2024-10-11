    <!--#include file="../include/inc_con.asp" -->
	<!--#include file="../include/fonction.asp" -->
	<!--#include file="../include/encryptions.asp" -->
<%		
    If Session("Login") = False Or IsNull(Session("Login")) = True Then Response.Redirect "../expire.asp" End If		
                        
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
		<title>SIGEC4 - Ajout nouvel exportateur</title>

		<link href="../assets/css/dashboard.css" rel="stylesheet" />
		<!-- Font family -->
		<link href="https://fonts.googleapis.com/css?family=Comfortaa:300,400,700" rel="stylesheet">

		<!-- Custom scroll bar css-->
        <link href="../assets/plugins/scroll-bar/jquery.mCustomScrollbar.css" rel="stylesheet" />
        <!-- Data table css -->
        <link href="../assets/plugins/bootstrap-table/bootstrap-table.min.css" rel="stylesheet" type="text/css" />
		<link href="../assets/plugins/bootstrap-datepicker/bootstrap-datepicker.min.css" rel="stylesheet">
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
		<div id="xglobal-loader"></div>

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
							<h4 class="page-title text-info"> Exportateur - Nouveau</h4>
							<ol class="breadcrumb"><!-- breadcrumb -->
								<li class="breadcrumb-item"><a href="#">Exportateur</a></li>
								<li class="breadcrumb-item active" aria-current="page">Nouveau</li>
							</ol><!-- End breadcrumb -->
						</div>
                        <!-- End page-header -->
                        
                        <!-- row -->
						<div class="row">
							<div class="col-md-12 col-lg-12">
                                <div class="card">
                                    <div class="card-header">
                                        <div class="card-title">Exportateur - Nouveau </div>
                                    </div>
                                    <div class="card-body">
										<div id="wFrm"></div>
                                    </div>
                                </div>
							</div>
						</div>
						
                    </div>
				</div>
                <!-- End content-area-->
                <!--footer-->
                    <!--#include file="../include/inc_bas.asp" -->
                <!-- End Footer-->
			</div>
		</div>
		<!-- End Page-->

		<!-- Back to top -->
		<a href="#top" id="back-to-top"><i class="fa fa-angle-up"></i></a>

        <!-- Jquery js-->
        <script type="text/javascript" src="../assets/js/vendors/jquery-3.2.1.min.js"></script>
        <script type="text/javascript" src="../assets/js/vendors/bootstrap.bundle.min.js"></script>
        <script type="text/javascript" src="../assets/plugins/horizontal-menu/horizontal.js"></script>
        <script type="text/javascript" src="../assets/plugins/bootstrap-table/bootstrap-table.min.js"></script>
		<script type="text/javascript" src="../assets/plugins/bootstrap-table/bootstrap-table-fr-FR.min.js"></script>
		<script type="text/javascript" src="../assets/plugins/bootstrap-datepicker/bootstrap-datepicker.min.js"></script>
		<script type="text/javascript" src="../assets/plugins/sweet-alert/sweetalert.min.js"></script>
		
		<!-- Custom js-->
        <script src="../assets/js/messcripts.js"></script>
        <script src="../assets/scripts/module_exportateur.js"></script>
        <script  type="text/javaScript">

            $(function () {              
                
                _exportateur_new('#wFrm');

				$('#Dt').datepicker({
					format: "dd/mm/yyyy",
					language: "fr"
				});

                $('#wFrm').on('keyup', 'input[type=text]', function(){
                    Compter(this, $(this).attr('maxlength'), '#nb'+$(this).attr('name'));
				});
				
				$('#wFrm').on('blur', 'input[type=text]', function(){
                    if($(this).val() != '') $(this).removeClass('is-invalid');
				});
				
				$('#wFrm').on('keypress', '#Id', function (e) {
					var keycode = window.event ? e.keyCode : e.which;
					if (parseInt(keycode) != 0 && parseInt(keycode) != 8 && parseInt(keycode) < 48 || parseInt(keycode) > 57) return false;
				});
    
                $('#wFrm').on('blur','#Exp, #Nom, #CC, #Lot', function(){
                    Up($(this).attr('name'));
                    $(this).val($(this).val().toUpperCase());
                    
                });

                $('#wFrm').on('click','#btn',function(){

                    var Err = 0, Msg = '';

					$.each($('#FrmExp input[type=text]'),function (i,item) {
						if($(this).val() == ''){
							Err += 1;
							$(this).addClass('is-invalid');
							Msg = "Vous devez renseigner tous les champs en rouge";
						}
					});

					if(($('input[name=vLot]:checked').val() || '') == '') {
						Err +=1;
						$(this).addClass('is-invalid');
                        Msg = "L'opérateur fait-il des lots ? ";                        
					}
					
					if(($('input[name=vPrep]:checked').val() || '') == '') {
						Err +=1;
						$(this).addClass('is-invalid');
                        Msg = "L'opérateur fait-il du prépayé ? ";                        
					}
					
                    if($('#Statut').val() == '') {                        
						Err += 1;
						$(this).addClass('is-invalid');
						Msg = "Vous devez choisir le statut de l'opérateur";
					}

					if($('#TypeOp').val() == '0') {                        
						Err +=1;
						$(this).addClass('is-invalid');
						Msg = "Vous devez choisir le type opérateur";
					}

                    if(Err != 0) {
                        swal("Erreur de saisie!", Msg, "warning");
                        return false;
                    }
                    else{ 
                        swal({
                                title: 'Création exportateur',
                                text: "Voulez-vous créer cet opérateur ?",                                
                                showCancelButton: true,
                                confirmButtonClass: 'btn-primary',                            
                                confirmButtonText: 'Oui',
                                cancelButtonText: 'Non',
                                closeOnConfirm: false
                            },
                                function(){
                                    _exportateur_maj();
                            });
                        }
                        return false;
                });

            });     

        </script>

	</body>
</html>
