module IWriteDocs
  class GitAdapter

    attr_reader :tags
      
    def initialize
      @repo = Rugged::Repository.discover(IWriteDocs.config.documentation_path)
      @master_oid = @repo.ref('refs/heads/master').target.oid
      build_tags_hash
    end

    def get_file_content(file_path, version = '')
      oid = get_oid_for_version(version)
      @repo.blob_at(oid, file_path).content
    end

  private

    def file_from_fs(file_path)
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
