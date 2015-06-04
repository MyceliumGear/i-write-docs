class DeviseMailerPreview < ActionMailer::Preview
  def reset_password_instructions
    Devise::Mailer.reset_password_instructions(user, "token")
  end

  def confirmation_instructions
    Devise::Mailer.confirmation_instructions(user, "token")
  end

  def unlock_instructions
    Devise::Mailer.unlock_instructions(user, "token")
  end

  private
  
    def user
      User.new(email: "to.arsen.gasparyan@gmail.com")
    end
end
