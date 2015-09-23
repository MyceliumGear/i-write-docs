require 'erb'
require 'sinatra/base'
require 'sinatra/reloader'

require_relative '../i-write-docs'
require_relative 'web_helpers'

module IWriteDocs
  class Web < Sinatra::Base

    configure :development do
      register Sinatra::Reloader
      also_reload 'web_helpers'
    end

    configure :production, :development do
      enable :logging
    end

    enable :sessions

    set :root, File.expand_path(File.dirname(__FILE__) + "/../../web")
    set :public_folder, proc { "#{root}/assets" }
    set :views, proc { "#{root}/views" }

    helpers WebHelpers

    get '/' do
      redirect to('/index')
    end
    
    post '/versions' do
      IWriteDocs.repo.set_tag(params[:tag])
      sessions[:tag] = params[:tag]
      redirect to('/')
    end

    get '/*' do |page|
      ENV['DOCUMENTATION_PATH'] = '../docs-dev'
      @node = IWriteDocs.docs_tree.find_node_by_url(page)
      halt "404" unless @node
      @content = prepare_page_content(@node.content[:source_path])
      erb :page
    end

    def prepare_page_content(path)
      source = IWriteDocs.repo.get_file_content(path+ '.md')
      content = IWriteDocs::DocFilter.filter(source)
      IWriteDocs::MarkdownRender.parse_to_html(content)
    end

    run! if app_file == $0
  end
end
