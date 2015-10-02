module IWriteDocs
  class GitAdapter

    attr_reader :tags
      
    def initialize
      @repo = Rugged::Repository.discover(IWriteDocs.config.documentation_path)
      @master_oid = @repo.ref('refs/heads/master').target.oid
      build_tags_hash
    end

    def get_file_content(file_path, version = '')
      return file_from_fs(file_path) if ENV['IWD_WRITER_MODE']
      oid = get_oid_for_version(version)
      @repo.blob_at(oid, file_path).content
    end

    def get_diff_for(file_path, tag, current_tag = nil)
      # target_blob = @repo.blob_at(@tags[tag], file_path)
      # current_tag_oid = @tags[current_tag] || @master_oid
      # current_blob = @repo.blob_at(current_tag_oid, file_path)
      # HTMLDiff::Diff.new(current_blob, target_blob).insline_html
    end

  private

    def file_from_fs(file_path)
      path = ENV['DOCUMENTATION_PATH'] + file_path
      File.open(path).read
    end
  
    def tag_exist?(tag)
      !!@tags[tag]
    end

    def build_tags_hash
      @tags = {}
      @repo.tags.each { |t| @tags.merge!({t.name => t.target.oid}) }
    end

    def get_oid_for_version(ver)
      oid = @tags[ver]
      return @master_oid if oid.nil?
      oid
    end
 
  end
end
