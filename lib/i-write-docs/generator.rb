require 'fileutils'

module IWriteDocs
  class Generator

    def self.build_docs
      self.new(IWriteDocs.config.docs_tree)
    end

    def initialize(docs_tree)
      @docs_tree = docs_tree
      path = @docs_tree.root.content[:root_path]
      @build_path = "#{path}/#{IWriteDocs.config.qbuild_folder}"
      create_build_folder
    end

    def create_build_folder
      FileUtils.remove_dir @build_path if Dir.exist? @build_path
      FileUtils.mkdir_p @build_path
      create_html_structure
    end

    def create_html_structure
      @docs_tree.each do |node|
        next if node.is_root?
        node_build_path = @build_path + parentage_path_for(node)
        FileUtils.mkdir_p(node_build_path) and next if node.has_children?
        render_html_file(node, node_build_path)
      end
    end

    def render_html_file(node, node_build_path)
      source_path = node.content[:source_path] +".md"
      html = IWriteDocs::MarkdownRender.parse_to_html(source_path)
      File.open(node_build_path +".html", 'w') { |f| f.write(html) }
    end

  private

    def parentage_path_for(node)
      par_arr = node.parentage.map{ |el| el.name unless el.is_root? }.compact.reverse
      result = ""
      result += "/"+ par_arr.join("/") unless par_arr.empty?
      result += "/"+ node.name 
    end
  end
end
