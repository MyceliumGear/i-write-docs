ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)

if File.exist?(File.expand_path('../../bundle/bundler/setup.rb', __FILE__))
  require_relative '../bundle/bundler/setup' # standalone bundle
  require_relative 'rubygems_stub'
else
  require 'bundler/setup' # Set up gems listed in the Gemfile.
end
