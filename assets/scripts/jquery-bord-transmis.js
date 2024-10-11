
var Bord_Perceptions;
(function ($) {
    Bord_Perceptions = function (wId, wDate, wDiv) {        
        $.ajax({
            type: 'POST',
            url: '_bord_transmis.asp',
            data: { id: wId, Dt: wDate, xOption:'Etat_Perceptions' },
            dataType: 'json',
            success: function (data) {
                
                var k = 0, TtlMt = 0, TtlPoids = 0;
                var Exp = "", Lieu = '', Prdt = '', wCamp = '';
                var tr = '<table class="table table-bordered"><thead>' +
                            '<tr><th>Exportateur</th><th>Contrat</th><th>Formule</th><th>Tonnage</th><th>Banque</th>' +
                            '<th>Chèque</th><th>Montant</th></thead><tbody>';
                $.each(data, function (i, item) {
                    if(item.NOM != undefined){
                        k++;                        
                        TtlMt += item.CH_MTT;
                        wCamp = item.CAMP_ID + '/' + (parseInt(item.CAMP_ID)+1);
                        TtlPoids += item.POIDS_FO1;
                        Prdt = (item.PRDT_ID == 1) ?  ' CAFE ' : ' CACAO ';
                        Lieu = (item.L_EDIT == 'Abj') ? ' ABIDJAN ' : ' SAN PEDRO ';
                        Exp = (item.NOM.length > 15) ? item.NOM.substr(0, 15) + ' ...' : item.NOM;
                        tr += '<tr>' +
                                    '<td>' + item.ID_EXP + ' - ' + Exp + '</td>' +
                                    '<td>' + item.CDC_CGFCC + '</td>' +
                                    '<td>' + item.NUM_FRC + '</td>' +                                    
                                    '<td class="text-right">' + nbFormat(item.POIDS_FO1, '', ' ') + '</td>' +
                                    '<td>' + item.BANK + '</td>' +  
                                    '<td>' + item.CH_REF + '</td>' + 
                                    '<td class="text-right">' + nbFormat(item.CH_MTT, '', ' ') + '</td>' +
                                '<tr>';
                        }
                });
                if (k == 0) {
                    tr += '<tr><th colspan="7" class="text-center">Aucun enregistrement disponible</th></tr>';
                } else {
                    tr += '<tr>' +
                                '<th></th>' +
                                '<th>Totaux</th>' +
                                '<th class="text-right">' + nbFormat(k, '', ' ') + '</th>' +
                                '<th class="text-right">' + nbFormat(TtlPoids, '', ' ') + '</th>' +
                                '<th class="text-right"> </th>' +
                                '<th class="text-right"> </th>' +
                                '<th class="text-right">' + nbFormat(TtlMt, '', ' ') + '</th>' +
                            '<tr>';
                }
                $(wDiv).html('<p>' + Prdt + ' ' + wCamp + ' - ' + Lieu + ' </p>' + tr + '</tbody></table>');
            },
            error: function (xhr) {
                alert('Erreur système sur liste réajustements: ' + xhr.status + ' ' + xhr.statusText);
            }
        });
    }
}(jQuery));