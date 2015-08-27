require 'yaml'
require 'tree'
require 'redcarpet'
require 'pygments'

require_relative 'i-write-docs/docs_tree'
require_relative 'i-write-docs/markdown_render'
require_relative 'i-write-docs/generator'
require_relative 'i-write-docs/doc_filter'

module IWriteDocs

  class IWriteDocsError < StandardError; end
  
  def self.docs_tree
    IWriteDocs::DocsTree.new.tree
  end

  # def self.setup
  #   yield self.config
  # end

end
