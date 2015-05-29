class UpdateItem < ActiveRecord::Base
  scope :newest, -> { order(created_at: :desc) }

  validates :priority, :subject, :body, presence: true

  enum priority: [:regular, :important, :critical]
end
