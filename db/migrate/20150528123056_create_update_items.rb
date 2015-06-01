class CreateUpdateItems < ActiveRecord::Migration
  def change
    create_table :update_items do |t|
      t.integer :priority, default: 0
      t.text :subject
      t.text :body
      t.datetime :sent_at

      t.timestamps null: false
    end

    add_column :users, :last_read_update_id, :integer
    add_column :users, :updates_email_subscription_level, :integer
    add_index  :users, :updates_email_subscription_level
  end
end
