class UserMailer < ApplicationMailer

  def update_item(user, update_item)
    @update = update_item
    mail(to: user.email)
  end

end
