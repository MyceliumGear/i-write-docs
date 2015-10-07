module IWriteDocs
  class Differ
    attr_reader :result
    
    def initialize(file_path, target_version, current_version)
      @result = "<div class='diff'>"
      target_blob = IWriteDocs.repo.get_file_content(file_path, target_version)
      current_blob = IWriteDocs.repo.get_file_content(file_path, current_version)
      prepare_content(target_blob, current_blob)
      make_diff
    end

    private

    def prepare_content(target_blob, current_blob)
      @target_content = MarkdownRender.parse_to_html(target_blob)
      @current_content = MarkdownRender.parse_to_html(current_blob)
    end

    def make_diff
      Diffy::Diff.new(@target_content, @current_content).each do |line|
        cleaned = clean_line(line)
        @result << case line
          when /^\+/
            "<div class='ins'><span class='symbol'>+</span>#{cleaned}</div>"
          when /^-/
            "<div class='del'><span class='symbol'>-</span>#{cleaned}</div>"
          else
            cleaned
          end
      end
      @result << "</div>"
    end

    def clean_line(line)
      line.sub(/^(.)/, '').chomp
    end
  end
end
