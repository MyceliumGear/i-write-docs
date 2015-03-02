class AddOrdersExpirationPeriodToGateways < ActiveRecord::Migration
  def change
    add_column :gateways, :orders_expiration_period, :integer, null: false, default: 900 # seconds 
  end
end
