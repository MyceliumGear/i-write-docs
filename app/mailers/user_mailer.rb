class UserMailer < ApplicationMailer

  def update(user, update_item)
    @update_item = update_item
    mail(to: user.email)
  end

end
