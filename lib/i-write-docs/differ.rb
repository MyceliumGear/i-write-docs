# coding: utf-8
module IWriteDocs
  class Differ
    attr_reader :result
    
    def initialize(file_path, target_version, current_version)
      @target_content  = IWriteDocs.repo.get_file_content(file_path, target_version).force_encoding(Encoding::UTF_8)
      @current_content = IWriteDocs.repo.get_file_content(file_path, current_version).force_encoding(Encoding::UTF_8)
      @result = make_diff
    end

  private

    def make_diff
      diff = Diffy::Diff.new(@target_content, @current_content).to_s(:text)
      return "<p class='noDiff'>#{I18n.t('i-write-docs.no-diff')}</p>" if diff.empty?
      prepared_diff = "```diff\n" + remove_special_chars(diff) + "\n```\n"
      MarkdownRender.parse_to_html(prepared_diff)
    end

    def remove_special_chars(content)
      content.gsub(/```/, "'''")
    end

  end
end
