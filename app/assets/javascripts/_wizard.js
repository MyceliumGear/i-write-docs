jQuery(function($){

  $("table.siteBackendTypesSelector td").click(function() {
    var site_type = $(this).data('siteType');
    var site_type_button = $("table.siteBackendTypesSelector td[data-site-type=" + site_type + "]").first()


    if(site_type == "unknown") {
      $(".websiteTypeChecker").slideDown();
    }
    else {
      site_type_button.addClass('pressed');
      window.location = "/wizard?step=2&site_type=" + site_type;
      setTimeout(function(){
        $('.pressed').removeClass('pressed');
      }, 500);
    }

  });

  $(".websiteTypeChecker button").click(function() {
    $.ajax({
      url: '/wizard/detect_site_type',
      dataType: 'text',
      type: 'POST',
      data: { url: $(".websiteTypeChecker input").val(), authenticity_token: AUTH_TOKEN },
      success: function(resp) {
        $("button, .button, input[type=submit]").removeClass("locked");
        $(".websiteTypeChecker .form").hide();
        $(".websiteTypeChecker ." + resp).fadeIn(300);
      }
    });
  });

});
