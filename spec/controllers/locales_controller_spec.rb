require 'rails_helper'

RSpec.describe LocalesController, type: :controller do

  it "should change locale" do
    pending "app should contain more than one locale" unless I18n.available_locales.many?
    session[:locale] = nil
    locale = (I18n.available_locales - [I18n.default_locale]).sample
    get :switch, {locale: locale}

    expect(session[:locale].to_sym).to eq(locale)
  end
end
