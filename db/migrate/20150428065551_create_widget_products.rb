class CreateWidgetProducts < ActiveRecord::Migration
  def change
    create_table :widget_products do |t|
      t.belongs_to :widget
      t.string :title
      t.float  :price
      t.timestamps null: false
    end
    add_index :widget_products, :widget_id
  end
end
