/* ############## - Gestion des exportateurs  - ############################### */
var Exportateur_liste;
(function ($) {
    Exportateur_liste = function (id, camp, xOption, xDiv){
        $("#global-loader").fadeOut("slow");
        $(xDiv).bootstrapTable('destroy');
        $.ajax({
            type : 'post',
            cache: false,
            dataType: 'json',
            url: '../all_user/_exportateur_item.asp',
            data: { Exp: id, Camp: camp, xOption: xOption},
            success: function (data) {

                var xdata = [], Lien = '', vAgrer = 0;   
                $.each(data, function(i,item){
                    if(item.ID_EXP != undefined){
                        if(xOption == 'ExpAgree'){
                            Lib = "";
                            vAgree = 0;
                            Lien = '<button name="' + vAgrer + '" class="btn btn-sm btn-primary" data-toggle="modal" data-target="#FrmModal">Activer</button>';
                            if(item.V_AGREE == true){
                                vAgree = 1;
                                Lib = '<span class="text-danger">Suspendu</span>';
                                Lien = '<button name="' + item.ID_EXP + '" class="btn btn-sm btn-warning" data-toggle="modal" data-target="#FrmModal">Suspendre</button>';
                            }
                        }
                        if(xOption == 'ExpNonAgree'){
                            vAgrer = 0;
                            Lien = '<button name="' + vAgrer + '" class="btn btn-sm btn-primary">Agréer</button>';
                        }
                        var otem = {};
                        otem['i'] = (i + 1);
                        otem['Num'] = item.ID_EXP;
                        otem['Nom'] = '<a class="wEdit" href="' + (item.ID_EXP*365) + '" data-toggle="modal" data-target="#wEdit">' + item.NOM + '</a>';
                        otem['Dg'] = (item.EXPORTATEUR.length < 25) ? item.EXPORTATEUR : item.EXPORTATEUR.substr(0,25) + ' ...' ;
                        otem['Statut'] = item.STATUT;
                        otem['CC'] = item.CONTRIBUABLE;
                        otem['TypExp'] = item.TYPE_EXP;
                        otem['Lien'] = Lien;
                        xdata.push(otem);
                    }
                });

                $(xDiv).bootstrapTable('destroy');
                $(xDiv).bootstrapTable({
                    data: xdata,
                    pagination: false,
                    height:450,
                    search: true,                    
                    columns: [                        
                        {field: 'i',title: '#'}, 
                        {field: 'Num',title: 'Code', sortable:true},
                        {field: 'Nom',title: 'Exportateur', sortable:true},                         
                        {field: 'Dg',title: 'Nom complet'}, 
                        {field: 'CC',title: 'C Contribuable'},
                        {field: 'Statut',title: 'Statut'}, 
                        {field: 'TypExp',title: 'Type'},
                        {field: 'Lien',title: ' # ', align:"center"}                        
                    ]
                });
            },
            error: function (xhr) {  
                alert(JSON.stringify(xhr)); 
                swal("Erreur interne au serveur !!!", "Reprendre l'opération. Si l'erreur persiste contacter l'administrateur !", "warning");
            }
        });
    }
}(jQuery));

/* ############## - Gestion des agréments  - ############################### */
var vAgrement;
(function ($) {
    vAgrement = function (wExp, wCamp){
        $.ajax({
            type : 'post',
            data: { Exp: wExp, Camp:wCamp, xOption:'vAgree' },
            url: '../all_user/_exp_agrement_up.asp',
            dataType: 'json',
            cache: false,
            success: function (data) {
                var Err_Type = (data[0].Erreur > 0) ? 'success':'warning';
                swal('Agrément exportateur', data[0].Err_Msg, Err_Type);
                //Exportateur_liste (0, 1, wCamp, '', '', 'ExpNonAgree', '#wData');                
            },
            error: function (xhr) {
                alert(JSON.stringify(xhr)); 
                //swal("Erreur interne au serveur !!!", "Reprendre l'opération. Si l'erreur persiste contacter l'administrateur !", "warning");
            }
        });
    }  
}(jQuery));

