module IWriteDocs
  class MarkdownRender < Redcarpet::Render::HTML
    
    def self.parse_to_html(source)
      md = self.new
      rc = Redcarpet::Markdown.new(md, highlight: true, fenced_code_blocks: true, with_toc_data: true)
      rc.render(source)
    end

    def self.parse_from_md_file(file_path)
      source = File.open(file_path).read
      md = self.new
      rc = Redcarpet::Markdown.new(md, highlight: true, fenced_code_blocks: true, with_toc_data: true)
      rc.render(source)
    end

    def block_code(code, language = "")
      String.new.tap do |s|
        s << Pygments.highlight(code, :lexer => language)
      end
    rescue
      "<div class='highlight'><pre>#{code}</pre></div>"
    end

    def preprocess(full_doc)
      IWriteDocs::DocFilter.filter(full_doc)
    end

  end
end
