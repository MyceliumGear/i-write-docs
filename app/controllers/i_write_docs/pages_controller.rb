module IWriteDocs
  class PagesController < ApplicationController

    def show
      page = params[:doc] || 'index'
      @node = IWriteDocs.docs_tree.find_node_by_url(page)
      raise ActionController::RoutingError.new('Not found') unless @node
      @content = prepare_page_content(@node.content[:source_path], session[:version])
      render 'body', locals: { content: @content }
    end

    def diff
      file = params[:file]
      @tag = params[:tag]
      redirect_to(iwd.root_path) and return if file.to_s.empty? || @tag.to_s.empty?
      @node = IWriteDocs.docs_tree.find_node_by_url(file)
      file_path = @node.content[:source_path] +'.md'
      html_content = Differ.new(file_path, @tag, session[:version]).result.html_safe
      render 'body', locals: { content: html_content }
    end

    def version
      session[:version] = params[:version]
      redirect_to iwd.root_path
    end

  private
    
    def prepare_page_content(path, ver)
      source = IWriteDocs.repo.get_file_content(path+ '.md', ver)
      content = IWriteDocs::DocFilter.filter(source)
      IWriteDocs::MarkdownRender.parse_to_html(content).html_safe
    end

  end
end
