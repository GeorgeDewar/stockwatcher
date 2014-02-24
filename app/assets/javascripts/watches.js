
function format(stock){
    code = split(stock.text, ' ', 1)[0];
    name = split(stock.text, ' ', 1)[1];
    name = name.substring(1, name.length - 1);
    if(stock.id == '') return '<p>' + stock.text + '</p>';
    return '<p class="stock-code">' + code + '</p>' +
    '<p class="stock-name">' + name + '</p>';
}

$(function(){
    $('select').select2({
      formatResult: format,
      formatSelection: format,
      escapeMarkup: function(m) { return m; },
      matcher: function(term, text) {
          code = split(text, ' ', 1)[0];
          name = split(text, ' ', 1)[1];
          name = name.substring(1, name.length - 1);

          return code.toUpperCase().indexOf(term.toUpperCase())==0 ||
              name.toUpperCase().indexOf(term.toUpperCase())==0;
      }
    });
});

