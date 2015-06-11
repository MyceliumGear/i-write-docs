class WidgetPaymentNotificationsWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  CHECK_INTERVAL = 15 # in minutes

  recurrence { hourly.minute_of_hour((0..59).step(CHECK_INTERVAL).to_a) }

  def perform(*args)
    WidgetPaymentsNotificationMailer.deliver_all!(CHECK_INTERVAL.minutes)
  end
end
