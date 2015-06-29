class AddTestPubkeyToGateway < ActiveRecord::Migration
  def change
    add_column :gateways, :test_pubkey, :string
  end
end
