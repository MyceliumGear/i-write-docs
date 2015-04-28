jQuery(function($){

  $(".widget .settings").on('click', ".add", function() {
    var last_product = $(this).parents(".item");
    var new_product  = last_product.clone().hide();
    $(this).remove();
    new_product.insertAfter(last_product);
    new_product.slideDown(300);
  });

  $(".widget .settings .fields").on('click', 'input[name=field_required]', function() {
    var field = $(this).parents(".field").find("input[type=text]");
    if(this.checked) {
      field.val("*" + field.val().replace("*", ''));
    } else {
      field.val(field.val().replace("*", ''));
    }
  });

});
