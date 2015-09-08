class ChangeColumnTypes < ActiveRecord::Migration
  def change
   change_column :gateways, :callback_url, :text
   change_column :gateways, :merchant_url, :text
  end
end
