require 'selenium_helper'

RSpec.describe "integration tests", type: :feature do

  before :each do
    @driver   = Selenium::WebDriver.for(:firefox)
    @base_url = ENV['TARGET']
  end

  after :each do
    @driver.quit
  end

  it "visits page" do
    @driver.get @base_url
    raise "recorded!"
  end
end
