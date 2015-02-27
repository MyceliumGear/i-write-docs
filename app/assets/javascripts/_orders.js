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
})();

jQuery(function($){

  $(".page.orders.index .list tr.order").mouseover(function() {
    $(this, "td").css({ opacity: 0.9 });
  });
  $(".page.orders.index .list tr.order").mouseout(function() {
    $(this, "td").css({ opacity: 1 });
  });
  $(".page.orders.index .list tr.order").click(function() {
    window.location = "/gateways/" + $(this).data('gatewayId') + "/orders/" + $(this).data('orderId');
  });

  $("select[name=filter_by_gateway]").change(function() {
    add_filter('gateway_id', $(this).val());
  });

  $("select[name=filter_by_status]").change(function() {
    add_filter('status', $(this).val());
  });

  function add_filter(param, value) {
    var loc = "/orders?";
    console.log(urlParams);
    urlParams[param] = value;
    console.log(urlParams);
    for(param_name in urlParams) {
      loc = loc + param_name + '=' + urlParams[param_name] + '&';
    };
    window.location = loc;
  }

});
