class User < ActiveRecord::Base
	attr_accessor :gauth_token

  devise :google_authenticatable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable, :timeoutable

  enum role: { merchant: 0, admin: 1 }

  has_many :gateways

  def admin?
    role == 'admin'
  end

end
