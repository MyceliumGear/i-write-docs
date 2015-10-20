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

    def file_path_for_version(file_path, current_version, target_version)
      current_oid = get_oid_for_version(current_version)
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
        old_file_path = delta.old_file[:path]
        new_file_path = delta.new_file[:path]

        if old_file_path == file_path
          return old_file_path if old_file_path == new_file_path
          return new_file_path
        end
      end
    end

   def entry_changed?(commit, path)
     parent = commit.parents[0]
     entry = commit.tree[path]
     Rails.logger.info "Entry: #{commit.tree.path("source").inspect}"

     # if at a root commit, consider it changed if we have this file;
     # i.e. if we added it in the initial commit
     if not parent
       return entry != nil
     end

     parent_entry = parent.tree[path]

     # does exist in either, no change
     if not entry and not parent_entry
       false
     # only in one of them, change
     elsif not entry or not parent_entry then
       true
     # otherwise it's changed if their ids arent' the same
     else
       entry[:oid] != parent_entry[:oid]
     end
   end
   
  end
end
