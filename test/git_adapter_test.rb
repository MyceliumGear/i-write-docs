require 'test_helper'

describe IWriteDocs::GitAdapter do

  let(:repo_path) { ENV['DOCUMENTATION_PATH'] }

  before(:all) { @repo = IWriteDocs.repo }

  it "gets file from git repository" do
    @repo.get_file_content("for_tests.yml").must_equal "New version"
  end

  it "get file for specific git tag" do
    @repo.get_file_content("for_tests.yml", "v2.0.1").must_equal "Old version"
  end

  it "return list of tags in repository" do
    @repo.tags.keys.must_equal ["v1", "v2", "v2.0.1"]
  end

  it "create new instance on each request to repo" do
    @repo.wont_equal IWriteDocs.repo
  end

end
