class UpdateItem < ActiveRecord::Base

  enum priority: [:regular, :important, :critical]

  validates :priority, :subject, :body, presence: true

  scope :newest_first, -> { order(created_at: :desc) }
  scope :critical_first, -> { order(priority: :desc) }
  scope :unsent, -> { where(sent_at: nil) }

  def interesting_for?(user)
    return false unless user.updates_email_subscription_level
    user.updates_email_subscription_level <= self.class.priorities[priority]
  end

  def sent!
    touch :sent_at unless sent_at
  end
end
