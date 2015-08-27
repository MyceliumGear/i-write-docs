class WidgetPaymentsNotificationMailer < ApplicationMailer

  # @param [User] user
  # @param [Hash[Gateway,Hash[:status,Array[StraightServer::Order]]]] data
  def widget_payments_notification(user, data)
    @user = user
    @data = data
    mail(to: @user.email, subject: I18n.t("widget_payments_notification_mailer.subject"))
  end

  # @param [Integer] timeframe in seconds
  # emails all {over,under,}paid orders with created_at between Time.now - timeframe and Time.now
  def self.deliver_all!(timeframe)
    each_recipient(timeframe) do |user, data|
      widget_payments_notification(user, data).deliver_now
    end
  end

  def self.each_recipient(timeframe)
    raise ArgumentError, 'Invalid timeframe' if timeframe.to_i <= 0
    now        = Time.now
    created_at = now - timeframe.to_i .. now
    User.find_each do |user|
      data = {}
      user.gateways.receives_payments_notifications.find_each do |gateway|
        new_orders    = gateway.orders(conditions: {created_at: created_at}).group_by(&:status)
        report_orders = %i{paid overpaid underpaid}.each_with_object({}) do |status, h|
          orders    = new_orders[Straight::Order::STATUSES[status]]
          h[status] = orders if orders
        end
        data[gateway] = report_orders unless report_orders.empty?
      end
      yield user, data unless data.empty?
    end
  end
end
