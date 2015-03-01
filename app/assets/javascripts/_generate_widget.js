jQuery(function($){

  var widget_code_template = $(".widget .generatedWidget textarea").val();

  $("#generate_widget").click(function() {
  
    if(!($("#widget_price").val().match(/^\d+(\.\d+)?$/))) {
      alert("Price should be a number!");
      return;
    }
    
    widget_code_template = widget_code_template.replace(/data-price=".*?"/, 'data-price="' + $("#widget_price").val() + '"');
    widget_code_template = widget_code_template.replace(/data-currency=".*?"/, 'data-currency="' + $("#widget_currency").text() + '"');
    widget_code_template = widget_code_template.replace(/data-gateway-id=".*?"/, 'data-gateway-id="' + $("#widget_gateway_id").val() + '"');
    widget_code_template = widget_code_template.replace(/  +/g, '');
    $(".widget .generatedWidget textarea").val(widget_code_template);

    $(".generatedWidget").slideDown();
    $("tr.widget th").html("Copy and paste this widget<br/>code onto your page:")

  });

});
