class CreateUpdateItems < ActiveRecord::Migration
  def change
    create_table :update_items do |t|
      t.integer :priority, default: 0
      t.text :subject
      t.text :body

      t.timestamps null: false
    end
  end
end
