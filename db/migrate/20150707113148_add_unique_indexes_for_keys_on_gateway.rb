class AddUniqueIndexesForKeysOnGateway < ActiveRecord::Migration
  def change
    add_index :gateways, :pubkey, unique: true
    add_index :gateways, :test_pubkey, unique: true
    add_index :gateways, :name, unique: true
  end
end
