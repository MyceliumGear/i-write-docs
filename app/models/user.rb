class User < ActiveRecord::Base
	attr_accessor :gauth_token

  devise :google_authenticatable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable, :timeoutable

  enum role: [:merchant, :admin]

  has_many :gateways

  def admin?
    role == 'admin'
  end

  protected

    def send_devise_notification(notification, *args)
      devise_mailer.send(notification, self, *args).deliver_later
    end

end
