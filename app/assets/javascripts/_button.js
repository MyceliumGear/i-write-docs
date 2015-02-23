jQuery(function($){

  jQuery.fn.center = function(obj) {
    var loc = obj.offset();
    this.css("top",(obj.outerHeight() - this.outerHeight()) / 2 + loc.top + 'px');
    this.css("left", (loc.left + 10) + 'px');
    return this;
  }

  $("button, .button, input[type=submit]").click(function() {
    if(!$(this).hasClass('unlockable')) {
      $(this).addClass('locked');
      // Position ajax loader on top of the Button
      $(".ajaxLoader").center($(this));
      $(".ajaxLoader").show();
    }
  });

  $("button, .button, input[type=submit]").mousedown(function() {
    if(!$(this).hasClass('locked') && !$(this).hasClass('disabled')) {
      $(this).addClass('pressed');
    }
  });

  $("button, .button, input[type=submit]").mouseup(function() {
    if(!$(this).hasClass('locked') && !$(this).hasClass('disabled')) {
      $(this).removeClass('pressed');
    }
  });

  function unlockAllButtons() {
    $(".ajaxLoader").hide();
    $("button, .button, input[type=submit]").removeClass("locked");
  }

});
