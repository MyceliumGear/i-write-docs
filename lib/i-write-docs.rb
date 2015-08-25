require 'yaml'
require 'tree'

require_relative 'i-write-docs/config'

module IWriteDocs

  class IWriteDocsError < StandardError; end
  
  def self.config
    IWriteDocs::Config.new
  end

  def self.setup
    yield self.config
  end

end
