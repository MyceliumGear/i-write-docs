module IWriteDocs
  class Differ
    attr_reader :result
    
    def initialize(file_path, target_version, current_version)
      @cur_repo = GitAdapter.new(current_version)
      @target_repo = GitAdapter.new(target_version)
      target_file_path = @cur_repo.file_path_for_version(file_path, target_version)
      fetch_contents_for(file_path, target_file_path)
    rescue NotExistFile
      empty_diff
    end

    def fetch_contents_for(file_path, target_file_path)
      current_content = @cur_repo.get_file_content(file_path).force_encoding(Encoding::UTF_8)
      target_content  = @target_repo.get_file_content(target_file_path).force_encoding(Encoding::UTF_8)
      make_diff(current_content, target_content)
    end

  private

    def make_diff(current_content, target_content)
      diff = Diffy::Diff.new(target_content, current_content).to_s(:text)
      return "<p class='noDiff'>#{I18n.t('i-write-docs.no-diff')}</p>" if diff.empty?
      prepared_diff = "```diff\n" + remove_special_chars(diff) + "\n```\n"
      @result = MarkdownRender.parse_to_html(prepared_diff)
    end

    def remove_special_chars(content)
      content.gsub(/```/, "'''")
    end

    def empty_diff
      @result = ''
    end

  end
end
