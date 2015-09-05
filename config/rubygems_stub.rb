# http://andre.arko.net/2014/06/27/rails-in-05-seconds/
module Gem
  # ActiveRecord requires Gem::LoadError to load
  class LoadError < ::LoadError; end

  # BacktraceCleaner wants path and default_dir
  def self.path; []; end
  def self.default_dir
    @default_dir ||= File.expand_path("../../bundle/#{RUBY_ENGINE}/#{RbConfig::CONFIG['ruby_version']}", __FILE__)
  end

  # irb/locale.rb calls this if defined?(Gem)
  def self.try_activate(*); end
end

module Kernel
  # ActiveSupport requires Kernel.gem to load
  def gem(*); end
  # rdoc/task.rb in Ruby 2.1.2 requires rubygems itself :(
  alias_method :orig_require, :require
  def require(*args); args.first == 'rubygems' || orig_require(*args); end
end
