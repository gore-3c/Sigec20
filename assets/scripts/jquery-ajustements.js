
var EtatSuivi3C;
(function ($) {
    EtatSuivi3C = function (wCamp, wPrdt) {
        $('#xLoad').html('<img src="../assets/images/loader.gif" class="img-fluid" alt="" />');
        $.ajax({
            type: 'POST',
            url: '_ajustements_etats.asp',
            dataType: 'json',
            data: { Num:0, Proper: wCamp, Prdt: wPrdt, xOption:'Recap3C' },
            success: function (data, status, xhr) {
                var k = 0, Total = 0;
                var TtNb3C = 0, TtP3C = 0, TtNbNCCI = 0, TtPNCCI = 0, TtNbA = 0, TtPA = 0, TtNbAJ = 0, TtPAJ = 0;
                var tr = '<table class="table table-bordered">' +
                            '<tr class="text-center"><th></th><th colspan="2">Demande </th><th colspan="2">Reception CCI</th><th colspan="2"> Réception Agrégées CCI</th><th colspan="2">FO1 Ajustées</th></tr>' +
                            '<tr class="text-center"><th>Période</th><th>Formule</th><th>Poids</th><th>Formule</th><th>Poids</th>' +
                            '<th>Formule</th><th>Poids</th><th>Formule</th><th>Poids</th></tr>';
                $.each(data, function (i, item) {
                    if(item.PERIODE != undefined){
                        k++;
                        TtNb3C += item.Nb_3C;
                        TtP3C += item.POIDSFO1_3C;

                        TtNbNCCI += item.Nb_CCI;
                        TtPNCCI += item.POIDSREEL_CCI;

                        TtNbA += item.Nb_ACCI;
                        TtPA += item.POIDSREEL_ACCI;
                        
                        TtNbAJ += item.Nb_AJ;
                        TtPAJ += item.POIDSREEL_AJ;

                        tr += '<tr>' +
                                    '<td>' + item.PERIODE + '</td>' +
                                    '<td class="text-right">' + nbFormat(item.Nb_3C, '', ' ') + '</td>' +
                                    '<td class="text-right">' + nbFormat(item.POIDSFO1_3C, '', ' ') + '</td>' +
                                    '<td class="text-right">' + nbFormat(item.Nb_CCI, '', ' ') + '</td>' +
                                    '<td class="text-right">' + nbFormat(item.POIDSREEL_CCI, '', ' ') + '</td>' +
                                    '<td class="text-right">' + nbFormat(item.Nb_ACCI, '', ' ') + '</td>' +
                                    '<td class="text-right">' + nbFormat(item.POIDSREEL_ACCI, '', ' ') + '</td>' +
                                    '<td class="text-right">' + nbFormat(item.Nb_AJ, '', ' ') + '</td>' +
                                    '<td class="text-right">' + nbFormat(item.POIDSREEL_AJ, '', ' ') + '</td>' +
                                '<tr>';
                    }
                });
                if (k == 0) {
                    tr += '<tr><th colspan="9" class="text-center">Aucun enregistrement disponible</th></tr>';
                } else {
                    tr += '<tr>' +
                                '<th>Totaux</th>' +
                                '<th class="text-right">' + nbFormat(TtNb3C, '', ' ') + '</th>' +
                                '<th class="text-right">' + nbFormat(TtP3C, '', ' ') + '</th>' +
                                '<th class="text-right">' + nbFormat(TtNbNCCI, '', ' ') + '</th>' +
                                '<th class="text-right">' + nbFormat(TtPNCCI, '', ' ') + '</th>' +                                
                                '<th class="text-right">' + nbFormat(TtNbA, '', ' ') + '</th>' +
                                '<th class="text-right">' + nbFormat(TtPA, '', ' ') + '</th>' +
                                '<th class="text-right">' + nbFormat(TtNbAJ, '', ' ') + '</th>' +
                                '<th class="text-right">' + nbFormat(TtPAJ, '', ' ') + '</th>' +
                            '<tr>';
                }
                $('#xData').html(tr + '</table>');
                $('#xLoad').html('');
            },
            error: function (xhr) {
                alert(JSON.stringify(xhr));
                //alert('Erreur système sur liste réajustements: ' + xhr.status + ' ' + xhr.statusText);
            }
        });
    }
}(jQuery));

