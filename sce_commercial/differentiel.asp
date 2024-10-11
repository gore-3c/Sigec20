﻿    <!--#include file="../include/inc_con.asp" -->
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
		<title> Paramétrage différentiel - SIGEC4</title>

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
							<h4 class="page-title text-info"> Différentiel - Paramétrage</h4>
							<ol class="breadcrumb"><!-- breadcrumb -->
								<li class="breadcrumb-item"><a href="#">Module Commercial</a></li>
								<li class="breadcrumb-item active" aria-current="page">Différentiel</li>
							</ol><!-- End breadcrumb -->
						</div>
                        <!-- End page-header -->
                        
                        <!-- row -->
						<div class="row">
							<div class="col-md-12 col-lg-12">
                                <div class="card">
                                    <div class="card-header">
                                        <div class="card-title">Différentiel - Paramétrage </div>
                                    </div>
                                    <div class="card-body">
										<div class="panel panel-primary">
											<div class="tab-menu-heading">
												<div class="tabs-menu ">
													<!-- Tabs -->
													<ul class="nav panel-tabs">
														<li class="">
															<a href="#tab1" class="active" data-toggle="tab">
																Différentiels récolte 																
															</a>
														</li>
														<li><a href="#tab2" data-toggle="tab">Nouveau </a></li>
														<li><a href="#tab3" data-toggle="tab">-- </a></li>
													</ul>
												</div>
											</div>
											<div class="panel-body tabs-menu-body">
												<div class="tab-content">
													<div class="tab-pane active " id="tab1">
														<form class="form-inline">
															<select class="form-control" name="Recolte" id="Recolte"></select>
															<select class="form-control" name="Produit" id="Produit">
																<option value="1">CAFE</option> 
																<option value="2" selected>CACAO</option>
															</select>
															<select class="form-control" name="xParite" id="xParite">
																<option value="0" selected>Tout</option> 
																<option value="1">1</option> 
																<option value="2">2</option>
															</select>
														</form>
														
														<div id="wListe" style="height: 400px; overflow-y: scroll;"></div>														
													</div>
													<div class="tab-pane" id="tab2">
														<div id="wFrm"></div>
													</div>
													<div class="tab-pane" id="tab3">
													
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
        <script type="text/javascript" src="../assets/plugins/sweet-alert/sweetalert.min.js"></script>
		<!-- Custom js-->
        <script src="../assets/js/messcripts.js"></script>
        <script src="../assets/scripts/jquery-commun.js"></script>
        <script src="../assets/scripts/jquery-redevances.js"></script>
        <script  type="text/javaScript">

            $(function () {

				$('#wFrm').on('keypress','input',function(e){
					// Autoriser seulement les chiffres, le point et la virgule
					var keycode = window.event? e.keyCode : e.which;
	 				if(parseInt(keycode)!= 44 && parseInt(keycode)!= 46 && parseInt(keycode)!= 0 && parseInt(keycode)!= 8 && parseInt(keycode)<48 || parseInt(keycode)>57)  return false; 
				});
   
                _differentiel_new('#wFrm');
                ComboListe(<%=(right(year(Now),2)+1)%>, 0, 0, 'CboRecolte', '#Recolte', 'Récolte');
                GetDifferentiels('<%=(right(year(Now),2)+1)%>', $('#Produit').val(), $('#xParite').val(), 'ListeDiff', '#wListe');				

                $('#Recolte,#Produit,#xParite').change(function(){
                	GetDifferentiels($('#Recolte').val(), $('#Produit').val(), $('#xParite').val(), 'ListeDiff', '#wListe');                    
                });

                $('a[href="#tab2"]').click(function(){
                    ComboListe(0, 0, 0, 'CboCamp', '#Camp', 'Campagne');
                	ComboListe(0, 0, 0, 'CboRecolte', '#Rclt', 'Récolte');
                });

                $('a[href="#tab1"]').click(function(){
                	GetDifferentiels('<%=(right(year(Now),2)+1)%>', $('#Produit').val(), $('#xParite').val(), 'ListeDiff', '#wListe');
                });

                $('#Camp').change(function(){
                    ComboListe(0, 1, 2, 'CboPeriode', '#Per', 'Période');
                });

                $('#tab2').on('change','#Prdt', function(){
                	ComboListe(0, 0, $('#Prdt').val(), 'CboPeriode', '#Per', 'Période');
                });

                $('#wListe').on('click','button', function(){
                	affiche_redevances ($(this).attr('id'), '#tab3');
                	$('.panel-tabs a[href="#tab3"]').tab('show');
                });

                $('#tab2').on('keyup','#FIXE_CAF', function(){

                	var CAF_REF = 0, FIXE_CF = 0, TX_CAF = 0;
                	FIXE_CF = $(this).val().replace(',','.');

                	$('#FIXE_CF').val(FIXE_CF);
                	CAF_REF = $('#CAF_REF').val().replace(',','.');
                	TX_CAF = parseFloat(FIXE_CF)*100/parseFloat(CAF_REF);
                	$('#TX_CAF').val(TX_CAF);
                });

                $('#tab2').on('keyup','#TX_VAR', function(){
                	var TX_CF = 0;
                	TX_CF = parseFloat(1-$(this).val().replace(',','.')/100)*100;
                	$('#TX_CF').val(TX_CF);
                });

                $('#wFrm').on('click','#btn',function(){

                    var Err = 0, Msg = '';
                    
                    if($('#Prdt').val() == '0') {
                        Msg = "Vous devez choisir le produit";
                        Err +=1;
					}
					if($('#Per').val() == '0') {
                        Msg = "Vous devez choisir la période";
                        Err +=1;
					}
					if($('#Rclt').val() == '0') {
                        Msg = "Vous devez choisir la récolte";
                        Err +=1;
					}
					if($('#Regime').val() == '0') {
                        Msg = "Vous devez choisir le régime";
                        Err +=1;
					}
					if($('#Parite').val() == '0') {
                        Msg = "Vous devez choisir la parité";
                        Err +=1;
					}
					if($('#TypeOp').val() == '0') {
                        Msg = "Vous devez choisir le type opérateur";
                        Err +=1;
					}

					if($('#CAF_REF').val() == '') {
                        Msg = "Vous devez saisir le prix CAF_REF";
                        Err +=1;
					}
					if($('#FIXE_CAF').val() == '') {
                        Msg = "Vous devez saisir le prix CAF_REF";
                        Err +=1;
					}
					if($('#TX_CAF').val() == '') {
                        Msg = "Vous devez saisir le taux TX_CAF";
                        Err +=1;
					}
					if($('#TX_VAR').val() == '') {
                        Msg = "Vous devez saisir le taux TX_VAR";
                        Err +=1;
					}
					if($('#CAF_FOB').val() == '') {
                        Msg = "Vous devez saisir le prix CAF_FOB";
                        Err +=1;
					}
					if($('#FIXE_CF').val() == '') {
                        Msg = "Vous devez saisir le prix FIXE_CF";
                        Err +=1;
					}
					if($('#TX_CF').val() == '') {
                        Msg = "Vous devez saisir le taux TX_CF";
                        Err +=1;
					}
					if($('#ASS').val() == '') {
                        Msg = "Vous devez saisir le prix ASSURANCE";
                        Err +=1;
					}
                    

                    if(Err != 0) {
                        swal("Erreur de saisie!", Msg, "warning");
                        return false;
                    }
                    else{ 
                        swal({
                                title: 'Saisie differentiel',
                                text: "Voulez-vous enregistrer ce differentiel ?",                                
                                showCancelButton: true,
                                confirmButtonClass: 'btn-primary',                            
                                confirmButtonText: 'Oui',
                                cancelButtonText: 'Non',
                                closeOnConfirm: false
                            },
                                function(){
                                    _differentiel_maj('#FrmDiff');
                            });
                        }
                        return false;
                });

            });     

        </script>

	</body>
</html>