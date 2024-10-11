/* ############## - Gestion des demandes de Reports  - ############################### */
var Liste_Contrats;
(function ($) {
    Liste_Contrats = function (exp, per, xtable){
        $.ajax({
            type: 'post',
            dataType: 'json',
            url: '../all_user/doc_demande_report.asp',
            data: { ProdperId: per, Exp: exp, xOption:"Liste" },            
            success: function (data) {
                var k = 0, j = 0;
                var tr = '', otr = '', Cv = '', xCv = '';
                var NbFo1 = 0, QteFo1 = 0, QteCv = 0, xQteCv = 0;
//alert(JSON.stringify(data));
                $.each(data,function(i,item){                    

                    Cv = item.CDC_CGFCC;
                    QteCv = item.POIDS_CDC;

                    if(Cv != xCv && i > 0){
                        otr += '<tr class="id_' + j + '">' +                                    
                                    '<td class="_' + j + '" colspan="2"> ' + xCv + '</td>' +
                                    '<td class="text-right">' + nbFormat(QteCv,0,' ') + '</td>' +
                                    '<td class="text-right">' + nbFormat(NbFo1,0,' ') + '</td>' +
                                    '<td class="text-right">' + nbFormat(QteFo1,0,' ') + '</td>' +
                                    '<td class="text-right">' + nbFormat(QteCv - QteFo1,0,' ') + '</td>' +
                                '</tr>' + tr;
                        j++;
                        k = 0;
                        tr = '';
                        NbFo1 = 0;
                        QteFo1 = 0; 
                    }
                    
                    k++;
                    tr = tr + 
                        '<tr class="parent_' + j + '">'+
                            '<td>' + k + '</td>'+
                            '<td>' + item.NUM_FRC + '</td>'+
                            '<td class="text-right">' + nbFormat(item.QTE,0,' ') + '</td>'+
                            '<td class="text-right">' + item.V_AE + '</td>'+
                            '<td class="text-right">-</td>'+
                            '<td class="text-right">-</td>'+
                        '</tr>';                    
                    xCv = Cv; 
                    xQteCv = QteCv;
                    NbFo1 += 1;
                    QteFo1 += parseFloat(item.QTE);
                });

                otr += '<tr class="id_' + j + '">'+                            
                            '<td class="_' + j + '" colspan="2"> ' + xCv + '</td>' +
                            '<td class="text-right">' + nbFormat(xQteCv,0,' ') + '</td>' +
                            '<td class="text-right">' + nbFormat(NbFo1,0,' ') + '</td>' +
                            '<td class="text-right">' + nbFormat(QteFo1,0,' ') + '</td>' +
                            '<td class="text-right">' + nbFormat(xQteCv - QteFo1,0,' ') + '</td>' +
                        '</tr>';

                $(xtable).html(otr + tr);

                $('#footer').html(tr);
                $('#loading').html('');
                $('.table tr[class*="parent_"]').addClass('hide-row');

            },
            error: function (xhr) {
                alert(JSON.stringify(xhr));
            }
        });
    } 
}(jQuery));


