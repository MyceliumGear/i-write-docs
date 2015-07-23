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

  function disableOptionsInSelectors() {
    var values = [];
    exchange_adapter_selects.each(function() {
      values.push(this.value)
      for (i = 0; i < this.options.length; ++i) {
        this.options[i].disabled = false;
      };
    });
    exchange_adapter_selects.each(function() {
      for (i = 0; i < this.options.length; ++i) {
        if (values.indexOf(this.options[i].value) != -1 && this.options[i].value != this.value ) {
          this.options[i].disabled = true;
        }
      };
    });
    exchange_adapter_selects.trigger("chosen:updated");
  }

  exchange_adapter_selects.change(function() {
    disableOptionsInSelectors();
    collectExchangeRateAdapterNames();
  });

  disableOptionsInSelectors();
  collectExchangeRateAdapterNames();

});
