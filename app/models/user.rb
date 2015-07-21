class User < ActiveRecord::Base
  attr_accessor :gauth_token

  devise :google_authenticatable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable, :timeoutable

  enum role: [:merchant, :admin]

  validates :updates_email_subscription_level, inclusion: {
    in: UpdateItem.priorities.values }, allow_nil: true

  has_many :gateways
  has_many :address_providers

  scope :subscribed_to, ->(level) { 
    where("updates_email_subscription_level <= ?", UpdateItem.priorities[level])
  }
  scope :subscribed_to_updates, -> {
    where.not(updates_email_subscription_level: nil)
  }

  def has_unreaded_updates?
    return false unless updates_email_subscription_level

    UpdateItem.exists?(["id > ? AND priority >= ?",
      last_read_update_id.to_i, updates_email_subscription_level])
  end
end
