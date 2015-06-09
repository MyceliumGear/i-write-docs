class AddReceivePaymentsNotificationsFlagToGateways < ActiveRecord::Migration

  def up
    add_column :gateways, :receive_payments_notifications, :boolean, null: false, default: false
    add_index :gateways, :receive_payments_notifications
    Gateway.has_widget.update_all(receive_payments_notifications: true)
  end

  def down
    remove_column :gateways, :receive_payments_notifications
  end
end
