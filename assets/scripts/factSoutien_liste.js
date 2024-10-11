/* ############## - Gestion des FS  - ############################### */
var factSoutien_affiche;
(function ($) {
    factSoutien_affiche = function (id, xDiv){
        $.ajax({
            cache: false,
            type : 'post',
            dataType: 'html',
            url: '../all_print/_fact_soutien.asp',
            data: { Id: id, xOption:'Edit' },                                    
            success: function (data) {
                $(xDiv).html(data);                
            },
            error: function (xhr) {                
                alert(JSON.stringify(xhr)); 
            }
        });
    }
}(jQuery));

var factSoutien_liste;
(function ($) {
    factSoutien_liste = function (id, xType, zone, rZone, xOption, xDiv){
        $("#global-loader").fadeOut("slow");
        $.ajax({
            type : 'post',
            cache: false,
            dataType: 'json',
            url: '../all_user/_fact_soutien_list.asp',
            data: { Id: id, xtype: xType, Zone:zone, rZone: rZone, xOption: xOption},
            success: function (data) {

                var xdata = [], Lien = '', Input = '', Up = '';
                
                $.each(data, function(i,item){
                    Input = (i+1);
                    Up = item.NUM;

                    switch(xType){
                        case 'Traiter' : Lien = '<a class="btn btn-primary btn-sm" href="' + xType + '?' + (item.ID*365) + '"><i class="fa fa-edit"></i></a>'; break;                        
                        case 'Liste' : Lien = '<a class="btn btn-primary btn-sm" href="#' + (item.ID*365) + '"><i class="fa fa-edit"></i></a>'; break;
                        case 'ListeUp' : 
                            Lien = '<button type="button" id="' + item.ID + '" class="btn btn-sm"><i class="fa fa-edit"></i></button>'; 
                            Input = '<input type="checkbox" name="Check_'+i+'" id="Check_'+i+'" value="'+ item.ID + '" />';
                            Up = '<input type="text" name="Num_'+i+'" id="Num_'+i+'" value="'+ item.NUM + '" disabled />';
                        break;
                        case 'Recept' : Lien = '<label class="custom-control custom-checkbox">' + 
                                                '<input id="' + i +'"  type="checkbox" class="custom-control-input" value="' + item.ID + '" />' + 
                                                    '<span class="custom-control-label"></span>' + 
                                                '</label>'; break;
                        case 'ListeA' : Lien = '<label class="custom-control custom-checkbox">' + 
                                                '<input id="' + i +'"  type="checkbox" class="custom-control-input" value="' + item.ID + '" />' + 
                                                '<span class="custom-control-label"></span>' + 
                                            '</label>'; break;                                                
                        default: Lien = '<button type="button" id="' + item.ID*365 + '" class="btn btn-primary btn-sm"><i class="fa fa-edit"></i></button>'; break;
                    }

                    if(item.ID != undefined){
                        var otem = {};
                        otem['i'] = Input;
                        otem['Num'] = Up;
                        otem['Ref'] = '<a class="wEdit" href="' + (item.ID*365) + '" data-toggle="modal" data-target="#wEdit">' + item.REF + '</a>';
                        otem['Dt'] = item.DT;
                        otem['Qte'] = nbFormat(item.QTE, 0, ' ');
                        otem['Mt'] = nbFormat(item.MONT, 0, ' ');
                        otem['Nom'] = (item.NOM.length < 10) ? item.NOM : item.NOM.substr(0,9) + ' ...' ;
                        otem['Lien'] = Lien;
                        otem['VALIDE'] = item.ETAT_VALIDE;
                        xdata.push(otem);
                    }
                });

                $(xDiv).bootstrapTable('destroy');
                $(xDiv).bootstrapTable({
                    data: xdata,
                    pagination: true,
                    search: true,                    
                    columns: [                        
                        {field: 'i',title: '#'}, 
                        {field: 'Num',title: 'Numero'},
                        {field: 'Ref',title: 'Reférence'}, 
                        {field: 'Dt',title: 'Date', sortable:true}, 
                        {field: 'Qte',title: 'Volume', sortable:true, align:"right"}, 
                        {field: 'Mt',title: 'Montant', sortable:true, align:"right"},
                        {field: 'Nom',title: 'Exportateur'},
                        {field: 'Lien',title: ' # ', align:"center"}                        
                    ]
                });
                //$('div.search').addClass('form-inline');
                //$('div.search').addClass('row');
                //$('div.search').append('<input type="text" class="form-control pull-left" />');
                
            },
            error: function (xhr) {  
                alert(JSON.stringify(xhr));           
                //swal("Erreur interne au serveur !!!", "Reprendre l'opération. Si l'erreur persiste contacter l'administrateur !", "warning");
            }
        });
    }
}(jQuery));

