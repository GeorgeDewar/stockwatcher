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

// A super simple template engine to remove dependency on a real one
var simpleCompile = function(template) {
        return {
            render: function(context) {
                return template.replace(/\{\{(\w+)\}\}/g, function (match,p1) { return context[p1]; });
            }
        };
};

var stocks = new Bloodhound({
    datumTokenizer: function(d) { return Bloodhound.tokenizers.whitespace(d.disp); },
    queryTokenizer: Bloodhound.tokenizers.whitespace,
    limit: 10,
    prefetch: {
        url: '/lookup/stocks',
        filter: function(list) {
            return $.map(list, function(stock) { return { code: stock.code, name: stock.name, disp: (stock.code + ' :: ' + stock.name + '') }; });
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
        templates: {
            suggestion: Mustache.compile([
                '<p class="stock-code">{{code}}</p>',
                '<p class="stock-name">{{name}}</p>'
            ].join(''))
        }

    });

});
