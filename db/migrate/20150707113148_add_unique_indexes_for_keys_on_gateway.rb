class AddUniqueIndexesForKeysOnGateway < ActiveRecord::Migration
  def up
    change_column :gateways, :pubkey, :string, null: true
    Gateway.where(pubkey: "").update_all(pubkey: nil)
    
    add_index :gateways, :pubkey, unique: true
    add_index :gateways, :test_pubkey, unique: true
    add_index :gateways, :name, unique: true
  end

  def down
    change_column :gateways, :pubkey, :string, null: false
    remove_index :gateways, :pubkey
    remove_index :gateways, :test_pubkey
    remove_index :gateways, :name
  end
end
