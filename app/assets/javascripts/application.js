// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require bootstrap
//= require twitter/typeahead
//= require mustache
//= require_tree .

var stocks = new Bloodhound({
    datumTokenizer: function(d) { return Bloodhound.tokenizers.whitespace(d.disp); },
    queryTokenizer: Bloodhound.tokenizers.whitespace,
    limit: 10,
    prefetch: {
        url: '/lookup/stocks',
        filter: function(list) {
            return $.map(list, function(stock) { return { id: stock.id, code: stock.code, name: stock.name, disp: (stock.code + ' :: ' + stock.name + '') }; });
        }
    }
});

stocks.initialize();

// instantiate the typeahead UI
$(function(){
    $('#watch_stock').typeahead(null, {
        name: 'stocks',
        displayKey: 'disp',
        source: stocks.ttAdapter(),
        restrictInputToDatum: true,
        templates: {
            suggestion: Mustache.compile([
                '<p class="stock-code">{{code}}</p>',
                '<p class="stock-name">{{name}}</p>'
            ].join(''))
        }
    });

    $('#watch_stock').on('typeahead:selected typeahead:autocompleted', function(e,datum) {
        $('#watch_stock').val(datum.id);
    });
});
