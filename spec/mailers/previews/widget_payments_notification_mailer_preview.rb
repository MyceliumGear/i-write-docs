# Preview all emails at http://localhost:3000/rails/mailers/widget_payments_notification_mailer
class WidgetPaymentsNotificationMailerPreview < ActionMailer::Preview

  def notification
    @@gateway ||= FactoryGirl.create(:widget_gateway)
    @@data ||= {
      @@gateway => {
        paid: [FactoryGirl.build(:straight_order, payment_id: 'payment1', gateway_id: @@gateway.straight_gateway_id, status: Straight::Order::STATUSES[:paid], data: {'product_title' => 'whistle'}, tid: 'e2bdabf32b90024b405830fee69b454512aae12950e4736e023c58795abb8d36')],
        overpaid: [FactoryGirl.build(:straight_order, payment_id: 'payment2', gateway_id: @@gateway.straight_gateway_id, status: Straight::Order::STATUSES[:overpaid], tid: 'e2bdabf32b90024b405830fee69b454512aae12950e4736e023c58795abb8d36')],
        underpaid: [FactoryGirl.build(:straight_order, payment_id: 'payment3', gateway_id: @@gateway.straight_gateway_id, status: Straight::Order::STATUSES[:underpaid], tid: 'e2bdabf32b90024b405830fee69b454512aae12950e4736e023c58795abb8d36')],
      }
    }
    WidgetPaymentsNotificationMailer.widget_payments_notification(@@gateway.user, @@data)
  end
end
