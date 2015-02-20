class CreateGateways < ActiveRecord::Migration
  def change
    create_table :gateways do |t|
      t.integer :confirmations_required, null: false, default: 0
      t.string  :pubkey, null: false
      t.string  :name,   null: false
      t.string  :default_currency, null: false, default: 'BTC'
      t.string  :callback_url
      t.boolean :check_signature, null: false, default: true
      t.boolean :active, null: false, default: true
      t.string  :exchange_rate_adapter_names

      t.belongs_to :user
      t.integer    :straight_gateway_id

      t.text   :description
      t.string :merchant_url
      t.string :merchant_name
      t.string :country
      t.string :region
      t.string :city

      t.text   :db_config

      t.timestamps null: false
    end

    add_index :gateways, :user_id

  end
end
