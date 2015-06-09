class ChnageUserSubscriptionLevel < ActiveRecord::Migration
  def up
    change_column :users, :updates_email_subscription_level, :integer, default: 1

    data_migration_up
  end

  def down
    change_column :users, :updates_email_subscription_level, :integer, default: 0

    data_migration_down
  end

  private

    def data_migration_up
      User.where(updates_email_subscription_level: 0)
        .update_all(updates_email_subscription_level: 1)
    end

    def data_migration_down
      User.where(updates_email_subscription_level: 1)
        .update_all(updates_email_subscription_level: 0)
    end
end
