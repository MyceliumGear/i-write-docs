require 'test_helper'

describe IWriteDocs::GitAdapter do

  let(:repo_path) { TEST_REP_PATH }

  before(:all) { @repo = IWriteDocs::GitAdapter.new(repo_path) }

  it "gets file from git repository" do
    @repo.get_file_content("for_tests.yml").must_equal "New version"
  end

  it "get file for specific git tag" do
    @repo.get_file_content("for_tests.yml", "v2.0.1").must_equal "Old version"
  end
  
end