var EtatSuiviCCI;
(function ($) {
    EtatSuiviCCI = function () {

        $.ajax({
            url: '_ajustements_etats.asp',            
            dataType: 'json',
            success: function (data, status, xhr) {
                var k = 0, Total = 0;
                var TtNb = 0, TtPFo1 = 0, TtNbN = 0, TtPFo1N = 0, TtPRN = 0, TtNbA = 0, TtPFo1A = 0, TtPRA = 0;
                var tr = '<table class="table table-bordered">' +
                            '<tr class="text-center"><th></th><th colspan="2">Demande</th><th colspan="3">Réception FO1 Normale CCI</th>'+
                            '<th colspan="3">Réception Fo1 Agrégée CCI</th><th colspan="3">Réception Totale CCI</th><th colspan="2">En attente</th></tr>' +
                            '<tr class="text-center"><th>Campagne</th><th>Formule</th><th>Poids</th><th>Formule</th><th>Poids</th><th>Poids Réel</th>' +
                            '<th>Formule</th><th>Poids</th><th>Poids Réel</th><th>Formule</th><th>Poids</th><th>Poids Réel</th><th>Formule</th><th>Poids</th></tr>';
                $.each(data['Record'], function (i, item) {
                    k++;
                    TtNb += item.Nbre;
                    TtPFo1 += item.PoidsFo1;

                    TtNbN += item.NbreN;
                    TtPFo1N += item.PoidsNFo1;
                    TtPRN += item.PoidsNR;

                    TtNbA += item.NbreA;
                    TtPFo1A += item.PoidsA;
                    TtPRA += item.PoidsAR;                    
                    
                    tr += '<tr>' +
                                '<td>' + item.Libelle + '</td>' +
                                '<td class="text-right">' + nbFormat(item.Nbre, '', ' ') + '</td>' +
                                '<td class="text-right">' + nbFormat(item.PoidsFo1, '', ' ') + '</td>' +
                                '<td class="text-right">' + nbFormat(item.NbreN, '', ' ') + '</td>' +
                                '<td class="text-right">' + nbFormat(item.PoidsNFo1, '', ' ') + '</td>' +
                                '<td class="text-right">' + nbFormat(item.PoidsNR, '', ' ') + '</td>' +
                                '<td class="text-right">' + nbFormat(item.NbreA, '', ' ') + '</td>' +
                                '<td class="text-right">' + nbFormat(item.PoidsA, '', ' ') + '</td>' +
                                '<td class="text-right">' + nbFormat(item.PoidsAR, '', ' ') + '</td>' +
                                '<td class="text-right">' + nbFormat(item.NbreN + item.NbreA, '', ' ') + '</td>' +
                                '<td class="text-right">' + nbFormat(item.PoidsNFo1 + item.PoidsA, '', ' ') + '</td>' +
                                '<td class="text-right">' + nbFormat(item.PoidsAR + item.PoidsNR, '', ' ') + '</td>' +
                                '<td class="text-right">' + nbFormat(item.Nbre - item.NbreN - item.NbreA, '', ' ') + '</td>' +
                                '<td class="text-right">' + nbFormat(item.PoidsFo1 - item.PoidsNFo1 - item.PoidsA, '', ' ') + '</td>' +
                            '<tr>';
                });
                if (k == 0) {
                    tr += '<tr><th colspan="14" class="text-center">Aucun enregistrement disponible</th></tr>';
                } else {
                    tr += '<tr>' +
                                '<th>Totaux</th>' +
                                '<th class="text-right">' + nbFormat(TtNb, '', ' ') + '</th>' +
                                '<th class="text-right">' + nbFormat(TtPFo1, '', ' ') + '</th>' +
                                '<th class="text-right">' + nbFormat(TtNbN, '', ' ') + '</th>' +
                                '<th class="text-right">' + nbFormat(TtPFo1N, '', ' ') + '</th>' +
                                '<th class="text-right">' + nbFormat(TtPRN, '', ' ') + '</th>' +
                                '<th class="text-right">' + nbFormat(TtNbA, '', ' ') + '</th>' +
                                '<th class="text-right">' + nbFormat(TtPFo1A, '', ' ') + '</th>' +
                                '<th class="text-right">' + nbFormat(TtPRA, '', ' ') + '</th>' +
                                '<th class="text-right">' + nbFormat(TtNbN + TtNbA, '', ' ') + '</th>' +
                                '<th class="text-right">' + nbFormat(TtPFo1N + TtPFo1A, '', ' ') + '</th>' +
                                '<th class="text-right">' + nbFormat(TtPRN + TtPRA, '', ' ') + '</th>' +
                                '<th class="text-right">' + nbFormat(TtNb - TtNbN - TtNbA, '', ' ') + '</th>' +
                                '<th class="text-right">' + nbFormat(TtPFo1 - TtPFo1N - TtPFo1A, '', ' ') + '</th>' +
                            '<tr>';
                }
                $('#xData').html(tr + '</table>');
            },
            error: function (xhr) {
                alert('Erreur système sur liste réajustements: ' + xhr.status + ' ' + xhr.statusText);
            }
        });
    }
}(jQuery));

