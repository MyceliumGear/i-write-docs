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

  def self.config
    Config.instance
  end

  class Config
    include Singleton
    
    attr_accessor :subproject

    def initialize
      @default_subproject = ENV['DEFAULT_SUBPROJECT'] || 'gear'
    end

    def documentation_path
      ENV['DOCUMENTATION_PATH'] || raise(IWriteDocsError.new("DOCUMENTATION_PATH not provided in ENV"))
    end

    def docs_tree
      IWriteDocs::DocsTree.new.tree
    end

    def build_folder
      ENV['BUILD_FOLDER'] || 'build'
    end

    def source_folder
      ENV["SOURCE_FOLDER"] || 'source'
    end

    def subproject
      @subproject || @default_subproject
    end
  end
  
  # def self.setup
  #   yield self.config
  # end

end
