require 'singleton'
require 'yaml'
require 'tree'
require 'redcarpet'
require 'pygments'
require 'rugged'
require 'haml'
require 'rails'
require 'diffy'

require_relative 'i-write-docs/docs_tree'
require_relative 'i-write-docs/markdown_render'
require_relative 'i-write-docs/generator'
require_relative 'i-write-docs/doc_filter'
require_relative 'i-write-docs/git_adapter'
require_relative 'i-write-docs/differ'
require_relative 'i-write-docs/engine'

module IWriteDocs

  class IWriteDocsError < StandardError; end
  class NotExistFile < StandardError; end

  def self.config
    Config.instance
  end

  class Config
    include Singleton
    
    attr_accessor :subproject, :locale

    def initialize
      @default_subproject = ENV['DEFAULT_SUBPROJECT'] || 'admin_app'
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

    def locale
      @locale || 'en'
    end

    def working_branch
      ENV['DOCS_WORKING_BRANCH'] || 'master'
    end
  end
  
end
