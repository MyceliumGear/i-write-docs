class AddFieldsForAfterPaymentRedirect < ActiveRecord::Migration
  def change
    add_column :gateways, :after_payment_redirect_to, :text
    add_column :gateways, :auto_redirect, :boolean, null: false, default: false
  end
end
