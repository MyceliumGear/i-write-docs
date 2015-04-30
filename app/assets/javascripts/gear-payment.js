jQuery(function($) {

  window.GearPayment       = {};
  GearPayment.ws_keepalive = false; // will change to true when socket is opened

  function ws_keepalive() {
    if(GearPayment.ws_keepalive) {
      GearPayment.socket.send("keepalive");
      setTimeout(ws_keepalive, 30000);
    }
  }

  // Vars used:
  //  GearPayment.interval;
  //  GearPayment.socket;
  GearPayment.reconnection_attempts = 1;

  GearPayment.display_status_changed_for = function(order) {
    order = JSON.parse(order);
    if(order.status > 1) {
      clearInterval(GearPayment.interval);
      $(".paymentInfo").hide();
      if(order.status == 2) {
        $(".paymentInfo.paid").fadeIn(200);
        $(".paymentInfo.paid .transactionId .value").text(order.tid);
      } else if(order.status == 3) {
        $(".paymentInfo.underpaid").fadeIn(200);
        $(".paymentInfo.underpaid .transactionId .value").text(order.tid);
      } else if(order.status == 4) {
        $(".paymentInfo.overpaid").fadeIn(200);
        $(".paymentInfo.overpaid .transactionId .value").text(order.tid);
      } else if(order.status == 5) {
        $(".paymentInfo.expired").fadeIn(200);
      }
      if(GearPayment.update_straight_widget_height) {
        GearPayment.update_straight_widget_height();
      }
    }
  }

  GearPayment.countdown = function() {

    var el = $(".timeLeft .value");
    var seconds = parseInt(el.attr('data-time-left'));
    var minutes = Math.floor(seconds/60);
    seconds     = seconds - minutes*60;

    GearPayment.interval = setInterval(function() {
      if(seconds == 0) {
        if(minutes == 0) {
          $(".paymentInfo").hide();
          $(".paymentInfo.expired").fadeIn(200);
          clearInterval(GearPayment.interval);
          return;
        } else {
          minutes--;
          seconds = 59;
        }
      }
      seconds_string = (seconds < 10) ? "0" + seconds : seconds;
      el.text(minutes + ":" + seconds_string);
      seconds--;
    }, 1000);
  }

  GearPayment.connect_to_websocket = function() {
    console.log("Connecting to websocket, attempt " + GearPayment.reconnection_attempts + '...');
    console.log("Websocket URL: " + new_uri + '/gateways/' + GearPayment.gateway_id + '/orders/' + GearPayment.payment_id + '/websocket');
    GearPayment.socket = new WebSocket(new_uri + '/gateways/' + GearPayment.gateway_id + '/orders/' + GearPayment.payment_id + '/websocket');

    GearPayment.socket.onmessage = function(s) {
      GearPayment.display_status_changed_for(s.data);
    };

    GearPayment.socket.onopen = function(s) {
      GearPayment.reconnection_attempts = 0;
      GearPayment.ws_keepalive          = true;
      ws_keepalive();
      console.log("Connected to websocket, tracking payment status now!")
    };

    GearPayment.socket.onclose = function(s) {
      GearPayment.ws_keepalive = false;
      if(!s.wasClean) {
        console.log("Connection to the websocket was lost.")
        if(GearPayment.reconnection_attempts < 15) {
          GearPayment.reconnection_attempts++;
          setTimeout(function() {
            connect_to_websocket()
          }, 5000); 
        } else {
          clearInterval(GearPayment.interval);
          $(".paymentInfo").hide();
          $(".paymentInfo.connectionProblem").fadeIn(200);
        }
      }
    };
  }

  var loc = window.location, new_uri;
  if (loc.protocol === "https:") {
      new_uri = "wss:";
  } else {
      new_uri = "ws:";
  }
  new_uri += "//" + loc.host;

});
