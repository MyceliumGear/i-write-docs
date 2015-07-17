class WidgetThemeCannotBeNull < ActiveRecord::Migration
  def change
    Widget.where(theme: nil).update_all(theme: 'Gray')
    change_column :widgets, :theme, :string, default: 'Gray', null: false
  end
end