var AjustsEtatSynthese;
(function ($) {
    AjustsEtatSynthese = function (wProper, wNum, wPrdt) {
        $.ajax({
            type: 'POST',
            dataType: 'json',
            url: '_ajustements_etats.asp',
            data: { Proper: wProper, Num: wNum, Prdt: wPrdt, xOption:'Synthese' },
            success: function (data, status, xhr) {
                var Exp = "", k = 0, Total = 0;
                var TtlPFo1 = 0, TtlPr = 0, TtlRedev = 0, TtlRs = 0, TtlEmb = 0, TtlIsps = 0, TtlTr = 0;
                var tr = '<table class="table table-bordered"><thead>' +
                            '<tr><th>Exportateur</th><th>Poids FO1</th><th>Poids Réel</th>' +
                            '<th>Redevances</th><th>Reverst/Soutien</th><th>Emballage</th><th>Transit</th><th>ISPS</th><th>Total</th></tr></thead><tbody>';

                $.each(data, function (i, item) {
                    if(item.ID_EXP != undefined){
                        k++;
                        TtlPFo1 += item.POIDS_FO1;
                        TtlPr += item.POIDSREEL;
                        TtlRedev += item.MT_REDEV;
                        TtlRs += item.MT_RS;
                        TtlEmb += item.MT_EMB;
                        TtlTr += item.MT_TRANSIT;
                        TtlIsps += item.MT_ISPS;
                        
                        Total = item.MT_REDEV + item.MT_RS + item.MT_EMB + item.MT_TRANSIT + item.MT_ISPS;
                        Exp = (item.NOM.length > 15) ? item.NOM.substr(0, 15) + ' ...' : item.NOM;
                        tr += '<tr>' +
                                    '<td>' + item.ID_EXP + ' - ' + Exp + '</td>' +
                                    '<td class="text-right">' + nbFormat(item.POIDS_FO1, '', ' ') + '</td>' +
                                    '<td class="text-right">' + nbFormat(item.POIDSREEL, '', ' ') + '</td>' +
                                    '<td class="text-right">' + nbFormat(item.MT_REDEV, '', ' ') + '</td>' +
                                    '<td class="text-right">' + nbFormat(item.MT_RS, '', ' ') + '</td>' +
                                    '<td class="text-right">' + nbFormat(item.MT_EMB, '', ' ') + '</td>' +
                                    '<td class="text-right">' + nbFormat(item.MT_TRANSIT, '', ' ') + '</td>' +
                                    '<td class="text-right">' + nbFormat(item.MT_ISPS, '', ' ') + '</td>' +
                                    '<td class="text-right">' + nbFormat(Total, '', ' ') + '</td>' +
                                '</tr>';
                        }
                }); 
                if (k == 0) {
                    tr += '<tr><th colspan="9" class="text-center">Aucun enregistrement disponible</th></tr>';
                } else {
                    tr += '<tr>' +
                                '<th>Totaux</th>' +
                                '<th class="text-right">' + nbFormat(TtlPFo1, '', ' ') + '</th>' +
                                '<th class="text-right">' + nbFormat(TtlPr, '', ' ') + '</th>' +
                                '<th class="text-right">' + nbFormat(TtlRedev, '', ' ') + '</th>' +
                                '<th class="text-right">' + nbFormat(TtlRs, '', ' ') + '</th>' +
                                '<th class="text-right">' + nbFormat(TtlEmb, '', ' ') + '</th>' +
                                '<th class="text-right">' + nbFormat(TtlTr, '', ' ') + '</th>' +
                                '<th class="text-right">' + nbFormat(TtlIsps, '', ' ') + '</th>' +
                                '<th class="text-right">' + nbFormat(TtlTr + TtlEmb + TtlRs + TtlRedev + TtlIsps, '', ' ') + '</th>' +
                            '</tr>';
                } 
                $('#xData').html(tr + '</tbody></table>'); 
            },
            error: function (xhr) {
                alert(JSON.stringify(xhr));
                //alert('Erreur système sur liste réajustements: ' + xhr.status + ' ' + xhr.statusText);
            }
        });
    }
}(jQuery));

