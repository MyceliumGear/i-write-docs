class AdminController < ActionController::Base

  def stats
    now   = Time.current
    @data = [
      [:gateways, Gateway.has_widget(false)],
      [:widgets, Widget],
      [:users, User],
      [:paid_orders, StraightServer::Order.where(status: StraightServer::Order::STATUSES[:paid])],
    ].each_with_object({}) do |(key, records), result|
      result[key] = {
        day:   records.where(created_at: now.beginning_of_day..now).count,
        week:  records.where(created_at: now.beginning_of_week..now).count,
        month: records.where(created_at: now.beginning_of_month..now).count,
        total: records.count,
      }
    end
  end
end
