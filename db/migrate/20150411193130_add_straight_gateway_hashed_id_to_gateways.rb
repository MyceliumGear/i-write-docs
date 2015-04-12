class AddStraightGatewayHashedIdToGateways < ActiveRecord::Migration

  def change
    add_column :gateways, :straight_gateway_hashed_id, :string
  end

end
