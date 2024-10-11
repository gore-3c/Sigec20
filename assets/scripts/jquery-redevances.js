
var hn_redevance_liste;
(function ($) {
    hn_redevance_liste = function (Recolte, Produit, Parite, Div){
        $(Div).html('');
        $.ajax({
            cache: false,
            type : 'post',
            dataType: 'json',
            url: '../all_user/_hn_redevance_item.asp',
            data: { Recolte:Recolte, Produit:Produit, Parite:Parite, xOption:'liste' },                                    
            success: function (data) {
                var tr = '', table = '', wSpecial = '';
                table = '<table class="table table-hover">' +
                        '    <thead>' +
                        '        <th>#</th>' +
                        '        <th>Recolte</th>' +
                        '        <th>Produit</th>' +
                        '        <th>Regime</th>' +
                        '        <th>Type</th>' +
                        '        <th>Parite</th>' +
                        '        <th>Spécial</th>' +
                        '        <th>Date</th>' +
                        '        <th>Vigueur</th>' +
                        '        <th>Fiscalité</th>' +
                        '    </thead>';
                $.each(data, function(i,item){ 
                    if(item.REDV_ID != undefined){
                        wSpecial = (item.SPECIALE == 1) ? ' checked' : '';
                        tr += '<tr>' + 
                                '<td>' + (i + 1) + '</td>' +
                                '<td>' + item.RECOLTE + '</td>' +
                                '<td>' + item.PRODUIT + '</td>' +
                                '<td>' + item.REGIME + '</td>' +
                                '<td>' + item.TRANS_LIB + '</td>' +
                                '<td>' + item.PARITE + '</td>' +
                                '<td>' +
                                    '<label class="custom-control custom-checkbox">' + 
                                        '<input id="wk_' + i +'"  type="checkbox" class="custom-control-input" disabled ' + wSpecial + ' />' + 
                                        '<span class="custom-control-label"></span>' + 
                                    '</label>'+ 
                                '</td>' +
                                '<td>' + item.DATE_REDV + '</td>' +
                                '<td>' + item.VIGUEUR + '</td>' +
                                '<td><button type="button" id="' + item.REDV_ID + '" class="btn btn-primary btn-sm"><i class="fa fa-print"></i></button></td>' +                               
                            '</tr>';
                    }

                    $(Div).html(table + '<tbody>' + tr + '</tbody></table>');
                });
            },
            error: function (xhr) {                
                alert(JSON.stringify(xhr)); 
            }
        });
    }
}(jQuery));

var hn_affiche_redevances;
(function ($) {
    hn_affiche_redevances = function (Id, xDiv){
        $.ajax({
            cache: false,
            type : 'post',
            dataType: 'html',
            data:{ Id:Id },
            url: '../all_user/hn_affiche_redevances.asp',                                  
            success: function (data) {
                $(xDiv).html(data);                
            },
            error: function (xhr) {                
                alert(JSON.stringify(xhr)); 
            }
        });
    }
}(jQuery));

var _hn_redevances_new;
(function ($) {
    _hn_redevances_new = function (xDiv){
        $.ajax({
            cache: false,
            type : 'post',
            dataType: 'html',
            url: '../all_user/_hn_redevance_frm.asp',                                  
            success: function (data) {
                $(xDiv).html(data);                
            },
            error: function (xhr) {                
                alert(JSON.stringify(xhr)); 
            }
        });
    }
}(jQuery));

var _hn_redevances_maj;
(function ($) {
    _hn_redevances_maj = function (wFrm){
        alert($(wFrm).serialize());
        $.ajax({
            cache: false,
            type : 'post',
            dataType: 'json',
            data: $(wFrm).serialize(),
            url: '../all_user/_hn_redevance_frm.asp',                                  
            success: function (data) {
                var Err_Type = (data[0].Erreur > 0) ? 'success':'warning';
                swal('Saisie de redevances', data[0].Err_Msg, Err_Type);        
            },
            error: function (xhr) {
                swal('Saisie de redevances', JSON.stringify(xhr), 'warning');
            }
        });
    }
}(jQuery));

