//= require _button
//= require _gateway_form
//= require _generate_widget
//= require _orders
//= require lib/_frontend_notifier/

jQuery(function($){

  $("select").chosen();
  $(".leftSidebar, .pageContent").matchHeight();

  $("menu li").click(function() {
    window.location = $("a", this).attr('href');
  });

});