var vSuspension;
(function ($) {
    vSuspension = function (wExp, wMotif){
        $.ajax({
            type : 'post',
            data: { Exp: wExp, Motif:wMotif, xOption:'vSuspension' },
            url: '../all_user/_exp_agrement_up.asp',
            dataType: 'json',
            cache: false,
            success: function (data) {
                var Err_Type = (data[0].Erreur > 0) ? 'success':'warning';
                swal('Agrément exportateur',data[0].Err_Msg,Err_Type);
                window.location.replace("../sce_commercial/exp_agrement.asp");
            },
            error: function (xhr) {                
                swal("Erreur interne au serveur !!!", "Reprendre l'opération. Si l'erreur persiste contacter l'administrateur !", "warning");
            }
        });
    }  
}(jQuery));

var _exportateur_new;
(function ($) {
    _exportateur_new = function (xDiv){
        $.ajax({
            cache: false,
            type : 'post',
            dataType: 'html',
            url: '../all_user/_exp_creation.asp',                                  
            success: function (data) {
                $(xDiv).html(data);                
            },
            error: function (xhr) {                
                alert(JSON.stringify(xhr)); 
            }
        });
    }
}(jQuery));

var _exportateur_maj;
(function ($) {
    _exportateur_maj = function (){
        $.ajax({
            type : 'post',
            data: $('#FrmExp').serialize(),
            url: '../all_user/_exp_creation.asp',
            dataType: 'json',
            cache: false,
            success: function (data) {
                var Err_Type = 'warning';
                if(data[0].Erreur > 0){
                    Err_Type = 'success';
                    //window.location.replace("../sce_commercial/exp_agrement.asp");
                }
                swal('Agrément exportateur', data[0].Err_Msg, Err_Type);                
            },
            error: function (xhr) {
                //alert(JSON.stringify(xhr));
                swal("Erreur interne au serveur !!!", "Reprendre l'opération. Si l'erreur persiste contacter l'administrateur !", "warning");
            }
        });
    }  
}(jQuery));
/*

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

var soit_transmis_liste;
(function ($) {
    soit_transmis_liste = function (id, xType, zone, rZone, xOption, xDiv){
        $("#global-loader").fadeOut("slow");
        $.ajax({
            type : 'post',
            cache: false,
            dataType: 'json',
            url: '../all_user/_fs_soit_transmis.asp',            
            data: { Id: id, xtype: xType, Zone:zone, rZone: rZone, xOption: xOption},
            success: function (data) {

                var xdata = [], Lien = '', Url = '';
                
                $.each(data, function(i,item){

                    //Url = Afficher("Voir_Soit-T", "../all_print/affiche_st_accord.asp' + item.Url + '", 100, 100, 500, 500, 0, 0, 0, 1, 1);
                    switch(xType){
                        case 'Traiter' : Lien = '<a class="btn btn-primary btn-sm" href="' + xType + '?' + (item.ID*365) + '"><i class="fa fa-edit"></i></a>'; break;                        
                        case 'Liste' : Lien = '<a class="btn btn-primary btn-sm" href="#' + (item.ID*365) + '"><i class="fa fa-edit"></i></a>'; break;
                        case 'ListeUp' : Lien = '<button type="button" id="' + item.ID + '" class="btn btn-sm"><i class="fa fa-edit"></i></button>'; break;
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
                    //'<a class="wEdit" href="' + (item.ID*365) + '" data-toggle="modal" data-target="#wEdit">' + item.REF + '</a>';
                    if(item.ID != undefined){
                        var otem = {};
                        otem['i'] = (i + 1);                        
                        otem['Ref'] = '<a href="../all_print/affiche_st_accord.asp?' + item.Url + '">' + item.REF + '</a>';
                        otem['Dt'] = item.DT;
                        otem['Nom'] = (item.NOM.length < 10) ? item.NOM : item.NOM.substr(0,9) + ' ...' ;
                        otem['Lien'] = '<a href="../all_print/affiche_st_accord.asp?' + item.Url + '"><img src="../assets/images/print.gif" /></a>';
                        otem['Camp'] = item.CAMPAGNE;
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
                        {field: 'Ref',title: 'Reférence'}, 
                        {field: 'Dt',title: 'Date', sortable:true}, 
                        {field: 'Nom',title: 'Exportateur'},
                        {field: 'Camp',title: 'Campagne'},
                        {field: 'Lien',title: ' # ', align:"center"}                        
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
*/