//#### - SIGEC4
var redevance_liste;
(function ($) {
    redevance_liste = function (Recolte, Produit, Parite, Div){
        $.ajax({
            cache: false,
            type : 'post',
            dataType: 'json',
            url: '../all_user/_redevance_item.asp',
            data: { Recolte:Recolte, Produit:Produit, Parite:Parite, xOption:'liste' },                                    
            success: function (data) {
                var tr = '', table = '', wSpecial = '';
                table = '<table class="table table-hover">' +
                        '    <thead>' +
                        '        <th>#</th>' +
                        '        <th>Période</th>' +
                        '        <th>Recolte</th>' +
                        '        <th>Produit</th>' +
                        '        <th>Regime</th>' +
                        '        <th>Type</th>' +
                        '        <th>Parite</th>' +
                        '        <th>Spécial</th>' +
                        '        <th>Vigueur</th>' +
                        '        <th>Différentiel</th>' +
                        '        <th>Fiscalité</th>' +
                        '    </thead>';
                $.each(data, function(i,item){                    
                    if(item.REDV_ID != undefined){
                        wSpecial = (item.SPECIALE == 1) ? ' checked' : '';
                        tr += '<tr>' + 
                                '<td>' + (i + 1) + '</td>' +
                                '<td>' + item.PER_REF + '</td>' +
                                '<td>' + item.RECOLTE + '</td>' +
                                '<td>' + item.PRODUIT + '</td>' +
                                '<td>' + item.REGIME + '</td>' +
                                '<td>' + item.TRANS_LIB + '</td>' +
                                '<td>' + item.PARITE + '</td>' +
                                '<td>' +
                                    '<label class="custom-control custom-checkbox">' + 
                                        '<input id="wk_' + i +'"  type="checkbox" class="custom-control-input" disabled ' + wSpecial + ' />' + 
                                        '<span class="custom-control-label"></span>' + 
                                    '</label>'+ 
                                '</td>' +
                                '<td>' + item.VIGUEUR + '</td>' +
                                '<td><button type="button" id="' + item.REVSOU_ID + '" class="btn btn-primary btn-sm">' + item.REVSOU_ID + '</button></td>' +  
                                '<td><button type="button" id="' + item.REDV_ID + '" class="btn btn-primary btn-sm"><i class="fa fa-print"></i></button></td>' +                               
                            '</tr>';
                    }

                    $(Div).html(table + '<tbody>' + tr + '</tbody></table>');
                });
            },
            error: function (xhr) {                
                alert(JSON.stringify(xhr)); 
            }
        });
    }
}(jQuery));

var affiche_redevances;
(function ($) {
    affiche_redevances = function (Id, xDiv){
        $.ajax({
            cache: false,
            type : 'post',
            dataType: 'html',
            data:{ Id:Id },
            url: '../all_user/affiche_redevances.asp',                                  
            success: function (data) {
                $(xDiv).html(data);                
            },
            error: function (xhr) {                
                alert(JSON.stringify(xhr)); 
            }
        });
    }
}(jQuery));

var _redevances_new;
(function ($) {
    _redevances_new = function (xDiv){
        $.ajax({
            cache: false,
            type : 'post',
            dataType: 'html',
            url: '../all_user/_redevance_frm.asp',                                  
            success: function (data) {
                $(xDiv).html(data);                
            },
            error: function (xhr) {                
                alert(JSON.stringify(xhr)); 
            }
        });
    }
}(jQuery));

var _redevances_maj;
(function ($) {
    _redevances_maj = function (wFrm){
        
        $.ajax({
            cache: false,
            type : 'post',
            dataType: 'json',
            data: $(wFrm).serialize(),
            url: '../all_user/_redevance_frm.asp',                                  
            success: function (data) {
                var Err_Type = (data[0].Erreur > 0) ? 'success':'warning';
                swal('Saisie de redevances', data[0].Err_Msg, Err_Type);    
            },
            error: function (xhr) {
                swal('Saisie de redevances', JSON.stringify(xhr), 'warning');
            }
        });
    }
}(jQuery));

var differentiel_liste;
(function ($) {
    differentiel_liste = function (Recolte, Produit, Parite, Div){
        $.ajax({
            cache: false,
            type : 'post',
            dataType: 'json',
            url: '../all_user/_differentiel_item.asp',
            data: { Recolte:Recolte, Prdt:Produit, Parite:Parite, xOption:'Liste' }, 
            success: function (data) {
                var tr = '', table = '';
                table = '<table class="table table-hover">' +
                        '    <thead>' +
                        '        <th>#</th>' +
                        '        <th>Campagne</th>' +
                        '        <th>Recolte</th>' +
                        '        <th>Période</th>' +
                        '        <th>Parite</th>' +
                        '        <th>Prix CAF</th>' +
                        '        <th>Date</th>' +
                        '        <th>Différentiel</th>' +
                        '    </thead>';
                $.each(data, function(i,item){                    
                    if(item.REVSOU_ID != undefined){
                        tr += '<tr>' + 
                                '<td>' + (i + 1) + '</td>' +
                                '<td>' + item.CAMPAGNE + '</td>' +
                                '<td>' + item.RECOLTE + '</td>' +
                                '<td>' + item.PERIODE + '</td>' +
                                '<td>' + item.PARITE + '</td>' +
                                '<td>' + item.CAF_REF + '</td>' +
                                '<td>' + item.DT_DIFF + '</td>' +
                                '<td><button type="button" id="' + item.REVSOU_ID + '" class="btn btn-primary btn-sm">' + item.REVSOU_ID + '</button></td>' + 
                            '</tr>';
                    }

                    $(Div).html(table + '<tbody>' + tr + '</tbody></table>');
                });
            },
            error: function (xhr) {                
                alert(JSON.stringify(xhr)); 
            }
        });
    }
}(jQuery));

