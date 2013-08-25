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
//= require jquery.ui.all
//= require twitter/bootstrap
//= require turbolinks
//= require google-code-prettify-rails/prettify
//= require google-code-prettify-rails/lang-clj
// require jquery-fileupload
//= require_tree .
//= require_self

$(function(){
    // make code pretty
    window.prettyPrint && prettyPrint();
  if(!Modernizr.inputtypes.date){
    $("input[type=date]").datepicker();
  }

  if(!Modernizr.inputtypes.number){
    $("input[type=number]").spinner();
  }

});

/*Modernizr.load([
  {
        test: ,
        nope: "assets,
        callback: function() {

        }
  },
  {
        test: Modernizr.inputtypes.number,
        callback: function() {
          $("input[type=number]").spinner();
        }
  }
]);*/
