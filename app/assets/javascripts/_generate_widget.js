jQuery(function($){

  var widget_code_template = $(".widget .generatedWidget textarea").val();

  $("#generate_widget").click(function() {

    
    widget_code_template = widget_code_template.replace(/data-currency=".*?"/, 'data-currency="' + $("#widget_currency").text() + '"');
    widget_code_template = widget_code_template.replace(/data-gateway-id=".*?"/, 'data-gateway-id="' + $("#widget_gateway_id").val() + '"');
    widget_code_template = widget_code_template.replace(/  +/g, '');

    if($(".widget .item").size() > 1) {
      console.log("many products");
      var products = [];
      $(".item").each(function() {
        var price = normalize_price($(this).find('.widgetPrice').val());
        if(!validate_price(price)) { return; }
        products.push($(this).find('.widgetTitle').val() + ':' + price);
      });
      console.log('data-products="' + products.join(',') + '"');
      widget_code_template = widget_code_template.replace(/data-products=".*?"/, 'data-products="' + products.join(',') + '"');
    } else {
      var price = normalize_price($(".item .widgetPrice").val());
      if(!validate_price(price)) { return; }
      widget_code_template = widget_code_template.replace(/data-title=".*?"/, 'data-title="' + $(".item .widgetTitle").val() + '"');
      widget_code_template = widget_code_template.replace(/data-price=".*?"/, 'data-price="' + price + '"');
    }

    $(".widget .generatedWidget textarea").val(widget_code_template);
    $(".generatedWidget").slideDown();
    $("tr.widget th").html("Copy and paste this widget<br/>code onto your page:")

  });

  function show_new_product_fields() {
    var item = $(this).parent().clone();
    item.find('input').val('');
    item.find('#add_product').click(show_new_product_fields);
    $(this).parent().after(item);
    $(this).remove();
  }

  function validate_price(price) {
    if(!(price.match(/^\d+(\.\d+)?$/))) {
      alert("Price should be a number!");
      return false;
    } else {
      return true;
    }
  }

  function normalize_price(price) {
    return price.replace(',', '.');
  }

  $("#add_product").click(show_new_product_fields);

});
