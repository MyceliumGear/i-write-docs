class UserMailer < ApplicationMailer

  # TODO: move to UpdatesMailer
  def update_item(user, update_item)
    @update = update_item
    @user = user
    mail(to: user.email)
  end

end
