require 'test_helper'

describe IWriteDocs::DocsTree do

  before do
    ENV["DOCUMENTATION_PATH"] = TEST_REP_PATH
  end
  let(:docs_tree) { IWriteDocs::DocsTree.new.tree }

  it "build tree from valid config" do
    docs_tree.must_be_instance_of Tree::TreeNode
  end

  it "have for each node specific content" do
    content = {:source_path=>"#{TEST_REP_PATH}/source/index", :title=>"Index"}
    docs_tree.first_child.content.must_equal content
  end

  it "have correct tree structure" do
    docs_tree["setup"].has_children?.must_equal true
  end

end