var AjustsEtatRecap;
(function ($) {
    AjustsEtatRecap = function (wProper, wNum, wExp) {
        
        $.ajax({
            type: 'POST',
            url: '_ajustements_etats.asp',
            data: { Proper: wProper, Num: wNum, Exp: wExp, Prdt:0, xOption:'Recap' },
            dataType: 'json',
            success: function (data, status, xhr) {

                var Exp = "", k = 0, Total = 0;
                var TtlPCv = 0, TtlPFo1 = 0, TtlPr = 0, TtlRedev = 0, TtlRs = 0, TtlEmb = 0, TtlIsps = 0, TtlTr = 0;
                var tr = '<table class="table table-bordered"><thead>' +
                            '<tr><th>Exportateur</th><th>Contrat</th><th>Poids CV</th><th>Poids FO1</th><th>Poids Réel</th>' +
                            '<th>Redevances</th><th>Reverst/Soutien</th><th>Emballage</th><th>Transit</th><th>ISPS</th><th>Total</th></tr></thead><tbody>';
                $.each(data, function (i, item) {
                    if(item.ID_EXP != undefined){

                        k++;
                        TtlPCv += item.NET;
                        TtlPFo1 += item.POIDS_FO1;
                        TtlPr += item.POIDSREEL;
                        TtlRedev += item.MT_REDEV;
                        TtlRs += item.MT_RS;
                        TtlEmb += item.MT_EMB;
                        TtlTr += item.MT_TRANSIT;
                        TtlIsps += item.MT_ISPS;

                        Total = item.MT_REDEV + item.MT_RS + item.MT_EMB + item.MT_TRANSIT + item.MT_ISPS;
                        Exp = (item.NOM.length > 15) ? item.NOM.substr(0, 15) + ' ...' : item.NOM;

                        tr += '<tr>' +
                                    '<td>' + item.ID_EXP + ' - ' + Exp + '</td>' +
                                    '<td>' + item.CDC_CGFCC + '</td>' +
                                    '<td class="text-right">' + nbFormat(item.NET, '', ' ') + '</td>' +
                                    '<td class="text-right">' + nbFormat(item.POIDS_FO1, '', ' ') + '</td>' +
                                    '<td class="text-right">' + nbFormat(item.POIDSREEL, '', ' ') + '</td>' +
                                    '<td class="text-right">' + nbFormat(item.MT_REDEV, '', ' ') + '</td>' +
                                    '<td class="text-right">' + nbFormat(item.MT_RS, '', ' ') + '</td>' +
                                    '<td class="text-right">' + nbFormat(item.MT_EMB, '', ' ') + '</td>' +
                                    '<td class="text-right">' + nbFormat(item.MT_TRANSIT, '', ' ') + '</td>' +
                                    '<td class="text-right">' + nbFormat(item.MT_ISPS, '', ' ') + '</td>' +
                                    '<td class="text-right">' + nbFormat(Total, '', ' ') + '</td>' +
                                '<tr>';
                        }
                });
                if (k == 0) {
                    tr += '<tr><th colspan="11" class="text-center">Aucun enregistrement disponible</th></tr>';
                } else {
                    tr += '<tr>' +
                                '<th>Totaux</th>' +
                                '<th>-</th>' +
                                '<th class="text-right">' + nbFormat(TtlPCv, '', ' ') + '</th>' +
                                '<th class="text-right">' + nbFormat(TtlPFo1, '', ' ') + '</th>' +
                                '<th class="text-right">' + nbFormat(TtlPr, '', ' ') + '</th>' +
                                '<th class="text-right">' + nbFormat(TtlRedev, '', ' ') + '</th>' +
                                '<th class="text-right">' + nbFormat(TtlRs, '', ' ') + '</th>' +
                                '<th class="text-right">' + nbFormat(TtlEmb, '', ' ') + '</th>' +
                                '<th class="text-right">' + nbFormat(TtlTr, '', ' ') + '</th>' +
                                '<th class="text-right">' + nbFormat(TtlIsps, '', ' ') + '</th>' +
                                '<th class="text-right">' + nbFormat(TtlTr + TtlEmb + TtlRs + TtlRedev + TtlIsps, '', ' ') + '</th>' +
                            '<tr>';
                }
                $('#xData').html(tr + '</tbody></table>');
            },
            error: function (xhr) {
                alert('Erreur système sur liste réajustements: ' + xhr.status + ' ' + xhr.statusText);
            }
        });
    }
}(jQuery));

