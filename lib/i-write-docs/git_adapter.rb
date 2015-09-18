module IWriteDocs
  class GitAdapter

    attr_reader :repo, :tags, :master_oid
    
    def initialize(repo_path)
      @repo = Rugged::Repository.discover(repo_path)
      @master_oid = @repo.ref('refs/heads/master').target.oid
      build_tags_hash
    end

    def get_file_content(file_path, tag = nil)
      oid = tag.nil? ? @master_oid : @tags[tag]
      # @repo.index.each { |el| p el }
      @repo.blob_at(oid, file_path).content
    end
    
  private
  
    def build_tags_hash
      @tags = {}
      @repo.tags.each { |t| @tags.merge!({t.name => t.target.oid}) }
    end
 
  end
end
