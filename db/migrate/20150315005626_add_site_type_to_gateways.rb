class AddSiteTypeToGateways < ActiveRecord::Migration
  def change
    add_column :gateways, :site_type, :string
  end
end
