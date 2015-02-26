class User < ActiveRecord::Base

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable, :timeoutable

  enum role: { merchant: 0, admin: 1 }

  has_many :gateways

  def admin?
    role == 'admin'
  end

end
