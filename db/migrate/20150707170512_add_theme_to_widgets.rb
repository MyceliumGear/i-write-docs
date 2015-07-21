class AddThemeToWidgets < ActiveRecord::Migration
  def change
    add_column :widgets, :theme, :string
  end
end
