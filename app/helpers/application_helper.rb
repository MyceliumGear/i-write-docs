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

  def docs_links_for(page)
    docs = [
      [I18n.t("pages.docs.link"), '/docs'],
      [I18n.t("pages.docs.index.links.payment_proccessing"), '/docs/overview'],
      [I18n.t("pages.docs.index.links.new_gateway"), '/docs/creating_gateway'],
      [I18n.t("pages.docs.index.links.signed_request"), '/docs/signed_request'],
      [I18n.t("pages.docs.index.links.creating_orders"), '/docs/creating_orders'],
      [I18n.t("pages.docs.index.links.callback"), '/docs/callback'],
      [I18n.t("pages.docs.index.links.order_status"), '/docs/checking_order_status'],
      [I18n.t("pages.docs.index.links.websocket"), '/docs/order_websocket'],
      [I18n.t("pages.docs.index.links.order_cancellation"), '/docs/order_cancellation'],
      [I18n.t("pages.docs.index.links.last_keychain"), '/docs/last_keychain_id'],
      [I18n.t("pages.docs.link"), '/docs'],
    ]

    index = docs.find_index { |item| item[1].end_with?("/#{page}") }
    prev_item = docs[index - 1]
    next_item = docs[index + 1]
    [
      link_to("&#8592; #{I18n.t('prev')} (#{prev_item[0]})".html_safe, prev_item[1]),
      link_to("#{I18n.t('next')} (#{next_item[0]}) &#8594;".html_safe, next_item[1]),
    ]
  end

  def subscriptions_collection
    values = {}
    UpdateItem.priorities.each do |value|
      values[I18n.t("devise.devise_registrations.#{value.first}")] = value.second
    end
    values
  end

  def localized_doc_page_for(name, locale = I18n.locale)
    if File.exists?("#{Rails.root}/app/views/pages/docs/md/#{locale}/#{name}.md")
      return "pages/docs/md/#{locale}/#{name}.md"
    else
      return "pages/docs/md/#{I18n.default_locale}/#{name}.md"
    end
  end
end
