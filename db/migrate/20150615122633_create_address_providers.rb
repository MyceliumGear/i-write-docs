class CreateAddressProviders < ActiveRecord::Migration
  def change
    create_table :address_providers do |t|
      t.string :type, null: false
      t.belongs_to :user
      t.string :name
      t.hstore :user_details
      t.hstore :credentials
      t.timestamps null: false
    end

    add_index :address_providers, :type
  end
end
