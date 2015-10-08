require 'test_helper'

describe IWriteDocs::Differ do
  it "returns diff of specific file" do
    IWriteDocs::Differ.new('source/getting_started.md', "v1", '').result.wont_be_empty
  end
end
