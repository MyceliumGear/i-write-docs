module IWriteDocs
  class MarkdownRender < Redcarpet::Render::HTML
    
    def self.parse_to_html(file_path)
      source = File.open(file_path).read
      md = self.new
      rc = Redcarpet::Markdown.new(md, highlight: true, fenced_code_blocks: true)
      rc.render(source)
    end

    def block_code(code, language = "ruby")
      title = nil
      code.gsub!(/\A\:\:(.*)$/) { title = $1 ; nil }
      String.new.tap do |s|
        s << "<p class='codeTitle'>#{title}</p>" if title
        s << Pygments.highlight(code, :lexer => language)
      end
    rescue
      "<div class='highlight'><pre>#{code}</pre></div>"
    end

  end
end
