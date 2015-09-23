require 'test_helper'

describe IWriteDocs::GitAdapter do

  let(:repo_path) { TEST_REP_PATH }

  before(:all) { @repo = IWriteDocs::GitAdapter.instance }

  it "gets file from git repository" do
    @repo.set_tag('')
    @repo.get_file_content("for_tests.yml").must_equal "New version"
  end

  it "get file for specific git tag" do
    @repo.set_tag("v2.0.1")
    @repo.get_file_content("for_tests.yml").must_equal "Old version"
  end

  it "return list of tags in repository" do
    @repo.tags.keys.must_equal ["v1", "v2", "v2.0.1"]
  end
  
end
