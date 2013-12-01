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
  
  
  function updateCharCount() {
    shortStoriesBox.find(".chars span").html(maxChars - shortStoriesBox.find("textarea").val().length);
  }
  var shortStoriesBox = $(".short_stories");
  if (shortStoriesBox.length) {
    var maxChars = parseInt(shortStoriesBox.find(".chars span").text());
    $(".short_stories textarea").keyup(updateCharCount);
    updateCharCount();
  }
  
  
  function updatePolls(info) {
    $.each(info, function (pId, options) {
      var poll = polls.find("#poll_"+pId);
      $.each(options, function (oId, optionInfo) {
        var option = poll.find("#poll_option_"+oId);
        option.find("input").prop("checked", optionInfo.v ? "checked" : "");
        option.find(".progress .meter").css({ width: optionInfo.p + "%" });
      });
    });
  }
  function togglePollBtns(poll, toggle) {
    $(":submit", poll).prop("disabled", !toggle).toggleClass("disabled", !toggle);
  }
  var polls = $(".polls_index");
  if (polls.length) {
    polls.find("form").submit(function () {
      togglePollBtns(this, false);
    })
    .on("ajax:success", function (e, data) {
      if (data.new_option) {
        $(data.new_option).hide().insertAfter($(".poll_option", this).last()).slideDown();
      }
      $("input[type=text]", this).val("");
      updatePolls(data.options);
      togglePollBtns(this, true);
    });
    $.get(polls.data("results-path"), function (data) {
      updatePolls(data.options);
    });
  }
});
