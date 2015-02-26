jQuery(function($){

  $(".page.orders.index .list tr.order").mouseover(function() {
    $(this, "td").css({ opacity: 0.9 });
  });
  $(".page.orders.index .list tr.order").mouseout(function() {
    $(this, "td").css({ opacity: 1 });
  });
  $(".page.orders.index .list tr.order").click(function() {
    window.location = "/orders/" + $(this).data('orderId');
  });

});
