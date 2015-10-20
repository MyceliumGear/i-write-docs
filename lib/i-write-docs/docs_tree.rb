module IWriteDocs
  class DocsTree

    attr_reader :docs_path, :tree, :leafs
    
    def initialize(ver = "")
      @docs_path = IWriteDocs.config.documentation_path
      build_docs_tree(ver)
      build_leafs
    end

    def index_node_url
      @tree.root.first_child.content[:url]
    end

    def find_node_by_url(url)
      node_path = ''
      url.split("/").map { |name| node_path << "['#{name}']" }
      eval("@tree#{node_path}")
    rescue NoMethodError
      return nil
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

    def prepare_node_content(node, parent)
      title = node.gsub('_', ' ').capitalize
      source_path = "#{parent.content[:source_path]}/#{node}"
      {
        source_path: source_path,
        url: source_path.split("/").drop(1).join("/"),
        title: title
      }
    end

    def get_index_in_leafs(node)
      @leafs.index { |leaf| leaf.has_key? node.content[:url] }
    end

    def build_docs_tree(ver = "")
      repo = GitAdapter.new(ver)
      config = repo.get_file_content('config.yml')
      docs_config = Psych.load(config)
      @tree = Tree::TreeNode.new("ROOT", {root_path: @docs_path,
                                          source_path: "#{IWriteDocs.config.source_folder}",
                                          url: "",
                                          title: "Documentation"})
      traverse(docs_config, @tree) do |node, parent|
        leaf = node.is_a?(Tree::TreeNode) ? node : Tree::TreeNode.new(node.to_s, prepare_node_content(node, parent))
        parent << leaf
      end
     # rescue Errno::ENOENT
    #   p "YAML config not found"
    # rescue Psych::SyntaxError
    #   p "YAML config file contains invalid syntax"
    end
    
    def build_leafs
      @leafs = []
      @tree.each_leaf do |node| 
        @leafs << {node.content[:url] => node.content[:title]}
      end
      @leafs.freeze
    end

    def traverse(obj, parent, &blk)
      case obj
      when Hash
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
  end
end
