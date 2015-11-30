module IWriteDocs
  class PagesController < ApplicationController

    def show
      docs_tree = DocsTree.new(session[:version])
      page = params[:doc] || docs_tree.index_node_url
      @node = docs_tree.find_node_by_url(page)
      raise ActionController::RoutingError.new("Not found page: #{page}") if node_is_not_document?(@node) 
      content = prepare_page_content(@node.content[:source_path], session[:version])
      render 'body', locals: { content: content }
    end

    def diff
      file = params[:file]
      @tag = params[:tag]
      @node = DocsTree.new(session[:version]).find_node_by_url(file)
      raise ActionController::RoutingError.new("Not found page: #{file}") if node_is_not_document?(@node)
      redirect_to(iwd.page_path(doc: @node.content[:url])) and return if @tag.to_s.empty?
      file_path = @node.content[:source_path] +'.md'
      html_content = Differ.new(file_path, @tag, session[:version]).result.html_safe
      render 'body', locals: { content: html_content }
    end

    def version
      session[:version] = params[:version]
      redirect_to iwd.root_path
    end

  private

    def node_is_not_document?(node)
      node.nil? || node.has_children?
    end

    def prepare_page_content(path, ver)
      repo    = GitAdapter.new(ver)
      source  = repo.get_file_content("#{path}.md")
      content = IWriteDocs::DocFilter.filter(source)
      IWriteDocs::MarkdownRender.parse_to_html(content).html_safe
    end

  end
end
