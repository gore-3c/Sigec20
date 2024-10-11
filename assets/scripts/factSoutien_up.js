var vReception;
(function ($) {
    vReception = function (id){
        $.ajax({
            type : 'post',
            data: { Id:id },
            url: '_fs_reception.asp',
            dataType: 'json',
            cache: false,
            success: function (data) {
                var Err_Type = (data[0].Erreur > 0) ? 'success':'warning';
                var Err_Msg = (data[0].Erreur > 0) ? 'Reception validée' : data[0].Err_Msg;
                Err_Msg = data[0].Err_Msg;
                swal({
                    title: "Reception de facture",
                    text: Err_Msg,
                    type: Err_Type,
                    confirmButtonClass: 'btn-primary',
                    confirmButtonText: 'Ok',
                    closeOnConfirm: true
                },
                function(){
                    $('#wFrm').html('');
                    factSoutien_liste (0, 'Recept', 'ListeFs', '#xData');
                });
            },
            error: function (xhr) {   
                alert(JSON.stringify(xhr));                
            }
        });
    }  
}(jQuery));

var Traitement_Up;
(function ($) {
    Traitement_Up = function (){
        $.ajax({
            type : 'post',
            data: $('#FrmUp').serialize(),
            url: '_fs_traitement.asp',
            dataType: 'json',
            cache: false,
            success: function (data) {
                var Err_Type = (data[0].Erreur > 0) ? 'success':'warning';
                var Err_Msg = (data[0].Erreur > 0) ? 'Traitement effectué avec succès' : data[0].Err_Msg;
                Err_Msg = data[0].Err_Msg;alert(Err_Msg);
                swal({
                    title: "Traitement de facture",
                    text: Err_Msg,
                    type: Err_Type,
                    confirmButtonClass: 'btn-primary',
                    confirmButtonText: 'Ok',
                    closeOnConfirm: true
                },
                function(){
                    $('#wFrm').html('');
                    factSoutien_liste(0, 'Traiter', 'ListeFs', '#xData');; //window.location.reload();
                });
                //swal('Agrément exportateur',data[0].Err_Msg,Err_Type);
                //window.location.replace("../sce_commercial/exp_agrement.asp");
            },
            error: function (xhr) {   
                alert(JSON.stringify(xhr));
                //swal("Erreur interne au serveur !!!", "Reprendre l'opération. Si l'erreur persiste contacter l'administrateur !", "warning");
            }
        });
    }  
}(jQuery));

var Soit_Transmis_Create;
(function ($) {
    Soit_Transmis_Create = function (id){
        $.ajax({
            type : 'post',
            data: { Id:id, Frm_Up: 'Yes' },
            url: '_soit_transmis.asp',
            dataType: 'json',
            cache: false,
            success: function (data) {
                var Err_Type = (data[0].Erreur > 0) ? 'success':'warning';
                var Err_Msg = (data[0].Erreur > 0) ? 'Soit Transmis créé' : data[0].Err_Msg;
                Err_Msg = data[0].Err_Msg;alert(Err_Msg);
                swal({
                    title: "Soit Transmis",
                    text: Err_Msg,
                    type: Err_Type,
                    confirmButtonClass: 'btn-primary',
                    confirmButtonText: 'Ok',
                    closeOnConfirm: true
                },
                function(){
                    $('#wFrm').html('');
                    factSoutien_liste(0, 'ListeA', 'ListeFs', '#xData');; //window.location.reload();
                });
            },
            error: function (xhr) {   
                alert(JSON.stringify(xhr));
                //swal("Erreur interne au serveur !!!", "Reprendre l'opération. Si l'erreur persiste contacter l'administrateur !", "warning");
            }
        });
    }  
}(jQuery));