module ApplicationHelper

  def gateway_id_for_order(o)
    if @gateways
      @gateways.each { |g| return g.id if o.gateway_id == g.straight_gateway_id }
    end
    nil
  end

  def blockchain_url(tid: nil)
    if tid
      link_to "#{tid[0, 5]}..#{tid[-5, 5]}", "https://blockchain.info/tx/#{tid}"
    end
  end

  def user_address_providers
    current_user.address_providers.map do |provider|
      ["#{provider.class::CURRENCIES.join(' ')} | #{provider.display_name}", provider.id]
    end
  end
end
