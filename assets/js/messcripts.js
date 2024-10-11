
// -- Convertir date en Fr -- //
function nb(m) {
    return (m < 10) ? '0' + m : m;
}
function ToJSDate(value) {
    var pattern = /Date\(([^)]+)\)/;
    var result = pattern.exec(value);
    var dt = new Date(parseFloat(result[1]));
    return nb(dt.getDate())+"/"+nb((dt.getMonth()+1))+"/"+dt.getFullYear();
}

// formate un chiffre avec 'decimal' chiffres après la virgule et un separateur
function nbFormat(valeur, decimal, separateur) {
    var deci = Math.round(Math.pow(10, decimal) * (Math.abs(valeur) - Math.floor(Math.abs(valeur))));
    var val = Math.floor(Math.abs(valeur));
    if ((decimal == 0) || (deci == Math.pow(10, decimal))) { val = Math.floor(Math.abs(valeur)); deci = 0; }
    var val_format = val + "";
    var nb = val_format.length;
    for (var i = 1; i < 4; i++) {
        if (val >= Math.pow(10, (3 * i))) {
            val_format = val_format.substring(0, nb - (3 * i)) + separateur + val_format.substring(nb - (3 * i));
        }
    }
    if (decimal > 0) {
        var decim = "";
        for (var j = 0; j < (decimal - deci.toString().length) ; j++) { decim += "0"; }
        deci = decim + deci.toString();
        val_format = val_format + "." + deci;
    }
    if (parseFloat(valeur) < 0) { val_format = "-" + val_format; }
    return val_format;
}

function Compter(Targeta, max, nomchamp){
    StrLen = $(Targeta).val().length;
    if (StrLen > max ){  CharsLeft = 0;	} 
    else { CharsLeft = StrLen; }	//else { CharsLeft = max - StrLen; }
    $(nomchamp).text(CharsLeft);
}

function Up(obj){
    var minus = "aàâäbcçdeéèêëfghiîïjklmnoôöpqrstuùûvwxyz"        
    var majus = "AAAABCCDEEEEEFGHIIIJKLMNOOOPQRSTUUUVWXYZ"
    var entree = $('#'+obj).val();
    var sortie = "";
    for (var i = 0 ; i < entree.length ; i++)
    {
        var car = entree.substr(i, 1);
        sortie += (minus.indexOf(car) != -1) ? majus.substr(minus.indexOf(car), 1) : car;
    }
    $('#'+obj).val(sortie);
}