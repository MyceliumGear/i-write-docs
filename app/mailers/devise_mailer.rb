class Devise::Mailer
  include Roadie::Rails::Automatic

  private
    def roadie_options
      super unless Rails.env.test?
    end
end
