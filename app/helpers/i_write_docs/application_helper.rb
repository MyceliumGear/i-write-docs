module IWriteDocs
  module ApplicationHelper

    def navigation_tree
      build_tree_menu(IWriteDocs.docs_tree.tree).html_safe
    end

    def versions
      IWriteDocs.repo.tags.keys
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
      res = "<div class='diff-links'>Diff with verion: "
      IWriteDocs.repo.tags.each_key do |t|
        res << link_to(t, diff_path(file: file_path, tag: t))
      end
      res << "</div>"
      res.html_safe
    end

    def breadcrumbs(node)
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
      link_to(title, page_path(url))
    end

    def build_tree_menu(node)
      html = "<ul #{'class=hide' unless node.is_root? || node_in_path?(node)}>"
      node.children do |child|
        next if child.is_root?
        html << "<li #{'class=active' if node_in_path?(child)}>"
        if child.has_children?
          html << "<span class='folder'>#{child.content[:title]}"
          html << "<i class='fa fa-angle-down'></i></span>"
          html << build_tree_menu(child)
        else
          html << link_to(child.content[:title], page_path(page: child.content[:url]))
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
