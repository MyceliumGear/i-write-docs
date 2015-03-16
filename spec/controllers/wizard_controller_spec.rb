require 'rails_helper'

RSpec.describe WizardController, type: :controller do

  describe "detect_site_type action" do

    it "detects wordpress" do
      post :detect_site_type, url: 'https://wordpress.org/news/'
      expect(response.body).to eq('wordpress')
    end

    it "detects shopify" do
      post :detect_site_type, url: 'http://personal-prints.com/'
      expect(response.body).to eq('shopify')
    end

    it "returns a string containing site type" do
      post :detect_site_type, url: 'http://mycelium.com'
      expect(response.body).to eq('unknown')
    end

    it "returns error if URL is unreachable" do
      post :detect_site_type, url: 'non existent site url'
      expect(response.body).to eq('ERROR: connection to the website is refused')
    end

  end

end
