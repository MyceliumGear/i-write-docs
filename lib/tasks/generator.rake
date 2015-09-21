require 'optparse'
require './lib/i-write-docs'

desc "Generate documentation from source."
namespace :generate do |args| 
  desc "HTML version with treee structure."
  task :html do
    define_options(args)
    IWriteDocs::Generator.build_docs
    puts "Docuemntation generated in folder: #{IWriteDocs.config.documentation_path}/#{IWriteDocs.config.build_folder}"
    exit 0
  end
  
  desc "Consolidated Markdown Readme file."
  task :readme do
    define_options(args)
    IWriteDocs::Generator.build_readme
    puts "Readme generated in folder: #{IWriteDocs.config.documentation_path}/#{IWriteDocs.config.build_folder}"
    exit 0
  end

  def define_options(args)
    opts = TaskOptions.new(args)
    IWriteDocs.config.subproject = opts.subproject
    IWriteDocs.config.git_tag = opts.tag
  rescue IWriteDocs::IWriteDocsError => e
    puts "Error: #{e.message}"
    exit 0
  end
end

class TaskOptions
  attr_reader :subproject, :tag

  def initialize(args)
    parse_args(args)
  end

  def parse_args(args)
    OptionParser.new(args) do |opts|
      opts.banner = "Usage: rake generate:{html|readme} [options]"
      opts.on("-s", "--subproject {subproject}", "Subproject which you want to render", String) do |s| 
        @subproject = s
      end
      opts.on("-t", "--tag {tag}", "Git tag of commit, which render (default: master)", String) do |t|
        @tag = t
      end
    end.parse!
  end

end
