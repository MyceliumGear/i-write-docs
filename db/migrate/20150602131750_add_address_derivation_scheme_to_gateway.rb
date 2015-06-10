class AddAddressDerivationSchemeToGateway < ActiveRecord::Migration
  def change
    add_column :gateways, :address_derivation_scheme, :string
  end
end
