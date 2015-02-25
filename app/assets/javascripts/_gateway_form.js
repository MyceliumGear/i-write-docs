jQuery(function($){

  var exchange_adapter_selects = $("#exchange_rate_adapter_name_1, #exchange_rate_adapter_name_2, #exchange_rate_adapter_name_3")

  function collectExchangeRateAdapterNames() {
    var names       = [];
    var uniqueNames = [];
    exchange_adapter_selects.each(function() {
    names.push($(this).val());
    });
    $.each(names, function(i, el){
      if($.inArray(el, uniqueNames) === -1) uniqueNames.push(el);
    });
    $("#gateway_exchange_rate_adapter_names").val(uniqueNames.join(','));
  }

  exchange_adapter_selects.change(function() {
    collectExchangeRateAdapterNames();
  });

  collectExchangeRateAdapterNames();

});