var AjustsEtatDetails;
(function ($) {
    AjustsEtatDetails = function (wProper, wNum, wExp) {        
        
        var TPsFo1 = 0, TPsReel = 0, TEcart = 0, TRedev = 0, TRS = 0, TEmb = 0, TTransit = 0, TIsps = 0, TTotal = 0;
        var tr = '<table class="table table-bordered"><thead>'+
                    '<tr><th>N° Fo1</th><th>Emballage</th><th>Transit</th>'+
                    '<th>Poids Fo1</th><th>Poids Réel</th><th>Ecart</th><th>Redevances</th>'+
                    '<th>R/S</th><th>Mt Emballage</th><th>Mt Transit</th><th>Mt ISPS</th><th>Total</th></tr></thead><tbody>';
        $.ajax({
            type: 'POST',
            url: '_ajustements_etats.asp',
            data: { Proper: wProper, Num: wNum, Exp: wExp, Prdt:0, xOption:'Details' },
            dataType: 'json',
            success: function (data, status, xhr) {
                $.each(data, function (i, item) {
                    if(item.NUM_FRC != undefined){
                        tr += '<tr>' +
                            '<td>' + item.NUM_FRC + '</td>'+
                            '<td>' + item.LIB_EMB + '</td>'+
                            '<td>' + item.LIB_TRANSIT + '</td>' +
                            '<td class="text-right">' + nbFormat(item.POIDS_FO1, '', ' ') + '</td>' +
                            '<td class="text-right">' + nbFormat(item.POIDSREEL, '', ' ') + '</td>' +
                            '<td class="text-right">' + nbFormat((item.POIDSREEL - item.POIDS_FO1), '', ' ') + '</td>' +
                            '<td class="text-right">' + nbFormat(item.MT_REDEV, '', ' ') + '</td>' +
                            '<td class="text-right">' + nbFormat(item.MT_RS, '', ' ') + '</td>' +
                            '<td class="text-right">' + nbFormat(item.MT_EMB, '', ' ') + '</td>' +
                            '<td class="text-right">' + nbFormat(item.MT_TRANSIT, '', ' ') + '</td>' +
                            '<td class="text-right">' + nbFormat(item.MT_ISPS, '', ' ') + '</td>' +
                            '<td class="text-right">' + nbFormat(parseFloat(item.MT_REDEV) + parseFloat(item.MT_RS) + parseFloat(item.MT_EMB) + parseFloat(item.MT_TRANSIT) + parseFloat(item.MT_ISPS), '', ' ') + '</td>' +
                        '</tr>';
                        
                        TPsFo1 += item.POIDS_FO1;
                        TPsReel += item.POIDSREEL;
                        TEcart += (item.POIDSREEL - item.POIDS_FO1);
                        TRedev += item.MT_REDEV;
                        TRS += item.MT_RS;
                        TEmb += item.MT_EMB;
                        TTransit += item.MT_TRANSIT;
                        TIsps += item.MT_ISPS;
                    }

                }); 
                TTotal = parseFloat(TRedev) + parseFloat(TIsps) + parseFloat(TTransit) + parseFloat(TEmb) + parseFloat(TRS);
                tr += '<tr>' +
                        '<th colspan="3">TOTAUX</th>' +
                        '<th class="text-right">' + nbFormat(TPsFo1, '', ' ') + '</th>' +
                        '<th class="text-right">' + nbFormat(TPsReel, '', ' ') + '</th>' +
                        '<th class="text-right">' + nbFormat(TEcart, '', ' ') + '</th>' +
                        '<th class="text-right">' + nbFormat(TRedev, '', ' ') + '</th>' +
                        '<th class="text-right">' + nbFormat(TRS, '', ' ') + '</th>' +
                        '<th class="text-right">' + nbFormat(TEmb, '', ' ') + '</th>' +
                        '<th class="text-right">' + nbFormat(TTransit, '', ' ') + '</th>' +
                        '<th class="text-right">' + nbFormat(TIsps, '', ' ') + '</th>' +
                        '<th class="text-right">' + nbFormat(TTotal, '', ' ') + '</th>' +
                    '</tr>';

                $('#xData').html(tr + '</tbody></table>');
            },
            error: function (xhr) {
                alert('Erreur système sur liste détails réajustements: ' + xhr.status + ' ' + xhr.statusText);
            }
        });
    }
}(jQuery));

