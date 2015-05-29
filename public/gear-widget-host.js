window.onload = function() {

  function animateHeight(obj, height) {
    var obj_height = obj.clientHeight;

    if(obj_height == height) { return; }

    if(obj_height <= height) {
       obj.style.height = (obj_height + 1) + "px";
       setTimeout(function(){
           animateHeight(obj, height);
       }, 5) 
    }
    else {
       obj.style.height = (obj_height - 1) + "px";
       setTimeout(function(){
           animateHeight(obj, height);
       }, 5) 
    }
  }

  var widget = document.getElementById('gear-widget');
  var target = widget.getAttribute('data-target-domain');
  
  widget.contentWindow.postMessage(
    {
      gateway_host: target
    },
    target
  );

  window.addEventListener('message', function(event) {
    if(event.data.eventName == 'gear-widget-height-change') {
      animateHeight(widget, event.data.newHeight);
    }
    if(event.data.eventName == 'redirect') {
      window.location = event.data.location;
    }
  });

}
