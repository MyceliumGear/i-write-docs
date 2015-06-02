task :widget_payments_notification, [:timeframe] => :environment do |_, args|
  WidgetPaymentsNotificationMailer.deliver_all!(args[:timeframe])
end
