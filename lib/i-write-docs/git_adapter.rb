module IWriteDocs
  class GitAdapter
    include Singleton

    attr_reader :repo, :tags, :master_oid

    def initialize
      @repo = Rugged::Repository.discover(IWriteDocs.config.documentation_path)
      @master_oid = @repo.ref('refs/heads/master').target.oid
      build_tags_hash
    end

    def get_file_content(file_path, tag = nil)
      oid = not_set?(tag) ? @master_oid : @tags[tag]
      @repo.blob_at(oid, file_path).content
    end

  private

    def not_set?(el)
      el.nil? || el.empty?
    end
  
    def build_tags_hash
      @tags = {}
      @repo.tags.each { |t| @tags.merge!({t.name => t.target.oid}) }
    end
 
  end
end
