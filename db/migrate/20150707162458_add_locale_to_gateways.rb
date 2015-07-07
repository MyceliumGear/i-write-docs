class AddLocaleToGateways < ActiveRecord::Migration
  def change
    add_column :gateways, :locale, :string
  end
end
