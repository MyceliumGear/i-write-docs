class UpdateItem < ActiveRecord::Base
  validates :priority, :subject, :body, presence: true

  enum priority: [:regular, :important, :critical]
end
