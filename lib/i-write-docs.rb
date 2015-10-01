require 'singleton'
require 'yaml'
require 'tree'
require 'redcarpet'
require 'pygments'
require 'rugged'
require 'haml'

require_relative 'i-write-docs/diff_to_html'
require_relative 'i-write-docs/docs_tree'
require_relative 'i-write-docs/markdown_render'
require_relative 'i-write-docs/generator'
require_relative 'i-write-docs/doc_filter'
require_relative 'i-write-docs/git_adapter'
# require_relative 'i-write-docs/engine'

module IWriteDocs

  class IWriteDocsError < StandardError; end

  def self.config
    Config.instance
  end

  def self.repo
    GitAdapter.instance
  end

  def self.docs_tree
    DocsTree.instance
  end

  class Config
    include Singleton
    
    attr_accessor :subproject

    def initialize
      @default_subproject = ENV['DEFAULT_SUBPROJECT'] || 'gear'
    end

    def documentation_path
      ENV['DOCUMENTATION_PATH'] || raise(IWriteDocsError.new("DOCUMENTATION_PATH is not provided in ENV"))
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
