# coding: utf-8
module IWriteDocs
  class Differ
    attr_reader :result
    
    def initialize(file_path, target_version, current_version)
      @target_content  = IWriteDocs.repo.get_file_content(file_path, target_version).force_encoding(Encoding::UTF_8)
      @current_content = IWriteDocs.repo.get_file_content(file_path, current_version).force_encoding(Encoding::UTF_8)
      make_diff
    end

  private

    def make_diff
      prepared_diff = "```diff\n"+ Diffy::Diff.new(@target_content, @current_content).to_s(:text) +"\n```\n"
      @result = MarkdownRender.parse_to_html(prepared_diff)
    end

  end
end
