// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require vendor/custom.modernizr
//= require foundation/foundation
//= require foundation/foundation.alerts
//= require foundation/foundation.forms
//= require foundation/foundation.section
//= require foundation/foundation.tooltips
//= require foundation/foundation.placeholder
//= require foundation/foundation.abide
//= require foundation/foundation.dropdown

$(function() {
  var minVer = 9;
  var el = $("<div>").prop("id", "ieDetect");
  $("body").append(el);
  el.html("<!--[if IE]><em></em><![endif]-->");
  if (el.find("em").length) {
    for (var v = 6; v < 15; v++) {
      el.html("<!--[if lte IE " + v + "]><b></b><![endif]-->");
      if (el.find("b").length) break;
    }
    if (v < minVer) {
      $("html").addClass("unsupportedBrowser");
      $.getScript("/assets/unsupported_browser.js");
    }
  }
  el.remove();
  
  $(document).foundation();
});
