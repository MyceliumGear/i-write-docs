class SetTestModeDefaultToFalse < ActiveRecord::Migration
  def change
    change_column :gateways, :test_mode, :boolean, default: false
  end
end
