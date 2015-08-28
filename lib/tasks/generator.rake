require 'optparse'
require './lib/i-write-docs'

desc "Generate documentation from source."
namespace :generate do |args| 
  desc "HTML version with treee structure."
  task :html do
    IWriteDocs.config.subproject = TaskOptions.new(args).subproject
    IWriteDocs::Generator.build_docs
    puts "Docuemntation generated in folder: #{IWriteDocs.config.documentation_path}/#{IWriteDocs.config.build_folder}"
    exit 0
  end
  
  desc "Consolidated Markdown Readme file."
  task :readme do
    IWriteDocs.config.subproject = TaskOptions.new(args).subproject
    IWriteDocs::Generator.build_readme
    puts "Readme generated in folder: #{IWriteDocs.config.documentation_path}/#{IWriteDocs.config.build_folder}"
    exit 0
  end
end

class TaskOptions
  attr_reader :options, :subproject

  def initialize(args)
    @options = {}
    parse_args(args)
    @subproject = @options[:subproject]
  end

  def parse_args(args)
    OptionParser.new(args) do |opts|
      opts.banner = "Usage: rake generate:html [options]"
      opts.on("-s", "--subproject {subproject}", "Subproject which you want to render", String) do |s| 
        @options[:subproject] = s
      end
    end.parse!
  end
  
end
