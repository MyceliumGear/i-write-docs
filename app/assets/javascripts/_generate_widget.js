jQuery(function($){

  var products_to_remove_ids = [];

  $("body").on('click', ".widget .settings .add", function() {
    var last_product = $(this).parents(".item");
    var new_product  = last_product.clone().hide();
    new_product.find("input").val('');
    $(this).remove();
    new_product.insertAfter(last_product);
    new_product.slideDown(300);
  });

  $("body").on('click', ".widget .settings .remove", function() {
    products_to_remove_ids.push($(this).parents('.product').data('productId'));
    show_save_widget_warning();
  });

  $("body").on('click', ".widget .settings .remove", function() {
    $(this).parents(".item").remove();
    show_save_widget_warning();
  });

  $("body").on('change', '.widget .settings .fields input[name=field_required]', function() {
    var field = $(this).parents(".field").find("input[type=text]");
    console.log('*');
    if(this.checked) {
      field.val("*" + field.val().replace("*", ''));
    } else {
      field.val(field.val().replace("*", ''));
    }
  });

  $("body").on('click', ".widget .settings button.save", function() {
    
    // Collect new products data
    var new_products    = [];
    var product_updates = [];
    $(".widget .product").each(function() {
      var title = $(this).find("input.title").val();
      var price = $(this).find("input.price").val();
      // If product is new, let's add it to the list
      if(!$(this).data("productId")) {
        if(title != '' || price != '') {
          new_products.push(
            {
              title: $(this).find("input.title").val(),
              price: $(this).find("input.price").val()
            }
          )
        }
      } else {
        product_updates.push(
          {
            id: $(this).data("productId"),
            title: $(this).find("input.title").val(),
            price: $(this).find("input.price").val()
          }
        )
      }
    });

    // Collect custom fields data
    var fields = [];
    $(".widget .field").each(function() {
      // If product is new, let's add it to the list
      fields.push($(this).find("input.fieldName").val());
    });

    sendUpdateRequest({
      widget_products_attributes: new_products,
      product_updates: product_updates,
      fields: fields.join(','),
      products_to_remove_ids: products_to_remove_ids.join(',')
    });

  });

  var sendUpdateRequest = function(widget_data) {
    // Make request
    $.ajax({
      url: '/widgets/' + $(".widget").data('widgetId'),
      type: 'PATCH',
      data: {
        authenticity_token: AUTH_TOKEN,
        widget: widget_data,
      },
      success: function(response) {
        $(".ajaxLoader").hide();
        var form = $(response)
        form.find('.item.new').hide();
        $(".widget").html('');
        $(".widget").append(form);
        form.find('.item.new').slideDown(300);
        if(form.find('input.error').length > 0) {
          FrontendNotifier.show("We've detected mistakes in the form, please fix them", "error");
        } else {
          if(!widget_data.cancel) {
            FrontendNotifier.show("Changes saved, check out the widget look below", "success");
            document.getElementById("gear-widget").contentDocument.location.reload(true);
          }
        }
      },
      error: function() {
        FrontendNotifier.show("Error on the server, we've been notified!", "error");
      }
    });
    products_to_remove_ids = [];
  }

  $("body").on('click', ".widget .settings button.cancel", function() {
    sendUpdateRequest({ cancel: '1'});
  });

  $("body").on("change", ".widget input", function() {
    show_save_widget_warning();
  });

  $("body").on("keyup", ".widget input", function() {
    show_save_widget_warning();
  });

  var show_save_widget_warning = function() {
    $(".widget .saveWarning").animate({ opacity: 1 });
    $(".widget .cancel").removeClass('disabled');
  }



});
