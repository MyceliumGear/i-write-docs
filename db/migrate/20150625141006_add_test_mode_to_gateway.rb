class AddTestModeToGateway < ActiveRecord::Migration
  def change
    add_column :gateways, :test_mode, :boolean, default: false
  end
end
