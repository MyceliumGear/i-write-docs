var urlParams;
(window.onpopstate = function () {
  var match,
    pl     = /\+/g,  // Regex for replacing addition symbol with a space
    search = /([^&=]+)=?([^&]*)/g,
    decode = function (s) { return decodeURIComponent(s.replace(pl, " ")); },
    query  = window.location.search.substring(1);

  urlParams = {};
  while (match = search.exec(query))
     urlParams[decode(match[1])] = decode(match[2]);

  delete urlParams['page'];

})();

jQuery(function($){

  $(".page.orders.index .list tr.order").mouseover(function() {
    $(this).addClass('hover');
  });
  $(".page.orders.index .list tr.order").mouseout(function() {
    $(this).removeClass('hover');
  });
  $(".page.orders.index .list tr.order").click(function() {
    window.location = "/gateways/" + $(this).data('gatewayId') + "/orders/" + $(this).data('orderId');
  });

  $("select[name=filter_by_gateway]").change(function() {
    urlParams['gateway_id'] = $(this).val();
    redirect_to_filter_url();
  });

  $("select[name=filter_by_status]").change(function() {
    urlParams['status'] = $(this).val();
    redirect_to_filter_url();
  });

  $(".activeFilters .filter").click(function() {
    delete urlParams[$(this).data('filterName')];
    redirect_to_filter_url();
  });

  function redirect_to_filter_url() {
    var loc = "/orders?";
    for(param_name in urlParams) {
      loc = loc + param_name + '=' + urlParams[param_name] + '&';
    };
    window.location = loc;
  }

});
