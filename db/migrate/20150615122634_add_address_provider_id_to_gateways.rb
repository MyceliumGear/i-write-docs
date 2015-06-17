class AddAddressProviderIdToGateways < ActiveRecord::Migration
  def change
    change_table :gateways do |t|
      t.belongs_to :address_provider
    end
  end
end
