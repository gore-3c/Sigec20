/* ############## - Gestion des contrats  - ############################### */
var ComboListe;
(function ($) {
    ComboListe = function (Default, Id, wId, xoption, Div, Libelle){ 
        var options = '<option value="0"> ' + Libelle + ' </option>';                
        $('#xLoad').html('<img src="../assets/images/loader.gif" class="img-fluid" alt="" />');
        $.ajax({
            type: 'POST',
            dataType: 'json',
            url: '../all_user/_select_list.asp',
            data: { Id: Id, Prdt: wId, xOption: xoption },
            success: function (data) {
                $.each(data, function (i, item) {
                    if(item.Id != undefined){
                        if (Default == item.Id) {
                            options += '<option value="' + item.Id + '" selected="selected">' + item.Libelle + '</option>';
                        } else {
                            options += '<option value="' + item.Id + '">' + item.Libelle + '</option>';
                        }
                    }
                });
                $(Div).html(options);
                $('#xLoad').html('');
            },
            error: function (xhr) {
                alert(JSON.stringify(xhr));
                //swal("Erreur interne au serveur !!!", "Reprendre l'opération. Si l'erreur persiste contacter l'administrateur !", "warning");
            }
        });
    } 
}(jQuery));


var ComboFrmRedevances;
(function ($) {
    ComboFrmRedevances = function (Id, Div){ 
        var tr = '<tr><td colspan="3">Aucune ligne trouvée</td></tr>';                
        $('#xLoad').html('<img src="../assets/images/loader.gif" class="img-fluid" alt="" />');
        $.ajax({
            type: 'POST',
            dataType: 'json',
            url: '../all_user/_select_list.asp',
            data: { Id:0, Prdt:Id, xOption:'CboFiscalites' },
            success: function (data) {
                tr = '';
                $.each(data, function (i, item) {
                    tr += '<tr><td>' + item.Id + '</td><td>' + item.Libelle + '</td><td><input type="text" maxlength="6" name="wTaxe_' + item.Id + '" id="wTaxe_' + item.Id + '" class="form-control" /> </td></tr>';
                });
                $(Div).html(tr);
                $('#xLoad').html('');
            },
            error: function (xhr) {
                alert(JSON.stringify(xhr));
                //swal("Erreur interne au serveur !!!", "Reprendre l'opération. Si l'erreur persiste contacter l'administrateur !", "warning");
            }
        });
    } 
}(jQuery));

var ComboFrmRedevancesHN;
(function ($) {
    ComboFrmRedevancesHN = function (Id, Div){ 
        var tr = '<tr><td colspan="3">Aucune ligne trouvée</td></tr>';                
        $('#xLoad').html('<img src="../assets/images/loader.gif" class="img-fluid" alt="" />');
        $.ajax({
            type: 'POST',
            dataType: 'json',
            url: '../all_user/_select_list.asp',
            data: { Id:0, Prdt:Id, xOption:'CboFiscalitesHN' },
            success: function (data) {
                tr = '';
                $.each(data, function (i, item) {
                    tr += '<tr><td>' + item.Id + '</td><td>' + item.Libelle + '</td><td><input type="text" maxlength="6" name="wTaxe_' + item.Id + '" id="wTaxe_' + item.Id + '" class="form-control" /> </td></tr>';
                });
                $(Div).html(tr);
                $('#xLoad').html('');
            },
            error: function (xhr) {
                alert(JSON.stringify(xhr));
                //swal("Erreur interne au serveur !!!", "Reprendre l'opération. Si l'erreur persiste contacter l'administrateur !", "warning");
            }
        });
    } 
}(jQuery));

var SelectListeCamp;
(function ($) {
    SelectListeCamp = function (id, camp) {
        $.ajax({
            url: '../all_user/_list_combo',
            dataType: 'json',
            success: function (data, status, xhr) {
                
                var k = 0, xOption = '<option value="0">Campagne</option>';
                $.each(data['Record'], function (i, item) {
                    if(item.Id != undefined){
                        if (id == item.Id) {
                            xOption += '<option value="' + item.Id + '" selected="selected">' + item.Libelle + '</option>';
                        } else {
                            xOption += '<option value="' + item.Id + '">' + item.Libelle + '</option>';
                        }
                        k++;
                    }
                });
                $('#CboCamp').html(xOption); 
            },
            error: function (xhr) {
                alert('Erreur système sur liste Campagnes: ' + xhr.status + ' ' + xhr.statusText);
            }
        });
    }
}(jQuery));

var SelectListeExp;
(function ($) {
    SelectListeExp = function (xCamp) {
        $.ajax({
            type:'post',
            url: '/Params/SelectListExp',
            data: { Camp: xCamp },
            dataType: 'json',
            success: function (data, status, xhr) {
                var xOption = '<option></option>';
                $.each(data['Record'], function (i, item) {
                    xOption += '<option value="' + item.Id + '">' + item.Id + ' - ' + item.Libelle + '</option>';
                });
                $('#CboExp').html(xOption);
            },
            error: function (xhr) {
                alert('Erreur système sur liste des exportateurs : ' + xhr.status + ' ' + xhr.statusText);
            }
        });
    }
}(jQuery));

var SelectListeCamPdtPer;
(function ($) {
    SelectListeCamPdtPer = function (Camp, Pdt) {
        $.ajax({
            url: '../all_user/_select_list.asp',
            data: { Camp: Camp, Prdt: Pdt, xOption:'CboCamPdtPer' },
            dataType: 'json',
            success: function (data, status, xhr) {
                var xOption = '<option></option>';
                $.each(data['Record'], function (i, item) {
                    xOption += '<option value="' + item.Id + '">' + item.Libelle + '</option>';
                }); 
                $('#CboPeriode').html(xOption);
            },
            error: function (xhr) {
                alert('Erreur système sur liste Camp Prodt Periode: ' + xhr.status + ' ' + xhr.statusText);
            }
        });
    }
}(jQuery));

var SelectListeNumEdit;
(function ($) {
    SelectListeNumEdit = function (Id) {
        $.ajax({
            url: '/Params/SelectListeNumEdit',
            data: { Id: Id},
            dataType: 'json',
            success: function (data, status, xhr) {
                var xOption = '<option value="0">Etat complet</option>';
                $.each(data['Record'], function (i, item) {
                    xOption += '<option value="' + item.Id + '">' + item.Libelle + '</option>';
                });
                $('#CboNum').html(xOption);
            },
            error: function (xhr) {
                alert('Erreur système sur liste Camp Prodt Periode: ' + xhr.status + ' ' + xhr.statusText);
            }
        });
    }
}(jQuery));