module OrdersHelper
  def status_filter_collection
    statuses = []
    StraightServer::Order::STATUSES.invert.each do |status|
      statuses << [status.first, I18n.t("#{status.second}", scope: 'orders.index')]
    end
    statuses
  end
end
