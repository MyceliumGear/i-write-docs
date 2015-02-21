class User < ActiveRecord::Base

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable, :timeoutable

  enum role: { merchant: 0, admin: 1 }

  def admin?
    role == 'admin'
  end

end
