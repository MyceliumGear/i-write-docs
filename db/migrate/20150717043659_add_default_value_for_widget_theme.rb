class AddDefaultValueForWidgetTheme < ActiveRecord::Migration
  def change
    change_column :widgets, :theme, :string, default: 'gray'
  end
end
