require 'test_helper'

describe IWriteDocs::Differ do
  it "returns diff of specific file" do
    IWriteDocs::Differ.new('source/en/getting_started.md', "v4", '').result.wont_be_empty
  end
  it "returns empty if file not exist before" do
    IWriteDocs::Differ.new('source/en/new_file.md', 'v1', '').result.must_be_empty
  end
end
