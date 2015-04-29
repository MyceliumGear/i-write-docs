jQuery(function($) {

  var gear_widget_settings = {};
  var widget_host          = {};
  GearPayment.payment_id = 0;
  GearPayment.gateway_id = 0;

  GearPayment.update_gear_widget_height = function() {
    widget_host.source.postMessage({
      eventName: 'gear-widget-height-change',
      newHeight: $(document).height()
    }, widget_host.origin);
  };

  window.addEventListener('message', function(event) {
    gear_widget_settings = {
      path:         event.data.path,
      url:          event.origin + event.data.path,
      gateway_id:   event.data.gateway_id,
      price:        event.data.price,
      currency:     event.data.currency,
      title:        event.data.title,
      products:     event.data.products,
      gateway_host: event.data.gateway_host
    }

    widget_host = { source: event.source, origin: event.origin };

    GearPayment.update_gear_widget_height();
    GearPayment.gateway_id     = gear_widget_settings.gateway_id;
    GearPayment.host           = gear_widget_settings.gateway_host;
    GearPayment.websocket_port = $('#gear-widget').data().websocketPort;

    $(".productInfo .title").text(gear_widget_settings.title);
    $(".productInfo .price .amount").text(gear_widget_settings.price);
    $(".productInfo .price .currency").text(gear_widget_settings.currency);

    // If we have multiple products, show the dropdown list
    // with product names and prices.
    if(gear_widget_settings.products) {
      gear_widget_settings.products.split(',').forEach(function (item) {
        var title_and_price = item.split(':');
        var option = $('<option value="' + item + '">' + title_and_price[0] + ' - ' +  title_and_price[1] + gear_widget_settings.currency + '</option>');
        $(".productInfo .productSelector select").append(option);
        $(".productInfo .title").hide();
        $(".productInfo .price").hide();
        $(".productInfo .productSelector").show();
      });

    }

  }, false);

  $("button#create_order").click(function() {

    $(this).attr("disabled", "disabled");
    $(this).val("Wait...");

    var product_data = { 'origin_url': gear_widget_settings.url, 'buyer_email': $("input#email").val() };
    if($(".productInfo .productSelector select").val()) {
      var product_title_and_price = $(".productInfo .productSelector select").val().split(':');
      product_data['product_title'] = product_title_and_price[0];
      var product_price = product_title_and_price[1];
    } else {
      var product_price = gear_widget_settings.price;
    }

    $.ajax({
      method: 'POST',
      url: GearPayment.host + "/gateways/" + gear_widget_settings.gateway_id + "/orders",
      data: {
        amount: product_price,
        currency: gear_widget_settings.currency,
        btc_denomination: 'BTC',
        data: product_data
      },
      success: function(resp) {

        resp       = JSON.parse(resp);
        GearPayment.payment_id = resp.payment_id;

        GearPayment.countdown();
        GearPayment.connect_to_websocket();

        var qrcode = new QRCode(document.getElementById("qrcode"), {
          text: "bitcoin:" + resp.address + "?amount=" + resp.amount_in_btc,
          width: 100,
          height: 100,
          colorDark : "#000000",
          colorLight : "#ffffff",
          correctLevel : QRCode.CorrectLevel.M
        });

        $(".productInfo").hide();
        $(".amount").text(resp.amount_in_btc);
        $(".paymentInfo.new textarea.depositAddressString").val(resp.address);
        $(".paymentInfo.new").show();
        GearPayment.update_gear_widget_height();
      }
    });
  });

  $("textarea.depositAddressString, textarea.transactionId").focus(function() {
    this.select(); 
  });

});
