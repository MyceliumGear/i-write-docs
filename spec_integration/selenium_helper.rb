require_relative '../spec/spec_helper'
require 'headless'
require 'selenium-webdriver'
require 'fileutils'

RSpec.configure do |config|

  config.before :suite do
    $recordings_dir = "#{ENV['HOME']}/recordings/#{ENV['BUILD_TAG'] || 'admin_app'}".freeze
    $headless = Headless.new(
      video: {
        frame_rate: 12,
        codec:      'libx264',
      },
    )
    $headless.start
  end

  config.after :suite do
    $headless.destroy
  end

  config.before :each do
    $headless.video.start_capture
  end

  config.after :each do |example|
    if example.exception
      FileUtils.mkdir_p $recordings_dir
      recording = "#{example.location[2..-1].tr('/:', '_')}.mov"
      $headless.video.stop_and_save "#{$recordings_dir}/#{recording}"
    end
  end
end
