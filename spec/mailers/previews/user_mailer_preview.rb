class UserMailerPreview < ActionMailer::Preview
  
  def update
    user = User.new(email: "to.arsen.gasparyan@gmail.com")
    update_item = UpdateItem.new(subject: "Subject", body: "Body", priority: :critical)

    UserMailer.update(user, update_item)
  end

end