var factSoutien_Suivi;
(function ($) {
    factSoutien_Suivi = function (id, xType, xOption, xDiv){
        $.ajax({
            type : 'post',
            cache: false,
            dataType: 'json',
            url: '../sce_commercial/test.asp',
            data: { Id: id, xtype: xType, xOption: xOption},
            success: function (data) {

                var xdata = [];
                
                $.each(data, function(i,item){

                    if(item.ID != undefined){
                        var otem = {};
                        otem['i'] = (i + 1);
                        otem['Num'] = item.NUM;
                        otem['Ref'] = item.REF;
                        otem['Dt'] = item.DT;
                        otem['Qte'] = nbFormat(item.QTE, 0, ' ');
                        otem['Mt'] = nbFormat(item.MONT, 0, ' ');
                        otem['ETAT'] = item.ETAT;
                        otem['VALIDE'] = item.ETAT_VALIDE;
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
                        {field: 'Ref',title: 'Reférence'}, 
                        {field: 'Dt',title: 'Date', sortable:true}, 
                        {field: 'Qte',title: 'Volume', sortable:true}, 
                        {field: 'Mt',title: 'Montant', sortable:true},
                        {field: 'VALIDE',title: 'Type', sortable:true},
                        {field: 'ETAT',title: 'Etat', sortable:true}
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

var factSoutien_traiter;
(function ($) {
    factSoutien_traiter = function (id, choix, xDiv){
        $.ajax({
            cache: false,
            type : 'post',
            dataType: 'html',
            url: '_fs_traitement.asp',
            data: { Id: id, Choix:choix, xOption:'ListeFs' },                                    
            success: function (data) {
                $(xDiv).html(data);

                // -- ### - Cacher ces elements -- //
                $("#rMotif,.uMotif").css("display", "none");
				$('tr[class$=_h1]').css("display", "none");
                $('tr[id$=_h0]').css('cursor', 'pointer');
                
            },
            error: function (xhr) {                
                alert(JSON.stringify(xhr)); 
            }
        });
    }
}(jQuery));

var factSoutien_st;
(function ($) {
    factSoutien_st = function (id, Div){
        $.ajax({
            type : 'post',
            data: { Id: id, xOption:'Saisie' },
            url: '../sce_commercial/_fact_soutien_st.asp',
            dataType: 'html',
            cache: false,
            success: function (data) {
                $(Div).html(data);
            },
            error: function (xhr) {
                alert(JSON.stringify(xhr)); 
                //swal("Erreur interne au serveur !!!", "Reprendre l'opération. Si l'erreur persiste contacter l'administrateur !", "warning");
            }
        });
    }
}(jQuery));

var factSoutien_details_up;
(function ($) {
    factSoutien_details_up = function (id, xType){
        $.ajax({
            cache: false,
            type : 'post',
            dataType: 'json',
            url: '../all_user/_fs_liste_json.asp',
            data: { Id: id, xtype: xType, xOption:'Detail_FS' },                                    
            success: function (data) {
                var tr = '', table = '';
                table = '<table class="table table-hover">' +
                        '    <thead>' +
                        '        <th>#</th>' +
                        '        <th>N° FO1</th>' +
                        '        <th>Tx</th>' +
                        '        <th>Poids Fact</th>' +
                        '        <th>Montant</th>' +
                        '        <th>A Corriger</th>' +
                        '        <th></th>' +
                        '    </thead>';
                $.each(data, function(i,item){                    
                    if(item.FO1_ID != undefined){
                        tr += '<tr>' +
                                '<td>' + 
                                    '<label class="custom-control custom-checkbox">' + 
                                        '<input id="ck_' + i +'"  type="checkbox" class="custom-control-input" value="' + item.FO1_ID + '" />' + 
                                        '<span class="custom-control-label"></span>' + 
                                    '</label>'+ 
                                '</td>' +
                                '<td>' + item.NUM_FRC + '</td>' +
                                '<td>' + item.TAUXSOUT + '</td>' +
                                '<td>' + nbFormat(item.POIDSFACT, 0, ' ') + '</td>' +
                                '<td>' + nbFormat(item.MONTSOUT, 0, ' ') + '</td>' +
                                '<td><input type="text" id="Mt_' + i + '" value="' + item.MONTSOUT + '" disabled class="form-control" /></td>' +
                                '<td><input type="button" id="btn_' + i + '" value="OK" class="btn btn-success btn-sm" /></td>' +
                            '</tr>';
                    }

                    $('#wFrm').html(table + '<tbody>' + tr + '</tbody></table>');
                });
            },
            error: function (xhr) {                
                alert(JSON.stringify(xhr)); 
            }
        });
    }
}(jQuery));

var factSoutien_Up;
(function ($) {
    factSoutien_Up = function (id, mt){
        $.ajax({
            type : 'post',
            data: { Id: id, Mt: mt, xOption:'Up_FS' },
            url: '../sce_commercial/test.asp',
            dataType: 'json',
            cache: false,
            success: function (data) {
                var Err_Type = (data[0].Erreur > 0) ? 'success':'warning';                
                swal('Correction Facture',data[0].Err_Msg, Err_Type);            
            },
            error: function (xhr) {
                alert(JSON.stringify(xhr)); 
                //swal("Erreur interne au serveur !!!", "Reprendre l'opération. Si l'erreur persiste contacter l'administrateur !", "warning");
            }
        });
    }
}(jQuery));

var factSoutien_NumUp;
(function ($) {
    factSoutien_NumUp = function (id, ref){
        $.ajax({
            type : 'post',
            data: { Id: id, Mt:0, Num: ref, xOption:'Up_Num' },
            url: '../sce_commercial/test.asp',
            dataType: 'json',
            cache: false,
            success: function (data) {
                var Err_Type = (data[0].Erreur > 0) ? 'success':'warning';                
                swal('Correction Facture',data[0].Err_Msg, Err_Type);            
            },
            error: function (xhr) {
                alert(JSON.stringify(xhr)); 
                //swal("Erreur interne au serveur !!!", "Reprendre l'opération. Si l'erreur persiste contacter l'administrateur !", "warning");
            }
        });
    }
}(jQuery));
