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
      session[:tag] = params[:tag]
      redirect to('/')
    end
    
    # TODO: create checks and answers on bad input
    get '/diff' do
      file = params[:file]
      tag = params[:tag]
      redirect to("/") if file.to_s.empty? || tag.to_s.empty?
      node = IWriteDocs.docs_tree.find_node_by_url(file)
      file_path = node.content[:source_path] +'.md'
      logger.info file_path
      diff = IWriteDocs.repo.get_diff_for(file_path, tag)
      html_content = GitDiffToHtml.new.composite_to_html(diff)
      # TODO: show that there is no diff
      erb html_content
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