var GetDifferentiels;
(function ($) {
    GetDifferentiels = function (Recolte, Produit, Parite, Option, Div){
        $.ajax({
            cache: false,
            type : 'post',
            dataType: 'json',
            url: '../all_user/_differentiel_item.asp',
            data: { Recolte:Recolte, Prdt:Produit, Parite:Parite, xOption:Option }, 
            success: function (data) {
                var tr = '', table = '';
                table = '<table class="table table-hover">' +
                        '    <thead>' +
                        '        <th>#</th>' +
                        '        <th>Campagne</th>' +
                        '        <th>Recolte</th>' +
                        '        <th>Période</th>' +
                        '        <th>Parite</th>' +
                        '        <th>Prix CAF</th>' +
                        '        <th>Date</th>' +
                        '        <th>Operateur</th>' +                        
                        '        <th>-</th>' +
                        '    </thead>';
                $.each(data, function(i,item){                    
                    if(item.REVSOU_ID != undefined){
                        tr += '<tr>' + 
                                '<td>' + (i + 1) + '</td>' +
                                '<td>' + item.CAMPAGNE + '</td>' +
                                '<td>' + item.RECOLTE + '</td>' +
                                '<td>' + item.PERIODE + '</td>' +
                                '<td>' + item.PARITE + '</td>' +
                                '<td>' + item.CAF_REF + '</td>' +
                                '<td>' + item.DT_DIFF + '</td>' +
                                '<td>' + item.TRANS_LIB + '</td>' +                                
                                '<td><button type="button" id="' + item.REVSOU_ID + '" class="btn btn-primary btn-sm"><i class="fa fa-print"></i></button></td>' +   
                            '</tr>';
                    }

                    $(Div).html(table + '<tbody>' + tr + '</tbody></table>');
                });
            },
            error: function (xhr) {                
                alert(JSON.stringify(xhr)); 
            }
        });
    }
}(jQuery));

var _differentiel_new;
(function ($) {
    _differentiel_new = function (xDiv){

        $.ajax({
            cache: false,
            type : 'post',
            dataType: 'html',
            url: '../all_user/_differentiel_frm.asp',                                  
            success: function (data) {
                $(xDiv).html(data);                
            },
            error: function (xhr) {                
                alert(JSON.stringify(xhr)); 
            }
        });
    }
}(jQuery));

var _differentiel_maj;
(function ($) {
    _differentiel_maj = function (wFrm){ 
        $.ajax({
            cache: false,
            type : 'post',
            dataType: 'json',
            data: $(wFrm).serialize(),
            url: '../all_user/_differentiel_frm.asp',                                  
            success: function (data) {
                var Err_Type = (data[0].Erreur > 0) ? 'success':'warning';
                swal('Saisie de différentiel', data[0].Err_Msg, Err_Type);                
            },
            error: function (xhr) {
                swal('Saisie de différentiel', JSON.stringify(xhr), 'warning');
            }
        });
    }
}(jQuery));

var Combo_Diff;
(function ($) {
    Combo_Diff = function (wCamp, wRclt, wPrdt, wRegime, wTypeOp, wParite, wDiv, Default = 0){
        var options = '<option value="0"> CODE DIFF - CAF_REF - PERIODE </option>';                
        $('#xLoad').html('<img src="../assets/images/loader.gif" class="img-fluid" alt="" />');
        $.ajax({
            cache: false,
            type : 'post',
            dataType: 'json',
            data: {Camp: wCamp, Rclt: wRclt, Prdt: wPrdt, Regime: wRegime, TypeOp:wTypeOp, Parite: wParite, xOption: 'Liste'},
            url: '../all_user/_differentiel_item.asp',                                  
            success: function (data) {
                $.each(data, function (i, item) {
                    if(item.REVSOU_ID != undefined){
                        if (Default == item.REVSOU_ID) {
                            options += '<option value="' + item.REVSOU_ID + '" selected="selected">[' + item.REVSOU_ID + '] - [' + item.CAF_REF + '] - [' + item.PERIODE + ' ' + item.CAMPAGNE + '] </option>';
                        } else {
                            options += '<option value="' + item.REVSOU_ID + '">[' + item.REVSOU_ID + '] - [' + item.CAF_REF + '] - [' + item.PERIODE + ' ' + item.CAMPAGNE + '] </option>';
                        }
                    }  
                });
                $(wDiv).html(options);
                $('#xLoad').html('');             
            },
            error: function (xhr) {
                swal('Saisie de différentiel', JSON.stringify(xhr), 'warning');
            }
        });
    }
}(jQuery));

