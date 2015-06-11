# Preview all emails at http://localhost:3000/rails/mailers/updates_mailer
class UpdatesMailerPreview < ActionMailer::Preview

  def updates_mail
    @@user    ||= FactoryGirl.create(:user)
    @@updates ||=
      FactoryGirl.create_list(:critical_update, 1).concat(
        FactoryGirl.create_list(:important_update, 3)
      ).concat(
        FactoryGirl.create_list(:regular_update, 5)
      )
    UpdatesMailer.updates_mail(@@user, @@updates)
  end
end
