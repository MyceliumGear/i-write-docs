class WidgetPaymentNotificationsWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  CHECK_INTERVAL = 15 # in minutes

  recurrence { minutely(CHECK_INTERVAL) }

  def perform(*args)
    WidgetPaymentsNotificationMailer.deliver_all!(CHECK_INTERVAL.minutes)
  end
end
