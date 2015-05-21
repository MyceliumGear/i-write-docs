jQuery(function($) {

  var gear_widget_settings = {};
  var widget_host          = {};
  GearPayment.payment_id = 0;
  GearPayment.gateway_id     = $('#gear-widget').data().gatewayId;

  GearPayment.update_gear_widget_height = function() {
    widget_host.source.postMessage({
      eventName: 'gear-widget-height-change',
      newHeight: $(document).height()
    }, widget_host.origin);
  };

  window.addEventListener('message', function(event) {
    widget_host = { source: event.source, origin: event.origin };
    GearPayment.host = event.data.gateway_host;
    GearPayment.update_gear_widget_height();
  }, false);


  $("#create_order").click(function() {

    if(GearPayment.host.match(/^https?:\/\/admin/)) { return; }

    var product_data = {};
    if($(".productInfo .productSelector select").val()) {
      var product_title_and_price = $(".productInfo .productSelector select").val().split(':');
      product_data['product_title'] = product_title_and_price[0];
      var product_price = product_title_and_price[1];
    } else if($("#variable_price").length > 0) {
      product_price = $("#variable_price").val();
      if(!product_price.match(/^[0-9]+\.?[0-9]*$/)) {
        alert("Please insert correct amount, must be a number");
        return;
      }
    } else {
      var product_price = $(".productInfo .price .amount").text();
    }

    var form_errors = [];
    $(".productInfo .field input").each(function() {
      product_data[$(this).attr('name')] = $(this).val();
      if($(this).data('required') == '1' && $(this).val() == '') {
        form_errors.push($(this).attr('name') + ' field is required');
      }
    });
    if(form_errors.length > 0) {
      alert(form_errors.join("\n"));
      return;
    }

    $(this).attr("disabled", "disabled").addClass('disabled');
    $(this).text("Wait...");

    $.ajax({
      method: 'POST',
      url: GearPayment.host + "/gateways/" + GearPayment.gateway_id + "/orders",
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
        $(".paymentInfo.new .qrcode a").attr('href', 'bitcoin:' + resp.address + '?amount=' + resp.amount_in_btc);
        $(".paymentInfo.new").show();
        GearPayment.update_gear_widget_height();
      }
    });
  });

  $("textarea.depositAddressString, textarea.transactionId").focus(function() {
    this.select(); 
  });

  $("a").click(function() {
    widget_host.source.postMessage({
      eventName: 'redirect',
      location: $(this).attr('href')
    }, widget_host.origin);
    return false;
  });

});
