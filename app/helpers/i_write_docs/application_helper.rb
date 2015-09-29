module IWriteDocs
  module ApplicationHelper

    def navigation_tree
      build_tree_menu(IWriteDocs.docs_tree.tree)
    end

    def global_version_select
      res = '<select name="version">'
      res << "<option value=''>Latest</option>"
      IWriteDocs.repo.tags.keys.each do |v|
        res << "<option value='#{v}' #{'selected' if v == session[:version]}>#{v}</option>"
      end
      res << '</select>'
      res.html_safe
    end

    def previous_link_for(node)
      prev_leaf = IWriteDocs.docs_tree.previous_leaf(node)
      build_prev_next_link(prev_leaf)
    end

    def next_link_for(node)
      next_leaf = IWriteDocs.docs_tree.next_leaf(node)
      build_prev_next_link(next_leaf)
    end

    def diff_tag_links(file_path)
      res = "<div class='diffLinks'>Diff with verion: "
      IWriteDocs.repo.tags.each_key do |t|
        res << link_to(t, diff_path(file: file_path, tag: t))
      end
      res << "</div>"
      res.html_safe
    end

  private

    def build_prev_next_link(leaf)
      return "" unless leaf
      url, title = leaf.first
      link_to(title, page_path(url))
    end

    def build_tree_menu(node, res: '<ul>')
      unless node.is_root?
        res << '<li>'
        if node.has_children?
          res << '<b>'+node.content[:title]+'</b>'
        else
          res << link_to(node.content[:title], page_path(page: node.content[:url]))
        end
        res << '</li>'
      end
      node.children { |child| build_tree_menu(child, res: res << '<ul>') }
      res << '</ul>'
      res.html_safe
    end

  end
end
