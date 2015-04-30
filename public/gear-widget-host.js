jQuery(function($) {

  $('#gear-widget').load(function(){
    // If widget states localhost as its target, we
    // default to the same host on which the widget is hosted.
    var target = $('#gear-widget').data().targetDomain;
    
    document.getElementById('gear-widget').contentWindow.postMessage(
      {
        gateway_id:     $('#gear-widget').data().gatewayId,
        price:          $('#gear-widget').data().price,
        currency:       $('#gear-widget').data().currency,
        title:          $('#gear-widget').data().title,
        products:       $('#gear-widget').data().products,
        path:         window.location.pathname,
        gateway_host: target
      },
      target
    );
  });

  window.addEventListener('message', function(event) {
    if(event.data.eventName == 'gear-widget-height-change') {
      $('#gear-widget').animate({ height: event.data.newHeight });
    }
  });

});
