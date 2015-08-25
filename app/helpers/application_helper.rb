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

  DOCS = [
    ["Table of contents", '/docs'],
    ["Overview of payment processing", '/docs/overview'],
    ["Creating a new gateway", '/docs/creating_gateway'],
    ["Signed request", '/docs/signed_request'],
    ["Creating orders", '/docs/creating_orders'],
    ["Receiving order status change callback", '/docs/callback'],
    ["Checking order status manually", '/docs/checking_order_status'],
    ["Order websocket", '/docs/order_websocket'],
    ["Order cancellation", '/docs/order_cancellation'],
    ["Receiving last keychain id for gateway", '/docs/last_keychain_id'],
    ["Table of contents", '/docs'],
  ]

  def docs_links_for(page)
    index = DOCS.find_index { |item| item[1].end_with?("/#{page}") }
    prev_item = DOCS[index - 1]
    next_item = DOCS[index + 1]
    [
      link_to("&#8592; Previous (#{prev_item[0]})".html_safe, prev_item[1]),
      link_to("Next (#{next_item[0]}) &#8594;".html_safe, next_item[1]),
    ]
  end
end
