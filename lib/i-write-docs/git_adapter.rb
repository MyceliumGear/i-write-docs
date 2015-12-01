module IWriteDocs
  class GitAdapter

    attr_accessor :version
    attr_reader :tags

    def initialize(version = "")
      @version = version
      @repo = Rugged::Repository.discover(IWriteDocs.config.documentation_path)
      branch = "refs/heads/#{IWriteDocs.config.working_branch}"
      @master_oid = @repo.ref(branch).target.oid
      build_tags_hash
    end

    def get_file_content(file_path)
      oid = get_oid_for_version(@version)
      @repo.blob_at(oid, file_path).content
    end

    def file_path_for_version(file_path, target_version)
      current_oid = get_oid_for_version(@version)
      target_oid  = get_oid_for_version(target_version)
      file_path_on_target_commit(file_path, current_oid, target_oid)
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

    def file_path_on_target_commit(file_path, current_oid, target_oid)
      target_commit = @repo.lookup(target_oid)
      current_commit = @repo.lookup(current_oid)
      diff = current_commit.diff(target_commit)
      diff.find_similar!(:renames => true)
      
      diff.each_delta do |delta|
        cur_file_path = delta.old_file[:path]
        target_file_path = delta.new_file[:path]
        return target_file_path if delta.status == :renamed && cur_file_path == file_path
        raise NotExistFile if delta.status == :deleted && cur_file_path == file_path
      end
      file_path
    end
   
  end
end
