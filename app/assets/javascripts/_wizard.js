jQuery(function($){

  $("table.siteBackendTypesSelector td").click(function() {
    var site_type = $(this).data('siteType');
    var site_type_button = $("table.siteBackendTypesSelector tr:first td[data-site-type=" + site_type + "]")


    if(site_type == "unknown") {
      $(".websiteTypeChecker").slideDown();
    }
    else {
      site_type_button.addClass('pressed');
      $(".ajaxLoader").center(site_type_button);
      $(".ajaxLoader").show();
      window.location = "/wizard?step=2&site_type=" + site_type;
    }

  });

  $(".websiteTypeChecker button").click(function() {
    $.ajax({
      url: '/wizard/detect_site_type',
      dataType: 'text',
      type: 'POST',
      data: { url: $(".websiteTypeChecker input").val(), authenticity_token: AUTH_TOKEN },
      success: function(resp) {
        $(".ajaxLoader").hide();
        $("button, .button, input[type=submit]").removeClass("locked");
        $(".websiteTypeChecker .form").hide();
        $(".websiteTypeChecker ." + resp).fadeIn(300);
      }
    });
  });

});