var AjustsMaJList;
(function ($) {
    AjustsMaJList = function (wProper) {        
        
        var TPsFo1 = 0, TPsReel = 0, TEcart = 0, TNb = 0, TTotal = 0;
        var tr = '<table class="table table-bordered"><thead>'+
                    '<tr><th>#</th><th>Exportateur</th><th>NB FO1</th>'+
                    '<th>Poids Fo1</th><th>Poids Réel</th><th>Ecart</th></tr></thead><tbody>';
        $.ajax({
            type: 'POST',
            url: '_ajust_maj.asp',
            data: { Proper: wProper, xOption:'MaJList' },
            dataType: 'json',
            success: function (data) {
                var Exp = '';
                $.each(data, function (i, item) {
                    if(item.ID_EXP != undefined){

                        Exp = (item.NOM.length > 20) ? item.NOM.substr(0, 20) + ' ...' : item.NOM;
                        tr += '<tr>' +
                            '<td>' + (i + 1) + '</td>'+
                            '<td>' + item.ID_EXP + ' - ' + Exp + '</td>'+
                            '<td class="text-right">' + nbFormat(item.NB_FO1, '', ' ') + '</td>' +
                            '<td class="text-right">' + nbFormat(item.POIDS_FO1, '', ' ') + '</td>' +
                            '<td class="text-right">' + nbFormat(item.POIDSREEL, '', ' ') + '</td>' +
                            '<td class="text-right">' + nbFormat((item.POIDSREEL - item.POIDS_FO1), '', ' ') + '</td>' +                            
                        '</tr>';

                        TNb += item.NB_FO1;
                        TPsFo1 += item.POIDS_FO1;
                        TPsReel += item.POIDSREEL;
                        TEcart += (item.POIDSREEL - item.POIDS_FO1);
                    }

                }); 

                tr += '<tr>' +
                        '<th colspan="2">TOTAUX</th>' +
                        '<th class="text-right">' + nbFormat(TNb, '', ' ') + '</th>' +
                        '<th class="text-right">' + nbFormat(TPsFo1, '', ' ') + '</th>' +
                        '<th class="text-right">' + nbFormat(TPsReel, '', ' ') + '</th>' +
                        '<th class="text-right">' + nbFormat(TEcart, '', ' ') + '</th>' +                        
                    '</tr>';

                $('#xData').html(tr + '</tbody></table>');
            },
            error: function (xhr) {
                alert(JSON.stringify(xhr));
                alert('Erreur système sur liste détails réajustements: ' + xhr.status + ' ' + xhr.statusText);
            }
        });
    }
}(jQuery));

var AjustsMaJ;
(function ($) {
    AjustsMaJ = function (wProper){
        $.ajax({
            type: 'post',
            cache: false,
            dataType: 'json',
            url: '_ajust_maj.asp',
            data: { Proper:wProper, Choix_Frm:"MaJ", xOption:"MaJValide" },            
            success: function (xdata) {
                if(xdata[0]['Erreur'] == 1){
                    swal("Ajustement sur poids réels", xdata[0]['Err_Msg'], "success");
                    AjustsMaJList(wProper);
                }else{
                    swal("Ajustement sur poids réels", xdata[0]['Err_Msg'], "warning");
                }
            },
            error: function (xhr) {
                alert('Erreur système 000 : ' + JSON.stringify(xhr));
            }
        });
    } 
}(jQuery));