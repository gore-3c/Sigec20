
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
    <title>SIGEC4 - Cession de contrats</title>

    
    <link href="../assets/css/dashboard.css" rel="stylesheet" />
    <!-- Font family -->
    <link href="https://fonts.googleapis.com/css?family=Comfortaa:300,400,700" rel="stylesheet">

    <!-- Custom scroll bar css-->
    <link href="../assets/plugins/scroll-bar/jquery.mCustomScrollbar.css" rel="stylesheet" />
    <!-- Data table css -->
    <link href="../assets/plugins/bootstrap-table/bootstrap-table.min.css" rel="stylesheet" type="text/css" />
    <link href="../assets/plugins/bootstrap-datepicker/bootstrap-datepicker.min.css" rel="stylesheet" type="text/css" />
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
            <!--#include file="../include/_menu_com.asp" -->						
                
            <!--content-area-->
            <div class="content-area">
                <div class="container">

                    <!-- page-header -->
                    <div class="page-header">
                        <h4 class="page-title text-info"> Contrat - Cession</h4>
                        <ol class="breadcrumb"><!-- breadcrumb -->
                            <li class="breadcrumb-item"><a href="#">Cession</a></li>
                            <li class="breadcrumb-item active" aria-current="page">Correction</li>
                        </ol><!-- End breadcrumb -->
                    </div>
                    <!-- End page-header -->
                    
                    <!-- row -->
                    <div class="row">
                        <div class="col-md-9 col-lg-9">
                            <div class="card">
                                <div class="card-header">
                                    <div class="card-title">Contrat à céder </div>
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
                                                <input type="text" name="Cdc" id="Cdc" class="form-control" placeholder="N° CDC à ceder" />
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
    <script type="text/javascript" src="../assets/js/vendors/jquery-3.2.1.min.js"></script>
    <script type="text/javascript" src="../assets/js/vendors/bootstrap.bundle.min.js"></script>
    <script type="text/javascript" src="../assets/plugins/horizontal-menu/horizontal.js"></script>
    <script type="text/javascript" src="../assets/plugins/bootstrap-table/bootstrap-table.min.js"></script>
    <script type="text/javascript" src="../assets/plugins/bootstrap-table/bootstrap-table-fr-FR.min.js"></script>
    <script type="text/javascript" src="../assets/plugins/bootstrap-datepicker/bootstrap-datepicker.min.js"></script>
    <script type="text/javascript" src="../assets/scripts/jquery.administrations.js"></script>
    
    <script>
        $(function() {            
            var Err = 0, errMsg = '';
            $('#rbtn').click(function(){
                cv_cession ($('#Cdc').val(), '#xData');
            });

            $('#Dt').datepicker({
                format: "dd/mm/yyyy",
                language: "fr",
                calendarWeeks: true,
                autoclose: true,
                todayHighlight: true
            });

            $('#xData').on('click', '#btn',function (e) {
                var Err = 0;

                if($('#Exp').val() == '' || $('#Exp').val() == '0'){
                    Err = 1;
                    errMsg = 'Choisir l\'exportateur';
                }
                if($('#Ref').val() == '' || $('#Ref').val() == '0'){
                    Err = 1;
                    errMsg = 'Saisir la référence du courrier';
                }
                if($('#Dt').val() == '' || $('#Dt').val() == '0'){
                    Err = 1;
                    errMsg = 'Saisir la date du courrier';
                }

                if(Err == 0){
                    alert($('#Id').val()+ ' - ' + $('#Exp').val()+ ' - ' + $('#Dt').val()+ ' - ' +$('#Ref').val())
                    swal({
                        title: "Cession de contrat",
                        text: "Voulez-vous confirmer la cession ?",
                        type: "warning",
                        showCancelButton: true,
                        cancelButtonText: "Non",
                        confirmButtonText: "Oui",
                        closeOnConfirm: true
                        },
                            function(){ cv_cession_up ($('#Id').val(), $('#Exp').val(), $('#Dt').val(), $('#Ref').val()); } 
                    );
                }else{ swal('Cession de contrat', 'Erreur: ' + errMsg,'warning'); }                                
            });
            //alert($('#Id').val()+ ' - ' + $('#Exp').val()+ ' - ' + $('#Dt').val()+ ' - ' +$('#Ref').val())
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