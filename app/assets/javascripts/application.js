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
//= require jquery-ui-sliderAccess
//= require jquery-ui-timepicker-addon
//= require_tree .
//= require_self

ready = function(){
    // make code pretty
    window.prettyPrint && prettyPrint();

  $.timepicker.regional['ko'] = {
    timeOnlyTitle: '시간 선택',
    timeText: '시간',
    hourText: '시',
    minuteText: '분',
    secondText: '초',
    millisecText: '밀리초',
    microsecText: '마이크로',
    timezoneText: '표준 시간대',
    currentText: '현재 시각',
    closeText: '닫기',
    timeFormat: 'tt h:mm',
    amNames: ['오전', 'AM', 'A'],
    pmNames: ['오후', 'PM', 'P'],
    isRTL: false
  };
  $.timepicker.setDefaults($.timepicker.regional['ko']);

  if(!Modernizr.inputtypes.date){
    $("input[type=date]").datetimepicker({ dateFormat: "yy-mm-dd", timeFormat: "HH:mm:ss" });
  }

  if(!Modernizr.inputtypes.number){
    $("input[type=number]").spinner({ min: 0, max: 100 });
  }

  $('input[multiple]').each(function(){
      $(this).on('change', function(){
        var fileName = $(this).val().split('/').pop().split('\\').pop();
        $(".uploaded-files").append("<div class='file'><i class='icon-large icon-file'></i><span>"
        + fileName + "</span>");
      });
  });


};

$(document).ready(ready);
$(document).on('page:load', ready);


// Modernizr.load([
//   {
//         test: ,
//         nope: "assets,
//         callback: function() {

//         }
//   },
//   {
//         test: Modernizr.inputtypes.number,
//         callback: function() {
//           $("input[type=number]").spinner();
//         }
//   }
// ]);

/*$('.fields-box input[type="file"][multiple="multiple"]').on('change',function(){
   var fileName = this.val().split('/').pop().split('\\').pop();
   $(".uploaded-files").append("<div class='file'><i class='icon-large icon-file'></i><span>" + fileName + "</span>");
});
*/
$(document).ready(function(){

});
