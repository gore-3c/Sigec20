var ListeCVDeblocagesNonVisible;
(function ($) {
    ListeCVDeblocagesNonVisible = function (xDiv){
        $('#loading').html('<img src="../assets/images/loader.gif" class="img-fluid" alt="" />');
        $.ajax({
            type : 'post',
            cache: false,
            dataType: 'json',
            url: '../all_user/_cv_non_visibles.asp',
            data: { xOption: 'Liste', Choix_Enr: '0'},
            success: function (data) { 

                var xdata = [];                
                $.each(data, function(i,item){
                    if(item.CV_ID != undefined){
                        var otem = {};
                        otem['i'] = (i + 1);                        
                        otem['Num'] = item.CV_NUMCONTRAT;
                        otem['Per'] = item.PERIODE;
                        otem['Dt'] = item.CV_DATE;
                        otem['Pdt'] = item.PRODUIT;
                        otem['Prix'] = item.CV_PRIX_CAF;
                        otem['Diff'] = item.DIFF;
                        otem['Drd'] = item.DRD;
                        otem['Qte'] = nbFormat(item.CV_TONNAGE, 0, ' ');
                        otem['Exp'] = (item.NOM.length < 20) ? item.NOM : item.NOM.substr(0,19) + ' ...' ;
                        otem['Lien'] = '<input type="checkbox" name="Id_' + item.CV_ID + '" id="Id_' + item.CV_ID + '" value="' + item.CV_ID + '" />';
                        xdata.push(otem);
                    }
                });

                $('#loading').html(''); 
                $(xDiv).bootstrapTable('destroy');
                $(xDiv).bootstrapTable({
                    data: xdata,
                    pagination: false,
                    search: true,
                    height:450,
                    columns: [
                        {field: 'i',title: '#'},
                        {field: 'Num',title: 'Numero'},
                        {field: 'Per',title: 'Periode'},
                        {field: 'Prix',title: 'Prix CAF'},
                        {field: 'Diff',title: 'Diff'},
                        {field: 'Drd',title: 'DRD'},
                        {field: 'Pdt',title: 'Produit'},
                        {field: 'Dt',title: 'Date', sortable:true}, 
                        {field: 'Qte',title: 'Tonnage', sortable:true}, 
                        {field: 'Exp',title: 'Exporateur', sortable:true},
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
var ImporterCvNonVisible;
(function ($) {

    ImporterCvNonVisible = function (Id){
        $.ajax({
            cache: false,
            type : 'post',
            dataType: 'json',
            url: '../all_user/_cv_non_visibles.asp',
            data: { Id:Id, Choix_Enr:'1' },
            success: function (data) { 
                var Err_Type = (data[0].Erreur == 1) ? 'success':'warning';
                var Err_Msg = (data[0].Erreur == 1) ? 'Imoprter CV non visibles' : data[0].Err_Msg;
                if(data[0].Erreur == 1){ window.location.href = '../sce_commercial/cv_deblocages_non_visible.asp'; }
                else { swal("Imoprter CV non visibles", Err_Msg, Err_Type); }
            },
            error: function (xhr) {                
                alert(JSON.stringify(xhr)); 
            }
        });
    }
}(jQuery));

var ListeCDCNonVisible;
(function ($) {
    ListeCDCNonVisible = function (xDiv){
        $('#loading').html('<img src="../assets/images/loader.gif" class="img-fluid" alt="" />');
        $.ajax({
            type : 'post',
            cache: false,
            dataType: 'json',
            url: '../all_user/_cv_non_visibles.asp',
            data: { xOption:'Execution', Choix_Enr: '0'},
            success: function (data) { 

                var xdata = [];                
                $.each(data, function(i,item){
                    if(item.CDC_ID != undefined){
                        var otem = {};
                        otem['i'] = (i + 1);                        
                        otem['Num'] = item.CDC_CGFCC;
                        otem['Per'] = item.PERIODE;
                        otem['Dt'] = item.DATE_CDC;
                        otem['Prix'] = item.PRIX_CAF;
                        otem['Redev'] = item.REDV_ID;
                        otem['Rev'] = item.REVSOU_ID;
                        otem['Qte'] = nbFormat(item.NET, 0, ' ');
                        otem['Exp'] = (item.NOM.length < 20) ? item.NOM : item.NOM.substr(0,19) + ' ...' ;
                        xdata.push(otem);
                    }
                });

                $('#loading').html(''); 
                $(xDiv).bootstrapTable('destroy');
                $(xDiv).bootstrapTable({
                    data: xdata,
                    pagination: false,
                    search: true,
                    height:450,
                    columns: [
                        {field: 'i',title: '#'},
                        {field: 'Num',title: 'Numero'},
                        {field: 'Per',title: 'Periode'},
                        {field: 'Prix',title: 'Prix CAF'},
                        {field: 'Redev',title: 'Redevance'},
                        {field: 'Rev',title: 'Diff'},
                        {field: 'Dt',title: 'Date', sortable:true}, 
                        {field: 'Qte',title: 'Tonnage', sortable:true}, 
                        {field: 'Exp',title: 'Exporateur', sortable:true}
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

var form_Chq_transfert_SYGESAP;
(function ($) {
    form_Chq_transfert_SYGESAP = function (id, dt, fo1, xDiv){
        $.ajax({
            type : 'post',
            cache: false,
            dataType: 'html',
            url: '../all_user/_transfert_sygesap.asp',
            data: { Id:id, Dt:dt, Num:fo1, xChoix: '0'},
            success: function (data) { 
                $(xDiv).html(data);
            },
            error: function (xhr) {  
                alert(JSON.stringify(xhr));           
                //swal("Erreur interne au serveur !!!", "Reprendre l'opération. Si l'erreur persiste contacter l'administrateur !", "warning");
            }
        });
    }
}(jQuery));

var transfet_cheq_SYGESAP;
(function ($) {
    transfet_cheq_SYGESAP = function (fo1, taxe){
        $.ajax({
            cache: false,
            type : 'post',
            dataType: 'json',
            url: '../all_user/_transfert_sygesap.asp',
            data: { Fo1:fo1, Strct: taxe, xChoix:1 },
            success: function (data) { 
                var Err_Type = (data[0].Erreur == 1) ? 'success':'warning';
                var Err_Msg = (data[0].Erreur == 1) ? 'Correction validée' : data[0].Err_Msg;
                if(data[0].Erreur == 1){ window.location.href = '../all_user/transfert_sygesap.asp'; }
                else { swal("Correction de chèques", Err_Msg, Err_Type); }
            },
            error: function (xhr) {                
                alert(JSON.stringify(xhr)); 
            }
        });
    }
}(jQuery));

var cv_sans_soutien;
(function ($) {
    cv_sans_soutien = function (zone, xDiv){
        $.ajax({
            cache: false,
            type : 'post',
            dataType: 'html',
            url: '../all_user/_cv_sans_soutien.asp',
            data: { Cv:zone, Choix_Enr:2 },
            success: function (xdata) {
                    $(xDiv).html(xdata);
            },
            error: function (xhr) {                
                alert(JSON.stringify(xhr)); 
            }
        });
    }
}(jQuery));
var cv_sans_soutien_up;
(function ($) {
    cv_sans_soutien_up = function (id){
        $.ajax({
            cache: false,
            type : 'post',
            dataType: 'json',
            url: '../all_user/_cv_sans_soutien.asp',
            data: { Id:id, Choix_Enr:1 },
            success: function (data) { 
                alert(JSON.stringify(data));
                var Err_Type = (data[0].Erreur == 1) ? 'success':'warning';
                var Err_Msg = (data[0].Erreur == 1) ? 'Traitement validé' : data[0].Err_Msg;

                if(data[0].Erreur == 1){ window.location.href = '../all_user/cv_sans_soutien.asp'; }
                else { swal("CV Sans Soutien", Err_Msg, Err_Type);  }
            },
            error: function (xhr) {                
                alert(JSON.stringify(xhr)); 
            }
        });
    }
}(jQuery));

var cv_chgt_parite;
(function ($) {
    cv_chgt_parite = function (zone, xDiv){
        $.ajax({
            cache: false,
            type : 'post',
            dataType: 'html',
            url: '../all_user/_cv_chgt_parite.asp',
            data: { Cv:zone, Choix_Enr:2 },
            success: function (xdata) {
                    $(xDiv).html(xdata);
            },
            error: function (xhr) {                
                alert(JSON.stringify(xhr)); 
            }
        });
    }
}(jQuery));
var cv_chgt_parite_up;
(function ($) {
    cv_chgt_parite_up = function (id, Cdc){
        $.ajax({
            cache: false,
            type : 'post',
            dataType: 'json',
            url: '../all_user/_cv_chgt_parite.asp',
            data: { Id:id, Cv: Cdc, Choix_Enr:1 },
            success: function (data) {
                var Err_Type = (data[0].Erreur == 1) ? 'success':'warning';
                var Err_Msg = (data[0].Erreur == 1) ? 'Traitement validé' : data[0].Err_Msg;
                if(data[0].Erreur == 1){ window.location.href = '../all_user/cv_chgt_parite.asp'; }
                else { swal("Changement de parité", Err_Msg, Err_Type);  }
            },
            error: function (xhr) {                
                alert(JSON.stringify(xhr)); 
            }
        });
    }
}(jQuery));

var cv_sans_decote;
(function ($) {
    cv_sans_decote = function (zone, xDiv){
        $.ajax({
            cache: false,
            type : 'post',
            dataType: 'html',
            url: '../all_user/_cv_sans_decote.asp',
            data: { Cv:zone, Choix_Enr:2 },
            success: function (xdata) {
                    $(xDiv).html(xdata);
            },
            error: function (xhr) {                
                alert(JSON.stringify(xhr)); 
            }
        });
    }
}(jQuery));
var cv_sans_decote_up;
(function ($) {
    cv_sans_decote_up = function (id){
        $.ajax({
            cache: false,
            type : 'post',
            dataType: 'json',
            url: '../all_user/_cv_sans_decote.asp',
            data: { Id:id, Choix_Enr:1 },
            success: function (data) {
                var Err_Type = (data[0].Erreur == 1) ? 'success':'warning';
                var Err_Msg = (data[0].Erreur == 1) ? 'Traitement validé' : data[0].Err_Msg;
                if(data[0].Erreur == 1){ window.location.href = '../all_user/cv_sans_decote.asp'; }
                else { swal("CV Sans Décote", Err_Msg, Err_Type); }
            },
            error: function (xhr) {                
                alert(JSON.stringify(xhr)); 
            }
        });
    }
}(jQuery));

var dus_up_form;
(function ($) {
    dus_up_form = function (zone, rZone, xType, xDiv){
        $.ajax({
            cache: false,
            type : 'post',
            dataType: 'html',
            url: '../all_user/_dus_up.asp',
            data: { Zone:zone, rZone: rZone, xType:xType,Choix_Enr:2 },
            success: function (xdata) {
                    $(xDiv).html(xdata);
            },
            error: function (xhr) {                
                alert(JSON.stringify(xhr)); 
            }
        });
    }
}(jQuery));

var dus_up;
(function ($) {
    dus_up = function (id, xtype, mt){
        $.ajax({
            cache: false,
            type : 'post',
            dataType: 'json',
            url: '../all_user/_dus_up.asp',
            data: { Id:id, Mt: mt, xType:xtype, Choix_Enr:1 },
            success: function (data) {
                var Err_Type = (data[0].Erreur == 1) ? 'success':'warning';
                var Err_Msg = (data[0].Erreur == 1) ? 'Correction validée' : data[0].Err_Msg;
                if(data[0].Erreur == 1){ window.location.href = '../all_user/dus_up.asp'; }
                else { swal("Correction DUS", Err_Msg, Err_Type); }
            },
            error: function (xhr) {                
                alert(JSON.stringify(xhr)); 
            }
        });
    }
}(jQuery));

var cv_cession;
(function ($) {
    cv_cession = function (Cdc, xDiv){
        $.ajax({
            cache: false,
            type : 'post',
            dataType: 'html',
            url: '../all_user/_cv_cession.asp',
            data: { Cdc:Cdc, Choix_Enr:2 },
            success: function (xdata) {
                    $(xDiv).html(xdata);
            },
            error: function (xhr) {                
                alert(JSON.stringify(xhr)); 
            }
        });
    }
}(jQuery));
var cv_cession_up;
(function ($) {
    cv_cession_up = function (Enr_id, Exp, Dt, Ref){
        $.ajax({
            cache: false,
            type : 'post',
            dataType: 'json',
            url: '../all_user/_cv_cession.asp',
            data: { Id:Enr_id, Exp:Exp, Dt:Dt, Ref:Ref, Choix_Enr:1 },
            success: function (data) {
                var Err_Type = (data[0].Erreur == 1) ? 'success':'warning';
                var Err_Msg = (data[0].Erreur == 1) ? 'Traitement validé' : data[0].Err_Msg;
                if(data[0].Erreur == 1){ window.location.href = '../sce_commercial/cv_cession.asp'; }
                else { swal("Cession de contrat", Err_Msg, Err_Type);  }
            },
            error: function (xhr) {
                alert(JSON.stringify(xhr)); 
            }
        });
    }
}(jQuery));

var cv_PrixCafEmb;
(function ($) {
    cv_PrixCafEmb = function (Cdc, xDiv){
        $.ajax({
            cache: false,
            type : 'post',
            dataType: 'html',
            url: '../all_user/_cv_PrixCafEmb_up.asp',
            data: { Cdc:Cdc, Choix_Enr:2 },
            success: function (xdata) {
                    $(xDiv).html(xdata);
            },
            error: function (xhr) {                
                alert(JSON.stringify(xhr)); 
            }
        });
    }
}(jQuery));
var cv_PrixCafEmb_up;
(function ($) {
    cv_PrixCafEmb_up = function (id, Caf, Emb){
        $.ajax({
            cache: false,
            type : 'post',
            dataType: 'json',
            url: '../all_user/_cv_PrixCafEmb_up.asp',
            data: { Id:id, Caf:Caf, Emb:Emb, Choix_Enr:1 },
            success: function (data) {
                var Err_Type = (data[0].Erreur == 1) ? 'success':'warning';
                var Err_Msg = (data[0].Erreur == 1) ? 'Traitement validé' : data[0].Err_Msg;
                if(data[0].Erreur == 1){ window.location.href = '../sce_commercial/cv_PrixCafEmb_up.asp'; }
                else { swal("Correction Prix CAF/EMB", Err_Msg, Err_Type);  }
            },
            error: function (xhr) {                
                alert(JSON.stringify(xhr)); 
            }
        });
    }
}(jQuery));
