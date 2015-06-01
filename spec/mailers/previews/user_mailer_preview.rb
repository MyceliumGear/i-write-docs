class UserMailerPreview < ActionMailer::Preview
  
  def update_item
    user = User.new(email: "to.arsen.gasparyan@gmail.com")
    update_item = UpdateItem.new(subject: "Subject", body: "Body", priority: :critical)

    UserMailer.update_item(user, update_item)
  end

end
