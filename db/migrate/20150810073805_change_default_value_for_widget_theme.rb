class ChangeDefaultValueForWidgetTheme < ActiveRecord::Migration
  def change
    Widget.all.find_each { |widget| widget.update_attributes(theme: widget.theme.downcase) }
    change_column :widgets, :theme, :string, default: 'gray', null: false
  end
end
