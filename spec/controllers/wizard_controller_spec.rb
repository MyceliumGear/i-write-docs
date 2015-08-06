require 'rails_helper'

RSpec.describe WizardController, type: :controller do
  it_should_require_signed_in_user [:step, :create_gateway], :gateway

  describe "detect_site_type action" do

    it "detects wordpress" do
      VCR.use_cassette 'wordpress.org' do
        post :detect_site_type, url: 'https://wordpress.org/news/'
      end
      expect(response.body).to eq('wordpress')
    end

    it "detects joomla" do
      VCR.use_cassette 'gsas.harvard.edu' do
        post :detect_site_type, url: 'http://gsas.harvard.edu/'
      end
      expect(response.body).to eq('joomla')
    end

    it "detects drupal" do
      VCR.use_cassette 'transportation.gov' do
        post :detect_site_type, url: 'http://www.transportation.gov/'
      end
      expect(response.body).to eq('drupal')
    end

    it "returns a string containing site type" do
      VCR.use_cassette 'mycelium.com' do
        post :detect_site_type, url: 'http://mycelium.com'
      end
      expect(response.body).to eq('unknown')
    end

    it "returns error if URL is unreachable" do
      post :detect_site_type, url: 'non existent site url'
      expect(response.body).to eq('connectionError')
    end

  end

end
