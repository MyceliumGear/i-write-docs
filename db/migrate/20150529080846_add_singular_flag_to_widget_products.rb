class AddSingularFlagToWidgetProducts < ActiveRecord::Migration
  def change
    add_column :widget_products, :singular, :boolean, null: false, default: true
  end
end
