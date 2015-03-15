jQuery(function($){

  $("table.siteBackendTypesSelector td").click(function() {
    var site_type = $(this).data('siteType');
    var site_type_button = $("table.siteBackendTypesSelector tr:first td[data-site-type=" + site_type + "]")
    site_type_button.addClass('pressed');
    $(".ajaxLoader").center(site_type_button);
    $(".ajaxLoader").show();

    if(site_type == "unknown") {}
    else {
      window.location = "/wizard?step=2&site_type=" + site_type;
    }
  });

});
