require 'yaml'
require 'tree'

require_relative 'i-write-docs/docs_tree'

module IWriteDocs

  class IWriteDocsError < StandardError; end
  
  def self.docs_tree
    IWriteDocs::DocsTree.new.tree
  end

  # def self.setup
  #   yield self.config
  # end

end
