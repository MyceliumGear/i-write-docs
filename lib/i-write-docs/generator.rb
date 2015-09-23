require 'fileutils'

module IWriteDocs
  class Generator

    def self.build_docs
      self.new.create_html_structure
    end

    def self.build_readme
      self.new.create_readme
    end

    def initialize
      @docs_tree  = IWriteDocs.docs_tree.tree
      path        = @docs_tree.root.content[:root_path]
      @build_path = "#{path}/#{IWriteDocs.config.build_folder}"
      create_build_folder
    end

    def create_readme
      content = generate_toc
      File.open("#{@build_path}/README.md", "w") do |f|
        f.write(content)
        @docs_tree.each do |node|
          next if node.is_root? || node.has_children?
          source = IWriteDocs.repo.get_file_content(node.content[:source_path] +".md")
          content = IWriteDocs::DocFilter.filter(source)
          f.write(content +"\n\n")
        end
      end
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
      source = IWriteDocs.repo.get_file_content(node.content[:source_path] +".md")
      html = IWriteDocs::MarkdownRender.parse_to_html(source)
      File.open(node_build_path +".html", 'w') { |f| f.write(html) }
    end
    
    def generate_toc
      result = "# Table of contents #\n\n"
      result << build_md_tree(@docs_tree.root)
      result << "\n\n"
    end

  private

    def parentage_path_for(node)
      par_arr = node.parentage.map{ |el| el.name unless el.is_root? }.compact.reverse
      result = ""
      result += "/"+ par_arr.join("/") unless par_arr.empty?
      result += "/"+ node.name 
    end

    def create_build_folder
      FileUtils.remove_dir @build_path if Dir.exist? @build_path
      FileUtils.mkdir_p @build_path
    end

    def build_md_tree(node, level: 0, res: '')
      unless node.is_root?
        res << (' ' * level * 2)
        res << "* "
        res << node.content[:title]
        res << "\n"
      end
      node.children { |child| build_md_tree(child, level: level+1, res: res) }
      res
    end

  end
end
