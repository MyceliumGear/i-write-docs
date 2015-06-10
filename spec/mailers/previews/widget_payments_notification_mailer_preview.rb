# Preview all emails at http://localhost:3000/rails/mailers/widget_payments_notification_mailer
class WidgetPaymentsNotificationMailerPreview < ActionMailer::Preview

  def notification
    @@gateway ||= FactoryGirl.create(:widget_gateway)
    @@data ||= {
      @@gateway => {
        paid: [FactoryGirl.build(:straight_order, payment_id: 'payment1', gateway_id: @@gateway.straight_gateway_id, status: Straight::Order::STATUSES[:paid])],
        overpaid: [FactoryGirl.build(:straight_order, payment_id: 'payment2', gateway_id: @@gateway.straight_gateway_id, status: Straight::Order::STATUSES[:overpaid])],
        underpaid: [FactoryGirl.build(:straight_order, payment_id: 'payment3', gateway_id: @@gateway.straight_gateway_id, status: Straight::Order::STATUSES[:underpaid])],
      }
    }
    WidgetPaymentsNotificationMailer.widget_payments_notification(@@gateway.user, @@data)
  end
end
