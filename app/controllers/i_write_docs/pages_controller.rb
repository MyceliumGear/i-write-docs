module IWriteDocs
  class PagesController < ApplicationController

    def show
      page = params[:page] || 'index'
      @node = IWriteDocs.docs_tree.find_node_by_url(page)
      raise ActionController::RoutingError.new('Not found') unless @node
      @content = prepare_page_content(@node.content[:source_path], session[:version])
    end

    def diff
      redirect_to(root_path)
      # file = params[:file]
      # tag = params[:tag]
      # redirect_to(root_path) if file.to_s.empty? || tag.to_s.empty?
      # @node = IWriteDocs.docs_tree.find_node_by_url(file)
      # file_path = @node.content[:source_path] +'.md'
      # diff = IWriteDocs.repo.get_diff_for(file_path, tag, session[:version])
      # @html_content = GitDiffToHtml.new.composite_to_html(diff)
    end

    def version
      session[:version] = params[:version]
      redirect_to root_path
    end

  private
    
    def prepare_page_content(path, ver)
      source = IWriteDocs.repo.get_file_content(path+ '.md', ver)
      content = IWriteDocs::DocFilter.filter(source)
      IWriteDocs::MarkdownRender.parse_to_html(content).html_safe
    end

  end
end
