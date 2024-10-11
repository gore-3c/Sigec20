var cheq_doublon_liste_fo1;
(function ($) {
    cheq_doublon_liste_fo1 = function (xDiv, Zone, rZone){
        $.ajax({
            type : 'post',
            cache: false,
            dataType: 'json',
            url: '../all_user/_chq_doublon.asp',
            data: { Zone: Zone, rZone:rZone, Choix_Enr: ''},
            success: function (data) { 

                var xdata = [];
                
                $.each(data, function(i,item){
                    if(item.FO1_ID != undefined){
                        var otem = {};
                        otem['i'] = (i + 1);
                        //otem['Id'] = item.FO1_ID;
                        otem['Num'] = item.FO1;
                        otem['Dt'] = item.FO1_DATE;
                        otem['Qte'] = nbFormat(item.QTE, 0, ' ');
                        otem['Exp'] = (item.NOM.length < 20) ? item.NOM : item.NOM.substr(0,19) + ' ...' ;
                        otem['Cdc'] = item.CDC_EXP;
                        otem['Lien'] = '<a class="wEdit" href="#' + item.FO1_ID + '"> <img src="../assets/images/sign.gif"></a>';
                        xdata.push(otem);
                    }
                });

                $('#loading').html('');   
                $(xDiv).bootstrapTable('destroy');
                $(xDiv).bootstrapTable({
                    data: xdata,
                    pagination: true,
                    search: true,                    
                    columns: [                        
                        {field: 'i',title: '#'},
                        {field: 'Num',title: 'Numero'},                        
                        {field: 'Dt',title: 'Date', sortable:true}, 
                        {field: 'Qte',title: 'Tonnage', sortable:true}, 
                        {field: 'Exp',title: 'Exporateur', sortable:true},
                        {field: 'Cdc',title: 'CDC', sortable:true},
                        {field: 'Lien',title: '-'}
                    ]
                });
            },
            error: function (xhr) {  
                alert(JSON.stringify(xhr));           
                //swal("Erreur interne au serveur !!!", "Reprendre l'opération. Si l'erreur persiste contacter l'administrateur !", "warning");
            }
        });
    }
}(jQuery));

var cheq_doublon_frm;
(function ($) {
    cheq_doublon_frm = function (id, xDiv){
        $.ajax({
            cache: false,
            type : 'post',
            dataType: 'html',
            url: '../all_user/_chq_doublon.asp',
            data: { Id: id, Choix_Enr: '1' },                                    
            success: function (data) {
                $(xDiv).html(data);
                $('#xData').bootstrapTable('destroy');
            },
            error: function (xhr) {                
                alert(JSON.stringify(xhr)); 
            }
        });
    }
}(jQuery));

var cheq_doublon_annule;
(function ($) {
    cheq_doublon_annule = function (wChq, wFo1){
        $.ajax({
            type : 'post',
            data: { Chq: wChq, Choix_Enr: '2' },
            url: '../all_user/_chq_doublon.asp',
            dataType: 'json',
            cache: false,
            success: function (data) {
                var Err_Type = (data[0].Erreur > 0) ? 'success':'warning';
                var Err_Msg = (data[0].Erreur > 0) ? 'Retrait de cheques validé' : data[0].Err_Msg;
                swal("Supression de cheque", Err_Msg, Err_Type);                
                cheq_doublon_frm(wFo1, '#wFrm');
            },
            error: function (xhr) {   
                alert(JSON.stringify(xhr));                
            }
        });
    }  
}(jQuery));

/*
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

}(jQuery));*/