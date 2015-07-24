module DeviseFilters
  def self.add_filters
    Devise::PasswordsController.before_filter :disable_recovery_unless_user_confirmed, only: :create
  end

  self.add_filters
end
