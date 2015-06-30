//= require _button
//= require _gateway_form
//= require _generate_widget
//= require _orders
//= require _wizard
//= require lib/_frontend_notifier/
//= require jquery_ujs

jQuery(function($){

  jQuery.fn.leftMiddle = function(obj) {
    var loc = obj.offset();
    this.css("top",(obj.outerHeight() - this.outerHeight()) / 2 + loc.top + 'px');
    this.css("left", (loc.left + 10) + 'px');
    return this;
  }

  jQuery.fn.center = function(obj) {
    var loc = obj.offset();
    this.css("top",(obj.outerHeight() - this.outerHeight()) / 2 + loc.top + 'px');
    this.css("left", (obj.outerWidth() - this.outerWidth()) / 2 + loc.left + 'px');
    return this;
  }

  $("select").chosen();
  $(".leftSidebar, .pageContent").matchHeight();

  $('menu li').click(function(e) {
    // http://www.jacklmoore.com/notes/click-events/
    if (!(e.which > 1 || e.shiftKey || e.altKey || e.metaKey || e.ctrlKey)) {
      window.location = $('a', this).attr('href');
    }
  });

});