// ### - DIFFERENTIEL MIXTE

var FormulaireSaisieRedevancesMixtes;
(function ($) {
    FormulaireSaisieRedevancesMixtes = function (xDiv){
        $.ajax({
            cache: false,
            type : 'post',
            dataType: 'html',
            url: '../all_user/_redevance_mixte_frm.asp',
            success: function (data) {
                $(xDiv).html(data);                
            },
            error: function (xhr) {                
                alert(JSON.stringify(xhr)); 
            }
        });
    }
}(jQuery));

var differentiel_mixte_liste;
(function ($) {
    differentiel_mixte_liste = function (Recolte, Produit, Parite, Div){
        $.ajax({
            cache: false,
            type : 'post',
            dataType: 'json',
            url: '../all_user/_differentiel_mixte_item.asp',
            data: { Recolte:Recolte, Prdt:Produit, Parite:Parite, xOption:'Liste' }, 
            success: function (data) {
                var tr = '', table = '';
                table = '<table class="table table-hover">' +
                        '    <thead>' +
                        '        <th>#</th>' +
                        '        <th>Campagne</th>' +
                        '        <th>Recolte</th>' +
                        '        <th>Période</th>' +
                        '        <th>Parite</th>' +
                        '        <th>Prix CAF</th>' +
                        '        <th>Date</th>' +
                        '        <th>Différentiel</th>' +
                        '    </thead>';
                $.each(data, function(i,item){                    
                    if(item.REVSOU_ID != undefined){
                        tr += '<tr>' + 
                                '<td>' + (i + 1) + '</td>' +
                                '<td>' + item.CAMPAGNE + '</td>' +
                                '<td>' + item.RECOLTE + '</td>' +
                                '<td>' + item.PERIODE + '</td>' +
                                '<td>' + item.PARITE + '</td>' +
                                '<td>' + item.CAF_REF + '</td>' +
                                '<td>' + item.DT_DIFF + '</td>' +
                                '<td><button type="button" id="' + item.REVSOU_ID + '" class="btn btn-primary btn-sm">' + item.REVSOU_ID + '</button></td>' + 
                            '</tr>';
                    }

                    $(Div).html(table + '<tbody>' + tr + '</tbody></table>');
                });
            },
            error: function (xhr) {                
                alert(JSON.stringify(xhr)); 
            }
        });
    }
}(jQuery));

var _differentiel_mixte_new;
(function ($) {
    _differentiel_mixte_new = function (xDiv){

        $.ajax({
            cache: false,
            type : 'post',
            dataType: 'html',
            url: '../all_user/_differentiel_mixte_frm.asp',                                  
            success: function (data) {
                $(xDiv).html(data);                
            },
            error: function (xhr) {                
                alert(JSON.stringify(xhr)); 
            }
        });
    }
}(jQuery));

var _differentiel_mixte_maj;
(function ($) {
    _differentiel_mixte_maj = function (wFrm){ 
        $.ajax({
            cache: false,
            type : 'post',
            dataType: 'json',
            data: $(wFrm).serialize(),
            url: '../all_user/_differentiel_mixte_frm.asp',                                  
            success: function (data) {
                var Err_Type = (data[0].Erreur > 0) ? 'success':'warning';
                swal('Saisie de différentiel', data[0].Err_Msg, Err_Type);                
            },
            error: function (xhr) {
                swal('Saisie de différentiel', JSON.stringify(xhr), 'warning');
            }
        });
    }
}(jQuery));

var ComboRedevancesMixte;
(function ($) {
    ComboRedevancesMixte = function (Prdt, TypeOp, RcltStock, PariteStock, wDiv, Default = 0){
        var options = '<option value="0"> REDEVANCES </option>';                
        $('#xLoad').html('<img src="../assets/images/loader.gif" class="img-fluid" alt="" />');
        $.ajax({
            cache: false,
            type : 'post',
            dataType: 'json',
            data: {Prdt:Prdt, TypeOp:TypeOp, Rclt:RcltStock, Parite:PariteStock, xOption: 'Redevance'},
            url: '../all_user/_redevance_mixte_item.asp',                                  
            success: function (data) {
                $.each(data, function (i, item) { 
                    if(item.REDV_ID != undefined){
                        options += '<option value="' + item.REDV_ID + '">' + item.RECOLTE + '/' + item.PARITE + ' </option>'; 
                    }
                });
                $(wDiv).html(options);
                $('#xLoad').html('');             
            },
            error: function (xhr) {
                swal('Saisie de différentiel', JSON.stringify(xhr), 'warning');
            }
        });
    }
}(jQuery));