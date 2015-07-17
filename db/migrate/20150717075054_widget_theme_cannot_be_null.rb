class WidgetThemeCannotBeNull < ActiveRecord::Migration
  def change
    change_column :widgets, :theme, :string, default: 'Gray', null: false
    Widget.all.each do |widget|
      widget.update_attributes!(theme:'Gray') if widget.theme.nil?
    end
  end
end
