require 'test_helper'

describe IWriteDocs::Differ do
  it "returns diff of specific file" do
    expected = "<div class='diff'><div class='del'><span class='symbol'>-</span><h1>Getting Started</h1></div><div class='ins'><span class='symbol'>+</span><h2>Getting Started</h2></div><div class='ins'><span class='symbol'>+</span></div><div class='ins'><span class='symbol'>+</span><p>Content with <em>italic</em> text</p></div><div class='ins'><span class='symbol'>+</span></div><div class='ins'><span class='symbol'>+</span><p>List:</div><div class='ins'><span class='symbol'>+</span>- one</div><div class='ins'><span class='symbol'>+</span>- two</p></div></div>"
    IWriteDocs::Differ.new('source/getting_started.md', "v1", '').result.must_equal expected
  end
end
