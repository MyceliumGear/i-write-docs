class AddAllowLinksFlagToGateways < ActiveRecord::Migration
  def change
    add_column :gateways, :allow_links, :boolean, default: false, null: false
  end
end
