module IWriteDocs
  module ApplicationHelper

    def iwd_navigation_tree
      build_tree_menu(IWriteDocs.docs_tree.tree).html_safe
    end

    def iwd_versions
      IWriteDocs.repo.tags.keys
    end

    def iwd_previous_link_for(node)
      prev_leaf = IWriteDocs.docs_tree.previous_leaf(node)
      build_prev_next_link(prev_leaf)
    end

    def iwd_next_link_for(node)
      next_leaf = IWriteDocs.docs_tree.next_leaf(node)
      build_prev_next_link(next_leaf)
    end

    def iwd_diff_tag_links(file_path)
      res = "<select class='diff-links'>Diff with verion: "
      res << "option>---</option>"
      IWriteDocs.repo.tags.each_key do |t|
        res << "<option value='#{t}'>#{t}</option>"
      end
      res << "</select>"
      res.html_safe
    end

    def iwd_breadcrumbs(node)
      res = ""
      parentage = node.parentage.reverse
      parentage.each do |n|
        res << n.content[:title]
        res << "<span class='breadcrumb-arrow'>></span> " 
      end
      res << node.content[:title]
      res.html_safe
    end

  private

    def build_prev_next_link(leaf)
      return "" unless leaf
      url, title = leaf.first
      link_to(title, iwd.page_path(url))
    end

    def build_tree_menu(node)
      html = "<ul>"
      node.children do |child|
        next if child.is_root?
        html << "<li #{'class=active' if node_in_path?(child)}>"
        if child.has_children?
          html << "<span class='folder'>#{child.content[:title]}"
          html << "<i class='fa fa-angle-down'></i></span>"
          html << build_tree_menu(child)
        else
          html << link_to(child.content[:title], iwd.page_path(doc: child.content[:url]))
        end
        html << '</li>'
      end
      html << '</ul>'
    end

    def node_in_path?(current_node)
      return true if current_node == @node
      @node.parentage.any? { |n| n == current_node }
    end

  end
end
