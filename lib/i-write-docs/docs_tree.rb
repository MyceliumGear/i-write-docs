module IWriteDocs
  class DocsTree

    CONFIG_FILE = 'config.yml'
    ROOT_TITLE = 'Documentation'
    attr_reader :docs_path, :tree, :leafs

    def initialize(ver = "")
      @docs_path   = IWriteDocs.config.documentation_path
      @locale      = IWriteDocs.config.locale
      @source_path = "#{IWriteDocs.config.source_folder}/#{@locale}"
      build_docs_tree(ver)
      build_leafs
    end

    def index_node_url
      @tree.root.first_child.content[:url]
    end

    def find_node_by_url(url)
      @tree.breadth_each { |node| return node if node.content[:url] == url }
      nil
    end

    # @return [Hash] of the form {"url" => "title"}, where url and title get from node
    def previous_leaf(node)
      index = get_index_in_leafs(node)
      return nil if index == 0
      @leafs.at(index-1)
    end

    # @return [Hash] of the form {"url" => "title"}, where url and title get from node
    def next_leaf(node)
      index = get_index_in_leafs(node)
      return nil if index == @leafs.size-1
      @leafs.at(index+1)
    end

  private

    def get_index_in_leafs(node)
      @leafs.index { |leaf| leaf.has_key? node.content[:url] }
    end

    def build_docs_tree(ver = "")
      config_file = GitAdapter.new(ver).get_file_content(CONFIG_FILE)
      docs_config = Psych.load(config_file)
      @tree = Tree::TreeNode.new("ROOT", {root_path: @docs_path,
                                          source_path: @source_path,
                                          url: "",
                                          title: ROOT_TITLE})
      traverse(docs_config[@locale], @tree) do |node, parent|
        name = node.is_a?(Hash) ? node.keys.first : node
        leaf = node.is_a?(Tree::TreeNode) ? node : Tree::TreeNode.new(name, prepare_node_content(node, parent))
        parent << leaf
      end
    end

    def build_leafs
      @leafs = []
      @tree.each_leaf do |node| 
        @leafs << {node.content[:url] => node.content[:title]}
      end
      @leafs.freeze
    end

    def traverse(obj, parent, &blk)
      is_folder = ->(obj) { obj.is_a?(Hash) && obj.values.first.is_a?(Array) }
      case obj
      when is_folder
        obj.each do |k,v|
          sub_root = Tree::TreeNode.new(k, prepare_node_content(k, parent))
          blk.call(sub_root, parent)
          traverse(v, sub_root ,&blk)
        end
      when Array
        obj.each { |v| traverse(v, parent, &blk) }
      else
        blk.call(obj, parent)
      end
    end

    def prepare_node_content(node, parent)
      case node
      when String
        {source_path: '', url: '', title: node}
      else
        {
          source_path:  "#{@source_path}/#{node.values.first}",
          url: node.values.first.gsub(/\.(.*)$/, ''),
          title: node.keys.first
        }
      end
    end

  end
end
