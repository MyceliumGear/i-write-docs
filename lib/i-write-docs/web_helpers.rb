module IWriteDocs
  module WebHelpers
    def navigation_tree
      build_tree_menu(IWriteDocs.docs_tree.tree)
    end

    def global_tags_select
      res = '<select name="tag"">'
      res << "<option value=''>Latest</option>"
      IWriteDocs.repo.tags.keys.each do |tag|
        res << "<option value='#{tag}'>#{tag}</option>"
      end
      res << '</select>'
    end

    def previous_link_for(node)
      prev_leaf = IWriteDocs.docs_tree.previous_leaf(node)
      build_prev_next_link(prev_leaf)
    end

    def next_link_for(node)
      next_leaf = IWriteDocs.docs_tree.next_leaf(node)
      build_prev_next_link(next_leaf)
    end

  private

    def build_prev_next_link(leaf)
      return "" unless leaf
      url, title = leaf.first
      "<a href='/#{url}'>#{title}</a>"
    end

    def build_tree_menu(node, res: '<ul>')
      unless node.is_root?
        res << '<li>'
        if node.has_children?
          res << '<b>'+node.content[:title]+'</b>'
        else
          res << "<a href='/#{node.content[:url]}'>#{node.content[:title]}</a>"
        end
        res << '</li>'
      end
      node.children { |child| build_tree_menu(child, res: res << '<ul>') }
      res << '</ul>'
    end
  end
end
