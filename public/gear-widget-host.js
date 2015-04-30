jQuery(function($) {

  $('#gear-widget').load(function(){
    var target = $('#gear-widget').data().targetDomain;
    
    document.getElementById('gear-widget').contentWindow.postMessage(
      {
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
