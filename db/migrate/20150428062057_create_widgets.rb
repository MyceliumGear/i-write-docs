class CreateWidgets < ActiveRecord::Migration
  def change
    create_table :widgets do |t|
      t.belongs_to :gateway
      t.text       :fields
      t.boolean    :variable_price
      t.timestamps null: false
    end
    add_index :widgets, :gateway_id, unique: true
  end
end
